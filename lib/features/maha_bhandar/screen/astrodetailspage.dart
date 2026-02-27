import 'dart:convert';
import 'dart:math';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/maha_bhandar/model/astro_reviews_model.dart';
import 'package:mahakal/features/maha_bhandar/model/consultation_model.dart';
import 'package:mahakal/features/maha_bhandar/screen/askquestions.dart';
import 'package:mahakal/features/maha_bhandar/screen/information.dart';
import 'package:mahakal/features/maha_bhandar/screen/shubhmuhuratmodel.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import '../../../main.dart';
import '../../../utill/devotees_count_widget.dart';
import '../../../utill/loading_datawidget.dart';
import '../../../utill/razorpay_screen.dart';
import '../../profile/controllers/profile_contrroller.dart';
import 'package:http/http.dart' as http;

class AstroDetailsView extends StatefulWidget {
  final dynamic productId;
  final bool isProduct;
  const AstroDetailsView(
      {super.key, required this.productId, required this.isProduct});

  @override
  State<AstroDetailsView> createState() => _AstroDetailsViewState();
}

class _AstroDetailsViewState extends State<AstroDetailsView> {
  @override
  void initState() {
    super.initState();
    print("Counselling Id or Slug is ${widget.productId}");
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    userNAME =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    userEMAIL =
        Provider.of<ProfileController>(Get.context!, listen: false).userEMAIL;
    userPHONE =
        Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
    getDetails();
    getConsultaionData();
    getMuhuratData();
  }

  final PageController _pageController = PageController();
  final CarouselSliderController carouselController =
      CarouselSliderController();
  var currentIndex = 0;
  double walletPay = 0.0;
  double walletMinusAmount = 0.0;
  double finalAmount = 0.0;
  int readAll = 2;
  int count = 0;
  bool isLoading = false;
  bool translateBtn = true;
  bool cicularIndicator = false;
  bool readalltrue = false;
  String serviceId = "";
  String thumbnail = "";
  String productNameEn = "";
  String productNameHi = "";
  int sellingPrice = 0;
  String mainPrice = "";
  String detailsEn = "";
  String detailsHi = "";
  String processEn = "";
  String processHi = "";
  String orderIdPooja = "";
  String leadId = "";
  String userId = "";
  String userNAME = "";
  String userEMAIL = "";
  String userPHONE = "";

  List<String> imageList = [];
  final razorpayService = RazorpayPaymentService();
  int highestRating = 0;

  List<Muhurat> muhuratModelList = <Muhurat>[];
  List<Astroconsultant> consultaionModelList = <Astroconsultant>[];

  List<Astrologyreview> reviewAstroModelList = <Astrologyreview>[];

  void getReviewData(String id) async {
    print("name of url $id");
    var res =
        await HttpService().getApi(AppConstants.consultancyReviewsUrl + id);
    if (res["status"]) {
      setState(() {
        reviewAstroModelList.clear();
        List reviewList = res["review"];
        reviewAstroModelList
            .addAll(reviewList.map((e) => Astrologyreview.fromJson(e)));
        // Get the highest rating
        highestRating = reviewAstroModelList
            .map((e) => e.rating)
            .reduce((a, b) => a > b ? a : b);
      });
      print(
          "all print review lenght ${reviewAstroModelList.length} $highestRating");
    }
  }

  void getConsultaionData() async {
    var res = await HttpService().getApi(AppConstants.consultaionUrl);
    if (res["status"] == 200) {
      setState(() {
        consultaionModelList.clear();
        List consultationList = res['data'];
        consultaionModelList
            .addAll(consultationList.map((e) => Astroconsultant.fromJson((e))));
      });
      print(res);
    } else {
      print("Failed Api Response");
    }
    setState(() {});
  }

  void getMuhuratData() async {
    var res = await HttpService().getApi(AppConstants.shubhmuhuratUrl);
    if (res["status"] == 200) {
      setState(() {
        muhuratModelList.clear();
        List shubhmuhuratList = res['data'];
        muhuratModelList
            .addAll(shubhmuhuratList.map((e) => Muhurat.fromJson(e)));

        // Assuming each Muhurat has an "images" list, save the first image
        // if (shubhmuhuratList.isNotEmpty && shubhmuhuratList[0]["images"].isNotEmpty) {
        //   firstImageUrl = shubhmuhuratList[0]["images"][0];
        // }
      });
      print(res);
    } else {
      print("Failed Api Response");
    }
  }

  void walletAmount() async {
    var res = await HttpService().getApi(AppConstants.poojaWalletUrl + userId);
    print(res);
    if (res["success"]) {
      setState(() {
        walletPay = double.parse(res["wallet_balance"].toString());
        // Calculate walletMinusAmount and finalAmount
        walletMinusAmount = max(walletPay - sellingPrice, 0);
        finalAmount = (walletPay - sellingPrice).abs();
        print(walletMinusAmount);
        print(finalAmount);
        isLoading = false;
      });
    }
  }

  Future<void> getLeadSave() async {
    // Define the API endpoint
    const String apiUrl =
        AppConstants.baseUrl + AppConstants.counslingLeadStoreUrl;

    // Create the data payload
    Map<String, dynamic> data = {
      "service_id": serviceId,
      "type": "counselling",
      "package_price": "$sellingPrice",
      "person_phone": userPHONE,
      "person_name": userNAME,
    };

    // Make the POST request
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if ([200, 201].contains(response.statusCode)) {
        // Handle success
        print('Booking successful pooja ');
        // Optionally, parse the response
        print(response.body);
        setState(() {
          var responseData = jsonDecode(response.body);
          leadId = responseData['lead']['id'].toString();
          print(">> print lead api $leadId");
          showCouponSheet();
          isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to book pooja: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Handle exception
      print('An error occurred: $e');
    }
  }

  void oderPlacePooja(String payId) async {
    int transactionAmount =
        (finalAmount - sellingPrice.toDouble()).abs().toInt();
    String walletBalance =
        walletMinusAmount == 0 ? "$transactionAmount" : "$sellingPrice";
    var res = await HttpService().postApi(AppConstants.poojaOrderPlaceUrl, {
      "customer_id": userId,
      "service_id": serviceId,
      "type": "counselling",
      "leads_id": leadId,
      "package_id": "",
      "package_price": "",
      "booking_date": "",
      "coupon_amount": "",
      "coupon_code": "",
      "payment_id": payId,
      "payment_amount": "$sellingPrice",
      "transection_amount": walletMinusAmount == 0 ? "$finalAmount" : "0",
      "wallet_balance": "$walletMinusAmount",
      "balance": "$walletMinusAmount",
      "debit": walletBalance
    });
    print(sellingPrice);
    print(walletMinusAmount == 0 ? "$finalAmount" : "0");
    print(walletBalance);
    print(walletMinusAmount);
    print(sellingPrice);
    print("Api response data counseeling $res");
    setState(() {
      orderIdPooja = res['order_id'];
      isLoading = false;
    });
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => InformationView(
                  orderId: orderIdPooja,
                )));
    walletAmount();
  }

  void getDetails() async {
    var res = await HttpService()
        .getApi("${AppConstants.consultationDetailUrl}${widget.productId}");
    if (res["status"] == 200) {
      setState(() {
        serviceId = res["data"]["id"].toString();
        thumbnail = res["data"]["thumbnail"];
        productNameHi = res["data"]["hi_name"];
        productNameEn = res["data"]["en_name"];
        detailsHi = res["data"]["hi_details"];
        detailsEn = res["data"]["en_details"];
        processHi = res["data"]["hi_process"];
        processEn = res["data"]["en_process"];
        mainPrice = res["data"]["counselling_main_price"].toString();
        sellingPrice = res["data"]["counselling_selling_price"];
        count = res["data"]["count"];
        imageList = List<String>.from(res["data"]["images"]);
      });
      print("app response ---->  ${widget.productId} -- $res");
      print("$userId $serviceId $sellingPrice");
      getReviewData(serviceId);
    } else {
      print("Failed Api Response");
    }
  }

  void showCouponSheet() {
    showMaterialModalBottomSheet(
        backgroundColor: Colors.transparent,
        expand: false,
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter modalSetter) {
              return Container(
                height: 450, // Adjust height as needed
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, blurRadius: 4.0, spreadRadius: 2)
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      height: 3,
                      width: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
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
                          // Header
                          Row(
                            children: [
                              Icon(Icons.receipt_long_rounded,
                                  color: Colors.orange.shade600, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                "Bill Details",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto',
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Wallet Balance
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_wallet_rounded,
                                    size: 18, color: Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Wallet Balance",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹$walletPay",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Total
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.shopping_bag_rounded,
                                    size: 18, color: Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹$sellingPrice.0",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                              height: 24,
                              thickness: 1,
                              color: Colors.grey.shade200),

                          // Wallet Remaining
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const SizedBox(
                                    width: 26), // To align with items above
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                      children: [
                                        const TextSpan(
                                            text: "Wallet remaining ("),
                                        TextSpan(
                                          text: "₹$walletMinusAmount",
                                          style: TextStyle(
                                            color: Colors.green.shade600,
                                          ),
                                        ),
                                        const TextSpan(text: ")"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Amount Paid via Wallet
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(Icons.payment_rounded,
                                    size: 18, color: Colors.grey.shade600),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Amount Paid (via Wallet)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Text(
                                  walletMinusAmount == 0
                                      ? "- ₹$walletPay"
                                      : "- ₹$sellingPrice.0",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                              height: 24,
                              thickness: 1,
                              color: Colors.grey.shade200),

                          // Total Amount
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text(
                                    "Total Amount",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    walletMinusAmount == 0
                                        ? "₹$finalAmount"
                                        : "₹0.0",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Information Box
                          // Container(
                          //   width: double.infinity,
                          //   padding: EdgeInsets.all(12),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8),
                          //     color: Colors.orange.shade50,
                          //     border: Border.all(
                          //       color: Colors.orange.shade100,
                          //       width: 1,
                          //     ),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.info_outline_rounded,
                          //           color: Colors.orange.shade600, size: 20),
                          //       SizedBox(width: 8),
                          //       Expanded(
                          //         child: Text(
                          //           "Name & Address will be asked after Payment",
                          //           style: TextStyle(
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w500,
                          //             color: Colors.orange.shade800,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    walletMinusAmount == 0
                        ? InkWell(
                            onTap: () {
                              getLeadSave();
                              // Navigator.push(context, CupertinoPageRoute(builder: (context) => const InformationView()));
                              razorpayService.openCheckout(
                                amount: finalAmount, // ₹100
                                razorpayKey: AppConstants.razorpayLive,
                                onSuccess: (response) {
                                  setState(() {
                                    cicularIndicator = true;
                                  });
                                  oderPlacePooja("${response.paymentId}");
                                },
                                onFailure: (response) {
                                  setState(() {
                                    cicularIndicator = false;
                                  });
                                },
                                onExternalWallet: (response) {
                                  print("Wallet: ${response.walletName}");
                                },
                                description: 'Astrology',
                              );
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(6.0)),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.book_online,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Pay Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              modalSetter(() {
                                isLoading ? null : oderPlacePooja("pay_wallet");
                                isLoading = true;
                                print("user id $userId");
                                print("service id $serviceId");
                                print("lead $leadId");
                                print("sell price $sellingPrice");
                                print("w amount $walletMinusAmount");
                                print("w amount $walletMinusAmount");
                                print("sell price $sellingPrice");
                              });
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(6.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          " Pay Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            })).whenComplete(() {
      // Clear text fields when the bottom sheet is closed
      isLoading = false;
    });
  }

  String formatDateString(String dateString) {
    // Parse the input date string to a DateTime object
    DateTime parsedDate = DateTime.parse(dateString);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('dd-MMMM-yyyy').format(parsedDate);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return thumbnail.isEmpty
        ? MahakalLoadingData(onReload: () {
            getDetails();
            getConsultaionData();
            getMuhuratData();
            getReviewData("${serviceId}");
          })
        : Scaffold(
            floatingActionButton: InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                walletAmount();
                getLeadSave();
                print("amount checker $finalAmount -- $sellingPrice}");
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(6.0)),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_online,
                            color: Colors.white,
                          ),
                          Text(
                            " Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              actions: [
                BouncingWidgetInOut(
                  onPressed: () {
                    setState(() {
                      translateBtn = !translateBtn;
                    });
                  },
                  bouncingType: BouncingType.bounceInAndOut,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: translateBtn ? Colors.white : Colors.orange,
                        border: Border.all(color: Colors.orange, width: 2)),
                    child: Center(
                      child: Icon(Icons.translate,
                          color: translateBtn ? Colors.orange : Colors.white),
                    ),
                  ),
                ),
              ],
              title: const Text(
                "Details",
                style: TextStyle(color: Colors.orange),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: cicularIndicator
                ? MahakalLoadingData(onReload: () {})
                : SafeArea(
                    child: Stack(
                      children: [
                        CarouselSlider(
                          items: imageList
                              .map(
                                (item) => Image.network(
                                  item,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              )
                              .toList(),
                          carouselController: carouselController,
                          options: CarouselOptions(
                            height: 260,
                            scrollPhysics: const BouncingScrollPhysics(),
                            autoPlay: true,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.only(top: 240),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)),
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: 2,
                                    width: 80,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      translateBtn
                                          ? productNameHi
                                          : productNameEn,
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.024,
                                          color: Colors.orange),
                                    ),
                                    const Spacer(),
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: '₹$sellingPrice ',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                      TextSpan(
                                          text: ' ₹$mainPrice',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                    ])),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const DevoteeAvatarStack(),
                                const SizedBox(
                                  height: 6,
                                ),
                                translateBtn
                                    ? Text.rich(
                                        TextSpan(
                                          text: '',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  ' ${count + 100}+ संतुष्ट ग्राहकों ने Mahakal.com',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                  fontSize: 16),
                                            ),
                                            const TextSpan(
                                              text:
                                                  ' पर भरोसा किया है, अपनी परामर्श रिपोर्ट प्राप्त की है और बेहतर भविष्य के लिए महत्वपूर्ण मार्गदर्शन पाया है!',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                      )
                                    : Text.rich(
                                        TextSpan(
                                          text: 'Over',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' ${count + 100}+',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                  fontSize: 16),
                                            ),
                                            const TextSpan(
                                              text:
                                                  ' satisfied customers have trusted',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            const TextSpan(
                                              text: ' Mahakal.com',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                  fontSize: 16),
                                            ),
                                            const TextSpan(
                                              text:
                                                  ' for their consultancy reports and gained valuable guidance for a better future!',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                // Row(
                                //   children: [
                                //     Text.rich(
                                //       TextSpan(
                                //         children: [
                                //           TextSpan(text:"$highestRating",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 35,fontFamily: 'Roboto',color: Color.fromRGBO(0, 0, 0, 1))),
                                //           TextSpan(
                                //             text: '/',
                                //             style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color: Color.fromRGBO(0, 0, 0, 1)),
                                //           ),
                                //           TextSpan(text: ' 5',style: TextStyle(color: Color.fromRGBO(176, 176, 176, 1),fontSize: 20)),
                                //         ],
                                //       ),
                                //     ),
                                //     Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: List.generate(
                                //         5,
                                //             (index) => Icon(
                                //           Icons.star,
                                //           color: index < highestRating ? Colors.amber : Colors.grey,
                                //           size: 25,
                                //         ),
                                //       ),
                                //     ),
                                //     // RatingBar.builder(
                                //     //   initialRating: highestRating,
                                //     //   minRating: 1,
                                //     //   direction: Axis.horizontal,
                                //     //   allowHalfRating: true,
                                //     //   itemCount: 5,
                                //     //   maxRating: 5,
                                //     //   itemPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                //     //   itemBuilder: (context, _) => Icon(
                                //     //     Icons.star,
                                //     //     color: Colors.amber,
                                //     //   ),
                                //     //   onRatingUpdate: (value) {
                                //     //     setState(() {
                                //     //       highestRating = value;
                                //     //     });
                                //     //   },
                                //     // ),
                                //   ],
                                // ),

                                Divider(
                                  color: Colors.grey.shade200,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: Colors.blue.shade400,
                                            width: 1.5)),
                                    child: Html(
                                      data:
                                          translateBtn ? detailsHi : detailsEn,
                                      style: {
                                        "p": Style(
                                          fontSize: FontSize(16),
                                        ),
                                      },
                                    )),

                                Html(
                                  data: translateBtn ? processHi : processEn,
                                  style: {
                                    "p": Style(
                                      fontSize: FontSize(16),
                                    ),
                                  },
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Container(
                                    //       height: 20,
                                    //       width: 3,
                                    //       color: Colors.orange,
                                    //     ),
                                    //     const SizedBox(width: 5),
                                    //     const Text(
                                    //       "Reviews",
                                    //       style: TextStyle(
                                    //           fontSize: 16,
                                    //           fontFamily: 'Roboto',
                                    //           fontWeight: FontWeight.w700,
                                    //           color: Colors.black
                                    //           ),
                                    //     ),
                                    //     const Spacer(),
                                    //     reviewAstroModelList.isEmpty
                                    //         ? const SizedBox.shrink()
                                    //         : TextButton(
                                    //             onPressed: () {
                                    //               showModalBottomSheet(
                                    //                   context: context,
                                    //                   isScrollControlled: true,
                                    //                   builder: (context) {
                                    //                     return StatefulBuilder(
                                    //                         builder: (BuildContext
                                    //                                 context,
                                    //                             StateSetter
                                    //                                 modalSetter) {
                                    //                       return SizedBox(
                                    //                         height:
                                    //                             MediaQuery.of(
                                    //                                     context)
                                    //                                 .size
                                    //                                 .height,
                                    //                         child: Padding(
                                    //                           padding: MediaQuery
                                    //                                   .of(context)
                                    //                               .viewInsets,
                                    //                           child: Padding(
                                    //                             padding:
                                    //                                 const EdgeInsets
                                    //                                     .all(
                                    //                                     16.0),
                                    //                             child:
                                    //                                 SingleChildScrollView(
                                    //                               physics:
                                    //                                   const BouncingScrollPhysics(),
                                    //                               child: Column(
                                    //                                 children: [
                                    //                                   const SizedBox(
                                    //                                     height:
                                    //                                         30,
                                    //                                   ),
                                    //                                   Row(
                                    //                                     children: [
                                    //                                       IconButton(
                                    //                                           onPressed: () => Navigator.pop(context),
                                    //                                           icon: const Icon(
                                    //                                             CupertinoIcons.chevron_back,
                                    //                                             color: Colors.red,
                                    //                                           )),
                                    //                                       const SizedBox(
                                    //                                         width:
                                    //                                             15,
                                    //                                       ),
                                    //                                       const Text(
                                    //                                           "Read All Reviews"),
                                    //                                       const Spacer(),
                                    //                                     ],
                                    //                                   ),
                                    //                                   const SizedBox(
                                    //                                     height:
                                    //                                         30,
                                    //                                   ),
                                    //                                   SingleChildScrollView(
                                    //                                     child:
                                    //                                         Column(
                                    //                                       children: [
                                    //                                         Text(
                                    //                                           "Based on ${reviewAstroModelList.length} Reviews",
                                    //                                           style: const TextStyle(color: Color.fromRGBO(176, 176, 176, 1), fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),
                                    //                                         ),
                                    //                                         Divider(
                                    //                                           color: Colors.grey.shade300,
                                    //                                         ),
                                    //                                         ListView.builder(
                                    //                                           physics: const NeverScrollableScrollPhysics(),
                                    //                                           shrinkWrap: true,
                                    //                                           itemCount: reviewAstroModelList.length,
                                    //                                           itemBuilder: (context, index) {
                                    //                                             return Container(
                                    //                                               padding: const EdgeInsets.all(10),
                                    //                                               decoration: BoxDecoration(
                                    //                                                 color: Colors.grey.shade400,
                                    //                                                 borderRadius: BorderRadius.circular(8.0),
                                    //                                               ),
                                    //                                               child: Column(
                                    //                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                    //                                                 mainAxisAlignment: MainAxisAlignment.start,
                                    //                                                 children: [
                                    //                                                   Row(
                                    //                                                     children: [
                                    //                                                       SizedBox(
                                    //                                                         height: 50,
                                    //                                                         width: 50,
                                    //                                                         child: ClipRRect(
                                    //                                                             borderRadius: BorderRadius.circular(100.0),
                                    //                                                             child: Image.network(
                                    //                                                               reviewAstroModelList[index].userData.image,
                                    //                                                               fit: BoxFit.cover,
                                    //                                                             )),
                                    //                                                       ),
                                    //                                                       const SizedBox(
                                    //                                                         width: 5,
                                    //                                                       ),
                                    //                                                       Text(
                                    //                                                         "@${reviewAstroModelList[index].userData.name}",
                                    //                                                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    //                                                       ),
                                    //                                                     ],
                                    //                                                   ),
                                    //                                                   const SizedBox(
                                    //                                                     height: 8,
                                    //                                                   ),
                                    //                                                   Row(
                                    //                                                     children: [
                                    //                                                       Row(
                                    //                                                         mainAxisSize: MainAxisSize.min,
                                    //                                                         children: List.generate(
                                    //                                                           5, // Total number of stars
                                    //                                                           (starIndex) => Icon(
                                    //                                                             Icons.star,
                                    //                                                             color: starIndex < reviewAstroModelList[index].rating ? Colors.amber : Colors.white,
                                    //                                                             size: 18, // Yellow for filled stars, grey for unfilled
                                    //                                                           ),
                                    //                                                         ),
                                    //                                                       ),
                                    //                                                       const SizedBox(
                                    //                                                         width: 5,
                                    //                                                       ),
                                    //                                                       Text(
                                    //                                                         formatDateString("${reviewAstroModelList[index].createdAt}"),
                                    //                                                         style: const TextStyle(fontSize: 16),
                                    //                                                       )
                                    //                                                     ],
                                    //                                                   ),
                                    //                                                   // SizedBox(height: 10,),
                                    //                                                   const Divider(
                                    //                                                     color: Colors.grey,
                                    //                                                   ),
                                    //                                                   Text(
                                    //                                                     "# ${reviewAstroModelList[index].comment}",
                                    //                                                     style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                                    //                                                   )
                                    //                                                 ],
                                    //                                               ),
                                    //                                             );
                                    //                                           },
                                    //                                         ),
                                    //                                       ],
                                    //                                     ),
                                    //                                   )
                                    //                                 ],
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                         ),
                                    //                       );
                                    //                     });
                                    //                   });
                                    //             },
                                    //             child: const Text(
                                    //               "See All",
                                    //               style: TextStyle(
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Colors.orange,
                                    //                 fontSize: 15,
                                    //               ),
                                    //             ))
                                    //   ],
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Text.rich(
                                    //       TextSpan(
                                    //         children: [
                                    //           TextSpan(
                                    //               text: "$highestRating",
                                    //               style: const TextStyle(
                                    //                   fontWeight:
                                    //                       FontWeight.w700,
                                    //                   fontSize: 35,
                                    //                   fontFamily: 'Roboto',
                                    //                   color: Color.fromRGBO(
                                    //                       0, 0, 0, 1))),
                                    //           const TextSpan(
                                    //             text: '/',
                                    //             style: TextStyle(
                                    //                 fontWeight: FontWeight.w700,
                                    //                 fontSize: 20,
                                    //                 color: Color.fromRGBO(
                                    //                     0, 0, 0, 1)),
                                    //           ),
                                    //           const TextSpan(
                                    //               text: ' 5',
                                    //               style: TextStyle(
                                    //                   color: Color.fromRGBO(
                                    //                       176, 176, 176, 1),
                                    //                   fontSize: 20)),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //
                                    //     Row(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       children: List.generate(
                                    //         5,
                                    //         (index) => Icon(
                                    //           Icons.star,
                                    //           color: index < highestRating
                                    //               ? Colors.amber
                                    //               : Colors.grey,
                                    //           size: 25,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     // RatingBar.builder(
                                    //     //   initialRating: highestRating,
                                    //     //   minRating: 1,
                                    //     //   direction: Axis.horizontal,
                                    //     //   allowHalfRating: true,
                                    //     //   itemCount: 5,
                                    //     //   maxRating: 5,
                                    //     //   itemPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                    //     //   itemBuilder: (context, _) => Icon(
                                    //     //     Icons.star,
                                    //     //     color: Colors.amber,
                                    //     //   ),
                                    //     //   onRatingUpdate: (value) {
                                    //     //     setState(() {
                                    //     //       highestRating = value;
                                    //     //     });
                                    //     //   },
                                    //     // ),
                                    //   ],
                                    // ),
                                    // Text(
                                    //   "Based on ${reviewAstroModelList.length} Reviews",
                                    //   style: const TextStyle(
                                    //       color:
                                    //           Color.fromRGBO(176, 176, 176, 1),
                                    //       fontSize: 15,
                                    //       fontWeight: FontWeight.w500,
                                    //       fontFamily: 'Roboto'),
                                    // ),
                                    // const SizedBox(height: 10),
                                    //
                                    // reviewAstroModelList.isEmpty
                                    //     ? const SizedBox.shrink()
                                    //     : ListView.builder(
                                    //         physics:
                                    //             const NeverScrollableScrollPhysics(),
                                    //         shrinkWrap: true,
                                    //         itemCount:
                                    //             reviewAstroModelList.length,
                                    //         itemBuilder: (context, index) {
                                    //           return Container(
                                    //             padding:
                                    //                 const EdgeInsets.all(10),
                                    //             decoration: BoxDecoration(
                                    //               color: Colors.grey.shade400,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(
                                    //                       8.0),
                                    //             ),
                                    //             child: Column(
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
                                    //               mainAxisAlignment:
                                    //                   MainAxisAlignment.start,
                                    //               children: [
                                    //                 Row(
                                    //                   children: [
                                    //                     SizedBox(
                                    //                       height: 50,
                                    //                       width: 50,
                                    //                       child: ClipRRect(
                                    //                           borderRadius:
                                    //                               BorderRadius
                                    //                                   .circular(
                                    //                                       100.0),
                                    //                           child:
                                    //                               Image.network(
                                    //                             reviewAstroModelList[
                                    //                                     index]
                                    //                                 .userData
                                    //                                 .image,
                                    //                             fit: BoxFit
                                    //                                 .cover,
                                    //                           )),
                                    //                     ),
                                    //                     const SizedBox(
                                    //                       width: 5,
                                    //                     ),
                                    //
                                    //                     Text(
                                    //                       "@${reviewAstroModelList[index].userData.name}",
                                    //                       style:
                                    //                           const TextStyle(
                                    //                               fontSize: 20,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .bold,
                                    //                               color: Colors
                                    //                                   .white),
                                    //                     ),
                                    //                     // Spacer(),
                                    //                     // Icon(Icons.more_vert,color: Colors.white,size: 24,)
                                    //                   ],
                                    //                 ),
                                    //                 const SizedBox(
                                    //                   height: 8,
                                    //                 ),
                                    //                 Row(
                                    //                   children: [
                                    //                     Row(
                                    //                       mainAxisSize:
                                    //                           MainAxisSize.min,
                                    //                       children:
                                    //                           List.generate(
                                    //                         5, // Total number of stars
                                    //                         (starIndex) => Icon(
                                    //                           Icons.star,
                                    //                           color: starIndex <
                                    //                                   reviewAstroModelList[
                                    //                                           index]
                                    //                                       .rating
                                    //                               ? Colors.amber
                                    //                               : Colors
                                    //                                   .white,
                                    //                           size:
                                    //                               22, // Yellow for filled stars, grey for unfilled
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                     const SizedBox(
                                    //                       width: 5,
                                    //                     ),
                                    //                     Text(
                                    //                       formatDateString(
                                    //                           "${reviewAstroModelList[index].createdAt}"),
                                    //                       style: const TextStyle(
                                    //                           fontSize: 15,
                                    //                           color: Colors
                                    //                               .blueGrey),
                                    //                     )
                                    //                   ],
                                    //                 ),
                                    //                 // SizedBox(height: 10,),
                                    //                 const Divider(
                                    //                   color: Colors.grey,
                                    //                 ),
                                    //                 Text(
                                    //                   reviewAstroModelList[
                                    //                           index]
                                    //                       .comment,
                                    //                   style: const TextStyle(
                                    //                       fontSize: 18,
                                    //                       color: Colors.black,
                                    //                       overflow: TextOverflow
                                    //                           .ellipsis),
                                    //                   maxLines: 3,
                                    //                 )
                                    //               ],
                                    //             ),
                                    //           );
                                    //         },
                                    //       ),
                                    // Container(
                                    //   height: 1.5, // Thinner but more elegant
                                    //   margin: const EdgeInsets.symmetric(
                                    //       vertical: 6),
                                    //   decoration: BoxDecoration(
                                    //     gradient: LinearGradient(
                                    //       colors: [
                                    //         Colors.transparent,
                                    //         Colors.orange.shade300,
                                    //         Colors.orange.shade400,
                                    //         Colors.orange.shade300,
                                    //         Colors.transparent,
                                    //       ],
                                    //       stops: const [
                                    //         0.0,
                                    //         0.2,
                                    //         0.5,
                                    //         0.8,
                                    //         1.0
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    //
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 3,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          widget.isProduct
                                              ? "Astrology Consultation"
                                              : "Shubh Muhurat",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    widget.isProduct
                                        ? SizedBox(
                                            height: 220,
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount:
                                                  consultaionModelList.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .replace(
                                                      oldRoute: ModalRoute.of(
                                                          context)!,
                                                      newRoute:
                                                          MaterialPageRoute(
                                                        builder: (context) =>
                                                            AstroDetailsView(
                                                          productId:
                                                              consultaionModelList[
                                                                      index]
                                                                  .id!,
                                                          isProduct: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    width: 140,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .orange.shade50,
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              blurRadius: 5,
                                                              offset:
                                                                  const Offset(
                                                                      0, 6))
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 120,
                                                            width: 130,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                child: Image
                                                                    .network(
                                                                  "${consultaionModelList[index].thumbnail}",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${translateBtn ? consultaionModelList[index].hiName : consultaionModelList[index].enName}",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            maxLines: 2,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text.rich(TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        '₹${consultaionModelList[index].counsellingSellingPrice} ',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .blue)),
                                                                TextSpan(
                                                                    text:
                                                                        ' ₹${consultaionModelList[index].counsellingMainPrice}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black,
                                                                        decoration:
                                                                            TextDecoration.lineThrough)),
                                                              ]))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox(
                                            height: 220,
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount:
                                                  muhuratModelList.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .replace(
                                                      oldRoute: ModalRoute.of(
                                                          context)!,
                                                      newRoute:
                                                          MaterialPageRoute(
                                                        builder: (context) =>
                                                            AstroDetailsView(
                                                                productId:
                                                                    muhuratModelList[
                                                                            index]
                                                                        .id!,
                                                                isProduct:
                                                                    false),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    width: 140,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .orange.shade50,
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              blurRadius: 5,
                                                              offset:
                                                                  const Offset(
                                                                      0, 6))
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 120,
                                                            width: 130,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                child: Image
                                                                    .network(
                                                                  "${muhuratModelList[index].thumbnail}",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "${translateBtn ? muhuratModelList[index].hiName : muhuratModelList[index].enName}",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            maxLines: 2,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text.rich(TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        '₹${muhuratModelList[index].counsellingSellingPrice} ',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .blue)),
                                                                TextSpan(
                                                                    text:
                                                                        ' ₹${muhuratModelList[index].counsellingMainPrice}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black,
                                                                        decoration:
                                                                            TextDecoration.lineThrough)),
                                                              ]))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 1.5, // Thinner but more elegant
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.orange.shade300,
                                            Colors.orange.shade400,
                                            Colors.orange.shade300,
                                            Colors.transparent,
                                          ],
                                          stops: const [
                                            0.0,
                                            0.2,
                                            0.5,
                                            0.8,
                                            1.0
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    widget.isProduct
                                        ? Container(
                                            child: Askquestions(
                                                type: 'yog consultation',
                                                translateEn:
                                                    translateBtn ? "hi" : "en"),
                                          )
                                        : Container(
                                            child: Askquestions(
                                                type: 'mahurat consultation',
                                                translateEn:
                                                    translateBtn ? "hi" : "en"),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          );
  }
}
