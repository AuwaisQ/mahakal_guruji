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
  int selectOrder = 4;
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
    fetchAllData(userId);
    fetchPanditPoojaOrders();
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
    Colors.amber,
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
        return Colors.amber; // Default color for unknown statuses
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
            labelColor: Colors.amber,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.amber,
            // indicator: BoxDecoration(
            //     color: Colors.amber,
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
                            color: Colors.amber,
                            onRefresh: () async {
                              // fetchAllData(userId);
                              // fetchPdfData(userId);
                              // fetchDonation(userId);
                              // fetchEventData(userId);
                              // fetchTourData(userId);
                              // fetchVipOrders();
                              // fetchAnushthanOrders();
                              // fetchChadhavaOrders();
                              // fetchPoojaOrders();
                              // fetchPanditPoojaOrders();
                              // fetchOfflinePooja();
                              // fetchConsultationOrders();
                              // fetchDarshanOrders();
                            },
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: [
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
                                                  ? Colors.amber
                                                  : Colors.amber
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
                                                  ? Colors.amber
                                                  : Colors.amber
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

                                        // All Pandit
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: () {
                                            shimmerEffect(11);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7.5),
                                            decoration: BoxDecoration(
                                              color: selectOrder == 11
                                                  ? Colors.amber
                                                  : Colors.amber
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
                                      ]),
                                    )),

                                Expanded(
                                    child: selectOrder == 4
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
                                                                              color: Colors.amber,
                                                                              date: eventModelList[index].eventBookingDate,
                                                                              price: "${eventModelList[index].amount}",
                                                                              orderId: eventModelList[index].orderNo,
                                                                              status: "Event",
                                                                            ),
                                                                          );
                                                                        },
                                                                      )
                                                                :  selectOrder == 11
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
            labelColor: Colors.amber, // active tab text color
            unselectedLabelColor: Colors.grey, // inactive tab text color
            dividerColor: Colors.grey.shade500,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.amber), // active tab underline color
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
                                  color: Colors.amber[700],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Colors.amber[700],
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
                                  color: Colors.amber[700],
                                ),
                              ),

                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Colors.amber[700],
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
                          color: Colors.amber,
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
                                        Colors.amber,
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
                            color: Colors.amber,
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
