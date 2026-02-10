import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/maha_bhandar/model/shubh_muhrt_model.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toggle_list/toggle_list.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../utill/app_constants.dart';
import '../../infopage/infopageview.dart';
import '../model/specialmuhurat_model.dart';

class ShubhMuhurat extends StatefulWidget {
  const ShubhMuhurat({super.key});

  @override
  State<ShubhMuhurat> createState() => _ShubhMuhuratState();
}

class _ShubhMuhuratState extends State<ShubhMuhurat> {
  bool shimmerEffect = false;
  DateTime now = DateTime.now();
  String monthName = DateFormat('MMMM').format(DateTime.now()).toString();
  String year = DateFormat('yyyy').format(DateTime.now()).toString();
  var marriageMuhurtList = <ShubhMuhratModel>[];
  var grihaPraveshList = <ShubhMuhratModel>[];
  var vehiclePurchaseList = <ShubhMuhratModel>[];
  var propertyPurchaseList = <ShubhMuhratModel>[];
  var mundanList = <ShubhMuhratModel>[];
  var annaPrashanList = <ShubhMuhratModel>[];
  var namkaranList = <ShubhMuhratModel>[];
  var vidyarambhList = <ShubhMuhratModel>[];
  var karnavedhaList = <ShubhMuhratModel>[];
  var specialMuhuratList = <Specialmuhurat>[];

  bool isTranslate = true;
  String enShubhInfo =
      "In Hindu astrology, a Muhurat is a special auspicious time chosen to initiate important activities or events, believed to be aligned with favorable cosmic energies. It ensures success, prosperity and positive outcomes according to traditional beliefs, guiding the timing of important undertakings to maximize their spiritual and practical significance.";
  String hiShubhInfo =
      "हिंदू ज्योतिष में महूर्त एक विशेष शुभ समय होता है जिसे महत्वपूर्ण गतिविधियों या घटनाओं को आरंभ करने के लिए चुना जाता है, माना जाता है कि यह अनुकूल ब्रह्मांडीय ऊर्जाओं के साथ संरेखित होता है। यह पारंपरिक मान्यताओं के अनुसार सफलता, समृद्धि और सकारात्मक परिणाम सुनिश्चित करता है, महत्वपूर्ण उपक्रमों के समय का मार्गदर्शन करता है ताकि उनका आध्यात्मिक और व्यावहारिक महत्व अधिकतम हो सके।";

  List<Color> colorsList = [
    Colors.orange.shade50,
    Colors.white,
    Colors.orange.shade50,
    Colors.white,
    Colors.orange.shade50,
    Colors.white,
    Colors.orange.shade50,
  ];

  // Future getData() async {
  //   shimmerEffect = true;
  //   print("Year-$year");
  //   print("Month-$monthName");
  //   //marriage Data
  //   var marriageResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=marriage&month=$monthName");
  //   var grihPraveshResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=griha pravesh&month=$monthName");
  //   var vehiclePurchaseResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=vehicle purchase&month=$monthName");
  //   var propertyPurchaseResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=property purchase&month=$monthName");
  //   var mundanResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=mundan&month=$monthName");
  //   var annaPrashanResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=annaprashan&month=$monthName");
  //   var namkaranResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=namkaran&month=$monthName");
  //   var vidyarambhResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=vidyarambh&month=$monthName");
  //   var karnavedhaResponse = await HttpService().getApi("${AppConstants.shubhMuhrt}?year=$year&type=karnavedha&month=$monthName");
  //
  //   //Marriage List Data
  //   if (marriageResponse['status'] == true) {
  //     print("Marriage data:${marriageResponse['data']}");
  //     setState(() {
  //       marriageMuhurtList =
  //           shubhMuhratModelFromJson(jsonEncode(marriageResponse['data']));
  //       shimmerEffect = false;
  //     });
  //   } else {
  //     print("Marriage data:${marriageResponse['message']}");
  //     setState(() {
  //       marriageMuhurtList = [];
  //     });
  //     shimmerEffect = false;
  //   }
  //
  //   //Grih Pravesh List Data
  //   if (grihPraveshResponse['status'] == true) {
  //     print("Grih Pravesh data:${grihPraveshResponse['data']}");
  //     setState(() {
  //       grihaPraveshList =
  //           shubhMuhratModelFromJson(jsonEncode(grihPraveshResponse['data']));
  //     });
  //   } else {
  //     print("Grih Pravesh data:${grihPraveshResponse['message']}");
  //     setState(() {
  //       grihaPraveshList = [];
  //     });
  //   }
  //
  //   //Vehicle List Data
  //   if (vehiclePurchaseResponse['status'] == true) {
  //     print("vehicle data:${vehiclePurchaseResponse['data']}");
  //     setState(() {
  //       vehiclePurchaseList = shubhMuhratModelFromJson(
  //           jsonEncode(vehiclePurchaseResponse['data']));
  //     });
  //   } else {
  //     print("vehicle data:${vehiclePurchaseResponse['message']}");
  //     setState(() {
  //       vehiclePurchaseList = [];
  //     });
  //   }
  //
  //   //Property List Data
  //   if(propertyPurchaseResponse['status'] == true){
  //     print("Property data:${propertyPurchaseResponse['data']}");
  //     setState(() {
  //       propertyPurchaseList = shubhMuhratModelFromJson(jsonEncode(propertyPurchaseResponse['data']));
  //     });
  //   }else{
  //     print("Property data:${propertyPurchaseResponse['message']}");
  //     setState(() {
  //       propertyPurchaseList = [];
  //     });
  //   }
  //
  //   //Mundan List Data
  //   if(mundanResponse['status'] == true){
  //     print("Property data:${mundanResponse['data']}");
  //     setState(() {
  //       mundanList = shubhMuhratModelFromJson(jsonEncode(mundanResponse['data']));
  //     });
  //   }else{
  //     print("Property data:${mundanResponse['message']}");
  //     setState(() {
  //       mundanList = [];
  //     });
  //   }
  //
  //   //Anna Prashan List Data
  //   if(annaPrashanResponse['status'] == true){
  //     print("Property data:${annaPrashanResponse['data']}");
  //     setState(() {
  //       annaPrashanList = shubhMuhratModelFromJson(jsonEncode(annaPrashanResponse['data']));
  //     });
  //   }else{
  //     print("Property data:${annaPrashanResponse['message']}");
  //     setState(() {
  //       annaPrashanList = [];
  //     });
  //   }
  //
  //   //NamKaran List Data
  //   if(namkaranResponse['status'] == true){
  //     print("Property data:${namkaranResponse['data']}");
  //     setState(() {
  //       namkaranList = shubhMuhratModelFromJson(jsonEncode(namkaranResponse['data']));
  //     });
  //   }else{
  //     print("Property data:${namkaranResponse['message']}");
  //     setState(() {
  //       namkaranList = [];
  //     });
  //   }
  //
  //   //NamKaran List Data
  //   if(vidyarambhResponse['status'] == true){
  //     print("Property data:${vidyarambhResponse['data']}");
  //     setState(() {
  //       vidyarambhList = shubhMuhratModelFromJson(jsonEncode(vidyarambhResponse['data']));
  //     });
  //   }else{
  //     print("Property data:${vidyarambhResponse['message']}");
  //     setState(() {
  //       vidyarambhList = [];
  //     });
  //   }
  //
  //   //NamKaran List Data
  //   if(karnavedhaResponse['status'] == true){
  //     print("Property data:${karnavedhaResponse['data']}");
  //     setState(() {
  //       karnavedhaList = shubhMuhratModelFromJson(jsonEncode(karnavedhaResponse['data']));
  //     });
  //   }else{
  //     print("Property data:${karnavedhaResponse['message']}");
  //     setState(() {
  //       karnavedhaList = [];
  //     });
  //   }
  //
  //   setState(()=>shimmerEffect = false);
  //
  // }

  void getSpecialMuhurat() async {
    var res = await HttpService().getApi(
        "${AppConstants.specialMahuratUrl}${now.year}&month=${DateFormat.MMMM().format(now)}&day=${now.day}&type=special");
    print("Api Special Muhurat $res");
    setState(() {
      specialMuhuratList.clear();
      List specialList = res["data"];
      specialMuhuratList
          .addAll(specialList.map((e) => Specialmuhurat.fromJson(e)));
    });
    print(res);
  }

  Future<void> getData() async {
    shimmerEffect = true;
    print("Year-$year");
    print("Month-$monthName");

    // Create a list of futures for all API calls
    List<Future<dynamic>> futures = [
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=marriage&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=griha pravesh&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=vehicle purchase&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=property purchase&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=mundan&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=annaprashan&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=namkaran&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=vidyarambh&month=$monthName"),
      HttpService().getApi(
          "${AppConstants.shubhMuhrt}?year=$year&type=karnavedha&month=$monthName"),
    ];

    // Wait for all futures to complete
    List<dynamic> responses = await Future.wait(futures);

    // Process the responses
    marriageMuhurtList = [];
    grihaPraveshList = [];
    vehiclePurchaseList = [];
    propertyPurchaseList = [];
    mundanList = [];
    annaPrashanList = [];
    namkaranList = [];
    vidyarambhList = [];
    karnavedhaList = [];

    for (int i = 0; i < responses.length; i++) {
      dynamic response = responses[i];
      if (response['status'] == true) {
        switch (i) {
          case 0:
            marriageMuhurtList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 1:
            grihaPraveshList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 2:
            vehiclePurchaseList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 3:
            propertyPurchaseList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 4:
            mundanList = shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 5:
            annaPrashanList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 6:
            namkaranList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 7:
            vidyarambhList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          case 8:
            karnavedhaList =
                shubhMuhratModelFromJson(jsonEncode(response['data']));
            break;
          default:
            break;
        }
      } else {
        switch (i) {
          case 0:
            print("Marriage data:${response['message']}");
            marriageMuhurtList = [];
            break;
          case 1:
            print("Grih Pravesh data:${response['message']}");
            grihaPraveshList = [];
            break;
          case 2:
            print("Vehicle data:${response['message']}");
            vehiclePurchaseList = [];
            break;
          case 3:
            print("Property data:${response['message']}");
            propertyPurchaseList = [];
            break;
          case 4:
            print("Mundan data:${response['message']}");
            mundanList = [];
            break;
          case 5:
            print("Anna Prashan data:${response['message']}");
            annaPrashanList = [];
            break;
          case 6:
            print("Namkaran data:${response['message']}");
            namkaranList = [];
            break;
          case 7:
            print("Vidyarambh data:${response['message']}");
            vidyarambhList = [];
            break;
          case 8:
            print("Karnavedha data:${response['message']}");
            karnavedhaList = [];
            break;
          default:
            break;
        }
      }
    }
    // Update theUI with the processed data
    setState(() {
      shimmerEffect = false;
    });
  }

  // Update the UI with the processed data

  void goToNextMonth() {
    setState(() {
      // Increment the current month by 1
      now = DateTime(now.year, now.month + 1, now.day);
      // Check if we have reached the end of the year
      if (now.month == 13) {
        // If the next month is January of the next year,
        // increment the year as well
        now = DateTime(now.year + 1, 1, now.day);
      }
      print("$monthName-$year");
      monthName = DateFormat('MMMM').format(now).toString();
      year = DateFormat('yyyy').format(now).toString();
      getData();
    });
  }

  void goToPreviewMonth() {
    setState(() {
      // Increment the current month by 1
      now = DateTime(now.year, now.month - 1, now.day);
      print(now);
      // Check if we have reached the end of the year
      if (now.month == 1) {
        // If the next month is January of the next year,
        // increment the year as well
        now = DateTime(now.year - 1, 13, now.day);
      }
      print("$monthName-$year");
      monthName = DateFormat('MMMM').format(now).toString();
      year = DateFormat('yyyy').format(now).toString();
      getData();
    });
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
                      "✤ $title ✤",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(image)),

                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(height: 20),
                      Text.rich(TextSpan(
                          text: '⦿ Date: ',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          children: <InlineSpan>[
                            TextSpan(
                              text: date,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //information
                  Text.rich(TextSpan(
                      text: '⦿ Muhurt: ',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                      children: <InlineSpan>[
                        TextSpan(
                          text: muhurt,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ])),

                  const SizedBox(height: 10),
                  //information
                  Text.rich(TextSpan(
                      text: '⦿ Nakshatra: ',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                      children: <InlineSpan>[
                        TextSpan(
                          text: nakshatra,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ])),

                  const SizedBox(height: 10),
                  //information
                  Text.rich(TextSpan(
                      text: '⦿ Tithi: ',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                      children: <InlineSpan>[
                        TextSpan(
                          text: tithi,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ])),
                ],
              ),
            ),
          );
        });
  }

  String extractDay(String dateString) {
    try {
      // Define multiple possible input formats
      List<String> formats = [
        'MMMM dd, yyyy, EEEE', // Example: January 15, 2024 Tuesday
        'EEEE, MMMM dd, yyyy', // Example: January 15, 2024 Tuesday
        'dd MMMM, yyyy', // Example: 15 January 2024
        'dd MMMM yyyy', // Example: 15 January 2024
        'dd MMMM, EEEE', // Example: 15 January 2024
        'yyyy-MM-dd', // Example: 2024-01-15
      ];

      for (var format in formats) {
        try {
          // Try parsing the date
          DateFormat inputFormat = DateFormat(format);
          DateTime parsedDate = inputFormat.parseStrict(dateString);
          // Return only the day
          return parsedDate.day.toString();
        } catch (e) {
          // Continue to the next format if parsing fails
          continue;
        }
      }

      // If none of the formats match, throw an error
      throw const FormatException("Date format not supported");
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid date";
    }
  }

  String extractMonthAbbreviation(String dateString) {
    try {
      // Define multiple possible input formats
      List<String> formats = [
        'MMMM dd, yyyy, EEEE',
        'EEEE, MMMM dd, yyyy', // Example: January 15, 2024 Tuesday
        'dd MMMM, yyyy', // Example: 15 January 2024
        'dd MMMM yyyy', // Example: 15 January 2024
        'dd MMMM, EEEE', // Example: 15 January 2024
        'yyyy-MM-dd', // Example: 2024-01-15
      ];

      for (var format in formats) {
        try {
          // Try parsing the date
          DateFormat inputFormat = DateFormat(format);
          DateTime parsedDate = inputFormat.parseStrict(dateString);
          // Return only the day'
          final abbreviatedMonth = DateFormat('MMM').format(parsedDate);

          return abbreviatedMonth;
        } catch (e) {
          // Continue to the next format if parsing fails
          continue;
        }
      }

      // If none of the formats match, throw an error
      throw const FormatException("Date format not supported");
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid date";
    }
  }

  // String extractDay(String dateString) {
  //   // Regular expression to match the date part (e.g., "January 16, 2024")
  //   final dateRegExp = RegExp(r'(\w+ \d{1,2}, \d{4})');
  //
  //   // Find the match in the input string
  //   final match = dateRegExp.firstMatch(dateString);
  //
  //   if (match != null) {
  //     // Extract the date part from the match
  //     final datePart = match.group(0);
  //
  //     // Parse the extracted date part to a DateTime object
  //     if (datePart != null) {
  //       final dateTime = DateFormat('MMMM d, y').parse(datePart);
  //
  //       // Return the day of the month as a string
  //       return dateTime.day.toString();
  //     }
  //   }
  //   // If no match is found or datePart is null, return an empty string or handle error
  //   return '';
  // }

  // String extractMonthAbbreviation(String dateString) {
  //   // Regular expression to match the date part (e.g., "January 16, 2024")
  //   final dateRegExp = RegExp(r'(\w+ \d{1,2}, \d{4})');
  //
  //   // Find the match in the input string
  //   final match = dateRegExp.firstMatch(dateString);
  //
  //   if (match != null) {
  //     // Extract the date part from the match
  //     final datePart = match.group(0);
  //
  //     // Parse the extracted date part to a DateTime object
  //     if (datePart != null) {
  //       final dateTime = DateFormat('MMMM d, y').parse(datePart);
  //
  //       // Format the month to a three-letter abbreviation
  //       final abbreviatedMonth = DateFormat('MMM').format(dateTime);
  //
  //       return abbreviatedMonth;
  //     }
  //   }
  //   // If no match is found or datePart is null, return an empty string or handle error
  //   return '';
  // }

  @override
  void initState() {
    getData();
    getSpecialMuhurat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: shimmerEffect
            ? const Shimmerscreen()
            : Column(
                children: [
                  Expanded(flex: 0, child: SizedBox(height: w * 0.22)),
                  // Date monthly
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              goToPreviewMonth();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(3.0),
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.orange, width: 2)),
                              child: const Center(
                                  child: Icon(Icons.keyboard_arrow_left)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(3.0),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border:
                                    Border.all(color: Colors.orange, width: 2)),
                            child: Center(
                                child: Text("$monthName-$year",
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                    ))),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              goToNextMonth();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(3.0),
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.orange, width: 2)),
                              child: const Center(
                                  child: Icon(Icons.keyboard_arrow_right)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Special muhurt
                  specialMuhuratList.isEmpty
                      ? const SizedBox()
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 18,
                                    width: 3,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Special Muhurat",
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      infoPopup(
                                          context,
                                          isTranslate
                                              ? hiShubhInfo
                                              : enShubhInfo);
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
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.red)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  ToggleListItem(
                                    isInitiallyExpanded: true,
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://i.pinimg.com/736x/37/37/9b/37379b2bd9e57ae2f23d135fbe54d546.jpg",
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        Text("Special Muhurat",
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.024,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    content: SizedBox(
                                      height: 60,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis
                                              .horizontal, // Scroll horizontally
                                          itemCount: specialMuhuratList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                infoSheet(
                                                    specialMuhuratList[index]
                                                        .message,
                                                    specialMuhuratList[index]
                                                        .titleLink,
                                                    specialMuhuratList[index]
                                                        .muhurat,
                                                    specialMuhuratList[index]
                                                        .nakshatra,
                                                    specialMuhuratList[index]
                                                        .tithi,
                                                    "https://i.pinimg.com/736x/37/37/9b/37379b2bd9e57ae2f23d135fbe54d546.jpg");
                                              },
                                              child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  height: 60,
                                                  width:
                                                      60, // Set the width of each item
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        color: Colors.red,
                                                        width: 1),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        extractDay(
                                                            specialMuhuratList[
                                                                    index]
                                                                .titleLink),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        extractMonthAbbreviation(
                                                            specialMuhuratList[
                                                                    index]
                                                                .titleLink),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),

                  //Text month shubh muhurt
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Row(
                      children: [
                        Container(
                          height: 18,
                          width: 3,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Month Shubh Muhurat",
                          style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            infoPopup(context,
                                isTranslate ? hiShubhInfo : enShubhInfo);
                          },
                          icon: const Icon(
                            Icons.report_gmailerrorred,
                            color: Colors.orange,
                          ),
                        )
                      ],
                    ),
                  ),
                  shimmerEffect == true
                      ? const Shimmerscreen()
                      : Column(
                          children: [
                            //Marriage
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.amber)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  marriageMuhurtList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/vivah_muhurt_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Marriage Yog",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/vivah_muhurt_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Marriage Yog",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount:
                                                    marriageMuhurtList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Marriage Yog',
                                                          marriageMuhurtList[
                                                                  index]
                                                              .titleLink!,
                                                          marriageMuhurtList[
                                                                  index]
                                                              .muhurat!,
                                                          marriageMuhurtList[
                                                                  index]
                                                              .nakshatra!,
                                                          marriageMuhurtList[
                                                                  index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/Marriage.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.amber,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  marriageMuhurtList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  marriageMuhurtList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //Grih Pravesh
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.purple)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  grihaPraveshList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/grah_pravesh_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Grah Prvesh Yog",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/grah_pravesh_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Grah Prvesh Yog",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount:
                                                    grihaPraveshList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Grah Vravesh Yog',
                                                          grihaPraveshList[
                                                                  index]
                                                              .titleLink!,
                                                          grihaPraveshList[
                                                                  index]
                                                              .muhurat!,
                                                          grihaPraveshList[
                                                                  index]
                                                              .nakshatra!,
                                                          grihaPraveshList[
                                                                  index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/Grah_pravesh.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.purple,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  grihaPraveshList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  grihaPraveshList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //Vehicle Purchase
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.green)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  vehiclePurchaseList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/valic_muhurt_animation.gif",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Vehicle Purchase",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/valic_muhurt_animation.gif",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Vehicle Purchase",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount:
                                                    vehiclePurchaseList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Vehicle Purchase Yog',
                                                          vehiclePurchaseList[
                                                                  index]
                                                              .titleLink!,
                                                          vehiclePurchaseList[
                                                                  index]
                                                              .muhurat!,
                                                          vehiclePurchaseList[
                                                                  index]
                                                              .nakshatra!,
                                                          vehiclePurchaseList[
                                                                  index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/vehical_purchase.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  vehiclePurchaseList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  vehiclePurchaseList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //Property Purchase
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.red)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  propertyPurchaseList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/property_purchase_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Property Purchase",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/property_purchase_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Property Purchase",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount:
                                                    propertyPurchaseList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Property Purchase Yog',
                                                          propertyPurchaseList[
                                                                  index]
                                                              .titleLink!,
                                                          propertyPurchaseList[
                                                                  index]
                                                              .muhurat!,
                                                          propertyPurchaseList[
                                                                  index]
                                                              .nakshatra!,
                                                          propertyPurchaseList[
                                                                  index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/property_purchase.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color: Colors.red,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  propertyPurchaseList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  propertyPurchaseList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //Mundan Muhrut
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.blue)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  mundanList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/mundan_muhurt_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Mundan Muhurt",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/mundan_muhurt_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Mundan Muhurt",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount: mundanList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Mundan Mahurat',
                                                          mundanList[index]
                                                              .titleLink!,
                                                          mundanList[index]
                                                              .muhurat!,
                                                          mundanList[index]
                                                              .nakshatra!,
                                                          mundanList[index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/Mundan.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.blue,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  mundanList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  mundanList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //AnnaPrashan Muhrut
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.brown.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.brown)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  annaPrashanList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/aan_prashan_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Anna-Prashan",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/aan_prashan_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Anna-Prashan",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount:
                                                    annaPrashanList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Anna-Prashan',
                                                          annaPrashanList[index]
                                                              .titleLink!,
                                                          annaPrashanList[index]
                                                              .muhurat!,
                                                          annaPrashanList[index]
                                                              .nakshatra!,
                                                          annaPrashanList[index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/Anna_prashan.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.brown,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  annaPrashanList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  annaPrashanList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //namkaran Muhrut
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.pink)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  namkaranList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/naam_karan_muhurt_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Namkaran",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/naam_karan_muhurt_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Namkaran",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount: namkaranList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Namkaran',
                                                          namkaranList[index]
                                                              .titleLink!,
                                                          namkaranList[index]
                                                              .muhurat!,
                                                          namkaranList[index]
                                                              .nakshatra!,
                                                          namkaranList[index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/Naamkaran.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.pink,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  namkaranList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  namkaranList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //vidyarambh Muhrut
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.green)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  vidyarambhList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/vidhya_aarambh_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Vidyarambh",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/vidhya_aarambh_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("vidyarambh",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount:
                                                    vidyarambhList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'Vidhyarambh',
                                                          vidyarambhList[index]
                                                              .titleLink!,
                                                          vidyarambhList[index]
                                                              .muhurat!,
                                                          vidyarambhList[index]
                                                              .nakshatra!,
                                                          vidyarambhList[index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/vidyarambh.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  vidyarambhList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  vidyarambhList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            //karnavedha
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.purple)),
                              child: ToggleList(
                                trailing: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  karnavedhaList.isEmpty
                                      ? ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/karnavedha_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Karnavedha",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: const Text(
                                              '--   Muhurt Not-Available   --'),
                                        )
                                      : ToggleListItem(
                                          isInitiallyExpanded: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Image.asset(
                                                  "assets/testImage/panchangImages/images/karnavedha_icon.png",
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text("Karnavedha",
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenHeight * 0.024,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis
                                                    .horizontal, // Scroll horizontally
                                                itemCount:
                                                    karnavedhaList.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      infoSheet(
                                                          'karnavedha',
                                                          karnavedhaList[index]
                                                              .titleLink!,
                                                          karnavedhaList[index]
                                                              .muhurat!,
                                                          karnavedhaList[index]
                                                              .nakshatra!,
                                                          karnavedhaList[index]
                                                              .tithi!,
                                                          "assets/testImage/panchangImages/images/Karnavedha.png");
                                                    },
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2),
                                                        height: 60,
                                                        width:
                                                            60, // Set the width of each item
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.purple,
                                                              width: 1),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              extractDay(
                                                                  karnavedhaList[
                                                                          index]
                                                                      .titleLink!),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              extractMonthAbbreviation(
                                                                  karnavedhaList[
                                                                          index]
                                                                      .titleLink!),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    color: Colors.orange,
                                    height: 20,
                                    width: 4,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Details Muhurat",
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.022,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.report_gmailerrorred,
                                    color: Colors.orange,
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                ],
              ),
      ),
    );
  }
}

class Shimmerscreen extends StatelessWidget {
  const Shimmerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10, // Number of items in the list
            itemBuilder: (BuildContext context, int index) {
              // itemBuilder function returns a widget for each item in the list
              return Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "sau",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        " to ",
                        style: TextStyle(color: Colors.grey, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
