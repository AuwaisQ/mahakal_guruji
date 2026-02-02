import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import '../../main.dart';
import '../../utill/app_constants.dart';
import '../../utill/razorpay_screen.dart';
import '../profile/controllers/profile_contrroller.dart';
import 'Counselling_Form_Submit.dart';
import 'Model/all_pandit_counsdetails.dart';
import 'Model/all_pandit_counslead.dart';
import 'Model/all_pandit_counsseccess.dart';
import 'Model/all_pandit_success_model.dart';

class PanditCounsellingDetails extends StatefulWidget {

  String gurujiId;
  String slug;

   PanditCounsellingDetails({super.key,required this.gurujiId,required this.slug});

  @override
  State<PanditCounsellingDetails> createState() => _PanditCounsellingDetailsState();
}

class _PanditCounsellingDetailsState extends State<PanditCounsellingDetails> {

  final razorpayService = RazorpayPaymentService();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool isExpanded = false;
  int activeIndex = 0;
  bool isLoading = true;

  AllPanditCounsDetailModel? allPanditCounsellingData;
  AllPanditCounsLead? allPanditCounslead;

  String userId = "";
  String userNAME = "";
  String userEMAIL = "";
  String userPHONE = "";

  @override
  void initState() {
    super.initState();
    fetchCounsellingDetails();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    userNAME = Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    userEMAIL = Provider.of<ProfileController>(Get.context!, listen: false).userEMAIL;
    userPHONE = Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
  }

  Future<void> fetchCounsellingDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      String  url = "${AppConstants.allPanditCounsellingUrl}${widget.gurujiId}&slug=${widget.slug}";
      final res = await HttpService().getApi(url);

      print("All Pandit Counselling Data $res");

      if (res != null) {
        final allCounsellingData = AllPanditCounsDetailModel.fromJson(res);

        setState(() {
          allPanditCounsellingData = allCounsellingData;
          isLoading = false;
        });
        print("${allPanditCounsellingData}");
      } else {
        print("Response is null");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("fetching new vendor $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> updateLead(bool isSuccess, String paymentId) async {
  //
  //   final Map<String, dynamic> data = {
  //     "service_id": "${allPanditCounsellingData?.counselling?.counsellingPackage?.serviceId}",
  //     "guruji_id": "${allPanditCounsellingData?.counselling?.counsellingPackage?.panditId}",
  //     "final_amount": "${allPanditCounsellingData?.counselling?.counsellingPackage?.price}",
  //     "payment_id": isSuccess ? "$paymentId" : "wallet"
  //   };
  //
  //   print("Lead Req Data: $data");
  //
  //   try {
  //     final res = await HttpService().postApi("${AppConstants.allPanditCounsellingLeadUrl}", data);
  //     print("Lead Update Data: $res");
  //
  //     if (res['status'] == true) {
  //       allPanditCounslead = AllPanditCounsLead.fromJson(res);
  //       print("Lead Id: ${allPanditCounslead?.orderId}");
  //
  //       if (isSuccess) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           print("Navigation Complete via context");
  //           Navigator.push(
  //             context,
  //             CupertinoPageRoute(builder: (_) =>  CounsellingFormWidget(orderId: '${allPanditCounslead?.orderId}',)),
  //           );
  //         });
  //       }
  //     } else {
  //       print("Lead update failed: ${res['message']}");
  //     }
  //   } catch (e) {
  //     print("Error in Lead Data: $e");
  //   } finally {
  //   }
  // }

  bool _isNavigatingAfterPayment = false;

  Future<void> updateLead(bool isSuccess, String paymentId) async {
    // Only show loading if it's coming from payment success
    if (isSuccess) {
      setState(() {
        _isNavigatingAfterPayment = true;
      });
    }

    final Map<String, dynamic> data = {
      "service_id": "${allPanditCounsellingData?.counselling?.counsellingPackage?.serviceId}",
      "guruji_id": "${allPanditCounsellingData?.counselling?.counsellingPackage?.panditId}",
      "final_amount": "${allPanditCounsellingData?.counselling?.counsellingPackage?.price}",
      "payment_id": isSuccess ? "$paymentId" : "wallet"
    };

    print("Lead Req Data: $data");

    try {
      final res = await HttpService().postApi("${AppConstants.allPanditCounsellingLeadUrl}", data);
      print("Lead Update Data: $res");

      if (res['status'] == true) {
        allPanditCounslead = AllPanditCounsLead.fromJson(res);
        print("Lead Id: ${allPanditCounslead?.orderId}");

        if (isSuccess) {
          // Stop loading before navigation
          setState(() {
            _isNavigatingAfterPayment = false;
          });

          // Small delay to ensure UI updates
          //await Future.delayed(Duration(milliseconds: 50));

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => CounsellingFormWidget(
                orderId: '${allPanditCounslead?.orderId}',
              ),
            ),
          );
        }
      } else {
        print("Lead update failed: ${res['message']}");
        if (isSuccess) {
          setState(() {
            _isNavigatingAfterPayment = false;
          });
        }
      }
    } catch (e) {
      print("Error in Lead Data: $e");
      if (isSuccess) {
        setState(() {
          _isNavigatingAfterPayment = false;
        });
      }
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.deepOrange.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Booking Confirmation",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 40,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// SERVICE NAME
                Text(
                  allPanditCounsellingData?.counselling?.name ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                /// BOOKING INFO
                _infoRow(
                  "Booking Date",
                  DateFormat('dd MMMM, EEEE').format(DateTime.now()),
                ),
                _infoRow(
                  "Guruji",
                  allPanditCounsellingData?.guruji?.name ?? "",
                ),

                const SizedBox(height: 20),

                /// CUSTOMER SECTION
                Text(
                  "Customer Details",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade700,
                  ),
                ),

                const SizedBox(height: 12),

                _infoRow("Name", userNAME),
                _infoRow("Mobile", userPHONE),
                _infoRow(
                  "Total Amount",
                  "₹${allPanditCounsellingData?.counselling?.counsellingPackage?.price}",
                  isHighlight: true,
                ),

                const SizedBox(height: 20),

                /// ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          razorpayService.openCheckout(
                            amount: int.parse("${allPanditCounsellingData!.counselling!.counsellingPackage!.price}",),
                            razorpayKey: AppConstants.razorpayLive,
                            description: 'All Pandit Counselling',
                            onSuccess: (response) {
                              updateLead(true, response.paymentId ?? "");
                            },
                            onFailure: (response) {
                              debugPrint("Payment Failed");
                            },
                            onExternalWallet: (response) {
                              debugPrint("Wallet: ${response.walletName}");
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Confirm & Pay",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
    );
  }

// Helper for cleaner rows
  Widget _infoRow(
      String label,
      String value, {
        bool isHighlight = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Label
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isHighlight
                  ? Colors.deepOrange.shade700
                  : Colors.black87,
            ),
          ),

          const SizedBox(width: 8),

          /// Value
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isHighlight ? 15 : 14,
                fontWeight:
                isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight
                    ? Colors.deepOrange
                    : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.orange))) : Scaffold(
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Row(
              children: [
                // iOS Style Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 22,
                  ),
                ),

                const Expanded(
                  child: Center(
                    child: Text(
                      "Counselling Details",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 48), // Balance for center title
              ],
            ),
          ),
        ),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// Left Side - Service Charge
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Service Charge",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹ ${allPanditCounsellingData!.counselling!.counsellingPackage!.price} /-",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /// Space between left & right
              const Spacer(),

              /// Right Side - Buttons
              Row(
                children: [
                  // BACK BUTTON
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    label: const Text(
                      "Back",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // NEXT BUTTON
                  ElevatedButton.icon(
                    onPressed: () {
                      updateLead(false, "");
                      showConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

        ),
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ============ SLIDER ===============
              Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: allPanditCounsellingData?.images.length,
                    options: CarouselOptions(
                      height: 180,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 900),
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        setState(() => activeIndex = index);
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            allPanditCounsellingData!.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),

                  AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: allPanditCounsellingData!.images.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 5,
                      dotWidth: 5,
                      activeDotColor: Colors.deepOrange,
                      dotColor: Colors.grey.shade400,
                    ),
                  ),

                  SizedBox(height: 12),
                ],
              ),

              /// ==========  POOJA DETAILS ==============
              StatefulBuilder(
                builder: (context, setState) {
                  return AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange.shade100,
                            Colors.deepOrange.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrange.shade100.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// DESCRIPTION
                          Text(
                            "${allPanditCounsellingData?.counselling?.metaDescription}",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),

                          SizedBox(height: 12),

                          /// RATINGS + ARROW
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 30,
                                child: Stack(
                                  children: List.generate(
                                    5,
                                        (index) => Positioned(
                                      left: index * 18.0,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                          "https://i.pravatar.cc/50?img=${index + 1}",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 8),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),

                              Text(
                                "4.8 (250 ratings)",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              Spacer(),

                              GestureDetector(
                                onTap: () => setState(() => isExpanded = !isExpanded),
                                child: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 26,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),

                          if (isExpanded) ...[
                            SizedBox(height: 10),

                            Text(
                              "${allPanditCounsellingData?.counselling?.name}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange.shade800,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "${allPanditCounsellingData?.counselling?.metaTitle}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.black54),
                                SizedBox(width: 4),
                                Text(
                                  "${allPanditCounsellingData?.counselling?.name}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              ),


              // Loading overlay ONLY for post-payment navigation
              // Loading overlay ONLY for post-payment navigation
              if (_isNavigatingAfterPayment)
                Container(
                  child: Center(
                    child: Container(
                      // White card in center
                      width: 280,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Spinner
                          CircularProgressIndicator(
                            color: Colors.deepOrange,
                            strokeWidth: 4,
                          ),

                          SizedBox(height: 20),

                          // Title
                          Text(
                            'Please wait...',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),

                          SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'Preparing your counselling form',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 10),

                        ],
                      ),
                    ),
                  ),
                ),

            ],
          ),
        )
    );
  }
}



