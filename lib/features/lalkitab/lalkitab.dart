import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';

import '../../main.dart';
import '../profile/controllers/profile_contrroller.dart';

class LalKitab extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final String country;
  final String city;
  final String lati;
  final String longi;
  const LalKitab(
      {super.key,
      required this.name,
      required this.date,
      required this.time,
      required this.country,
      required this.city,
      required this.lati,
      required this.longi});

  @override
  State<LalKitab> createState() => _LalKitabState();
}

class _LalKitabState extends State<LalKitab> {
  String userId = "";
  @override
  void initState() {
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    getKundliLalkitab();
  }

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
  List lalKitabRemedies = [];

  bool fontSizeChange = true;

  double fontSizeDefault = 16.0;
  int seletcColor = 0;

  String planetPositionName = "";
  String lalKitabName = "";
  String lalKitabHouse = "";
  String lalKitabDescriition = "";
  String translateEn = 'hi';
  bool gridList = false;

  void getKundliLalkitab() async {
    lalKitabName = "";
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
          actions: [
            BouncingWidgetInOut(
              onPressed: () {
                setState(() {
                  gridList = !gridList;
                  translateEn = gridList ? 'en' : 'hi';
                });
                getKundliLalkitab();
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
            )
          ],
          title: const Text(
            "Lal Kitab",
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            const Material(
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Lal Kitab Tratment",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Lal Kitab ",
                    ),
                  ),
                ],
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
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                                  "उपचार",
                                  style: TextStyle(
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ))),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
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
                            padding: const EdgeInsets.all(6),
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
    return lalKitabName.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.orange,
          ))
        : ListView.builder(
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
                    const Text(
                      "संकेत",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      lalKitabModelList[index].indications,
                      style: TextStyle(fontSize: fontSizeDefault),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const Text(
                      "वाकया",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(lalKitabModelList[index].events,
                        style: TextStyle(fontSize: fontSizeDefault)),
                  ],
                ),
              );
            },
          );
  }
}

class LalKitabNameModel {
  final String name;
  final String image;
  LalKitabNameModel({required this.name, required this.image});
}

List<LalkitabModel> lalkitabModelFromJson(String str) =>
    List<LalkitabModel>.from(
        json.decode(str).map((x) => LalkitabModel.fromJson(x)));

String lalkitabModelToJson(List<LalkitabModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LalkitabModel {
  String debtName;
  String indications;
  String events;

  LalkitabModel({
    required this.debtName,
    required this.indications,
    required this.events,
  });

  factory LalkitabModel.fromJson(Map<String, dynamic> json) => LalkitabModel(
    debtName: json["debt_name"],
    indications: json["indications"],
    events: json["events"],
  );

  Map<String, dynamic> toJson() => {
    "debt_name": debtName,
    "indications": indications,
    "events": events,
  };
}
