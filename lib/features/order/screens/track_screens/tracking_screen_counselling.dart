import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/finaltrack_model.dart';

class CounsellingTrackingPage extends StatefulWidget {
  final String createdDate;
  final String status;
  final String orderId;

  const CounsellingTrackingPage(
      {super.key,
      required this.createdDate,
      required this.status,
      required this.orderId});

  @override
  State<CounsellingTrackingPage> createState() =>
      _CounsellingTrackingPageState();
}

class _CounsellingTrackingPageState extends State<CounsellingTrackingPage> {
  FinalTrackDetailModel? trackModelData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrackData(widget.orderId);
  }

  Future<void> getTrackData(String userId) async {
    final String url =
        AppConstants.baseUrl + AppConstants.serviceTrackUrl + userId;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          print("APi response ${response.body}");
          // var res = jsonEncode(response.body);

          trackModelData = finalTrackDetailModelFromJson(response.body);
          _fetchPujaReportImage(trackModelData?.order!.counsellingReport ?? '');
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

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    FileDownloader.downloadFile(
      url: imageUrl,
      onDownloadCompleted: (path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image saved at: $path")),
        );
      },
      onDownloadError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Download failed: $error")),
        );
      },
    );
  }

  String? imagePath;
  Future<void> _fetchPujaReportImage(String ImageUrl) async {
    if (ImageUrl.isEmpty) {
      print('Certificate URL is empty');
      return;
    }

    try {
      final response = await http.get(Uri.parse(ImageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        String tempImagePath = '${directory.path}/pass.png';

        final file = File(tempImagePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          imagePath = tempImagePath;
          //isLoading = false;
        });

        print("Certificate downloaded at: $imagePath");
      } else {
        print('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching certificate image: $e');
    }
  }

  void sharePujaReport() async {
    if (imagePath != null) {
      String shareUrl = '';
      shareUrl = "${AppConstants.baseUrl}/download";

      // Share the image with a custom message
      await Share.shareXFiles(
        [XFile(imagePath ?? '')],
        text: '''
📜 **आपकी पूजा रिपोर्ट** 🔱  

🌟 ** Mahakal.com ऐप द्वारा आयोजित पूजा में आपकी भागीदारी के लिए धन्यवाद!**  
यह पूजा रिपोर्ट आपके आध्यात्मिक अनुभव का प्रमाण है। 🙏💖  

🔗 **अभी ऐप डाउनलोड करें और और भी आध्यात्मिक आयोजनों से जुड़ें!**  
📲 Download App Now: $shareUrl;  

#महाकाल #पूजा_रिपोर्ट #SpiritualJourney 🔥🙏
      ''',
      );
    } else {
      print('Image not available for sharing');
    }
  }

  String formatStringDate(String dateString) {
    try {
      // Convert string to DateTime
      DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);

      // Convert DateTime to desired format
      return DateFormat('hh:mm a, dd MMM yyyy').format(dateTime);
    } catch (e) {
      return "Invalid Date"; // Handle invalid date cases
    }
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: () async {
        getTrackData(widget.orderId);
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
                    text: "${trackModelData?.order?.status}",
                    style: TextStyle(
                        color:
                            getStatusColor("${trackModelData?.order?.status}"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ])),
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
                const Text(
                  'Counselling Tracking Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                  "assets/animated/pooja_conformed_animation.gif")),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Confirm order',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber),
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
                                  trackModelData?.order?.status == "completed"
                                      ? 45
                                      : 40,
                              width:
                                  trackModelData?.order?.status == "completed"
                                      ? 45
                                      : 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: trackModelData?.order?.status ==
                                      "completed"
                                  ? Image.asset(
                                      "assets/animated/Pooja_done_animation.gif")
                                  : Opacity(
                                      opacity: 0.5,
                                      child: Image.asset(
                                          "assets/animated/Pooja_done_animation.gif"))),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order completed',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trackModelData?.order?.status == "completed"
                                  ? Column(
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
                                                  "${trackModelData?.order?.orderCompleted}"),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Successfully",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  trackModelData?.order?.status == "completed"
                                      ? Colors.amber
                                      : Colors.amber.withOpacity(0.3),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      trackModelData?.order?.status == "completed"
                          ? Divider(color: Colors.grey.shade300)
                          : const SizedBox(),
                      trackModelData?.order?.status == "completed"
                          ? Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      spreadRadius: 1),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        "${trackModelData?.order?.counsellingReport}",
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade300),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.download,
                                            color: Colors.blue),
                                        onPressed: () => _downloadImage(context,
                                            "${trackModelData?.order?.counsellingReport}"),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.share,
                                            color: Colors.green),
                                        onPressed: () => sharePujaReport(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
