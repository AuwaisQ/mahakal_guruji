import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:http/http.dart' as http;
import 'package:mahakal/call_service/call_service.dart';
import 'package:mahakal/common/basewidget/bouncy_widget.dart';
import 'package:mahakal/features/astrotalk/screen/astro_chatscreen.dart';
import 'package:mahakal/features/order_details/screens/order_details_screen.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/features/splash/controllers/splash_controller.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/push_notification/models/notification_body.dart';
import 'package:mahakal/features/auth/controllers/auth_controller.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:mahakal/utill/color_resources.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/common/basewidget/no_internet_screen_widget.dart';
import 'package:mahakal/features/chat/screens/inbox_screen.dart';
import 'package:mahakal/features/maintenance/maintenance_screen.dart';
import 'package:mahakal/features/notification/screens/notification_screen.dart';
import 'package:mahakal/features/onboarding/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

import '../../../deeplinking/deeplink_service.dart';
import '../../../push_notification/notification_helper.dart';
import '../../all_pandit/Pandit_Bottom_bar.dart';
import '../../auth/screens/auth_screen.dart';
import '../../update/screen/update_screen.dart';
import '../domain/models/config_model.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  final GlobalKey<NavigatorState> navigatorKey;
  SplashScreen({super.key, this.body, required this.navigatorKey});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  final ScrollController scrollController = ScrollController();
  late DeepLinkService deepLinkService;
  String? currentUuid;

  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: isNotConnected ? Colors.red : Colors.green,
            duration: Duration(seconds: isNotConnected ? 6000 : 3),
            content: Text(
              isNotConnected
                  ? getTranslated('no_connection', context)!
                  : getTranslated('connected', context)!,
              textAlign: TextAlign.center,
            ),
          ),
        );
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();
    bool isLoggedIn = Provider.of<AuthController>(
      Get.context!,
      listen: false,
    ).isLoggedIn();
    print("LoggedIn-$isLoggedIn");
    _onConnectivityChanged.cancel();
  }

  checkDeepLinkAndNavigate() {
    print('<--Splash Deep Link-->');
    Navigator.of(Get.context!).pushReplacement(
      CupertinoPageRoute(
        builder: (BuildContext context) => const PanditBottomBar(pageIndex: 0, panditId: 3, sellerId: 188, astroImage: '',),
      ),
    );
    deepLinkService = DeepLinkService(widget.navigatorKey);
    deepLinkService.init();
  }

  void _route() {
    Provider.of<SplashController>(
      context,
      listen: false,
    ).initConfig(context).then((bool isSuccess) {
      if (isSuccess) {
        String? minimumVersion = "0";
        UserAppVersionControl? appVersion = Provider.of<SplashController>(
          Get.context!,
          listen: false,
        ).configModel?.userAppVersionControl;
        if (Platform.isAndroid) {
          minimumVersion = appVersion?.forAndroid?.version ?? '0';
        } else if (Platform.isIOS) {
          minimumVersion = appVersion?.forIos?.version ?? '0';
        }
        Provider.of<SplashController>(
          Get.context!,
          listen: false,
        ).initSharedPrefData();
        Timer(const Duration(seconds: 1), () {
          if (compareVersions(minimumVersion!, AppConstants.appVersion) == 1) {
            Navigator.of(Get.context!).pushReplacement(
              CupertinoPageRoute(builder: (_) => const UpdateScreen()),
            );
          } else if (Provider.of<SplashController>(
            Get.context!,
            listen: false,
          ).configModel!.maintenanceMode!) {
            Navigator.of(Get.context!).pushReplacement(
              CupertinoPageRoute(builder: (_) => const MaintenanceScreen()),
            );
          } else if (Provider.of<AuthController>(
            Get.context!,
            listen: false,
          ).isLoggedIn()) {
            Provider.of<AuthController>(
              Get.context!,
              listen: false,
            ).updateToken(Get.context!);
            if (widget.body != null) {
              print(
                'Splash Screen Notification Type----> ${json.encode(widget.body!)}',
              );
              //NotificationHelper.handleNotificationNavigation(widget.body!);
            } else {
              checkDeepLinkAndNavigate();

              if (widget.body != null) {
                //NotificationHelper.handleNotificationNavigation(widget.body!);
              }
            }
          } else if (Provider.of<SplashController>(
            Get.context!,
            listen: false,
          ).showIntro()!) {
            Navigator.of(Get.context!).pushReplacement(
              CupertinoPageRoute(
                builder: (BuildContext context) => OnBoardingScreen(
                  indicatorColor: ColorResources.grey,
                  selectedIndicatorColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          } else {
            if (Provider.of<AuthController>(
                      context,
                      listen: false,
                    ).getGuestToken() !=
                    null &&
                Provider.of<AuthController>(
                      context,
                      listen: false,
                    ).getGuestToken() !=
                    '1') {
              // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const AuthScreen(),
                ),
              );
            } else {
              Provider.of<AuthController>(
                context,
                listen: false,
              ).getGuestIdUrl();
              // Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (_) => const AuthScreen()),
                (route) => false,
              );
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      key: _globalKey,
      body: Provider.of<SplashController>(context).hasConnection
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BouncyWidget(
                    duration: const Duration(milliseconds: 2000),
                    lift: 50,
                    ratio: 0.5,
                    pause: 0.25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        Images.appLogo,
                        height: 200,
                        width: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                  Image.asset(
                    Images.splashScreenImage,
                    height: 50,
                    width: 150.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            )
          : NoInternetOrDataScreenWidget(
              isNoInternet: true,
              child: SplashScreen(navigatorKey: widget.navigatorKey),
            ),
    );
  }

  int compareVersions(String version1, String version2) {
    List<String> v1Components = version1.split('.');
    List<String> v2Components = version2.split('.');
    for (int i = 0; i < v1Components.length; i++) {
      int v1Part = int.parse(v1Components[i]);
      int v2Part = int.parse(v2Components[i]);
      if (v1Part > v2Part) {
        return 1;
      } else if (v1Part < v2Part) {
        return -1;
      }
    }
    return 0;
  }
}
