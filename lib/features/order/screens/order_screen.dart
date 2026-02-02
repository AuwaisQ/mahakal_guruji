import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/order/controllers/order_controller.dart';
import 'package:mahakal/features/order/screens/track_screens/track_donation_details.dart';
import 'package:mahakal/features/order/screens/track_screens/track_event_details.dart';
import 'package:mahakal/features/order/widgets/order_shimmer_widget.dart';
import 'package:mahakal/features/order/widgets/order_type_button_widget.dart';
import 'package:mahakal/features/order/widgets/order_widget.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/features/auth/controllers/auth_controller.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/common/basewidget/no_internet_screen_widget.dart';
import 'package:mahakal/common/basewidget/not_loggedin_widget.dart';
import 'package:mahakal/common/basewidget/paginated_list_view_widget.dart';
import 'package:intl/intl.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../profile/controllers/profile_contrroller.dart';
import '../model/all_order_model.dart';
import '../model/darshan_model.dart';
import '../model/donationorder_model.dart';
import '../model/event_model.dart';
import '../model/offline_model.dart';
import '../model/order_model.dart';
import '../model/pdfdata_model.dart';
import '../model/tour_travel_model.dart';
import 'track_screens/dasrhan_track_screen.dart';
import 'track_screens/pfd_details_page.dart';
import 'track_screens/track_chadhava_details.dart';
import 'track_screens/track_order_details.dart';

class OrderScreen extends StatefulWidget {
  int barIndex = 0;
  int orderIndex = 0;
  OrderScreen({super.key, required this.barIndex, required this.orderIndex});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  int selectOrder = 111;
  String userToken = "";
  String userId = "";
  bool showShimmerScreen = true;

  ScrollController scrollController = ScrollController();
  bool isGuestMode =
      !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn();
  bool _isVisible = true;
  late Timer _timer;

  @override
  void initState() {
    if (!isGuestMode) {
      Provider.of<OrderController>(context, listen: false)
          .setIndex(0, notify: false);
      Provider.of<OrderController>(context, listen: false)
          .getOrderList(1, 'ongoing');
    }
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
    selectOrder = widget.orderIndex;
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    userToken =
        Provider.of<AuthController>(Get.context!, listen: false).getUserToken();

    print(">>>> token $userId $userToken");
    // scrollToIndex(selectOrder);
    fetchAllOrders();
    fetchAllData(userId);
    // fetchPdfData(userId);
    // fetchDonation(userId);
    // fetchEventData(userId);
    // fetchTourData(userId);
    fetchVipOrders();
    fetchDarshanOrders();
    fetchAnushthanOrders();
    fetchChadhavaOrders();
    fetchPoojaOrders();
    fetchPanditPoojaOrders();
    fetchOfflinePooja();
    fetchConsultationOrders();
    showShimmerScreen = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToOrder(widget.orderIndex);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    super.initState();
  }

  // PoojaOrderModel? orderModelData;
  List<Recentorder> allOrderModelList = <Recentorder>[];
  List<Poojaorder> orderModelList = <Poojaorder>[];
  List<Poojaorder> panditPoojaOrderModelList = <Poojaorder>[];
  List<Poojaorder> vipModelList = <Poojaorder>[];
  List<Poojaorder> anushthanModelList = <Poojaorder>[];
  List<Poojaorder> chadhavaModelList = <Poojaorder>[];
  List<Poojaorder> counsellingModelList = <Poojaorder>[];
  List<Poojaorder> orderDemoList = <Poojaorder>[];
  List<Eventdata> eventModelList = <Eventdata>[];
  List<Darshanorder> darshanModelList = <Darshanorder>[];
  EventOrderModel? eventModelData;
  List<Pdfdatum> pdfModelList = <Pdfdatum>[];
  List<Pdfdatum> pdfMilanModelList = <Pdfdatum>[];
  List<Donation> donationModelList = <Donation>[];
  List<Tourorderlist> tourModelList = <Tourorderlist>[];
  List<Offlinelist> offlineModelList = <Offlinelist>[];

  final ScrollController _scrollController = ScrollController();

  late AnimationController _controller;
  final List<Color> _colors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  void scrollToOrder(int index) {
    // Approximate tab width (you can fine-tune this)
    double tabWidth = 130.0;

    // Screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the offset to center the tab
    double position = (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);

    // Clamp the value so it doesn’t go negative
    if (position < 0) position = 0;

    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
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
        return Colors.orange; // Default color for unknown statuses
    }
  }

  String extractDate(String dateTime) {
    // Define the input format
    DateFormat inputFormat = DateFormat("dd-MM-yyyy hh:mm:ss a");
    // Parse the datetime string
    DateTime date = inputFormat.parse(dateTime);
    // Define the output format
    DateFormat outputFormat = DateFormat("dd-MMM-yyyy");
    // Format and return only the date
    return outputFormat.format(date);
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

  // donation + tour + events + kundali
  Future<void> fetchAllData(String userId) async {
    final List<Map<String, dynamic>> requests = [
      {
        "url": AppConstants.baseUrl + AppConstants.eventOrderListUrl,
        "type": "event",
      },
      {
        "url": AppConstants.baseUrl + AppConstants.tourOrderDetailsUrl,
        "type": "tour",
      },
      {
        "url": AppConstants.baseUrl + AppConstants.donationOrderUrl,
        "type": "donation",
      },
      {
        "url": AppConstants.baseUrl + AppConstants.orderPdfurl,
        "type": "kundali",
      },
      {
        "url": AppConstants.baseUrl + AppConstants.orderPdfurl,
        "type": "kundali_milan",
      },
    ];

    try {
      for (var request in requests) {
        final response = await http.post(
          Uri.parse(request['url']),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "user_id": userId,
            if (request['type'] == 'kundali' ||
                request['type'] == 'kundali_milan')
              "type": request['type'],
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List listData = data["data"];

          setState(() {
            switch (request['type']) {
              case "event":
                eventModelList.clear();
                eventModelList
                    .addAll(listData.map((e) => Eventdata.fromJson(e)));
                print("orderModelData: ${eventModelList[0].eventBookingDate}");
                break;
              case "tour":
                tourModelList.clear();
                tourModelList
                    .addAll(listData.map((e) => Tourorderlist.fromJson(e)));
                break;
              case "donation":
                donationModelList.clear();
                donationModelList
                    .addAll(listData.map((e) => Donation.fromJson(e)));
                break;
              case "kundali":
                pdfModelList.clear();
                pdfModelList.addAll(listData.map((e) => Pdfdatum.fromJson(e)));
                break;
              case "kundali_milan":
                pdfMilanModelList.clear();
                pdfMilanModelList
                    .addAll(listData.map((e) => Pdfdatum.fromJson(e)));
                break;
            }
          });

          print("✅ Loaded ${request['type']} data: $listData");
        } else {
          print(
              "❌ Failed to load ${request['type']} data. Status: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("❗ Error in fetchAllData: $e");
    }
  }

  //
  // Future<void> fetchEventData(String userId) async {
  //   const String url = AppConstants.baseUrl + AppConstants.eventOrderListUrl;
  //
  //   try {
  //     // Sending the POST request
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //       },
  //       body: jsonEncode({
  //         "user_id": userId,
  //       }),
  //     );
  //
  //     // Handling the response
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print("Response Data event: $data");
  //       setState(() {
  //         // eventModelData = eventOrderModelFromJson(jsonEncode(response));
  //         eventModelList.clear();
  //         List eventList = data["data"];
  //         eventModelList.addAll(eventList.map((e) => Eventdata.fromJson(e)));
  //       });
  //       // Process the response as needed
  //       // For example: update a list, notify the UI, etc.
  //     } else {
  //       print("Failed to load data event. Status Code: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //   }
  // }
  //
  // Future<void> fetchTourData(String userId) async {
  //   const String url = AppConstants.baseUrl + AppConstants.tourOrderDetailsUrl;
  //
  //   try {
  //     // Sending the POST request
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //       },
  //       body: jsonEncode({
  //         "user_id": userId,
  //       }),
  //     );
  //
  //     // Handling the response
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print("Response Data event: $data");
  //       setState(() {
  //         // eventModelData = eventOrderModelFromJson(jsonEncode(response));
  //         tourModelList.clear();
  //         List tourList = data["data"];
  //         tourModelList.addAll(tourList.map((e) => Tourorderlist.fromJson(e)));
  //       });
  //       // Process the response as needed
  //       // For example: update a list, notify the UI, etc.
  //     } else {
  //       print("Failed to load data event. Status Code: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error In Tour List: $error");
  //   }
  // }
  //
  // Future<void> fetchDonation(String userId) async {
  //   const String url = AppConstants.baseUrl + AppConstants.donationOrderUrl;
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //       },
  //       body: jsonEncode({
  //         "user_id": userId,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         donationModelList.clear();
  //         var data = jsonDecode(response.body);
  //         List tourList = data['data'];
  //         donationModelList.addAll(tourList.map((e) => Donation.fromJson(e)));
  //         // orderModelData = poojaOrderModelFromJson(jsonEncode(response));
  //       });
  //     } else {
  //       print("Failed to load data. Status code: ${response.statusCode}");
  //       // Handle error case
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     // Handle error case
  //   }
  // }
  //
  // Future<void> fetchPdfData(String userId) async {
  //   const String url = AppConstants.baseUrl + AppConstants.orderPdfurl;
  //
  //   try {
  //     // First call: type = kundali
  //     final responseKundali = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //       },
  //       body: jsonEncode({"user_id": userId, "type": "kundali"}),
  //     );
  //
  //     // Second call: type = kundali_milan
  //     final responseKundaliMilan = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //       },
  //       body: jsonEncode({"user_id": userId, "type": "kundali_milan"}),
  //     );
  //
  //     setState(() {
  //       if (responseKundali.statusCode == 200) {
  //         final Map<String, dynamic> res = jsonDecode(responseKundali.body);
  //         final List pdfList = res["data"];
  //         pdfModelList.clear();
  //         pdfModelList.addAll(pdfList.map((e) => Pdfdatum.fromJson(e)));
  //         print(">>> Kundali Data: $pdfList");
  //       } else {
  //         print("Failed to load kundali data.");
  //       }
  //
  //       if (responseKundaliMilan.statusCode == 200) {
  //         final Map<String, dynamic> res =
  //             jsonDecode(responseKundaliMilan.body);
  //         final List pdfList = res["data"];
  //         pdfMilanModelList.clear();
  //         pdfMilanModelList.addAll(pdfList.map((e) => Pdfdatum.fromJson(e)));
  //         print(">>> Kundali Milan Data: $pdfList");
  //       } else {
  //         print("Failed to load kundali_milan data.");
  //       }
  //     });
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  Future<void> fetchAllOrders() async {
    final response = await http.get(
      Uri.parse(AppConstants.baseUrl + AppConstants.allOrdersUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order pooja ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        allOrderModelList.clear();
        var data = jsonDecode(response.body);
        List allOrderList = data['orders'];
        allOrderModelList
            .addAll(allOrderList.map((e) => Recentorder.fromJson(e)));
        // orderModelData = poojaOrderModelFromJson(jsonEncode(response));
        showShimmerScreen = true;
      });
    }
  }

  Future<void> fetchDarshanOrders() async {
    final response = await http.get(
      Uri.parse(AppConstants.baseUrl + AppConstants.darshanUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response darshan order ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        darshanModelList.clear();
        var data = jsonDecode(response.body);
        List darshanList = data['data'];
        darshanModelList
            .addAll(darshanList.map((e) => Darshanorder.fromJson(e)));
        // orderModelData = poojaOrderModelFromJson(jsonEncode(response));
      });
    }
  }

  Future<void> fetchOfflinePooja() async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}${AppConstants.offlinePoojaOrderUrl}"),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order offline ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        offlineModelList.clear();
        var data = jsonDecode(response.body);
        List offlineList = data['orders'];
        offlineModelList
            .addAll(offlineList.map((e) => Offlinelist.fromJson(e)));
        // orderModelData = poojaOrderModelFromJson(jsonEncode(response));
      });
    }
  }

  Future<void> fetchPoojaOrders() async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}${AppConstants.poojaOrderUrl}"),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order pooja ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        orderModelList.clear();
        var data = jsonDecode(response.body);
        List orderList = data['orders'];
        orderModelList.addAll(orderList.map((e) => Poojaorder.fromJson(e)));
        // orderModelData = poojaOrderModelFromJson(jsonEncode(response));
      });
    }
  }

  Future<void> fetchPanditPoojaOrders() async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}${AppConstants.allPanditOrderUrl}"),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order pooja ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        panditPoojaOrderModelList.clear();
        var data = jsonDecode(response.body);
        List orderList = data['orders'];
        panditPoojaOrderModelList
            .addAll(orderList.map((e) => Poojaorder.fromJson(e)));
        print("Pandit pooja Orders:$panditPoojaOrderModelList");
        // orderModelData = poojaOrderModelFromJson(jsonEncode(response));
      });
    }
  }

  Future<void> fetchVipOrders() async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}${AppConstants.vipOrderUrl}"),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order vip ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        vipModelList.clear();
        var data = jsonDecode(response.body);
        List vipList = data['orders'];
        vipModelList.addAll(vipList.map((e) => Poojaorder.fromJson(e)));
      });
    }
  }

  Future<void> fetchAnushthanOrders() async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}${AppConstants.anushthanOrderUrl}"),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order anushtha ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        anushthanModelList.clear();
        var data = jsonDecode(response.body);
        List anushthanList = data['orders'];
        anushthanModelList
            .addAll(anushthanList.map((e) => Poojaorder.fromJson(e)));
      });
    }
  }

  Future<void> fetchChadhavaOrders() async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}${AppConstants.chadhavaOrderUrl}"),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order chadhava ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        chadhavaModelList.clear();
        var data = jsonDecode(response.body);
        List chadhavaList = data['orders'];
        chadhavaModelList
            .addAll(chadhavaList.map((e) => Poojaorder.fromJson(e)));
      });
    } else {
      print(
          "Failed to load data. chadhava Status code: ${response.statusCode}");
    }
  }

  Future<void> fetchConsultationOrders() async {
    const String apiUrl =
        '${AppConstants.baseUrl}${AppConstants.counsellingOrderUrl}';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );
    print("Api response order astrology ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        counsellingModelList.clear();
        var data = jsonDecode(response.body);
        List counsellingList = data['orders'];
        counsellingModelList
            .addAll(counsellingList.map((e) => Poojaorder.fromJson(e)));
      });
    } else {
      print("Failed to load data. astro Status code: ${response.statusCode}");
    }
  }

  String formatBookingDate(String bookingDate) {
    DateTime? dateTime;

    try {
      // Try parsing ISO format first
      dateTime = DateTime.tryParse(bookingDate);

      dateTime ??= DateFormat('dd-MM-yyyy hh:mm:ss a').parse(bookingDate);

      // Format to "dd-MMMM-yyyy"
      String formattedDate = DateFormat('dd-MMMM-yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      print("Error parsing date: $e");
      return bookingDate; // Return original if any error
    }
  }

  void scrollToIndex(int index) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double itemWidth =
        120.0; // Approximate width of each tab item (Adjust if needed)
    double scrollOffset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      scrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      selectOrder = index;
    });
  }

  void shimmerEffect(int index) {
    // Set shimmer screen to true immediately to show it before the delay
    setState(() {
      selectOrder = index;
      showShimmerScreen = true; // Display the shimmer effect
    });

    // Delay for 1 second before showing the actual content
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        // Update the selected order after delay
        showShimmerScreen =
            false; // Hide the shimmer effect and show the actual content
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      initialIndex: widget.barIndex,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Order',
            style: TextStyle(color: Colors.grey),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 18,
            ),
          ),
          bottom: const TabBar(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            dividerColor: Colors.white,
            labelColor: Colors.deepOrange,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.deepOrange,
            // indicator: BoxDecoration(
            //     color: Colors.deepOrange,
            //     borderRadius: BorderRadius.circular(
            //         6.0) // Set the background color of the indicator
            // ),
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Service'),
            ],
          ),
        ),
        body: isGuestMode
            ? const NotLoggedInWidget()
            : Consumer<OrderController>(
                builder: (context, orderController, child) {
                return Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: [
                          //First tabview
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeLarge),
                                  child: Row(children: [
                                    OrderTypeButton(
                                        text: getTranslated('RUNNING', context),
                                        index: 0),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    OrderTypeButton(
                                        text:
                                            getTranslated('DELIVERED', context),
                                        index: 1),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    OrderTypeButton(
                                        text:
                                            getTranslated('CANCELED', context),
                                        index: 2)
                                  ])),
                              Expanded(
                                  child: orderController.orderModel != null
                                      ? (orderController.orderModel!.orders !=
                                                  null &&
                                              orderController.orderModel!
                                                  .orders!.isNotEmpty)
                                          ? SingleChildScrollView(
                                              controller: scrollController,
                                              child: PaginatedListView(
                                                scrollController:
                                                    scrollController,
                                                onPaginate:
                                                    (int? offset) async {
                                                  await orderController
                                                      .getOrderList(
                                                          offset!,
                                                          orderController
                                                              .selectedType);
                                                },
                                                totalSize: orderController
                                                    .orderModel?.totalSize,
                                                offset: orderController
                                                            .orderModel
                                                            ?.offset !=
                                                        null
                                                    ? int.parse(orderController
                                                        .orderModel!.offset!)
                                                    : 1,
                                                itemView: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: orderController
                                                      .orderModel
                                                      ?.orders!
                                                      .length,
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  itemBuilder: (context,
                                                          index) =>
                                                      OrderWidget(
                                                          orderModel:
                                                              orderController
                                                                      .orderModel
                                                                      ?.orders![
                                                                  index]),
                                                ),
                                              ),
                                            )
                                          : const NoInternetOrDataScreenWidget(
                                              isNoInternet: false,
                                              icon: Images.noOrder,
                                              message: 'no_order_found',
                                            )
                                      : const OrderShimmerWidget())
                            ],
                          ),

                          //Second tabview
                          RefreshIndicator(
                            color: Colors.orange,
                            onRefresh: () async {
                              fetchAllOrders();
                              fetchAllData(userId);
                              // fetchPdfData(userId);
                              // fetchDonation(userId);
                              // fetchEventData(userId);
                              // fetchTourData(userId);
                              fetchVipOrders();
                              fetchAnushthanOrders();
                              fetchChadhavaOrders();
                              fetchPoojaOrders();
                              fetchPanditPoojaOrders();
                              fetchOfflinePooja();
                              fetchConsultationOrders();
                              fetchDarshanOrders();
                            },
                            child: Column(
                              children: [
                                // Padding(
                                //     padding: const EdgeInsets.all(
                                //         Dimensions.paddingSizeLarge),
                                //     child: Row(children: [
                                //       OrderTypeButton(
                                //           text: getTranslated('CHADAVA', context),
                                //           index: 0),
                                //       const SizedBox(
                                //           width: Dimensions.paddingSizeSmall),
                                //       OrderTypeButton(
                                //           text: getTranslated('POOJA', context),
                                //           index: 1),
                                //       const SizedBox(
                                //           width: Dimensions.paddingSizeSmall),
                                //       OrderTypeButton(
                                //           text: getTranslated(
                                //               'CONSULTATION', context),
                                //           index: 2)
                                //     ])),
                                Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: [
                                        //Recent pooja
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(111);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 111
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "recent_order", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 111
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),

                                        //vip pooja
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(0);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 0
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated("vip", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 0
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),

                                        // anushthan pooja
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(1);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 1
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "anushthan", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 1
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),

                                        // chadhava pooja
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(2);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 2
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "CHADAVA", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 2
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),

                                        // pooja
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(3);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 3
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated("POOJA", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 3
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),

                                        //consultation
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(4);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 4
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "CONSULTATION", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 4
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),

                                        // events
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(5);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 5
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated("events", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 5
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),

                                        // tour booking
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(6);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 6
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "tourBooking", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 6
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),

                                        //pdf
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(7);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 7
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated("PDF", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 7
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),

                                        // donation
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(8);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 8
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "donation", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 8
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),

                                        // offline pooja
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(9);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 9
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "offline_pooja", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 9
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),

                                        // Darshan
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(10);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 10
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Darshan",
                                              style: TextStyle(
                                                  color: selectOrder == 10
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),

                                        // All Pandit
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(11);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 11
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "pooja_pandit", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 11
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),

                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(12);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 12
                                                  ? Colors.deepOrange
                                                  : Colors.deepOrange
                                                      .withOpacity(0.07),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated(
                                                  "hotel_booking", context)!,
                                              style: TextStyle(
                                                  color: selectOrder == 12
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 14),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                      ]),
                                    )),

                                Expanded(
                                    child: selectOrder == 111
                                        ? allOrderModelList.isEmpty
                                            ? showShimmerScreen
                                                ? const OrderShimmerWidget()
                                                : const NoInternetOrDataScreenWidget(
                                                    isNoInternet: false,
                                                    icon: Images.noOrder,
                                                    message: 'no_order_found',
                                                  )
                                            : ListView.builder(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    allOrderModelList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      print(
                                                          "My Order Types :${allOrderModelList[index].type}");

                                                      allOrderModelList[index]
                                                                  .type ==
                                                              "pooja"
                                                          ? Navigator.push(
                                                              context,
                                                              PageAnimationTransition(
                                                                  page:
                                                                      MahakalTrackOrder(
                                                                    poojaId: allOrderModelList[
                                                                            index]
                                                                        .orderId,
                                                                    typePooja:
                                                                        'pooja',
                                                                  ),
                                                                  pageAnimationType:
                                                                      RightToLeftTransition()))
                                                          : allOrderModelList[
                                                                          index]
                                                                      .type ==
                                                                  "chadhava"
                                                              ? Navigator.push(
                                                                  context,
                                                                  PageAnimationTransition(
                                                                      page:
                                                                          ChadhavaMahakalTrackOrder(
                                                                        poojaId:
                                                                            allOrderModelList[index].orderId,
                                                                      ),
                                                                      pageAnimationType:
                                                                          RightToLeftTransition()))
                                                                  // : allOrderModelList[index].type == "offlinepooja"
                                                                  //     ? Navigator.push(
                                                                  //         context,
                                                                  //         PageAnimationTransition(
                                                                  //             page: OfflinePoojaTrackOrder(
                                                                  //               poojaId: allOrderModelList[index].orderId,
                                                                  //             ),
                                                                  //             pageAnimationType: RightToLeftTransition()))
                                                                          : allOrderModelList[index].type == "event"
                                                                              ? Navigator.push(
                                                                                  context,
                                                                                  PageAnimationTransition(
                                                                                      page: TrackEventDetails(
                                                                                        orderId: allOrderModelList[index].id,
                                                                                      ),
                                                                                      pageAnimationType: RightToLeftTransition()))
                                                                              : allOrderModelList[index].type == "donate_ads" || allOrderModelList[index].type == "donate_trust"
                                                                                  ? Navigator.push(
                                                                                      context,
                                                                                      PageAnimationTransition(
                                                                                          page: TrackDonationDetails(
                                                                                            donationId: '${allOrderModelList[index].id}',
                                                                                          ),
                                                                                          pageAnimationType: RightToLeftTransition()))
                                                                                  : allOrderModelList[index].type == "kundli"
                                                                                      ? Navigator.push(
                                                                                          context,
                                                                                          PageAnimationTransition(
                                                                                              page: PdfOrderDetails(
                                                                                                orderId: "${allOrderModelList[index].id}",
                                                                                                type: "kundali",
                                                                                              ),
                                                                                              pageAnimationType: RightToLeftTransition()))
                                                                                      : allOrderModelList[index].type == "kundli milan"
                                                                                          ? Navigator.push(
                                                                                              context,
                                                                                              PageAnimationTransition(
                                                                                                  page: PdfOrderDetails(
                                                                                                    orderId: "${allOrderModelList[index].id}",
                                                                                                    type: "kundali_milan",
                                                                                                  ),
                                                                                                  pageAnimationType: RightToLeftTransition()))
                                                                                          : allOrderModelList[index].type == "vip"
                                                                                              ? Navigator.push(
                                                                                                  context,
                                                                                                  PageAnimationTransition(
                                                                                                      page: MahakalTrackOrder(
                                                                                                        poojaId: "${allOrderModelList[index].orderId}",
                                                                                                        typePooja: 'vip',
                                                                                                      ),
                                                                                                      pageAnimationType: RightToLeftTransition()))
                                                                                              : allOrderModelList[index].type == "anushthan"
                                                                                                  ? Navigator.push(
                                                                                                      context,
                                                                                                      PageAnimationTransition(
                                                                                                          page: MahakalTrackOrder(
                                                                                                            poojaId: "${allOrderModelList[index].orderId}",
                                                                                                            typePooja: 'anushthan',
                                                                                                          ),
                                                                                                          pageAnimationType: RightToLeftTransition()))
                                                                                                  : null;
                                                      // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                      print(
                                                          "chal rha he ${allOrderModelList[index].orderId}");
                                                    },
                                                    child: _buildOrderDesign(
                                                      image:
                                                          "${allOrderModelList[index].services.thumbnail}",
                                                      name:
                                                          "${allOrderModelList[index].services.name}",
                                                      color: getStatusColor(
                                                          "${allOrderModelList[index].status}"),
                                                      date:
                                                          "${allOrderModelList[index].createdAt}",
                                                      price:
                                                          "${allOrderModelList[index].payAmount}",
                                                      orderId:
                                                          "${allOrderModelList[index].orderId}",
                                                      status:
                                                          "${allOrderModelList[index].orderStatus}",
                                                      type:
                                                          "${allOrderModelList[index].type}",
                                                    ),
                                                  );
                                                },
                                              )
                                        : selectOrder == 0
                                            ? vipModelList.isEmpty
                                                ? showShimmerScreen
                                                    ? const OrderShimmerWidget()
                                                    : const NoInternetOrDataScreenWidget(
                                                        isNoInternet: false,
                                                        icon: Images.noOrder,
                                                        message:
                                                            'no_order_found',
                                                      )
                                                : ListView.builder(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        vipModelList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              PageAnimationTransition(
                                                                  page:
                                                                      MahakalTrackOrder(
                                                                    poojaId:
                                                                        "${vipModelList[index].orderId}",
                                                                    typePooja:
                                                                        'vip',
                                                                  ),
                                                                  pageAnimationType:
                                                                      RightToLeftTransition()));
                                                          // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                          print("chal rha he");
                                                        },
                                                        child:
                                                            _buildOrderDesign(
                                                          image:
                                                              "${vipModelList[index].services?.thumbnail}",
                                                          name:
                                                              "${vipModelList[index].services?.name}",
                                                          color: getStatusColor(
                                                              "${vipModelList[index].status}"),
                                                          date:
                                                              "${vipModelList[index].createdAt}",
                                                          price:
                                                              "${vipModelList[index].payAmount}",
                                                          orderId:
                                                              "${vipModelList[index].orderId}",
                                                          status:
                                                              "${vipModelList[index].orderStatus}",
                                                        ),
                                                      );
                                                    },
                                                  )
                                            : selectOrder == 1
                                                ? anushthanModelList.isEmpty
                                                    ? showShimmerScreen
                                                        ? const OrderShimmerWidget()
                                                        : const NoInternetOrDataScreenWidget(
                                                            isNoInternet: false,
                                                            icon:
                                                                Images.noOrder,
                                                            message:
                                                                'no_order_found',
                                                          )
                                                    : ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            anushthanModelList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  PageAnimationTransition(
                                                                      page:
                                                                          MahakalTrackOrder(
                                                                        poojaId:
                                                                            "${anushthanModelList[index].orderId}",
                                                                        typePooja:
                                                                            'anushthan',
                                                                      ),
                                                                      pageAnimationType:
                                                                          RightToLeftTransition()));
                                                              // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                              print(
                                                                  "chal rha he anushthan");
                                                            },
                                                            child:
                                                                _buildOrderDesign(
                                                              image:
                                                                  "${anushthanModelList[index].services?.thumbnail}",
                                                              name:
                                                                  "${anushthanModelList[index].services?.name}",
                                                              color: getStatusColor(
                                                                  "${anushthanModelList[index].status}"),
                                                              date:
                                                                  "${anushthanModelList[index].createdAt}",
                                                              price:
                                                                  "${anushthanModelList[index].payAmount}",
                                                              orderId:
                                                                  "${anushthanModelList[index].orderId}",
                                                              status:
                                                                  "${anushthanModelList[index].orderStatus}",
                                                            ),
                                                          );
                                                        },
                                                      )
                                                : selectOrder == 2
                                                    ? chadhavaModelList.isEmpty
                                                        ? showShimmerScreen
                                                            ? const OrderShimmerWidget()
                                                            : const NoInternetOrDataScreenWidget(
                                                                isNoInternet:
                                                                    false,
                                                                icon: Images
                                                                    .noOrder,
                                                                message:
                                                                    'no_order_found',
                                                              )
                                                        : ListView.builder(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                chadhavaModelList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageAnimationTransition(
                                                                          page: ChadhavaMahakalTrackOrder(
                                                                            poojaId:
                                                                                "${chadhavaModelList[index].orderId}",
                                                                          ),
                                                                          pageAnimationType: RightToLeftTransition()));
                                                                  // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                                  print(
                                                                      "chal rha he");
                                                                },
                                                                child:
                                                                    _buildOrderDesign(
                                                                  image:
                                                                      "${chadhavaModelList[index].services?.thumbnail}",
                                                                  name:
                                                                      "${chadhavaModelList[index].services?.name}",
                                                                  color: getStatusColor(
                                                                      "${chadhavaModelList[index].status}"),
                                                                  date:
                                                                      "${chadhavaModelList[index].createdAt}",
                                                                  price:
                                                                      "${chadhavaModelList[index].payAmount}",
                                                                  orderId:
                                                                      "${chadhavaModelList[index].orderId}",
                                                                  status:
                                                                      "${chadhavaModelList[index].orderStatus}",
                                                                ),
                                                              );
                                                            },
                                                          )
                                                    : selectOrder == 3
                                                        ? orderModelList.isEmpty
                                                            ? showShimmerScreen
                                                                ? const OrderShimmerWidget()
                                                                : const NoInternetOrDataScreenWidget(
                                                                    isNoInternet:
                                                                        false,
                                                                    icon: Images
                                                                        .noOrder,
                                                                    message:
                                                                        'no_order_found',
                                                                  )
                                                            : ListView.builder(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                physics:
                                                                    const BouncingScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    orderModelList
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          PageAnimationTransition(
                                                                              page: MahakalTrackOrder(
                                                                                poojaId: "${orderModelList[index].orderId}",
                                                                                typePooja: 'pooja',
                                                                              ),
                                                                              pageAnimationType: RightToLeftTransition()));
                                                                    },
                                                                    child:
                                                                        _buildOrderDesign(
                                                                      image:
                                                                          "${orderModelList[index].services?.thumbnail}",
                                                                      name:
                                                                          "${orderModelList[index].services?.name}",
                                                                      color: getStatusColor(
                                                                          "${orderModelList[index].status}"),
                                                                      date:
                                                                          "${orderModelList[index].createdAt}",
                                                                      price:
                                                                          "${orderModelList[index].payAmount}",
                                                                      orderId:
                                                                          "${orderModelList[index].orderId}",
                                                                      status:
                                                                          "${orderModelList[index].orderStatus}",
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                        : selectOrder == 4
                                                            ? counsellingModelList
                                                                    .isEmpty
                                                                ? showShimmerScreen
                                                                    ? const OrderShimmerWidget()
                                                                    : const NoInternetOrDataScreenWidget(
                                                                        isNoInternet:
                                                                            false,
                                                                        icon: Images
                                                                            .noOrder,
                                                                        message:
                                                                            'no_order_found',
                                                                      )
                                                                : ListView
                                                                    .builder(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        counsellingModelList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          // Navigator.push(
                                                                          //     context,
                                                                          //     PageAnimationTransition(
                                                                          //         page: CounsellingTrackOrder(
                                                                          //           poojaId: "${counsellingModelList[index].orderId}",
                                                                          //         ),
                                                                          //         pageAnimationType: RightToLeftTransition()));
                                                                          // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                                          print(
                                                                              "chal rha he");
                                                                        },
                                                                        child:
                                                                            _buildOrderDesign(
                                                                          image:
                                                                              "${counsellingModelList[index].services?.thumbnail}",
                                                                          name:
                                                                              "${counsellingModelList[index].services?.name}",
                                                                          color:
                                                                              getStatusColor("${counsellingModelList[index].status}"),
                                                                          date:
                                                                              "${counsellingModelList[index].createdAt}",
                                                                          price:
                                                                              "${counsellingModelList[index].payAmount}",
                                                                          orderId:
                                                                              "${counsellingModelList[index].orderId}",
                                                                          status:
                                                                              "${counsellingModelList[index].orderStatus}",
                                                                        ),
                                                                      );
                                                                    },
                                                                  )
                                                            : selectOrder == 5
                                                                ? eventModelList
                                                                        .isEmpty
                                                                    ? showShimmerScreen
                                                                        ? const OrderShimmerWidget()
                                                                        : const NoInternetOrDataScreenWidget(
                                                                            isNoInternet:
                                                                                false,
                                                                            icon:
                                                                                Images.noOrder,
                                                                            message:
                                                                                'no_order_found',
                                                                          )
                                                                    : ListView
                                                                        .builder(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        physics:
                                                                            const BouncingScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            eventModelList.length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  CupertinoPageRoute(
                                                                                    builder: (context) => TrackEventDetails(
                                                                                      orderId: eventModelList[index].id ?? 0,
                                                                                    ),
                                                                                  ));
                                                                            },
                                                                            child:
                                                                                _buildOrderDesign(
                                                                              image: eventModelList[index].eventImage,
                                                                              name: eventModelList[index].enEventName,
                                                                              color: Colors.deepOrange,
                                                                              date: eventModelList[index].eventBookingDate,
                                                                              price: "${eventModelList[index].amount}",
                                                                              orderId: eventModelList[index].orderNo,
                                                                              status: "Event",
                                                                            ),
                                                                          );
                                                                        },
                                                                      )
                                                                : selectOrder ==
                                                                        6
                                                                    ? tourModelList
                                                                            .isEmpty
                                                                        ? showShimmerScreen
                                                                            ? const OrderShimmerWidget()
                                                                            : const NoInternetOrDataScreenWidget(
                                                                                isNoInternet: false,
                                                                                icon: Images.noOrder,
                                                                                message: 'no_order_found',
                                                                              )
                                                                        : ListView
                                                                            .builder(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            physics:
                                                                                const BouncingScrollPhysics(),
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                tourModelList.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  print(tourModelList[index].id);
                                                                                  // Navigator.push(
                                                                                  //     context,
                                                                                  //     CupertinoPageRoute(
                                                                                  //       builder: (context) => TrackTourDetails(orderId: "${tourModelList[index].id}"),
                                                                                  //     ));
                                                                                  //Navigator.push(context, CupertinoPageRoute(builder: (context) => TrackTourDetails(orderId: tourModelList[index].orderId,pickUpDate: tourModelList[index].pickupDate,userId: userId,),));
                                                                                },
                                                                                child: _buildOrderDesign(
                                                                                  image: tourModelList[index].tourImage,
                                                                                  name: tourModelList[index].enTourName,
                                                                                  color: tourModelList[index].refundStatus == 1
                                                                                      ? Colors.red
                                                                                      : tourModelList[index].partPayment == "part"
                                                                                          ? Colors.blue
                                                                                          : tourModelList[index].partPayment == "full"
                                                                                              ? Colors.green
                                                                                              : tourModelList[index].partPayment == "custom"
                                                                                                  ? Colors.orange
                                                                                                  : Colors.grey,
                                                                                  date: "${tourModelList[index].bookingTime}",
                                                                                  price: "${tourModelList[index].payAmount}",
                                                                                  orderId: "${tourModelList[index].orderId}",
                                                                                  status: tourModelList[index].refundStatus == 1
                                                                                      ? "Refunded"
                                                                                      : tourModelList[index].partPayment == "part"
                                                                                          ? "Partially Paid"
                                                                                          : tourModelList[index].partPayment == "full"
                                                                                              ? "Fully Paid"
                                                                                              : tourModelList[index].partPayment == "custom"
                                                                                                  ? "Custom"
                                                                                                  : (tourModelList[index].amountStatus == 1 ? "Success" : "Failed"),
                                                                                ),
                                                                              );
                                                                            },
                                                                          )
                                                                    : selectOrder ==
                                                                            7
                                                                        ? pdfModelList
                                                                                .isEmpty
                                                                            ? showShimmerScreen
                                                                                ? const OrderShimmerWidget()
                                                                                : const NoInternetOrDataScreenWidget(
                                                                                    isNoInternet: false,
                                                                                    icon: Images.noOrder,
                                                                                    message: 'no_order_found',
                                                                                  )
                                                                            : TabBarKundali(
                                                                                context)
                                                                        : selectOrder ==
                                                                                8
                                                                            ? donationModelList.isEmpty
                                                                                ? showShimmerScreen
                                                                                    ? const OrderShimmerWidget()
                                                                                    : const NoInternetOrDataScreenWidget(
                                                                                        isNoInternet: false,
                                                                                        icon: Images.noOrder,
                                                                                        message: 'no_order_found',
                                                                                      )
                                                                                : ListView.builder(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    itemCount: donationModelList.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return InkWell(
                                                                                        onTap: () {
                                                                                          Navigator.push(
                                                                                              context,
                                                                                              PageAnimationTransition(
                                                                                                  page:
                                                                                                      //DonationSuccessScreen(),
                                                                                                      TrackDonationDetails(
                                                                                                    donationId: "${donationModelList[index].id}",
                                                                                                  ),
                                                                                                  pageAnimationType: RightToLeftTransition()));
                                                                                        },
                                                                                        child: _buildOrderDesign(
                                                                                          image: donationModelList[index].image,
                                                                                          name: donationModelList[index].enTrustName,
                                                                                          color: Colors.orange,
                                                                                          date: donationModelList[index].date,
                                                                                          price: "${donationModelList[index].amount}",
                                                                                          orderId: donationModelList[index].orderId,
                                                                                          status: donationModelList[index].type,
                                                                                          subscriptionId: donationModelList[index].frequency,
                                                                                          Ordertype: "donation",
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  )
                                                                            : selectOrder == 9
                                                                                ? offlineModelList.isEmpty
                                                                                    ? showShimmerScreen
                                                                                        ? const OrderShimmerWidget()
                                                                                        : const NoInternetOrDataScreenWidget(
                                                                                            isNoInternet: false,
                                                                                            icon: Images.noOrder,
                                                                                            message: 'no_order_found',
                                                                                          )
                                                                                    : ListView.builder(
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        physics: const BouncingScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        itemCount: offlineModelList.length,
                                                                                        itemBuilder: (context, index) {
                                                                                          return InkWell(
                                                                                            onTap: () {
                                                                                              // Navigator.push(
                                                                                              //     context,
                                                                                              //     PageAnimationTransition(
                                                                                              //         page: OfflinePoojaTrackOrder(
                                                                                              //           poojaId: offlineModelList[index].orderId,
                                                                                              //         ),
                                                                                              //         pageAnimationType: RightToLeftTransition()));
                                                                                              // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                                                              print("chal rha he");
                                                                                            },
                                                                                            child: _buildOrderDesign(
                                                                                              image: offlineModelList[index].services!.thumbnail,
                                                                                              name: offlineModelList[index].services!.name,
                                                                                              color: getStatusColor(offlineModelList[index].status),
                                                                                              date: "${offlineModelList[index].createdAt}",
                                                                                              price: offlineModelList[index].payAmount,
                                                                                              orderId: offlineModelList[index].orderId,
                                                                                              status: offlineModelList[index].status,
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      )
                                                                                : selectOrder == 10
                                                                                    ? darshanModelList.isEmpty
                                                                                        ? showShimmerScreen
                                                                                            ? const OrderShimmerWidget()
                                                                                            : const NoInternetOrDataScreenWidget(
                                                                                                isNoInternet: false,
                                                                                                icon: Images.noOrder,
                                                                                                message: 'no_order_found',
                                                                                              )
                                                                                        : ListView.builder(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            physics: const BouncingScrollPhysics(),
                                                                                            shrinkWrap: true,
                                                                                            itemCount: darshanModelList.length,
                                                                                            itemBuilder: (context, index) {
                                                                                              return InkWell(
                                                                                                onTap: () {
                                                                                                  Navigator.push(
                                                                                                      context,
                                                                                                      PageAnimationTransition(
                                                                                                          page: MandirDarshanDetailsOrder(
                                                                                                            orderId: darshanModelList[index].id.toString(),
                                                                                                          ),
                                                                                                          pageAnimationType: RightToLeftTransition()));
                                                                                                  // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                                                                  print("chal rha he ${darshanModelList[index].id.toString()}");
                                                                                                },
                                                                                                child: _buildOrderDesign(
                                                                                                  image: darshanModelList[index].image,
                                                                                                  name: darshanModelList[index].enTempleName,
                                                                                                  color: darshanModelList[index].status == 1 ? Colors.green : Colors.red,
                                                                                                  date: darshanModelList[index].createdAt,
                                                                                                  price: "${darshanModelList[index].price}",
                                                                                                  orderId: darshanModelList[index].orderId,
                                                                                                  status: darshanModelList[index].status == 1 ? "Success" : "Failed",
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          )
                                                                                    : selectOrder == 11
                                                                                        ? panditPoojaOrderModelList.isEmpty
                                                                                            ? showShimmerScreen
                                                                                                ? const OrderShimmerWidget()
                                                                                                : const NoInternetOrDataScreenWidget(
                                                                                                    isNoInternet: false,
                                                                                                    icon: Images.noOrder,
                                                                                                    message: 'no_order_found',
                                                                                                  )
                                                                                            : ListView.builder(
                                                                                                padding: const EdgeInsets.all(10),
                                                                                                physics: const BouncingScrollPhysics(),
                                                                                                shrinkWrap: true,
                                                                                                itemCount: panditPoojaOrderModelList.length,
                                                                                                itemBuilder: (context, index) {
                                                                                                  return InkWell(
                                                                                                    onTap: () {
                                                                                                      Navigator.push(
                                                                                                          context,
                                                                                                          PageAnimationTransition(
                                                                                                              page: MahakalTrackOrder(
                                                                                                                poojaId: "${panditPoojaOrderModelList[index].orderId}",
                                                                                                                typePooja: 'pooja',
                                                                                                              ),
                                                                                                              pageAnimationType: RightToLeftTransition()));

                                                                                                      // Navigator.push(context, CupertinoPageRoute(builder: (context) => PoojaTrackScreen()));
                                                                                                      print("chal rha he ${panditPoojaOrderModelList[index].id.toString()}");
                                                                                                    },
                                                                                                    child: _buildOrderDesign(
                                                                                                      image: panditPoojaOrderModelList[index].services?.thumbnail ?? '',
                                                                                                      name: panditPoojaOrderModelList[index].services?.name ?? '',
                                                                                                      color: panditPoojaOrderModelList[index].status == 1 ? Colors.green : Colors.red,
                                                                                                      date: panditPoojaOrderModelList[index].createdAt ?? '',
                                                                                                      price: "${panditPoojaOrderModelList[index].payAmount}",
                                                                                                      orderId: panditPoojaOrderModelList[index].orderId,
                                                                                                      status: panditPoojaOrderModelList[index].status ?? '',
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                              )
                                                                                            : const SizedBox()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
      ),
    );
  }

  Widget TabBarKundali(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      initialIndex: 0, // Default tab index
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          TabBar(
            splashFactory: NoSplash.splashFactory,
            labelColor: Colors.deepOrange, // active tab text color
            unselectedLabelColor: Colors.grey, // inactive tab text color
            dividerColor: Colors.grey.shade500,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.deepOrange), // active tab underline color
              insets: EdgeInsets.symmetric(horizontal: 0.0), // optional spacing
            ),
            tabs: const [
              Tab(text: "Kundli"),
              Tab(text: "Kundali Milan"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                KundliWidget(),
                KundaliMilanWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget KundliWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: pdfModelList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageAnimationTransition(
                  page: PdfOrderDetails(
                    orderId: "${pdfModelList[index].id}",
                    type: 'kundali',
                  ),
                  pageAnimationType: RightToLeftTransition(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Image with decorative border
                    Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: "${pdfModelList[index].image}",
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: Icon(
                              Icons.insert_drive_file_rounded,
                              color: Colors.grey[400],
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Details section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name with status chip
                          Text(
                            pdfModelList[index].maleName ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.titleLarge?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          // Metadata row
                          Row(
                            children: [
                              Icon(
                                Icons.language,
                                size: 16,
                                color: Colors.blueGrey[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Language - ${pdfModelList[index].language == 'hi' ? 'Hindi' : pdfModelList[index].language == 'en' ? 'English' : pdfModelList[index].language}",
                                style: TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Date row
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: Colors.blueGrey[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pdfModelList[index].createdAt != null
                                    ? formatBookingDate(
                                        "${pdfModelList[index].createdAt}")
                                    : "N/A",
                                style: TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Price and action
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹${pdfModelList[index].amount}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
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
    );
  }

  Widget KundaliMilanWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: pdfMilanModelList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageAnimationTransition(
                  page: PdfOrderDetails(
                    orderId: "${pdfMilanModelList[index].id}",
                    type: 'kundali_milan',
                  ),
                  pageAnimationType: RightToLeftTransition(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Container
                    Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.2),
                            Theme.of(context).primaryColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: "${pdfMilanModelList[index].image}",
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.photo_library_rounded,
                              color: Colors.grey[400],
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Details Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Couple Names
                          Text(
                            "${pdfMilanModelList[index].maleName} + ${pdfMilanModelList[index].femaleName}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.titleLarge?.color,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 6),

                          // Chart Style
                          Row(
                            children: [
                              Icon(
                                Icons.language,
                                color: Colors.blueGrey[400],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Language - ${pdfMilanModelList[index].language == 'hi' ? 'Hindi' : pdfMilanModelList[index].language == 'en' ? 'English' : pdfMilanModelList[index].language}",
                                style: TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Date
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.blueGrey[400],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pdfMilanModelList[index].createdAt != null
                                    ? formatBookingDate(
                                        "${pdfMilanModelList[index].createdAt}")
                                    : "N/A",
                                style: TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Price and Status Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price
                              Text(
                                "₹${pdfMilanModelList[index].amount}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),

                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
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
    );
  }

  Widget _buildOrderDesign(
      {required String image,
      required String name,
      required Color color,
      required String date,
      required String price,
      required String orderId,
      required String status,
      String subscriptionId = "",
      String Ordertype = "",
      String? type}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            /// Image Section
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      width: 120,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        width: 120,
                        height: 70,
                        child: const Center(
                            child: Icon(
                          Icons.image,
                          color: Colors.deepOrange,
                        )),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        width: 120,
                        height: 70,
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                selectOrder == 111
                    ? Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 24,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.lerp(
                                        Colors.deepOrange,
                                        Colors.red.withOpacity(0.3),
                                        sin(_controller.value * pi))!,
                                    Color.lerp(
                                        Colors.amber.withOpacity(0.3),
                                        Colors.red,
                                        sin(_controller.value * pi))!,
                                  ],
                                  stops: const [0.0, 1.0],
                                  tileMode: TileMode.mirror,
                                ),
                                border: const Border(
                                  top: BorderSide(
                                      color: Colors.black, width: 1.0),
                                  bottom: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "$type".toUpperCase().replaceAll("_", " "),
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Ensure contrast with background
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        // Add shadow for better visibility
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 2,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(width: 16),

            /// Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),

                      // Positioned Subscription Badge
                      (Ordertype == "donation" && subscriptionId != "one_time")
                          ? Expanded(
                              flex: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.verified,
                                    size: 18, color: Colors.white),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),

                  /// Order ID
                  Text(
                    'Order #$orderId',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),

                  /// Date
                  Text(
                    'Date: ${formatBookingDate(date)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),

                  /// price
                  Row(
                    children: [
                      Text(
                        price == "0" ? "Free" : 'Price: ₹$price',
                        style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),

                      /// Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          border: Border.all(color: color),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
