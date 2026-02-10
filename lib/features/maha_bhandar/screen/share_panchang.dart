import 'dart:convert';
import 'dart:ui';
import 'package:country_picker/country_picker.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mahakal/features/maha_bhandar/model/festival_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../utill/app_constants.dart';
import '../../profile/controllers/profile_contrroller.dart';
import '../controller/share_panchang_controller.dart';
import '../model/city_model.dart';
import '../model/shubh_muhrt_model.dart';
import '../model/today_muhurat_model.dart';

class SharePachangScreen extends StatefulWidget {
  final String formattedDate;
  final String day;
  final String month;
  final String year;
  final String late;
  final String long;
  final String location;
  final List<FestivalModel> fastData;
  final List<FestivalModel> festivalData;
  final List<Muhurat> muhuratModelList;

  const SharePachangScreen({
    required this.formattedDate,
    super.key,
    required this.day,
    required this.month,
    required this.year,
    required this.fastData,
    required this.festivalData,
    required this.muhuratModelList,
    required this.late,
    required this.long,
    required this.location,
  });

  @override
  State<SharePachangScreen> createState() => _SharePachangScreenState();
}

class _SharePachangScreenState extends State<SharePachangScreen> {
  final sharePanchang = SharePachangController();

  DateTime now = DateTime.now();
  DateTime todayDate = DateTime.now();
  int dainikCount = 0;
  bool shimmerscreenDate = false;
  bool isMasikDialog = false;
  bool isTranslate = false;
  String latitude = "23.1765";
  String longitude = "75.7885";
  String tithiName = "";
  String tithiEndTime = "";
  String sunrise = "";
  String sunset = "";
  String moonrise = "";
  String moonSet = "";
  String hinduMonthName = "";
  String season = "";
  String vikramSamvatName = "";
  String day = "";
  String special = "";
  String nakshatraName = "";
  String nakshatraTime = "";
  String yogaName = "";
  String yogaTime = "";
  String karanaName = "";
  String karanaTime = "";
  String monthAmanta = "";
  String monthPurnima = "";
  String shakaSamvatName = "";
  String shakaSamvatTime = "";
  String sunSign = "";
  String moonSign = "";
  String dishaShool = "";
  String moonPlacement = "";
  String ayana = "";
  String auspiciousStartTime = "";
  String auspiciousEndTime = "";
  String gulikStartTime = "";
  String gulikEndTime = "";
  String rahuStartTime = "";
  String rahuEndTime = "";
  String yamghantStartTime = "";
  String yamghantEndTime = "";
  int vikramSamvatTime = 0;

  //Masik Dialog var
  String masikTithiName = "";
  String masikDay = "";
  String masikTithiEndTime = "";
  String masikHinduMonthName = "";
  String masikSeason = "";
  String masikVikramSamvatName = "";
  String translateMoonImage = "hi_name";
  String moonImage = "";
  String locationMessage = "";
  String addressMessage = "";
  int masikVikramSamvatTime = 0;

  //Fast,Festival,Shubh Muhurt List's
  var fastData = <FestivalModel>[];
  var festivalData = <FestivalModel>[];
  var festivalList = <FestivalModel>[];
  var fastList = <FestivalModel>[];
  var muhurtList = <ShubhMuhratModel>[];

  Future panchangData() async {
    print("Translate Value-$isTranslate");
    print("Date:${widget.formattedDate}");
    print("Time:${DateFormat('HH:mm').format(now)}");
    var monthName = DateFormat('MMMM').format(now);

    final panchangRequestBody = {
      'date': widget.formattedDate,
      'time': DateFormat('HH:mm').format(now),
      'latitude': latitude,
      'longitude': longitude,
      'timezone': '5.5',
      'language': isTranslate ? 'en' : 'hi',
    };
    setState(() {
      shimmerscreenDate = true;
    });

    // Make API calls concurrently
    final responses = await Future.wait([
      HttpService().postApi(AppConstants.panchangUrl, panchangRequestBody),
      HttpService().getApi(
          "${AppConstants.monthlyFestival}?type=Vrat&year=${now.year}&month=${now.month}&day=${now.day}"),
      HttpService().getApi(
          "${AppConstants.monthlyFestival}?type=Festival&year=${now.year}&month=${now.month}&day=${now.day}"),
      HttpService().getApi(
          "${AppConstants.monthlyFestival}?type=Vrat&year=${now.year}&month=${now.month}"),
      HttpService().getApi(
          "${AppConstants.monthlyFestival}?type=Festival&year=${now.year}&month=${now.month}"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=${now.year}&month=$monthName&day=${now.day}"),
      HttpService().getApi(AppConstants.moonImageURl),
    ]);

    // Process the responses
    var res = responses[0];
    var fastResponse = responses[1];
    var festivalResponse = responses[2];
    var allFastData = responses[3];
    var allFestivalData = responses[4];
    var shubhMuhurtData = responses[5];
    final tithiImageResponse = responses[6];

    print("Panchang Data:$res");
    print("Festival data:$res");
    print("Fast data:$res");

    //Panchang Data
    tithiName = res['panchang']['tithi']['details']['tithi_name'];
    day = res['panchang']['day'];
    tithiEndTime =
        "${res['panchang']['tithi']['end_time']['hour']}:${res['panchang']['tithi']['end_time']['minute']}:${res['panchang']['tithi']['end_time']['second']}";
    sunrise = res['panchang']['sunrise'];
    sunset = res['panchang']['sunset'];
    moonrise = res['panchang']['moonrise'];
    moonSet = res['panchang']['moonset'];
    hinduMonthName = res['panchang']['hindu_maah']['purnimanta'];
    season = res['panchang']['ritu'];
    sunSign = res['panchang']['sun_sign'];
    moonSign = res['panchang']['moon_sign'];
    dishaShool = res['panchang']['disha_shool'];
    moonPlacement = res['panchang']['moon_nivas'];
    ayana = res['panchang']['ayana'];
    vikramSamvatName = res['panchang']['vkram_samvat_name'];
    vikramSamvatTime = res['panchang']['vikram_samvat'];
    special = res['panchang']['tithi']['details']['special'];
    nakshatraName = res['panchang']['nakshatra']['details']['nak_name'];
    nakshatraTime =
        "${res['panchang']['nakshatra']['end_time']['hour']}:${res['panchang']['nakshatra']['end_time']['minute']}:${res['panchang']['nakshatra']['end_time']['second']}";
    yogaName = res['panchang']['yog']['details']['yog_name'];
    yogaTime =
        "${res['panchang']['yog']['end_time']['hour']}:${res['panchang']['yog']['end_time']['minute']}:${res['panchang']['yog']['end_time']['second']}";
    karanaName = res['panchang']['karan']['details']['karan_name'];
    karanaTime =
        "${res['panchang']['karan']['end_time']['hour']}:${res['panchang']['karan']['end_time']['minute']}:${res['panchang']['karan']['end_time']['second']}";
    monthAmanta = res['panchang']['hindu_maah']['amanta'];
    monthPurnima = res['panchang']['hindu_maah']['purnimanta'];
    shakaSamvatName = "${res['panchang']['shaka_samvat_name']}";
    shakaSamvatTime = "${res['panchang']['shaka_samvat']}";
    auspiciousStartTime = res['panchang']['abhijit_muhurta']['start'];
    auspiciousEndTime = res['panchang']['abhijit_muhurta']['end'];
    gulikStartTime = res['panchang']['guliKaal']['start'];
    gulikEndTime = res['panchang']['guliKaal']['end'];
    rahuStartTime = res['panchang']['rahukaal']['start'];
    rahuEndTime = res['panchang']['rahukaal']['end'];
    yamghantStartTime = res['panchang']['yamghant_kaal']['start'];
    yamghantEndTime = res['panchang']['yamghant_kaal']['end'];

    //Fast & Festival
    fastData = festivalModelFromJson(jsonEncode(fastResponse));
    fastList = festivalModelFromJson(jsonEncode(allFastData));
    festivalData = festivalModelFromJson(jsonEncode(festivalResponse));
    festivalList = festivalModelFromJson(jsonEncode(allFestivalData));

    //ShubhMuhurt
    if (shubhMuhurtData['status'] == true) {
      muhurtList =
          shubhMuhratModelFromJson(jsonEncode(shubhMuhurtData['data']));
    } else {
      muhurtList = [];
    }

    isTranslate
        ? translateMoonImage = "en_name"
        : translateMoonImage = "hi_name";

    // Find the matching tithi name and set the image
    final tithiList = tithiImageResponse['data'];
    final matchedTithi = tithiList.firstWhere(
        (tithi) => tithi[translateMoonImage] == tithiName,
        orElse: () => null);
    if (matchedTithi != null) {
      moonImage = matchedTithi['image'];
    }
    shimmerscreenDate = false;
    setState(() {});
  }

  Color color = Colors.red;
  bool _showColor = true;
  bool _showimage = false;
  int _selectedContainer = 0;
  int _colorIndex = 0;

  List<Color> colors1 = [
    Colors.red.shade800,
    Colors.deepOrange.shade600,
    Colors.red.shade800,
    Colors.purple,
    Colors.red.shade800,
    Colors.deepOrange.shade600,
    Colors.red.shade800,
    Colors.purple,
  ];

  List<Color> colors2 = [
    Colors.white,
    Colors.black,
    Colors.white,
    Colors.black,
    Colors.white,
    Colors.black,
    Colors.white,
    Colors.black,
  ];

  final List<Color> _colors = [
    const Color(0xFFF8BBD0), // Light Pink – black/red/blue/white text works
    const Color(0xFFFFF9C4), // Light Yellow – works with dark/red/blue text
    const Color(0xFFFFE0B2), // Light Orange – works with black text
    const Color(0xFFDCEDC8),
    const Color(
        0xFFF5F5F5), // Light Gray – dark text friendly// Soft Green – black/red text looks good
    const Color(0xFFBBDEFB), // Light Blue – black/blue text friendly
  ];

  int _gradIndex = 0;

  final List<Gradient> _gradColors = [
    const LinearGradient(colors: [Colors.cyan, Colors.teal]),
    const LinearGradient(colors: [Colors.red, Colors.orange]),
    const LinearGradient(colors: [Colors.green, Colors.yellow]),
    const LinearGradient(colors: [Colors.blue, Colors.indigo]),
    const LinearGradient(colors: [Colors.purple, Colors.pink]),
  ];

  int _imageIndex = 0;
  String countryDefault = "Ujjain/Madhaya Pradesh";
  final Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "9123456789",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "91-IN-0",
  );

  final List<String> _images = [
    "assets/image/imagefirst.jpg",
    "assets/image/imagesecond.jpg",
    "assets/image/imagethird.jpg",
    "assets/image/imagefourth.jpg",
    "assets/image/imagefifth.jpg",
    "assets/image/imagesixth.jpg",
    "assets/image/imageseventh.jpg",
    "assets/image/imageeighth.jpg",
    "assets/image/imageninth.jpg",
    "assets/image/imagegita.jpg",
    "assets/image/gitaimage.jpg",
    "assets/image/gita.jpg",
  ];

  String convertTimeToAmPm(String time) {
    try {
      print('Input time: $time'); // Log the input time
      final dateTime = DateFormat('HH:mm').parse(time);
      final formattedTime = DateFormat.jm().format(dateTime);
      print('Formatted time: $formattedTime'); // Log the formatted time
      return formattedTime;
    } catch (e) {
      print('Error: $e'); // Log any errors
      return 'Error parsing time';
    }
  }

  List<Muhurat> muhuratModelList = <Muhurat>[];

  String getResponse(String input) {
    switch (input.toLowerCase()) {
      case "marriage":
        return "assets/testImage/panchangImages/images/Marriage.png";

      case "property purchase":
        return "assets/testImage/panchangImages/images/property_purchase.png";

      case "namkaran":
        return "assets/testImage/panchangImages/images/Naamkaran.png";

      case "vehicle purchase":
        return "assets/testImage/panchangImages/images/vehical_purchase.png";

      case "karnavedha":
        return "assets/testImage/panchangImages/images/Karnavedha.png";

      case "mundan":
        return "assets/testImage/panchangImages/images/Mundan.png";

      case "anna prashan":
        return "assets/testImage/panchangImages/images/Anna_prashan.png";

      case "Vidyarambh":
        return "assets/testImage/panchangImages/images/vidyarambh.png";

      case "grah pravesh":
        return "assets/testImage/panchangImages/images/Grah_pravesh.png";

      default:
        return "assets/testImage/panchangImages/images/Grah_pravesh.png";
    }
  }

  void getMuhuratData() async {
    var res = await HttpService().getApi(
        "${AppConstants.getMahuratUrl}${widget.year}&month=${widget.month}&day=${widget.day}");
    setState(() {
      muhuratModelList.clear();
      if (res["status"]) {
        List muhuratList = res["data"];
        muhuratModelList.addAll(muhuratList.map((e) => Muhurat.fromJson(e)));
      }
    });
    print(res);
  }

  void locationSheet(BuildContext context, String selectedCountry) {
    final TextEditingController countryController = TextEditingController();
    List<CityPickerModel> citylistdata = <CityPickerModel>[];

    void getCityPick(StateSetter modalSetter) async {
      List<CityPickerModel> citypicket = [];
      var response = await http.post(
        Uri.parse('https://geo.vedicrishi.in/places/'),
        body: {
          "country": selectedCountry,
          "name": countryController.text,
        },
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print("Api response $result");
        List listLocation = result;
        citypicket.addAll(listLocation.map((e) => CityPickerModel.fromJson(e)));

        modalSetter(() {
          citylistdata.clear();
          citylistdata.addAll(citypicket);
        });
      }
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetter) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        AppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          leading: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                CupertinoIcons.chevron_back,
                                color: Colors.red,
                              )),
                          title: const Text(
                            'Search City',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: countryController,
                            onChanged: (value) {
                              getCityPick(modalSetter);
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter City Name',
                              contentPadding:
                                  const EdgeInsets.only(top: 5, left: 15),
                              labelStyle:
                                  TextStyle(color: Colors.grey.shade400),
                              suffixIcon: const Icon(
                                CupertinoIcons.search_circle_fill,
                                color: Colors.orange,
                                size: 40,
                              ),
                              counterText: '',
                              alignLabelWithHint: true,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: citylistdata
                              .length, // Number of items in the list
                          itemBuilder: (ctx, int index) {
                            return InkWell(
                              onTap: () {
                                modalSetter(() {
                                  countryController.text =
                                      citylistdata[index].place.toString();
                                  countryDefault =
                                      citylistdata[index].place.toString();
                                  latitude =
                                      citylistdata[index].latitude.toString();
                                  longitude =
                                      citylistdata[index].longitude.toString();
                                  print("Latitude:$latitude");
                                  print("Longitude:$longitude");
                                  print(
                                      "Date:${DateFormat('dd/MM/yyyy').format(now)}");
                                  print(
                                      "Time:${DateFormat('HH:mm').format(now)}");
                                  panchangData();
                                  Navigator.pop(context);
                                  countryController.clear();
                                });
                              },
                              child: DelayedDisplay(
                                delay: const Duration(milliseconds: 500),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_pin,
                                            size: 20, color: Colors.black54),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.3,
                                          child: Text(
                                            citylistdata[index].place,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  int colorIndex1 = 0;
  int colorIndex2 = 0;

  void changeColor() {
    setState(() {
      colorIndex1 = (colorIndex1 + 1) % colors1.length;
      colorIndex2 = (colorIndex2 + 1) % colors2.length;
    });
  }

  String userName = "";
  bool isToggled = false; // State variable to track toggle state

  @override
  void initState() {
    // TODO: implement initStat
    // _initLocation();
    //latitude = "${Provider.of<AuthController>(context, listen: false).latitude}";
    //longitude = "${Provider.of<AuthController>(context, listen: false).longitude}";
    //countryDefault = "${Provider.of<AuthController>(context, listen: false).fullAddress}";
    latitude = widget.late;
    longitude = widget.long;
    countryDefault = widget.location;
    panchangData();
    getMuhuratData();
    // Retrieve the userName from the ProfileController
    userName = Provider.of<ProfileController>(context, listen: false).userNAME;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    DateTime now = DateTime.now();
    String moonDate = DateFormat('dd-MMMM-yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Share Panchang',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.06)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          InkWell(
            onTap: () {
              context.read<SharePachangController>().shareCustomDesign(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.share,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),

          // InkWell(
          //     onTap: () {
          //       context
          //           .read<SharePachangController>()
          //           .shareCustomDesign(context);
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(30),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withOpacity(0.2),
          //             blurRadius: 15,
          //             spreadRadius: 1,
          //             offset: const Offset(0, 5),
          //           ),
          //         ],
          //       ),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(30),
          //         child: BackdropFilter(
          //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //             decoration: BoxDecoration(
          //               color: Colors.white.withOpacity(0.2),
          //               borderRadius: BorderRadius.circular(30),
          //               border: Border.all(
          //                 color: Colors.white.withOpacity(0.5),
          //                 width: 1,
          //               ),
          //             ),
          //             child: const Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Text(
          //                   "Share",
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 13,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //                 SizedBox(width: 5),
          //                 Icon(
          //                   Icons.share,
          //                   color: Colors.white,
          //                   size: 18,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),),

          const SizedBox(
            width: 10,
          ),
          // InkWell(
          //     onTap: () {
          //       locationSheet(context, selectedCountry.name);
          //     },
          //     child: Icon(
          //       Icons.search,
          //       color: Colors.white,
          //     )),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: sunset.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04),
                    child: Screenshot(
                      controller: context
                          .watch<SharePachangController>()
                          .screenshotController,
                      child: Container(
                        decoration: BoxDecoration(
                            color: _showColor ? _colors[_colorIndex] : null,
                            gradient:
                                _showColor ? null : _gradColors[_gradIndex],
                            image: _showimage
                                ? DecorationImage(
                                    image: AssetImage(_images[_imageIndex]),
                                    fit: BoxFit.cover)
                                : null),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenWidth * 0.02,
                                  right: screenWidth * 0.05,
                                  left: screenWidth * 0.05),
                              child: Column(
                                children: [
                                  // Asset Image Background
                                  Image.asset(
                                    'assets/images/head_2.png', // Replace with your image path
                                    fit: BoxFit.cover,
                                    height: 55,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2.0),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 2), // Black border
                                      borderRadius: BorderRadius.circular(
                                          50), // Rounded corners
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8), // Horizontal padding
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.formattedDate,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: colors1[colorIndex1],
                                              ),
                                              textAlign: TextAlign
                                                  .center, // Align text to center
                                              maxLines:
                                                  1, // Optional: set number of lines if needed
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              child: Text(
                                                countryDefault,
                                                style: TextStyle(
                                                    color: colors1[colorIndex1],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: h * 0.02,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Sunrise and Sunset Info
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "सूर्योदय : ",
                                                    style: TextStyle(
                                                      color: colors1[
                                                          colorIndex1], // red.shade800 color for सूर्योदय
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: convertTimeToAmPm(
                                                        sunrise),
                                                    style: TextStyle(
                                                      color:
                                                          colors2[colorIndex2],
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                width:
                                                    5), // Space between the texts
                                            const Text("|"),
                                            const SizedBox(
                                                width:
                                                    5), // Space between the texts
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "सूर्यास्त : ",
                                                    style: TextStyle(
                                                      color: colors1[
                                                          colorIndex1], // red.shade800 color for सूर्यास्त
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: convertTimeToAmPm(
                                                        sunset),
                                                    style: TextStyle(
                                                      color:
                                                          colors2[colorIndex2],
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Moonrise and Moonset Info
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 2, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "चंद्र उदय : ",
                                                    style: TextStyle(
                                                      color: colors1[
                                                          colorIndex1], // red.shade800 color for चंद्र उदय
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: convertTimeToAmPm(
                                                        moonrise),
                                                    style: TextStyle(
                                                      color:
                                                          colors2[colorIndex2],
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                width:
                                                    5), // Space between the texts
                                            const Text("|"),
                                            const SizedBox(
                                                width:
                                                    5), // Space between the texts
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "चंद्र अस्त : ",
                                                    style: TextStyle(
                                                      color: colors1[
                                                          colorIndex1], // red.shade800 color for चंद्र अस्त
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: convertTimeToAmPm(
                                                        moonSet),
                                                    style: TextStyle(
                                                      color:
                                                          colors2[colorIndex2],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(
                                    color: Colors.black,
                                  ),

                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "तिथि : ",
                                              style: TextStyle(
                                                color: colors1[
                                                    colorIndex1], // Green color for 📅 तिथि:
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: tithiName,
                                              style: TextStyle(
                                                color: colors2[
                                                    colorIndex2], // White color for the remaining text
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "तिथि समाप्ति : ",
                                              style: TextStyle(
                                                color: colors1[
                                                    colorIndex1], // Green color for 🕰 तिथि समाप्ति:
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: convertTimeToAmPm(
                                                  tithiEndTime),
                                              style: TextStyle(
                                                color: colors2[
                                                    colorIndex2], // White color for the remaining text
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(
                                    color: Colors.black,
                                  ),

                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 28, left: 28),
                                              child: Text(
                                                "अभिजीत काल : ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors1[colorIndex1],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            "${convertTimeToAmPm(auspiciousStartTime)} To ${convertTimeToAmPm(auspiciousEndTime)}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: colors2[colorIndex2],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          buildTimeSlot('यमगंड काल : '),
                                          const SizedBox(height: 3),
                                          Text(
                                            "${convertTimeToAmPm(yamghantStartTime)} To ${convertTimeToAmPm(yamghantEndTime)}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: colors2[colorIndex2],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          buildTimeSlot('गुलिक काल : '),
                                          const SizedBox(height: 3),
                                          Text(
                                            "${convertTimeToAmPm(gulikStartTime)} To ${convertTimeToAmPm(gulikEndTime)}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: colors2[colorIndex2],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: buildTimeSlot("राहु काल : "),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            "${convertTimeToAmPm(rahuStartTime)} To ${convertTimeToAmPm(rahuEndTime)}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: colors2[colorIndex2],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const Divider(
                                    color: Colors.black,
                                  ),

                                  const SizedBox(height: 5),

                                  // Row with "दिशा शूल", "चंद्र राशि", "सूर्य राशि"
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "दिशा शूल : ",
                                              style: TextStyle(
                                                  color: colors1[
                                                      colorIndex1], // Green color for 🕰 तिथि समाप्ति:
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: dishaShool,
                                              style: TextStyle(
                                                color: colors2[
                                                    colorIndex2], // White color for the remaining text
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "चंद्र राशि : ",
                                              style: TextStyle(
                                                  color: colors1[
                                                      colorIndex1], // Green color for 🕰 तिथि समाप्ति:
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: moonSign,
                                              style: TextStyle(
                                                color: colors2[
                                                    colorIndex2], // White color for the remaining text
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "सूर्य राशि : ",
                                                style: TextStyle(
                                                    color: colors1[
                                                        colorIndex1], // Green color for 🕰 तिथि समाप्ति:
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: sunSign,
                                                style: TextStyle(
                                                  color: colors2[
                                                      colorIndex2], // White color for the remaining text
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5),
                                  const Divider(
                                    color: Colors.black,
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              "शुभ मुहूर्त :",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: colors1[colorIndex1],
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(height: 5),
                                            widget.muhuratModelList.isEmpty
                                                ? Text(
                                                    isTranslate
                                                        ? "No Shubh Muhurat\nToday"
                                                        : "आज कोई शुभ\nमुहूर्त नहीं है",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: widget
                                                        .muhuratModelList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {},
                                                        child: Text(
                                                          " ${widget.muhuratModelList[index].type.toUpperCase()}",
                                                          style: TextStyle(
                                                            color: colors2[
                                                                colorIndex2],
                                                            fontSize: 10,
                                                          ),
                                                          maxLines:
                                                              3, // Limit to 2 lines
                                                          overflow: TextOverflow
                                                              .ellipsis, // Add ellipsis for overflow
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              "व्रत :",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: colors1[colorIndex1],
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(height: 5),
                                            widget.fastData.isEmpty
                                                ? Text(
                                                    isTranslate
                                                        ? "No Fast\nToday"
                                                        : "आज कोई व्रत\nनहीं है",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        widget.fastData.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {},
                                                        child: Text(
                                                          widget.fastData[index]
                                                              .eventName,
                                                          style: TextStyle(
                                                              color: colors2[
                                                                  colorIndex2],
                                                              fontSize: 13),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              "त्योहार :",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: colors1[colorIndex1],
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            const SizedBox(height: 5),
                                            widget.festivalData.isEmpty
                                                ? Text(
                                                    isTranslate
                                                        ? "No Festival\nToday"
                                                        : "आज कोई त्यौहार\nनहीं है",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: widget
                                                        .festivalData.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {},
                                                        child: Text(
                                                          widget
                                                              .festivalData[
                                                                  index]
                                                              .eventName,
                                                          style: TextStyle(
                                                              color: colors2[
                                                                  colorIndex2]),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 9),
                                ],
                              ),
                            ),

                            /// Share Buttons
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenWidth * 0.01),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Display user information or toggle button based on isToggled
                                    isToggled
                                        ? Column(
                                            children: [
                                              Text(
                                                "विनीत : ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: colors1[colorIndex1],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                userName,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: colors2[colorIndex2],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  // Handle Play Store tap
                                                },
                                                child: Container(
                                                  height: screenWidth * 0.13,
                                                  width: screenWidth * 0.18,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            screenWidth * 0.02),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          "assets/image/playstore.png"),
                                                      fit: BoxFit.contain,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  // Handle App Store tap
                                                },
                                                child: Container(
                                                  height: screenWidth * 0.12,
                                                  width: screenWidth * 0.18,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            screenWidth * 0.02),
                                                    child: const Image(
                                                      image: AssetImage(
                                                          "assets/image/appstore.png"),
                                                      fit: BoxFit.contain,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                    GestureDetector(
                                      child: Container(
                                          // height: 55,
                                          height: screenWidth * 0.13,
                                          // width: 180,
                                          width: screenWidth * 0.45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * 0.02,
                                                right: screenWidth * 0.02),
                                            child: const Image(
                                              image: AssetImage(
                                                  "assets/image/mahakal_logo.png"),
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Divider(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Solid Color Option
                        Column(
                          children: [
                            const Icon(
                              Icons.palette_outlined,
                              size: 22,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _colorIndex =
                                      (_colorIndex + 1) % _colors.length;
                                  _showColor = true;
                                  _showimage = false;
                                  _selectedContainer = 0;
                                });
                              },
                              child: Container(
                                height: screenWidth * 0.12,
                                width: screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _colors[_colorIndex],
                                  border: _selectedContainer == 0
                                      ? Border.all(
                                          color: Colors.black, width: 3)
                                      : Border.all(
                                          color: Colors.grey[300]!, width: 2),
                                  boxShadow: _selectedContainer == 0
                                      ? [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Solid",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),

                        // Gradient Option
                        Column(
                          children: [
                            const Icon(
                              Icons.gradient_outlined,
                              size: 22,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _gradIndex =
                                      (_gradIndex + 1) % _gradColors.length;
                                  _showColor = false;
                                  _showimage = false;
                                  _selectedContainer = 1;
                                });
                              },
                              child: Container(
                                height: screenWidth * 0.12,
                                width: screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: _gradColors[_gradIndex],
                                  border: _selectedContainer == 1
                                      ? Border.all(
                                          color: Colors.black, width: 3)
                                      : Border.all(
                                          color: Colors.grey[300]!, width: 2),
                                  boxShadow: _selectedContainer == 1
                                      ? [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Gradient",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),

                        // Image Option
                        Column(
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 22,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imageIndex =
                                      (_imageIndex + 1) % _images.length;
                                  _showimage = true;
                                  _showColor = false;
                                  _selectedContainer = 2;
                                });
                              },
                              child: Container(
                                height: screenWidth * 0.12,
                                width: screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(_images[_imageIndex]),
                                    fit: BoxFit.cover,
                                  ),
                                  border: _selectedContainer == 2
                                      ? Border.all(
                                          color: Colors.black, width: 3)
                                      : Border.all(
                                          color: Colors.grey[300]!, width: 2),
                                  boxShadow: _selectedContainer == 2
                                      ? [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Image",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),

                        // Text Color Option
                        Column(
                          children: [
                            const Icon(
                              Icons.text_fields_outlined,
                              size: 22,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedContainer = 3;
                                  changeColor();
                                });
                              },
                              child: Container(
                                height: screenWidth * 0.12,
                                width: screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors1[colorIndex1],
                                  border: _selectedContainer == 3
                                      ? Border.all(
                                          color: Colors.black, width: 3)
                                      : Border.all(
                                          color: Colors.grey[300]!, width: 2),
                                  boxShadow: _selectedContainer == 3
                                      ? [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Text",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),

                        // Toggle Switch
                        Column(
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Transform.scale(
                              scale: 1.2,
                              child: Switch.adaptive(
                                thumbColor: WidgetStateProperty.all(
                                  isToggled ? Colors.white : Colors.grey,
                                ),
                                activeColor:
                                    isToggled ? Colors.orange : Colors.grey,
                                activeTrackColor: Colors.orange,
                                value: isToggled,
                                onChanged: (value) {
                                  setState(() {
                                    isToggled = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     right: 30,
                  //       left: 30,
                  //       top: 7,
                  //       // horizontal: screenWidth * 0.2,
                  //       // vertical: 5
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Column(
                  //         children: [
                  //           Container(
                  //             height: screenWidth * 0.05,
                  //             width: screenWidth * 0.05,
                  //             decoration: const BoxDecoration(
                  //                 image: DecorationImage(
                  //                     image: NetworkImage(
                  //                         "https://icon-library.com/images/theme-icon-png/theme-icon-png-27.jpg"))),
                  //           ),
                  //           SizedBox(
                  //             height: screenWidth * 0.02,
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 _colorIndex =
                  //                     (_colorIndex + 1) % _colors.length;
                  //                 _showColor = true;
                  //                 _showimage = false;
                  //                 _selectedContainer = 0;
                  //               });
                  //             },
                  //             child: Container(
                  //               height: screenWidth * 0.1,
                  //               width: screenWidth * 0.1,
                  //               decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color: _colors[_colorIndex],
                  //                   border: _selectedContainer == 0
                  //                       ? Border.all(
                  //                           color: Colors.black,
                  //                           width: 4)
                  //                       : null),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(width: 3),
                  //       Column(
                  //         children: [
                  //           // Container(
                  //           //   height: screenWidth * 0.05,
                  //           //   width: screenWidth * 0.05,
                  //           //   decoration: const BoxDecoration(
                  //           //       image: DecorationImage(
                  //           //           image: NetworkImage(
                  //           //               "https://cdn.icon-icons.com/icons2/368/PNG/512/Themes_37103.png"))),
                  //           // ),
                  //           Icon(
                  //             Icons.color_lens_outlined,
                  //             size: 20,
                  //             color: Colors.orange,
                  //           ),
                  //           SizedBox(
                  //             height: screenWidth * 0.02,
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 _gradIndex = (_gradIndex + 1) % _gradColors.length;
                  //                 _showColor = false;
                  //                 _showimage = false;
                  //                 _selectedContainer = 1;
                  //               });
                  //             },
                  //             child: Container(
                  //               height: screenWidth * 0.1,
                  //               width: screenWidth * 0.1,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 border: _selectedContainer == 1
                  //                     ? Border.all(
                  //                     color: Colors.black,
                  //                     width: 4)
                  //                     : null,
                  //                 gradient: _gradColors[_gradIndex],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(width: 3),
                  //       Column(
                  //         children: [
                  //           Container(
                  //             height: screenWidth * 0.05,
                  //             width: screenWidth * 0.05,
                  //             decoration: const BoxDecoration(
                  //                 image: DecorationImage(
                  //                     image: NetworkImage(
                  //                         "https://cdn-icons-png.flaticon.com/512/5460/5460486.png"))),
                  //           ),
                  //           SizedBox(
                  //             height: screenWidth * 0.02,
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 _imageIndex = (_imageIndex + 1) % _images.length;
                  //                 _showimage = true;
                  //                 _showColor = false;
                  //                 _selectedContainer = 2;
                  //               });
                  //             },
                  //             child: Container(
                  //               height: screenWidth * 0.1,
                  //               width: screenWidth * 0.1,
                  //               decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   image: DecorationImage(
                  //                       image: AssetImage(_images[_imageIndex]),
                  //                       fit: BoxFit.cover),
                  //                   border: _selectedContainer == 2
                  //                       ? Border.all(
                  //                       color: Colors.black,
                  //                       width: 4)
                  //                       : null),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(width: 3),
                  //       Column(
                  //         children: [
                  //           Icon(
                  //             CupertinoIcons.textformat,
                  //             size: 20,
                  //             color: Colors.black,
                  //           ),
                  //           SizedBox(
                  //             height: screenWidth * 0.01,
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //              setState(() {
                  //                _selectedContainer = 3;
                  //                changeColor();
                  //              });
                  //             },
                  //             child: Container(
                  //               height: screenWidth * 0.1,
                  //               width: screenWidth * 0.1,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 border: _selectedContainer == 3
                  //                     ? Border.all(
                  //                     color: Colors.black,
                  //                     width: 4)
                  //                     : null,
                  //                 color: colors1[colorIndex1],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(width: 3),
                  //       // Toggle Button
                  //       Column(
                  //         children: [
                  //           Text("Name"),
                  //           Switch(
                  //             value: isToggled,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 isToggled = value; // Update the toggle state
                  //               });
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }

  Widget buildInfoTile(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: colors2[colorIndex2],
      ),
      // textAlign: TextAlign.center,
    );
  }

  Widget buildTimeRow(
      String title, String time, MaterialAccentColor orangeAccent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title :",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              color: colors2[colorIndex2],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.alfaSlabOne(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        shadows: [
          const Shadow(
            color: Colors.black45,
            offset: Offset(3, 3),
            blurRadius: 5,
          ),
        ],
        color: Colors.amberAccent,
      ),
    );
  }

  Widget buildSubtitle(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: colors2[colorIndex2],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colors1[colorIndex1],
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget buildTimeSlot(String title) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 28, left: 28),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors1[colorIndex1],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
