import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../models/dosh_model.dart';

class DoshView extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final String country;
  final String city;
  final String lati;
  final String longi;
  final String translate;
  final double fontSizeDefault;
  final DoshModel? doshData;
  const DoshView({
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
    required this.doshData,
  });

  @override
  State<DoshView> createState() => _DoshViewState();
}

class _DoshViewState extends State<DoshView> {
  @override
  void initState() {
    super.initState();
  }
  //Manglik data
  // List manglikBased_on_aspect = [];
  // List manglikBased_on_house = [];
  // String manglikStatus = "";
  // String manglikPercent = "";
  // String manglikReport = "";
  // //Kalsarp dosh
  // String kaalSarpDoshline = "";
  // String kaalSarpName = "";
  // String kaalSarpReport = "";
  // String kaalSarptrue = "";
  // // Pitr dosh data
  // String pitrConclusion = "";
  // String pitrmessage = "";
  // String pitrtrue = "";
  // List pitrRulesMatched = [];
  // List pitrRemedies = [];
  // List pitrEffects = [];
  // //sadesati data
  // String sadesatiDate = "";
  // String sadesatiStartDate = "";
  // String sadesatiEndDate = "";
  // String sadesatiMessage = "";
  // String sadesatiReport = "";
  // String sadesatiMoon = "";
  // String sadesatiSaturn = "";
  // String sadesatiRetrograde = "";
  // String userId = "";

  // void getDoshPage() async {
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
  //     "tab" : "dosh",
  //   });
  //   print(res);
  //   setState(() {
  //     //ratna data
  //     if (res['status'] == 200) {
  //       // manglik dosh data
  //       manglikBased_on_aspect = res['mangalDosh']['manglik_present_rule']['based_on_aspect'];
  //       manglikBased_on_house = res['mangalDosh']['manglik_present_rule']['based_on_house'];
  //       manglikStatus = res['mangalDosh']['manglik_status'].toString();
  //       manglikPercent = res['mangalDosh']['percentage_manglik_present'].toString();
  //       manglikReport = res['mangalDosh']['manglik_report'].toString();
  //
  //       // kalsarp dosh data
  //       if(res['kalsarpDosha']['present']){
  //         kaalSarpName = res['kalsarpDosha']['type'].toString();
  //         kaalSarptrue = res['kalsarpDosha']['present'].toString();
  //         kaalSarpDoshline = res['kalsarpDosha']['one_line'].toString();
  //         kaalSarpReport = res['kalsarpDosha']['report']['report'].toString();
  //       }else{
  //         kaalSarpName = "---Not Available---";
  //         kaalSarptrue = res['kalsarpDosha']['present'].toString();
  //         kaalSarpDoshline = res['kalsarpDosha']['one_line'].toString();
  //         kaalSarpReport = "---Not Available---";
  //       }
  //
  //       //Pitr dosh data
  //       if(res['pitraDosh']['is_pitri_dosha_present']){
  //         pitrConclusion = res['pitraDosh']['conclusion'].toString();
  //         pitrmessage = res['pitraDosh']['what_is_pitri_dosha'].toString();
  //         pitrtrue = res['pitraDosh']['is_pitri_dosha_present'].toString();
  //         pitrRulesMatched = res['pitraDosh']['rules_matched'];
  //         pitrRemedies = res['pitraDosh']['remedies'];
  //         pitrEffects = res['pitraDosh']['effects'];
  //       }else{
  //         pitrConclusion = res['pitraDosh']['conclusion'].toString();
  //         pitrmessage = res['pitraDosh']['what_is_pitri_dosha'].toString();
  //         pitrtrue = res['pitraDosh']['is_pitri_dosha_present'].toString();
  //         pitrRulesMatched = ["---Not Available---"];
  //         pitrRemedies = ["–––Not Available---"];
  //         pitrEffects = ["---Not Available---"];
  //       }
  //
  //       // SadeSati dosh data
  //       sadesatiDate = res['sadhesatiShani']['consideration_date'].toString();
  //       sadesatiStartDate = res['sadhesatiShani']['start_date'].toString();
  //       sadesatiEndDate = res['sadhesatiShani']['end_date'].toString();
  //       sadesatiMessage = res['sadhesatiShani']['what_is_sadhesati'].toString();
  //       sadesatiReport = res['sadhesatiShani']['is_undergoing_sadhesati'].toString();
  //       sadesatiMoon = res['sadhesatiShani']['moon_sign'].toString();
  //       sadesatiSaturn = res['sadhesatiShani']['saturn_sign'].toString();
  //       sadesatiRetrograde = res['sadhesatiShani']['is_saturn_retrograde'].toString();
  //
  //       print(res);
  //     } else {
  //       print("Api response failled");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    tabs: [
                      Tab(
                          text: widget.translate == "hi"
                              ? "मंगलिक दोष"
                              : "Manglik Dosh"),
                      Tab(
                          text: widget.translate == "hi"
                              ? "कालसर्प दोष"
                              : "Kalsarpa Dosh"),
                      Tab(
                          text: widget.translate == "hi"
                              ? "पितृ दोष"
                              : "Pitr Dosh"),
                      Tab(
                          text: widget.translate == "hi"
                              ? "साडेसाती दोष"
                              : "Sadesati Dosh"),
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
                        fontFamily: 'Roboto',
                        letterSpacing: 0.30),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Roboto-Regular',
                      letterSpacing: 0.30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: widget.doshData!.mangalDosh!.manglikStatus!.isEmpty
                  ? Container(
                      color: Colors.white,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: Colors.orange,
                      )))
                  : TabBarView(
                      children: [
                        _manglikContent(),
                        _kalsarpaContent(),
                        _pitrContent(),
                        _sadesatiContent(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Manglik Dosh tab
  Widget _manglikContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.translate == "hi"
                          ? "मांगलिक दोष प्रतिशत :" // Hindi for "Manglik Dosh Percentage :"
                          : "Manglik Dosh Percentage :", // English version
                      style: TextStyle(
                        fontSize: widget
                            .fontSizeDefault, // Using the font size from the widget
                      ),
                    ),
                    Text(
                      " ${widget.doshData?.mangalDosh?.percentageManglikPresent}",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSizeDefault),
                    ),
                  ],
                )),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  widget.translate == "hi"
                      ? "जन्म कुंडली ग्रह भाव पर आधारित" // Hindi for "Based on Birth Chart Planet Houses"
                      : "Based on Birth Chart Planet Houses", // English version
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: widget
                        .fontSizeDefault, // Using the font size from the widget
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.doshData?.mangalDosh?.manglikPresentRule
                  ?.basedOnAspect?.length, // Number of items in the list
              itemBuilder: (BuildContext context, int index) {
                // itemBuilder function returns a widget for each item in the list
                return Text(
                  "${widget.doshData?.mangalDosh?.manglikPresentRule!.basedOnAspect?[index]}",
                  style: TextStyle(fontSize: widget.fontSizeDefault),
                );
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  widget.translate == "hi"
                      ? "जन्म कुंडली ग्रह दृष्टि पर आधारित" // Hindi for "Based on Birth Chart Planet Aspects"
                      : "Based on Birth Chart Planet Aspects", // English version
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Text color set to red
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.doshData?.mangalDosh?.manglikPresentRule
                  ?.basedOnHouse?.length, // Number of items in the list
              itemBuilder: (BuildContext context, int index) {
                // itemBuilder function returns a widget for each item in the list
                return Text(
                  "${widget.doshData?.mangalDosh?.manglikPresentRule?.basedOnHouse?[index]}",
                  style: TextStyle(fontSize: widget.fontSizeDefault),
                );
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Center(
                  child: Text(
                    widget.translate == "hi"
                        ? "मांगलिक विश्लेषण" // Hindi for "Manglik Analysis"
                        : "Manglik Analysis", // English version
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange, // Text color set to orange
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${widget.doshData?.mangalDosh?.manglikReport}",
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: [
                    Text(
                      widget.translate == "hi"
                          ? "मांगलिक प्रभाव" // Hindi for "Manglik Effect"
                          : "Manglik Effect", // English version
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Text color set to green
                        fontSize: widget
                            .fontSizeDefault, // Using the font size from the widget
                      ),
                    ),
                    Text(
                      "${widget.doshData?.mangalDosh?.manglikStatus}",
                      style: TextStyle(fontSize: widget.fontSizeDefault),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Kalsarpa Dosh tab
  Widget _kalsarpaContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Image.network("https://www.jagranimages.com/images/newimg/27052023/27_05_2023-kaal_sarp_dosh_upay_23424658.jpg",height: 80,width: 120,fit: BoxFit.cover),
            // ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "आपकी कुंडली में कालसर्प दोष है ? :" // Hindi for "Is there Kalsarpa Dosh in your horoscope?"
                        : "Is there Kalsarpa Dosh in your horoscope?", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                    ),
                  ),
                  Text(
                    widget.doshData?.kalsarpDosha?.present == true
                        ? " हां"
                        : " नहीं",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: widget.fontSizeDefault),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              widget.translate == "hi"
                  ? "कालसर्प प्रकार" // Hindi for "Kalsarpa Type"
                  : "Kalsarpa Type", // English version
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold text
                fontSize: widget
                    .fontSizeDefault, // Using the font size from the widget
                color: Colors.green, // Text color set to green
              ),
            ),
            Center(
              child: widget.doshData?.kalsarpDosha?.present == true
                  ? Text("${widget.doshData!.kalsarpDosha?.name}")
                  : Text(
                      "-- Not Available --",
                      style: TextStyle(
                          fontSize: widget.fontSizeDefault, color: Colors.red),
                    ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "विवरण" // Hindi for "Details"
                        : "Details", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                      color: Colors.green, // Text color set to green
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${widget.doshData?.kalsarpDosha?.oneLine}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.fontSizeDefault),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
            ),
            widget.doshData?.kalsarpDosha?.present == true
                ? Text(
                    widget.translate == "hi"
                        ? "विश्लेषण" // Hindi for "Analysis"
                        : "Analysis", // English version
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: widget.fontSizeDefault),
                  )
                : const SizedBox.shrink(),

            widget.doshData?.kalsarpDosha?.present == true
                ? Html(
                    data: "${widget.doshData?.kalsarpDosha?.report}",
                    style: {
                      "p": Style(
                        fontSize: FontSize(widget.fontSizeDefault),
                      ),
                    },
                  )
                : const SizedBox.shrink(),
            // Text("${widget.doshData?.kalsarpDosha?.report}",style: TextStyle(
            //     fontSize: widget.doshData?.kalsarpDosha?.present == true ? 14 : 12,
            //     fontWeight: FontWeight.bold,
            //     color: widget.doshData?.kalsarpDosha?.present == true ? Colors.black : Colors.red
            // ),),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  // Pitr Dosh tab
  Widget _pitrContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "क्या आपकी कुंडली में पित्र दोष है ? :" // Hindi for "Is there Pitr Dosh in your horoscope?"
                        : "Is there Pitr Dosh in your horoscope?", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                    ),
                  ),
                  Text(
                    widget.doshData?.pitraDosh?.isPitriDoshaPresent == "true"
                        ? " हां"
                        : " नहीं",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: widget.fontSizeDefault),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "पित्र दोष क्या है?" // Hindi for "What is Pitr Dosh?"
                        : "What is Pitr Dosh?", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                      color: Colors.blue, // Text color set to blue
                    ),
                  ),
                  Text(
                    "${widget.doshData?.pitraDosh?.whatIsPitriDosha}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.fontSizeDefault),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "निष्कर्ष" // Hindi for "Conclusion"
                        : "Conclusion", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                      color: Colors.blue, // Text color set to blue
                    ),
                  ),
                  Text(
                    "${widget.doshData?.pitraDosh?.conclusion}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.fontSizeDefault),
                  ),
                ],
              ),
            ),
            widget.doshData?.pitraDosh?.isPitriDoshaPresent == false
                ? const SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.translate == "hi"
                              ? "पित्र दोष के परिणाम" // Hindi for "Results of Pitr Dosh"
                              : "Results of Pitr Dosh", // English version
                          textAlign: TextAlign.center, // Center align the text
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Bold text
                            fontSize: widget
                                .fontSizeDefault, // Using the font size from the widget
                            color: Colors.blue, // Text color set to blue
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.doshData?.pitraDosh?.effects
                              ?.length, // Number of items in the list
                          itemBuilder: (BuildContext context, int index) {
                            // itemBuilder function returns a widget for each item in the list
                            return Text(
                                "${widget.doshData?.pitraDosh?.effects?[index]}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: widget.fontSizeDefault,
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
            widget.doshData?.pitraDosh?.isPitriDoshaPresent == false
                ? const SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.translate == "hi"
                              ? "पित्र दोष के उपाय" // Hindi for "Remedies for Pitr Dosh"
                              : "Remedies for Pitr Dosh", // English version
                          textAlign: TextAlign.center, // Center align the text
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, // Bold text
                            fontSize: 16, // Fixed font size
                            color: Colors.blue, // Text color set to blue
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.doshData?.pitraDosh?.remedies
                              ?.length, // Number of items in the list
                          itemBuilder: (BuildContext context, int index) {
                            // itemBuilder function returns a widget for each item in the list
                            return Text(
                              "${widget.doshData?.pitraDosh?.remedies?[index]}",
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(fontSize: widget.fontSizeDefault),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Sadesati Dosh tab
  Widget _sadesatiContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.translate == "hi"
                  ? "निष्कर्ष" // Hindi for "Conclusion"
                  : "Conclusion", // English version
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold text
                fontSize: widget
                    .fontSizeDefault, // Using the font size from the widget
                color: Colors.red, // Text color set to red
              ),
            ),
            Text(
              "${widget.doshData?.sadhesatiShani?.isUndergoingSadhesati}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "साढ़े साती दोष क्या है?" // Hindi for "What is Sade Sati Dosh?"
                        : "What is Sade Sati Dosh?", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                    ),
                  ),
                  Text(
                    "${widget.doshData?.sadhesatiShani?.whatIsSadhesati}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.fontSizeDefault),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.translate == "hi"
                  ? "साढ़े साती वरण" // Hindi for "Sade Sati Selection"
                  : "Sade Sati Selection", // English version
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold text
                fontSize: widget
                    .fontSizeDefault, // Using the font size from the widget
                color: Colors.red, // Text color set to red
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "क्या शनि वक्री है ? :" // Hindi for "Is Saturn Retrograde?"
                        : "Is Saturn Retrograde?", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                    ),
                  ),
                  Text(
                    widget.doshData?.sadhesatiShani?.isSaturnRetrograde ==
                            "true"
                        ? " हां"
                        : " नहीं",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: widget.fontSizeDefault,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.translate == "hi"
                        ? "विचार तिथि :" // Hindi for "Consideration Date:"
                        : "Consideration Date:", // English version
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontSize: widget
                          .fontSizeDefault, // Using the font size from the widget
                    ),
                  ),
                  Text(
                    " ${widget.doshData?.sadhesatiShani?.considerationDate}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: widget.fontSizeDefault,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.translate == "hi"
                              ? "चंद्र राशि :" // Hindi for "Moon Sign:"
                              : "Moon Sign:", // English version
                          textAlign: TextAlign.center, // Center align the text
                          style: const TextStyle(
                            fontSize: 14, // Fixed font size of 14
                          ),
                        ),
                        Text(
                          " ${widget.doshData?.sadhesatiShani?.moonSign}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget.fontSizeDefault,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.translate == "hi"
                              ? "शनि राशि :" // Hindi for "Saturn Sign:"
                              : "Saturn Sign:", // English version
                          textAlign: TextAlign.center, // Center align the text
                          style: const TextStyle(
                            fontSize: 14, // Fixed font size of 14
                          ),
                        ),
                        Text(
                          " ${widget.doshData?.sadhesatiShani?.saturnSign}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget.fontSizeDefault,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
