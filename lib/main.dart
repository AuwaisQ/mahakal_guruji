import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mahakal/call_service/call_service.dart';
import 'package:mahakal/my_app.dart';
import 'package:mahakal/provider_registry.dart';
import 'package:mahakal/push_notification/models/notification_body.dart';
import 'package:mahakal/push_notification/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'di_container.dart' as di;
import 'firebase_options.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey< NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FlutterDownloader
  await FlutterDownloader.initialize(
    debug: true, // Set to true for debug mode
  );

  // Set callbacks for FlutterDownloader
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  MediaKit.ensureInitialized();
  await di.init();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FlutterCallkitIncoming.requestFullIntentPermission();
  HttpOverrides.global = MyHttpOverrides();
   NotificationBody? launchBody;
  //
  // try {
  //   final RemoteMessage? initialMessage =
  //   await FirebaseMessaging.instance.getInitialMessage();
  //
  //   if (initialMessage != null) {
  //     launchBody = NotificationHelper.convertNotification(initialMessage.data);
  //     print('🔔 App opened from terminated state via notification');
  //   }
  // } catch (e) {
  //   print('❌ Error reading initial tap: $e');
  // }

  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(
        body: launchBody,
        navigatorKey: navigatorKey,
      ),
    ),
  );

  
  //
  // Future.microtask(() async {
  //   await initializeNotifications();
  // });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Future<void> initializeNotifications() async {
//   try {
//     // Ask for permissions
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//
//     // Local Notification Setup
//     await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
//
//     // Background handler
//     FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
//
//     print('✅ Notifications initialized');
//   } catch (e) {
//     print('❌ Notification init failed: $e');
//   }
// }

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}

