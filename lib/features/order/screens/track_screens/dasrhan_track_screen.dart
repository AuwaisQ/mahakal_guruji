import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/datasource/remote/http/httpClient.dart';
import '../../../../utill/app_constants.dart';
import '../../model/darshan_details_model.dart';
import 'package:http/http.dart' as http;


class MandirDarshanDetailsOrder extends StatefulWidget {
  final String orderId;
  const MandirDarshanDetailsOrder({super.key, required this.orderId});

  @override
  State<MandirDarshanDetailsOrder> createState() =>
      _MandirDarshanDetailsOrderState();
}

class _MandirDarshanDetailsOrderState extends State<MandirDarshanDetailsOrder> {
  MandirDarshandetailsModel? trackModelData;
  String invoicePDF = "";
  bool downloadProgress = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("order id ${widget.orderId}");
    getTrackData(widget.orderId);
    // invoicePDF = "${trackModelData?.data.invoice}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  void downloadFile(String url) {
    print("api url $url");
    FileDownloader.downloadFile(
      url: url,
      name: 'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
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

  void getTrackData(String id) async {
    var res = await HttpService().getApi("${AppConstants.darshanUrl}/$id");
    print("api response $res");
    setState(() {
      trackModelData = mandirDarshandetailsModelFromJson(jsonEncode(res));
      print("check api response ${trackModelData!.status}");
    });
    invoicePDF = "${trackModelData?.data.invoice}";
  }

  void openInvoice(
      BuildContext context, Uint8List pdfBytes, String invoiceUrl) async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/invoice_${widget.orderId}.pdf';
    File file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => InvoiceViewer(
    //       pdfPath: filePath,
    //       invoiceUrl: invoiceUrl,
    //     ),
    //   ),
    // );
  }

  Future<void> sharePassPdf(String pdfUrl) async {
    print("Mandir Invoice: $pdfUrl");
    try {
      // Download the PDF
      final response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final file =
            File('${tempDir.path}/vip_pass.pdf'); // Changed extension to .pdf

        // Save PDF bytes to file
        await file.writeAsBytes(response.bodyBytes);

        // Share the PDF
        await Share.shareXFiles(
          [
            XFile(file.path, mimeType: 'application/pdf')
          ], // Specify PDF mime type
          text: "📿 आपकी VIP पास तैयार है!\n\n"
              "डाउनलोड Mahakal.com ऐप:\n"
              "${AppConstants.baseUrl}/download",
        );
      } else {
        print("❌ Failed to download PDF: ${response.statusCode}");
        throw Exception("Failed to download PDF: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error sharing PDF: $e");
      rethrow; // Consider showing this error to the user
    }
  }

  // Future<void> sharePassImage(String imageUrl) async {
  //   print("Mandir Invoice${imageUrl}");
  //   try {
  //     // Download the image
  //     final response = await http.get(Uri.parse(imageUrl));
  //
  //     if (response.statusCode == 200) {
  //       // Get temporary directory
  //       final tempDir = await getTemporaryDirectory();
  //       final file = File('${tempDir.path}/vip_pass.jpg');
  //       String shareUrl = "${AppConstants.baseUrl}/download";
  //       // Save image bytes to file
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       // Share the image
  //       await Share.shareXFiles(
  //         [XFile(file.path)],
  //         text: "📿 आपकी VIP पास तैयार है!\n\nडाउनलोड Mahakal.com ऐप:\n $shareUrl",
  //       );
  //     } else {
  //       print("❌ Failed to download image: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("❌ Error sharing image: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return trackModelData?.data.orderId == null
        ? Container(
            color: Colors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
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
                        text: " #${trackModelData?.data.orderId}",
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
                        text: trackModelData?.data.status == 1
                            ? "Success"
                            : "Failed",
                        style: TextStyle(
                            color: trackModelData?.data.status == 1
                                ? Colors.green
                                : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("${trackModelData?.data.bookingDate}",
                      style: const TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black)),
                ],
              ),
              centerTitle: true,
              toolbarHeight: 100,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getTrackData(widget.orderId);
              },
              color: Colors.white, // Progress indicator color
              backgroundColor: Colors
                  .deepOrange, // Background color of the refresh indicator
              displacement: 40.0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 10),
                    _buildMemberGrid(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Temple Details Container
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Temple Image and Name
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      image: DecorationImage(
                        image: NetworkImage(trackModelData?.data.image ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      trackModelData?.data.enTempleName ?? 'Temple Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Package and Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Package Info
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.orange.shade200,
                      ),
                    ),
                    child: Text(
                      trackModelData?.data.packageName ?? 'Package',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Price
                  Text(
                    '₹${trackModelData?.data.price ?? '500'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // VIP Pass Container
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent.shade100,
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.deepOrange.withOpacity(0.2),
                Colors.purple.withOpacity(0.4),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Header with title and compact invoice button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      trackModelData?.data.title ?? 'VIP Pass',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36, // Compact button size
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final String invoiceUrl =
                            '${trackModelData?.data.invoice}';
                        final response = await Dio().get(
                          invoiceUrl,
                          options: Options(responseType: ResponseType.bytes),
                        );
                        if (response.statusCode == 200) {
                          Uint8List invoicePDF =
                              Uint8List.fromList(response.data);
                          openInvoice(context, invoicePDF, invoiceUrl);
                        }
                      },
                      icon: const Icon(Icons.download,
                          size: 16, color: Colors.white),
                      label:
                          const Text('Invoice', style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Pass Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Name', '${trackModelData?.data.userName}'),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Valid Date', '${trackModelData?.data.bookingDate}'),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Time Slot', '${trackModelData?.data.timeSlot}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Group Members',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.deepOrange.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Count: ${trackModelData?.data.memberList.length ?? 0}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trackModelData?.data.memberList.length,
            itemBuilder: (context, index) {
              final data = trackModelData?.data.memberList[index];
              final isPrimary = index == 0;
              final String? base64String =
                  trackModelData?.data.memberList[index].image;
              Uint8List bytes = base64Decode(base64String!.split(',').last);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: isPrimary ? 1.5 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrange.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                                border:
                                    Border.all(color: Colors.orange, width: 1)),
                            child: CircleAvatar(
                              radius: 20, // Slightly larger
                              backgroundColor: Colors.deepOrange.shade50,
                              child: data!.image.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.memory(
                                        bytes,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            size: 32,
                                            color: Colors.deepOrange.shade700,
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                      data.name.substring(0, 1),
                                      style: TextStyle(
                                          color: Colors.deepOrange.shade700,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const Spacer(),
                          if (isPrimary)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRIMARY MEMBER',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Only show phone for primary member
                      if (isPrimary) ...[
                        _buildDetail(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: data.phone,
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Aadhar for all members
                      _buildDetail(
                        icon: Icons.badge,
                        label: 'Aadhar',
                        value:
                            "${data.aadhar.substring(0, 4)}****${data.aadhar.substring(data.aadhar.length - 4)}",
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final String invoiceUrl =
                                      '${trackModelData?.data.memberList[index].pass}';
                                  final response = await Dio().get(
                                    invoiceUrl,
                                    options: Options(
                                        responseType: ResponseType.bytes),
                                  );
                                  if (response.statusCode == 200) {
                                    Uint8List invoicePDF =
                                        Uint8List.fromList(response.data);
                                    openInvoice(
                                        context, invoicePDF, invoiceUrl);
                                  }
                                },
                                icon: const Icon(
                                  Icons.article,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Preview',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  /// **Share  Invoice**
                                  sharePassPdf(
                                      "${trackModelData?.data.memberList[index].pass}");
                                },
                                icon: const Icon(
                                  Icons.share,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // Handle member pass download
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel:
                                        MaterialLocalizations.of(context)
                                            .modalBarrierDismissLabel,
                                    barrierColor: Colors.black54,
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter modalSetter) {
                                          return Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                        'Download Invoice',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    const SizedBox(height: 10),
                                                    const Text(
                                                        'Are you sure you want to download this invoice PDF?',
                                                        textAlign:
                                                            TextAlign.center),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              side: const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 2),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              downloadFile(
                                                                  "${trackModelData?.data.invoice}");
                                                              modalSetter(() {
                                                                downloadProgress =
                                                                    true;
                                                              });
                                                              await Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          2));
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              modalSetter(() {
                                                                downloadProgress =
                                                                    false;
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: downloadProgress
                                                                    ? Colors
                                                                        .white30
                                                                    : Colors
                                                                        .green,
                                                              ),
                                                              child: Center(
                                                                child: downloadProgress
                                                                    ? const CircularProgressIndicator(
                                                                        color: Colors
                                                                            .green)
                                                                    : const Text(
                                                                        "Download",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    transitionBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return ScaleTransition(
                                        scale: CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutBack),
                                        child: child,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.download_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Pass',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
