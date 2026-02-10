import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mahakal/features/maha_bhandar/model/festival_event_model.dart';
import 'package:intl/intl.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';

import '../../../../data/datasource/remote/http/httpClient.dart';
import '../../../../utill/app_constants.dart';
import 'fast_festival_details.dart';

class FastFestivalsList extends StatefulWidget {
  String festivalName;
  String title;
  FastFestivalsList(
      {super.key, required this.festivalName, required this.title});

  @override
  State<FastFestivalsList> createState() => _FastFestivalsListState();
}

class _FastFestivalsListState extends State<FastFestivalsList> {
  bool isToday = true;
  bool gridList = false;
  bool shimmerEffect = false;
  DateTime now = DateTime.now();
  DateTime yearNow = DateTime.now();
  var festivalData = <FestivalEvents>[];

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

  void goToNextYear() {
    setState(() {
      // Increment the current year by 1 while keeping the same month and day
      yearNow = DateTime(yearNow.year + 1, yearNow.month, yearNow.day);

      // Apply shimmer effect
      shimmerEffect = true;
    });

    showShimmer();
  }

  void goToPreviewYear() {
    setState(() {
      // Increment the current year by 1 while keeping the same month and day
      yearNow = DateTime(yearNow.year - 1, yearNow.month, yearNow.day);

      // Apply shimmer effect
      shimmerEffect = true;
    });

    showShimmer();
  }

  Future getFestivals() async {
    shimmerEffect = true;
    var res = await HttpService()
        .getApi("${AppConstants.getFestivalDetails}${widget.festivalName}");
    print("Festival data:$res");
    festivalData = festivalEventsFromJson(jsonEncode(res));
    shimmerEffect = false;
    setState(() {});
  }
  //
  // void getYearlyData() async{
  //   var response =  await HttpService().getApi("${AppConstants.getFestivalDetails}")
  // }

  @override
  void initState() {
    getFestivals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String festivalYear = DateFormat('- yyyy -').format(yearNow);
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.orange),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        goToPreviewYear();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.orange, width: 2)),
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
                          border: Border.all(color: Colors.orange, width: 2)),
                      child: Center(
                          child: Text(festivalYear,
                              style: TextStyle(
                                fontSize: screenHeight * 0.020,
                              ))),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        goToNextYear();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.orange, width: 2)),
                        child: const Center(
                            child: Icon(Icons.keyboard_arrow_right)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            shimmerEffect == true
                ? const Shimmerscreen()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount:
                        festivalData.length, // Number of items in the list
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageAnimationTransition(
                                  page: FastFestivalsDetails(
                                    title: festivalData[index].eventName,
                                    hiDescription:
                                        festivalData[index].hiDescription,
                                    enDescription:
                                        festivalData[index].enDescription,
                                    image: festivalData[index].image,
                                  ),
                                  pageAnimationType:
                                      RightToLeftFadedTransition()));
                          // detailSheet(
                          //       context,
                          //       festivalData[index].eventName,
                          //       festivalData[index].image,
                          //       festivalData[index].hiDescription,
                          //       festivalData[index].enDescription
                          //     );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      separateDate(festivalData[index]
                                                      .eventDate)
                                                  .length >
                                              5
                                          ? separateDate(
                                                  festivalData[index].eventDate)
                                              .substring(0, 2)
                                          : separateDate(
                                              festivalData[index].eventDate),
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      separateDay(
                                          festivalData[index].eventDate),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(festivalData[index].eventName,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.022,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        separateDate(
                                            festivalData[index].eventDate),
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Image.network(
                                      festivalData[index].image,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }

  void locationSheet(BuildContext context, String title, String image,
      String hiDiscription, String enDiscription) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          bool isTranslate = false;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Expanded(
                      flex: 0,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "✤ $title ✤",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: BouncingWidgetInOut(
                              onPressed: () {
                                modalSetter(() {
                                  isTranslate = !isTranslate;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: isTranslate
                                        ? Colors.red
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: isTranslate
                                            ? Colors.transparent
                                            : Colors.red,
                                        width: 2)),
                                child: Icon(
                                  Icons.translate,
                                  color:
                                      isTranslate ? Colors.white : Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //Image
                            Container(
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(image)),
                            ),

                            Text(
                              "⦿ More Detail's",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.030,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),

                            //information
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 10),
                              child: Html(
                                data:
                                    isTranslate ? hiDiscription : enDiscription,
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
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
