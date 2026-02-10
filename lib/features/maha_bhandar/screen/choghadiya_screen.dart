import 'dart:async';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:http/http.dart' as http;
import '../../infopage/infopageview.dart';
import '../model/choghadiya_model.dart';
import '../model/choghdaiyaDayNight_model.dart';
import '../model/city_model.dart';

class ChoghadiyaScreen extends StatefulWidget {
  final String? cityName;
  final String? localityName;
  const ChoghadiyaScreen({super.key, this.cityName, this.localityName});

  @override
  State<ChoghadiyaScreen> createState() => _ChoghadiyaScreenState();
}

class _ChoghadiyaScreenState extends State<ChoghadiyaScreen> {
  bool isToday = true;
  bool showDayNight = true;
  bool isDayNight = true;
  bool gridList = true;
  bool gridListTomorrow = true;
  bool dateIncremented = false;
  bool searchbox = false;
  bool isShimmer = false;
  bool isTranslate = false;
  DateTime now = DateTime.now();
  Timer? timer;
  String formattedTime = "";
  String latitude = "23.179300";
  String longitude = "75.784912";
  String countryDefault = "Ujjain/Madhya Pradesh";
  String locationMessage = "";
  String enChoghadiyaInfo =
      "Choghadiya is a traditional Hindu method of scheduling that divides the day into auspicious and inauspicious periods for various activities based on planetary influences. It guides decision-making and scheduling to maximize favorable outcomes and minimize risks according to astrological principles.";
  String hiChoghadiyaInfo =
      "चौघड़िया समय-निर्धारण की एक पारंपरिक हिंदू पद्धति है जो ग्रहों के प्रभाव के आधार पर विभिन्न गतिविधियों के लिए दिन को शुभ और अशुभ अवधियों में विभाजित करती है। यह ज्योतिषीय सिद्धांतों के अनुसार अनुकूल परिणामों को अधिकतम करने और जोखिमों को कम करने के लिए निर्णय लेने और समय-निर्धारण का मार्गदर्शन करता है।";
  // List<ChaughdiyaModel> dayModelList = <ChaughdiyaModel>[];
  // List<ChaughdiyaModel> nightModelList = <ChaughdiyaModel>[];
  // List<dynamic> tomorrowChoghadiyaModelList = [];
  List<ChaughdiyaModel> tomorrowList = <ChaughdiyaModel>[];
  List<dynamic> todayChaughdiyaModel = [];
  List<ChaughdiyaModel> previousDayChoghadiya = <ChaughdiyaModel>[];
  List<ChaughdiyaModel> presentDayChoghadiya = <ChaughdiyaModel>[];

  List<Result> choghadiyaModelList = <Result>[];
  List<Result> tomorrowChoghadiyaModelList = <Result>[];

  List<DayChaughdiya> dayModelList = <DayChaughdiya>[];
  List<NightChaughdiya> nightModelList = <NightChaughdiya>[];
  List<DayChaughdiya> dayModelListTomorrow = <DayChaughdiya>[];
  List<NightChaughdiya> nightModelListTomorrow = <NightChaughdiya>[];

  void toggleTrue() {
    setState(() {
      isToday = true;
    });
  }

  void toggleFalse() {
    setState(() {
      isToday = false; // Toggle the boolean value
    });
  }

  String convertTimeToAmPm(String time) {
    // Parse the time string into a DateTime object
    final dateTime = DateFormat('HH:mm').parse(time);
    // Format the DateTime object into an AM/PM time string
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  Color convertColorCode(String colorCode) {
    int colorInt = int.parse("0xff$colorCode");
    return Color(colorInt);
  }

  void goToNextDate() {
    if (!dateIncremented) {
      setState(() {
        now = now.add(const Duration(days: 1));
        dateIncremented = true;
      });
    }
  }

  void goToCurrentDate() {
    setState(() {
      now = DateTime.now();
      dateIncremented = false;
    });
  }

  final Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "9123456789",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "91-IN-0",
  );

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void getDayNightData() async {
    isShimmer = true;
    var response = await HttpService().postApi(AppConstants.choghadiyaDayUrl, {
      "date": DateFormat('dd/MM/yyyy').format(now),
      "time": DateFormat('HH:mm').format(now),
      "latitude": latitude,
      "longitude": longitude,
      "timezone": "5.5",
      "language": isTranslate ? "en" : "hi"
    });
    setState(() {
      dayModelList.clear();
      nightModelList.clear();
      List dayList = response["dayChaughdiya"];
      dayModelList.addAll(dayList.map((e) => DayChaughdiya.fromJson(e)));

      List nightList = response["nightChaughdiya"];
      nightModelList.addAll(nightList.map((e) => NightChaughdiya.fromJson(e)));
      print("Filtered API response: $nightModelList");
      isShimmer = false;
    });
  }

  void getDayNightDataTomorrow() async {
    isShimmer = true;
    var response = await HttpService().postApi(AppConstants.choghadiyaDayUrl, {
      "date": DateFormat('dd/MM/yyyy').format(now.add(const Duration(days: 1))),
      "time": DateFormat('HH:mm').format(now),
      "latitude": latitude,
      "longitude": longitude,
      "timezone": "5.5",
      "language": isTranslate ? "en" : "hi"
    });
    setState(() {
      dayModelListTomorrow.clear();
      nightModelListTomorrow.clear();
      List dayListTomorrow = response["dayChaughdiya"];
      dayModelListTomorrow
          .addAll(dayListTomorrow.map((e) => DayChaughdiya.fromJson(e)));

      List nightListTomorrow = response["nightChaughdiya"];
      nightModelListTomorrow
          .addAll(nightListTomorrow.map((e) => NightChaughdiya.fromJson(e)));
      isShimmer = false;
    });
  }

  // void getchoghadiyaData() async {
  //   isShimmer = true;
  //   var response = await HttpService().postApi(AppConstants.choghadiyaUrl, {
  //     "date": DateFormat('dd/MM/yyyy').format(now),
  //     "time": DateFormat('HH:mm').format(now),
  //     "latitude": latitude,
  //     "longitude": longitude,
  //     "timezone": "5.5",
  //     "language": isTranslate ? "en" : "hi"
  //   });
  //
  //   setState(() {
  //     List choghList = response["result"];
  //     DateTime currentTime = DateTime.now();
  //     print("Current Time: ${currentTime.toIso8601String()}");
  //
  //     choghadiyaModelList = choghList
  //         .map((e) => Result.fromJson(e))
  //         .where((element) {
  //       DateTime endTime = DateFormat('HH:mm').parse(element.endTime!);
  //
  //       // Convert end time to the same date as the current time
  //       endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, endTime.hour, endTime.minute);
  //
  //       // Print the end time for debugging
  //       print("End Time: ${endTime.toIso8601String()}");
  //
  //        return endTime.isAfter(currentTime);
  //     }).toList();
  //
  //     print("Filtered API response: $choghadiyaModelList");
  //     isShimmer = false;
  //   });
  // }

  void getchoghadiyaData() async {
    isShimmer = true;
    try {
      var response = await HttpService().postApi(AppConstants.choghadiyaUrl, {
        "date": DateFormat('dd/MM/yyyy').format(now),
        "time": DateFormat('HH:mm').format(now),
        "latitude": latitude,
        "longitude": longitude,
        "timezone": "5.5",
        "language": isTranslate ? "en" : "hi"
      });

      setState(() {
        List choghList = response["result"];
        DateTime currentTime = DateTime.now();
        print("Current Time: ${currentTime.toIso8601String()}");

        choghadiyaModelList =
            choghList.map((e) => Result.fromJson(e)).where((element) {
          try {
            DateTime endTime = DateFormat('HH:mm').parse(element.endTime!);

            // Convert end time to the same date as the current time
            if (endTime.hour == 0 && endTime.minute == 0) {
              // Handle the case where endTime is exactly 00:00 (midnight)
              endTime = DateTime(currentTime.year, currentTime.month,
                  currentTime.day + 1, endTime.hour, endTime.minute);
            } else {
              endTime = DateTime(currentTime.year, currentTime.month,
                  currentTime.day, endTime.hour, endTime.minute);
            }

            // Print the end time for debugging
            print("End Time: ${endTime.toIso8601String()}");

            return endTime.isAfter(currentTime);
          } catch (e) {
            print("Error parsing end time: $e");
            return false;
          }
        }).toList();

        print("Filtered API response: $choghadiyaModelList");
        isShimmer = false;
      });
    } catch (e) {
      print("Error in getchoghadiyaData: $e");
      setState(() {
        isShimmer = false;
      });
    }
  }

  Future getChoughadiyaDataTomorrow() async {
    setState(() {
      isShimmer = true;
    });
    var res = await HttpService().postApi(AppConstants.choghadiyaUrl, {
      "date": DateFormat('dd/MM/yyyy').format(now.add(const Duration(days: 1))),
      "time": DateFormat('HH:mm').format(now),
      "latitude": latitude,
      "longitude": longitude,
      "timezone": "5.5",
      "language": isTranslate ? "en" : "hi"
    });
    setState(() {
      tomorrowChoghadiyaModelList.clear();
      List tomorrowList = res['result'];
      tomorrowChoghadiyaModelList
          .addAll(tomorrowList.map((val) => Result.fromJson(val)));
      isShimmer = false;
    });
    formattedTime = DateFormat('HH:mm:ss').format(now);
    isShimmer = false;
  }

  Future<void> getLocation() async {
    setState(() {
      isShimmer = true;
    });

    try {
      // Check if location services are enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are disabled.';
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw 'Location permissions are denied.';
        }
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });

      // Get the address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        countryDefault = placemarks.isNotEmpty
            ? "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].postalCode}, ${placemarks[0].country}"
            : "No address available";
      });
    } catch (e) {
      setState(() {
        locationMessage = "Error: $e";
        countryDefault = "";
      });
    }
  }

  Color hexToColor(String hex) {
    // Add a leading hash if it's not present
    hex = hex.startsWith('#') ? hex : '#$hex';

    // Parse the string as an integer and create a Color object
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  void initState() {
    super.initState();
    isToday = true;
    print(DateFormat('dd/MM/yyyy').format(now));
    getchoghadiyaData();
    getChoughadiyaDataTomorrow();
    getDayNightData();
    getDayNightDataTomorrow();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String chaughadiyadate = DateFormat('dd-MMM-yyyy').format(now);
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 0, child: SizedBox(height: w * 0.21)),
          Expanded(
            flex: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: Column(
                children: [
                  //Location Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 2,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Choghadiya",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    locationSheet(
                                        context, selectedCountry.name);
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text(
                                      countryDefault,
                                      style: TextStyle(
                                          color: Colors.orange,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: screenHeight * 0.02,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.orange,
                                size: 15,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  //Today Tomorrow Button
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            toggleTrue();
                            goToCurrentDate();
                            setState(() {
                              gridList = true;
                              showDayNight = true;
                            });
                            // print("$buttonTab");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(3.0),
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color:
                                      isToday ? Colors.orange : Colors.orange,
                                  width: 2),
                              color: isToday ? Colors.orange : Colors.white,
                            ),
                            child: Center(
                                child: Text(
                              "Today",
                              style: TextStyle(
                                  fontSize: screenHeight * 0.02,
                                  color: isToday ? Colors.white : Colors.black),
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            toggleFalse();
                            goToNextDate();
                            setState(() {
                              gridListTomorrow = true;
                              showDayNight = true;
                            });
                            // print("$buttonTab");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(3.0),
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color:
                                      isToday ? Colors.orange : Colors.orange,
                                  width: 2),
                              color: isToday ? Colors.white : Colors.orange,
                            ),
                            child: Center(
                                child: Text(
                              "Tomorrow",
                              style: TextStyle(
                                  fontSize: screenHeight * 0.02,
                                  color: isToday ? Colors.black : Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Choughadiya Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.horizontal_distribute,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          gridList
                              ? "$chaughadiyadate Chaughadiya"
                              : "Chaughadiya",
                          style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        BouncingWidgetInOut(
                          onPressed: () {
                            setState(() {
                              gridList = !gridList;
                              gridListTomorrow = !gridListTomorrow;
                              showDayNight = !showDayNight;
                            });
                          },
                          bouncingType: BouncingType.bounceInAndOut,
                          child: Center(
                            child: Icon(
                                gridList
                                    ? Icons.grid_view_outlined
                                    : CupertinoIcons.square_favorites,
                                size: 30,
                                color: Colors.orange),
                          ),
                        ),
                        BouncingWidgetInOut(
                          onPressed: () {
                            setState(() {
                              isTranslate = !isTranslate;
                              getchoghadiyaData();
                              getChoughadiyaDataTomorrow();
                              getDayNightData();
                              getDayNightDataTomorrow();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isTranslate
                                    ? Colors.orange
                                    : Colors.transparent,
                                border: Border.all(
                                    color: isTranslate
                                        ? Colors.transparent
                                        : Colors.orange,
                                    width: 2)),
                            child: Icon(
                              Icons.translate,
                              color: isTranslate ? Colors.white : Colors.orange,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //day Night Widget
                  showDayNight
                      ? const SizedBox()
                      : Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isDayNight = true;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3.0),
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: isDayNight
                                            ? Colors.green
                                            : Colors.grey,
                                        width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Day ",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: isDayNight
                                                ? Colors.green
                                                : Colors.grey),
                                      ),
                                      Icon(
                                        Icons.sunny,
                                        color: isDayNight
                                            ? Colors.green
                                            : Colors.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isDayNight = false;
                                  });
                                  // print("$buttonTab");
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3.0),
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: isDayNight
                                            ? Colors.grey
                                            : Colors.red,
                                        width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Night ",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: isDayNight
                                                ? Colors.grey
                                                : Colors.red),
                                      ),
                                      Icon(
                                        Icons.dark_mode,
                                        color: isDayNight
                                            ? Colors.grey
                                            : Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: RefreshIndicator(
                displacement: 20,
                onRefresh: () async {
                  getchoghadiyaData();
                  getChoughadiyaDataTomorrow();
                  // timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) => updateTodayChaughadiya());
                },
                child: SingleChildScrollView(
                  child: isToday == true ? todayScreen() : tomorrowScreen(),
                ),
              ))
        ],
      ),
    );
  }

  Widget todayScreen() {
    double screenHeight = MediaQuery.of(context).size.height - 80;
    return isShimmer
        ? const Shimmerscreen()
        : Column(
            children: [
              //grid view
              gridList
                  ? Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: choghadiyaModelList.length > 1
                              ? 1
                              : choghadiyaModelList
                                  .length, // Number of items in the list
                          itemBuilder: (BuildContext context, int index) {
                            // final todayList = choghadiyaModelList[0];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4.0),
                              decoration: BoxDecoration(
                                // color: convertColorCode(dayModelList[index].color).withOpacity(0.15),
                                color: hexToColor(choghadiyaModelList[index]
                                        .color
                                        .toString())
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ToggleList(
                                trailing: Icon(
                                  Icons.keyboard_arrow_down,
                                  // color: convertColorCode(dayModelList[index].color),
                                  color: hexToColor(choghadiyaModelList[index]
                                      .color
                                      .toString()),
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                innerPadding: const EdgeInsets.all(10),
                                children: [
                                  ToggleListItem(
                                    isInitiallyExpanded: true,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${choghadiyaModelList[index].muhurta}",
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.026,
                                                fontWeight: FontWeight.bold,
                                                color: hexToColor(
                                                    choghadiyaModelList[index]
                                                        .color
                                                        .toString()))),
                                        Text(
                                            "${convertTimeToAmPm(choghadiyaModelList[index].startTime.toString())} to ${convertTimeToAmPm(choghadiyaModelList[index].endTime.toString())}",
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.018,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                letterSpacing: 1)),
                                      ],
                                    ),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "${choghadiyaModelList[index].chaughdiyadetail}",
                                          style: TextStyle(
                                              fontSize: screenHeight * 0.022,
                                              letterSpacing: 0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.horizontal_distribute,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Upcoming chaughadiya",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  infoPopup(
                                      context,
                                      isTranslate
                                          ? enChoghadiyaInfo
                                          : hiChoghadiyaInfo);
                                },
                                icon: const Icon(
                                  Icons.report_gmailerrorred,
                                  color: Colors.orange,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        choghadiyaModelList.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // itemCount: nightModelList.length, // Number of items in the list
                                itemCount: choghadiyaModelList.length -
                                    1, // Number of items in the list
                                itemBuilder: (BuildContext context, int index) {
                                  final todayList =
                                      choghadiyaModelList[index + 1];
                                  // itemBuilder function returns a widget for each item in the list
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      // color: convertColorCode(dayModelList[index].color).withOpacity(0.15),
                                      color:
                                          hexToColor(todayList.color.toString())
                                              .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ToggleList(
                                      trailing: Icon(
                                        Icons.keyboard_arrow_down,
                                        // color: convertColorCode(dayModelList[index].color),
                                        color: hexToColor(
                                            todayList.color.toString()),
                                        size: 30,
                                      ),
                                      scrollPhysics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        ToggleListItem(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text("${nightModelList[index].muhurta}",
                                              Text("${todayList.muhurta}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.026,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: hexToColor(
                                                          todayList.color
                                                              .toString()))),
                                              Text(
                                                  // "${nightModelList[index].startTime} to ${convertTimeToAmPm(dayModelList[index].endTime)}",
                                                  "${convertTimeToAmPm(todayList.startTime.toString())} to ${convertTimeToAmPm(todayList.endTime.toString())}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.018,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54,
                                                      letterSpacing: 1)),
                                            ],
                                          ),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const Divider(
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                "${todayList.chaughdiyadetail}",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenHeight * 0.022,
                                                    letterSpacing: 0.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              isDayNight == true
                                  ? SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: dayModelList
                                            .length, // Number of items in the list
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // itemBuilder function returns a widget for each item in the list
                                          return Container(
                                            height: 50,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: convertColorCode(
                                                          "${dayModelList[index].color}")
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${dayModelList[index].muhurta}",
                                                  style: TextStyle(
                                                      color: convertColorCode(
                                                          "${dayModelList[index].color}"),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenHeight * 0.018),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${convertTimeToAmPm("${dayModelList[index].startTime}")} - ${convertTimeToAmPm("${dayModelList[index].endTime}")}",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          screenHeight * 0.018,
                                                      letterSpacing: 1),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: nightModelList
                                            .length, // Number of items in the list
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // itemBuilder function returns a widget for each item in the list
                                          return Container(
                                            height: 50,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: convertColorCode(
                                                          "${nightModelList[index].color}")
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${nightModelList[index].muhurta}",
                                                  style: TextStyle(
                                                      color: convertColorCode(
                                                          "${nightModelList[index].color}"),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          screenHeight * 0.018),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${convertTimeToAmPm("${nightModelList[index].startTime}")} - ${convertTimeToAmPm("${nightModelList[index].endTime}")}",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          screenHeight * 0.018,
                                                      letterSpacing: 1),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
            ],
          );
  }

  Widget tomorrowScreen() {
    double screenHeight = MediaQuery.of(context).size.height;
    return isShimmer
        ? const Shimmerscreen()
        : Column(
            children: [
              gridListTomorrow
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tomorrowChoghadiyaModelList
                          .length, // Number of items in the list
                      itemBuilder: (BuildContext context, int index) {
                        // itemBuilder function returns a widget for each item in the list
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: convertColorCode(
                                    "${tomorrowChoghadiyaModelList[index].color}")
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ToggleList(
                            trailing: Icon(
                              Icons.keyboard_arrow_down,
                              color: convertColorCode(
                                  "${tomorrowChoghadiyaModelList[index].color}"),
                              size: 30,
                            ),
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              ToggleListItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${tomorrowChoghadiyaModelList[index].muhurta}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.025,
                                            fontWeight: FontWeight.bold,
                                            color: convertColorCode(
                                                "${tomorrowChoghadiyaModelList[index].color}"))),
                                    Text(
                                        "${convertTimeToAmPm("${tomorrowChoghadiyaModelList[index].startTime}")} - ${convertTimeToAmPm("${tomorrowChoghadiyaModelList[index].endTime}")}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            letterSpacing: 1)),
                                  ],
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Marriage, Religious, Education Activities",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.022,
                                          letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            isDayNight == true
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: dayModelListTomorrow
                                        .length, // Number of items in the list
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // itemBuilder function returns a widget for each item in the list
                                      return Container(
                                        height: 50,
                                        margin: const EdgeInsets.all(5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: convertColorCode(
                                                      "${dayModelListTomorrow[index].color}")
                                                  .withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${dayModelListTomorrow[index].muhurta}",
                                              style: TextStyle(
                                                  color: convertColorCode(
                                                      "${dayModelListTomorrow[index].color}"),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      screenHeight * 0.020),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${convertTimeToAmPm("${dayModelListTomorrow[index].startTime}")} - ${convertTimeToAmPm("${dayModelListTomorrow[index].endTime}")}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      screenHeight * 0.018,
                                                  letterSpacing: 1),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: nightModelListTomorrow
                                        .length, // Number of items in the list
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // itemBuilder function returns a widget for each item in the list
                                      return Container(
                                        height: 50,
                                        margin: const EdgeInsets.all(5.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: convertColorCode(
                                                      "${nightModelListTomorrow[index].color}")
                                                  .withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${nightModelListTomorrow[index].muhurta}",
                                              style: TextStyle(
                                                  color: convertColorCode(
                                                      "${nightModelListTomorrow[index].color}"),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      screenHeight * 0.020),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${convertTimeToAmPm("${nightModelListTomorrow[index].startTime}")} - ${convertTimeToAmPm("${nightModelListTomorrow[index].endTime}")}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      screenHeight * 0.018,
                                                  letterSpacing: 1),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
            ],
          );
  }

  void locationSheet(BuildContext context, String selectedCountry) {
    final TextEditingController countryController = TextEditingController();
    List<CityPickerModel> citylistdata = <CityPickerModel>[];

    void getCityPick(StateSetter modalSetter) async {
      List<CityPickerModel> citypicket = [];
      var response = await http.post(
        Uri.parse('https://geo.vedicrishi.in/places/'),
        body: {
          "country": selectedCountry,
          "name": countryController.text,
        },
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print("Api response $result");
        List listLocation = result;
        citypicket.addAll(listLocation.map((e) => CityPickerModel.fromJson(e)));

        modalSetter(() {
          citylistdata.clear();
          citylistdata.addAll(citypicket);
        });
      }
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        AppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          leading: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                CupertinoIcons.chevron_back,
                                color: Colors.red,
                              )),
                          title: const Text(
                            'Search City',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: countryController,
                            onChanged: (value) {
                              getCityPick(modalSetter);
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter City Name',
                              contentPadding:
                                  const EdgeInsets.only(top: 5, left: 15),
                              labelStyle:
                                  TextStyle(color: Colors.grey.shade400),
                              suffixIcon: const Icon(
                                CupertinoIcons.search_circle_fill,
                                color: Colors.orange,
                                size: 40,
                              ),
                              counterText: '',
                              alignLabelWithHint: true,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: citylistdata
                              .length, // Number of items in the list
                          itemBuilder: (ctx, int index) {
                            return InkWell(
                              onTap: () {
                                modalSetter(() {
                                  countryController.text =
                                      citylistdata[index].place.toString();
                                  countryDefault =
                                      citylistdata[index].place.toString();
                                  latitude =
                                      citylistdata[index].latitude.toString();
                                  longitude =
                                      citylistdata[index].longitude.toString();
                                  Navigator.pop(context);
                                  getchoghadiyaData();
                                  searchbox = false;
                                  countryController.clear();
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_pin,
                                          size: 20, color: Colors.black54),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        child: Text(
                                          citylistdata[index].place,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
