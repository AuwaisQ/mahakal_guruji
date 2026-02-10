import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../main.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../infopage/infopageview.dart';
import '../model/city_model.dart';
import '../model/grahoKiIsthiti_model.dart';

class GrahiKiSthiti extends StatefulWidget {
  final String? cityName;
  final String? localityName;

  const GrahiKiSthiti({super.key, this.cityName, this.localityName});

  @override
  State<GrahiKiSthiti> createState() => _GrahiKiSthitiState();
}

class _GrahiKiSthitiState extends State<GrahiKiSthiti> {
  String latitude = "23.179300";
  String longitude = "75.784912";
  String countryDefault = "Ujjain/Madhya Pradesh";
  String enGrahInfo =
      "Planetary positions in Hindu astrology refer to the positions and conditions of celestial bodies (planets), which influence human affairs and events based on their position in the zodiac. It guides interpretations of cosmic influences and predictions, shaping beliefs about personal destiny and optimal times for actions.";
  String hiGrahInfo =
      "ग्रहों की स्थिति हिंदू ज्योतिष में आकाशीय पिंडों (ग्रहों) की स्थिति और स्थितियों को संदर्भित करती है, जो राशि चक्र में उनकी स्थिति के आधार पर मानवीय मामलों और घटनाओं को प्रभावित करती है। यह ब्रह्मांडीय प्रभावों और भविष्यवाणियों की व्याख्याओं का मार्गदर्शन करती है, व्यक्तिगत नियति और कार्यों के लिए इष्टतम समय के बारे में विश्वासों को आकार देती है।";
  var address1 = "";
  var address2 = "";
  var moonDate = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
  int seletcColor = 0;
  int countGrah = 0;

  //Planet data List Api
  List<Planate> modelList = <Planate>[];
  List<PlanateImage> modelListImages = <PlanateImage>[];
  var id = "";
  var name = "";
  var sign = "";
  var sign_lord = "";
  var nakshatra = "";
  var nakshatra_lord = "";

  var speed = "";
  bool isToday = true;
  bool shimmerscreen = false;
  bool isTranslate = false;
  bool isDateAdded = false;
  DateTime todayDate = DateTime.now();
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

  Future<void> showShimmer() async {
    await Future.delayed(const Duration(
      seconds: 1,
    ));
    setState(() {
      shimmerscreen = false;
    });
  }

  @override
  void initState() {
    super.initState();
    shimmerscreen = true;
    showShimmer();
    getData();
    latitude = Provider.of<AuthController>(Get.context!, listen: false)
        .latitude
        .toString();
    longitude = Provider.of<AuthController>(Get.context!, listen: false)
        .longitude
        .toString();
    // fetchPosition();
  }

  Future getData() async {
    setState(() => shimmerscreen = true);
    var res = await HttpService().postApi(AppConstants.grahoUrl, {
      "date": DateFormat('dd/MM/yyyy').format(todayDate),
      "time": DateFormat('HH:mm').format(todayDate),
      "latitude": latitude,
      "longitude": longitude,
      "timezone": "5.5",
      "language": isTranslate ? "en" : "hi",
    });
    List listData = res["planate"];
    modelList.addAll(listData.map((e) => Planate.fromJson(e)));
    id = listData[0]['id'].toString();
    name = listData[0]['name'].toString();
    sign = listData[0]['sign'].toString();
    sign_lord = listData[0]['sign_lord'].toString();
    nakshatra = listData[0]['nakshatra'].toString();
    nakshatra_lord = listData[0]['nakshatra_lord'].toString();
    speed = listData[0]['speed'].toString();

    if (countGrah == countGrah) {
      id = listData[countGrah]['id'].toString();
      name = listData[countGrah]['name'].toString();
      sign = listData[countGrah]['sign'].toString();
      sign_lord = listData[countGrah]['sign_lord'].toString();
      nakshatra = listData[countGrah]['nakshatra'].toString();
      nakshatra_lord = listData[countGrah]['nakshatra_lord'].toString();
      speed = listData[countGrah]['speed'].toString();
      print("Graho Ki isthiti List${listData[countGrah]}");
      setState(() => shimmerscreen = false);
    }
    modelListImages.clear();
    List listImageData = res["planate_images"];
    modelListImages
        .addAll(listImageData.map((val) => PlanateImage.fromJson(val)));
    setState(() => shimmerscreen = false);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    DateTime today = DateTime.now();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(flex: 0, child: SizedBox(height: w * 0.22)),
            //Location Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 20,
                          width: 2,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Graho Ki Isthiti",
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
                              locationSheet(context, selectedCountry.name);
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
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

            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isDateAdded = false;
                          isToday = true; // Toggle the boolean value
                          todayDate = DateTime.now();
                          moonDate =
                              DateFormat('dd-MMMM-yyyy').format(todayDate);
                          getData();
                        });
                        // print("$buttonTab");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: isToday ? Colors.orange : Colors.orange,
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
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (!isDateAdded) {
                            todayDate = todayDate.add(const Duration(days: 1));
                            isDateAdded = true;

                            if (todayDate ==
                                DateTime.now().add(const Duration(days: 1))) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Correct Date')),
                              );
                            } else {
                              isToday = false; // Toggle the boolean value
                              moonDate =
                                  DateFormat('dd-MMMM-yyyy').format(todayDate);
                              getData();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Tommorrow Selected')),
                            );
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: isToday ? Colors.orange : Colors.orange,
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
                  const SizedBox(width: 3),
                  Expanded(
                    flex: 0,
                    child: BouncingWidgetInOut(
                      onPressed: () {
                        setState(() {
                          isTranslate = !isTranslate;
                          getData();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        height: 43,
                        width: 43,
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
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Today moon
            if (shimmerscreen == true)
              shimmerEffect()
            else
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                width: double.infinity,
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            moonDate,
                            style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              infoPopup(context,
                                  isTranslate ? enGrahInfo : hiGrahInfo);
                            },
                            icon: const Icon(
                              Icons.report_gmailerrorred,
                              color: Colors.orange,
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              // Shadow color
                              spreadRadius: 3,
                              // Spread radius
                              blurRadius: 5,
                              // Blur radius
                              offset:
                                  const Offset(0, 3), // Offset of the shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Grah",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.020,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Vakree",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.020,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Rashi",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.020,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Rashi swami",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.020,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Ansh par",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.020,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Nakshatra",
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.020,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text("Nakshatra Swami",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.020,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Column(
                                  children: [
                                    Text(name,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.020)),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text("-",
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.020)),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(sign,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.020)),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(sign_lord,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.020)),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      speed.length > 5
                                          ? speed.substring(0, 5)
                                          : speed,
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.020,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(nakshatra,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.020)),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(nakshatra_lord,
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.020)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Container(
              color: Colors.red.shade50,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          // Scroll horizontally
                          itemCount: modelListImages.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                shimmerscreen = true;
                                showShimmer();
                                setState(() {
                                  countGrah = index;
                                  seletcColor = index;
                                });
                                getData();
                              },
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: seletcColor == index
                                      ? Colors.orange.shade100
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      // Shadow color
                                      spreadRadius: 3,
                                      // Spread radius
                                      blurRadius: 5,
                                      // Blur radius
                                      offset: const Offset(
                                          0, 3), // Offset of the shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.white,
                                              // Shadow color
                                              spreadRadius: 1,
                                              // Spread radius
                                              blurRadius: 20,
                                              // Blur radius
                                              offset: Offset(0,
                                                  3), // Offset/direction of shadow
                                            ),
                                          ]),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              modelListImages[index].image,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      modelListImages[index].name,
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.022,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
                          itemCount: citylistdata.length,
                          // Number of items in the list
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
                                  getData();
                                  Navigator.pop(context);
                                  countryController.clear();
                                });
                              },
                              child: DelayedDisplay(
                                delay: const Duration(milliseconds: 500),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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

  Widget shimmerEffect() {
    double screenHeight = MediaQuery.of(context).size.height;
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Grah",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.020,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Vakree",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.020,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Rashi",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.020,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Rashi swami",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.020,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Ansh par",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.020,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Nakshatra",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.020,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Nakshatra Swami",
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis)),
                            ],
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
                          child: Column(
                            children: [
                              Text(name,
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("-",
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(sign,
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(sign_lord,
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(speed,
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                      overflow: TextOverflow.ellipsis)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(nakshatra,
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(nakshatra_lord,
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.020)),
                            ],
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
