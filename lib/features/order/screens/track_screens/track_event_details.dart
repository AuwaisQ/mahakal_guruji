import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/utill/loading_datawidget.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/datasource/remote/http/httpClient.dart';
import '../../../../main.dart';
import '../../../../utill/app_constants.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../profile/controllers/profile_contrroller.dart';
import '../../../support/screens/support_ticket_screen.dart';
import '../../model/event_order_details_model.dart';
import 'package:http/http.dart' as http;

import '../../model/event_pass_model.dart';

class TrackEventDetails extends StatefulWidget {
  final int orderId;

  const TrackEventDetails({
    super.key,
    required this.orderId,
  });

  @override
  State<TrackEventDetails> createState() => _TrackEventDetailsState();
}

class _TrackEventDetailsState extends State<TrackEventDetails> {
  String userName = "";
  String userNumber = "";
  String userId = "";
  String userEmail = "";
  String? latitude;
  String? longitude;
  String? selectedLocation;
  String? timeHour;
  String? timeMinute;
  String userToken = "";
  int _selectedRating = 3;
  bool isLoading = true;
  int _selectedIndex = 0;

  String formatDateTime(String dateWithTime, {bool returnDate = true}) {
    List<String> parts = dateWithTime.split(" ");

    if (parts.length < 5) return "Invalid Date Format"; // Safety check

    String eventDate = "${parts[0]} ${parts[1]} ${parts[2]}"; // "29 Mar 2025"
    String eventTime = "${parts[3]} ${parts[4]}"; // "08:00 AM"

    return returnDate ? eventDate : eventTime;
  }

  final TextEditingController _suggestionsController = TextEditingController();
  List<String> options = [
    "The event coordinator was knowledgeable and provided detailed assistance throughout the booking.",
    "The booking experience was well-organized and included all necessary details about the event.",
    "The ticket booking process was smooth and easy to complete.",
    "I liked that I could select events based on my personal interests.",
    "The overall experience was hassle-free, and I received timely updates and support after booking.",
    // ... more options
  ];

  @override
  void initState() {
    print("My Event Order Id:${widget.orderId}");
    // TODO: implement initState
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    userName =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    userNumber =
        Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
    userToken =
        Provider.of<AuthController>(Get.context!, listen: false).getUserToken();
    userEmail =
        Provider.of<ProfileController>(Get.context!, listen: false).userEMAIL;
    getEventOrderDetails();
  }

  EventOrderDetailsModel? eventOrderData;

  Future<void> getEventOrderDetails() async {
    // String url = AppConstants.baseUrl + AppConstants.eventOrderListUrl;
    Map<String, dynamic> data = {"user_id": userId, "id": widget.orderId};

    setState(() {
      isLoading = true;
    });
    try {
      final res =
          await HttpService().postApi(AppConstants.eventOrderListUrl, data);
      //final res = await ApiServiceDonate().getAdvertise(url, data);
      print("Event Order Details$res");

      if (res != null) {
        setState(() {
          eventOrderData = EventOrderDetailsModel.fromJson(res);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Event Order Error$e");
    }
  }

  void _handleCheckboxChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void setReviewData(StateSetter modalSetter) async {
    final url = Uri.parse(AppConstants.baseUrl +
        AppConstants.addEventCommentUrl); // Replace with your API endpoint
    final Map<String, dynamic> data = {
      "user_id": userId,
      "event_id": "${eventOrderData!.data!.eventId}",
      "order_id": "${eventOrderData!.data!.id}",
      "star": _selectedRating,
      "comment": _suggestionsController.text,
      "image": ""
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        modalSetter(() {
          isLoading = false;
          _suggestionsController.clear();
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Thank you for your feedback!",
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        // Handle error response
        Fluttertoast.showToast(
            msg: "Add Failed",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (error) {
      print('Error posting data: $error');
    }
  }

  /// review bottom sheet
  void showFeedbackBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      AppBar(
                        backgroundColor: Colors.transparent,
                        centerTitle: true,
                        leading: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              CupertinoIcons.chevron_back,
                              color: Colors.red,
                            )),
                        title: const Text(
                          'Please provide your feedback',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),

                      // Star Rating
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "How many stars will you give us for your Tour booking on Mahakal.com",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < _selectedRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    modalSetter(() {
                                      _selectedRating = index + 1;
                                    });
                                  },
                                );
                              }),
                            ),
                            Center(
                              child: Text(
                                _selectedRating == 1
                                    ? "Poor"
                                    : _selectedRating == 2
                                        ? "Below Average"
                                        : _selectedRating == 3
                                            ? "Average"
                                            : _selectedRating == 4
                                                ? "Good"
                                                : "Excellent",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Improvement Options
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "What can we improve ?",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: List.generate(options.length, (index) {
                                return CheckboxListTile(
                                  checkColor: Colors.white,
                                  activeColor: Colors.amber,
                                  title: Text(
                                    options[index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  value: _selectedIndex ==
                                      index, // Key change: Compare index
                                  onChanged: (value) {
                                    if (value == true) {
                                      //Only allow selection if value is true. Prevents unchecking
                                      modalSetter(() {
                                        _handleCheckboxChange(index);
                                        _suggestionsController.text =
                                            options[index];
                                        print(
                                            "suggestion controller ${_suggestionsController.text}");
                                      });
                                    }
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      // Suggestions
                      const SizedBox(height: 10),
                      Container(
                        // margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Please provide your suggestions",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _suggestionsController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber)),
                                hintText: "Write here...",
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      // Submit Button
                      isLoading
                          ? Container(
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.all(4.0),
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.amber.shade400,
                              ),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.white,
                              )))
                          : GestureDetector(
                              onTap: () {
                                modalSetter(() {
                                  isLoading = true;
                                });
                                // Submit feedback logic
                                print("Rating: $_selectedRating");
                                // print("Improvements: ${_improvementOptions.toString()}");
                                print(
                                    "Suggestions: ${_suggestionsController.text}");
                                setReviewData(modalSetter);
                                getEventOrderDetails();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.amber,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> downloadPass(
    String orderId,
    int index,
    List<bool> isDownloading,
    List<double> progressValues,
  ) async {
    const url = AppConstants.baseUrl + AppConstants.eventOrderPassUrl;

    try {
      setState(() {
        isDownloading[index] = true;
        progressValues[index] = 0.0;
      });

      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          Fluttertoast.showToast(msg: "❌ Storage Permission Denied!");
          setState(() => isDownloading[index] = false);
          return;
        }
      }

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"order_id": orderId, "num": index + 1}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        Directory? directory;

        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        String filePath = "${directory.path}/event_pass_${index + 1}.png";
        File file = File(filePath);

        int totalBytes = bytes.length;
        int downloadedBytes = 0;
        const chunkSize = 4096;

        IOSink sink = file.openWrite();
        for (int i = 0; i < totalBytes; i += chunkSize) {
          int end = (i + chunkSize > totalBytes) ? totalBytes : i + chunkSize;
          sink.add(bytes.sublist(i, end));
          downloadedBytes = end;

          setState(() {
            progressValues[index] = downloadedBytes / totalBytes;
          });
          await Future.delayed(const Duration(milliseconds: 50));
        }

        await sink.close();
        Fluttertoast.showToast(
            msg: "✅ Pass Downloaded: event_pass_${index + 1}.png");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "❌ Download Failed: $e");
      print("Error: $e");
    }

    setState(() => isDownloading[index] = false);
  }

  void showPassDownloadSheet(
      BuildContext context, String orderId, int totalMembers) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter modalSetter) {
            List<bool> isDownloading = List.filled(totalMembers, false);
            List<double> progressValues = List.filled(totalMembers, 0.0);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Download Your Passes",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: totalMembers,
                    itemBuilder: (context, index) {
                      int passNumber = index + 1;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.person,
                              color: Colors.blue, size: 28),
                          title: Text(
                            "Pass #$passNumber",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          trailing: isDownloading[index]
                              ? CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 4.0,
                                  percent: progressValues[index],
                                  center: Text(
                                      "${(progressValues[index] * 100).toInt()}%"),
                                  progressColor: Colors.green,
                                )
                              : IconButton(
                                  icon: const Icon(Icons.download,
                                      color: Colors.amber),
                                  onPressed: () async {
                                    await downloadPass(orderId, index,
                                        isDownloading, progressValues);
                                  },
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close",
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            )))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey.shade50,
              title: Column(
                children: [
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: "Order -",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    TextSpan(
                        text: " #${eventOrderData?.data?.orderNo}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text.rich(TextSpan(children: [
                    TextSpan(
                        text: " Your Order is - ",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    TextSpan(
                        text: "Success",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      formatDateTime("${eventOrderData?.data?.eventDate}",
                          returnDate: true),
                      style: const TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black))
                ],
              ),
              centerTitle: true,
              toolbarHeight: 100,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                //getTrackData(widget.poojaId);
              },
              color: Colors.white,
              // Progress indicator color
              backgroundColor: Colors.amber,
              // Background color of the refresh indicator
              displacement: 40.0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/map_bg.png"),
                              fit: BoxFit.fill)),
                      child: Column(
                        children: [
                          /// User Info
                          Container(
                            // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.article,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("User Info",
                                          style: TextStyle(
                                              fontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber))
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.amber.shade200,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${eventOrderData?.data?.userName}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: Colors.amber.shade200,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${eventOrderData?.data?.userEmail}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.amber.shade200,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${eventOrderData?.data?.userPhone}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Pass Button
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => EventPassScreen(
                                    eventOrderId: '${eventOrderData?.data?.id}',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated Icon Container
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B00),
                                          Color(0xFFFF8C00)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.confirmation_number_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Text Content
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your Event Pass",
                                        style: TextStyle(
                                          color: Colors.amber[800],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Your Ticket to Unforgettable Experiences!",
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),

                                  // Arrow in circle
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.amber.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.amber[700],
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // your product
                          const Row(
                            children: [
                              Icon(
                                Icons.redeem,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Your Tickets Info",
                                  style: TextStyle(
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          /// **Event Details Card**
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /// **Event Details**
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// **Ticket Name**
                                          Text(
                                            "${eventOrderData?.data?.enEventName}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          const SizedBox(height: 5),

                                          /// **Booking Date & Time**
                                          Row(
                                            children: [
                                              const Icon(Icons.date_range,
                                                  color: Colors.blue, size: 18),
                                              const SizedBox(width: 5),
                                              Text(
                                                formatDateTime(
                                                    "${eventOrderData?.data?.eventDate},",
                                                    returnDate: true),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                formatDateTime(
                                                    "${eventOrderData?.data?.eventDate}",
                                                    returnDate: false),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),

                                          /// **Artist Name**
                                          Row(
                                            children: [
                                              const Icon(Icons.person,
                                                  color: Colors.deepPurple,
                                                  size: 18),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  "${eventOrderData?.data?.enArtistName}",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),

                                          /// **Event Venue**
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.location_on,
                                                  color: Colors.red, size: 18),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  "${eventOrderData?.data?.enEventVenue}",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),

                                    /// **Event Image**
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(12),
                                    //   child: Image.network(
                                    //     "${eventOrderData!.data!.artistImage}",
                                    //     height: 120,
                                    //     width: 120,
                                    //     fit: BoxFit.cover,
                                    //     errorBuilder: (context, error,
                                    //         stackTrace) =>
                                    //     const Icon(
                                    //         Icons.image_not_supported_outlined,
                                    //         size: 50,
                                    //         color: Colors.grey),
                                    //   ),
                                    // ),
                                    Container(
                                      height: 90,
                                      width: 155,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          "${eventOrderData?.data?.artistImage}",
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(
                                  color: Colors.grey,
                                ),

                                /// **Event Name**
                                Text(
                                  "${eventOrderData?.data?.enEventName}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                ///& Total Seats**
                                Text(
                                  "Total Seats: ${eventOrderData?.data?.totalSeats}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),

                                /// **Price
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "${NumberFormat.currency(
                                                locale: 'en_IN',
                                                symbol: '₹',
                                                decimalDigits: 0)
                                                .format(double.tryParse("${eventOrderData?.data?.amount} ") ??
                                                0)}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "(Tax Included)",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  // Slightly transparent black for better aesthetics
                                  blurRadius: 4,
                                  // Controls the softness of the shadow
                                  spreadRadius:
                                      1, // Spread the shadow a little// X=0 (centered horizontally), Y=4 (downwards)
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.article,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Payment info",
                                        style: TextStyle(
                                            fontSize: 20,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    const Text("Subtotal",
                                        style: TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.green)),
                                    const Spacer(),
                                    Text(
                                        "${NumberFormat.currency(
                                            locale: 'en_IN',
                                            symbol: '₹',
                                            decimalDigits: 0)
                                            .format(double.tryParse("${eventOrderData?.data?.amount}") ??
                                            0)}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.green)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Text("Coupon discount",
                                        style: TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text(
                                        "${NumberFormat.currency(
                                            locale: 'en_IN',
                                            symbol: '₹',
                                            decimalDigits: 0)
                                            .format(double.tryParse("${eventOrderData?.data?.couponAmount}") ??
                                            0)}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                                Row(
                                  children: [
                                    const Text("Amount Paid",
                                        style: TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text(
                                        "${NumberFormat.currency(
                                            locale: 'en_IN',
                                            symbol: '₹',
                                            decimalDigits: 0)
                                            .format(double.tryParse("${eventOrderData?.data?.amount - eventOrderData?.data?.couponAmount}") ??
                                            0)}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // tourOrderData?.data!.amountStatus == 1
                          // ?
                          Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              eventOrderData?.data?.reviewStatus == 1
                                  ? Container(
                                      height: 50,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 2),
                                      ),
                                      child: const Row(children: [
                                        Text(
                                          "Review added successfully ✨",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Center(
                                            child: Icon(
                                          CupertinoIcons.checkmark_circle_fill,
                                          color: Colors.green,
                                        )),
                                      ]),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _suggestionsController.text =
                                            options[0];
                                        showFeedbackBottomSheet();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: Colors.grey.shade400,
                                              width: 2),
                                        ),
                                        child: const Row(children: [
                                          Text(
                                            "Write Your Experience",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Spacer(),
                                          Center(
                                              child: Icon(
                                            CupertinoIcons
                                                .arrow_right_circle_fill,
                                            color: Colors.blue,
                                          )),
                                        ]),
                                      ),
                                    ),
                            ],
                          ),
                          //: const SizedBox.shrink(),

                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                              "For any assistance or support with consultancy bookings, please feel free to contact us!",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageAnimationTransition(
                                        page: const SupportTicketScreen(),
                                        pageAnimationType:
                                            RightToLeftTransition()));
                              },
                              child: const Text("Support Center",
                                  style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.amber))),

                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class EventPassScreen extends StatefulWidget {
  //final String eventCategory;
  //final String eventVenue;
  //final String eventPerformer;
  //final String eventName;
  //final String eventDate;
  // final String eventAmount;
  // final totalMembers;
  final String eventOrderId;
  // final String artistImage;
  // final String passType;

  const EventPassScreen(
      {super.key,
      // required this.eventCategory,
      // required this.eventVenue,
      // required this.eventPerformer,
      // required this.eventName,
      // required this.eventDate,
      // required this.eventAmount,
      // this.totalMembers,
      // required this.artistImage,
      // required this.passType,
      required this.eventOrderId});

  @override
  _EventPassScreenState createState() => _EventPassScreenState();
}

class _EventPassScreenState extends State<EventPassScreen> {
  List<GlobalKey> _passKeys = []; // List of GlobalKeys for each pass

  @override
  void initState() {
    super.initState();
    showQR(widget.eventOrderId);
  }

  Future<String?> _captureAndSave(int index) async {
    try {
      // Wait until the current frame is finished
      await WidgetsBinding.instance.endOfFrame;

      RenderRepaintBoundary? boundary = _passKeys[index]
          .currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        print("Boundary is null — widget not rendered yet.");
        return null;
      }

      var image = await boundary.toImage(pixelRatio: 4.0); // High quality
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/event_pass_$index.png';
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      return filePath;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }

  String? filePath = "";

  Future<void> _sharePass(int index, String eventName, String eventPerformer,
      String eventVenue, String eventAmount) async {
    filePath = await _captureAndSave(index);

    String shareUrl = '';
    shareUrl = "${AppConstants.baseUrl}/download";

    // // Default URLs
    // String androidUrl = '';
    // String iosUrl = '';
    //
    // // SplashController se dynamically URL fetch karna
    // var splashController = Provider.of<SplashController>(context, listen: false);
    // androidUrl = splashController.configModel?.userAppVersionControl?.forAndroid?.link ?? "";
    // iosUrl = splashController.configModel?.userAppVersionControl?.forIos?.link ?? "";

    if (filePath != null) {
      await Share.shareXFiles([XFile(filePath!)], text: '''
📢 **आध्यात्मिक प्रवचन में आपका स्वागत है!** 🎟️  
🌟 इस अद्भुत अनुभव के लिए तैयार हो जाइए!  

📅 **इवेंट:** ${eventName}  
🎭 **प्रवचनकर्ता:** ${eventPerformer}  
📍 **स्थान:** ${eventVenue}  
💰 **टिकट मूल्य:** ${eventAmount}  

🔗 **अभी ऐप डाउनलोड करें और हर खास आयोजन से जुड़े रहें!**  
📲 Download App Now: $shareUrl  

#आध्यात्मिक_प्रवचन #Bhakti #SpiritualEvent 🙏🔥
      ''');
    }
  }

  String category = "";

  // String eventTypeReturn(String eventType) {
  //   switch (eventType) {
  //     case 'Silver Package':
  //       category = 'Silver';
  //       break;
  //     case 'Gold Package':
  //       category = 'Gold';
  //       break;
  //     case 'Platinum Package':
  //       category = 'Platinum';
  //       break;
  //     case 'VIP Ticket':
  //       category = 'VIP';
  //       break;
  //     default:
  //       category = 'Gen';
  //   }
  //   return category;
  // }

  void _showPassDialog(BuildContext context, EventPass event) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 PASS (QR Section)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.transparent,
                      width: 280,
                      height: 280,
                      child: Image.network(
                        event.passUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 60,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 INFO SECTION
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Text(
                        event.enCategoryName ?? "Event Pass",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Biggest Spiritual Discourses of the Year",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),

                      const Divider(
                        height: 20,
                        thickness: 1,
                        color: Colors.white24,
                      ),

                      /// Performed By
                      Row(
                        children: [
                          const Icon(Icons.mic, color: Colors.amber, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Performed by: ${event.enArtistName ?? "Unknown"}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 CLOSE BUTTON
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 30),
                      elevation: 5,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isLoading = false;
  List<EventPass> qrList = [];

  Future<void> showQR(String id) async {
    //String url = "${AppConstants.baseUrl}${AppConstants.eventPassUrl}";
    Map<String, dynamic> data = {
      "id": id,
    };

    setState(() {
      isLoading = true;
    });

    try {
      final res = await HttpService().postApi(AppConstants.eventPassUrl, data);
      //final res = await ApiServiceDonate().getAdvertise(url, data);
      if (res != null && res["data"] != null) {
        final response = EventPassModel.fromJson(res);
        qrList = response.data;

        _passKeys = List.generate(qrList.length, (index) => GlobalKey());
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Event Pass List",
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
        ),
        body: isLoading
            ? MahakalLoadingData(onReload: () {})
            : ListView.builder(
                itemCount: qrList.length,
                itemBuilder: (context, index) {
                  int passNumber = index + 1;
                  var event = qrList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _showPassDialog(context, event),
                      child: RepaintBoundary(
                        key: _passKeys[index],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFff9966),
                                Color(0xFFff5e62),
                                //Color(0xFFff5f6d), Color(0xFF845ec2)
                              ], // pink → purple gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Left Side (Icon / Placeholder)
                                Column(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image,
                                          color: Colors.white, size: 40),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Pass #$passNumber",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                /// Middle Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// User name
                                      Row(
                                        children: [
                                          const Icon(Icons.person,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            event.passUserName,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      /// Venue
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              event.enEventVenue,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      /// Date & Time
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            event.eventDate,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      /// Event name
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.event,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              event.enEventName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /// QR Code (Right Side)
                                Column(
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        event.passUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black12),
                                      child: IconButton(
                                        onPressed: () => _sharePass(
                                            index,
                                            event.enEventName,
                                            event.enArtistName,
                                            event.enEventVenue,
                                            "${event.amount}"),
                                        icon: const Icon(Icons.share,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
