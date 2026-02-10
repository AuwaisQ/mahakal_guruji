import 'package:flutter/material.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartView extends StatefulWidget {
  final String translate;
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
  const ChartView(
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
      required this.longi,
      required this.translate});
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  void initState() {
    super.initState();
    print("date ${widget.day}");
    print("date ${widget.month}");
    print("date ${widget.year}");
    print("date ${widget.hour}");
    print("date ${widget.mint}");
    print("date ${widget.lati}");
    print("date ${widget.longi}");
  }

  int northSeletcColor = 2;
  int southSeletcColor = 2;
  String chartData = "D1";
  String northchartUrl = "${AppConstants.baseUrl}${AppConstants.northChartURL}";
  String southchartUrl = "${AppConstants.baseUrl}${AppConstants.southChartURL}";
  String? northChart;

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
                    widget.translate == "hi" ? "उत्तर भारतीय" : "North Indian",
                  ),
                ),
                Tab(
                  child: Text(
                    widget.translate == "hi" ? "दक्षिण भारतीय" : "South Indian",
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
          '${northchartUrl}day=${widget.day}&month=${widget.month}&year=${widget.year}&hour=${widget.hour}&min=${widget.mint}&lat=${widget.lati}&lon=${widget.longi}&tzone=5.5&type=$chartData'));
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
                      northSeletcColor = index;
                      chartData = chartItemsModelList[index].types;
                    });
                    print("chartdata $chartData");
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: northSeletcColor == index
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
                            child: northSeletcColor == index
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
                          height: 5.0,
                        ),
                        Center(
                            child: Text(
                          chartItemsModelList[index].name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: northSeletcColor == index
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
          '${southchartUrl}day=${widget.day}&month=${widget.month}&year=${widget.year}&hour=${widget.hour}&min=${widget.mint}&lat=${widget.lati}&lon=${widget.longi}&tzone=5.5&type=$chartData'));
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
                      southSeletcColor = index;
                      chartData = chartItemsModelList[index].types;
                    });
                    print("chartdata $chartData");
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: southSeletcColor == index
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
                            child: southSeletcColor == index
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
                          height: 5.0,
                        ),
                        Center(
                            child: Text(
                          chartItemsModelList[index].name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: southSeletcColor == index
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
