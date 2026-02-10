import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/checkout/widgets/shipping_details_widget.dart';
import 'package:mahakal/features/maha_bhandar/screen/share_panchang.dart';
import 'package:mahakal/features/product/widgets/recommended_product_widget.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../localization/language_constrants.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../../utill/dimensions.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../infopage/infopageview.dart';
import '../model/festival_model.dart';
import '../model/specialmuhurat_model.dart';
import '../model/today_muhurat_model.dart';
import 'fast_&_festival_widget/fast_festival_details.dart';

class TodayTab extends StatefulWidget {
  const TodayTab({super.key});

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab>
    with SingleTickerProviderStateMixin {
  DateTime now = DateTime.now();
  DateTime todayDate = DateTime.now();
  int dainikCount = 0;
  bool shimmerscreenDate = false;
  bool isTranslate = false;
  String latitude = "23.179300";
  String longitude = "75.784912";
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
  String moonImage = "";
  String translateMoonImage = "hi_name";
  int vikramSamvatTime = 0;
  var fastData = <FestivalModel>[];
  var festivalData = <FestivalModel>[];
  var specialMuhuratList = <Specialmuhurat>[];

  String enAuspiciousInfo =
      "Shubh Muhurat is also called Abhijeet Muhurat, in which auspicious works are done. If you are unable to do auspicious work in Shubh Muhurat, then you can do it in Gulikaal. However, the possibility of repeating the work done in Gulikaal increases. Rahukaal and Yamghantakal are inauspicious times in which no auspicious work is done.";
  String hiAuspiciousInfo =
      "शुभ मुहूर्त को अभिजीत मुहूर्त भी कहते है, जिसमें शुभ कार्य किए जाते हैं। अगर शुभ मुहूर्त में शुभ कार्य नहीं कर पाएं तो गुलिकाल में कर सकते हैं। हालांकि गुलिकाल में किए गए कार्य की दोबारा होने की सम्भावना बढ़ जाती है। राहुकाल और यमघण्टकाल अशुभ समय है जिसमें कोई भी शुभ कार्य नहीं किए जाते हैं।";
  String enSunsetInfo =
      "Sunrise and sunset represent the daily appearance and disappearance of the Sun, while moonrise and moonset represent the appearance and disappearance of the Moon, which is important for timekeeping and cultural practices.";
  String hiSunsetInfo =
      "सूर्योदय और सूर्यास्त सूर्य के दैनिक रूप से प्रकट होने और लुप्त होने को दर्शाते हैं, जबकि चंद्रोदय और चंद्रास्त चंद्रमा के दिखाई देने और लुप्त होने को दर्शाते हैं, जो समय की गणना और सांस्कृतिक प्रथाओं के लिए महत्वपूर्ण है।";

  // String convertTimeToAmPm(String time) {
  //   final dateTime = DateFormat('HH:mm:ss').parse(time);
  //   final formattedTime = DateFormat.jm().format(dateTime);
  //   return formattedTime;
  // }
  String dayNow = DateFormat('dd').format(DateTime.now()).toString();
  String monthName = DateFormat('MMMM').format(DateTime.now()).toString();
  String year = DateFormat('yyyy').format(DateTime.now()).toString();
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
    print("Year-$year");
    print("Month-$monthName");
    var res = await HttpService().getApi(
        "/api/v1/astro/muhurat?year=$year&month=$monthName&day=$dayNow");
    if (res != null && res["data"] != null && res["data"] is List) {
      setState(() {
        muhuratModelList.clear();
        List muhuratList = res["data"];
        muhuratModelList.addAll(muhuratList.map((e) => Muhurat.fromJson(e)));
        print(muhuratModelList.length);
      });
    } else {
      print("No data found or unexpected response format.");
    }
  }

  void getSpecialMuhurat() async {
    var res = await HttpService().getApi(
        "/api/v1/astro/special-muhurat?year=$year&month=$monthName&day=$dayNow&type=special");
    print("Api Special Muhurat $res");

    if (res != null && res["data"] != null && res["data"] is List) {
      setState(() {
        specialMuhuratList.clear();
        List specialList = res["data"];
        specialMuhuratList
            .addAll(specialList.map((e) => Specialmuhurat.fromJson(e)));
      });
    } else {
      print("No data found or unexpected response format.");
    }
  }

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

  Future<void> fetchData() async {
    setState(() {
      shimmerscreenDate = true;
    });

    // Define API URLs
    const panchangUrl = AppConstants.panchangUrl;
    const monthlyFestivalUrl = AppConstants.monthlyFestival;
    const tithiImageApiUrl = AppConstants.moonImageURl;

    // Get current date and time
    final now = DateTime.now();

    // Create the request body for Panchang API
    final panchangRequestBody = {
      'date': DateFormat('dd/MM/yyyy').format(now),
      'time': DateFormat('HH:mm').format(now),
      'latitude': latitude,
      'longitude': longitude,
      'timezone': '5.5',
      'language': isTranslate ? 'en' : 'hi',
    };

    // Make API calls concurrently
    final responses = await Future.wait([
      HttpService().postApi(panchangUrl, panchangRequestBody),
      HttpService().getApi(
          '$monthlyFestivalUrl?type=Vrat&year=${now.year}&month=${now.month}&day=${now.day}'),
      HttpService().getApi(
          '$monthlyFestivalUrl?type=Festival&year=${now.year}&month=${now.month}&day=${now.day}'),
      HttpService().getApi(tithiImageApiUrl),
    ]);

    // Extract responses
    final panchangResponse = responses[0];
    final fastResponse = responses[1];
    final festivalResponse = responses[2];
    final tithiImageResponse = responses[3];

    // Process Panchang data
    tithiName = panchangResponse['panchang']['tithi']['details']['tithi_name'];
    day = panchangResponse['panchang']['day'];
    tithiEndTime =
        "${panchangResponse['panchang']['tithi']['end_time']['hour']}:${panchangResponse['panchang']['tithi']['end_time']['minute']}:${panchangResponse['panchang']['tithi']['end_time']['second']}";
    sunrise = panchangResponse['panchang']['sunrise'];
    sunset = panchangResponse['panchang']['sunset'];
    moonrise = panchangResponse['panchang']['moonrise'];
    moonSet = panchangResponse['panchang']['moonset'];
    hinduMonthName = panchangResponse['panchang']['hindu_maah']['purnimanta'];
    season = panchangResponse['panchang']['ritu'];
    sunSign = panchangResponse['panchang']['sun_sign'];
    moonSign = panchangResponse['panchang']['moon_sign'];
    dishaShool = panchangResponse['panchang']['disha_shool'];
    moonPlacement = panchangResponse['panchang']['moon_nivas'];
    ayana = panchangResponse['panchang']['ayana'];
    vikramSamvatName = panchangResponse['panchang']['vkram_samvat_name'];
    vikramSamvatTime = panchangResponse['panchang']['vikram_samvat'];
    special = panchangResponse['panchang']['tithi']['details']['special'];
    nakshatraName =
        panchangResponse['panchang']['nakshatra']['details']['nak_name'];
    nakshatraTime =
        "${panchangResponse['panchang']['nakshatra']['end_time']['hour']}:${panchangResponse['panchang']['nakshatra']['end_time']['minute']}:${panchangResponse['panchang']['nakshatra']['end_time']['second']}";
    yogaName = panchangResponse['panchang']['yog']['details']['yog_name'];
    yogaTime =
        "${panchangResponse['panchang']['yog']['end_time']['hour']}:${panchangResponse['panchang']['yog']['end_time']['minute']}:${panchangResponse['panchang']['yog']['end_time']['second']}";
    karanaName = panchangResponse['panchang']['karan']['details']['karan_name'];
    karanaTime =
        "${panchangResponse['panchang']['karan']['end_time']['hour']}:${panchangResponse['panchang']['karan']['end_time']['minute']}:${panchangResponse['panchang']['karan']['end_time']['second']}";
    monthAmanta = panchangResponse['panchang']['hindu_maah']['amanta'];
    monthPurnima = panchangResponse['panchang']['hindu_maah']['purnimanta'];
    shakaSamvatName = "${panchangResponse['panchang']['shaka_samvat_name']}";
    shakaSamvatTime = "${panchangResponse['panchang']['shaka_samvat']}";
    auspiciousStartTime =
        panchangResponse['panchang']['abhijit_muhurta']['start'];
    auspiciousEndTime = panchangResponse['panchang']['abhijit_muhurta']['end'];
    gulikStartTime = panchangResponse['panchang']['rahukaal']['start'];
    gulikEndTime = panchangResponse['panchang']['rahukaal']['end'];
    rahuStartTime = panchangResponse['panchang']['guliKaal']['start'];
    rahuEndTime = panchangResponse['panchang']['guliKaal']['end'];
    yamghantStartTime = panchangResponse['panchang']['yamghant_kaal']['start'];
    yamghantEndTime = panchangResponse['panchang']['yamghant_kaal']['end'];

    // Process fast and festival data
    fastData = festivalModelFromJson(jsonEncode(fastResponse));
    festivalData = festivalModelFromJson(jsonEncode(festivalResponse));

    isTranslate
        ? translateMoonImage = "en_name"
        : translateMoonImage = "hi_name";

    // Find the matching tithi name and set the image
    final tithiList = tithiImageResponse['data'] as List<dynamic>;
    final matchedTithi = tithiList.firstWhere(
        (tithi) => tithi[translateMoonImage] == tithiName,
        orElse: () => null);
    if (matchedTithi != null) {
      moonImage = matchedTithi['image'];
    }

    setState(() {
      shimmerscreenDate = false;
    });
  }

  void infoSheet(String title, String date, String muhurt, String nakshatra,
      String tithi, String image) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "✤ ${title.capitalize()} ✤",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(image)),

                  const SizedBox(height: 10),

                  Text(
                    "⦿ Date:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  //information
                  Text(
                    "⦿ Muhurt:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    muhurt,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),
                  //information
                  Text(
                    "⦿ Nakshatra:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    nakshatra,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),
                  //information
                  Text(
                    "⦿ Tithi:",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    tithi,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    fetchData();
    getMuhuratData();
    getSpecialMuhurat();
    latitude = Provider.of<AuthController>(Get.context!, listen: false)
        .latitude
        .toString();
    longitude = Provider.of<AuthController>(Get.context!, listen: false)
        .longitude
        .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    String moonDate = DateFormat('dd-MMMM-yyyy').format(now);
    return Scaffold(
      body: shimmerscreenDate
          ? const ShimmerScreenWdget()
          : Column(
              children: [
                Expanded(flex: 0, child: SizedBox(height: w * 0.2)),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sunny,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "$moonDate (${getTranslated('moon', context) ?? "Moon"})",
                          style: TextStyle(
                              fontSize: h * 0.02, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        //Translate Button
                        BouncingWidgetInOut(
                          onPressed: () {
                            setState(() {
                              isTranslate = !isTranslate;
                              isTranslate
                                  ? translateMoonImage = "en_name"
                                  : translateMoonImage = "hi_name";
                              fetchData();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isTranslate
                                    ? Colors.orange
                                    : Colors.transparent,
                                border: Border.all(
                                    color: isTranslate
                                        ? Colors.transparent
                                        : Colors.orange)),
                            child: Icon(
                              Icons.translate,
                              color: isTranslate ? Colors.white : Colors.orange,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Today Moon
                        Column(
                          children: [
                            // Today moon
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => SharePachangScreen(
                                      formattedDate:
                                          DateFormat('dd/MM/yyyy').format(now),
                                      day: "${now.day}",
                                      month: DateFormat.MMMM().format(now),
                                      year: "${now.year}",
                                      fastData: fastData,
                                      festivalData: festivalData,
                                      muhuratModelList: muhuratModelList,
                                      late: latitude,
                                      long: longitude,
                                      location: "Ujjain/Madhaya Pradesh",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                width: double.infinity,
                                color: Colors.orange.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        padding: const EdgeInsets.all(10),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5), // Shadow color
                                              spreadRadius: 3, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: const Offset(
                                                  0, 3), // Offset of the shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () => print(
                                                    "${AppConstants.baseUrl}${AppConstants.moonImagePathURL}$moonImage"),
                                                child: Container(
                                                  height: h * 0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${AppConstants.baseUrl}${AppConstants.moonImagePathURL}$moonImage"),
                                                      fit: BoxFit
                                                          .cover, // You can adjust the fit as needed
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        tithiName,
                                                        style: TextStyle(
                                                            fontSize: h * 0.024,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const Spacer(),

                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  SharePachangScreen(
                                                                formattedDate:
                                                                    DateFormat(
                                                                            'dd/MM/yyyy')
                                                                        .format(
                                                                            now),
                                                                day:
                                                                    "${now.day}",
                                                                month: DateFormat
                                                                        .MMMM()
                                                                    .format(
                                                                        now),
                                                                year:
                                                                    "${now.year}",
                                                                fastData:
                                                                    fastData,
                                                                festivalData:
                                                                    festivalData,
                                                                muhuratModelList:
                                                                    muhuratModelList,
                                                                late: latitude,
                                                                long: longitude,
                                                                location:
                                                                    "Ujjain/Madhaya Pradesh",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color:
                                                                    Colors.red,
                                                                width: 0.5),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.08),
                                                                blurRadius: 4,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
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
                                                      //   onTap: () {
                                                      //     // Your navigation code
                                                      //     Navigator.push(
                                                      //       context,
                                                      //       CupertinoPageRoute(
                                                      //         builder: (context) => SharePachangScreen(
                                                      //           formattedDate: DateFormat('dd/MM/yyyy').format(now),
                                                      //           day: "${now.day}",
                                                      //           month: DateFormat.MMMM().format(now),
                                                      //           year: "${now.year}",
                                                      //           fastData: fastData,
                                                      //           festivalData: festivalData,
                                                      //           muhuratModelList: muhuratModelList,
                                                      //           late: latitude,
                                                      //           long: longitude,
                                                      //           location: "Ujjain/Madhaya Pradesh",
                                                      //         ),
                                                      //       ),
                                                      //     );
                                                      //   },
                                                      //   child: Container(
                                                      //     decoration: BoxDecoration(
                                                      //       borderRadius: BorderRadius.circular(30),
                                                      //       boxShadow: [
                                                      //         BoxShadow(
                                                      //           color: Colors.deepOrange.withOpacity(0.2),
                                                      //           blurRadius: 15,
                                                      //           spreadRadius: 1,
                                                      //           offset: const Offset(0, 5),
                                                      //         ),
                                                      //       ],
                                                      //     ),
                                                      //     child: ClipRRect(
                                                      //       borderRadius: BorderRadius.circular(30),
                                                      //       child: BackdropFilter(
                                                      //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                      //         child: Container(
                                                      //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      //           decoration: BoxDecoration(
                                                      //             color: Colors.white.withOpacity(0.2),
                                                      //             borderRadius: BorderRadius.circular(30),
                                                      //             border: Border.all(
                                                      //               color: Colors.deepOrange.withOpacity(0.5),
                                                      //               width: 1,
                                                      //             ),
                                                      //           ),
                                                      //           child: const Row(
                                                      //             mainAxisSize: MainAxisSize.min,
                                                      //             children: [
                                                      //               Text(
                                                      //                 "Share",
                                                      //                 style: TextStyle(
                                                      //                   color: Colors.deepOrange,
                                                      //                   fontSize: 13,
                                                      //                   fontWeight: FontWeight.w600,
                                                      //                 ),
                                                      //               ),
                                                      //               SizedBox(width: 5),
                                                      //               Icon(
                                                      //                 Icons.share,
                                                      //                 color: Colors.deepOrange,
                                                      //                 size: 18,
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                  Text(
                                                    day,
                                                    style: TextStyle(
                                                        fontSize: h * 0.020,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    isTranslate
                                                        ? "Till ${convertTimeToAmPm(tithiEndTime)}"
                                                        : "${convertTimeToAmPm(tithiEndTime)} बजे तक",
                                                    style: TextStyle(
                                                        fontSize: h * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    "$hinduMonthName ${getTranslated('month', context) ?? 'Month'}",
                                                    style: TextStyle(
                                                        fontSize: h * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    "$season, $vikramSamvatName $vikramSamvatTime",
                                                    style: TextStyle(
                                                        fontSize: h * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //Fast & Festivals
                        const SizedBox(height: 10.0),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          padding: const EdgeInsets.all(6),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 3, // Spread radius
                                blurRadius: 5, // Blur radius
                                offset:
                                    const Offset(0, 3), // Offset of the shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.orange,
                                      height: 20,
                                      width: 4,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      getTranslated(
                                              'fast_&_festival', context) ??
                                          "Fast & Festival",
                                      style: TextStyle(
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                child: Text(
                                  getTranslated('fast', context) ?? "Fast",
                                  style: TextStyle(
                                      fontSize: h * 0.022,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                child: fastData.isEmpty
                                    ? Text(
                                        isTranslate
                                            ? "---- No Fast Today ----"
                                            : "---- आज कोई व्रत नहीं है ----",
                                        style: TextStyle(
                                          fontSize: h * 0.018,
                                          color: Colors.indigoAccent.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                              fastData.length,
                                              (index) => InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageAnimationTransition(
                                                              page:
                                                                  FastFestivalsDetails(
                                                                title: fastData[
                                                                        index]
                                                                    .eventName,
                                                                hiDescription:
                                                                    fastData[
                                                                            index]
                                                                        .hiDescription,
                                                                enDescription:
                                                                    fastData[
                                                                            index]
                                                                        .enDescription,
                                                                image: fastData[
                                                                        index]
                                                                    .image,
                                                              ),
                                                              pageAnimationType:
                                                                  RightToLeftTransition()));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0),
                                                      child: Chip(
                                                        label: Text(
                                                          fastData[index]
                                                              .eventName,
                                                          style: TextStyle(
                                                            fontSize: h * 0.018,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: Colors
                                                            .orange
                                                            .withOpacity(0.1),
                                                        shape:
                                                            const StadiumBorder(
                                                          side: BorderSide(
                                                            color:
                                                                Colors.orange,
                                                            width: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                child: Text(
                                  getTranslated('festival', context) ??
                                      "Festival",
                                  style: TextStyle(
                                      fontSize: h * 0.022,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                child: festivalData.isEmpty
                                    ? Text(
                                        isTranslate
                                            ? "---- No Festival Today ----"
                                            : "---- आज कोई त्यौहार नहीं है ----",
                                        style: TextStyle(
                                          fontSize: h * 0.018,
                                          color: Colors.indigoAccent.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                              festivalData.length,
                                              (index) => InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageAnimationTransition(
                                                              page:
                                                                  FastFestivalsDetails(
                                                                title: festivalData[
                                                                        index]
                                                                    .eventName,
                                                                hiDescription:
                                                                    festivalData[
                                                                            index]
                                                                        .hiDescription,
                                                                enDescription:
                                                                    festivalData[
                                                                            index]
                                                                        .enDescription,
                                                                image:
                                                                    festivalData[
                                                                            index]
                                                                        .image,
                                                              ),
                                                              pageAnimationType:
                                                                  RightToLeftTransition()));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0),
                                                      child: Chip(
                                                        label: Text(
                                                          festivalData[index]
                                                              .eventName,
                                                          style: TextStyle(
                                                            fontSize: h * 0.018,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: Colors
                                                            .orange
                                                            .withOpacity(0.1),
                                                        shape:
                                                            const StadiumBorder(
                                                          side: BorderSide(
                                                            color:
                                                                Colors.orange,
                                                            width: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                child: Text(
                                  getTranslated('Shubh muhurat', context) ??
                                      "Shubh Muhurat",
                                  style: TextStyle(
                                      fontSize: h * 0.022,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                child: muhuratModelList.isEmpty
                                    ? Text(
                                        isTranslate
                                            ? "---- No Muhurat Today ----"
                                            : "---- आज कोई मुहुर्त नहीं है ----",
                                        style: TextStyle(
                                          fontSize: h * 0.018,
                                          color: Colors.indigoAccent.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                              muhuratModelList.length,
                                              (index) => InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                        muhuratModelList[index]
                                                            .type,
                                                        muhuratModelList[index]
                                                            .titleLink,
                                                        muhuratModelList[index]
                                                            .muhurat,
                                                        muhuratModelList[index]
                                                            .nakshatra,
                                                        muhuratModelList[index]
                                                            .tithi,
                                                        getResponse(
                                                            muhuratModelList[
                                                                    index]
                                                                .type),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0),
                                                      child: Chip(
                                                        label: Text(
                                                          muhuratModelList[
                                                                  index]
                                                              .type
                                                              .capitalize(),
                                                          style: TextStyle(
                                                            fontSize: h * 0.018,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: Colors
                                                            .orange
                                                            .withOpacity(0.1),
                                                        shape:
                                                            const StadiumBorder(
                                                          side: BorderSide(
                                                            color:
                                                                Colors.orange,
                                                            width: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                              ),

                              //Special muhurat
                              specialMuhuratList.isEmpty
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 2.0),
                                          child: Text(
                                            getTranslated(
                                                'special_muhurat', context)!,
                                            style: TextStyle(
                                                fontSize: h * 0.022,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 2.0),
                                          child: specialMuhuratList.isEmpty
                                              ? Text(
                                                  isTranslate
                                                      ? "---- No Muhurat Today ----"
                                                      : "---- आज कोई मुहुर्त नहीं है ----",
                                                  style: TextStyle(
                                                    fontSize: h * 0.018,
                                                    color: Colors
                                                        .indigoAccent.shade700,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: List.generate(
                                                        specialMuhuratList
                                                            .length,
                                                        (index) => InkWell(
                                                              onTap: () {
                                                                infoSheet(
                                                                  specialMuhuratList[
                                                                          index]
                                                                      .type,
                                                                  specialMuhuratList[
                                                                          index]
                                                                      .titleLink,
                                                                  specialMuhuratList[
                                                                          index]
                                                                      .muhurat,
                                                                  specialMuhuratList[
                                                                          index]
                                                                      .nakshatra,
                                                                  specialMuhuratList[
                                                                          index]
                                                                      .tithi,
                                                                  getResponse(
                                                                      muhuratModelList[
                                                                              index]
                                                                          .type),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        2.0),
                                                                child: Chip(
                                                                  label: Text(
                                                                    specialMuhuratList[
                                                                            index]
                                                                        .message,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: h *
                                                                          0.018,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: Colors
                                                                      .orange
                                                                      .withOpacity(
                                                                          0.1),
                                                                  shape:
                                                                      StadiumBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .orange
                                                                          .shade50,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),

                        //Sunrise-sunset
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          color: Colors.red.shade50,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.orange,
                                      height: 20,
                                      width: 4,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${getTranslated('sunrise', context) ?? "Sunrise"} - ${getTranslated('sunset', context) ?? "Sunset"}",
                                      style: TextStyle(
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        infoPopup(
                                            context,
                                            isTranslate
                                                ? enSunsetInfo
                                                : hiSunsetInfo);
                                      },
                                      icon: const Icon(
                                        Icons.report_gmailerrorred,
                                        color: Colors.orange,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                padding: const EdgeInsets.all(6),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.5), // Shadow color
                                      spreadRadius: 3, // Spread radius
                                      blurRadius: 5, // Blur radius
                                      offset: const Offset(
                                          0, 3), // Offset of the shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Lottie.asset(
                                            'assets/lottie/sunrise.json',
                                            height: 50,
                                            width: 50),
                                        Text(
                                          getTranslated('sunrise', context) ??
                                              "Sunrise",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          convertTimeToAmPm(sunrise),
                                          style: TextStyle(
                                              color:
                                                  Colors.indigoAccent.shade700,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 100,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      children: [
                                        Image.asset('assets/lottie/sunset.gif',
                                            height: 50, width: 50),
                                        Text(
                                          getTranslated('sunset', context) ??
                                              "Sunset",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          convertTimeToAmPm(sunset),
                                          style: TextStyle(
                                              color:
                                                  Colors.indigoAccent.shade700,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 100,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                            'assets/lottie/moonrise.gif',
                                            height: 50,
                                            width: 50),
                                        Text(
                                          getTranslated('moonrise', context) ??
                                              "Moonrise",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          convertTimeToAmPm(moonrise),
                                          style: TextStyle(
                                              color:
                                                  Colors.indigoAccent.shade700,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 100,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      children: [
                                        Image.asset('assets/lottie/moonset.gif',
                                            height: 50, width: 50),
                                        Text(
                                          getTranslated('moonset', context) ??
                                              "Moonset",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          convertTimeToAmPm(moonSet),
                                          style: TextStyle(
                                              color:
                                                  Colors.indigoAccent.shade700,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),

                        // Auspicious-Inauspicious Timings Image
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                color: Colors.orange,
                                height: 20,
                                width: 4,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                getTranslated('ausipicous_inauspicious_timing',
                                        context) ??
                                    "Auspicious-Inauspicious Timings",
                                style: TextStyle(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  infoPopup(
                                      context,
                                      isTranslate
                                          ? enAuspiciousInfo
                                          : hiAuspiciousInfo);
                                },
                                icon: const Icon(
                                  Icons.report_gmailerrorred,
                                  color: Colors.orange,
                                ),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 140,
                        //   margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        //   decoration: BoxDecoration(
                        //       borderRadius: const BorderRadius.only(
                        //         topLeft: Radius.circular(10),
                        //         topRight: Radius.circular(10),
                        //       ),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey
                        //               .withOpacity(0.5), // Shadow color
                        //           spreadRadius: 3, // Spread radius
                        //           blurRadius: 5, // Blur radius
                        //         ),
                        //       ],
                        //       image: const DecorationImage(
                        //           image: NetworkImage(
                        //               'https://cdntc.mpanchang.com/mpnc/images/remedy/wednesday_rahu_kaal_timings.jpg'))),
                        // ),

                        // Auspicious-Inauspicious Timings 4 boxes
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 11),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 3, // Spread radius
                                blurRadius: 5, // Blur radius
                                offset:
                                    const Offset(0, 3), // Offset of the shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 10.0),
                                        margin: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.green.shade50,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslated('auspicious_time',
                                                      context) ??
                                                  "Auspicious Time",
                                              style: TextStyle(
                                                  fontSize: h * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                                "$auspiciousStartTime To $auspiciousEndTime",
                                                style: TextStyle(
                                                    fontSize: h * 0.017,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue)),
                                          ],
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 10.0),
                                        margin: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.red.shade50,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslated(
                                                      'gulika_kal', context) ??
                                                  "Gulik kaal",
                                              style: TextStyle(
                                                  fontSize: h * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                                "${convertTimeToAmPm(gulikStartTime)} To ${convertTimeToAmPm(gulikEndTime)}",
                                                style: TextStyle(
                                                    fontSize: h * 0.017,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue)),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 10.0),
                                        margin: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.red.shade50,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslated(
                                                      'rahu_kal', context) ??
                                                  "Rahu kaal",
                                              style: TextStyle(
                                                  fontSize: h * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                                "${convertTimeToAmPm(rahuStartTime)} To ${convertTimeToAmPm(rahuEndTime)}",
                                                style: TextStyle(
                                                    fontSize: h * 0.017,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue)),
                                          ],
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 10.0),
                                        margin: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.red.shade50,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslated('yamghant_kal',
                                                      context) ??
                                                  "Yamghant kaal",
                                              style: TextStyle(
                                                  fontSize: h * 0.024,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                                "${convertTimeToAmPm(yamghantStartTime)} To ${convertTimeToAmPm(yamghantEndTime)}",
                                                style: TextStyle(
                                                    fontSize: h * 0.017,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue)),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //Today Suvichar
                        // const SizedBox(height: 10,),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         color: Colors.orange,
                        //         height: 20,
                        //         width: 4,
                        //       ),
                        //       SizedBox(width: 10),
                        //       Text(
                        //         getTranslated('todays_suvichar', context) ??"Todays Suvichar",
                        //         style: TextStyle(
                        //             fontSize: h * 0.022,
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //       Spacer(),
                        //       Icon(
                        //         Icons.arrow_forward_ios,
                        //         color: Colors.orange,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: [
                        //       SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://feeds.abplive.com/onecms/images/uploaded-images/2022/10/10/fed1da6da79ca8f0cba2aa0c88e14d9e9c40c.jpg",
                        //           height: h * 0.20,
                        //           width: h * 0.35,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://aajkavichar.com/wp-content/uploads/2024/04/%E0%A4%B8%E0%A5%81%E0%A4%B5%E0%A4%BF%E0%A4%9A%E0%A4%BE%E0%A4%B02.png",
                        //           height: h * 0.20,
                        //           width: h * 0.35,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //
                        //       SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjTItEBNKstfX59WkQqEVv7qKnUbXXQv84cJtXJlqo0aec8tJNRMWbwzgn3DhPxun8f2CLq2rqJS3Katx6tVP2cnyfvIyiKaOwIl-oY9GDFHzYzflCYKHIFniJ-DBTcFBOWRDQfUzrV9YEjqy-GCzLA6tfYv84Wy9G88lo40QZpYupbdpbqxXWHxk-xiVGn/s1280/Untitled%20design_20240411_065904_0000.png",
                        //           height: h * 0.20,
                        //           width: h * 0.35,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://feeds.abplive.com/onecms/images/uploaded-images/2022/10/10/fed1da6da79ca8f0cba2aa0c88e14d9e9c40c.jpg",
                        //           height: h * 0.20,
                        //           width: h * 0.35,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        //Today mantr
                        // SizedBox(height: 10,),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         color: Colors.orange,
                        //         height: 20,
                        //         width: 4,
                        //       ),
                        //       SizedBox(width: 10),
                        //       Text(
                        //         "Todays Mantr ",
                        //         style: TextStyle(
                        //             fontSize: h * 0.022,
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //       Spacer(),
                        //       Icon(
                        //         Icons.arrow_forward_ios,
                        //         color: Colors.orange,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        //   padding: EdgeInsets.all(6),
                        //   height: h * 0.40,
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(8.0),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.5), // Shadow color
                        //         spreadRadius: 3, // Spread radius
                        //         blurRadius: 5, // Blur radius
                        //         offset: Offset(0, 3), // Offset of the shadow
                        //       ),
                        //     ],
                        //     image: const DecorationImage(
                        //       image: NetworkImage('https://cdn.dotpe.in/longtail/store-items/7852766/iGVgHH3t.jpeg'), // Your image asset
                        //       fit: BoxFit.cover, // Cover the entire container
                        //     ),
                        //   ),
                        // ),

                        //Today Wallpaper
                        // const SizedBox(height: 10,),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         color: Colors.orange,
                        //         height: 20,
                        //         width: 4,
                        //       ),
                        //       const SizedBox(width: 10),
                        //       Text(
                        //         "Todays Wallpaper",
                        //         style: TextStyle(
                        //             fontSize: h * 0.022,
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //       const Spacer(),
                        //       const Icon(
                        //         Icons.arrow_forward_ios,
                        //         color: Colors.orange,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: [
                        //       const SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://i.pinimg.com/236x/f4/2f/a6/f42fa67c763b0c0fc57866ce8e39d4f2.jpg",
                        //           height: h * 0.35,
                        //           width: h * 0.20,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       const SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://wallpapers.com/images/featured/god-mobile-8zkcu9np2hlivyi6.jpg",
                        //           height: h * 0.35,
                        //           width: h * 0.20,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //
                        //       SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://designguruji.in/wp-content/uploads/2020/07/mahakal1-576x1024.jpg",
                        //           height: h * 0.35,
                        //           width: h * 0.20,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       SizedBox(width: 10,),
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.network("https://wallpapers.com/images/featured/mahadev-hd-pictures-0knnrunxwudvxmoe.jpg",
                        //           height: h * 0.35,
                        //           width: h * 0.20,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        //Today Shubh Karya Muhurat

                        // today Shubh muhurat
                        // SizedBox(height: 15,),
                        // Container(
                        //   color: Colors.cyan.shade50,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
                        //         child: Row(
                        //           children: [
                        //             Container(
                        //               color: Colors.orange,
                        //               height: 20,
                        //               width: 4,
                        //             ),
                        //             const SizedBox(width: 10),
                        //             Text(
                        //               "Today Shubh Karya Muhurat ",
                        //               style: TextStyle(
                        //                   fontSize: h * 0.022,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //             const Spacer(),
                        //             const Icon(
                        //               Icons.report_gmailerrorred,
                        //               color: Colors.orange,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       Row(
                        //         children: [
                        //           Expanded(
                        //             flex:0,
                        //             child: Container(
                        //               margin: const EdgeInsets.all(6.0),
                        //               height: 240,
                        //               width: 150,
                        //               padding: const EdgeInsets.all(10),
                        //               decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(6.0),
                        //                   color: Colors.red.shade50,
                        //                 border: Border.all(color: Colors.grey.shade300,width: 1.5),
                        //                   image: DecorationImage(image: AssetImage("assets/images/shubhmuhurat_Rectangle.png",),fit: BoxFit.cover),
                        //               ),
                        //               child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Spacer(),
                        //                   Center(child: Text("Shubh Karya Muhurat",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),)),
                        //                Spacer(),
                        //                   Container(
                        //                       padding: EdgeInsets.symmetric(vertical: 5),
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: BorderRadius.circular(4.0),
                        //                       color: Colors.orange
                        //                     ),
                        //                       child: Center(child: Text("See All",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: h * 0.022),))
                        //                   ),
                        //                   SizedBox(height: 10,),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //
                        //
                        //           Expanded(
                        //               flex:1,
                        //             child: SizedBox(
                        //               height: 240,
                        //               child: GridView.builder(
                        //                 scrollDirection: Axis.horizontal,
                        //                 shrinkWrap: true,
                        //                 physics: BouncingScrollPhysics(),
                        //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //                   crossAxisCount: 2, // Number of items per row
                        //                   childAspectRatio: 1, // Ratio of item width to height
                        //                 ),
                        //                 itemCount: 8, // Number of items in the grid
                        //                 itemBuilder: (context, index) {
                        //                   return    InkWell(
                        //                     onTap: (){
                        //
                        //                     },
                        //                     child: Container(
                        //                       margin: const EdgeInsets.all(2.0),
                        //                       height: 120,
                        //                       width: 120,
                        //                       padding: const EdgeInsets.all(10),
                        //                       decoration: BoxDecoration(
                        //                           gradient: LinearGradient(
                        //                             colors: [Colors.white24, Colors.red.shade100],
                        //                             begin: Alignment.topLeft,
                        //                             end: Alignment.bottomRight,
                        //                             tileMode: TileMode.mirror,
                        //                           ),
                        //                         border: Border.all(color: Colors.grey.shade300,width: 1.5),
                        //                           borderRadius: BorderRadius.circular(6.0),
                        //                           color: Colors.white
                        //                       ),
                        //                       child: Column(
                        //                         mainAxisAlignment: MainAxisAlignment.center,
                        //                         children: [
                        //                           Image.network("https://www.pngall.com/wp-content/uploads/11/Tuning-Car-PNG-Photo.png",height: 30,),
                        //                           SizedBox(height: 4,),
                        //                           Text("Vehicle Purchase time",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: h * 0.020,fontWeight: FontWeight.bold),),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             ),
                        //           ),
                        //
                        //           const SizedBox(width: 8.0,)
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        //Todays Offers
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(
                                bottom: Dimensions.homePagePadding),
                            child: RecommendedProductWidget()),

                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class ShimmerScreenWdget extends StatelessWidget {
  const ShimmerScreenWdget({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          // Today moon
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            width: double.infinity,
            color: Colors.grey.withOpacity(0.7),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
              child: Column(
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade300,
                            child: Container(
                              height: h * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade300,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade300,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade300,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade300,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade300,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Auspicious Inauspicious
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Shimmer.fromColors(
                baseColor: Colors.grey.shade100,
                highlightColor: Colors.grey.shade300,
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.orange, width: 2),
                            color: Colors.white),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.orange, width: 2),
                            color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.orange, width: 2),
                            color: Colors.white),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        margin: const EdgeInsets.all(3.0),
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.orange, width: 2),
                            color: Colors.white),
                      )),
                ),
              ],
            ),
          ),

          // sunrise sunset
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            width: double.infinity,
            color: Colors.grey.withOpacity(0.7),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
              child: Column(
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400, // Shadow color
                          spreadRadius: 4, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                      baseColor: Colors.grey.shade100,
                                      highlightColor: Colors.grey.shade300,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Shimmer.fromColors(
                                      baseColor: Colors.grey.shade100,
                                      highlightColor: Colors.grey.shade300,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                      baseColor: Colors.grey.shade100,
                                      highlightColor: Colors.grey.shade300,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Shimmer.fromColors(
                                      baseColor: Colors.grey.shade100,
                                      highlightColor: Colors.grey.shade300,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                            const Spacer(),
                            Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Complete Panchang
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
              child: Column(
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade300,
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                  //first contaier
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400, // Shadow color
                          spreadRadius: 4, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 180,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 280,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Divider(
                          color: Colors.red,
                          height: 3,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nakshatra\nShravan",
                                    style: TextStyle(
                                        fontSize: h * 0.018,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Till 8:12 PM",
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 3,
                              height: 80,
                              color: Colors.red.shade100,
                            ),
                            const Spacer(),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Yoga\nSiddh",
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold)),
                                  const Text("Till 1:15 PM",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 3,
                              height: 80,
                              color: Colors.red.shade100,
                            ),
                            const Spacer(),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Karana\nVishti",
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold)),
                                  Text("Till 4:09 PM",
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //second container
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400, // Shadow color
                          spreadRadius: 4, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 160,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Month Amanta",
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Phalguna",
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 3,
                              height: 80,
                              color: Colors.red.shade100,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 160,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Month Purnimata",
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold)),
                                    Text("Chaitra",
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          color: Colors.lightBlueAccent,
                          height: 3,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 160,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Vikram Samvat",
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("2080 (Nal)",
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 3,
                              height: 80,
                              color: Colors.red.shade100,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 160,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Shaka Samvat",
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold)),
                                    Text("1945 (Shobhan)",
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
