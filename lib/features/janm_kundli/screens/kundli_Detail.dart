import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/janm_kundli/models/suggestion_model.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import '../../../main.dart';
import '../../profile/controllers/profile_contrroller.dart';
import '../custom_table.dart';
import '../models/dosh_model.dart';
import '../models/lalkitab_model.dart';
import '../models/vimshottarimaha_model.dart';
import 'component/chartscreen.dart';
import 'component/dashascreen.dart';
import 'component/doshscreen.dart';
import 'component/fallscreen.dart';
import 'component/suggestionscreen.dart';

class KundliDetails extends StatefulWidget {
  final String name;
  final String day;
  final String month;
  final String year;
  final String hour;
  final String mint;
  final String country;
  final String city;
  final String lati;
  final String longi;
  const KundliDetails(
      {super.key,
      required this.name,
      required this.day,
      required this.month,
      required this.year,
      required this.hour,
      required this.mint,
      required this.country,
      required this.city,
      required this.lati,
      required this.longi});

  @override
  _KundliDetailsState createState() => _KundliDetailsState();
}

class _KundliDetailsState extends State<KundliDetails> {
  @override
  void initState() {
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    getKundliData();
    getKundliDashaPage();
    getSuggestionData();
    getDoshData();
    getKundliLalkitab();
    getKundliFallPage();
  }

  void _refreshPage1() {
    setState(() {
      // Perform initialization logic
      print("Page 1 reinitialized");
    });
  }

  String translateEn = 'hi';
  //basic details
  String dobDay = "";
  String dobMonth = "";
  String dobYear = "";
  String birthTimeHour = "";
  String birthTimeMinute = "";
  String lati = "";
  String longi = "";
  String sunrise = "";
  String sunset = "";
  String timeZone = "";
  String ayanamsha = "";
  // Panchang data
  String panchangDay = "";
  String tithi = "";
  String nakshatra = "";
  String yog = "";
  String karan = "";
  String panchangSunrise = "";
  String panchangSunset = "";
  String vedic_sunrise = "";
  String vedic_sunset = "";
  //Avakhada Data
  String ascendant = "";
  String ascendant_lord = "";
  String varna = "";
  String vashya = "";
  String yoni = "";
  String gan = "";
  String nadi = "";
  String signLord = "";
  String sign = "";
  String naksahtraAstro = "";
  String naksahtraLord = "";
  String charan = "";
  String yogAstro = "";
  String tithiastro = "";
  String yunja = "";
  String tatva = "";
  String name_alphabet = "";
  String paya = "";
  String userId = "";
  VimshotriDashaModel? vimshotriDasha;
  SuggestionModel? suggestionData;
  DoshModel? doshData;

  List<String> menuItems = [
    "sun",
    "moon",
    "mars",
    "mercury",
    "jupiter",
    "venus",
    "saturn"
  ];
  List<LalkitabModel> lalKitabModelList = <LalkitabModel>[];
  int seletcColor = 0;
  String planetPositionName = "";
  String lalKitabName = "";
  String lalKitabHouse = "";
  String lalKitabDescriition = "";
  List lalKitabRemedies = [];

  // Ascendant result
  String lagnaName = "";
  String lagnaReport = "";
  //planet data
  String planetName = "";
  String planetReport = "";
  //Nakshatra Data
  String nakshatraName = "";
  String nakshatraHealth = "";
  String nakshatraEmotions = "";
  String nakshatraProfession = "";
  String nakshatraLuck = "";
  String nakshatraTravel = "";
  String nakshatraPersonalLife = "";
  String nakshatraDate = "";

  void getKundliFallPage() async {
    var res = await HttpService().postApi(AppConstants.kundliURL, {
      "user_id": userId,
      "device_id": "123",
      "name": widget.name,
      "date": "${widget.day}/${widget.month}/${widget.year}",
      "time": "${widget.hour}:${widget.mint}",
      "country": widget.country,
      "city": widget.city,
      "latitude": widget.lati,
      "longitude": widget.longi,
      "language": translateEn,
      "timezone": "5.5",
      "planet_name": planetPositionName,
      "tab": "fall"
    });
    setState(() {
      print(res);
      if (res['status'] == 200) {
        // lagnna data
        lagnaName = res['lagnaData']['asc_report']['ascendant'].toString();
        lagnaReport = res['lagnaData']['asc_report']['report'].toString();
        // planet data
        planetName = res['planetResult']['planet'].toString();
        planetReport = res['planetResult']['house_report'].toString();

        // Nakshatra data
        nakshatraName = res['nakshatra']['birth_moon_nakshatra'].toString();
        nakshatraDate = res['nakshatra']['prediction_date'].toString();
        nakshatraHealth = res['nakshatra']['prediction']['health'].toString();
        nakshatraEmotions =
            res['nakshatra']['prediction']['emotions'].toString();
        nakshatraProfession =
            res['nakshatra']['prediction']['profession'].toString();
        nakshatraLuck = res['nakshatra']['prediction']['luck'].toString();
        nakshatraTravel = res['nakshatra']['prediction']['travel'].toString();
        nakshatraPersonalLife =
            res['nakshatra']['prediction']['personal_life'].toString();
        print(planetName);
      } else {
        print("Api response failled");
      }
    });
  }

  void getKundliLalkitab() async {
    lalKitabName = "";
    var res = await HttpService().postApi(AppConstants.kundliURL, {
      "user_id": userId,
      "device_id": "123",
      "name": widget.name,
      "date": "${widget.day}/${widget.month}/${widget.year}",
      "time": "${widget.hour}:${widget.mint}",
      "country": widget.country,
      "city": widget.city,
      "latitude": widget.lati,
      "longitude": widget.longi,
      "language": translateEn,
      "timezone": "5.5",
      "planet_name": planetPositionName,
      "tab": "lalkitab"
    });
    print(res);
    setState(() {
      //Pooja data
      if (res['status'] == 200) {
        lalKitabModelList.clear();
        List lalKitabList = res["lalKitabRin"];
        lalKitabModelList
            .addAll(lalKitabList.map((e) => LalkitabModel.fromJson(e)));

        //lal kita remedies
        lalKitabName = res['lalkitabRemedies']['planet'].toString();
        lalKitabHouse = res['lalkitabRemedies']['house'].toString();
        lalKitabDescriition =
            res['lalkitabRemedies']['lal_kitab_desc'].toString();
        lalKitabRemedies = res['lalkitabRemedies']['lal_kitab_remedies'];
      } else {
        print("error msg");
      }
    });
  }

  void getKundliData() async {
    var res = await HttpService().postApi(AppConstants.kundliURL, {
      "user_id": userId,
      "device_id": "123",
      "name": widget.name,
      "date": "${widget.day}/${widget.month}/${widget.year}",
      "time": "${widget.hour}:${widget.mint}",
      "country": widget.country,
      "city": widget.city,
      "latitude": widget.lati,
      "longitude": widget.longi,
      "language": translateEn,
      "timezone": "5.5",
      "tab": "basic"
    });
    print(res);
    if (res['status'] == 200) {
      setState(() {
        // Basic details
        dobDay = res['birthData']['day'].toString();
        dobMonth = res['birthData']['month'].toString();
        dobYear = res['birthData']['year'].toString();
        birthTimeMinute = res['birthData']['minute'].toString();
        birthTimeHour = res['birthData']['hour'].toString();
        lati = res['birthData']['latitude'].toString();
        longi = res['birthData']['longitude'].toString();
        sunrise = res['birthData']['sunrise'].toString();
        sunset = res['birthData']['sunset'].toString();
        timeZone = res['birthData']['timezone'].toString();
        ayanamsha = res['birthData']['ayanamsha'].toString();
        //panchang data
        panchangDay = res['panchangData']['day'].toString();
        tithi = res['panchangData']['tithi'].toString();
        nakshatra = res['panchangData']['nakshatra'].toString();
        yog = res['panchangData']['yog'].toString();
        karan = res['panchangData']['karan'].toString();
        panchangSunrise = res['panchangData']['sunrise'].toString();
        panchangSunset = res['panchangData']['sunset'].toString();
        vedic_sunrise = res['panchangData']['vedic_sunrise'].toString();
        vedic_sunset = res['panchangData']['vedic_sunset'].toString();
        //Avakhada data
        ascendant = res['astroData']['ascendant'].toString();
        ascendant_lord = res['astroData']['ascendant_lord'].toString();
        varna = res['astroData']['Varna'].toString();
        vashya = res['astroData']['Vashya'].toString();
        yoni = res['astroData']['Yoni'].toString();
        gan = res['astroData']['Gan'].toString();
        nadi = res['astroData']['Nadi'].toString();
        signLord = res['astroData']['SignLord'].toString();
        sign = res['astroData']['sign'].toString();
        naksahtraAstro = res['astroData']['Naksahtra'].toString();
        naksahtraLord = res['astroData']['NaksahtraLord'].toString();
        charan = res['astroData']['Charan'].toString();
        yogAstro = res['astroData']['Yog'].toString();
        tithiastro = res['astroData']['Tithi'].toString();
        yunja = res['astroData']['yunja'].toString();
        tatva = res['astroData']['tatva'].toString();
        name_alphabet = res['astroData']['name_alphabet'].toString();
        paya = res['astroData']['paya'].toString();
      });
    } else if (res['status'] == 500) {
      final snackBar = SnackBar(
        content: const Text('This is a SnackBar with an action!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Code to execute when the action is pressed.
            print('Undo action pressed!');
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("Api response failled");
    }
  }

  // void getKundliDashaPage() async{
  //
  //   try{
  //     var res =  await HttpService().postApi(AppConstants.kundliURL,{
  //       "user_id": userId,
  //       "device_id":"123",
  //       "name": widget.name,
  //       "date": "${widget.day}/${widget.month}/${widget.year}",
  //       "time": "${widget.hour}:${widget.mint}",
  //       "country":widget.country,
  //       "city":widget.city,
  //       "latitude":widget.lati,
  //       "longitude":widget.longi,
  //       "language": translateEn,
  //       "timezone":"5.5",
  //       "tab" : "dasha"
  //     });
  //     print("Kundli Dasha Page Data${res}");
  //     setState(() {
  //       if(res['status'] == 200){
  //         vimshotriDasha = vimshotriDashaModelFromJson(jsonEncode(res));
  //         // yoginiDasha = yoginiMahaModelFromJson(jsonEncode(res));
  //         // // yogini data
  //         // yoginiStatus = res['yoginiDasha']['status'].toString();
  //         // yoginiMsg = res['yoginiDasha']['msg'].toString();
  //         // // Planet data
  //         // yoginiPlanet1 = res['yoginiDasha']['major_dasha']['dasha_name'].toString();
  //         // yoginiPlanet2 = res['yoginiDasha']['sub_dasha']['dasha_name'].toString();
  //         // yoginiPlanet3 = res['yoginiDasha']['sub_sub_dasha']['dasha_name'].toString();
  //         // // start time data
  //         // yoginiStart1 = res['yoginiDasha']['major_dasha']['start_date'].toString();
  //         // yoginiStart2 = res['yoginiDasha']['sub_dasha']['start_date'].toString();
  //         // yoginiStart3 = res['yoginiDasha']['sub_sub_dasha']['start_date'].toString();
  //         // // start time data
  //         // yoginiEnd1 = res['yoginiDasha']['major_dasha']['end_date'].toString();
  //         // yoginiEnd2 = res['yoginiDasha']['sub_dasha']['end_date'].toString();
  //         // yoginiEnd3 = res['yoginiDasha']['sub_sub_dasha']['end_date'].toString();
  //         //
  //         // List yoginiList = res['majorYoginiDasha'];
  //         // mahaYoginiModelList.addAll(yoginiList.map((e) => YoginiMahaModel.fromJson(e)));
  //
  //       }else{
  //       }
  //     });
  //   } catch(e){
  //     print("Error in Getting Dasha Page Data $e");
  //   }
  //
  // }
  void getKundliDashaPage() async {
    try {
      var res = await HttpService().postApi(AppConstants.kundliURL, {
        "user_id": userId,
        "device_id": "123",
        "name": widget.name,
        "date": "${widget.day}/${widget.month}/${widget.year}",
        "time": "${widget.hour}:${widget.mint}",
        "country": widget.country,
        "city": widget.city,
        "latitude": widget.lati,
        "longitude": widget.longi,
        "language": translateEn,
        "timezone": "5.5",
        "tab": "dasha"
      });

      print("Kundli Dasha Page Data: ${jsonEncode(res)}"); // Better formatting

      if (res['status'] == 200) {
        setState(() {
          try {
            vimshotriDasha = vimshotriDashaModelFromJson(jsonEncode(res));
          } catch (e) {
            print("Error parsing response: $e");
            // Handle parsing error (maybe show to user)
          }
        });
      }
    } catch (e) {
      print("Error in Getting Dasha Page Data: $e");
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading data: ${e.toString()}")));
    }
  }

  void getSuggestionData() async {
    var res = await HttpService().postApi(AppConstants.kundliURL, {
      "user_id": userId,
      "device_id": "123",
      "name": widget.name,
      "date": "${widget.day}/${widget.month}/${widget.year}",
      "time": "${widget.hour}:${widget.mint}",
      "country": widget.country,
      "city": widget.city,
      "latitude": widget.lati,
      "longitude": widget.longi,
      "language": translateEn,
      "timezone": "5.5",
      "tab": "suggestion"
    });
    setState(() {
      //Rudraksh data
      if (res['status'] == 200) {
        suggestionData = suggestionModelFromJson(jsonEncode(res));
      } else {}
    });
  }

  void getDoshData() async {
    var res = await HttpService().postApi(AppConstants.kundliURL, {
      "user_id": userId,
      "device_id": "123",
      "name": widget.name,
      "date": "${widget.day}/${widget.month}/${widget.year}",
      "time": "${widget.hour}:${widget.mint}",
      "country": widget.country,
      "city": widget.city,
      "latitude": widget.lati,
      "longitude": widget.longi,
      "language": translateEn,
      "timezone": "5.5",
      "tab": "dosh",
    });
    print(res);
    setState(() {
      //ratna data
      if (res['status'] == 200) {
        doshData = doshModelFromJson(jsonEncode(res));
        print("Api response success");
        print(res);
      } else {
        print("Api response failled");
      }
    });
  }

  bool gridList = false;
  bool fontSizeChange = true;
  double fontSizeDefault = 16.0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: dobDay.isEmpty
          ? Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ))
          : Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
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
                  "Kundli",
                  style: TextStyle(color: Colors.orange),
                ),
                actions: [
                  BouncingWidgetInOut(
                    onPressed: () {
                      setState(() {
                        gridList = !gridList;
                        translateEn = gridList ? 'en' : 'hi';
                      });
                      getKundliData();
                      getKundliDashaPage();
                      getSuggestionData();
                      getDoshData();
                      getKundliLalkitab();
                      getKundliFallPage();
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
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: TabBar(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.orange,
                      indicator: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8.0)),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          child:
                              Text(translateEn == "hi" ? "सामान्य" : 'Basic'),
                        ),
                        Tab(
                          child: Text(translateEn == "hi" ? "चार्ट" : "Charts"),
                        ),
                        Tab(
                          child: Text(translateEn == "hi" ? "दशा" : "Dasha"),
                        ),
                        Tab(
                          child: Text(translateEn == "hi" ? "फल" : "Phal"),
                        ),
                        Tab(
                          child: Text(
                              translateEn == "hi" ? "सुझाव" : "Suggestions"),
                        ),
                        Tab(
                          child: Text(translateEn == "hi" ? "दोष" : "Dosh"),
                        ),
                        Tab(
                          child: Text(
                              translateEn == "hi" ? "लाल किताब" : "Lal Kitab"),
                        ),
                      ],
                      labelStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 0.30,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 18.0,
                        letterSpacing: 0.30,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        BasicTab(),
                        ChartView(
                          name: widget.name,
                          day: widget.day,
                          month: widget.month,
                          year: widget.year,
                          hour: widget.hour,
                          mint: widget.mint,
                          country: widget.country,
                          city: widget.city,
                          lati: widget.lati,
                          longi: widget.longi,
                          translate: translateEn,
                        ),
                        DashaView(
                            name: widget.name,
                            date:
                                "${widget.day}/${widget.month}/${widget.year}",
                            time: "${widget.hour}:${widget.mint}",
                            country: widget.country,
                            city: widget.city,
                            lati: widget.lati,
                            longi: widget.longi,
                            translate: translateEn,
                            fontSizeDefault: fontSizeDefault,
                            vimshotriData: vimshotriDasha),
                        _fallHomeScreen(),
                        SuggestionView(
                          name: widget.name,
                          date: "${widget.day}/${widget.month}/${widget.year}",
                          time: "${widget.hour}:${widget.mint}",
                          country: widget.country,
                          city: widget.city,
                          lati: widget.lati,
                          longi: widget.longi,
                          translate: translateEn,
                          fontSizeDefault: fontSizeDefault,
                          suggestionData: suggestionData,
                        ),
                        DoshView(
                          name: widget.name,
                          date: "${widget.day}/${widget.month}/${widget.year}",
                          time: "${widget.hour}:${widget.mint}",
                          country: widget.country,
                          city: widget.city,
                          lati: widget.lati,
                          longi: widget.longi,
                          translate: translateEn,
                          fontSizeDefault: fontSizeDefault,
                          doshData: doshData,
                        ),
                        _lalKitabHome(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // lal kitab
  Widget _lalKitabHome() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      translateEn == "hi"
                          ? "लाल किताब उपचार" // Hindi for "Lal Kitab Treatment"
                          : "Lal Kitab Treatment", // English version
                    ),
                  ),
                  Tab(
                    child: Text(
                      translateEn == "hi"
                          ? "लाल किताब" // Hindi for "Lal Kitab"
                          : "Lal Kitab", // English version (same in this case)
                    ),
                  ),
                ],
                indicatorColor: Colors.orange,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.28),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.28),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _tratmentTab(),
                  _lalKitabTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // planet Tab
  Widget _tratmentTab() {
    List<LalKitabNameModel> lalKitabNameModelList = <LalKitabNameModel>[
      LalKitabNameModel(
          name: translateEn == "hi" ? "सूर्य \nउपाय " : "sun \nRemedeies",
          image: "assets/planet/sun.png"),
      LalKitabNameModel(
          name: translateEn == "hi" ? "चंद्रमा \nउपाय " : "moon \nRemedeies",
          image: "assets/planet/moon.png"),
      LalKitabNameModel(
          name: translateEn == "hi" ? "मंगल \nउपाय " : "mars \nRemedeies",
          image: "assets/planet/mars.png"),
      LalKitabNameModel(
          name: translateEn == "hi" ? "बुध \nउपाय " : "mercury \nRemedeies",
          image: "assets/planet/mercury.png"),
      LalKitabNameModel(
          name: translateEn == "hi" ? "गुरु \nउपाय " : "jupiter \nRemedeies",
          image: "assets/planet/jupitar.png"),
      LalKitabNameModel(
          name: translateEn == "hi" ? "शुक्र \nउपाय " : "venus \nRemedeies",
          image: "assets/planet/venus.png"),
      LalKitabNameModel(
          name: translateEn == "hi" ? "शनि \nउपाय " : "saturn \nRemedeies",
          image: "assets/planet/Saturn.png"),
    ];
    return Stack(
      children: [
        lalKitabName.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.orange,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                    child: Text(
                                  lalKitabName,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold),
                                ))),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "$lalKitabName ग्रह आपकी कुंडली में $lalKitabHouse घर में स्थित है.",
                              style: TextStyle(
                                  fontSize: fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              lalKitabDescriition,
                              style: TextStyle(fontSize: fontSizeDefault),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                    child: Text(
                                  translateEn == "hi" ? "उपचार" : "treatment",
                                  style: TextStyle(
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ))),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: lalKitabRemedies.length,
                              itemBuilder: (context, index) {
                                return Text(
                                    "${index + 1}. ${lalKitabRemedies[index]}",
                                    style: TextStyle(
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold,
                                    ));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 160,
                  ),
                ],
              ),
        //  FloatingActionButton area
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      seletcColor = index;
                      planetPositionName = menuItems[index];
                    });
                    getKundliLalkitab();
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: seletcColor == index
                            ? Colors.orange.shade100
                            : Colors.white,
                        border: Border.all(
                            color: Colors.grey.shade300, width: 1.5)),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white, // Shadow color
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 20, // Blur radius
                                    offset: Offset(
                                        0, 3), // Offset/direction of shadow
                                  ),
                                ]),
                            child: ClipRRect(
                                child: Image.asset(
                              lalKitabNameModelList[index].image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Center(
                              child: Text(
                            lalKitabNameModelList[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: seletcColor == index
                                  ? Colors.orange
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // daily Tab
  Widget _lalKitabTab() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: lalKitabModelList.length, // Number of items in the list
      itemBuilder: (BuildContext context, int index) {
        // itemBuilder function returns a widget for each item in the list
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Center(
                      child: Text(
                    lalKitabModelList[index].debtName,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: fontSizeDefault,
                        fontWeight: FontWeight.bold),
                  ))),
              const SizedBox(
                height: 10,
              ),
              Text(
                "संकेत",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: fontSizeDefault),
              ),
              Text(lalKitabModelList[index].indications,
                  style: TextStyle(fontSize: fontSizeDefault)),
              const Divider(
                color: Colors.grey,
              ),
              Text(
                "वाकया",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: fontSizeDefault),
              ),
              Text(lalKitabModelList[index].events,
                  style: TextStyle(fontSize: fontSizeDefault)),
            ],
          ),
        );
      },
    );
  }

  Widget _fallHomeScreen() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      translateEn == "hi"
                          ? "उदय राशि परिणाम"
                          : "Ascendant Result",
                    ),
                  ),
                  Tab(
                    child: Text(
                      translateEn == "hi"
                          ? "ग्रह गृह परिणाम"
                          : "Planet House Result",
                    ),
                  ),
                  Tab(
                    child: Text(
                      translateEn == "hi"
                          ? "दैनिक नक्षत्र स्थिति"
                          : "Daily Nakshatra fall",
                    ),
                  ),
                ],
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: Colors.orange,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.28),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.28),
              ),
            ),
            Expanded(
              child: lagnaName.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.orange,
                    ))
                  : TabBarView(
                      children: [
                        _ascendantTab(),
                        _planetTab(),
                        _nakshatraTab(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // "Ascendant Result",
  Widget _ascendantTab() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translateEn == "hi" ? "लग्न फल :" : "Lagna Predictions :",
                      style: TextStyle(
                        fontSize: fontSizeDefault,
                      ),
                    ),
                    Text(
                      " $lagnaName",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: fontSizeDefault),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              translateEn == "hi"
                  ? "आपका लग्न $lagnaName है"
                  : "Your ascendant is $lagnaName.",
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeDefault),
            ),
            Text(
              lagnaReport,
              style: TextStyle(fontSize: fontSizeDefault),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  // planet Tab
  Widget _planetTab() {
    List<PlanetNameModel> planetNameModelList = <PlanetNameModel>[
      PlanetNameModel(
          name: translateEn == "hi" ? "सूर्य" : "sun",
          image: "assets/planet/sun.png"),
      PlanetNameModel(
          name: translateEn == "hi" ? "चंद्रमा" : "moon",
          image: "assets/planet/moon.png"),
      PlanetNameModel(
          name: translateEn == "hi" ? "मंगल" : "mars",
          image: "assets/planet/mars.png"),
      PlanetNameModel(
          name: translateEn == "hi" ? "बुध" : "mercury",
          image: "assets/planet/mercury.png"),
      PlanetNameModel(
          name: translateEn == "hi" ? "गुरु" : "jupiter",
          image: "assets/planet/jupitar.png"),
      PlanetNameModel(
          name: translateEn == "hi" ? "शुक्र" : "venus",
          image: "assets/planet/venus.png"),
      PlanetNameModel(
          name: translateEn == "hi" ? "शनि" : "saturn",
          image: "assets/planet/Saturn.png"),
    ];
    List<String> planetPositionNameList = [
      "sun",
      "moon",
      "mars",
      "mercury",
      "jupiter",
      "venus",
      "saturn",
    ];

    return Stack(
      children: [
        planetName.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                // -- .. -. . .-.
                color: Colors.orange,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    translateEn == "hi"
                                        ? "ग्रह भाव फल : "
                                        : "Planet House Result :",
                                    style: TextStyle(fontSize: fontSizeDefault),
                                  ),
                                  Text(
                                    " $planetName",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSizeDefault,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            translateEn == "hi"
                                ? Html(
                                    data: planetReport,
                                    style: {
                                      "p": Style(
                                          fontSize: FontSize(fontSizeDefault))
                                    },
                                  )
                                : Text(
                                    planetReport,
                                    style: TextStyle(fontSize: fontSizeDefault),
                                  ),
                            const SizedBox(
                              height: 150,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        //  FloatingActionButton area
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            height: 150,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: planetNameModelList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      planetName = "";
                      planetPositionName = planetPositionNameList[index];
                      seletcColor = index;
                    });
                    print(planetPositionName);
                    getKundliFallPage();
                  },
                  child: Container(
                    width: 100,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: seletcColor == index
                            ? Colors.orange.shade100
                            : Colors.white,
                        border: Border.all(
                            color: Colors.grey.shade300, width: 1.5)),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white, // Shadow color
                                      spreadRadius: 1, // Spread radius
                                      blurRadius: 20, // Blur radius
                                      offset: Offset(
                                          0, 3), // Offset/direction of shadow
                                    ),
                                  ]),
                              child: Image.asset(
                                planetNameModelList[index].image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )),
                        ),
                        Expanded(
                          flex: 0,
                          child: Center(
                              child: Text(
                            planetNameModelList[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: seletcColor == index
                                  ? Colors.orange
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // daily Tab
  Widget _nakshatraTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translateEn == "hi"
                        ? "आपका नक्षत्र है :"
                        : "Planet House Result :",
                    style: TextStyle(fontSize: fontSizeDefault),
                  ),
                  Text(
                    " $nakshatraName",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeDefault),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  translateEn == "hi"
                      ? "$nakshatraName नक्षत्र दैनिक फल -"
                      : "$nakshatraName Nakshatra Daily Result -",
                  style: TextStyle(fontSize: fontSizeDefault),
                ),
                Text(
                  " $nakshatraDate",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeDefault),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  translateEn == "hi" ? "स्वास्थ्य" : "Health",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeDefault,
                  ),
                ),
              ),
            ),
            Text(
              nakshatraHealth,
              style: TextStyle(fontSize: fontSizeDefault),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  translateEn == "hi" ? "व्यक्तिगत जीवन" : "Personal Life",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeDefault,
                  ),
                ),
              ),
            ),
            Text(
              nakshatraPersonalLife,
              style: TextStyle(fontSize: fontSizeDefault),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  translateEn == "hi" ? "व्यापार/व्यवसाय" : "Business",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeDefault,
                  ),
                ),
              ),
            ),
            Text(
              nakshatraProfession,
              style: TextStyle(fontSize: fontSizeDefault),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  translateEn == "hi" ? "भावनाएं" : "Emotions",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeDefault,
                  ),
                ),
              ),
            ),
            Text(
              nakshatraEmotions,
              style: TextStyle(fontSize: fontSizeDefault),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  translateEn == "hi" ? "यात्रा" : "Travel",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeDefault,
                  ),
                ),
              ),
            ),
            Text(
              nakshatraTravel,
              style: TextStyle(fontSize: fontSizeDefault),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  translateEn == "hi" ? "भाग्य" : "Luck",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeDefault,
                  ),
                ),
              ),
            ),
            Text(
              nakshatraLuck,
              style: TextStyle(fontSize: fontSizeDefault),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget BasicTab() {
    List<List<String>> basicDetails = [
      [translateEn == "hi" ? "नाम" : 'Name', (widget.name)],
      [
        translateEn == "hi" ? "जन्म तिथि" : 'Date of birth',
        '$dobDay/$dobMonth/$dobYear'
      ],
      [
        translateEn == "hi" ? "जन्म समय" : 'Birth time',
        '$birthTimeHour : $birthTimeMinute'
      ],
      [translateEn == "hi" ? "अक्षांश" : 'Latitude', lati],
      [translateEn == "hi" ? "देशांतर" : 'Longitude', longi],
      [translateEn == "hi" ? "सूर्योदय" : 'Sunrise', '$sunrise AM'],
      [translateEn == "hi" ? "सूर्यास्त" : 'Sunset', '$sunset PM'],
      [translateEn == "hi" ? "समय क्षेत्र" : 'Time zone', 'GMT+$timeZone'],
      [translateEn == "hi" ? "आयनाम्श" : 'Ayanamsha', ayanamsha],
    ];

    List<List<String>> panchangDetails = [
      [translateEn == "hi" ? "दिन" : 'Day', panchangDay],
      [translateEn == "hi" ? "तिथि" : 'Tithi', tithi],
      [translateEn == "hi" ? "नक्षत्र" : 'Nakshatra', nakshatra],
      [translateEn == "hi" ? "योग" : 'Yog', yog],
      [translateEn == "hi" ? "करण" : 'Karan', karan],
      [translateEn == "hi" ? "सूर्योदय" : 'Sunrise', '$panchangSunrise AM'],
      [translateEn == "hi" ? "सूर्यास्त" : 'Sunset', '$panchangSunset PM'],
      [translateEn == "hi" ? "वैदिक सूर्योदय" : 'Vedic Sunrise', vedic_sunrise],
      [translateEn == "hi" ? "वैदिक सूर्यास्त" : 'Vedic Sunset', vedic_sunset],
    ];

    List<List<String>> avakhadaDetails = [
      [translateEn == "hi" ? "लग्न" : 'Ascendant', ascendant],
      [translateEn == "hi" ? "लग्न स्वामी" : 'Ascendant Lord', ascendant_lord],
      [translateEn == "hi" ? "वर्ण" : 'Varna', varna],
      [translateEn == "hi" ? "वश्य" : 'Vashya', vashya],
      [translateEn == "hi" ? "योनि" : 'Yoni', yoni],
      [translateEn == "hi" ? "गण" : 'Gan', gan],
      [translateEn == "hi" ? "नाड़ी" : 'Nadi', nadi],
      [translateEn == "hi" ? "राशि स्वामी" : 'Sign Lord', signLord],
      [translateEn == "hi" ? "राशि" : 'Sign', sign],
      [translateEn == "hi" ? "नक्षत्र" : 'Nakshatra Astro', naksahtraAstro],
      [
        translateEn == "hi" ? "नक्षत्र स्वामी" : 'Nakshatra Lord',
        naksahtraLord
      ],
      [translateEn == "hi" ? "चरण" : 'Charan', charan],
      [translateEn == "hi" ? "योग" : 'Yog Astro', yogAstro],
      [translateEn == "hi" ? "तिथि" : 'Tithi Astro', tithiastro],
      [translateEn == "hi" ? "युंज" : 'Yunja', yunja],
      [translateEn == "hi" ? "तत्व" : 'Tatva', tatva],
      [translateEn == "hi" ? "नाम का अक्षर" : 'Name Alphabet', name_alphabet],
      [translateEn == "hi" ? "पाया" : 'Paya', paya],
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTable(
              title: "Basic Details",
              data: basicDetails,
            ),
            CustomTable(
              title: "Panchang",
              data: panchangDetails,
            ),
            CustomTable(
              title: "Avakhada",
              data: avakhadaDetails,
            ),
          ],
        ),
      ),
    );
  }
}

class LalKitabNameModel {
  final String name;
  final String image;
  LalKitabNameModel({required this.name, required this.image});
}
