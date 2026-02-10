import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../main.dart';
import '../../../profile/controllers/profile_contrroller.dart';
import '../../models/vimshottarimaha_model.dart';

class DashaView extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final String country;
  final String city;
  final String lati;
  final String longi;
  final String translate;
  final double fontSizeDefault;
  final VimshotriDashaModel? vimshotriData;
  const DashaView({
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
    required this.vimshotriData,
  });

  @override
  State<DashaView> createState() => _DashaViewState();
}

class _DashaViewState extends State<DashaView> {
// Vimshottari data
//   String vimshottariPlanet1 = "";
//   String vimshottariPlanet2 = "";
//   String vimshottariPlanet3 = "";
//   String vimshottariPlanet4 = "";
//   String vimshottariPlanet5 = "";
//   String vimshottariStart1 = "";
//   String vimshottariStart2 = "";
//   String vimshottariStart3 = "";
//   String vimshottariStart4 = "";
//   String vimshottariStart5 = "";
//   String vimshottariEnd1 = "";
//   String vimshottariEnd2 = "";
//   String vimshottariEnd3 = "";
//   String vimshottariEnd4 = "";
//   String vimshottariEnd5 = "";
  // List<VimshotariMahaModel> mahaVimshottariModelList = <VimshotariMahaModel>[];

  // yogini data
  // String yoginiPlanet1 = "";
  // String yoginiPlanet2 = "";
  // String yoginiPlanet3 = "";
  // String yoginiStart1 = "";
  // String yoginiStart2 = "";
  // String yoginiStart3 = "";
  // String yoginiEnd1 = "";
  // String yoginiEnd2 = "";
  // String yoginiEnd3 = "";
  // String yoginiStatus = "";
  // String yoginiMsg = "";
  String userId = "";
  // List<YoginiMahaModel> mahaYoginiModelList = <YoginiMahaModel>[];

  @override
  void initState() {
    super.initState();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    // getKundliDashaPage();
  }

  // void getKundliDashaPage() async{
  //   var res =  await HttpService().postApi(AppConstants.kundliURL,{
  //     "user_id": userId,
  //     "device_id":"123",
  //     "name": widget.name,
  //     "date": widget.date,
  //     "time":widget.time,
  //     "country":widget.country,
  //     "city":widget.city,
  //     "latitude":widget.lati,
  //     "longitude":widget.longi,
  //     "language": widget.translate,
  //     "timezone":"5.5",
  //     "tab" : "dasha"
  //   });
  //   setState(() {
  //     if(res['status'] == 200){
  //       // Planet data
  //       vimshottariPlanet1 = res['vimshottariDasha']['major']['planet'].toString();
  //       vimshottariPlanet2 = res['vimshottariDasha']['minor']['planet'].toString();
  //       vimshottariPlanet3 = res['vimshottariDasha']['sub_minor']['planet'].toString();
  //       vimshottariPlanet4 = res['vimshottariDasha']['sub_sub_minor']['planet'].toString();
  //       vimshottariPlanet5 = res['vimshottariDasha']['sub_sub_sub_minor']['planet'].toString();
  //
  //       // start time data
  //       vimshottariStart1 = res['vimshottariDasha']['major']['start'].toString();
  //       vimshottariStart2 = res['vimshottariDasha']['minor']['start'].toString();
  //       vimshottariStart3 = res['vimshottariDasha']['sub_minor']['start'].toString();
  //       vimshottariStart4 = res['vimshottariDasha']['sub_sub_minor']['start'].toString();
  //       vimshottariStart5 = res['vimshottariDasha']['sub_sub_sub_minor']['start'].toString();
  //
  //       // start time data
  //       vimshottariEnd1 = res['vimshottariDasha']['major']['end'].toString();
  //       vimshottariEnd2 = res['vimshottariDasha']['minor']['end'].toString();
  //       vimshottariEnd3 = res['vimshottariDasha']['sub_minor']['end'].toString();
  //       vimshottariEnd4 = res['vimshottariDasha']['sub_sub_minor']['end'].toString();
  //       vimshottariEnd5 = res['vimshottariDasha']['sub_sub_sub_minor']['end'].toString();
  //
  //       List vimshottariList = res['mahaVimshottari'];
  //       // mahaVimshottariModelList.addAll(vimshottariList.map((e) => VimshotariMahaModel.fromJson(e)));
  //
  //       // yogini data
  //       yoginiStatus = res['yoginiDasha']['status'].toString();
  //       yoginiMsg = res['yoginiDasha']['msg'].toString();
  //       // Planet data
  //       yoginiPlanet1 = res['yoginiDasha']['major_dasha']['dasha_name'].toString();
  //       yoginiPlanet2 = res['yoginiDasha']['sub_dasha']['dasha_name'].toString();
  //       yoginiPlanet3 = res['yoginiDasha']['sub_sub_dasha']['dasha_name'].toString();
  //       // start time data
  //       yoginiStart1 = res['yoginiDasha']['major_dasha']['start_date'].toString();
  //       yoginiStart2 = res['yoginiDasha']['sub_dasha']['start_date'].toString();
  //       yoginiStart3 = res['yoginiDasha']['sub_sub_dasha']['start_date'].toString();
  //       // start time data
  //       yoginiEnd1 = res['yoginiDasha']['major_dasha']['end_date'].toString();
  //       yoginiEnd2 = res['yoginiDasha']['sub_dasha']['end_date'].toString();
  //       yoginiEnd3 = res['yoginiDasha']['sub_sub_dasha']['end_date'].toString();
  //
  //       List yoginiList = res['majorYoginiDasha'];
  //       mahaYoginiModelList.addAll(yoginiList.map((e) => YoginiMahaModel.fromJson(e)));
  //
  //     }else{
  //     }
  //
  //   });
  // }

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
                    widget.translate == "hi" ? "विंशोत्तरी" : "vimshotri",
                  ),
                ),
                Tab(
                  child: Text(
                    widget.translate == "hi" ? "योगिनी" : "Yogini",
                  ),
                ),
              ],
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto-Regular',
                  letterSpacing: 0.5),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Roboto-Regular',
                  letterSpacing: 0.5),
            ),
            Expanded(
              child: widget.vimshotriData!.vimshottariDasha.major.planet.isEmpty
                  ? Container(
                      color: Colors.white,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: Colors.orange,
                      )))
                  : TabBarView(
                      children: [
                        _buildTab1Content(),
                        _buildTab2Content(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab1Content() {
    // Example content for Tab 1
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Text(
                        "${widget.vimshotriData?.vimshottariDasha.major.planet}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.fontSizeDefault),
                      )),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.translate == "hi" ? "महादशा" : "Mahadasha",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSizeDefault),
                        ),
                        Text(
                          "${widget.vimshotriData?.vimshottariDasha.major.start} - ${widget.vimshotriData?.vimshottariDasha.major.end}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Text(
                        "${widget.vimshotriData?.vimshottariDasha.minor.planet}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.fontSizeDefault),
                      )),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.translate == "hi" ? "अंतर दशा" : "Antar Dasha",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSizeDefault),
                        ),
                        Text(
                          "${widget.vimshotriData?.vimshottariDasha.major.start} - ${widget.vimshotriData?.vimshottariDasha.minor.end}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Text(
                        "${widget.vimshotriData?.vimshottariDasha.subMinor.planet}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.fontSizeDefault),
                      )),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.translate == "hi"
                              ? "प्रत्यान्तर दशा"
                              : "Pratyantar Dasha",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSizeDefault),
                        ),
                        Text(
                          "${widget.vimshotriData?.vimshottariDasha.subMinor.start} - ${widget.vimshotriData?.vimshottariDasha.subMinor.end}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Text(
                        "${widget.vimshotriData?.vimshottariDasha.subSubMinor.planet}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.fontSizeDefault),
                      )),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.translate == "hi"
                              ? "सूक्ष्म दशा"
                              : "Sookshma Dasha",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSizeDefault),
                        ),
                        Text(
                          "${widget.vimshotriData?.vimshottariDasha.subSubMinor.start} - ${widget.vimshotriData?.vimshottariDasha.subSubMinor.end}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                          child: Text(
                        "${widget.vimshotriData?.vimshottariDasha.subSubSubMinor.planet}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.fontSizeDefault),
                      )),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.translate == "hi" ? "प्राण दशा" : "Pran Dasha",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.fontSizeDefault),
                        ),
                        Text(
                          "${widget.vimshotriData?.vimshottariDasha.subSubSubMinor.start} - ${widget.vimshotriData?.vimshottariDasha.subSubSubMinor.end}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 1.5),
                borderRadius: BorderRadius.circular(8.0),
                image: const DecorationImage(
                    image: AssetImage("assets/images/framebg.png")),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              border: Border.all(color: Colors.orange),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(7.0))),
                          child: Center(
                              child: Text(
                            widget.translate == "hi" ? "ग्रह" : "Planet",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              border: Border.all(color: Colors.orange)),
                          child: Center(
                              child: Text(
                            widget.translate == "hi"
                                ? "आरंभ तिथि"
                                : "Start date",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              border: Border.all(color: Colors.orange),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(7.0))),
                          child: Center(
                              child: Text(
                            widget.translate == "hi"
                                ? "समापन तिथि"
                                : "End Date",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.vimshotriData?.mahaVimshottari
                        .length, // Number of items in the list
                    itemBuilder: (BuildContext context, int index) {
                      final mahaVimshottariModelList =
                          widget.vimshotriData?.mahaVimshottari;
                      // itemBuilder function returns a widget for each item in the list
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Center(
                                  child: Text(
                                mahaVimshottariModelList![index].planet,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(color: Colors.grey)),
                              ),
                              child: Center(
                                  child: Text(
                                mahaVimshottariModelList[index].start,
                                style: const TextStyle(fontSize: 12),
                              )),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Center(
                                  child: Text(
                                mahaVimshottariModelList[index].end,
                                style: const TextStyle(fontSize: 12),
                              )),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab2Content() {
    // Example content for Tab 2
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                        child: Text(
                      "${widget.vimshotriData?.yoginiDasha.majorDasha.dashaName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSizeDefault),
                    )),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.translate == "hi" ? "महादशा" : "Mahadasha",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.fontSizeDefault),
                      ),
                      Text(
                        "${widget.vimshotriData?.yoginiDasha.majorDasha.startDate} - ${widget.vimshotriData?.yoginiDasha.majorDasha.endDate}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                        child: Text(
                      "${widget.vimshotriData?.yoginiDasha.subDasha.dashaName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSizeDefault),
                    )),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.translate == "hi" ? "अंतर दशा" : "Antar Dasha",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.fontSizeDefault),
                      ),
                      Text(
                        "${widget.vimshotriData?.yoginiDasha.subDasha.startDate} - ${widget.vimshotriData?.yoginiDasha.subDasha.endDate}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                        child: Text(
                      "${widget.vimshotriData?.yoginiDasha.subSubDasha.dashaName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSizeDefault),
                    )),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.translate == "hi"
                            ? "प्रत्यान्तर दशा"
                            : "Pratyantar Dasha",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.fontSizeDefault),
                      ),
                      Text(
                        "${widget.vimshotriData?.yoginiDasha.subSubDasha.startDate} - ${widget.vimshotriData?.yoginiDasha.subSubDasha.endDate}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 1.5),
              borderRadius: BorderRadius.circular(8.0),
              image: const DecorationImage(
                  image: AssetImage("assets/images/framebg.png")),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.cyan.shade50,
                            border: Border.all(color: Colors.orange),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(7.0))),
                        child: Center(
                            child: Text(
                          widget.translate == "hi" ? "ग्रह" : "Planet",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.orange)),
                        child: Center(
                            child: Text(
                          widget.translate == "hi" ? "आरंभ तिथि" : "Start date",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Center(
                            child: Text(
                          widget.translate == "hi" ? "समापन तिथि" : "End Date",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.orange),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(7.0))),
                        child: Center(
                            child: Text(
                          widget.translate == "hi" ? "वर्ष" : "Year",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.vimshotriData?.majorYoginiDasha
                      .length, // Number of items in the list
                  itemBuilder: (BuildContext context, int index) {
                    final mahaYoginiModelList =
                        widget.vimshotriData?.majorYoginiDasha;
                    // itemBuilder function returns a widget for each item in the list
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Center(
                              child: Text(
                                mahaYoginiModelList![index].dashaName,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(color: Colors.grey)),
                            ),
                            child: Center(
                              child: Text(
                                " ${mahaYoginiModelList[index].startDate}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Center(
                              child: Text(
                                " ${mahaYoginiModelList[index].endDate}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Center(
                              child: Text(
                                "${mahaYoginiModelList[index].duration} Year",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
