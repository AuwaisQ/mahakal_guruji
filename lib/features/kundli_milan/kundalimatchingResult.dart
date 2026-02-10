import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import '../../main.dart';
import '../profile/controllers/profile_contrroller.dart';
import 'component/ashtakootdetails.dart';
import 'component/birthdetail.dart';
import 'component/dashakootdetails.dart';
import 'component/horoscopedetail.dart';
import 'component/manglikdetails.dart';
import 'component/matchingdetails.dart';
import 'component/planetdetails.dart';
import 'models/ashtakootDetailsModel.dart';
import 'models/birthDetailModel.dart';
import 'models/dashakootDetailModel.dart';
import 'models/manglikDetailModel.dart';
import 'models/matchingDetailModel.dart';
import 'models/planetDetailModel.dart';

class KundliMatchingResultView extends StatefulWidget {
  //Male data
  final String maleName;
  final String maleDate;
  final String maleTime;
  final String maleCountry;
  final String maleCity;
  final String maleLati;
  final String maleLongi;
  // Female data
  final String femaleName;
  final String femaleDate;
  final String femaleTime;
  final String femaleCountry;
  final String femaleCity;
  final String femaleLati;
  final String femaleLongi;
  const KundliMatchingResultView(
      {super.key,
      required this.maleName,
      required this.maleDate,
      required this.maleTime,
      required this.maleCountry,
      required this.maleCity,
      required this.maleLati,
      required this.maleLongi,
      required this.femaleName,
      required this.femaleDate,
      required this.femaleTime,
      required this.femaleCountry,
      required this.femaleCity,
      required this.femaleLati,
      required this.femaleLongi});

  @override
  State<KundliMatchingResultView> createState() =>
      _KundliMatchingResultViewState();
}

class _KundliMatchingResultViewState extends State<KundliMatchingResultView> {
  //Variables
  BirthDetailModel? birthDetailData;
  MatchingDetailModel? matchingDetailData;
  ManglikDetailModel? manglikDetailData;
  DashakootDetailModel? dashakootDetailData;
  AshtakootDetailModel? ashtakootDetailData;
  PlanetDetailModel? planetDetailData;

  String translateEn = 'hi';
  String userId = '';

  @override
  void initState() {
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    getKundliBirth();
  }

  bool isShimmer = false;

  void getKundliBirth() async {
    var res = await HttpService().postApi(AppConstants.kundliMilanURL, {
      "user_id": userId,
      "device_id": "123",
      "male_name": widget.maleName,
      "male_date": widget.maleDate,
      "male_time": widget.maleTime,
      "male_country": widget.maleCountry,
      "male_city": widget.maleCity,
      "male_latitude": widget.maleLati,
      "male_longitude": widget.maleLongi,
      "male_timezone": "5.5",
      "female_name": widget.femaleName,
      "female_date": widget.femaleDate,
      "female_time": widget.femaleTime,
      "female_country": widget.femaleCountry,
      "female_city": widget.femaleCity,
      "female_latitude": widget.femaleLati,
      "female_longitude": widget.femaleLongi,
      "female_timezone": "5.5",
      "language": translateEn,
      "tab": "birth-detail"
    });
    if (res['status'] == 200) {
      print("Kundli Astro Data -$res");
      setState(() {
        birthDetailData = birthDetailModelFromJson(jsonEncode(res));
        // planetDetailData = planetDetailModelFromJson(jsonEncode(res));
        // matchingDetailData = matchingDetailModelFromJson(jsonEncode(res));
        // manglikDetailData = manglikDetailModelFromJson(jsonEncode(res));
        // dashakootDetailData = dashakootDetailModelFromJson(jsonEncode(res));
        // ashtakootDetailData = ashtakootDetailModelFromJson(jsonEncode(res));
      });
      getKundliMatching();
      getKundliManglik();
      getKundliDashakoot();
      getKundliAshtakoot();
      getKundliPlanet();
      setState(() {
        isShimmer = false;
      });
    } else {
      // Handle API response failure
    }
  }

  void getKundliPlanet() async {
    var res = await HttpService().postApi(AppConstants.kundliMilanURL, {
      "user_id": userId,
      "device_id": "123",
      "male_name": widget.maleName,
      "male_date": widget.maleDate,
      "male_time": widget.maleTime,
      "male_country": widget.maleCountry,
      "male_city": widget.maleCity,
      "male_latitude": widget.maleLati,
      "male_longitude": widget.maleLongi,
      "male_timezone": "5.5",
      "female_name": widget.femaleName,
      "female_date": widget.femaleDate,
      "female_time": widget.femaleTime,
      "female_country": widget.femaleCountry,
      "female_city": widget.femaleCity,
      "female_latitude": widget.femaleLati,
      "female_longitude": widget.femaleLongi,
      "female_timezone": "5.5",
      "language": translateEn,
      "tab": "planet-detail"
    });
    if (res['status'] == 200) {
      print("Kundli planet Data -$res");
      setState(() {
        planetDetailData = planetDetailModelFromJson(jsonEncode(res));
      });
    } else {
      // Handle API response failure
    }
  }

  void getKundliMatching() async {
    var res = await HttpService().postApi(AppConstants.kundliMilanURL, {
      "user_id": userId,
      "device_id": "123",
      "male_name": widget.maleName,
      "male_date": widget.maleDate,
      "male_time": widget.maleTime,
      "male_country": widget.maleCountry,
      "male_city": widget.maleCity,
      "male_latitude": widget.maleLati,
      "male_longitude": widget.maleLongi,
      "male_timezone": "5.5",
      "female_name": widget.femaleName,
      "female_date": widget.femaleDate,
      "female_time": widget.femaleTime,
      "female_country": widget.femaleCountry,
      "female_city": widget.femaleCity,
      "female_latitude": widget.femaleLati,
      "female_longitude": widget.femaleLongi,
      "female_timezone": "5.5",
      "language": translateEn,
      "tab": "match-making-detail"
    });
    if (res['status'] == 200) {
      print("Kundli Matching Data -$res");
      setState(() {
        matchingDetailData = matchingDetailModelFromJson(jsonEncode(res));
      });
    } else {
      // Handle API response failure
    }
  }

  void getKundliManglik() async {
    var res = await HttpService().postApi(AppConstants.kundliMilanURL, {
      "user_id": userId,
      "device_id": "123",
      "male_name": widget.maleName,
      "male_date": widget.maleDate,
      "male_time": widget.maleTime,
      "male_country": widget.maleCountry,
      "male_city": widget.maleCity,
      "male_latitude": widget.maleLati,
      "male_longitude": widget.maleLongi,
      "male_timezone": "5.5",
      "female_name": widget.femaleName,
      "female_date": widget.femaleDate,
      "female_time": widget.femaleTime,
      "female_country": widget.femaleCountry,
      "female_city": widget.femaleCity,
      "female_latitude": widget.femaleLati,
      "female_longitude": widget.femaleLongi,
      "female_timezone": "5.5",
      "language": translateEn,
      "tab": "manglik-detail"
    });
    if (res['status'] == 200) {
      print("Kundli Manglik Data -$res");
      setState(() {
        manglikDetailData = manglikDetailModelFromJson(jsonEncode(res));
      });
    } else {
      // Handle API response failure
    }
  }

  void getKundliDashakoot() async {
    var res = await HttpService().postApi(AppConstants.kundliMilanURL, {
      "user_id": userId,
      "device_id": "123",
      "male_name": widget.maleName,
      "male_date": widget.maleDate,
      "male_time": widget.maleTime,
      "male_country": widget.maleCountry,
      "male_city": widget.maleCity,
      "male_latitude": widget.maleLati,
      "male_longitude": widget.maleLongi,
      "male_timezone": "5.5",
      "female_name": widget.femaleName,
      "female_date": widget.femaleDate,
      "female_time": widget.femaleTime,
      "female_country": widget.femaleCountry,
      "female_city": widget.femaleCity,
      "female_latitude": widget.femaleLati,
      "female_longitude": widget.femaleLongi,
      "female_timezone": "5.5",
      "language": translateEn,
      "tab": "dashakoot-detail"
    });
    if (res['status'] == 200) {
      print("Kundli Dashakoot Data -$res");
      setState(() {
        dashakootDetailData = dashakootDetailModelFromJson(jsonEncode(res));
      });
    } else {
      // Handle API response failure
    }
  }

  void getKundliAshtakoot() async {
    var res = await HttpService().postApi(AppConstants.kundliMilanURL, {
      "user_id": userId,
      "device_id": "123",
      "male_name": widget.maleName,
      "male_date": widget.maleDate,
      "male_time": widget.maleTime,
      "male_country": widget.maleCountry,
      "male_city": widget.maleCity,
      "male_latitude": widget.maleLati,
      "male_longitude": widget.maleLongi,
      "male_timezone": "5.5",
      "female_name": widget.femaleName,
      "female_date": widget.femaleDate,
      "female_time": widget.femaleTime,
      "female_country": widget.femaleCountry,
      "female_city": widget.femaleCity,
      "female_latitude": widget.femaleLati,
      "female_longitude": widget.femaleLongi,
      "female_timezone": "5.5",
      "language": translateEn,
      "tab": "ashtakoot-detail"
    });
    if (res['status'] == 200) {
      print("Kundli Ashtakoot Data -$res");
      setState(() {
        ashtakootDetailData = ashtakootDetailModelFromJson(jsonEncode(res));
      });
    } else {
      // Handle API response failure
    }
  }

  bool gridList = false;
  bool fontSizeChange = true;
  double fontSizeDefault = 16.0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // Number of inner tabs
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Row(
          children: [
            const Spacer(),
            fontSizeChange
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Slider(
                      inactiveColor: Colors.grey,
                      activeColor: Colors.orange,
                      label: "$fontSizeDefault",
                      value: fontSizeDefault,
                      min: 12.0,
                      max: 32.0,
                      onChanged: (double value) {
                        setState(() {
                          fontSizeDefault = value;
                        });
                      },
                    ),
                  ),
            FloatingActionButton.small(
              backgroundColor: Colors.orange,
              onPressed: () {
                setState(() {
                  fontSizeChange = !fontSizeChange;
                });
              },
              child: Icon(
                fontSizeChange ? Icons.text_fields : Icons.cancel,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        appBar: AppBar(
          title: const Text(
            "Kundli Matching",
            style: TextStyle(color: Colors.orange),
          ),
          actions: [
            BouncingWidgetInOut(
              onPressed: () {
                setState(() {
                  isShimmer = true;
                  gridList = !gridList;
                  translateEn = gridList ? 'en' : 'hi';
                });
                getKundliBirth();
              },
              bouncingType: BouncingType.bounceInAndOut,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: gridList ? Colors.orange : Colors.white,
                    border: Border.all(color: Colors.orange, width: 2)),
                child: Center(
                  child: Icon(Icons.translate,
                      color: gridList ? Colors.white : Colors.orange),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          children: [
            //Tabs
            Container(
              height: 40,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey)),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.white,
                labelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontSize: 18,
                ),
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(
                        6.0) // Set the background color of the indicator
                    ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Text(
                        translateEn == "hi" ? "जन्म विवरण" : "Birth Details"),
                  ),
                  Tab(
                    child: Text(translateEn == "hi"
                        ? "ग्रहों का विवरण"
                        : "Description Of Planet"),
                  ),
                  Tab(
                    child: Text(translateEn == "hi"
                        ? "कुंडली विवरण"
                        : "Horoscope details"),
                  ),
                  Tab(
                    child: Text(translateEn == "hi"
                        ? "अष्टकूट मिलान"
                        : "Ashtakoot Matching"),
                  ),
                  Tab(
                    child: Text(translateEn == "hi"
                        ? "दशकूट मिलान"
                        : "Dashakoot Matching"),
                  ),
                  Tab(
                    child: Text(translateEn == "hi"
                        ? "मांगलिक विवरण"
                        : "Manglik Vivran"),
                  ),
                  Tab(
                    child: Text(translateEn == "hi"
                        ? "मिलान विवरण"
                        : "Matching Details"),
                  ),
                ],
              ),
            ),
            //TAbViewz
            Expanded(
              child: isShimmer
                  ? const Shimmerscreen()
                  : TabBarView(
                      children: [
                        BirthDetailsView(
                          data: birthDetailData,
                          translateEn: translateEn,
                        ),
                        // Content for inner Tab 1
                        PlanetDetailView(
                          data: planetDetailData,
                          fontSizeDefault: fontSizeDefault,
                        ),
                        // Content for inner Tab 1
                        HoroscopeChartView(
                          maleName: widget.maleName,
                          maleDate: widget.maleDate,
                          maleTime: widget.maleTime,
                          maleCountry: widget.maleCountry,
                          maleCity: widget.maleCity,
                          maleLati: widget.maleLati,
                          maleLongi: widget.maleLongi,
                          femaleName: widget.femaleName,
                          femaleDate: widget.femaleDate,
                          femaleTime: widget.femaleTime,
                          femaleCountry: widget.femaleCountry,
                          femaleCity: widget.femaleCity,
                          femaleLati: widget.femaleLati,
                          femaleLongi: widget.femaleLongi,
                          translate: translateEn,
                        ),
                        // Content for inner Tab 1
                        AshtakootDetailView(
                          data: ashtakootDetailData,
                          fontSizeDefault: fontSizeDefault,
                          translateEn: translateEn,
                        ),
                        // Content for inner Tab 1
                        DashakootDetailView(
                          data: dashakootDetailData,
                          translateEn: translateEn,
                        ),
                        // Content for inner Tab 1
                        ManglikDetailView(
                          data: manglikDetailData,
                          fontSizeDefault: fontSizeDefault,
                          translateEn: translateEn,
                        ),
                        // Content for inner Tab 2
                        MatchingDetailsView(
                          data: matchingDetailData,
                          fontSizeDefault: fontSizeDefault,
                          translateEn: translateEn,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerEffect() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      width: double.infinity,
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey.shade200,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: const Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade100,
                          highlightColor: Colors.orange,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 260,
                      width: 1,
                      color: Colors.red,
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade100,
                          highlightColor: Colors.orange,
                          child: const Column(
                            children: [],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 20, // Number of items in the list
              itemBuilder: (BuildContext context, int index) {
                // itemBuilder function returns a widget for each item in the list
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
