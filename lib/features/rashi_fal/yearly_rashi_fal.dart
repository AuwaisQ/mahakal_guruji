import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'Model/rashi_model.dart';
import 'Model/rashifalModel.dart';

class RashiphalData {
  String name;
  String? enDescription;
  String? hiDescription;
  String? urlHref;

  RashiphalData(
      {required this.name,
      this.enDescription,
      this.hiDescription,
      this.urlHref});
}

class YearlyRashiFal extends StatefulWidget {
  final double fontDefault;
  List<YearlyRashiModel>? previousData;
  final List<Rashi> rashiNameList;
  YearlyRashiFal(
      {super.key,
      required this.fontDefault,
      required this.previousData,
      required this.rashiNameList});

  @override
  State<YearlyRashiFal> createState() => _YearlyRashiFalState();
}

class _YearlyRashiFalState extends State<YearlyRashiFal>
    with SingleTickerProviderStateMixin {
  // Future<void> scrapeAndUpdateRashiphalData(List<RashiphalData> previousData) async {
  //   isLoading = true;
  //
  //   // The URL to scrape
  //   const url = 'https://www.drikpanchang.com/astrology/prediction/vedic-astrology-yearly-rashiphal.html';
  //
  //   // Fetch the HTML content of the page
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     // Parse the HTML content
  //     doc.Document document = parser.parse(response.body);
  //
  //     // Find all elements with class "dpRashiphalCollageCard"
  //     List<element.Element> rashiphalCards = document.querySelectorAll('div.dpRashiphalCollageCard');
  //
  //     List<RashiphalData> rashifal = [];
  //
  //     for (var card in rashiphalCards) {
  //       // Extract the name
  //       String? name = card.querySelector('div.dpRashiphalCardTitle div.dpRashiphalCollageTitle')?.text?.trim();
  //
  //       // Extract the English description
  //       String? enDescription = card.querySelector('div.dpRashiphalCardInfo')?.text?.trim();
  //
  //
  //       String? urlHref = card.querySelector('div.dpRashiphalExpand a')?.attributes['href'];
  //
  //
  //       if (name != null && enDescription != null) {
  //         setState(() {
  //           rashifal.add(RashiphalData(name: name!,enDescription: enDescription!, hiDescription: '', urlHref: urlHref));
  //         });
  //
  //       }
  //       setState(() {
  //         for (var data in rashifal) {
  //           bool found = false;
  //           for (var pre in previousData) {
  //             if (data.name == pre.name) {
  //               pre.hiDescription = data.enDescription;
  //               found = true;
  //               break;
  //             }
  //           }
  //           if (!found) {
  //             previousData.add(data);
  //           }
  //         }
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to load the page');
  //   }
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  //
  // Future<void> getRashiFalDetail(String url) async {
  //   isLoading = true;
  //   const String websiteURL = "https://www.drikpanchang.com";
  //   // Fetch the HTML content of the page
  //   final response = await http.get(Uri.parse('$websiteURL$url'));
  //
  //   if (response.statusCode == 200) {
  //     // Parse the HTML content
  //     doc.Document document = parser.parse(response.body);
  //
  //     // Extract specific sections
  //     String health = '';
  //     String financialCondition = '';
  //     String famiAndSocialLife = '';
  //     String loveLife = '';
  //     String eduAndCareer = '';
  //
  //     // Extract Health section
  //     var healthElement = document.querySelector('p.dpContent .dpHealth');
  //     if (healthElement != null) {
  //       health = healthElement.parent?.text.trim().replaceFirst('Health: ', '') ?? '';
  //       yearlyRashiHealth = health;
  //     }
  //
  //     // Extract Financial Condition section
  //     var financialConditionElement = document.querySelector('p.dpContent .dpCareer');
  //     if (financialConditionElement != null) {
  //       financialCondition = financialConditionElement.parent?.text.trim().replaceFirst('Financial Condition: ', '') ?? '';
  //       yearlyRashiFinacial = financialCondition;
  //     }
  //
  //     // Extract Family and Social Life section
  //     var famiAndSocialLifeElement = document.querySelector('p.dpContent .dpFamily');
  //     if (famiAndSocialLifeElement != null) {
  //       famiAndSocialLife = famiAndSocialLifeElement.parent?.text.trim().replaceFirst('Family and Social Life: ', '') ?? '';
  //       yearlyRashifmailyAndSocial = famiAndSocialLife;
  //     }
  //
  //     // Extract Love Life section
  //     var loveLifeElement = document.querySelector('p.dpContent .dpRomance');
  //     if (loveLifeElement != null) {
  //       loveLife = loveLifeElement.parent?.text.trim().replaceFirst('Love Life: ', '') ?? '';
  //       yearlyRashiLoveLife = loveLife;
  //     }
  //
  //     // Extract Education and Career section
  //     var eduAndCareerElement = document.querySelector('p.dpContent .dpBusiness');
  //     if (eduAndCareerElement != null) {
  //       eduAndCareer = eduAndCareerElement.parent?.text.trim().replaceFirst('Education and Career: ', '') ?? '';
  //       yearlyRashiEducation = eduAndCareer;
  //     }
  //
  //     // Print extracted data for debugging
  //     print('Health: $health');
  //     print('Financial Condition: $financialCondition');
  //     print('Family and Social Life: $famiAndSocialLife');
  //     print('Love Life: $loveLife');
  //     print('Education and Career: $eduAndCareer');
  //
  //   } else {
  //     throw Exception('Failed to load the page');
  //   }
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  //
  // var previousYearlyData = <YearlyRashiModel>[];
  List<RashiphalData> yearlyRashiFalData = [];
  late TabController tabController;
  bool isLoading = false;
  int selectedIndex = 0;
  // String yearlyRashiHealth = "";
  // String yearlyRashiFinacial = "";
  // String yearlyRashifmailyAndSocial = "";
  // String yearlyRashiLoveLife = "";
  // String yearlyRashiEducation = "";
  // final List<Rashi> rashiNameList = [
  //   Rashi(
  //     image: 'assets/testImage/categories/mesh.png',
  //     name: "Aries",
  //   ),
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
  // final List<String> yearlySahiName = [
  //   'mesha',
  //   'vrishabha',
  //   'mihuna',
  // ];

  // Future getRashiYearlyData() async {
  //   String language = "en";
  //   String apiUrl =
  //       'https://rashifal.rizrv.net/api/rashiphal/yearly?lang=$language';
  //   print("URL-$apiUrl");
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final res = await http.get(Uri.parse(apiUrl));
  //     print(res);
  //     setState(() {
  //       previousData = yearlyRashiModelFromJson(res.body);
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("Error fetching Rashi data: $e");
  //   }
  // }

  @override
  void initState() {
    // getRashiYearlyData();
    tabController =
        TabController(length: widget.rashiNameList.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : DefaultTabController(
              length: widget.rashiNameList.length,
              child: Column(
                children: [
                  TabBar(
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    splashFactory: NoSplash.splashFactory,
                    controller: tabController,
                    labelPadding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: const EdgeInsets.all(10),
                    dividerColor: Colors.white,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
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
                            height: selectedIndex == index ? 40 : 30,
                            width: selectedIndex == index ? 40 : 30,
                          ),
                        ),
                        text: widget.rashiNameList[index].name,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: List.generate(
                        widget.rashiNameList.length,
                        (index) {
                          return DelayedDisplay(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    //Health
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color:
                                                              Colors.orange)),
                                                  child: Center(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/testImage/rashifall/healthyear.png"),
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
                                                const Text(
                                                  "Health",
                                                  style: TextStyle(
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
                                              widget
                                                  .previousData![index].health,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: widget.fontDefault,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //Financial
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color:
                                                              Colors.orange)),
                                                  child: Center(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/testImage/rashifall/finance.png"),
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
                                                const Text(
                                                  "Financial",
                                                  style: TextStyle(
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
                                              widget.previousData![index]
                                                  .financialCondition,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: widget.fontDefault,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //Family
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color:
                                                              Colors.orange)),
                                                  child: Center(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/testImage/rashifall/familyandsocial.png"),
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
                                                const Text(
                                                  "Family and Social",
                                                  style: TextStyle(
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
                                              widget.previousData![index]
                                                  .familyAndSocialLife,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: widget.fontDefault,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //Love Life
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color:
                                                              Colors.orange)),
                                                  child: Center(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/testImage/rashifall/lovelife.png"),
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
                                                const Text(
                                                  "Love Life",
                                                  style: TextStyle(
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
                                              widget.previousData![index]
                                                  .loveLife,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: widget.fontDefault,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //Education
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color:
                                                              Colors.orange)),
                                                  child: Center(
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/testImage/rashifall/education.png"),
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
                                                const Text(
                                                  "Education",
                                                  style: TextStyle(
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
                                              widget.previousData![index]
                                                  .educationAndCareer,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: widget.fontDefault,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
