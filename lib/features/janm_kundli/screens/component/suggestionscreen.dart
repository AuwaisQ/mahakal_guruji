import 'package:flutter/material.dart';
import 'package:mahakal/features/janm_kundli/models/suggestion_model.dart';

class SuggestionView extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final String country;
  final String city;
  final String lati;
  final String longi;
  final String translate;
  final double fontSizeDefault;
  final SuggestionModel? suggestionData;
  const SuggestionView({
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
    required this.suggestionData,
  });

  @override
  State<SuggestionView> createState() => _SuggestionViewState();
}

class _SuggestionViewState extends State<SuggestionView> {
  //ratna suggestion data life gems
  // String lifeGemsName = "";
  // String lifeGemsFinger = "";
  // String lifeGemsWeight = "";
  // String lifeGemsDay = "";
  // String lifeGemsDeity = "";
  // String lifeGemsMetal = "";
  // //ratna suggestion data benefic gems
  // String beneficGemsName = "";
  // String beneficGemsFinger = "";
  // String beneficGemsWeight = "";
  // String beneficGemsDay = "";
  // String beneficGemsDeity = "";
  // String beneficGemsMetal = "";
  // //ratna suggestion data lucky gems
  // String luckyGemsName = "";
  // String luckyGemsFinger = "";
  // String luckyGemsWeight = "";
  // String luckyGemsDay = "";
  // String luckyGemsDeity = "";
  // String luckyGemsMetal = "";
  // // rudraksha data
  // String rudrakshaImage = "";
  // String rudrakshaName = "";
  // String rudrakshaRecommend = "";
  // String rudrakshaDetail = "";
  // // pooja
  // String poojaSummary = "";
  // List<PoojasuggestionModel> poojaSugges = <PoojasuggestionModel>[];

  int screenCount = 0;
  String translateEn = 'hi';
  @override
  void initState() {
    super.initState();
  }

  // void getRudrakshPooja() async {
  //   var res = await HttpService().postApi(AppConstants.kundliURL, {
  //     "user_id": userId,
  //     "device_id":"123",
  //     "name":widget.name,
  //     "date": widget.date,
  //     "time":widget.time,
  //     "country":widget.country,
  //     "city":widget.city,
  //     "latitude":widget.lati,
  //     "longitude":widget.longi,
  //     "language": widget.translate,
  //     "timezone":"5.5",
  //     "tab" : "suggestion"
  //   });
  //   setState(() {
  //     //Rudraksh data
  //     if(res['status'] == 200){
  //
  //       rudrakshaImage = res['rudrakshaSuggestion']['img_url'].toString();
  //       rudrakshaName = res['rudrakshaSuggestion']['name'].toString();
  //       rudrakshaRecommend = res['rudrakshaSuggestion']['recommend'].toString();
  //       rudrakshaDetail = res['rudrakshaSuggestion']['detail'].toString();
  //
  //       poojaSummary = res['poojaSuggestion']['summary'].toString();
  //       poojaSugges = res['poojaSuggestion']['suggestions'];
  //     }else{
  //     }
  //   });
  //
  // }
  //
  // void getKundliGems() async {
  //   var res = await HttpService().postApi(AppConstants.kundliURL, {
  //     "user_id": userId,
  //     "device_id":"123",
  //     "name":widget.name,
  //     "date": widget.date,
  //     "time":widget.time,
  //     "country":widget.country,
  //     "city":widget.city,
  //     "latitude":widget.lati,
  //     "longitude":widget.longi,
  //     "language": widget.translate,
  //     "timezone":"5.5",
  //     "tab" : "suggestion"
  //   });
  //   setState(() {
  //     //ratna data
  //     if (res['status'] == 200) {
  //       // life data
  //       lifeGemsName = res['gemStone']['LIFE']['name'].toString();
  //       lifeGemsFinger = res['gemStone']['LIFE']['wear_finger'].toString();
  //       lifeGemsWeight = res['gemStone']['LIFE']['weight_caret'].toString();
  //       lifeGemsDay = res['gemStone']['LIFE']['wear_day'].toString();
  //       lifeGemsDeity = res['gemStone']['LIFE']['gem_deity'].toString();
  //       lifeGemsMetal = res['gemStone']['LIFE']['wear_metal'].toString();
  //       // benefic data
  //       beneficGemsName = res['gemStone']['BENEFIC']['name'].toString();
  //       beneficGemsFinger =
  //           res['gemStone']['BENEFIC']['wear_finger'].toString();
  //       beneficGemsWeight =
  //           res['gemStone']['BENEFIC']['weight_caret'].toString();
  //       beneficGemsDay = res['gemStone']['BENEFIC']['wear_day'].toString();
  //       beneficGemsDeity = res['gemStone']['BENEFIC']['gem_deity'].toString();
  //       beneficGemsMetal =
  //           res['gemStone']['BENEFIC']['wear_metal'].toString();
  //       // lucky data
  //       luckyGemsName = res['gemStone']['LUCKY']['name'].toString();
  //       luckyGemsFinger = res['gemStone']['LUCKY']['wear_finger'].toString();
  //       luckyGemsWeight = res['gemStone']['LUCKY']['weight_caret'].toString();
  //       luckyGemsDay = res['gemStone']['LUCKY']['wear_day'].toString();
  //       luckyGemsDeity = res['gemStone']['LUCKY']['gem_deity'].toString();
  //       luckyGemsMetal = res['gemStone']['LUCKY']['wear_metal'].toString();
  //
  //     } else {
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                widget.suggestionData!.rudrakshaSuggestion.name.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.orange,
                      ))
                    : screenCount == 0
                        ? RudrakshScreen()
                        : screenCount == 1
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: RatnaSugges())
                            : screenCount == 2
                                ? PoojaSuggestion()
                                : const SizedBox(),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        screenCount = 0;
                      });
                    },
                    child: Container(
                      height: 150,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Colors.grey.shade400, width: 2)),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(7.0),
                                  topLeft: Radius.circular(7.0)),
                              child: Image.asset(
                                'assets/images/kundlirudraksha.jpg',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )),
                          const Spacer(),
                          Text(
                            translateEn == 'hi' ? 'रुद्राक्ष' : 'Rudraksh',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        screenCount = 1;
                      });
                    },
                    child: Container(
                      height: 150,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Colors.grey.shade400, width: 2)),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(7.0),
                                  topLeft: Radius.circular(7.0)),
                              child: Image.asset(
                                'assets/images/kundliratna.jpg',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )),
                          const Spacer(),
                          Text(
                            translateEn == 'hi'
                                ? 'रत्न' // Hindi for "Gemstone"
                                : 'Gemstone',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        screenCount = 2;
                      });
                    },
                    child: Container(
                      height: 150,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Colors.grey.shade400, width: 2)),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(7.0),
                                  topLeft: Radius.circular(7.0)),
                              child: Image.asset(
                                'assets/images/kundlipooja.png',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )),
                          const Spacer(),
                          Text(
                            translateEn == 'hi'
                                ? 'पूजा' // Hindi for "Pooja"
                                : 'Pooja',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget RatnaSugges() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SizedBox(height: 10.0), // Added SizedBox for spacing
          TabBar(
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
            tabs: [
              Tab(
                text: translateEn == 'hi'
                    ? 'जीवन रत्न' // Hindi for "Life Ratna"
                    : 'Life Ratna',
              ),
              Tab(
                text: translateEn == 'hi'
                    ? 'लाभ रत्न' // Hindi for "Profit Ratna"
                    : 'Profit Ratna',
              ),
              Tab(
                text: translateEn == 'hi'
                    ? 'भाग्य रत्न' // Hindi for "Fortune Ratna"
                    : 'Fortune Ratna',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://blog.brilliance.com/wp-content/uploads/2017/06/perfect-diamond-isolated-on-shiny-background.jpg',
                              fit: BoxFit.fill,
                            ))),
                    Text(
                      translateEn == 'hi'
                          ? 'हीरा' // Hindi for "Diamond"
                          : 'Diamond',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside: BorderSide(color: Colors.cyan),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(7.0),
                                    topLeft: Radius.circular(7.0))),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'वैकल्पिक' // Hindi for "Substitute"
                                      : 'Substitute',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.life
                                          .name, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'उंगली' // Hindi for "Finger"
                                      : 'Finger',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.life
                                          .wearFinger, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'वजन' // Hindi for "Weight"
                                      : 'Weight',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.life
                                          .weightCaret, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'दिन' // Hindi for "Day"
                                      : 'Day',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.life
                                          .wearDay, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'देवता' // Hindi for "Deity"
                                      : 'Deity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.life
                                          .gemDeity, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(7.0),
                                  bottomLeft: Radius.circular(7.0)),
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'धातु' // Hindi for "Metal"
                                      : 'Metal',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.life
                                          .wearMetal, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEHmTdlvOK1kDEOHR51zFqVO4mQlemylYl4uwJXsJr_w&s',
                              fit: BoxFit.fill,
                            ))),
                    Text(
                      translateEn == 'hi'
                          ? 'हीरा' // Hindi for "Diamond"
                          : 'Diamond',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside: BorderSide(color: Colors.cyan),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(7.0),
                                    topLeft: Radius.circular(7.0))),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'वैकल्पिक' // Hindi for "Substitute"
                                      : 'Substitute',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.benefic
                                          .name, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'उंगली' // Hindi for "Finger"
                                      : 'Finger',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.benefic
                                          .wearFinger, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'वजन' // Hindi for "Weight"
                                      : 'Weight',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.benefic
                                          .weightCaret, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'दिन' // Hindi for "Day"
                                      : 'Day',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.benefic
                                          .wearDay, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'देवता' // Hindi for "Deity"
                                      : 'Deity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.benefic
                                          .gemDeity, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(7.0),
                                  bottomLeft: Radius.circular(7.0)),
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'धातु' // Hindi for "Metal"
                                      : 'Metal',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.benefic
                                          .wearMetal, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://img1.exportersindia.com/product_images/bc-full/2021/7/8764740/green-diamond-1625890677-5814848.jpeg',
                              fit: BoxFit.fill,
                            ))),
                    Text(
                      translateEn == 'hi'
                          ? 'हीरा' // Hindi for "Diamond"
                          : 'Diamond',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      child: Table(
                        border: const TableBorder(
                          horizontalInside: BorderSide(color: Colors.cyan),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(7.0),
                                    topLeft: Radius.circular(7.0))),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'वैकल्पिक' // Hindi for "Substitute"
                                      : 'Substitute',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.lucky
                                          .name, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'उंगली' // Hindi for "Finger"
                                      : 'Finger',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.lucky
                                          .wearFinger, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'वजन' // Hindi for "Weight"
                                      : 'Weight',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.lucky
                                          .weightCaret, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'दिन' // Hindi for "Day"
                                      : 'Day',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.lucky
                                          .wearDay, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'देवता' // Hindi for "Deity"
                                      : 'Deity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.lucky
                                          .gemDeity, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(7.0),
                                  bottomLeft: Radius.circular(7.0)),
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Text(
                                  translateEn == 'hi'
                                      ? 'धातु' // Hindi for "Metal"
                                      : 'Metal',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 2,
                                    color: Colors.cyan,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    child: Text(
                                      widget.suggestionData!.gemStone.lucky
                                          .wearMetal, // Assuming you want to display this string.
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget RudrakshScreen() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            // child: Image.network("https://dev-mahakal.rizrv.in${rudrakshaImage}"),),
            child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqLtZalAz6VmhsVzCyO2GNcZ5oUOTgzA-HMA&s'),
          ),
          Text(
            widget.suggestionData!.rudrakshaSuggestion.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: widget.fontSizeDefault),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              widget.suggestionData!.rudrakshaSuggestion.recommend,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            widget.suggestionData!.rudrakshaSuggestion.detail,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: widget.fontSizeDefault),
          ),
          const SizedBox(
            height: 160,
          ),
        ],
      ),
    );
  }

  Widget PoojaSuggestion() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translateEn == 'hi'
                ? 'पूजा सुझाव' // Hindi for "Pooja Suggestion"
                : 'Pooja Suggestion',
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              widget.suggestionData!.poojaSuggestion.summary,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.suggestionData!.poojaSuggestion.suggestions
                .length, // Number of items in the list
            itemBuilder: (BuildContext context, int index) {
              // itemBuilder function returns a widget for each item in the list
              return Column(
                children: [
                  Text(widget.suggestionData!.poojaSuggestion.suggestions[index]
                      .title),
                  Text(widget.suggestionData!.poojaSuggestion.suggestions[index]
                      .summary),
                  Text(widget.suggestionData!.poojaSuggestion.suggestions[index]
                      .pujaId),
                  Text(widget.suggestionData!.poojaSuggestion.suggestions[index]
                      .oneLine),
                ],
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
