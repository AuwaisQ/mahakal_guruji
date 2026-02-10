// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mahakal/features/notification/domain/models/notification_model.dart';
// import 'package:mahakal/features/splash/controllers/splash_controller.dart';
// import 'package:mahakal/utill/custom_themes.dart';
// import 'package:mahakal/utill/dimensions.dart';
// import 'package:mahakal/common/basewidget/custom_image_widget.dart';
// import 'package:provider/provider.dart';
// import '../../../main.dart';
// import '../../astrology/component/astrodetailspage.dart';
// import '../../donation/view/home_page/static_view/all_home_page/static_details/Donationpage.dart';
// import '../../event_booking/view/event_details.dart';
// import '../../mandir_darshan/mandirdetails_mandir.dart';
// import '../../offline_pooja/view/offline_details.dart';
// import '../../pooja_booking/view/anushthandetail.dart';
// import '../../pooja_booking/view/chadhavadetails.dart';
// import '../../pooja_booking/view/silvertabbar.dart';
// import '../../pooja_booking/view/vipdetails.dart';
// import '../../product_details/screens/product_details_screen.dart';
// import '../../tour_and_travells/view/TourDetails.dart';
//
// class NotificationDialogWidget extends StatelessWidget {
//   final NotificationItem notificationModel;
//   const NotificationDialogWidget({super.key, required this.notificationModel});
//
//   @override
//   Widget build(BuildContext context) {
//     final splashController =
//     Provider.of<SplashController>(context, listen: false);
//
//     final Color amber = Colors.amber.shade600;
//
//     void handleNotificationNavigation(NotificationItem notificationModel) {
//       final notificationType = notificationModel.type ?? '';
//       final serviceId = notificationModel.serviceId ?? '';
//       final slug = notificationModel.slug ?? '';
//
//       print("🔔 Notification Type: $notificationType");
//       print("🆔 Service ID: $serviceId");
//       print("🔗 Slug: $slug");
//
//       switch (notificationType) {
//         case 'puja':
//           {
//             print("👉 Opening Pooja Page...");
//             final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//             final nextDate =
//             dateFormat.format(DateTime.now().add(const Duration(days: 7)));
//
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => SliversExample(
//                     slugName: slug,
//                     nextDatePooja: nextDate,
//                   ),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'vip':
//           {
//             print("👉 Opening VIP Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) =>
//                       VipDetails(idNumber: slug, typePooja: 'vip'),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'anushthan':
//           {
//             print("👉 Opening Anushthan Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => AnushthanDetails(
//                     idNumber: slug,
//                     typePooja: 'anushthan',
//                   ),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'chadhava':
//           {
//             print("👉 Opening Chadhava Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => ChadhavaDetailView(idNumber: serviceId),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'offlinepuja':
//           {
//             print("👉 Opening Offline Pooja Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => OfflinePoojaDetails(slugName: slug),
//                 ),
//               );
//             });
//           }
//           break;
//          //counselling
//         case 'consultancy':
//           {
//             print("👉 Opening Consultancy Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) =>
//                       AstroDetailsView(productId: serviceId, isProduct: false),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'event':
//           {
//             print("👉 Opening Event Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => EventDeatils(eventId: slug),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'darshan':
//           {
//             print("👉 Opening Darshan Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => MandirDetailView(detailId: serviceId),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'tour':
//           {
//             print("👉 Opening Tour Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => TourDetails(productId: slug),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'donation':
//           {
//             print("👉 Opening Donation Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => Donationpage(myId: serviceId),
//                 ),
//               );
//             });
//           }
//           break;
//
//         case 'product':
//           {
//             print("👉 Opening Product Page...");
//             Future.delayed(const Duration(milliseconds: 500), () {
//               Navigator.of(Get.context!).push(
//                 CupertinoPageRoute(
//                   builder: (context) => ProductDetails(
//                     productId: serviceId,
//                     slug: slug,
//                   ),
//                 ),
//               );
//             });
//           }
//           break;
//
//         default:
//           {
//             print("⚠️ Unknown notification type: $notificationType");
//           }
//       }
//     }
//
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(30),
//         topRight: Radius.circular(30),
//       ),
//       child: Container(
//         color: Colors.white,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             const SizedBox(height: 10),
//
//             // Drag handle
//             Container(
//               width: 50,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // Image (if available)
//             if (notificationModel.image != "null")
//               Container(
//                 margin: const EdgeInsets.symmetric(
//                     horizontal: Dimensions.paddingSizeLarge),
//                 height: MediaQuery.of(context).size.width * 0.5,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: CustomImageWidget(
//                   image:
//                   '${splashController.baseUrls!.notificationImageUrl}/${notificationModel.image}',
//                   fit: BoxFit.fill,
//                   height: MediaQuery.of(context).size.width * 0.5,
//                   width: double.infinity,
//                 ),
//               ),
//
//             const SizedBox(height: 10),
//
//             // Title
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: Dimensions.paddingSizeLarge),
//               child: Text(
//                 notificationModel.title ?? '',
//                 textAlign: TextAlign.center,
//                 style: titilliumSemiBold.copyWith(
//                   color: amber,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 5),
//
//             // Description
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Text(
//                 notificationModel.description ?? '',
//                 textAlign: TextAlign.center,
//                 style: titilliumRegular.copyWith(
//                   color: Colors.black87,
//                   fontSize: Dimensions.fontSizeDefault,
//                   height: 1.5,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 5),
//
//             // "Book Now" Button
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: amber,
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     elevation: 6,
//                     shadowColor: amber.withOpacity(0.4),
//                   ),
//                   onPressed: () {
//
//                     // 👉 Add your booking navigation logic here
//                     // Example:
//                     // Navigator.of(context).pushNamed('/epooja');
//                     handleNotificationNavigation(notificationModel);
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     "Book Now",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/features/notification/domain/models/notification_model.dart';
import 'package:mahakal/features/splash/controllers/splash_controller.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../product_details/screens/product_details_screen.dart';


class NotificationDialogWidget extends StatefulWidget {
  final NotificationItem notificationModel;
  const NotificationDialogWidget({super.key, required this.notificationModel});

  @override
  State<NotificationDialogWidget> createState() =>
      _NotificationDialogWidgetState();
}

class _NotificationDialogWidgetState extends State<NotificationDialogWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final splashController =
    Provider.of<SplashController>(context, listen: false);
    final Color amber = Colors.amber.shade600;

    void handleNotificationNavigation(NotificationItem notificationModel) {
      final notificationType = notificationModel.type ?? '';
      final serviceId = notificationModel.serviceId ?? '';
      final slug = notificationModel.slug ?? '';

      switch (notificationType) {
        case 'product':
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(Get.context!).push(
              CupertinoPageRoute(
                  builder: (context) => ProductDetails(
                    productId: serviceId,
                    slug: slug,
                  )),
            );
          });
          break;
      }
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 10),
              if (widget.notificationModel.image != "null")
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge),
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomImageWidget(
                    image:
                    '${splashController.baseUrls!.notificationImageUrl}/${widget.notificationModel.image}',
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: double.infinity,
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  widget.notificationModel.title ?? '',
                  textAlign: TextAlign.center,
                  style: titilliumSemiBold.copyWith(
                    color: amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    Text(
                      widget.notificationModel.description ?? '',
                      maxLines: isExpanded ? null : 3,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: titilliumRegular.copyWith(
                        color: Colors.black87,
                        fontSize: Dimensions.fontSizeDefault,
                        height: 1.5,
                      ),
                    ),
                    if ((widget.notificationModel.description ?? '').length > 100)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? "View Less" : "View More",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: amber,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                      shadowColor: amber.withOpacity(0.4),
                    ),
                    onPressed: () {
                      handleNotificationNavigation(widget.notificationModel);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Book Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
