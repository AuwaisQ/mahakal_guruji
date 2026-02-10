import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/maha_bhandar/controller/hora_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import 'package:toggle_list/toggle_list.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../infopage/infopageview.dart';
import '../model/city_model.dart';
import '../model/hora_day_Model.dart';
import '../model/hora_model.dart';
import 'package:http/http.dart' as http;

class HoraScreen extends StatefulWidget {
  final String? cityName;
  final String? localityName;
  const HoraScreen({super.key, this.cityName, this.localityName});

  @override
  State<HoraScreen> createState() => _HoraScreenState();
}

class _HoraScreenState extends State<HoraScreen> {
  bool shimmer = false;
  bool isTranslate = false;
  String latitude = "23.179300";
  String longitude = "75.784912";
  String countryDefault = "Ujjain/Madhya Pradesh";
  String locationMessage = "";
  String enHoraInfo =
      "Hora is a traditional system in Hindu astrology that divides the day into planetary hours, each of which is associated with a specific planet. It is used to determine auspicious times for various activities based on the favorable influence of the ruling planet, to make optimal decisions and create timetables according to astrological principles.";
  String hiHoraInfo =
      "होरा हिंदू ज्योतिष में एक पारंपरिक प्रणाली है जो दिन को ग्रहों के घंटों में विभाजित करती है, जिनमें से प्रत्येक एक विशिष्ट ग्रह से जुड़ा होता है। इसका उपयोग शासक ग्रह के अनुकूल प्रभाव के आधार पर विभिन्न गतिविधियों के लिए शुभ समय निर्धारित करने, ज्योतिषीय सिद्धांतों के अनुसार इष्टतम निर्णय लेने और समय-सारिणी बनाने के लिए किया जाता है।";

  String convertTimeToAmPm(String time) {
    // Parse the time string into a DateTime object
    final dateTime = DateFormat('HH:mm').parse(time);
    // Format the DateTime object into an AM/PM time string
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  List<AllData> horaModelList = <AllData>[];
  List<DayHora> horaDayModelList = <DayHora>[];
  List<NightHora> horaNightModelList = <NightHora>[];

  List<AllData> horaTomorrowModelList = <AllData>[];
  List<DayHora> horaDayTomorrowModelList = <DayHora>[];
  List<NightHora> horaNightTomorrowModelList = <NightHora>[];

  // void getHoraData() async {
  //   var response = await HttpService().postApi(AppConstants.horaUrl, {
  //     "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
  //     "time": DateFormat('HH:mm').format(DateTime.now()),
  //     "latitude": Provider.of<HoraController>(Get.context!, listen: false).latitude,
  //     "longitude": Provider.of<HoraController>(Get.context!, listen: false).longitude,
  //     "timezone": "5.5",
  //     "language": isTranslate ? "en" : "hi"
  //   });
  //
  //   setState(() {
  //     horaModelList.clear();
  //     List horaList = response["all_data"];
  //     // horaModelList.addAll(horaList.map((e) => AllData.fromJson(e)));
  //     DateTime currentTime = DateTime.now();
  //     print("Current Time: ${currentTime.toIso8601String()}");
  //
  //    horaModelList = horaList
  //         .map((e) => AllData.fromJson(e))
  //         .where((element) {
  //       DateTime endTime = DateFormat('HH:mm').parse(element.endTime!);
  //
  //       // Convert end time to the same date as the current time
  //       endTime = DateTime(currentTime.year, currentTime.month, currentTime.day, endTime.hour, endTime.minute);
  //
  //       // Print the end time for debugging
  //       print("End Time: ${endTime.toIso8601String()}");
  //
  //       return endTime.isAfter(currentTime);
  //     }).toList();
  //
  //     print("Filtered API response: $horaModelList");
  //   });
  // }

  void getHoraData() async {
    try {
      var response = await HttpService().postApi(AppConstants.horaUrl, {
        "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
        "time": DateFormat('HH:mm').format(DateTime.now()),
        "latitutde":
            Provider.of<HoraController>(Get.context!, listen: false).latitude,
        "longitude":
            Provider.of<HoraController>(Get.context!, listen: false).longitude,
        "timezone": "5.5",
        "language": isTranslate ? "en" : "hi"
      });

      setState(() {
        horaModelList.clear();
        List horaList = response["all_data"];
        DateTime currentTime = DateTime.now();
        print("Current Time: ${currentTime.toIso8601String()}");

        horaModelList =
            horaList.map((e) => AllData.fromJson(e)).where((element) {
          try {
            DateTime endTime = DateFormat('HH:mm').parse(element.endTime!);

            // Handle the case where endTime is exactly 00:00 (midnight)
            if (endTime.hour == 0 && endTime.minute == 0) {
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

        print("Filtered API response: $horaModelList");
      });
    } catch (e) {
      print("Error in getHoraData: $e");
    }
  }

  void getDayHora() async {
    var res = await HttpService().postApi(AppConstants.horaDayUrl, {
      "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "latitutde":
          Provider.of<HoraController>(Get.context!, listen: false).latitude,
      "longitude":
          Provider.of<HoraController>(Get.context!, listen: false).longitude,
      "timezone": "5.5",
      "language": isTranslate ? "en" : "hi"
    });
    setState(() {
      horaDayModelList.clear();
      horaNightModelList.clear();
      List horaDay = res["dayHora"];
      horaDayModelList.addAll(horaDay.map((e) => DayHora.fromJson(e)));
      List horaNight = res["nightHora"];
      horaNightModelList.addAll(horaNight.map((e) => NightHora.fromJson(e)));
    });
  }

  // Future getHoraData() async {
  //   setState(() => shimmer = true);
  //   var res = await HttpService().postApi(AppConstants.horaUrl, {
  //     "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
  //     "time": DateFormat('HH:mm').format(DateTime.now()),
  //     "latitude": Provider.of<HoraController>(Get.context!, listen: false).latitude,
  //     "longitude": Provider.of<HoraController>(Get.context!, listen: false).longitude,
  //     "timezone": "5.5",
  //     "language": isTranslate ? "en" : "hi"
  //   });
  //   print("Hora Data:$res");
  //   Provider.of<HoraController>(Get.context!, listen: false).dayModelList.clear();
  //   Provider.of<HoraController>(Get.context!, listen: false).nightModelList.clear();
  //
  //     List dayList = res['dayHora'];
  //     List nightList = res['nightHora'];
  //     Provider.of<HoraController>(Get.context!, listen: false).dayModelList.addAll(dayList.map((val) => AllData.fromJson(val)));
  //     Provider.of<HoraController>(Get.context!, listen: false).nightModelList.addAll(nightList.map((val) => AllData.fromJson(val)));
  //
  //
  //     // Combine and sort the data
  //     final combined = [
  //       ...res['dayHora']!,
  //       ...res['nightHora']!,
  //     ];
  //
  //     combined.sort((a, b) {
  //       return a['start_time']!.compareTo(b['start_time']!);
  //     });
  //
  //       Provider.of<HoraController>(Get.context!, listen: false).todayHora = combined;
  //
  //   setState(() {});
  //
  //   final now = DateTime.now();
  //   final timeFormat = DateFormat('HH:mm');
  //   setState(() {
  //     Provider.of<HoraController>(Get.context!, listen: false).todayHora.removeWhere((element) {
  //       final endTime = timeFormat.parse(element['end_time']!);
  //       return now.isAfter(DateTime(now.year, now.month, now.day, endTime.hour,
  //           endTime.minute, endTime.second));
  //     });
  //   });
  // }

  Future tomorrowHora() async {
    var res = await HttpService().postApi(AppConstants.horaUrl, {
      "date": DateFormat('dd/MM/yyyy')
          .format(DateTime.now().add(const Duration(days: 1))),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "latitutde":
          Provider.of<HoraController>(Get.context!, listen: false).latitude,
      "longitude":
          Provider.of<HoraController>(Get.context!, listen: false).longitude,
      "timezone": "5.5",
      "language": isTranslate ? "en" : "hi"
    });
    print("Hora Data:$res");
    setState(() {
      horaTomorrowModelList.clear();
      List tomorrowHora = res["all_data"];
      horaTomorrowModelList
          .addAll(tomorrowHora.map((val) => AllData.fromJson(val)));
      // List horaTomorrowDay = res["dayHora"];
      // horaDayTomorrowModelList.addAll(horaTomorrowDay.map((e) => DayHora.fromJson(e)));
      // List horaTommorowNight = res["nightHora"];
      // horaNightTomorrowModelList.addAll(horaTommorowNight.map((e) => NightHora.fromJson(e)));
    });
  }

  void getDayTomorrowHora() async {
    var res = await HttpService().postApi(AppConstants.horaDayUrl, {
      "date": DateFormat('dd/MM/yyyy')
          .format(DateTime.now().add(const Duration(days: 1))),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "latitude":
          Provider.of<HoraController>(Get.context!, listen: false).latitude,
      "longitude":
          Provider.of<HoraController>(Get.context!, listen: false).longitude,
      "timezone": "5.5",
      "language": isTranslate ? "en" : "hi"
    });
    setState(() {
      horaDayTomorrowModelList.clear();
      horaNightTomorrowModelList.clear();
      List horaDayTomorrow = res["dayHora"];
      horaDayTomorrowModelList
          .addAll(horaDayTomorrow.map((e) => DayHora.fromJson(e)));
      List horaNightTomorrow = res["nightHora"];
      horaNightTomorrowModelList
          .addAll(horaNightTomorrow.map((e) => NightHora.fromJson(e)));
    });
  }

  void searchBox() {
    if (Provider.of<HoraController>(Get.context!, listen: false)
            .countryController
            .text
            .length >
        1) {
      setState(() {
        Provider.of<HoraController>(Get.context!, listen: false).searchbox =
            true;
      });
    } else if (Provider.of<HoraController>(Get.context!, listen: false)
        .countryController
        .text
        .isEmpty) {
      setState(() {
        Provider.of<HoraController>(Get.context!, listen: false).searchbox =
            false;
      });
    }
    print(
        "serchbox $Provider.of<HoraController>(Get.context!, listen: false).searchbox");
  }

  // country picker api
  void getCityPick() async {
    print("object");
    Provider.of<HoraController>(Get.context!, listen: false)
        .cityListModel
        .clear();
    var response = await http.post(
      Uri.parse('https://geo.vedicrishi.in/places/'),
      body: {
        "country": Provider.of<HoraController>(Get.context!, listen: false)
            .selectedCountry
            .name,
        "name": Provider.of<HoraController>(Get.context!, listen: false)
            .countryController
            .text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        var result = json.decode(response.body);
        print("Api response $result");
        List listLocation = result;
        Provider.of<HoraController>(Get.context!, listen: false)
            .cityListModel
            .addAll(listLocation.map((e) => CityPickerModel.fromJson(e)));
      });
    } else {
      print("Failed Api Rresponse");
    }
  }

  void updateValue(String value) {
    // Implement your logic here - e.g., print the value, perform validation, etc.
    print('Entered value: $value');
    getCityPick();
    searchBox();
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

  Future<void> getLocation() async {
    setState(() {
      // shimmerscreenDate = true;
    });

    try {
      // Check if location services are enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are disabled.';
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      } else if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately
        throw 'Location permissions are permanently denied.';
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
            ? "${placemarks[0].locality},${placemarks[0].country}"
            : "No address available";
      });
    } catch (e) {
      setState(() {
        locationMessage = "Error: $e";
        countryDefault = "";
      });
    }
    getHoraData();
    tomorrowHora();
    getDayHora();
    getDayTomorrowHora();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<HoraController>(Get.context!, listen: false).isToday = true;
    latitude = Provider.of<AuthController>(Get.context!, listen: false)
        .latitude
        .toString();
    longitude = Provider.of<AuthController>(Get.context!, listen: false)
        .longitude
        .toString(); // Provider.of<HoraController>(Get.context!, listen: false).timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) => updategetHoraData());
    getHoraData();
    tomorrowHora();
    getDayHora();
    getDayTomorrowHora();
  }

  @override
  Widget build(BuildContext context) {
    final horaController =
        Provider.of<HoraController>(Get.context!, listen: false);
    String horaDate = DateFormat('dd-MMMM-yyyy').format(horaController.now);
    double screenHeight = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: horaModelList.isEmpty
          ? const Shimmerscreen()
          : Column(
              children: [
                Expanded(flex: 0, child: SizedBox(height: w * 0.2)),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      //Location Button
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, left: 15, right: 15, bottom: 5),
                        child: Row(
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
                                    "Hora",
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
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        child: Text(
                                          Provider.of<HoraController>(
                                                  Get.context!,
                                                  listen: false)
                                              .countryDefault,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    horaController.isToday = true;
                                    horaController.gridList = true;
                                    horaController.dayNight = true;
                                    horaController.showDayNight = true;
                                  });
                                  horaController.goToCurrentDate();
                                  // print("$buttonTab");
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3.0),
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: horaController.isToday
                                            ? Colors.orange
                                            : Colors.orange,
                                        width: 2),
                                    color: horaController.isToday
                                        ? Colors.orange
                                        : Colors.white,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Today",
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.02,
                                      color: horaController.isToday
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: horaController.isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    horaController.isToday = false;
                                    horaController.gridListTomorrow = true;
                                    horaController.dayNight = true;
                                    horaController.showDayNight = true;
                                    // Toggle the boolean value
                                  });
                                  horaController.goToNextDate();
                                  // print("$buttonTab");
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3.0),
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: horaController.isToday
                                            ? Colors.orange
                                            : Colors.orange,
                                        width: 2),
                                    color: horaController.isToday
                                        ? Colors.white
                                        : Colors.orange,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Tomorrow",
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.02,
                                      color: horaController.isToday
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: horaController.isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.horizontal_distribute,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 5),
                            horaController.gridList
                                ? Text(
                                    "$horaDate Hora",
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Hora Day & Night",
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                            const Spacer(),
                            BouncingWidgetInOut(
                              onPressed: () {
                                setState(() {
                                  horaController.gridList =
                                      !horaController.gridList;
                                  horaController.showDayNight =
                                      !horaController.showDayNight;
                                  horaController.gridListTomorrow =
                                      !horaController.gridListTomorrow;
                                  print(horaController.gridList);
                                });
                              },
                              bouncingType: BouncingType.bounceInAndOut,
                              child: Center(
                                child: Icon(
                                    horaController.gridList
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
                                  getHoraData();
                                  tomorrowHora();
                                  getDayHora();
                                  getDayTomorrowHora();
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
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
                                  color: isTranslate
                                      ? Colors.white
                                      : Colors.orange,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      horaController.showDayNight
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  right: 5, left: 5, bottom: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          horaController.dayNight = true;
                                        });
                                        // print("$buttonTab");
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(3.0),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: horaController.dayNight
                                                  ? Colors.green
                                                  : Colors.grey,
                                              width: 2),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Day ",
                                              style: TextStyle(
                                                  fontSize: screenHeight * 0.02,
                                                  color: horaController.dayNight
                                                      ? Colors.green
                                                      : Colors.grey),
                                            ),
                                            Icon(
                                              Icons.sunny,
                                              color: horaController.dayNight
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
                                          horaController.dayNight = false;
                                        });
                                        // print("$buttonTab");
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(3.0),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: horaController.dayNight
                                                  ? Colors.grey
                                                  : Colors.red,
                                              width: 2),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Night",
                                              style: TextStyle(
                                                  fontSize: screenHeight * 0.02,
                                                  color: horaController.dayNight
                                                      ? Colors.grey
                                                      : Colors.red),
                                            ),
                                            Icon(
                                              Icons.dark_mode,
                                              color: horaController.dayNight
                                                  ? Colors.grey
                                                  : Colors.red,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: horaController.isToday
                        ? todayScreen()
                        : tomorrowScreen(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget todayScreen() {
    final horaController =
        Provider.of<HoraController>(Get.context!, listen: false);
    double screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      displacement: 20,
      onRefresh: () async {
        getHoraData();
        tomorrowHora();
        getDayHora();
        getDayTomorrowHora();
      },
      child: Column(
        children: [
          horaController.gridList
              ? Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: horaModelList.length > 1
                          ? 1
                          : horaModelList.length, // Number of items in the list
                      itemBuilder: (BuildContext context, int index) {
                        final todayList = horaModelList[index];
                        // itemBuilder function returns a widget for each item in the list
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4.0),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 6, // Blur radius
                              ),
                            ],
                          ),
                          child: ToggleList(
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            innerPadding: const EdgeInsets.all(10),
                            shrinkWrap: true,
                            trailing: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.orange,
                              size: 30,
                            ),
                            children: [
                              ToggleListItem(
                                isInitiallyExpanded: true,
                                leading: CachedNetworkImage(
                                  imageUrl: "${todayList.horaImage}",
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${todayList.hora}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.024,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "${convertTimeToAmPm("${todayList.startTime}")} to ${convertTimeToAmPm("${todayList.endTime}")}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            letterSpacing: 1)),
                                  ],
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${todayList.horaDetail}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    //Anukul
                                    Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Anukul",
                                              style: TextStyle(
                                                  fontSize:
                                                      screenHeight * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            Text("${todayList.horaAnukul}",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenHeight * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.7,
                                                    color: Colors.green)),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    //Pratikul
                                    Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Pratikul",
                                              style: TextStyle(
                                                  fontSize:
                                                      screenHeight * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            Text("${todayList.horaPratikul}",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenHeight * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.7,
                                                    color: Colors.red)),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 8.0,
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //Rang
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Rang - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.rang,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                //Bhojan
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Bhojan - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              todayList.bhojan,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black38,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  0.7,
                                                              fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                //Ratna
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Ratna - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.ratna,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                //Sankhya
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Sankhya - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              todayList.sankhya,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //Fool
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Fool - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.fool,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Vahan - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.vahan,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Dhatu - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.dhatu,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.horizontal_distribute,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Upcoming Hora",
                            style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              infoPopup(context,
                                  isTranslate ? enHoraInfo : hiHoraInfo);
                            },
                            icon: const Icon(
                              Icons.report_gmailerrorred,
                              color: Colors.orange,
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: horaModelList.length -
                          1, // Number of items in the list
                      itemBuilder: (BuildContext context, int index) {
                        final todayList = horaModelList[index + 1];
                        // itemBuilder function returns a widget for each item in the list
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4.0),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 6, // Blur radius
                              ),
                            ],
                          ),
                          child: ToggleList(
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            innerPadding: const EdgeInsets.all(10),
                            shrinkWrap: true,
                            trailing: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.orange,
                              size: 30,
                            ),
                            children: [
                              ToggleListItem(
                                leading: CachedNetworkImage(
                                  imageUrl: "${todayList.horaImage}",
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${todayList.hora}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.024,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "${convertTimeToAmPm("${todayList.startTime}")} to ${convertTimeToAmPm("${todayList.endTime}")}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            letterSpacing: 1)),
                                  ],
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${todayList.horaDetail}",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.018,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    //Anukul
                                    Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Anukul",
                                              style: TextStyle(
                                                  fontSize:
                                                      screenHeight * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            Text("${todayList.horaAnukul}",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenHeight * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.7,
                                                    color: Colors.green)),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    //Pratikul
                                    Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Pratikul",
                                              style: TextStyle(
                                                  fontSize:
                                                      screenHeight * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            Text("${todayList.horaPratikul}",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenHeight * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.7,
                                                    color: Colors.red)),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 8.0,
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //Rang
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Rang - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.rang,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                //Bhojan
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Bhojan - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              todayList.bhojan,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black38,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  0.7,
                                                              fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                //Ratna
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Ratna - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.ratna,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                //Sankhya
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Sankhya - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              todayList.sankhya,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //Fool
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Fool - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.fool,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Vahan - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.vahan,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                      text: 'Dhatu - ',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.7),
                                                      children: [
                                                        TextSpan(
                                                          text: todayList.dhatu,
                                                          style:
                                                              const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
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
                          horaController.dayNight == true
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: horaDayModelList
                                      .length, // Number of items in the list
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // itemBuilder function returns a widget for each item in the list
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5), // Shadow color
                                                spreadRadius:
                                                    1, // Spread radius
                                                blurRadius:
                                                    6, // Offset of the shadow
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "${horaDayModelList[index].horaImage}",
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                  "${horaDayModelList[index].hora}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.020,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green)),
                                              const Spacer(),
                                              Text(
                                                  "${convertTimeToAmPm("${horaDayModelList[index].startTime}")} to ${convertTimeToAmPm("${horaDayModelList[index].endTime}")}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.018,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                      letterSpacing: 1))
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: horaNightModelList
                                      .length, // Number of items in the list
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // itemBuilder function returns a widget for each item in the list
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5), // Shadow color
                                                spreadRadius:
                                                    1, // Spread radius
                                                blurRadius:
                                                    6, // Offset of the shadow
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "${horaNightModelList[index].horaImage}",
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text(
                                                  "${horaNightModelList[index].hora}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.020,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red)),
                                              const Spacer(),
                                              Text(
                                                  "${convertTimeToAmPm("${horaNightModelList[index].startTime}")} to ${convertTimeToAmPm("${horaNightModelList[index].endTime}")}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.018,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                      letterSpacing: 1))
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget tomorrowScreen() {
    final horaController =
        Provider.of<HoraController>(Get.context!, listen: false);
    double screenHeight = MediaQuery.of(context).size.height;
    return horaTomorrowModelList.isEmpty
        ? const Shimmerscreen()
        : Column(
            children: [
              horaController.gridListTomorrow
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: horaTomorrowModelList
                          .length, // Number of items in the list
                      itemBuilder: (BuildContext context, int index) {
                        // itemBuilder function returns a widget for each item in the list
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 4.0),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 6, // Blur radius
                                  ),
                                ],
                              ),
                              child: ToggleList(
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                children: [
                                  ToggleListItem(
                                    title: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              "${horaTomorrowModelList[index].horaImage}",
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${horaTomorrowModelList[index].hora}",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenHeight * 0.024,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "${convertTimeToAmPm("${horaTomorrowModelList[index].startTime}")} to ${convertTimeToAmPm("${horaTomorrowModelList[index].endTime}")}",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenHeight * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    letterSpacing: 1)),
                                          ],
                                        )
                                      ],
                                    ),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${horaTomorrowModelList[index].horaDetail}",
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.018,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(10.0),
                                            color: Colors.green.shade50,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Anukul",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                                Text(
                                                    "${horaTomorrowModelList[index].horaAnukul}",
                                                    style: TextStyle(
                                                        fontSize: screenHeight *
                                                            0.018,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.7,
                                                        color: Colors.green)),
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(10.0),
                                            color: Colors.red.shade50,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Pratikul",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                ),
                                                Text(
                                                    "${horaTomorrowModelList[index].horaPratikul}",
                                                    style: TextStyle(
                                                        fontSize: screenHeight *
                                                            0.018,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.7,
                                                        color: Colors.red)),
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //Rang
                                                    Text.rich(
                                                      TextSpan(
                                                          text: 'Rang - ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  horaTomorrowModelList[
                                                                          index]
                                                                      .rang,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                            )
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    //Bhojan
                                                    Text.rich(
                                                      TextSpan(
                                                          text: 'Bhojan - ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  horaTomorrowModelList[
                                                                          index]
                                                                      .bhojan,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black38,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                            )
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    //Ratna
                                                    Text.rich(
                                                      TextSpan(
                                                          text: 'Ratna - ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  horaTomorrowModelList[
                                                                          index]
                                                                      .ratna,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                            )
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    //Sankhya
                                                    Text.rich(
                                                      TextSpan(
                                                          text: 'Sankhya - ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  horaTomorrowModelList[
                                                                          index]
                                                                      .sankhya,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                            )
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //Fool
                                                    Text.rich(
                                                      TextSpan(
                                                          text: 'Fool - ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  horaTomorrowModelList[
                                                                          index]
                                                                      .fool,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                            )
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                          text: 'Vahan - ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  horaTomorrowModelList[
                                                                          index]
                                                                      .vahan,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                            )
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                          text: 'Dhatu - ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  horaTomorrowModelList[
                                                                          index]
                                                                      .dhatu,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.7,
                                                                  fontSize: 15),
                                                            )
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              horaController.dayNight == true
                                  ? SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: horaDayModelList
                                            .length, // Number of items in the list
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // itemBuilder function returns a widget for each item in the list
                                          return Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(
                                                              0.5), // Shadow color
                                                      spreadRadius:
                                                          1, // Spread radius
                                                      blurRadius:
                                                          6, // Offset of the shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl:
                                                          "${horaDayModelList[index].horaImage}",
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    Text(
                                                        "${horaDayModelList[index].hora}",
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.020,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green)),
                                                    const Spacer(),
                                                    Text(
                                                        "${horaDayModelList[index].startTime} to ${horaDayModelList[index].endTime}",
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.018,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue,
                                                            letterSpacing: 1))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: horaNightModelList
                                            .length, // Number of items in the list
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // itemBuilder function returns a widget for each item in the list
                                          return Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(
                                                              0.5), // Shadow color
                                                      spreadRadius:
                                                          1, // Spread radius
                                                      blurRadius:
                                                          6, // Offset of the shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl:
                                                          "${horaNightModelList[index].horaImage}",
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    Text(
                                                        "${horaNightModelList[index].hora}",
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.020,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red)),
                                                    const Spacer(),
                                                    Text(
                                                        "${horaNightModelList[index].startTime} to ${horaNightModelList[index].endTime}",
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.018,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue,
                                                            letterSpacing: 1))
                                                  ],
                                                ),
                                              ),
                                            ],
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

  void locationSheet(BuildContext context, String selectedCountry) {
    final TextEditingController countryController = TextEditingController();
    List<CityPickerModel> citylistdata = <CityPickerModel>[];
    final horaController =
        Provider.of<HoraController>(Get.context!, listen: false);

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
                                  horaController.countryDefault =
                                      citylistdata[index].place.toString();
                                  horaController.latitude =
                                      citylistdata[index].latitude.toString();
                                  horaController.longitude =
                                      citylistdata[index].longitude.toString();
                                  Navigator.pop(context);
                                  horaController.searchbox = false;
                                  countryController.clear();
                                  getHoraData();
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
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10, // Number of items in the list
            itemBuilder: (BuildContext context, int index) {
              // itemBuilder function returns a widget for each item in the list
              return Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 50,
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
