// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:mahakal/features/address/controllers/address_controller.dart';
// import 'package:mahakal/features/astrotalk/screen/astro_chatscreen.dart';
// import 'package:mahakal/features/auth/controllers/auth_controller.dart';
// import 'package:mahakal/features/auth/screens/auth_screen.dart';
// import 'package:mahakal/features/chat/screens/chat_screen.dart';
// import 'package:mahakal/features/chat/screens/inbox_screen.dart';
// import 'package:mahakal/features/custom_bottom_bar/bottomBar.dart';
// import 'package:mahakal/features/explore/exploreScreen.dart';
// import 'package:mahakal/features/home/screens/home_screens.dart';
// import 'package:mahakal/features/notification/screens/notification_screen.dart';
// import 'package:mahakal/features/order_details/screens/order_details_screen.dart';
// import 'package:mahakal/features/wallet/screens/wallet_screen.dart';
// import 'package:mahakal/main.dart';
// import 'package:mahakal/push_notification/models/notification_body.dart';
// import 'package:mahakal/utill/app_constants.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import '../features/astrology/component/astrodetailspage.dart';
// import '../features/donation/view/home_page/dynamic_view/dynamic_details/Detailspage.dart';
// import '../features/donation/view/home_page/static_view/all_home_page/static_details/Donationpage.dart';
// import '../features/event_booking/view/event_details.dart';
// import '../features/mandir_darshan/mandirdetails_mandir.dart';
// import '../features/offline_pooja/view/offline_details.dart';
// import '../features/pooja_booking/view/anushthandetail.dart';
// import '../features/pooja_booking/view/chadhavadetails.dart';
// import '../features/pooja_booking/view/silvertabbar.dart';
// import '../features/pooja_booking/view/vipdetails.dart';
// import '../features/product_details/screens/product_details_screen.dart';
// import '../features/tour_and_travells/view/TourDetails.dart';
//
// class NotificationHelper {
//
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize =
//         const AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = const DarwinInitializationSettings();
//     var initializationsSettings =
//         InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//     flutterLocalNotificationsPlugin.initialize(initializationsSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse load) async {
//       final ScrollController scrollController = ScrollController();
//       try {
//         NotificationBody payload;
//         if (load.payload!.isNotEmpty) {
//
//           NotificationBody? payload;
//           if (load.payload != null && load.payload!.isNotEmpty) {
//             payload = NotificationBody.fromJson(jsonDecode(load.payload!));
//           }
//
//           if (payload != null) {
//             NotificationHelper.handleNotificationNavigation(payload);
//           }
//
//         }
//       } catch (_) {}
//       return;
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//
//       if(ChatState.activeAstrologerId == message.data['astrologer_id'].toString()){
//         return;
//       }
//
//       if (message.data['type'] == 'audio' ||
//           message.data['type'] == 'video' ||
//           message.data['type'] == 'chat') {
//         // Show incoming call screen
//         NotificationHelper.showCallkitIncoming(message.data, 'foreground');
//         return; // don’t show local notification for calls
//       }
//
//       if (message.data['type'] == 'block') {
//         Provider.of<AuthController>(Get.context!, listen: false)
//             .clearSharedData();
//         Provider.of<AddressController>(Get.context!, listen: false)
//             .getAddressList();
//         Navigator.of(Get.context!).pushAndRemoveUntil(
//             CupertinoPageRoute(builder: (context) => const AuthScreen()),
//             (route) => false);
//       }
//       NotificationHelper.showNotification(
//           message, flutterLocalNotificationsPlugin, false);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if(ChatState.activeAstrologerId == message.data['astrologer_id'].toString()){
//         return;
//       }
//       if (message.data['type'] == 'audio' ||
//           message.data['type'] == 'video' ||
//           message.data['type'] == 'chat') {
//         NotificationHelper.showCallkitIncoming(message.data, 'foreground');
//
//         return;
//       }
//       final ScrollController scrollController = ScrollController();
//       if (kDebugMode) {
//         print('onOpenApp: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}');
//         print('Message Data: ${message.data}');
//       }
//
//       final notificationType = message.data['notification_type'];
//       print("Notification Type: ${message.data}");
//
//       try {
//         if (message.data.isNotEmpty) {
//           NotificationBody notificationBody = convertNotification(message.data);
//
//           log('Notification Body Working=> ${notificationBody.type}');
//
//           NotificationHelper.handleNotificationNavigation(notificationBody);
//
//         }
//       } catch (_) {}
//
//     });
//   }
//
//   static Future<void> showNotification(RemoteMessage message,
//       FlutterLocalNotificationsPlugin fln, bool data) async {
//     if (!Platform.isIOS) {
//       String? title;
//       String? body;
//       String? orderID;
//       String? image;
//       NotificationBody notificationBody = convertNotification(message.data);
//       if (data) {
//         title = message.data['title'];
//         body = message.data['body'];
//         orderID = message.data['order_id'];
//         image = (message.data['image'] != null &&
//                 message.data['image'].isNotEmpty)
//             ? message.data['image'].startsWith('http')
//                 ? message.data['image']
//                 : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}'
//             : null;
//       } else {
//         title = message.notification!.title ?? message.data['title'];
//         body = message.notification!.body ?? message.data['body'];
//         orderID = message.notification!.titleLocKey;
//         if (Platform.isAndroid) {
//           image = (message.notification!.android!.imageUrl != null &&
//                   message.notification!.android!.imageUrl!.isNotEmpty)
//               ? message.notification!.android!.imageUrl!.startsWith('http')
//                   ? message.notification!.android!.imageUrl
//                   : '${AppConstants.baseUrl}/storage/app/public/notification/${message.notification!.android!.imageUrl}'
//               : null;
//         } else if (Platform.isIOS) {
//           image = (message.notification!.apple!.imageUrl != null &&
//                   message.notification!.apple!.imageUrl!.isNotEmpty)
//               ? message.notification!.apple!.imageUrl!.startsWith('http')
//                   ? message.notification!.apple!.imageUrl
//                   : '${AppConstants.baseUrl}/storage/app/public/notification/${message.notification!.apple!.imageUrl}'
//               : null;
//         }
//       }
//
//       if (image != null && image.isNotEmpty) {
//         try {
//           await showBigPictureNotificationHiddenLargeIcon(
//               title, body, orderID, notificationBody, image, fln);
//         } catch (e) {
//           await showBigTextNotification(
//               title, body!, orderID, notificationBody, fln);
//         }
//       } else {
//         await showBigTextNotification(
//             title, body!, orderID, notificationBody, fln);
//       }
//     }
//   }
//
//   static Future<void> showTextNotification(
//       String title,
//       String body,
//       String orderID,
//       NotificationBody? notificationBody,
//       FlutterLocalNotificationsPlugin fln) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'Mahakal.com',
//       'Mahakal.com',
//       playSound: true,
//       importance: Importance.max,
//       priority: Priority.max,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics,
//         payload: notificationBody != null
//             ? jsonEncode(notificationBody.toJson())
//             : null);
//   }
//
//   static Future<void> showBigTextNotification(
//       String? title,
//       String body,
//       String? orderID,
//       NotificationBody? notificationBody,
//       FlutterLocalNotificationsPlugin fln) async {
//     print('Notification Body ----> $body');
//     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//       body,
//       htmlFormatBigText: true,
//       contentTitle: title,
//       htmlFormatContentTitle: true,
//     );
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'Mahakal.com',
//       'Mahakal.com',
//       importance: Importance.max,
//       styleInformation: bigTextStyleInformation,
//       priority: Priority.max,
//       playSound: true,
//       // sound: const RawResourceAndroidNotificationSound('notification'),
//     );
//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics,
//         payload: notificationBody != null
//             ? jsonEncode(notificationBody.toJson())
//             : null);
//   }
//
//   static Future<void> showBigPictureNotificationHiddenLargeIcon(
//       String? title,
//       String? body,
//       String? orderID,
//       NotificationBody? notificationBody,
//       String image,
//       FlutterLocalNotificationsPlugin fln) async {
//     final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
//     final String bigPicturePath =
//         await _downloadAndSaveFile(image, 'bigPicture');
//     final BigPictureStyleInformation bigPictureStyleInformation =
//         BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       hideExpandedLargeIcon: true,
//       contentTitle: title,
//       htmlFormatContentTitle: true,
//       summaryText: body,
//       htmlFormatSummaryText: true,
//     );
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'Mahakal.com',
//       'Mahakal.com',
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//       priority: Priority.max,
//       playSound: true,
//       styleInformation: bigPictureStyleInformation,
//       importance: Importance.max,
//       sound: const RawResourceAndroidNotificationSound('notification'),
//     );
//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics,
//         payload: notificationBody != null
//             ? jsonEncode(notificationBody.toJson())
//             : null);
//   }
//
//   static Future<String> _downloadAndSaveFile(
//       String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
//
//   static NotificationBody convertNotification(Map<String, dynamic> data) {
//     log("Convert Method Call: $data");
//
//     final type = data['notification_type'] ?? data['type'] ?? 'unknown';
//
//     switch (type) {
//       case 'notification':
//         return NotificationBody(type: 'notification');
//
//       case 'order':
//         return NotificationBody(
//           type: 'order',
//           orderId: int.tryParse("${data['order_id']}"),
//         );
//
//       case 'wallet':
//         return NotificationBody(type: 'wallet');
//
//       case 'block':
//         return NotificationBody(type: 'block');
//
//       case 'chadhava':
//       case 'puja':
//       case 'vip':
//       case 'anushthan':
//       case 'offlinepuja':
//       case 'consultancy':
//       case 'event':
//       case 'darshan':
//       case 'tour': //
//       case 'donation':
//       case 'product':
//
//         return NotificationBody(
//           type: type,
//           service_id: data['service_id']?.toString(),
//           slug: data['slug']?.toString()
//         );
//
//       default:
//         return NotificationBody(type: 'chatting');
//     }
//   }
//
//   static void handleNotificationNavigation(NotificationBody body) {
//     final context = Get.context!;
//     final ScrollController scrollController = ScrollController();
//
//     print('Notification Body Type => ${body.type}');
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => ExploreScreen(scrollController: scrollController)),
//           (route) => false,  // Remove all previous routes (Splash)
//     );
//
//     switch (body.type) {
//
//     // ------------------ SIMPLE SCREENS ------------------
//
//
//
//       case 'chatting':
//         Navigator.of(Get.context!).pushReplacement(
//       CupertinoPageRoute(
//         builder: (BuildContext context) => const BottomBar(pageIndex: 0),
//       ),
//     );
//         break;
//
//
//       case 'order':
//         Navigator.of(context).pushReplacement(
//           CupertinoPageRoute(
//             builder: (_) => OrderDetailsScreen(
//               orderId: body.orderId,
//               isNotification: true,
//             ),
//           ),
//         );
//         break;
//
//       case 'wallet':
//         Navigator.of(context).pushReplacement(
//           CupertinoPageRoute(builder: (_) => const WalletScreen()),
//         );
//         break;
//
//       case 'notification':
//         Navigator.of(context).pushReplacement(
//           CupertinoPageRoute(
//             builder: (_) => const NotificationScreen(fromNotification: true),
//           ),
//         );
//         break;
//
//
//     // ------------------ SLUG BASED ------------------
//       case 'puja':
//         {
//           print("Pooja Open");
//
//           final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//           final nextDate =
//           dateFormat.format(DateTime.now().add(const Duration(days: 7)));
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => SliversExample(
//                   slugName: body.slug!,   // SLUG
//                   // nextDatePooja: nextDate,
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'vip':
//         {
//           print("VIP Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => VipDetails(
//                   idNumber: body.slug!,   // SLUG
//                   typePooja: 'vip',
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'anushthan':
//         {
//           print("anushthan Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => AnushthanDetails(
//                   idNumber: body.slug!,   // SLUG
//                   typePooja: 'anushthan',
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//
//     // ------------------ ID BASED ------------------
//       case 'chadhava':
//         {
//           print("chadhava Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => ChadhavaDetailView(
//                   idNumber: body.service_id!, // ID
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'offlinepuja':
//         {
//           print("offlinepuja Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => OfflinePoojaDetails(
//                   slugName: body.slug!,    // SLUG
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'consultancy':
//         {
//           print("consultancy Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => AstroDetailsView(
//                   productId: body.service_id!,   // ID
//                   isProduct: false,
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'event':
//         {
//           print("event Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => EventDeatils(
//                   eventId: body.slug!,   // SLUG
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'darshan':
//         {
//           print("darshan Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => MandirDetailView(
//                   detailId: body.service_id!,  // ID
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'tour':
//         {
//           print("tour Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => TourDetails(
//                   productId: body.slug!,   // SLUG
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'donation':
//         {
//           print("donation Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) =>
//                     Donationpage(myId: body.service_id!),   // ID
//               ),
//             );
//           });
//         }
//         break;
//
//       case 'product':
//         {
//           print("product Open");
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).push(
//               CupertinoPageRoute(
//                 builder: (_) => ProductDetails(
//                   productId: body.service_id! ?? 0,   // ID
//                   slug: body.slug ?? '',              // SLUG
//                 ),
//               ),
//             );
//           });
//         }
//         break;
//
//     // ------------------ DEFAULT ------------------
//       default:
//         Navigator.of(context).pushReplacement(
//           CupertinoPageRoute(
//             builder: (_) => InboxScreen(
//               isBackButtonExist: true,
//               scrollController: scrollController,
//             ),
//           ),
//         );
//     }
//   }
//
//   static Future<void> showCallkitIncoming(Map<String, dynamic> data, String from) async {
//     print("Call Data ----> :${data}");
//     var id = 0;
//     switch (data['type']) {
//       case 'audio':
//         id = 0;
//         break;
//       case 'video':
//         id = 1;
//         break;
//       default:
//         id = 0;
//     }
//     final params = CallKitParams.fromJson({
//       'id': data['ID'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       'nameCaller': data['callerName'] ?? 'Unknown Caller',
//       'appName': 'Mahakal.com',
//       'avatar': "${AppConstants.astrologersImages}${data['profile_image']}" ??
//           'https://i.pravatar.cc/100',
//       'handle': data['callerName'] ?? 'Caller',
//       'type': id,
//       'duration': 30000,
//       'textAccept': 'Accept',
//       'textDecline': 'Decline',
//       'extra': <String, dynamic>{
//         'userId': data['callerId'] ?? '0',
//         'type': data['type'],
//         'callRequestId': data['callRequestId'],
//         'charges' : data['charges'] ?? '0',
//         'from': from,
//       },
//       'android': <String, dynamic>{
//         'isCustomNotification': false,
//         'isShowLogo': true,
//         'ringtonePath': 'system_ringtone_default',
//         'backgroundColor': '#0955fa',
//         'actionColor': '#4CAF50'
//       },
//       'ios': <String, dynamic>{
//         'iconName': 'CallKitLogo',
//         'handleType': 'generic',
//         'supportsVideo': true,
//         'maximumCallGroups': 2,
//         'maximumCallsPerCallGroup': 1,
//         'audioSessionMode': 'default',
//         'audioSessionActive': true,
//         'supportsDTMF': true,
//         'supportsHolding': true,
//         'supportsGrouping': false,
//         'supportsUngrouping': false,
//         'ringtonePath': 'system_ringtone_default'
//       }
//     });
//
//     await FlutterCallkitIncoming.showCallkitIncoming(params);
//   }
// }
//
// @pragma('vm:entry-point')
// Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
//   // print('onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}');
//   print('New Data: ${message.data['type'] ?? message.data['service_id']}');
//   if (message.data['type'] == 'audio' ||
//       message.data['type'] == 'video' ||
//       message.data['type'] == 'chat') {
//     await NotificationHelper.showCallkitIncoming(message.data, 'background');
//     return;
//   }
// }
//
