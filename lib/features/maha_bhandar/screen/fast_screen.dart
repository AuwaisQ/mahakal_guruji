import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../utill/app_constants.dart';
import '../model/festival_model.dart';
import 'fast_&_festival_widget/fast_festival_details.dart';
import 'fast_&_festival_widget/fast_festival_list.dart';

class FastView extends StatefulWidget {
  const FastView({super.key});

  @override
  State<FastView> createState() => _FastState();
}

class _FastState extends State<FastView> {
  final TextEditingController _searchController = TextEditingController();

  bool isToday = true;
  bool gridList = true;
  bool yearlyGridList = false;
  bool shimmerEffect = false;
  bool isTranslate = false;
  String month = "";
  String year = "";
  DateTime todayDate = DateTime.now();
  DateTime yearNow = DateTime.now();
  var fastMonthData = <FestivalModel>[];
  var fastYearData = <FestivalModel>[];
  List<FestivalModel> _filteredFasts = [];

  void _filterFast(String query) {
    final filtered = fastYearData.where((festival) {
      return festival.eventName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredFasts = filtered;
      if (_searchController.text.isEmpty) {
        _filteredFasts.clear();
      } else {
        return;
      }
    });
  }

  Future<void> showShimmer() async {
    await Future.delayed(const Duration(
      milliseconds: 1500,
    ));
    setState(() {
      shimmerEffect = false;
    });
  }

  String separateDate(String dateString) {
    // Split the string by the comma and space
    List<String> parts = dateString.split(', ');

    // Ensure the input is in the correct format
    if (parts.length != 2) {
      throw const FormatException(
          "Invalid date string format. Expected format: 'Day, DD-MM-YYYY'");
    }
    String date = parts[1];

    return date;
  }

  String separateDay(String dateString) {
    // Split the string by the comma and space
    List<String> parts = dateString.split(', ');

    // Ensure the input is in the correct format
    if (parts.length != 2) {
      throw const FormatException(
          "Invalid date string format. Expected format: 'Day, DD-MM-YYYY'");
    }
    String day = parts[0];
    return day;
  }

  void goToNextMonth() {
    // Increment the current month by 1
    todayDate = DateTime(todayDate.year, todayDate.month + 1, todayDate.day);
    // Check if we have reached the end of the year
    if (todayDate.month == 13) {
      // If the next month is January of the next year,
      // increment the year as well
      todayDate = DateTime(todayDate.year + 1, 1, todayDate.day);
    }
    getfastMonthData();
    setState(() {});
    showShimmer();
  }

  void goToPreviewMonth() {
    // Increment the current month by 1
    todayDate = DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
    print(todayDate);
    // Check if we have reached the end of the year
    if (todayDate.month == 1) {
      // If the next month is January of the next year,
      // increment the year as well
      todayDate = DateTime(todayDate.year - 1, 13, todayDate.day);
      print(todayDate);
    }
    getfastMonthData();
    setState(() {});
    showShimmer();
  }

  Future getfastMonthData() async {
    shimmerEffect = true;
    month = DateFormat('MM').format(todayDate);
    year = DateFormat('yyyy').format(todayDate);
    print("Month - $month");
    print("Year - $year");
    var res = await HttpService().getApi(
        "${AppConstants.monthlyFestival}?type=Vrat&month=$month&year=$year");
    print("Festival data:$res");
    setState(() {
      fastMonthData = festivalModelFromJson(jsonEncode(res));
      shimmerEffect = false;
    });
    shimmerEffect = false;
  }

  Future getfastYearData() async {
    shimmerEffect = true;
    year = DateFormat('yyyy').format(todayDate);
    print("Year - $year");
    var res = await HttpService()
        .getApi("${AppConstants.monthlyFestival}?type=Vrat&year=$year");
    print("Festival data:$res");
    setState(() {
      fastYearData = festivalModelFromJson(jsonEncode(res));
      shimmerEffect = false;
    });
    shimmerEffect = false;
  }

  @override
  void dispose() {
    goToPreviewMonth();
    showShimmer();
    super.dispose();
  }

  @override
  void initState() {
    getfastMonthData();
    getfastYearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String festivalDate = DateFormat('MMMM-yyyy').format(todayDate);
    double screenHeight = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Expanded(flex: 0, child: SizedBox(height: w * 0.24)),

            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      isToday = true;
                      gridList = true;
                      yearlyGridList = false;
                      setState(() {});
                      // print("$buttonTab");
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: isToday ? Colors.orange : Colors.transparent,
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Monthly",
                        style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.w500,
                            color: isToday ? Colors.white : Colors.grey),
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isToday = false;
                        gridList = true;
                        yearlyGridList = true;
                        getfastYearData();
                        // Toggle the boolean value
                      });
                      // print("$buttonTab");
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: isToday ? Colors.transparent : Colors.orange,
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Yearly",
                        style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            fontWeight:
                                isToday ? FontWeight.w500 : FontWeight.bold,
                            color: isToday ? Colors.grey : Colors.white),
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                BouncingWidgetInOut(
                  onPressed: () {
                    setState(() {
                      isTranslate = !isTranslate;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: isTranslate ? Colors.orange : Colors.transparent,
                        border: Border.all(
                            color: isTranslate
                                ? Colors.transparent
                                : Colors.orange,
                            width: 2)),
                    child: Icon(
                      Icons.translate,
                      color: isTranslate ? Colors.white : Colors.orange,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),

            isToday
                ?
                //Month Change Widget
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 2.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              goToPreviewMonth();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(3.0),
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.orange, width: 2)),
                              child: const Center(
                                  child: Icon(Icons.keyboard_arrow_left)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(3.0),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border:
                                    Border.all(color: Colors.orange, width: 2)),
                            child: Center(
                                child: Text(festivalDate,
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                    ))),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              goToNextMonth();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(3.0),
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.orange, width: 2)),
                              child: const Center(
                                  child: Icon(Icons.keyboard_arrow_right)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        BouncingWidgetInOut(
                          onPressed: () {
                            setState(() {
                              gridList = !gridList;
                            });
                          },
                          bouncingType: BouncingType.bounceInAndOut,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: gridList ? Colors.orange : Colors.white,
                                border:
                                    Border.all(color: Colors.orange, width: 2)),
                            child: Center(
                              child: Icon(
                                  gridList ? Icons.reorder : Icons.grid_view,
                                  color:
                                      gridList ? Colors.white : Colors.orange),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 6.0),
                          height: 45,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: TextFormField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto'),
                                prefixIcon: Icon(Icons.search)),
                            onChanged: (query) {
                              _filterFast(query);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: BouncingWidgetInOut(
                          onPressed: () {
                            setState(() {
                              gridList = !gridList;
                            });
                          },
                          bouncingType: BouncingType.bounceInAndOut,
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: gridList ? Colors.orange : Colors.white,
                                border:
                                    Border.all(color: Colors.orange, width: 2)),
                            child: Center(
                              child: Icon(
                                  gridList ? Icons.reorder : Icons.grid_view,
                                  color:
                                      gridList ? Colors.white : Colors.orange),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

            //List & Grid View's
            shimmerEffect == true
                ? const Shimmerscreen()
                : Column(
                    children: [
                      isToday == true
                          //Monthly
                          ? Column(
                              children: [
                                gridList == false
                                    ? fastMonthData.isEmpty
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 100),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/animated/noData.gif'),
                                                const Text(
                                                  'Data Not\nAvailable',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemCount: fastMonthData.length,
                                            // Number of items in the list
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageAnimationTransition(
                                                          page:
                                                              FastFestivalsDetails(
                                                            title:
                                                                fastMonthData[
                                                                        index]
                                                                    .eventName,
                                                            hiDescription:
                                                                fastMonthData[
                                                                        index]
                                                                    .hiDescription,
                                                            enDescription:
                                                                fastMonthData[
                                                                        index]
                                                                    .enDescription,
                                                            image:
                                                                fastMonthData[
                                                                        index]
                                                                    .image,
                                                          ),
                                                          pageAnimationType:
                                                              RightToLeftFadedTransition()));
                                                  // detailSheet(
                                                  //   context,
                                                  //   fastMonthData[index].eventName,
                                                  //   fastMonthData[index].image,
                                                  //   fastMonthData[index].hiDescription,
                                                  //   fastMonthData[index].enDescription,
                                                  // );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade400),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 0,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              separateDate(fastMonthData[index]
                                                                              .eventDate)
                                                                          .length >
                                                                      5
                                                                  ? separateDate(
                                                                          fastMonthData[index]
                                                                              .eventDate)
                                                                      .substring(
                                                                          0, 2)
                                                                  : separateDate(
                                                                      fastMonthData[
                                                                              index]
                                                                          .eventDate),
                                                              style: const TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              separateDay(
                                                                  fastMonthData[
                                                                          index]
                                                                      .eventDate),
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                isTranslate
                                                                    ? fastMonthData[
                                                                            index]
                                                                        .eventName
                                                                    : fastMonthData[
                                                                            index]
                                                                        .eventNameHi,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenHeight *
                                                                            0.022,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    color: Colors
                                                                        .black87,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Text(
                                                                separateDate(
                                                                    fastMonthData[
                                                                            index]
                                                                        .eventDate),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenHeight *
                                                                            0.018,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 0,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                fastMonthData[
                                                                        index]
                                                                    .image,
                                                            height: 70,
                                                            fit: BoxFit.fill,
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                    : fastMonthData.isEmpty
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 100),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/animated/noData.gif'),
                                                const Text(
                                                  'Data Not\nAvailable',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          )
                                        : GridView.builder(
                                            itemCount: fastMonthData.length,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 0.0,
                                                    mainAxisSpacing: 0.0,
                                                    childAspectRatio: 0.83),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageAnimationTransition(
                                                          page:
                                                              FastFestivalsDetails(
                                                            title: isTranslate
                                                                ? fastMonthData[
                                                                        index]
                                                                    .eventName
                                                                : fastMonthData[
                                                                        index]
                                                                    .eventNameHi,
                                                            hiDescription:
                                                                fastMonthData[
                                                                        index]
                                                                    .hiDescription,
                                                            enDescription:
                                                                fastMonthData[
                                                                        index]
                                                                    .enDescription,
                                                            image:
                                                                fastMonthData[
                                                                        index]
                                                                    .image,
                                                          ),
                                                          pageAnimationType:
                                                              RightToLeftFadedTransition()));
                                                  // detailSheet(
                                                  //   context,
                                                  //   fastMonthData[index].eventName,
                                                  //   fastMonthData[index].image,
                                                  //   fastMonthData[index].hiDescription,
                                                  //   fastMonthData[index].enDescription,
                                                  // );
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(4.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 2)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              fastMonthData[
                                                                      index]
                                                                  .image,
                                                          fit: BoxFit.fill,
                                                          height: 120,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 4.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          separateDate(
                                                              fastMonthData[
                                                                      index]
                                                                  .eventDate),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenHeight *
                                                                      0.022,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          separateDay(
                                                              fastMonthData[
                                                                      index]
                                                                  .eventDate),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenHeight *
                                                                      0.020,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          isTranslate
                                                              ? "✤ ${fastMonthData[index].eventName}"
                                                              : "✤ ${fastMonthData[index].eventNameHi}",
                                                          style: TextStyle(
                                                              // overflow: TextOverflow.ellipsis,
                                                              fontSize:
                                                                  screenHeight *
                                                                      0.022,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                              ],
                            )

                          //Yearly
                          : Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: SizedBox(
                                          child: gridList
                                              ? GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      fastYearData.length,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          childAspectRatio:
                                                              0.99),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    // itemBuilder function returns a widget for each item in the list
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            PageAnimationTransition(
                                                                page:
                                                                    FastFestivalsList(
                                                                  festivalName:
                                                                      fastYearData[
                                                                              index]
                                                                          .eventName,
                                                                  title: 'Fast',
                                                                ),
                                                                pageAnimationType:
                                                                    RightToLeftFadedTransition()));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(4.0),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .purple.shade50,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  child: Image
                                                                      .network(
                                                                    fastYearData[
                                                                            index]
                                                                        .image,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )),
                                                            ),
                                                            Text(
                                                              isTranslate
                                                                  ? fastYearData[
                                                                          index]
                                                                      .eventName
                                                                  : fastYearData[
                                                                          index]
                                                                      .eventNameHi,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenHeight *
                                                                          0.02,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const ScrollPhysics(),
                                                  itemCount:
                                                      fastYearData.length,
                                                  // Number of items in the list
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            PageAnimationTransition(
                                                                page:
                                                                    FastFestivalsList(
                                                                  festivalName:
                                                                      fastYearData[
                                                                              index]
                                                                          .eventName,
                                                                  title: 'Fast',
                                                                ),
                                                                pageAnimationType:
                                                                    RightToLeftFadedTransition()));
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              flex: 0,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    separateDate(fastYearData[index].eventDate).length >
                                                                            5
                                                                        ? separateDate(fastYearData[index].eventDate).substring(
                                                                            0,
                                                                            2)
                                                                        : separateDate(
                                                                            fastYearData[index].eventDate),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            30,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    separateDay(
                                                                        fastYearData[index]
                                                                            .eventDate),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      isTranslate
                                                                          ? fastYearData[index]
                                                                              .eventName
                                                                          : fastYearData[index]
                                                                              .eventNameHi,
                                                                      style: TextStyle(
                                                                          fontSize: screenHeight *
                                                                              0.022,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color: Colors
                                                                              .black87,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                      separateDate(
                                                                          fastYearData[index]
                                                                              .eventDate),
                                                                      style: TextStyle(
                                                                          fontSize: screenHeight *
                                                                              0.018,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade700,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 0,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6.0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      fastYearData[
                                                                              index]
                                                                          .image,
                                                                  height: 70,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .error),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    )
                                  ],
                                ),
                                AnimatedContainer(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  padding: const EdgeInsets.all(10),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInToLinear,
                                  width: double.infinity,
                                  height: _filteredFasts.isEmpty ? 0.0 : 250.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 2),
                                        left: BorderSide(
                                            color: Colors.grey, width: 2),
                                        right: BorderSide(
                                            color: Colors.grey, width: 2)),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0)),
                                  ),
                                  child: ListView.builder(
                                    itemCount: _filteredFasts.length,
                                    itemBuilder: (context, index) {
                                      final fastData = _filteredFasts[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageAnimationTransition(
                                                  page: FastFestivalsList(
                                                    festivalName:
                                                        fastData.eventName,
                                                    title: 'Fast',
                                                  ),
                                                  pageAnimationType:
                                                      RightToLeftFadedTransition()));
                                          _searchController.clear();
                                          _filteredFasts.clear();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    isTranslate
                                                        ? fastData.eventName
                                                        : fastData.eventNameHi,
                                                    style: const TextStyle(
                                                        fontSize: 18)),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.temple_hindu,
                                                  size: 20,
                                                  color: Colors.orange,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            const Divider(
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

class Shimmerscreen extends StatelessWidget {
  const Shimmerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6, // Number of items in the list
            itemBuilder: (BuildContext context, int index) {
              // itemBuilder function returns a widget for each item in the list
              return Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "sau",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        " to ",
                        style: TextStyle(color: Colors.grey, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ShimmerscreenGrid extends StatelessWidget {
  const ShimmerscreenGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: GridView.builder(
            itemCount: 9,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 0.88),
            itemBuilder: (BuildContext context, int index) {
              return Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 2)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
