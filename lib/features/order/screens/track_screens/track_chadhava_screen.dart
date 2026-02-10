import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mahakal/features/order/screens/track_screens/track_donation_details.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../main.dart';
import '../../../profile/controllers/profile_contrroller.dart';
import '../../model/finaltrack_model.dart';

class ChadhavaTrackingPage extends StatefulWidget {
  String? userID;

  ChadhavaTrackingPage({super.key, required this.userID});

  @override
  State<ChadhavaTrackingPage> createState() => _ChadhavaTrackingPageState();
}

class _ChadhavaTrackingPageState extends State<ChadhavaTrackingPage> {
  FinalTrackDetailModel? trackModelData;

  Future<void> getTrackData(String userId) async {
    final String url =
        AppConstants.baseUrl + AppConstants.fetchChadhavaTrackUrl + userId;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          print("APi response chadhava ${response.body}");
          // var res = jsonEncode(response.body);

          trackModelData = finalTrackDetailModelFromJson(response.body);
        });
      } else {
        setState(() {
          print("APi response fail ${response.body}");
        });
      }
    } catch (e) {
      setState(() {
        // errorMessage = 'Failed to load data: $e';
        // isLoading = false;
      });
    }
  }

  String formatStringTime(String timeString) {
    // Parse time using DateFormat
    DateTime dateTime = DateFormat("HH:mm:ss").parse(timeString);

    // Format time to 12-hour AM/PM format
    return DateFormat('hh:mm a').format(dateTime);
  }

  String formatStringDate(String dateString) {
    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object into the desired string format
    return DateFormat('hh:mm a, dd MMM yyyy').format(dateTime);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'cancel':
        return Colors.red;
      case 'rejected':
        return Colors.red;
      case 'confirmed':
        return Colors.green;
      default:
        return Colors.amber; // Default color for unknown statuses
    }
  }

  String convertDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Invalid date"; // Or any default message you prefer
    }

    try {
      final dateTime = DateFormat('yyyy-MM-dd').parse(date);
      final formattedDate = DateFormat("dd-MMMM-yyyy").format(dateTime);
      return formattedDate;
    } catch (e) {
      return "Invalid format"; // Handle parsing errors
    }
  }

  Future<void> _launchURL(String liveStreamUrl) async {
    if (liveStreamUrl.isNotEmpty) {
      final Uri url = Uri.parse(liveStreamUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $liveStreamUrl");
      }
    } else {
      debugPrint("URL is empty.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrackData("${widget.userID}");
  }

  @override
  Widget build(BuildContext context) {
    return trackModelData?.order?.orderId == null
        ? Container(
            color: Colors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            )))
        : RefreshIndicator(
            color: Colors.amber,
            onRefresh: () async {
              getTrackData("${widget.userID}");
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey.shade50,
                title: Column(
                  children: [
                    Text.rich(TextSpan(children: [
                      const TextSpan(
                          text: "Order -",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      TextSpan(
                          text: " #${trackModelData?.order?.orderId}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Text.rich(TextSpan(children: [
                      const TextSpan(
                          text: " Your Order is - ",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      TextSpan(
                          text: "${trackModelData?.order?.orderStatus}",
                          style: TextStyle(
                              color: getStatusColor(
                                  "${trackModelData?.order?.orderStatus}"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(convertDate("${trackModelData?.order?.bookingDate}"),
                        style: const TextStyle(
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black)),
                  ],
                ),
                centerTitle: true,
                toolbarHeight: 100,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //     width: double.infinity,
                      //     padding: const EdgeInsets.all(7),
                      //     decoration: BoxDecoration(
                      //         color: Theme.of(context).primaryColor.withOpacity(0.15),
                      //         borderRadius: BorderRadius.circular(10)
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Container(height:15,width: 4,decoration: BoxDecoration(
                      //             color: Colors.amber,
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),),
                      //         const SizedBox(width: 5,),
                      //         Text("Chadhava Tracking Status",style: TextStyle(fontSize: Dimensions.fontSizeLarge,fontWeight: FontWeight.bold),),
                      //       ],
                      //     )),
                      // const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: trackModelData?.order?.status ==
                                          "Rejected"
                                      ? 40
                                      : 45,
                                  width: trackModelData?.order?.status ==
                                          "Rejected"
                                      ? 40
                                      : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData?.order?.status ==
                                          "Rejected"
                                      ? Opacity(
                                          opacity: 0.5,
                                          child: Image.asset(
                                              "assets/animated/pooja_conformed_animation.gif"))
                                      : Image.asset(
                                          "assets/animated/pooja_conformed_animation.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Chadhava Confirmed',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.status == "Rejected"
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.alarm,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                formatStringDate(
                                                    "${trackModelData?.order?.createdAt}"),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData?.order?.status ==
                                              "Rejected"
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height:
                                      trackModelData?.order?.scheduleCreated ==
                                              null
                                          ? 40
                                          : 45,
                                  width:
                                      trackModelData?.order?.scheduleCreated ==
                                              null
                                          ? 40
                                          : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData
                                              ?.order?.scheduleCreated ==
                                          null
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              "assets/animated/shadule_puja_gif.gif"))
                                      : Image.asset(
                                          "assets/animated/shadule_puja_gif.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Chadhava Time',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.scheduleTime == null
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.alarm,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                formatStringTime(
                                                    "${trackModelData?.order?.scheduleTime}"),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.scheduleCreated ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    height: trackModelData
                                                ?.order?.liveCreatedStream ==
                                            null
                                        ? 40
                                        : 45,
                                    width: trackModelData
                                                ?.order?.liveCreatedStream ==
                                            null
                                        ? 40
                                        : 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: trackModelData
                                                ?.order?.liveCreatedStream ==
                                            null
                                        ? Opacity(
                                            opacity: 0.3,
                                            child: Image.asset(
                                                "assets/animated/live_streem_icon.gif"))
                                        : Image.asset(
                                            "assets/animated/live_streem_icon.gif")),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Live Stream',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.liveCreatedStream ==
                                            null
                                        ? const SizedBox.shrink()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.alarm,
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    formatStringDate(
                                                        "${trackModelData?.order?.liveCreatedStream}"),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          FullScreenVideoPlayer(
                                                        videoUrl:
                                                            '${trackModelData?.order?.liveStream}',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.video_label,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Play Video",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.liveCreatedStream ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: trackModelData
                                              ?.order?.videoCreatedSharing ==
                                          null
                                      ? 40
                                      : 45,
                                  width: trackModelData
                                              ?.order?.videoCreatedSharing ==
                                          null
                                      ? 40
                                      : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData
                                              ?.order?.videoCreatedSharing ==
                                          null
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              "assets/animated/prepairing_animation.gif"))
                                      : Image.asset(
                                          "assets/animated/prepairing_animation.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Recorded Video',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData
                                                ?.order?.videoCreatedSharing ==
                                            null
                                        ? const SizedBox.shrink()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.alarm,
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    formatStringDate(
                                                        "${trackModelData?.order?.videoCreatedSharing}"),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          FullScreenVideoPlayer(
                                                        videoUrl:
                                                            '${trackModelData?.order?.poojaVideo}',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .slow_motion_video_sharp,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Play Pooja Video",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: (){
                                              //     _launchURL("${trackModelData?.order?.poojaVideo}");
                                              //   },
                                              //   child: Row(
                                              //     children: [
                                              //       Icon(Icons.slow_motion_video_sharp,color: Colors.amber,size: 18,),
                                              //       SizedBox(width: 5,),
                                              //       // Text("${trackModelData?.order?.poojaVideo}",
                                              //       //   style: TextStyle(
                                              //       //     fontSize: 16,
                                              //       //     color: Colors.blue,
                                              //       //     fontWeight: FontWeight.bold,
                                              //       //     overflow: TextOverflow.ellipsis
                                              //       //   ),
                                              //       // ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData?.order
                                                  ?.videoCreatedSharing ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height:
                                      trackModelData?.order?.poojaCertificate ==
                                              ""
                                          ? 40
                                          : 45,
                                  width:
                                      trackModelData?.order?.poojaCertificate ==
                                              ""
                                          ? 40
                                          : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData
                                              ?.order?.poojaCertificate ==
                                          ""
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              "assets/animated/pooja_certificate_animation.gif"))
                                      : Image.asset(
                                          "assets/animated/pooja_certificate_animation.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Certificate Generating',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.poojaCertificate ==
                                            ""
                                        ? const SizedBox.shrink()
                                        : Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.alarm,
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    formatStringDate(
                                                        "${trackModelData?.order?.orderCompleted}"),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          CertificateViewScreen(
                                                        certificateImageUrl:
                                                            '${trackModelData?.order?.poojaCertificate}',
                                                        issuedDate:
                                                            '${trackModelData?.order?.bookingDate}',
                                                        certificateShareMessage:
                                                            '🌸 आपका श्रद्धा चढ़ावा स्वीकार हुआ 🌸\n\n'
                                                            'महाकाल ऐप के माध्यम से अर्पित आपका पवित्र चढ़ावा भोलेनाथ की सेवा में समर्पित किया गया है। 🔱\n'
                                                            'आपकी यह श्रद्धा निश्चित ही महादेव की कृपा दिलाएगी। 💖\n'
                                                            'भोलेनाथ आपके जीवन में सुख, समृद्धि और शांति प्रदान करें। 🌺🕉️\n'
                                                            'जय महाकाल! 🙏',
                                                        serviceType: 'Chadhava',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .document_scanner_sharp,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "View Certificate",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.poojaCertificate ==
                                              ""
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    height:
                                        trackModelData?.order?.orderCompleted ==
                                                null
                                            ? 40
                                            : 45,
                                    width:
                                        trackModelData?.order?.orderCompleted ==
                                                null
                                            ? 40
                                            : 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: trackModelData
                                                ?.order?.orderCompleted ==
                                            null
                                        ? Opacity(
                                            opacity: 0.3,
                                            child: Image.asset(
                                                "assets/animated/Pooja_done_animation.gif"))
                                        : Image.asset(
                                            "assets/animated/Pooja_done_animation.gif")),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Order Completed',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.orderCompleted ==
                                            null
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.alarm,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                formatStringDate(
                                                    "${trackModelData?.order?.orderCompleted}"),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.orderCompleted ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPlayer({super.key, required this.videoUrl});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  YoutubePlayerController? _youtubeController;
  late YoutubeMetaData videoMetaData;
  var isPlayerReady = false;

  @override
  void initState() {
    _initializeYoutubePlayer(widget.videoUrl);
    super.initState();
  }

  void _initializeYoutubePlayer(String videoUrl) {
    final videoID = YoutubePlayer.convertUrlToId(videoUrl);
    _youtubeController = YoutubePlayerController(
      initialVideoId: "$videoID",
      flags: const YoutubePlayerFlags(
        useHybridComposition: true,
        mute: false,
        autoPlay: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (isPlayerReady && mounted && !_youtubeController!.value.isFullScreen) {
      setState(() {
        videoMetaData = _youtubeController!.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _youtubeController!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _youtubeController!.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: YoutubePlayer(
        controller: _youtubeController!,
        topActions: [
          InkWell(
              onTap: () {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ))
        ],
        showVideoProgressIndicator: true,
        onReady: () {
          isPlayerReady = true;
          print('Player is ready.');
        },
      )),
    );
  }
}


