import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:mahakal/call_service/call_service.dart';
import 'package:mahakal/features/astrotalk/screen/astro_bottombar.dart';
import 'package:mahakal/features/astrotalk/screen/astro_chatscreen.dart';
import 'package:mahakal/features/astrotalk/screen/astro_home.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/push_notification/models/notification_body.dart';
import 'package:mahakal/theme/controllers/theme_controller.dart';
import 'package:mahakal/theme/dark_theme.dart';
import 'package:mahakal/theme/light_theme.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'features/home/screens/home_screens.dart';
import 'features/maha_bhandar/screen/maha_bhandar_screen.dart';
import 'features/product_details/screens/product_details_screen.dart';
import 'features/shop/screens/shop_screen.dart';
import 'features/splash/screens/splash_screen.dart';
import 'helper/custom_delegate.dart';
import 'localization/app_localization.dart';
import 'localization/controllers/localization_controller.dart';

class MyApp extends StatefulWidget {
  final NotificationBody? body;
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.body, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late ScrollController scrollController;
  String? currentUuid;
  static _MyAppState? instances;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    checkSipRegistered();
    instances = this;

    WidgetsBinding.instance.addObserver(this);

    // ✅ Background check for active calls
    checkAndNavigationCallingPage();

    // ✅ Listen for CallKit events here
    FlutterCallkitIncoming.onEvent.listen((event) async {
      switch (event!.event) {
        case Event.actionCallAccept:
          print('call accepted Body-${event.body}');
          final rawId = event.body?['extra']?['callRequestId'];
          print('CallKit raw callRequestId: $rawId (type=${rawId.runtimeType})');
          final id = rawId?.toString().trim() ?? '';
          print('CallKit normalized callRequestId: "${id}"');
          if (id.isEmpty) {
            print('call accept: empty callRequestId, skipping status API');
            break;
          }
          // Mark request id early to avoid duplicate processing across widgets
          final callProvider = Provider.of<CallServiceProvider>(context, listen: false);
          callProvider.setRequestId(id);

          if (event.body['extra']['type'] == 'audio' ||
              event.body['extra']['type'] == 'video') {
            callStatusApi(id, 'connect');
          }
          checkAndNavigationCallingPage();
          break;

        case Event.actionCallDecline:
          debugPrint('❌ Call Declined');
          final rawIdDecline = event.body?['extra']?['callRequestId'];
          print('CallKit raw callRequestId (decline): $rawIdDecline (type=${rawIdDecline.runtimeType})');
          final idDecline = rawIdDecline?.toString().trim() ?? '';
          print('CallKit normalized callRequestId (decline): "${idDecline}"');
          if (idDecline.isEmpty) {
            debugPrint('Call decline: missing callRequestId, skipping status API');
          } else {
            final callProvider = Provider.of<CallServiceProvider>(context, listen: false);
            callProvider.setRequestId(idDecline);
            callStatusApi(idDecline, 'reject');
          }
          currentUuid = null;
          break;

        case Event.actionCallEnded:
          debugPrint('📞 Call Ended');
          currentUuid = null;

          // Close call screen if open
          if (widget.navigatorKey.currentState?.canPop() ?? false) {
            widget.navigatorKey.currentState?.pop();
          }
          break;

        default:
          break;
      }
    });
  }

  void checkSipRegistered()async{
    final callProvider = Provider.of<CallServiceProvider>(context, listen: false);
    print("callProvider.registerState: ${callProvider.registerState}");
    if (callProvider.registerState == null) {
      await callProvider.getSIPData();
    }
  }

  /// Ensure SIP is registered before proceeding. Attempts to connect up to
  /// [maxConnectAttempts] times; waits [waitMillis] between polls and polls
  /// [attemptsPerConnect] times per connect attempt. Returns true if
  /// registration succeeded.
  Future<bool> ensureSipRegistered({
    int maxConnectAttempts = 3,
    int waitMillis = 500,
    int attemptsPerConnect = 10,
  }) async {
    final callProvider = Provider.of<CallServiceProvider>(context, listen: false);
    for (int connectAttempt = 0; connectAttempt < maxConnectAttempts; connectAttempt++) {
      if (callProvider.registerState != null) return true;
      // Trigger connect (reads credentials from SharedPreferences)
      await callProvider.getSIPData();

      for (int i = 0; i < attemptsPerConnect; i++) {
        if (!mounted) return false;
        if (callProvider.registerState != null) return true;
        await Future.delayed(Duration(milliseconds: waitMillis));
      }
    }
    return callProvider.registerState != null;
  }

  Future<void> callStatusApi(String id, String status) async {
    String apiUrl = '${AppConstants.expressURI}/api/call-requests/$id/$status';
    print(' My App Call URL -->$apiUrl');
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Call Update --->${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Call $status:-$responseBody');
    } else {
      print('Failed to make call request. Status code: ${response.statusCode}');
    }
  }

  Future<void> checkAndNavigationCallingPage() async {
    Call? call;
    var calls = await FlutterCallkitIncoming.activeCalls();
    debugPrint('calls...$calls');
    final callProvider = Provider.of<CallServiceProvider>(context, listen: false);
    final bool sipRegistered = await ensureSipRegistered();

    if (calls is List && calls.isNotEmpty) {
      final active = calls[0];
      currentUuid = active['id'];
      
      // Safely convert to Map<String, dynamic>
        final Map<String, dynamic>? eventBody =
          active is Map ? Map<String, dynamic>.from(active) : null;

          if (eventBody != null && eventBody['extra'] != null){
            String id = eventBody['extra']['callRequestId'];

            // Skip if provider already handled this request id
            final existingRequestId = callProvider.requestId;
            if (existingRequestId != null && existingRequestId == id) {
              debugPrint('Call $id already handled by provider; skipping.');
            } else if(active['isAccepted'] == true){
            callProvider.setRequestId(id);
            callStatusApi(id, 'connect');
          }
              }

      String? callType;
      String? userName = 'John Doe';
      String? userImageUrl = '';
      bool isCaller = false;
      // Get userId from SharedPreferences instead of Provider (which might not be loaded yet)
      String userId = '-1';

      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('user_id') ?? '-1';

      print('User ID--->: $userId');
      print('Call Register State --> ${callProvider.registerState?.state ?? callProvider.registerState}');
      if (eventBody != null && eventBody['extra'] != null) {
        final extra = eventBody['extra'];
        final from = extra['from']?.toString() ?? 'background';

        if (extra is Map && extra['type'] == 'chat' && from != 'background' ) {
          FlutterCallkitIncoming.endAllCalls();
          // Navigate to chat screen
            Navigator.of(Get.context!).push(MaterialPageRoute(
            builder: (_) => ChatScreenView(
              astrologerId: extra['userId']?.toString() ?? '',
              astrologerName: eventBody['handle'] ?? '',
              astrologerImage: eventBody['avatar'] ?? '',
              chargePerMin: int.tryParse(extra['charges']?.toString() ?? '0') ?? 0,
              userId: userId ?? '0',
              isConnect: true,
            ),
          ));
          print('Chat call navigation skipped on Splash Screen.');
        } else if (extra is Map &&
            (extra['type'] == 'audio' || extra['type'] == 'video')) {
          // For audio/video we require SIP registration
          if (!sipRegistered || callProvider.registerState == null) {
            print('SIP not registered after retries — skipping call navigation.');
            return;
          }
          callType = extra['type'];

          print('Sending call charges: ${extra['charges']}/min');
          
          Provider.of<CallServiceProvider>(context, listen: false)
              .setUserName(eventBody['handle'] ?? 'John Doe');
          Provider.of<CallServiceProvider>(context, listen: false)
              .setUserImage(eventBody['avatar'] ?? '');
          Provider.of<CallServiceProvider>(context, listen: false)
              .setRequestId(eventBody['extra']['callRequestId'] ?? '-1');
          Provider.of<CallServiceProvider>(context, listen: false)
              .setCharges(eventBody['extra']['charges'] ?? '0');
          Provider.of<CallServiceProvider>(context, listen: false)
              .setAstrologerId(extra['userId']?.toString() ?? '');
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('📱 Lifecycle: $state');
    if (state == AppLifecycleState.resumed) {
      checkAndNavigationCallingPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // deepLinkService.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generate locales more efficiently
    final locales = AppConstants.languages
        .map((language) => Locale(language.languageCode!, language.countryCode))
        .toList();

    return MaterialApp(
      title: AppConstants.appName,
      navigatorKey: widget.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeController>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationController>(context).locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackLocalizationDelegate(),
      ],
      builder: (context, child) {
        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      supportedLocales: locales,
      routes: {
        '/splash': (context) => SplashScreen(
              body: widget.body,
              navigatorKey: widget.navigatorKey,
            ),
            
        '/shop-view-details': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final slug = args?['shopId']?.toString() ?? '';

          print(' My slug: $slug');

          if (slug.isEmpty) {
            return const Scaffold(
              body: Center(child: Text(' Invalid or missing shop ID')),
            );
          }

          return FutureBuilder<Response>(
            future: Dio().get('${AppConstants.baseUrl}/api/v1/shopView/$slug'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                print(' API Error: ${snapshot.error}');
                return const Scaffold(
                  body: Center(child: Text(' Error loading shop data')),
                );
              }

              if (!snapshot.hasData || snapshot.data?.data == null) {
                print('⚠ No data returned from API');
                return const Scaffold(
                  body: Center(child: Text('No shop data found')),
                );
              }

              final data = snapshot.data!.data;
              final sellers = data['sellers'] as List?;
              if (sellers == null || sellers.isEmpty) {
                print('⚠ No sellers in response');
                return const Scaffold(
                  body: Center(child: Text('No seller found')),
                );
              }

              final seller = sellers.first;
              final shop = seller['shop'];

              if (shop == null) {
                print('⚠ Shop data is null inside seller');
                return const Scaffold(
                  body: Center(child: Text('No shop information available')),
                );
              }

              print(' My Shop Data: $shop');

              return TopSellerProductScreen(
                sellerId: shop['seller_id'] ?? 0,
                temporaryClose: shop['temporary_close'],
                vacationStatus: shop['vacation_status'],
                vacationStartDate: shop['vacation_start_date'],
                vacationEndDate: shop['vacation_end_date'],
                name: shop['name'] ?? '',
                banner: shop['banner'] ?? '',
                image: shop['image'] ?? '',
                fromMore: false,
              );
            },
          );
        },
      },
      home: SplashScreen(body: widget.body, navigatorKey: widget.navigatorKey),
    );
  }
}