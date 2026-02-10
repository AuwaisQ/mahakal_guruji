import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import '../../../../main.dart';
import '../../../profile/controllers/profile_contrroller.dart';
import '../../models/lalkitab_model.dart';

class LalKitabView extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final String country;
  final String city;
  final String lati;
  final String longi;
  final String translate;
  final double fontSizeDefault;
  const LalKitabView({
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
  _LalKitabViewState createState() => _LalKitabViewState();
}

class _LalKitabViewState extends State<LalKitabView> {
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

  int seletcColor = 0;
  String userId = "";
  String planetPositionName = "";
  String lalKitabName = "";
  String lalKitabHouse = "";
  String lalKitabDescriition = "";
  List lalKitabRemedies = [];

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
      "language": widget.translate,
      "timezone": "5.5",
      "planet_name": planetPositionName,
      "tab": "lalkitab"
    });
    print(res);
    setState(() {
      //Pooja data
      if (res['status'] == 200) {
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
                    fontSize: 16.0,
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
          name: widget.translate == "hi" ? "सूर्य \nउपाय " : "sun \nRemedeies",
          image: "assets/planet/sun.png"),
      LalKitabNameModel(
          name:
              widget.translate == "hi" ? "चंद्रमा \nउपाय " : "moon \nRemedeies",
          image: "assets/planet/moon.png"),
      LalKitabNameModel(
          name: widget.translate == "hi" ? "मंगल \nउपाय " : "mars \nRemedeies",
          image: "assets/planet/mars.png"),
      LalKitabNameModel(
          name:
              widget.translate == "hi" ? "बुध \nउपाय " : "mercury \nRemedeies",
          image: "assets/planet/mercury.png"),
      LalKitabNameModel(
          name:
              widget.translate == "hi" ? "गुरु \nउपाय " : "jupiter \nRemedeies",
          image: "assets/planet/jupitar.png"),
      LalKitabNameModel(
          name:
              widget.translate == "hi" ? "शुक्र \nउपाय " : "venus \nRemedeies",
          image: "assets/planet/venus.png"),
      LalKitabNameModel(
          name: widget.translate == "hi" ? "शनि \nउपाय " : "saturn \nRemedeies",
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
                                      fontSize: widget.fontSizeDefault,
                                      fontWeight: FontWeight.bold),
                                ))),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "$lalKitabName ग्रह आपकी कुंडली में $lalKitabHouse घर में स्थित है.",
                              style: TextStyle(
                                  fontSize: widget.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              lalKitabDescriition,
                              style:
                                  TextStyle(fontSize: widget.fontSizeDefault),
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
                                      fontSize: widget.fontSizeDefault,
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
                                      fontSize: widget.fontSizeDefault,
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
                        fontSize: widget.fontSizeDefault,
                        fontWeight: FontWeight.bold),
                  ))),
              const SizedBox(
                height: 10,
              ),
              Text(
                "संकेत",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSizeDefault),
              ),
              Text(lalKitabModelList[index].indications,
                  style: TextStyle(fontSize: widget.fontSizeDefault)),
              const Divider(
                color: Colors.grey,
              ),
              Text(
                "वाकया",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSizeDefault),
              ),
              Text(lalKitabModelList[index].events,
                  style: TextStyle(fontSize: widget.fontSizeDefault)),
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
