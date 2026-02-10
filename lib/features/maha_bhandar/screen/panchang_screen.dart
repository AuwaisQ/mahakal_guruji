import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/auth/controllers/auth_controller.dart';
import 'package:mahakal/features/checkout/widgets/shipping_details_widget.dart';
import 'package:mahakal/features/maha_bhandar/screen/share_panchang.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../localization/language_constrants.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../../utill/dimensions.dart';
import '../../infopage/infopageview.dart';
import '../model/city_model.dart';
import '../model/festival_model.dart';
import '../model/shubh_muhrt_model.dart';
import '../model/specialmuhurat_model.dart';
import '../model/today_muhurat_model.dart';
import 'fast_&_festival_widget/fast_festival_details.dart';

class PanchangScreen extends StatefulWidget {
  final String? localityName;
  final String? default_lat;
  final String? default_long;
  const PanchangScreen(
      {super.key,
      this.localityName,
      this.default_lat,
      this.default_long});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  DateTime today = DateTime.now();
  String countryDefault = 'Ujjain/Madhya Pradesh';
  final Country selectedCountry = Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India',
    displayNameNoCountryCode: 'India',
    e164Key: '91-IN-0',
  );
  DateTime now = DateTime.now();
  DateTime todayDate = DateTime.now();
  int dainikCount = 0;
  bool shimmerscreenDate = false;
  bool isMasikDialog = false;
  bool isTranslate = false;
  String latitude = '23.179300';
  String longitude = '75.784912';
  String tithiName = '';
  String tithiEndTime = '';
  String sunrise = '';
  String sunset = '';
  String moonrise = '';
  String moonSet = '';
  String hinduMonthName = '';
  String season = '';
  String vikramSamvatName = '';
  String day = '';
  String special = '';
  String nakshatraName = '';
  String nakshatraTime = '';
  String yogaName = '';
  String yogaTime = '';
  String karanaName = '';
  String karanaTime = '';
  String monthAmanta = '';
  String monthPurnima = '';
  String shakaSamvatName = '';
  String shakaSamvatTime = '';
  String sunSign = '';
  String moonSign = '';
  String dishaShool = '';
  String moonPlacement = '';
  String ayana = '';
  String auspiciousStartTime = '';
  String auspiciousEndTime = '';
  String gulikStartTime = '';
  String gulikEndTime = '';
  String rahuStartTime = '';
  String rahuEndTime = '';
  String yamghantStartTime = '';
  String yamghantEndTime = '';
  int vikramSamvatTime = 0;

  //Masik Dialog var
  String masikTithiName = '';
  String masikDay = '';
  String masikTithiEndTime = '';
  String masikHinduMonthName = '';
  String masikSeason = '';
  String masikVikramSamvatName = '';
  String translateMoonImage = 'hi_name';
  String moonImage = '';
  String locationMessage = '';
  String addressMessage = '';
  int masikVikramSamvatTime = 0;

  String enPanchangInfo =
      'Sampurn Panchang is a comprehensive Hindu calendar that provides detailed astrological and astronomical information including daily lunar phases, planetary positions, auspicious times (muhurats) and religious events. It serves as a guide for scheduling celebrations.';
  String hiPanchangInfo =
      'सम्पूर्ण पंचांग एक व्यापक हिंदू कैलेंडर है जो दैनिक चंद्र चरणों, ग्रहों की स्थिति, शुभ समय (मुहूर्त) और धार्मिक आयोजनों सहित विस्तृत ज्योतिषीय और खगोलीय जानकारी प्रदान करता है। यह खगोलीय प्रभावों और परंपराओं के साथ जुड़े समारोहों, त्योहारों और दैनिक गतिविधियों को शेड्यूल करने के लिए एक मार्गदर्शक के रूप में कार्य करता है।';
  String enAuspiciousInfo =
      'Shubh Muhurat is also called Abhijeet Muhurat, in which auspicious works are done. If you are unable to do auspicious work in Shubh Muhurat, then you can do it in Gulikaal. However, the possibility of repeating the work done in Gulikaal increases. Rahukaal and Yamghantakal are inauspicious times in which no auspicious work is done.';
  String hiAuspiciousInfo =
      'शुभ मुहूर्त को अभिजीत मुहूर्त भी कहते है, जिसमें शुभ कार्य किए जाते हैं। अगर शुभ मुहूर्त में शुभ कार्य नहीं कर पाएं तो गुलिकाल में कर सकते हैं। हालांकि गुलिकाल में किए गए कार्य की दोबारा होने की सम्भावना बढ़ जाती है। राहुकाल और यमघण्टकाल अशुभ समय है जिसमें कोई भी शुभ कार्य नहीं किए जाते हैं।';
  String enSunsetInfo =
      'Sunrise and sunset represent the daily appearance and disappearance of the Sun, while moonrise and moonset represent the appearance and disappearance of the Moon, which is important for timekeeping and cultural practices.';
  String hiSunsetInfo =
      'सूर्योदय और सूर्यास्त सूर्य के दैनिक रूप से प्रकट होने और लुप्त होने को दर्शाते हैं, जबकि चंद्रोदय और चंद्रास्त चंद्रमा के दिखाई देने और लुप्त होने को दर्शाते हैं, जो समय की गणना और सांस्कृतिक प्रथाओं के लिए महत्वपूर्ण है।';

  //Fast,Festival,Shubh Muhurt List's
  var fastData = <FestivalModel>[];
  var festivalData = <FestivalModel>[];
  var festivalList = <FestivalModel>[];
  var fastList = <FestivalModel>[];
  var muhurtList = <ShubhMuhratModel>[];
  var specialMuhuratList = <Specialmuhurat>[];

  late YoutubePlayerController youtubePlayerController;
  late YoutubeMetaData videoMetaData;

  String separateDate(String dateString) {
    // Split the string by the comma and space
    List<String> parts = dateString.split(', ');

    // Ensure the input is in the correct format
    if (parts.length != 2) {
      throw const FormatException(
          "Invalid date string format. Expected format: 'Day, DD-MM-YYYY'");
    }
    String date = parts[1];

    return date;
  }

  String separateDay(String dateString) {
    // Split the string by the comma and space
    List<String> parts = dateString.split(', ');

    // Ensure the input is in the correct format
    if (parts.length != 2) {
      throw const FormatException(
          "Invalid date string format. Expected format: 'Day, DD-MM-YYYY'");
    }
    String day = parts[0];
    return day;
  }

  void updateState() {
    setState(() {
      isOrange = true;
    });
  }

  void goToNextDate() {
    setState(() {
      now = now.add(const Duration(days: 1));
      panchangData();
      getMuhuratData();
      getSpecialMuhurat();
      dainikCount++;
    });
    print(dainikCount);
  }

  void goToPreviousDate() {
    setState(() {
      if (now.isAfter(todayDate)) {
        now = now.subtract(const Duration(days: 1));
        panchangData();
        getMuhuratData();
        getSpecialMuhurat();
        dainikCount--;
      }
    });
    print(dainikCount);
  }

  Future<void> showShimmer() async {
    await Future.delayed(const Duration(
      seconds: 2,
    ));
    setState(() {
      shimmerscreenDate = false;
    });
  }

  String convertTimeToAmPm(String time) {
    // Parse the time string into a DateTime object
    final dateTime = DateFormat('HH:mm:ss').parse(time);
    // Format the DateTime object into an AM/PM time string
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  Future panchangData() async {
    print('Translate Value-$isTranslate');
    print("Date:${DateFormat('dd/MM/yyyy').format(now)}");
    print("Time:${DateFormat('HH:mm').format(now)}");
    var monthName = DateFormat('MMMM').format(now);

    final panchangRequestBody = {
      'date': DateFormat('dd/MM/yyyy').format(now),
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
          '${AppConstants.monthlyFestival}?type=Vrat&year=${now.year}&month=${now.month}&day=${now.day}'),
      HttpService().getApi(
          '${AppConstants.monthlyFestival}?type=Festival&year=${now.year}&month=${now.month}&day=${now.day}'),
      HttpService().getApi(
          '${AppConstants.monthlyFestival}?type=Vrat&year=${now.year}&month=${now.month}'),
      HttpService().getApi(
          '${AppConstants.monthlyFestival}?type=Festival&year=${now.year}&month=${now.month}'),
      HttpService().getApi(
          '${AppConstants.shubhMuhrt}?year=${now.year}&month=$monthName&day=${now.day}'),
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

    print('Panchang Data:$res');
    print('Festival data:$res');
    print('Fast data:$res');

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
        ? translateMoonImage = 'en_name'
        : translateMoonImage = 'hi_name';

    // Find the matching tithi name and set the image
    final tithiList = tithiImageResponse['data'] as List<dynamic>;
    final matchedTithi = tithiList.firstWhere(
        (tithi) => tithi[translateMoonImage] == tithiName,
        orElse: () => null);
    if (matchedTithi != null) {
      moonImage = matchedTithi['image'];
    }
    shimmerscreenDate = false;
    setState(() {});
  }

  void onDaySelect(DateTime day, DateTime focusedDay) {
    double h = MediaQuery.of(context).size.height;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetter) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.black45,
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isMasikDialog
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        )
                      : Material(
                          child: Container(
                            padding: const EdgeInsets.all(10),
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
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${AppConstants.baseUrl}/storage/app/public/panchang-moon-img/$moonImage',
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
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
                                          Text(
                                            masikTithiName,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Till ${convertTimeToAmPm(tithiEndTime)}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "$masikHinduMonthName ${getTranslated('month', context) ?? 'Month'}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '$masikSeason, $masikVikramSamvatName $masikVikramSamvatTime',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    modalSetter(() {
                                      now = day;
                                      panchangData();
                                    });
                                    updateState();
                                    getMuhuratData();
                                    getSpecialMuhurat();
                                  },
                                  child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade100
                                                .withOpacity(
                                                    0.1), // Shadow color
                                            spreadRadius: 1, // Spread radius
                                            blurRadius: 2, // Blur radius
                                            offset: const Offset(
                                                0, 3), // Offset of the shadow
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                          child: Text(
                                        'See Daily Panchang',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ))),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future maskikDialogData() async {
    setState(() {
      isMasikDialog = true;
      onDaySelect(today, today);
    });
    var res = await HttpService().postApi(AppConstants.panchangUrl, {
      'date': DateFormat('dd/MM/yyyy').format(today),
      'time': DateFormat('HH:mm').format(today),
      'latitude': latitude,
      'longitude': longitude,
      'timezone': '5.5',
      'language': isTranslate ? 'en' : 'hi',
    });
    print('Panchang Data:$res');
    masikTithiName = res['panchang']['tithi']['details']['tithi_name'];
    masikDay = res['panchang']['day'];
    masikTithiEndTime =
        "${res['panchang']['tithi']['end_time']['hour']}:${res['panchang']['tithi']['end_time']['minute']}:${res['panchang']['tithi']['end_time']['second']}";
    masikHinduMonthName = res['panchang']['hindu_maah']['purnimanta'];
    masikSeason = res['panchang']['ritu'];
    masikVikramSamvatName = res['panchang']['vkram_samvat_name'];
    masikVikramSamvatTime = res['panchang']['vikram_samvat'];
    setState(() {
      isMasikDialog = false;
      Navigator.pop(context);

      onDaySelect(today, today);
    });
  }

  List<Muhurat> muhuratModelList = <Muhurat>[];

  String getResponse(String input) {
    switch (input.toLowerCase()) {
      case 'marriage':
        return 'assets/testImage/panchangImages/images/Marriage.png';

      case 'property purchase':
        return 'assets/testImage/panchangImages/images/property_purchase.png';

      case 'namkaran':
        return 'assets/testImage/panchangImages/images/Naamkaran.png';

      case 'vehicle purchase':
        return 'assets/testImage/panchangImages/images/vehical_purchase.png';

      case 'karnavedha':
        return 'assets/testImage/panchangImages/images/Karnavedha.png';

      case 'mundan':
        return 'assets/testImage/panchangImages/images/Mundan.png';

      case 'anna prashan':
        return 'assets/testImage/panchangImages/images/Anna_prashan.png';

      case 'Vidyarambh':
        return 'assets/testImage/panchangImages/images/vidyarambh.png';

      case 'grah pravesh':
        return 'assets/testImage/panchangImages/images/Grah_pravesh.png';

      default:
        return 'assets/testImage/panchangImages/images/Grah_pravesh.png';
    }
  }

  void getMuhuratData() async {
    var res = await HttpService().getApi(
        '${AppConstants.shubhMuhrt}?year=${now.year}&month=${DateFormat.MMMM().format(now)}&day=${now.day}');
    setState(() {
      muhuratModelList.clear();
      // Ensure muhuratList is always a List
      List muhuratList = [];
      if (res['data'] is List) {
        muhuratList = res['data'];
      } else if (res['data'] != null) {
        // If data is not a list but not null, try to wrap it
        muhuratList = [res['data']];
      }
      muhuratModelList.addAll(muhuratList.map((e) => Muhurat.fromJson(e)));
    });
    print(res);
  }

  void getSpecialMuhurat() async {
    try {
      final res = await HttpService().getApi(
        '${AppConstants.specialMahuratUrl}?year=${now.year}&month=${DateFormat.MMMM().format(now)}&day=${now.day}&type=special',
      );

      print('Api Special Muhurat $res');

      if (res != null && res['status'] == true && res['data'] is List) {
        List specialList = res['data'];
        setState(() {
          specialMuhuratList.clear();
          specialMuhuratList.addAll(
            specialList.map((e) => Specialmuhurat.fromJson(e)),
          );
        });
      } else {
        // Handle empty or error response
        setState(() {
          specialMuhuratList.clear();
        });
        print('No muhurat found or data is not a list');
      }
    } catch (e) {
      print('Error in getSpecialMuhurat: $e');
      setState(() {
        specialMuhuratList.clear();
      });
    }
  }

  void infoSheet(
    String title,
    String date,
    String muhurt,
    String nakshatra,
    String tithi,
    String image,
  ) {
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
                      '✤ ${title.capitalize()} ✤',
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
                    '⦿ Date:',
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
                    '⦿ Muhurt:',
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
                    '⦿ Nakshatra:',
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
                    '⦿ Tithi:',
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

  int tabcountIndex = 0;

  bool isOrange = true;

  @override
  void initState() {
    // getLocation();
    panchangData();
    getMuhuratData();
    getSpecialMuhurat();
    latitude = Provider.of<AuthController>(Get.context!, listen: false).latitude.toString();
    longitude = Provider.of<AuthController>(Get.context!, listen: false).longitude.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    return RefreshIndicator(
      color: Colors.orange,
      displacement: 70,
      onRefresh: () async {
        panchangData();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(flex: 0, child: SizedBox(height: w * 0.21)),

            //Location Button

            Expanded(
              flex: 0,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 2,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isOrange == true
                                    ? 'Daily Panchang'
                                    : 'Monthly Panchang',
                                style: TextStyle(
                                    fontSize: h * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    locationSheet(
                                        context, selectedCountry.name);
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Text(
                                      countryDefault,
                                      style: TextStyle(
                                          color: Colors.orange,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: h * 0.02,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end,
                                    ),
                                  )),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.orange,
                                size: 15,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  //Dainik&Masik Button
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 10.0),
                    padding: const EdgeInsets.all(2.0),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isOrange = true; // Switch to first tab
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInCirc,
                              width: isOrange ? 200.0 : 0.0,
                              height: isOrange ? 40.0 : 30.0,
                              decoration: BoxDecoration(
                                color: isOrange
                                    ? Colors.orange
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              alignment: isOrange
                                  ? Alignment.center
                                  : Alignment.topRight,
                              child: Center(
                                child: Text(
                                  'Dainik',
                                  style: TextStyle(
                                      fontSize: h * 0.020,
                                      color: isOrange
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: isOrange
                                          ? FontWeight.bold
                                          : FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Tab 2
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isOrange = false; // Switch to first tab
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInCirc,
                              width: isOrange ? 0.0 : 200.0,
                              height: isOrange ? 30.0 : 40.0,
                              decoration: BoxDecoration(
                                color: isOrange
                                    ? Colors.transparent
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              alignment: isOrange
                                  ? Alignment.topRight
                                  : Alignment.center,
                              child: Center(
                                child: Text(
                                  'Masik',
                                  style: TextStyle(
                                      fontSize: h * 0.020,
                                      color: isOrange
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: isOrange
                                          ? FontWeight.w400
                                          : FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Daily panchang
                  isOrange
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      now = todayDate;
                                      panchangData();
                                      dainikCount = 0;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(3.0),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: Colors.orange, width: 2),
                                        color: dainikCount == 0
                                            ? Colors.orange
                                            : Colors.white),
                                    child: Center(
                                        child: Text(
                                      'Dainik',
                                      style: TextStyle(
                                          fontSize: h * 0.020,
                                          color: dainikCount == 0
                                              ? Colors.white
                                              : Colors.black),
                                    )),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    goToPreviousDate();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(3.0),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: Colors.orange, width: 2)),
                                    child: const Center(
                                        child: Icon(Icons.keyboard_arrow_left)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isOrange = false; // Switch to first tab
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(3.0),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: Colors.orange, width: 2)),
                                    child: Center(
                                        child: Text(formattedDate,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: h * 0.020,
                                            ))),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    goToNextDate();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(3.0),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: Colors.orange, width: 2)),
                                    child: const Center(
                                        child:
                                            Icon(Icons.keyboard_arrow_right)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              //Language Button
                              BouncingWidgetInOut(
                                onPressed: () {
                                  setState(() {
                                    isTranslate = !isTranslate;
                                    isTranslate
                                        ? translateMoonImage = 'en_name'
                                        : translateMoonImage = 'hi_name';
                                    panchangData();
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 7),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: isTranslate
                                          ? Colors.orange
                                          : Colors.transparent,
                                      border: Border.all(
                                          color: isTranslate
                                              ? Colors.transparent
                                              : Colors.orange,
                                          width: 2)),
                                  child: Icon(
                                    Icons.translate,
                                    color: isTranslate
                                        ? Colors.white
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),

            Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: isOrange == true ? danikScreen() : masikScreen(),
                ))
          ],
        ),
      ),
    );
  }

  Widget danikScreen() {
    double h = MediaQuery.of(context).size.height;
    String moonDate = DateFormat('dd-MMMM-yyyy').format(now);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (shimmerscreenDate)
            const ShimmerScreenWdget()
          else
            Column(
              children: [
                // Today moon
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  width: double.infinity,
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.sunny,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$moonDate (Today Moon)',
                              style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SharePachangScreen(
                                  formattedDate:
                                      DateFormat('dd/MM/yyyy').format(now),
                                  day: '${now.day}',
                                  month: DateFormat.MMMM().format(now),
                                  year: '${now.year}',
                                  fastData: fastData,
                                  festivalData: festivalData,
                                  muhuratModelList: muhuratModelList,
                                  late: latitude,
                                  long: longitude,
                                  location: countryDefault,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 8),
                            padding: const EdgeInsets.all(10),
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
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: h * 0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${AppConstants.baseUrl}${AppConstants.moonImagePathURL}$moonImage',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            tithiName,
                                            style: TextStyle(
                                                fontSize: h * 0.024,
                                                fontWeight: FontWeight.bold),
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
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(now),
                                                    day: '${now.day}',
                                                    month: DateFormat.MMMM()
                                                        .format(now),
                                                    year: '${now.day}',
                                                    fastData: fastData,
                                                    festivalData: festivalData,
                                                    muhuratModelList:
                                                        muhuratModelList,
                                                    late: latitude,
                                                    long: longitude,
                                                    location: countryDefault,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 0.5),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.08),
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
                                          //   onTap: () {
                                          //     // Your navigation code
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        isTranslate
                                            ? 'Till ${convertTimeToAmPm(tithiEndTime)}'
                                            : '${convertTimeToAmPm(tithiEndTime)} बजे तक',
                                        style: TextStyle(
                                            fontSize: h * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "$hinduMonthName ${getTranslated('month', context) ?? 'Month'}",
                                        style: TextStyle(
                                            fontSize: h * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        '$season, $vikramSamvatName $vikramSamvatTime',
                                        style: TextStyle(
                                            fontSize: h * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 3, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: const Offset(0, 3), // Offset of the shadow
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
                            const SizedBox(width: 5),
                            Text(
                              getTranslated('fast', context) ?? 'Fast',
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
                        child: fastData.isEmpty
                            ? Text(
                                isTranslate
                                    ? '---- No Fast Today ----'
                                    : '---- आज कोई व्रत नहीं है ----',
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
                                                        title: fastData[index]
                                                            .eventName,
                                                        hiDescription:
                                                            fastData[index]
                                                                .hiDescription,
                                                        enDescription:
                                                            fastData[index]
                                                                .enDescription,
                                                        image: fastData[index]
                                                            .image,
                                                      ),
                                                      pageAnimationType:
                                                          RightToLeftTransition()));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              child: Chip(
                                                label: Text(
                                                  fastData[index].eventName,
                                                  style: TextStyle(
                                                    fontSize: h * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                backgroundColor: Colors.orange
                                                    .withOpacity(0.1),
                                                shape: const StadiumBorder(
                                                  side: BorderSide(
                                                    color: Colors.orange,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        child: Row(
                          children: [
                            Container(
                              color: Colors.orange,
                              height: 20,
                              width: 4,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              getTranslated('festival', context) ?? 'Festival',
                              style: TextStyle(
                                  fontSize: h * 0.019,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        child: festivalData.isEmpty
                            ? Text(
                                isTranslate
                                    ? '---- No Festival Today ----'
                                    : '---- आज कोई त्यौहार नहीं है ----',
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
                                                        title:
                                                            festivalData[index]
                                                                .eventName,
                                                        hiDescription:
                                                            festivalData[index]
                                                                .hiDescription,
                                                        enDescription:
                                                            festivalData[index]
                                                                .enDescription,
                                                        image:
                                                            festivalData[index]
                                                                .image,
                                                      ),
                                                      pageAnimationType:
                                                          RightToLeftTransition()));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              child: Chip(
                                                label: Text(
                                                  festivalData[index].eventName,
                                                  style: TextStyle(
                                                    fontSize: h * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                backgroundColor: Colors.orange
                                                    .withOpacity(0.1),
                                                shape: const StadiumBorder(
                                                  side: BorderSide(
                                                    color: Colors.orange,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
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
                            const SizedBox(width: 5),
                            Text(
                              getTranslated('shubh_muhurt', context) ?? 'Fast',
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
                        child: muhuratModelList.isEmpty
                            ? Text(
                                isTranslate
                                    ? '---- No Muhurat Today ----'
                                    : '---- आज कोई मुहुर्त नहीं है ----',
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
                                                  muhuratModelList[index].type,
                                                  muhuratModelList[index]
                                                      .titleLink,
                                                  muhuratModelList[index]
                                                      .muhurat,
                                                  muhuratModelList[index]
                                                      .nakshatra,
                                                  muhuratModelList[index].tithi,
                                                  getResponse(
                                                      muhuratModelList[index]
                                                          .type));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              child: Chip(
                                                label: Text(
                                                  muhuratModelList[index]
                                                      .type
                                                      .capitalize(),
                                                  style: TextStyle(
                                                    fontSize: h * 0.018,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                backgroundColor: Colors.orange
                                                    .withOpacity(0.1),
                                                shape: const StadiumBorder(
                                                  side: BorderSide(
                                                    color: Colors.orange,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                      ),
                      specialMuhuratList.isEmpty
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  color: Colors.grey.shade300,
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
                                      const SizedBox(width: 5),
                                      Text(
                                        getTranslated(
                                                'special_muhurat', context) ??
                                            'Special Muhurat',
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
                                  child: specialMuhuratList.isEmpty
                                      ? Text(
                                          isTranslate
                                              ? '---- No Muhurat Today ----'
                                              : '---- आज कोई मुहुर्त नहीं है ----',
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
                                                specialMuhuratList.length,
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
                                                                    .type));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    2.0),
                                                        child: Chip(
                                                          label: Text(
                                                            specialMuhuratList[
                                                                    index]
                                                                .message,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  h * 0.018,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.orange
                                                                  .withOpacity(
                                                                      0.1),
                                                          shape:
                                                              const StadiumBorder(
                                                            side: BorderSide(
                                                              color: Colors.red,
                                                              width: 2,
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

                // Auspicious-Inauspicious Timings 4 boxes
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.orange,
                        height: 20,
                        width: 4,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Auspicious-Inauspicious Timings',
                        style: TextStyle(
                            fontSize: h * 0.02, fontWeight: FontWeight.bold),
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

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   child: SizedBox(
                //       child: ClipRRect(
                //           borderRadius: BorderRadius.circular(10),
                //           child: Image.network(
                //             "https://cdntc.mpanchang.com/mpnc/images/remedy/wednesday_rahu_kaal_timings.jpg",
                //             fit: BoxFit.fill,
                //             height: 140,
                //           ))),
                // ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 11),
                  padding: const EdgeInsets.symmetric(vertical: 5),
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
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.green.shade50,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated(
                                              'auspicious_time', context) ??
                                          'Auspicious Time',
                                      style: TextStyle(
                                          fontSize: h * 0.022,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                        '$auspiciousStartTime To $auspiciousEndTime',
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
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.red.shade50,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Gulik kaal',
                                      style: TextStyle(
                                          fontSize: h * 0.024,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                        '${convertTimeToAmPm(gulikStartTime)} To ${convertTimeToAmPm(gulikEndTime)}',
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
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.red.shade50,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Rahu kaal',
                                      style: TextStyle(
                                          fontSize: h * 0.024,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                        '${convertTimeToAmPm(rahuStartTime)} To ${convertTimeToAmPm(rahuEndTime)}',
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
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.red.shade50,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Yamghant kaal',
                                      style: TextStyle(
                                          fontSize: h * 0.024,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                        '${convertTimeToAmPm(yamghantStartTime)} To ${convertTimeToAmPm(yamghantEndTime)}',
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
                const SizedBox(height: 20),

                // sunrise sunset
                Container(
                  width: double.infinity,
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.horizontal_distribute,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Sunrise-Sunset',
                              style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                infoPopup(context,
                                    isTranslate ? enSunsetInfo : hiSunsetInfo);
                              },
                              icon: const Icon(
                                Icons.report_gmailerrorred,
                                color: Colors.orange,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
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
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.sunny,
                                                color: Colors.orange),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Sunrise',
                                              style: TextStyle(
                                                  fontSize: h * 0.02,
                                                  color: Colors.black),
                                            ),
                                            const Spacer(),
                                            Text(
                                              convertTimeToAmPm(sunrise),
                                              style: TextStyle(
                                                  fontSize: h * 0.02,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.sunny_snowing,
                                                color: Colors.orange),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Sunset',
                                              style: TextStyle(
                                                  fontSize: h * 0.02,
                                                  color: Colors.black),
                                            ),
                                            const Spacer(),
                                            Text(
                                              convertTimeToAmPm(sunset),
                                              style: TextStyle(
                                                  fontSize: h * 0.02,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Lottie.asset(
                                          'assets/lottie/sunrise.json'),
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
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/lottie/moonrise.gif'),
                                          fit: BoxFit
                                              .cover, // You can adjust the fit as needed
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
                                            const Icon(Icons.dark_mode,
                                                color: Colors.orange),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Moonrise',
                                              style: TextStyle(
                                                fontSize: h * 0.02,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              convertTimeToAmPm(moonrise),
                                              style: TextStyle(
                                                  fontSize: h * 0.02,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.circle,
                                                color: Colors.orange),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Moonset',
                                              style: TextStyle(
                                                  fontSize: h * 0.02,
                                                  color: Colors.black),
                                            ),
                                            const Spacer(),
                                            Text(
                                              convertTimeToAmPm(moonSet),
                                              style: TextStyle(
                                                  fontSize: h * 0.02,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
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
                                  Text(
                                    'Sun Sign: Pisces',
                                    style: TextStyle(
                                        fontSize: h * 0.018,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Moon Sign: Capricorn',
                                    style: TextStyle(
                                        fontSize: h * 0.018,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Complete Panchang
                Container(
                  width: double.infinity,
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.horizontal_distribute,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Complete Panchang',
                              style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                infoPopup(
                                    context,
                                    isTranslate
                                        ? enPanchangInfo
                                        : hiPanchangInfo);
                              },
                              icon: const Icon(
                                Icons.report_gmailerrorred,
                                color: Colors.orange,
                              ),
                            )
                          ],
                        ),
                        //first contaier
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
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
                                offset:
                                    const Offset(0, 3), // Offset of the shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      '$tithiName ($special) ${convertTimeToAmPm(tithiEndTime)} till',
                                      style: TextStyle(
                                        fontSize: h * 0.02,
                                      )),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Divider(
                                  color: Colors.red,
                                  height: 3,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Nakshatra'),
                                      Text(
                                        nakshatraName,
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(convertTimeToAmPm(nakshatraTime),
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                    ],
                                  ),
                                  Container(
                                    width: 3,
                                    height: 80,
                                    color: Colors.red.shade100,
                                  ),
                                  Column(
                                    children: [
                                      const Text('Yog'),
                                      Text(
                                        yogaName,
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(convertTimeToAmPm(yogaTime),
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                    ],
                                  ),
                                  Container(
                                    width: 3,
                                    height: 80,
                                    color: Colors.red.shade100,
                                  ),
                                  Column(
                                    children: [
                                      const Text('karna'),
                                      Text(
                                        karanaName,
                                        style: TextStyle(
                                            fontSize: h * 0.018,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(convertTimeToAmPm(karanaTime),
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //second container
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
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
                                offset:
                                    const Offset(0, 3), // Offset of the shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Month Amanta',
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(monthAmanta,
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
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Month Purnimata',
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold)),
                                        Text(monthPurnima,
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                      ],
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Vikram Samvat',
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '$vikramSamvatTime ($vikramSamvatName)',
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
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Shaka Samvat',
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '$shakaSamvatTime ($shakaSamvatName)',
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

                        //Third container
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
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
                                offset:
                                    const Offset(0, 3), // Offset of the shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sun Sign',
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(sunSign,
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
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Moon Sign',
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold)),
                                        Text(moonSign,
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                color: Colors.green,
                                height: 3,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Dishashool',
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(dishaShool,
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
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Moon Placement',
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold)),
                                        Text(moonPlacement,
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                color: Colors.green,
                                height: 3,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Season',
                                          style: TextStyle(
                                              fontSize: h * 0.018,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(season,
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
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Ayana',
                                            style: TextStyle(
                                                fontSize: h * 0.018,
                                                fontWeight: FontWeight.bold)),
                                        Text(ayana,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget masikScreen() {
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Today moon
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 0.5),
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.orange.shade50,
                ),
                child: TableCalendar(
                  locale: 'en_US',
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.orange),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.orange),
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.orange),
                    defaultTextStyle: TextStyle(color: Colors.black),
                    outsideDaysVisible: false,
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.orange),
                    weekdayStyle: TextStyle(color: Colors.black),
                  ),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  focusedDay: today,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  onPageChanged: (DateTime day) {
                    print('OnPageChange-$day');
                    setState(() {
                      today = day;
                      now = day;
                      panchangData();
                    });
                  },
                  onDaySelected: (DateTime day, DateTime focusedDay) {
                    setState(() {
                      print(day);
                      today = day;
                      maskikDialogData();
                    });
                  },
                )),
          ),

          //Festivals of April 2024
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    tabcountIndex = 0;
                  });
                },
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: tabcountIndex == 0
                              ? Colors.orange
                              : Colors.transparent, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: tabcountIndex == 0 ? Colors.orange : Colors.grey,
                        fontSize: tabcountIndex == 0 ? 20 : 15,
                        fontWeight: tabcountIndex == 0
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      child: const Text('Festival'),
                    )),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    tabcountIndex = 1;
                  });
                },
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: tabcountIndex == 1
                              ? Colors.orange
                              : Colors.transparent, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: tabcountIndex == 1 ? Colors.orange : Colors.grey,
                        fontSize: tabcountIndex == 1 ? 20 : 15,
                        fontWeight: tabcountIndex == 1
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      child: const Text('Fast'),
                    )),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    tabcountIndex = 2;
                  });
                },
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: tabcountIndex == 2
                              ? Colors.orange
                              : Colors.transparent, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: tabcountIndex == 2 ? Colors.orange : Colors.grey,
                        fontSize: tabcountIndex == 2 ? 20 : 15,
                        fontWeight: tabcountIndex == 2
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      child: const Text('Muhurt'),
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),

          //Festival
          if (tabcountIndex == 0)
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: festivalList.length, // Number of items in the list
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageAnimationTransition(
                                page: FastFestivalsDetails(
                                  title: festivalList[index].eventName,
                                  hiDescription:
                                      festivalList[index].hiDescription,
                                  enDescription:
                                      festivalList[index].enDescription,
                                  image: festivalList[index].image,
                                ),
                                pageAnimationType: RightToLeftTransition()));
                        // detailSheet(
                        //   context,
                        //   festivalList[index].eventName,
                        //   festivalList[index].image,
                        //   festivalList[index].hiDescription,
                        //   festivalList[index].enDescription,
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    separateDate(festivalList[index].eventDate)
                                                .length >
                                            5
                                        ? separateDate(
                                                festivalList[index].eventDate)
                                            .substring(0, 2)
                                        : separateDate(
                                            festivalList[index].eventDate),
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    separateDay(festivalList[index].eventDate),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      isTranslate
                                          ? festivalList[index].eventName
                                          : festivalList[index].eventNameHi,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      separateDate(
                                          festivalList[index].eventDate),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: CachedNetworkImage(
                                  imageUrl: festivalList[index].image,
                                  height: 60,
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          else
            tabcountIndex == 1
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            fastList.length, // Number of items in the list
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageAnimationTransition(
                                      page: FastFestivalsDetails(
                                        title: fastList[index].eventName,
                                        hiDescription:
                                            fastList[index].hiDescription,
                                        enDescription:
                                            fastList[index].enDescription,
                                        image: fastList[index].image,
                                      ),
                                      pageAnimationType:
                                          RightToLeftTransition()));
                              // detailSheet(
                              //   context,
                              //   fastList[index].eventName,
                              //   fastList[index].image,
                              //   festivalList[index].hiDescription,
                              //   festivalList[index].enDescription,
                              // );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          separateDate(fastList[index]
                                                          .eventDate)
                                                      .length >
                                                  5
                                              ? separateDate(
                                                      fastList[index].eventDate)
                                                  .substring(0, 2)
                                              : separateDate(
                                                  fastList[index].eventDate),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          separateDay(
                                              fastList[index].eventDate),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            isTranslate
                                                ? fastList[index].eventName
                                                : fastList[index].eventNameHi,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            separateDate(
                                                fastList[index].eventDate),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: CachedNetworkImage(
                                        imageUrl: fastList[index].image,
                                        height: 70,
                                        fit: BoxFit.fill,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : tabcountIndex == 2
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: muhurtList
                                .length, // Number of items in the list
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  infoSheet(
                                      muhuratModelList[index].type,
                                      muhuratModelList[index].titleLink,
                                      muhuratModelList[index].muhurat,
                                      muhuratModelList[index].nakshatra,
                                      muhuratModelList[index].tithi,
                                      getResponse(
                                          muhuratModelList[index].type));
                                },
                                child: ListTile(
                                  title: Text(
                                    muhurtList[index].type!,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(muhurtList[index].titleLink!),
                                  trailing: const Icon(
                                      Icons.arrow_circle_right_outlined),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void locationSheet(BuildContext context, String selectedCountry) {
    final TextEditingController countryController = TextEditingController();
    List<CityPickerModel> citylistdata = <CityPickerModel>[];

    void getCityPick(StateSetter modalSetter) async {
      List<CityPickerModel> citypicket = [];
      var response = await http.post(
        Uri.parse('https://geo.vedicrishi.in/places/'),
        body: {
          'country': selectedCountry,
          'name': countryController.text,
        },
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print('Api response $result');
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
                                  print('Latitude:$latitude');
                                  print('Longitude:$longitude');
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
}

class ShimmerScreenWdget extends StatelessWidget {
  const ShimmerScreenWdget({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Column(
      children: [
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
                          width: 220,
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
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
        const SizedBox(
          height: 10,
        ),
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
                          width: 220,
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
                                      borderRadius: BorderRadius.circular(100),
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
                                      borderRadius: BorderRadius.circular(100),
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
                                      borderRadius: BorderRadius.circular(100),
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
                                      borderRadius: BorderRadius.circular(100),
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
                                  'Nakshatra\nShravan',
                                  style: TextStyle(
                                      fontSize: h * 0.018,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Till 8:12 PM',
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
                                Text('Yoga\nSiddh',
                                    style: TextStyle(
                                        fontSize: h * 0.018,
                                        fontWeight: FontWeight.bold)),
                                const Text('Till 1:15 PM',
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
                                Text('Karana\nVishti',
                                    style: TextStyle(
                                        fontSize: h * 0.018,
                                        fontWeight: FontWeight.bold)),
                                Text('Till 4:09 PM',
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
                                    'Month Amanta',
                                    style: TextStyle(
                                        fontSize: h * 0.018,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('Phalguna',
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
                                  Text('Month Purnimata',
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold)),
                                  Text('Chaitra',
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
                                    'Vikram Samvat',
                                    style: TextStyle(
                                        fontSize: h * 0.018,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('2080 (Nal)',
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
                                  Text('Shaka Samvat',
                                      style: TextStyle(
                                          fontSize: h * 0.018,
                                          fontWeight: FontWeight.bold)),
                                  Text('1945 (Shobhan)',
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
    );
  }
}
