import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/order/screens/track_screens/track_chadhava_screen.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/utill/loading_datawidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../model/donation_orderdetails_model.dart';
import 'package:mahakal/utill/app_constants.dart';
import '../../../../main.dart' show Get;
import '../../../profile/controllers/profile_contrroller.dart';

class TrackDonationDetails extends StatefulWidget {
  final String donationId;

  const TrackDonationDetails({super.key, required this.donationId});

  @override
  State<TrackDonationDetails> createState() => _TrackDonationDetailsState();
}

class _TrackDonationDetailsState extends State<TrackDonationDetails> {
  bool isLoading = false;
  String userId = "";
  String userToken = "";
  bool isSubscribed = false;
  String subscriptionStatus = "";

  @override
  void initState() {
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    userToken = Provider.of<AuthController>(Get.context!, listen: false).getUserToken();
    getOrderDetails();
    fetchDonationInvoice(context, widget.donationId, userToken);
  }

  DonationOrderDetails? donationOrderDetails;

  Future<void> getOrderDetails() async {
    print("Donation Id: ${widget.donationId}");
    Map<String, dynamic> data = {"user_id": userId, "id": widget.donationId};

    setState(() {
      isLoading = true;
    });

    try {
      final res =
          await HttpService().postApi(AppConstants.donationOrderUrl, data);
      if (res != null) {
        setState(() {
          donationOrderDetails = DonationOrderDetails.fromJson(res);
          final status = donationOrderDetails?.data?.subscriptionStatus?.toLowerCase() ?? "";

          // handle all possible cases
          if (status == "cancelled") {
            isSubscribed = false;
            subscriptionStatus = "Cancelled";
          } else if (status == "created") {
            isSubscribed = false;
            subscriptionStatus = "In Progress";
          } else if (status == "active") {
            isSubscribed = true;
            subscriptionStatus = "Active";
          } else {
            // fallback — treat as Active
            isSubscribed = true;
            subscriptionStatus = "Active";
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Donation Order Details Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> cancelSubscription() async {
    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "id": "${donationOrderDetails?.data?.subscriptionId}"
    };

    try {
      final res =
          await HttpService().postApi(AppConstants.donationSubsCancalUrl, data);

      if (res != null && res["status"] == 1) {
        // ✅ API success
        // setState(() {
        //   isSubscribed = false;
        // });

        getOrderDetails();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(res["message"] ?? "Subscription cancelled successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res?["message"] ?? "Failed to cancel subscription"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      print("❌ Error in Cancel Subscription: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _formatDate(String dateString) {
    try {
      final inputFormat = DateFormat('dd-MM-yyyy hh:mm:ss a');
      final outputFormat = DateFormat('MMMM dd, yyyy hh:mm a');
      final date = inputFormat.parse(dateString);
      return outputFormat.format(date);
    } catch (e) {
      return dateString;
    }
  }

   String? donationInvoicePath;
   String invoicePdfUrl = "";

  /// Fetch Donation Invoice
   Future<void> fetchDonationInvoice(
      BuildContext context, String invoiceId, String userToken) async {
     invoicePdfUrl = AppConstants.baseUrl + AppConstants.donationInvoiceUrl + invoiceId;

    print("Donation api url ${invoicePdfUrl}");

    try {
      Response response = await Dio().get(
        invoicePdfUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "Authorization": "Bearer $userToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        final pdfBytes = List<int>.from(response.data);

        // Validate PDF
        if (!String.fromCharCodes(pdfBytes).startsWith('%PDF')) {
          throw Exception("Invalid PDF file received");
        }

        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/donation_invoice_$invoiceId.pdf';

        File file = File(filePath);
        await file.writeAsBytes(pdfBytes, flush: true);

        donationInvoicePath = filePath;
        print("Saved at: $donationInvoicePath");
        print("File size: ${file.lengthSync()} bytes");

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //       content: Text("Invoice downloaded successfully!"),
        //       backgroundColor: Colors.green),
        // );
      } else {
        throw Exception("HTTP ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching invoice: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to fetch invoice"),
            backgroundColor: Colors.red),
      );
    }
  }

  /// Open Donation Invoice
   Future<void> openDonationInvoice(BuildContext context) async {
    if (donationInvoicePath == null ||
        !File(donationInvoicePath!).existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please download the invoice first!"),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    print("Invoice Donation$donationInvoicePath");
    print("Invoice Url$invoicePdfUrl");

    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => InvoiceViewer(
    //       pdfPath: donationInvoicePath ?? "",
    //       invoiceUrl: '$invoicePdfUrl',
    //     ),
    //   ),
    // );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFFFF5E6),
      backgroundColor: Colors.white,
      body: isLoading
          ? MahakalLoadingData(onReload: () {})
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context),
                    _buildSuccessCard(_formatDate(donationOrderDetails!.data!.date), context),
                    if(donationOrderDetails!.data!.information.isNotEmpty) _buildDonationDetails(context),
                    _buildThankYou(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE96B29), Color(0xFFFF8C42)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              top: 20,
              left: 20,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ))),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'धन्यवाद',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Hind',
                  ),
                ),
                Text(
                  'Your Donation is Successful',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              'ॐ',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(String formattedDate, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFFFF5E6),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header
                Column(
                  children: [
                    const Text(
                      'दान सफल',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE96B29),
                        fontFamily: 'Hind',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Donation Successful',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Amount Display - Centerpiece
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber[100]!,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFE96B29).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'आपका दान',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontFamily: 'Hind',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        donationOrderDetails?.data?.amount != null
                            ? '₹${donationOrderDetails!.data!.amount}'
                            : 'N/A',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: donationOrderDetails?.data?.amount != null
                              ? const Color(0xFFE96B29)
                              : Colors.grey,
                          fontFamily: 'Hind',
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Details Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE96B29).withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                          'रसीद संख्या',
                          donationOrderDetails?.data?.orderId != null
                              ? donationOrderDetails!.data!.orderId
                              : "N/A"),
                      Divider(height: 24, color: Colors.grey[200]),
                      _buildDetailRow('तारीख', formattedDate),
                      Divider(height: 24, color: Colors.grey[200]),
                      _buildDetailRow(
                          'संस्था',
                          donationOrderDetails?.data?.hiAdsName != null
                              ? donationOrderDetails!.data!.hiAdsName
                              : "N/A"),
                      Divider(height: 24, color: Colors.grey[200]),
                      donationOrderDetails?.data?.frequency?.toLowerCase() ==
                              "one_time"
                          ? SizedBox.shrink()
                          : Stack(
                              children: [
                                // Card background
                                Container(
                                  width: 320,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      donationOrderDetails?.data?.frequency
                                                  ?.toLowerCase() ==
                                              "one_time"
                                          ? const SizedBox
                                              .shrink() // hide text completely
                                          : Text(
                                              "${donationOrderDetails?.data?.frequency.toUpperCase()}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                      const SizedBox(height: 10),

                                      //  Subscription Status Badge
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              subscriptionStatus == "Cancelled"
                                                  ? Colors.red.shade600
                                                  : subscriptionStatus ==
                                                          "In Progress"
                                                      ? Colors.amber.shade600
                                                      : Colors.green.shade600,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              subscriptionStatus == "Cancelled"
                                                  ? Icons.cancel
                                                  : subscriptionStatus ==
                                                          "In Progress"
                                                      ? Icons.hourglass_top
                                                      : Icons.verified,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              subscriptionStatus,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      if (subscriptionStatus == "Active")
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 28, vertical: 12),
                                          ),
                                          onPressed: () async {
                                            await cancelSubscription();

                                            // 🧠 After successful cancel API, update UI
                                            setState(() {
                                              isSubscribed = false;
                                              subscriptionStatus = "Cancelled";
                                            });
                                          },
                                          child: const Text(
                                            "Cancel Subscription",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      else
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                subscriptionStatus ==
                                                        "Cancelled"
                                                    ? Colors.grey
                                                    : Colors.amber.shade600,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 28, vertical: 12),
                                          ),
                                          onPressed: null, // disabled
                                          child: Text(
                                            subscriptionStatus == "Cancelled"
                                                ? "Subscription Cancelled"
                                                : "Processing Your Subscription",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          openDonationInvoice(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE96B29),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFFE96B29)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt, size: 20),
                            SizedBox(width: 8),
                            Text('रसीद'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    donationOrderDetails?.data?.ertigaCertificate == ""
                        ? SizedBox()
                        : Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Download certificate
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => CertificateViewScreen(
                                      certificateImageUrl: donationOrderDetails
                                              ?.data?.ertigaCertificate ??
                                          "N/A",
                                      issuedDate: '',
                                      certificateShareMessage:
                                          '🌟 आपका प्रमाण पत्र 🌟\n\n'
                                          'यह प्रमाण पत्र Mahakal.com ऐप द्वारा आपके पावन दान के लिए सम्मानपूर्वक प्रदान किया जाता है। 🔱💖\n'
                                          'आपका यह पुण्य कार्य **शिव सेवा** का एक अनमोल योगदान है।\n'
                                          'महादेव की कृपा सदैव आप पर बनी रहे। 🙏\n'
                                          'हर हर महादेव! 🕉️',
                                      serviceType: 'Donation',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE96B29),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified, size: 20),
                                  SizedBox(width: 8),
                                  Text('प्रमाणपत्र'),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontFamily: 'Hind',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildThankYou() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'ॐ',
            style: TextStyle(fontSize: 40, color: Color(0xFFE96B29)),
          ),
          const SizedBox(height: 10),
          const Text(
            'Thank you for your generous donation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE96B29),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Your contribution helps us continue our seva',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDonationDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with decorative divider
                  const Row(
                    children: [
                      Icon(Icons.verified, color: Color(0xFFE96B29), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Donation Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE96B29),
                          fontFamily: 'Hind',
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: const Color(0xFFE96B29).withOpacity(0.3),
                    thickness: 1,
                    height: 20,
                  ),

                  ListView.builder(
                    itemCount: donationOrderDetails!.data!.information.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item =
                          donationOrderDetails!.data!.information[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                // Product Image Placeholder
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.amber.shade200),
                                  ),
                                  child: item.image != null &&
                                          item.image.isNotEmpty &&
                                          item.image != " "
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            item.image,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(
                                                Icons.shopping_bag,
                                                color: Colors.amber,
                                                size: 30,
                                              );
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.shopping_bag,
                                            color: Colors.amber,
                                            size: 30,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.amber.shade800,
                                        ),
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade50,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Quantity: ${item.qty}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total:',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '₹${item.fullamount}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.amber.shade900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Decorative Footer
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CertificateViewScreen extends StatefulWidget {
  final String certificateImageUrl;
  final String issuedDate;
  final String certificateShareMessage;
  final String serviceType;

  const CertificateViewScreen(
      {super.key,
        required this.certificateImageUrl,
        required this.issuedDate,
        required this.certificateShareMessage,
        required this.serviceType});

  @override
  State<CertificateViewScreen> createState() => _CertificateViewScreenState();
}

class _CertificateViewScreenState extends State<CertificateViewScreen> {
  String? imagePath;
  bool isLoading = true;
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchCertificateImage();
    userName =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
  }

  /// **Download Image and Save Locally**
  Future<void> _fetchCertificateImage() async {
    if (widget.certificateImageUrl.isEmpty) {
      print('Certificate URL is empty');
      return;
    }

    try {
      final response = await http.get(Uri.parse(widget.certificateImageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        String tempImagePath = '${directory.path}/certificate.png';

        final file = File(tempImagePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          imagePath = tempImagePath;
          isLoading = false;
        });

        print("Certificate downloaded at: $imagePath");
      } else {
        print('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching certificate image: $e');
    }
  }

  void shareCertificate() async {
    if (imagePath != null) {
      // Get configuration from SplashController
      // final splashController = Provider.of<SplashController>(context, listen: false);
      //
      // // Default URLs
      // String androidUrl = '';
      // String iosUrl = '';
      //
      // // Get URLs from SplashController (if available)
      // androidUrl = splashController.configModel?.userAppVersionControl?.forAndroid?.link ?? androidUrl;
      // iosUrl = splashController.configModel?.userAppVersionControl?.forIos?.link ?? iosUrl;
      //
      // // Create combined app links block
      // String appLinks = "\n\n"
      //     "🔹 **Android:** $androidUrl\n"
      //     "🔹 **IOS:** $iosUrl";

      String shareUrl = '';
      shareUrl = "${AppConstants.baseUrl}/download";

      // Default message
      String defaultMessage = "🌟 **आपका प्रमाण पत्र** 🌟\n"
          "यह प्रमाण पत्र Mahakal.com ऐप द्वारा आयोजित पूजा में भागीदारी के लिए दिया गया है। 🔱💖\n"
          "आपका आभार! 🙏\n"
          "अभी डाउनलोड करें और पुण्य लाभ प्राप्त करें! 📲🙏"
          "Download App Now: $shareUrl";

      // Use dynamic message if provided, else fallback to default
      String shareMessage = widget.certificateShareMessage ?? defaultMessage;

      // Replace {appUrl} placeholder if it exists in dynamic message
      shareMessage = shareMessage.replaceAll('{appUrl}', shareUrl);

      // Share the image with message
      await Share.shareXFiles(
        [XFile(imagePath!)],
        text: shareMessage,
      );
    } else {
      print('Image not available for sharing');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Certificate image not available for sharing')),
      );
    }
  }


  String? formatDate(String apiDate) {
    if (apiDate.isEmpty) return null;
    try {
      DateTime dateTime = DateTime.parse(apiDate.split('.').first);
      return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
    } catch (e) {
      print("Date parsing error: $e");
      return null;
    }
  }


  /// **Download Certificate to Device Storage**
  Future<void> _downloadCertificate(
      BuildContext context, String imageUrl) async {
    FileDownloader.downloadFile(
      url: imageUrl,
      onDownloadCompleted: (path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Download Successfully!',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // String formattedDate = formatDate(widget.issuedDate);
    String? formattedDate = formatDate(widget.issuedDate);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          //"${widget.issuedDate}",
          '🎖 Certificate of Honor',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Certificate Image with Glassmorphism Effect
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.certificateImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child:
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Name
            Text(
              "🏅 Congratulations, $userName!",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

            if (formattedDate != null)
              Text(
                '📅 Issued on: $formattedDate',
                style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey),
              ),

            // Certificate Issued Date
            //Text(
            //   '📅 Issued on: $formattedDate',
            //   style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
            // ),
            const SizedBox(height: 10),

            // Certificate Description

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  children: [
                    TextSpan(
                        text:
                        '🎊 You have been awarded this certificate for your dedicated involvement in the ${widget.serviceType}, facilitated by ',
                        style: const TextStyle(fontWeight: FontWeight.w300)),
                    const TextSpan(
                      text: 'Mahakal.com',
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    const TextSpan(
                        text:
                        '.\n\n🙏 May Lord Mahakal bless you with wisdom and prosperity!'),
                  ],
                ),
              ),
            ),

            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   margin: const EdgeInsets.symmetric(horizontal: 20),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.amber.withOpacity(0.2),
            //         blurRadius: 8,
            //         offset: const Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: const Text(
            //     '🎊 You have been awarded this certificate for your dedicated involvement in the Pooja Ceremony, facilitated by Mahakal.com.\n\n🙏 May Lord Mahakal bless you with wisdom and prosperity!',
            //     style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 16),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            const SizedBox(height: 20),

            // Download & Share Buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.amber.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _downloadCertificate(
                            context, widget.certificateImageUrl),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download, color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text('Download\nCertificate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.amber.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: shareCertificate,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text('Share\nCertificate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Closing Message
            const Text(
              "✨ Thank you for being a part of this spiritual journey! ✨",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}