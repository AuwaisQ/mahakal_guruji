import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as doc;
import 'package:html/dom.dart' as element;
import 'Model/rashi_model.dart';
import 'Model/rashifalModel.dart';

class RashiphalData {
  String name;
  String? enDescription;
  String? hiDescription;

  RashiphalData({required this.name, this.enDescription, this.hiDescription});
}

class MonthlyRashiFal extends StatefulWidget {
  final double fontDefault;
  List<RashiMonthlyModel>? previousData;
  final List<Rashi> rashiNameList;
  MonthlyRashiFal(
      {super.key,
      required this.fontDefault,
      required this.previousData,
      required this.rashiNameList});

  @override
  State<MonthlyRashiFal> createState() => _MonthlyRashiFalState();
}

class _MonthlyRashiFalState extends State<MonthlyRashiFal>
    with SingleTickerProviderStateMixin {
  Future<void> scrapeAndUpdateRashiphalData(
      List<RashiphalData> previousData) async {
    isLoading = true;

    // The URL to scrape
    const url =
        'https://www.drikpanchang.com/astrology/prediction/vedic-astrology-monthly-rashiphal.html';

    // Fetch the HTML content of the page
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the HTML content
      doc.Document document = parser.parse(response.body);

      // Find all elements with class "dpRashiphalCollageCard"
      List<element.Element> rashiphalCards =
          document.querySelectorAll('div.dpRashiphalCollageCard');

      List<RashiphalData> rashifal = [];

      for (var card in rashiphalCards) {
        // Extract the name
        String? name = card
            .querySelector(
                'div.dpRashiphalCardTitle div.dpRashiphalCollageTitle')
            ?.text
            .trim();
        print("Name$name");

        // Extract the English description
        String? enDescription =
            card.querySelector('div.dpRashiphalCardInfo')?.text.trim();
        print("enDescription$enDescription");

        if (name != null && enDescription != null) {
          setState(() {
            rashifal.add(RashiphalData(
                name: name, enDescription: enDescription, hiDescription: ''));
          });
        }
        setState(() {
          for (var data in rashifal) {
            bool found = false;
            for (var pre in previousData) {
              if (data.name == pre.name) {
                pre.hiDescription = data.enDescription;
                found = true;
                break;
              }
            }
            if (!found) {
              previousData.add(data);
            }
          }
        });
      }
    } else {
      throw Exception('Failed to load the page');
    }

    setState(() {
      isLoading = false;
    });
    print('previous data len ${previousData.length}');
  }

  // var previousData = <RashiMonthlyModel>[];
  late TabController tabController;
  bool isLoading = false;
  bool isTranslate = false;
  int selectedIndex = 0;

  // final List<Rashi> rashiNameList = [
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

  // Future getRashiMonthData() async {
  //   String language = widget.language;
  //   String apiUrl = 'https://rashifal.rizrv.net/api/rashiphal/monthly?lang=$language';
  //   print("URL-$apiUrl");
  //   setState(() {isLoading = true;});
  //
  //   try{
  //     final res = await http.get(Uri.parse(apiUrl));
  //     print(res);
  //     setState(() {
  //       previousData = rashiMonthlyModelFromJson(res.body);
  //       isLoading = false;
  //     });
  //   }catch(e){
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("Error fetching Rashi data: $e");
  //   }
  // }

  @override
  void initState() {
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
          : widget.previousData!.isEmpty
              ? const Center(
                  child: Text('No Data-Found'),
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
                        labelPadding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
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
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.asset(
                                                    widget.rashiNameList[index]
                                                        .image,
                                                    height: 50,
                                                  ),
                                                ),
                                                Text(
                                                  widget.rashiNameList[index]
                                                      .name,
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize:
                                                        widget.fontDefault,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(color: Colors.grey),
                                            Text(
                                              widget.previousData![index]
                                                  .description,
                                              style: TextStyle(
                                                  fontSize: widget.fontDefault),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

      // body: ListView.separated(
      //   itemCount: previousData.length,
      //     itemBuilder:(context, index){
      //       return Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(previousData[index].name!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //           const SizedBox(height: 5,),
      //           Text(previousData[index].enDescription!),
      //           const SizedBox(height: 20,),
      //         ],
      //       );
      //     }, separatorBuilder: (BuildContext context, int index) {  return const Divider();},
      // ),
    );
  }
}
