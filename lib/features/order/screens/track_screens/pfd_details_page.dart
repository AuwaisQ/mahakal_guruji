import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/utill/loading_datawidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/datasource/remote/http/httpClient.dart';
import '../../../../main.dart';
import '../../../../utill/app_constants.dart';
import '../../../profile/controllers/profile_contrroller.dart';
import '../../../splash/controllers/splash_controller.dart';
import '../../model/pdforder_details_modal.dart';

class PdfOrderDetails extends StatefulWidget {
  final String orderId;
  final String type;
  const PdfOrderDetails({super.key, required this.orderId, required this.type});

  @override
  State<PdfOrderDetails> createState() => _PdfOrderDetailsState();
}

class _PdfOrderDetailsState extends State<PdfOrderDetails> {
  String userId = "";
  String userName = "";
  String userNumber = "";
  String userEmail = "";
  Pdforderdetails? pdfModelList;

  void fetchPdfData(String orderId, String type) async {
    print("Pdf Data $orderId $type");
    var res = await HttpService().postApi(AppConstants.orderPdfurl, {
      "user_id": userId,
      "order_id": orderId,
      "type": type,
    });
    if (res['status'] == 1) {
      setState(() {
        pdfModelList = Pdforderdetails.fromJson(res['data']);
      });
      print("Kundli Matching Data -$res");
      print("Kundli Matching Data -${pdfModelList?.maleName}");
    } else {
      print("Kundli Api response Failed -$res");
      // Handle API response failure
    }
  }

  String convertToAmPm(String time24) {
    try {
      DateTime dateTime = DateFormat("HH:mm:ss").parse(time24);
      return DateFormat("hh:mm a").format(dateTime); // e.g., 10:22 PM
    } catch (e) {
      return 'Invalid Time';
    }
  }

  Future<void> openInBrowser(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // Opens in Chrome or default browser
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static String? savedInvoicePath; // Invoice ka path store karega

  /// **Invoice fetch Method**
  static Future<void> fetchInvoice(String orderId) async {
    try {
      String apiUrl =
          AppConstants.baseUrl + AppConstants.fetchInvoiceUrl + orderId;

      Response response = await Dio().get(
        apiUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/invoice_$orderId.pdf';

        File file = File(filePath);
        await file.writeAsBytes(response.data);
        savedInvoicePath = filePath;

        print("downloading invoice: ${response.data}");
      } else {
        // no else action
      }
    } catch (error) {
      print("Error downloading invoice: $error");
    }
  }

  /// **Invoice Open Method**
  static Future<void> openInvoice(BuildContext context, String url) async {
    if (savedInvoicePath == null || !File(savedInvoicePath!).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("⚠ No invoice found at: ${savedInvoicePath ?? 'NULL'}")),
      );
      print("File does not exist: ${savedInvoicePath ?? 'NULL'}");
      return;
    }

    print("Opening PDF: $savedInvoicePath");

    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => InvoiceViewer(
    //       pdfPath: savedInvoicePath!,
    //       invoiceUrl: url,
    //     ),
    //   ),
    // );
  }

  /// **Invoice Share Method**
  static Future<void> shareInvoice(BuildContext context) async {
    if (savedInvoicePath != null && File(savedInvoicePath!).existsSync()) {
      var splashController =
          Provider.of<SplashController>(context, listen: false);
      String shareUrl = '';
      shareUrl = "${AppConstants.baseUrl}/download";

      // Share message
      String shareText = "📜 **आपका टूर इनवॉइस** ✨\n\n"
          "अब देखें Mahakal.com ऐप पर! 🔱💖\n"
          "📲 **डाउनलोड करें और यात्रा का लाभ उठाएं!** 🙏\n\n"
          "🔹Download App Now: $shareUrl";

      // **Step 1: Pehle PDF share karo**
      await Share.shareXFiles([XFile(savedInvoicePath!)]);

      // **Step 2: Phir Text + URL share karo**
      await Share.share(shareText, subject: "📜 आपका टूर इनवॉइस");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please download the invoice first!")),
      );
    }
  }

  String formatCreatedAt(String bookingDate) {
    try {
      DateTime dateTime = DateTime.parse(bookingDate);
      // Format the DateTime to the desired format, e.g., "dd-MM-yyyy"
      String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      print("Error parsing date: $e");
      return bookingDate; // Return the original string in case of error
    }
  }

  double _downloadProgress = 0.0;
  bool downloadProgress = false;
  void downloadFile(String url) {
    print("api url $url");
    FileDownloader.downloadFile(
      url: url, // Your PDF URL
      name:
          'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf', // Optional custom name
      onProgress: (String? fileName, double progress) {
        setState(() {
          _downloadProgress = progress;
        });
      },
      onDownloadCompleted: (String path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Download Complete: $path'),
              backgroundColor: Colors.green),
        );
        print('File saved at: $path');
      },
      onDownloadError: (String error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Download failed: $error'),
              backgroundColor: Colors.red),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    userName =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    userNumber = Provider.of<ProfileController>(Get.context!, listen: false)
        .userPHONE
        .substring(3);
    userEmail =
        Provider.of<ProfileController>(Get.context!, listen: false).userEMAIL;
    fetchPdfData(widget.orderId, widget.type);
    fetchInvoice(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return pdfModelList?.chartStyle == null
        ? MahakalLoadingData(onReload: () {})
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Share Button (Only Show if Not Refunded)
                  // if (tourOrderData?.data!.refundStatus != 1)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        openInvoice(context, '${pdfModelList?.invoicePdf}');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors
                              .white, // Background color                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade100,
                              blurRadius: 4,
                              spreadRadius: 2,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.remove_red_eye,
                                color: Colors.black,
                                size: 16), // Refund policy icon
                            SizedBox(width: 8), // Spacing
                            Text(
                              "view Invoice",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            //SizedBox(width: 5),
                            // Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // openInBrowser("${pdfModelList?.kundaliPdf}");

                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black54, // Background color
                          transitionDuration: const Duration(
                              milliseconds: 400), // Animation duration
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter modalSetter) {
                              return Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Download Kundali',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        const Text(
                                            'Are you sure you want to download this Kundali PDF?',
                                            textAlign: TextAlign.center),
                                        const SizedBox(height: 20),
                                        // const Text('Download Invoice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        // const SizedBox(height: 10),
                                        // const Text('Are you sure you want to download this invoice PDF?', textAlign: TextAlign.center),
                                        // const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      color: Colors.red,
                                                      width:
                                                          2), // <-- Border color + width
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // optional: for rounded corners
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  downloadFile(
                                                      "${pdfModelList?.kundaliPdf}");
                                                  modalSetter(() {
                                                    downloadProgress = true;
                                                  });
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 2));
                                                  Navigator.of(context).pop();
                                                  modalSetter(() {
                                                    downloadProgress = false;
                                                  }); // Then wait
                                                },
                                                child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: downloadProgress
                                                          ? Colors.white30
                                                          : Colors.green,
                                                    ),
                                                    child: Center(
                                                      child: downloadProgress
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          : const Text(
                                                              "Download",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              // <- Animation type here
                              scale: CurvedAnimation(
                                  parent: animation, curve: Curves.easeOutBack),
                              child: child,
                            );
                          },
                        );

                        // downloadFile("${pdfModelList?.kundaliPdf}");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors
                              .white, // Background color                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100,
                              blurRadius: 4,
                              spreadRadius: 2,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.download,
                                color: Colors.black,
                                size: 16), // Refund policy icon
                            SizedBox(width: 8), // Spacing
                            Text(
                              "Kundali PDF",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            //SizedBox(width: 5),
                            // Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12), // Arrow icon
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.grey.shade50,
              title: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(formatCreatedAt("${pdfModelList?.createdAt}"),
                      style: const TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.blue)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: "Chart Style -",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    TextSpan(
                        text: " ${pdfModelList?.chartStyle}",
                        style: const TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: " Your Order Id - ",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    TextSpan(
                        text: "${pdfModelList?.orderId}",
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                ],
              ),
              centerTitle: true,
              toolbarHeight: 100,
            ),
            body: SingleChildScrollView(
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
                    child: Container(
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.article,
                                  color: Colors.deepOrange,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("User Info",
                                    style: TextStyle(
                                        fontSize: 20,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange))
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
                                  color: Colors.deepOrange.shade200,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(userName,
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
                                  color: Colors.deepOrange.shade200,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(userEmail,
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
                                  color: Colors.deepOrange.shade200,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(userNumber,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.type == "kundali"
                      ? Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.deepOrange.shade400,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepOrange.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.orange.shade50,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row
                              Row(
                                children: [
                                  Icon(Icons.article,
                                      color: Colors.deepOrange.shade700,
                                      size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    "User Details",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.deepOrange.shade800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),

                              // Divider
                              Divider(
                                color: Colors.deepOrange.shade200,
                                thickness: 1,
                                height: 24,
                              ),

                              // Name Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.person,
                                      color: Colors.deepOrange.shade600,
                                      size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "${pdfModelList?.maleName}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade800,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Date and Time Row
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.date_range,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        formatCreatedAt(
                                            "${pdfModelList?.maleBod}"),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.access_alarm_rounded,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        convertToAmPm(
                                            "${pdfModelList?.maleTime}"),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Country Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.deepOrange.shade600,
                                      size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "${pdfModelList?.maleCountry}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade800,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // State Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.flag,
                                      color: Colors.deepOrange.shade600,
                                      size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "${pdfModelList?.maleState}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade800,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.deepOrange.shade400,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrange.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.orange.shade50,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("✦ Male Details ✦",
                                          style: TextStyle(
                                              fontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.deepOrange.shade600))
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
                                      Expanded(
                                          flex: 0,
                                          child: Icon(Icons.person,
                                              color: Colors.deepOrange.shade600,
                                              size: 20)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${pdfModelList?.maleName}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 2,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.date_range,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          formatCreatedAt(
                                              "${pdfModelList?.maleBod}"),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                      const SizedBox(
                                        width: 60,
                                      ),
                                      Icon(Icons.access_alarm_rounded,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          convertToAmPm(
                                              "${pdfModelList?.maleTime}"),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${pdfModelList?.maleCountry}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.flag,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                              "${pdfModelList?.maleState}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.deepOrange.shade400,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrange.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.orange.shade50,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("✦ Female Details ✦",
                                          style: TextStyle(
                                              fontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.deepOrange.shade600))
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
                                      Expanded(
                                          flex: 0,
                                          child: Icon(Icons.person,
                                              color: Colors.deepOrange.shade600,
                                              size: 20)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${pdfModelList?.femaleName}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 2,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.date_range,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          formatCreatedAt(
                                              "${pdfModelList?.femaleBod}"),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                      const SizedBox(
                                        width: 60,
                                      ),
                                      Icon(Icons.access_alarm_rounded,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          convertToAmPm(
                                              "${pdfModelList?.femaleTime}"),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${pdfModelList?.femaleCountry}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.flag,
                                          color: Colors.deepOrange.shade600,
                                          size: 20),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                              "${pdfModelList?.femaleState}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          );
  }
}
