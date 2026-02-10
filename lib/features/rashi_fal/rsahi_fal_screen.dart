import 'dart:ui';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/rashi_fal/Model/rashi_model.dart';
import 'package:mahakal/features/rashi_fal/monthly_rashi.dart';
import 'package:mahakal/features/rashi_fal/yearly_rashi_fal.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import '../../localization/language_constrants.dart';
import '../../utill/app_constants.dart';
import 'package:http/http.dart' as http;

import 'Model/rashifalModel.dart';

class RashiFallView extends StatefulWidget {
  String rashiName;
  final List<Rashi> rashiNameList;
  int index = 0;
  BuildContext context;
  RashiFallView(
      {super.key,
      required this.rashiName,
      required this.index,
      required this.context,
      required this.rashiNameList});

  @override
  State<RashiFallView> createState() => _RashiFallViewState();
}

class _RashiFallViewState extends State<RashiFallView>
    with SingleTickerProviderStateMixin {
  String lang = 'hi';
  String luck = '';
  String health = '';
  String emotion = '';
  String personalLife = '';
  String profession = '';
  String travel = '';
  String rashiFallName = '';
  bool fontSizeChange = true;
  double fontSizeDefault = 16.0;
  bool gridList = false;
  bool isLoading = false;
  var rashiList = <RashiModel>[];

  var previousData = <RashiMonthlyModel>[];

  var previousYearlyData = <YearlyRashiModel>[];

  // [
  //   Rashi(image: 'assets/testImage/categories/mesh.png', name: "Aries"),
  //   Rashi(image: 'assets/testImage/categories/vrash.png', name: "Taurus"),
  //   Rashi(image: 'assets/testImage/categories/mithun.png', name: "Gemini"),
  //   Rashi(image: 'assets/testImage/categories/kark.png', name: "Cancer"),
  //   Rashi(image: 'assets/testImage/categories/singh.png', name: "Leo"),
  //   Rashi(image: 'assets/testImage/categories/kanya.png', name: "Virgo"),
  //   Rashi(image: 'assets/animated/tula.gif', name: "Libra"),
  //   Rashi(image: 'assets/testImage/categories/vrashik.png', name: "Scorpio"),
  //   Rashi(image: 'assets/animated/dhanu.gif', name: "Sagittarius"),
  //   Rashi(image: 'assets/testImage/categories/makar.png', name: "Capricon"),
  //   Rashi(image: 'assets/testImage/categories/kumbh.png', name: "Aquarius"),
  //   Rashi(image: 'assets/animated/meen.gif', name: "Pisces"),
  // ];
  int seletcColor = 0;
  late TabController tabController;
  late PageController _pageController;

  String imageChange =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT06TO6bWc8ne6Tyr-CLj8FvZfMO7UEWFjw8w&s";
  String nameChange = "Aries";

  Future<void> fetchData(String rashiName) async {
    setState(() {
      rashiFallName = rashiName;
      print("rashi name $rashiName");
    });
    // Define API URLs
    final ariesData = "${AppConstants.rashiDailyData}/$rashiName/$lang";
    final responses = await HttpService().getApi(ariesData);

    // Extract responses
    final rashiDailyData = responses;

    // Process Panchang data
    luck = rashiDailyData['rashi']['prediction']['luck'];
    health = rashiDailyData['rashi']['prediction']['health'];
    emotion = rashiDailyData['rashi']['prediction']['emotions'];
    personalLife = rashiDailyData['rashi']['prediction']['personal_life'];
    profession = rashiDailyData['rashi']['prediction']['profession'];
    travel = rashiDailyData['rashi']['prediction']['travel'];

    rashiList = [
      RashiModel(
          name: "health",
          discription: health,
          image: 'assets/testImage/rashifall/health.png'),
      RashiModel(
          name: "emotion",
          discription: emotion,
          image: 'assets/testImage/rashifall/emotional.png'),
      RashiModel(
          name: "personalLife",
          discription: personalLife,
          image: 'assets/testImage/rashifall/personallife.png'),
      RashiModel(
          name: "profession",
          discription: profession,
          image: 'assets/testImage/rashifall/profession.png'),
      RashiModel(
          name: "travel",
          discription: travel,
          image: 'assets/testImage/rashifall/travell.png')
    ];
    setState(() {});
  }

  Future getRashiMonthData() async {
    String apiUrl =
        'https://rashifal.rizrv.net/api/rashiphal/monthly?lang=$lang';
    print("URL-$apiUrl");
    setState(() {
      isLoading = true;
    });

    try {
      final res = await http.get(Uri.parse(apiUrl));
      print(res);
      setState(() {
        previousData.clear();
        previousData = rashiMonthlyModelFromJson(res.body);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching Rashi data: $e");
    }
  }

  Future getRashiYearlyData() async {
    String apiUrl =
        'https://rashifal.rizrv.net/api/rashiphal/yearly?lang=$lang';
    print("URL-$apiUrl");
    setState(() {
      isLoading = true;
    });
    try {
      final res = await http.get(Uri.parse(apiUrl));
      print(res);
      setState(() {
        previousYearlyData = yearlyRashiModelFromJson(res.body);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching Rashi data: $e");
    }
  }

  @override
  void initState() {
    tabController = TabController(
        length: widget.rashiNameList.length,
        vsync: this,
        initialIndex: widget.index);
    _pageController = PageController();
    // Synchronize PageController with TabController
    _pageController.addListener(() {
      int newIndex = _pageController.page!.round();
      setState(() {
        tabController.index = newIndex;
        print("tab index ${tabController.index}");
      });
    });
    rashiFallName = widget.rashiName;
    fetchData(widget.rashiName);
    getRashiMonthData();
    getRashiYearlyData();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> rashiListName = [
      "Aries",
      "Taurus",
      "Gemini",
      "Cancer",
      "Leo",
      "Virgo",
      "Libra",
      "Scorpio",
      "Sagittarius",
      "Capricorn",
      "Aquarius",
      "Pisces"
    ];
    return DefaultTabController(
      length: 3,
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
                  gridList ? lang = 'en' : lang = 'hi';
                  fetchData(rashiListName[tabController.index]);
                  getRashiMonthData();
                  getRashiYearlyData();
                });
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
                  child: Icon(
                    Icons.translate,
                    color: gridList ? Colors.white : Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10)
          ],
          title: Text(
            rashiFallName,
            style: const TextStyle(color: Colors.orange),
          ),
          centerTitle: true,
          bottom: TabBar(
            dividerColor: Colors.grey,
            labelColor: Colors.orange,
            indicatorColor: Colors.orange,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                text: getTranslated('today', context),
                icon: Image.asset(
                  'assets/images/gif/todayRashi.gif',
                  height: 30,
                  width: 30,
                ),
              ),
              Tab(
                text: getTranslated('month', context),
                icon: Image.asset(
                  'assets/images/gif/monthRashi.gif',
                  height: 30,
                  width: 30,
                ),
              ),
              Tab(
                text: getTranslated('year', context),
                icon: Image.asset(
                  'assets/images/gif/yearRashi.gif',
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // tab 1
            RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  gridList ? lang = 'en' : lang = 'hi';
                  fetchData(rashiListName[tabController.index]);
                  getRashiMonthData();
                  getRashiYearlyData();
                },
                child: todayRashiFal(context, fontSizeDefault)),
            // tab 2
            RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  gridList ? lang = 'en' : lang = 'hi';
                  fetchData(rashiListName[tabController.index]);
                  getRashiMonthData();
                  getRashiYearlyData();
                },
                child: MonthlyRashiFal(
                  fontDefault: fontSizeDefault,
                  previousData: previousData,
                  rashiNameList: widget.rashiNameList,
                )),
            // tab 3
            RefreshIndicator(
                color: Colors.orange,
                onRefresh: () async {
                  gridList ? lang = 'en' : lang = 'hi';
                  fetchData(rashiListName[tabController.index]);
                  getRashiMonthData();
                  getRashiYearlyData();
                },
                child: YearlyRashiFal(
                  fontDefault: fontSizeDefault,
                  previousData: previousYearlyData,
                  rashiNameList: widget.rashiNameList,
                )),
          ],
        ),
      ),
    );
  }

  Widget todayRashiFal(BuildContext context, double fontSize) {
    final List<String> rashiListName = [
      "Aries",
      "Taurus",
      "Gemini",
      "Cancer",
      "Leo",
      "Virgo",
      "Libra",
      "Scorpio",
      "Sagittarius",
      "Capricorn",
      "Aquarius",
      "Pisces"
    ];
    return DefaultTabController(
      length: widget.rashiNameList.length,
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            onTap: (int index) {
              setState(() {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
                fetchData(rashiListName[tabController.index]);
              });
            },
            splashFactory: NoSplash.splashFactory,
            labelPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.all(10),
            dividerColor: Colors.white,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.orange, width: 3),
            ),
            tabs: List.generate(
              widget.rashiNameList.length,
              (index) => Tab(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    widget.rashiNameList[index].image,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                ),
                text: widget.rashiNameList[index].name,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  tabController.index = index;
                  fetchData(rashiListName[tabController.index]);
                });
              },
              children: List.generate(
                widget.rashiNameList.length,
                (index) {
                  return DelayedDisplay(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade400,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.asset(
                                            widget.rashiNameList[index].image,
                                            height: 40,
                                          ),
                                        ),
                                        Text(
                                          widget.rashiNameList[index].name,
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(color: Colors.grey),
                                    Text(
                                      luck,
                                      style: TextStyle(fontSize: fontSize),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rashiList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.orange, width: 1.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                          ),
                                          border: const Border(
                                            bottom: BorderSide(
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                      color: Colors.orange)),
                                              child: Center(
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: AssetImage(
                                                          rashiList[index]
                                                              .image),
                                                      height: 30,
                                                      fit: BoxFit.fill,
                                                    )
                                                    // Image.network(
                                                    //   "https://5.imimg.com/data5/MP/XD/ZG/SELLER-37889120/rashi-bhavishya-services-500x500.jpg",
                                                    //   height: 40,
                                                    //   fit: BoxFit.fill,
                                                    // ),
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              rashiList[index].name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          rashiList[index].discription,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: fontSize,
                                          ),
                                        ),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RashifalModel {
  final String name;
  final String image;
  RashifalModel({required this.image, required this.name});
}
