import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../profile/controllers/profile_contrroller.dart';

class FallView extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final String country;
  final String city;
  final String lati;
  final String longi;
  final String translate;
  final double fontSizeDefault;
  const FallView({
    super.key,
    required this.name,
    required this.date,
    required this.time,
    required this.country,
    required this.city,
    required this.lati,
    required this.longi,
    required this.translate,
    required this.fontSizeDefault,
  });

  @override
  State<FallView> createState() => _FallViewState();
}

class _FallViewState extends State<FallView> {
  @override
  void initState() {
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    getKundliFallPage();
  }

  //Lagna Data
  String userId = "";
  String lagnaName = "";
  String lagnaReport = "";
  //planet data
  String planetName = "";
  String planetReport = "";
  int seletcColor = 0;
  String planetPositionName = "";
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
      "date": widget.date,
      "time": widget.time,
      "country": widget.country,
      "city": widget.city,
      "latitude": widget.lati,
      "longitude": widget.longi,
      "language": widget.translate,
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const Material(
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Ascendant Result",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Planet House Result",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Daily Nakshatra fall",
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
                labelStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.28),
                unselectedLabelStyle: TextStyle(
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
                      "लग्न फल :",
                      style: TextStyle(
                        fontSize: widget.fontSizeDefault,
                      ),
                    ),
                    Text(
                      " $lagnaName",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: widget.fontSizeDefault),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "आपका लग्न $lagnaName है",
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSizeDefault),
            ),
            Text(
              lagnaReport,
              style: TextStyle(fontSize: widget.fontSizeDefault),
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
          name: widget.translate == "hi" ? "सूर्य" : "sun",
          image: "assets/planet/sun.png"),
      PlanetNameModel(
          name: widget.translate == "hi" ? "चंद्रमा" : "moon",
          image: "assets/planet/moon.png"),
      PlanetNameModel(
          name: widget.translate == "hi" ? "मंगल" : "mars",
          image: "assets/planet/mars.png"),
      PlanetNameModel(
          name: widget.translate == "hi" ? "बुध" : "mercury",
          image: "assets/planet/mercury.png"),
      PlanetNameModel(
          name: widget.translate == "hi" ? "गुरु" : "jupiter",
          image: "assets/planet/jupitar.png"),
      PlanetNameModel(
          name: widget.translate == "hi" ? "शुक्र" : "venus",
          image: "assets/planet/venus.png"),
      PlanetNameModel(
          name: widget.translate == "hi" ? "शनि" : "saturn",
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
                                    "ग्रह भाव फल : ",
                                    style: TextStyle(
                                        fontSize: widget.fontSizeDefault),
                                  ),
                                  Text(
                                    " $planetName",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: widget.fontSizeDefault,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            widget.translate == "hi"
                                ? Html(
                                    data: planetReport,
                                    style: {
                                      "p": Style(
                                          fontSize:
                                              FontSize(widget.fontSizeDefault))
                                    },
                                  )
                                : Text(
                                    planetReport,
                                    style: TextStyle(
                                        fontSize: widget.fontSizeDefault),
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
                    "आपका नक्षत्र है : ",
                    style: TextStyle(fontSize: widget.fontSizeDefault),
                  ),
                  Text(
                    " $nakshatraName",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSizeDefault),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$nakshatraNameनक्षत्र दैनिक फल - ",
                  style: TextStyle(fontSize: widget.fontSizeDefault),
                ),
                Text(
                  " $nakshatraDate",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.fontSizeDefault),
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
                  child: Text("स्वास्थ्य",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSizeDefault))),
            ),
            Text(
              nakshatraHealth,
              style: TextStyle(fontSize: widget.fontSizeDefault),
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
                  child: Text("व्यक्तिगत जीवन",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSizeDefault))),
            ),
            Text(
              nakshatraPersonalLife,
              style: TextStyle(fontSize: widget.fontSizeDefault),
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
                  child: Text("व्यापार/व्यवसाय",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSizeDefault))),
            ),
            Text(
              nakshatraProfession,
              style: TextStyle(fontSize: widget.fontSizeDefault),
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
                  child: Text("भावनाएं",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSizeDefault))),
            ),
            Text(
              nakshatraEmotions,
              style: TextStyle(fontSize: widget.fontSizeDefault),
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
                  child: Text("यात्रा",
                      style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSizeDefault))),
            ),
            Text(
              nakshatraTravel,
              style: TextStyle(fontSize: widget.fontSizeDefault),
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
                  child: Text("भाग्य",
                      style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSizeDefault))),
            ),
            Text(
              nakshatraLuck,
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class PlanetNameModel {
  final String name;
  final String image;
  PlanetNameModel({required this.name, required this.image});
}
