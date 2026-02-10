import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utill/app_constants.dart';

class HoroscopeChartView extends StatefulWidget {
  //Male data
  final String maleName;
  final String maleDate;
  final String maleTime;
  final String maleCountry;
  final String maleCity;
  final String maleLati;
  final String maleLongi;
  // Female data
  final String femaleName;
  final String femaleDate;
  final String femaleTime;
  final String femaleCountry;
  final String femaleCity;
  final String femaleLati;
  final String femaleLongi;

  final String translate;
  const HoroscopeChartView(
      {super.key,
      required this.maleName,
      required this.maleDate,
      required this.maleTime,
      required this.maleCountry,
      required this.maleCity,
      required this.maleLati,
      required this.maleLongi,
      required this.femaleName,
      required this.femaleDate,
      required this.femaleTime,
      required this.femaleCountry,
      required this.femaleCity,
      required this.femaleLati,
      required this.femaleLongi,
      required this.translate});
  @override
  _HoroscopeChartViewState createState() => _HoroscopeChartViewState();
}

class _HoroscopeChartViewState extends State<HoroscopeChartView> {
  @override
  void initState() {
    super.initState();
    print("male ${widget.maleName}");
    print("date ${widget.maleDate.substring(0, 2)}");
    print("date ${widget.maleDate.substring(3, 5)}");
    print("date ${widget.maleDate.substring(6, 10)}");
    print("date ${widget.maleTime.substring(0, 2)}");
    print("date ${widget.maleTime.substring(3, 5)}");
    print("date ${widget.maleCountry}");
    print("date ${widget.maleCity}");
    print("date ${widget.maleLati}");
    print("date ${widget.maleLongi}");

    print("female ${widget.femaleName}");
    print("female ${widget.femaleDate}");
    print("date ${widget.femaleDate.substring(0, 2)}");
    print("date ${widget.femaleDate.substring(3, 5)}");
    print("date ${widget.femaleDate.substring(6, 10)}");
    print("date ${widget.femaleTime.substring(0, 2)}");
    print("date ${widget.femaleTime.substring(3, 5)}");
    print("date ${widget.femaleCountry}");
    print("date ${widget.femaleCity}");
    print("date ${widget.femaleLati}");
    print("date ${widget.femaleLongi}");
  }

  int maleSeletcColor = 2;
  int femaleSeletcColor = 2;
  String maleChartData = "D1";
  String femaleChartData = "D1";
  String northchartUrl = "${AppConstants.baseUrl}${AppConstants.northChartURL}";
  String southchartUrl = "${AppConstants.baseUrl}${AppConstants.southChartURL}";
  String? northChart;

  // List<ListChartItems> chartItemsModelList = <ListChartItems>[
  //   ListChartItems(name:widget.translate == "hi" ? "सूर्य \nचार्ट": "Sun \nChart", types: "SUN",image:"assets/images/kundli_chart_images/Sun_Chart.png", gifImage: 'assets/images/kundli_chart_images/Sun_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "चंद्र \nचार्ट": "Moon \nChart", types: "MOON",image:"assets/images/kundli_chart_images/Moon_Chart.png", gifImage: 'assets/images/kundli_chart_images/Moon_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "जन्म \nचार्ट" : "Birth \nChart", types: "D1",image:"assets/images/kundli_chart_images/Birth_Chart.png", gifImage: 'assets/images/kundli_chart_images/Birth_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "होरा \nचार्ट" : "Hora \nChart", types: "D2",image:"assets/images/kundli_chart_images/Hora_Chart.png", gifImage: 'assets/images/kundli_chart_images/Hora_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "द्रेष्काण चार्ट" :  "Dreshkan Chart", types: "D3",image:"assets/images/kundli_chart_images/Dreshkan_Chart.png", gifImage: 'assets/images/kundli_chart_images/Dreshkan_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "चतुर्थांश चार्ट" :  "Chathurthamasha Chart", types: "D4",image:"assets/images/kundli_chart_images/Chathurtha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Chathurtha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "पंचमांश चार्ट" :  "Panchmansha Chart", types: "D5",image:"assets/images/kundli_chart_images/Panchmansha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Panchmansha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "सप्तमांश चार्ट" :  "Saptamansha Chart", types: "D7",image:"assets/images/kundli_chart_images/Saptamasha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Saptamasha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "अष्टमांश चार्ट" :  "Ashtamansha Chart", types: "D8",image:"assets/images/kundli_chart_images/Ashtamansha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Ashtamansha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "नवमांश चार्ट" :  "Navamansha Chart", types: "D9",image:"assets/images/kundli_chart_images/Navamansha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Navamansha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "द्वादशांश चार्ट" :  "Dwadashamsha Chart", types: "D10",image:"assets/images/kundli_chart_images/Dwadashamsha_chart.png", gifImage: 'assets/images/kundli_chart_images/Dwadashamsha_chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "दशमांश चार्ट" :  "Dashamansha Chart", types: "D12",image:"assets/images/kundli_chart_images/Dashmansha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Dashmansha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "षोडशांश चार्ट" :  "Shodashamsha Chart", types: "D16",image:"assets/images/kundli_chart_images/Shodashamsha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Shodashamsha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "विषमांश चार्ट" :  "Vishamansha Chart", types: "D20",image:"assets/images/kundli_chart_images/Vishamansha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Vishamansha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "चतुर्विम्शांश चार्ट" :  "Chaturvimshamsha Chart", types: "D24",image:"assets/images/kundli_chart_images/Chaturvishamsha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Chaturvishamsha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "भाम्शा चार्ट" :  "Bhamsha Chart", types: "D27",image:"assets/images/kundli_chart_images/Bhamsha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Bhamsha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "त्रिशमांश चार्ट" :  "Trishamansha Chart", types: "D30",image:"assets/images/kundli_chart_images/Trishamansha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Trishamansha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "खवेड़मांश चार्ट" :  "Khavedamsha Chart", types: "D40",image:"assets/images/kundli_chart_images/Khavedamsha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Khavedamsha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "अक्षवेदांश चार्ट" :  "Akshvedansha Chart", types: "D45",image:"assets/images/kundli_chart_images/Akshvedansha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Akshvedansha_Chart.gif'),
  //   ListChartItems(name:widget.translate == "hi" ? "षष्ट्यंश चार्ट" :  "Shashtymsha Chart", types: "D60",image:"assets/images/kundli_chart_images/Shashtymsha_Chart.png", gifImage: 'assets/images/kundli_chart_images/Shashtymsha_Chart.gif'),
  // ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            TabBar(
              tabs: [
                Tab(
                  child: Text(
                    widget.translate == "hi" ? "पुरुष चार्ट" : "Male Chart",
                  ),
                ),
                Tab(
                  child: Text(
                    widget.translate == "hi" ? "महिला चार्ट" : "Female Chart",
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
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto-Regular',
                  letterSpacing: 0.28),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Roboto-Regular',
                  letterSpacing: 0.28),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _northTab(),
                  _southTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// north
  Widget _northTab() {
    List<ListChartItems> chartItemsModelList = <ListChartItems>[
      ListChartItems(
          name: widget.translate == "hi" ? "सूर्य \nचार्ट" : "Sun \nChart",
          types: "SUN",
          image: "assets/images/kundli_chart_images/Sun_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Sun_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "चंद्र \nचार्ट" : "Moon \nChart",
          types: "MOON",
          image: "assets/images/kundli_chart_images/Moon_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Moon_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "जन्म \nचार्ट" : "Birth \nChart",
          types: "D1",
          image: "assets/images/kundli_chart_images/Birth_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Birth_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "होरा \nचार्ट" : "Hora \nChart",
          types: "D2",
          image: "assets/images/kundli_chart_images/Hora_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Hora_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "द्रेष्काण चार्ट" : "Dreshkan Chart",
          types: "D3",
          image: "assets/images/kundli_chart_images/Dreshkan_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Dreshkan_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "चतुर्थांश चार्ट"
              : "Chathurthamasha Chart",
          types: "D4",
          image: "assets/images/kundli_chart_images/Chathurtha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Chathurtha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "पंचमांश चार्ट" : "Panchmansha Chart",
          types: "D5",
          image: "assets/images/kundli_chart_images/Panchmansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Panchmansha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "सप्तमांश चार्ट" : "Saptamansha Chart",
          types: "D7",
          image: "assets/images/kundli_chart_images/Saptamasha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Saptamasha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "अष्टमांश चार्ट" : "Ashtamansha Chart",
          types: "D8",
          image: "assets/images/kundli_chart_images/Ashtamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Ashtamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "नवमांश चार्ट" : "Navamansha Chart",
          types: "D9",
          image: "assets/images/kundli_chart_images/Navamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Navamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "द्वादशांश चार्ट"
              : "Dwadashamsha Chart",
          types: "D10",
          image: "assets/images/kundli_chart_images/Dwadashamsha_chart.png",
          gifImage: 'assets/images/kundli_chart_images/Dwadashamsha_chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "दशमांश चार्ट" : "Dashamansha Chart",
          types: "D12",
          image: "assets/images/kundli_chart_images/Dashmansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Dashmansha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "षोडशांश चार्ट" : "Shodashamsha Chart",
          types: "D16",
          image: "assets/images/kundli_chart_images/Shodashamsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Shodashamsha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "विषमांश चार्ट" : "Vishamansha Chart",
          types: "D20",
          image: "assets/images/kundli_chart_images/Vishamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Vishamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "चतुर्विम्शांश चार्ट"
              : "Chaturvimshamsha Chart",
          types: "D24",
          image: "assets/images/kundli_chart_images/Chaturvishamsha_Chart.png",
          gifImage:
              'assets/images/kundli_chart_images/Chaturvishamsha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "भाम्शा चार्ट" : "Bhamsha Chart",
          types: "D27",
          image: "assets/images/kundli_chart_images/Bhamsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Bhamsha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "त्रिशमांश चार्ट"
              : "Trishamansha Chart",
          types: "D30",
          image: "assets/images/kundli_chart_images/Trishamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Trishamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "खवेड़मांश चार्ट"
              : "Khavedamsha Chart",
          types: "D40",
          image: "assets/images/kundli_chart_images/Khavedamsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Khavedamsha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "अक्षवेदांश चार्ट"
              : "Akshvedansha Chart",
          types: "D45",
          image: "assets/images/kundli_chart_images/Akshvedansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Akshvedansha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "षष्ट्यंश चार्ट" : "Shashtymsha Chart",
          types: "D60",
          image: "assets/images/kundli_chart_images/Shashtymsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Shashtymsha_Chart.gif'),
    ];

    var webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00005600))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          '${northchartUrl}day=${widget.maleDate.substring(0, 2)}&month=${widget.maleDate.substring(3, 5)}&year=${widget.maleDate.substring(6, 10)}&hour=${widget.maleTime.substring(0, 2)}&min=${widget.maleTime.substring(3, 5)}&lat=${widget.maleLati}&lon=${widget.maleLongi}&tzone=5.5&type=$maleChartData'));
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
              child: SizedBox(
                  height: 400, child: WebViewWidget(controller: webController)),
            ),
          ],
        ),
        //  FloatingActionButton area
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 160,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: chartItemsModelList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      maleSeletcColor = index;
                      maleChartData = chartItemsModelList[index].types;
                    });
                    print("chartdata $maleChartData");
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: maleSeletcColor == index
                            ? Colors.orange.shade100
                            : Colors.white,
                        border: Border.all(
                            color: Colors.grey.shade300, width: 1.5)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 3.0,
                        ),
                        Container(
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
                            child: maleSeletcColor == index
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      chartItemsModelList[index].gifImage,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      chartItemsModelList[index].image,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        const SizedBox(
                          height: 0.5,
                        ),
                        Center(
                            child: Text(
                          chartItemsModelList[index].name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: maleSeletcColor == index
                                ? Colors.orange
                                : Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        )),
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

  // south
  Widget _southTab() {
    List<ListChartItems> chartItemsModelList = <ListChartItems>[
      ListChartItems(
          name: widget.translate == "hi" ? "सूर्य \nचार्ट" : "Sun \nChart",
          types: "SUN",
          image: "assets/images/kundli_chart_images/Sun_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Sun_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "चंद्र \nचार्ट" : "Moon \nChart",
          types: "MOON",
          image: "assets/images/kundli_chart_images/Moon_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Moon_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "जन्म \nचार्ट" : "Birth \nChart",
          types: "D1",
          image: "assets/images/kundli_chart_images/Birth_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Birth_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "होरा \nचार्ट" : "Hora \nChart",
          types: "D2",
          image: "assets/images/kundli_chart_images/Hora_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Hora_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "द्रेष्काण चार्ट" : "Dreshkan Chart",
          types: "D3",
          image: "assets/images/kundli_chart_images/Dreshkan_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Dreshkan_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "चतुर्थांश चार्ट"
              : "Chathurthamasha Chart",
          types: "D4",
          image: "assets/images/kundli_chart_images/Chathurtha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Chathurtha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "पंचमांश चार्ट" : "Panchmansha Chart",
          types: "D5",
          image: "assets/images/kundli_chart_images/Panchmansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Panchmansha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "सप्तमांश चार्ट" : "Saptamansha Chart",
          types: "D7",
          image: "assets/images/kundli_chart_images/Saptamasha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Saptamasha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "अष्टमांश चार्ट" : "Ashtamansha Chart",
          types: "D8",
          image: "assets/images/kundli_chart_images/Ashtamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Ashtamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "नवमांश चार्ट" : "Navamansha Chart",
          types: "D9",
          image: "assets/images/kundli_chart_images/Navamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Navamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "द्वादशांश चार्ट"
              : "Dwadashamsha Chart",
          types: "D10",
          image: "assets/images/kundli_chart_images/Dwadashamsha_chart.png",
          gifImage: 'assets/images/kundli_chart_images/Dwadashamsha_chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "दशमांश चार्ट" : "Dashamansha Chart",
          types: "D12",
          image: "assets/images/kundli_chart_images/Dashmansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Dashmansha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "षोडशांश चार्ट" : "Shodashamsha Chart",
          types: "D16",
          image: "assets/images/kundli_chart_images/Shodashamsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Shodashamsha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "विषमांश चार्ट" : "Vishamansha Chart",
          types: "D20",
          image: "assets/images/kundli_chart_images/Vishamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Vishamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "चतुर्विम्शांश चार्ट"
              : "Chaturvimshamsha Chart",
          types: "D24",
          image: "assets/images/kundli_chart_images/Chaturvishamsha_Chart.png",
          gifImage:
              'assets/images/kundli_chart_images/Chaturvishamsha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi" ? "भाम्शा चार्ट" : "Bhamsha Chart",
          types: "D27",
          image: "assets/images/kundli_chart_images/Bhamsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Bhamsha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "त्रिशमांश चार्ट"
              : "Trishamansha Chart",
          types: "D30",
          image: "assets/images/kundli_chart_images/Trishamansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Trishamansha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "खवेड़मांश चार्ट"
              : "Khavedamsha Chart",
          types: "D40",
          image: "assets/images/kundli_chart_images/Khavedamsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Khavedamsha_Chart.gif'),
      ListChartItems(
          name: widget.translate == "hi"
              ? "अक्षवेदांश चार्ट"
              : "Akshvedansha Chart",
          types: "D45",
          image: "assets/images/kundli_chart_images/Akshvedansha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Akshvedansha_Chart.gif'),
      ListChartItems(
          name:
              widget.translate == "hi" ? "षष्ट्यंश चार्ट" : "Shashtymsha Chart",
          types: "D60",
          image: "assets/images/kundli_chart_images/Shashtymsha_Chart.png",
          gifImage: 'assets/images/kundli_chart_images/Shashtymsha_Chart.gif'),
    ];

    var webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00005600))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          '${northchartUrl}day=${widget.femaleDate.substring(0, 2)}&month=${widget.femaleDate.substring(3, 5)}&year=${widget.femaleDate.substring(6, 10)}&hour=${widget.femaleTime.substring(0, 2)}&min=${widget.femaleTime.substring(3, 5)}&lat=${widget.femaleLati}&lon=${widget.femaleLongi}&tzone=5.5&type=$femaleChartData'));
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
              child: SizedBox(
                  height: 400, child: WebViewWidget(controller: webController)),
            ),
          ],
        ),
        //  FloatingActionButton area
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 160,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: chartItemsModelList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      femaleSeletcColor = index;
                      femaleChartData = chartItemsModelList[index].types;
                    });
                    print("chartdata $femaleChartData");
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: femaleSeletcColor == index
                            ? Colors.orange.shade100
                            : Colors.white,
                        border: Border.all(
                            color: Colors.grey.shade300, width: 1.5)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 3.0,
                        ),
                        Container(
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
                            child: femaleSeletcColor == index
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      chartItemsModelList[index].gifImage,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.asset(
                                      chartItemsModelList[index].image,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        const SizedBox(
                          height: 0.5,
                        ),
                        Center(
                            child: Text(
                          chartItemsModelList[index].name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: femaleSeletcColor == index
                                ? Colors.orange
                                : Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        )),
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
}

class ListChartItems {
  final String name;
  final String types;
  final String image;
  final String gifImage;
  ListChartItems({
    required this.name,
    required this.types,
    required this.image,
    required this.gifImage,
  });
}
