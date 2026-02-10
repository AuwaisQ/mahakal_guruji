import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../main.dart';
import '../../../profile/controllers/profile_contrroller.dart';
import '../../model/finaltrack_model.dart';

class OrderTrackingPage extends StatefulWidget {
  String? userID;
  int? isPrashad;
  OrderTrackingPage({super.key, required this.userID, required this.isPrashad});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  FinalTrackDetailModel? trackModelData;
  String orderStatus = "";
  String bookDate = "";
  String awbNumber = "";
  String streamKey = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrackData("${widget.userID}");
    getTrackPrasad("${widget.userID}");
  }

  Future<void> launchInApp(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView, // Opens inside the app
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget OrderStatusWidget() {
    switch (orderStatus) {
      case "confirmed":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.check, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Confirmed',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            formatStringDate(bookDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(Icons.assessment,
                        color: Colors.amber.withOpacity(0.3)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Processing',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Transit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Out for Pickup',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Delivered',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
            ],
          ),
        );

      case "processing":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.check, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Confirmed',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            formatStringDate(bookDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Processing',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            formatStringDate(bookDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      awbNumber.isEmpty
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                launchInApp(
                                    "https://mahakal.shipway.com/t/$awbNumber");
                              },
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      "🚚 Click & Track Order",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Transit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Out for Pickup',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Delivered',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
            ],
          ),
        );

      case "in-transit":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.check, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Confirmed',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Processing',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            formatStringDate(bookDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      awbNumber.isEmpty
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                launchInApp(
                                    "https://mahakal.shipway.com/t/$awbNumber");
                              },
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      "🚚 Click & Track",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Transit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Out for Pickup',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Delivered',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber.withOpacity(0.3)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
            ],
          ),
        );

      case "out_for_pickup":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.check, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Confirmed',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Processing',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            formatStringDate(bookDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      awbNumber.isEmpty
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                launchInApp(
                                    "https://mahakal.shipway.com/t/$awbNumber");
                              },
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      "🚚 Click & Track",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Transit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Out for Pickup',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.assessment,
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Delivered',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
            ],
          ),
        );

      case "delivered":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child: const Icon(Icons.check, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Confirmed',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Processing',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.alarm,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            formatStringDate(bookDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      awbNumber.isEmpty
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                launchInApp(
                                    "https://mahakal.shipway.com/t/$awbNumber");
                              },
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      "🚚 Click & Track",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Transit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Out for Pickup',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                    child:
                        const Icon(Icons.assessment, color: Colors.amber),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Delivered',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
            ],
          ),
        );

      default:
        return Text("order Status : $orderStatus");
    }
  }

  String extractApiKeyFromLiveStreamUrl(String url) {
    final uri = Uri.parse(url);
    // Get the last segment after the last '/'
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  }

  Future<void> getTrackData(String userId) async {
    final String url =
        AppConstants.baseUrl + AppConstants.poojaServiceTrackUrl + userId;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          print("APi response ${response.body}");
          // var res = jsonEncode(response.body);
          trackModelData = finalTrackDetailModelFromJson(response.body);
          streamKey = extractApiKeyFromLiveStreamUrl(
              trackModelData!.order!.liveStream!);
        });
      } else {
        setState(() {
          print("APi response fail ${response.body}");
        });
      }
    } catch (e) {
      setState(() {
        // errorMessage = 'Failed to load data: $e';
        // isLoading = false;
      });
    }
  }

  Future<void> getTrackPrasad(String userId) async {
    final String url =
        AppConstants.baseUrl + AppConstants.poojaPrashadTrackUrl + userId;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          print("APi response ${response.body}");
          // var res = jsonEncode(response.body);
          var res = jsonDecode(response.body);
          orderStatus = res["order"]["order_status"];
          bookDate = res["order"]["booking_date"];
          awbNumber = res["order"]["awb"];
          print("order status $orderStatus");
          // trackModelData = finalTrackDetailModelFromJson(response.body);
        });
      } else {
        setState(() {
          print("APi response fail ${response.body}");
        });
      }
    } catch (e) {
      setState(() {
        // errorMessage = 'Failed to load data: $e';
        // isLoading = false;
      });
    }
  }

  String formatStringDate(String dateString) {
    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object into the desired string format
    return DateFormat('hh:mm a, dd MMM yyyy').format(dateTime);
  }

  String formatStringTime(String timeString) {
    // Parse time using DateFormat
    DateTime dateTime = DateFormat("HH:mm:ss").parse(timeString);

    // Format time to 12-hour AM/PM format
    return DateFormat('hh:mm a').format(dateTime);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'cancel':
        return Colors.red;
      case 'rejected':
        return Colors.red;
      case 'confirmed':
        return Colors.green;
      default:
        return Colors.amber; // Default color for unknown statuses
    }
  }

  String convertDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Invalid date"; // Or any default message you prefer
    }

    try {
      final dateTime = DateFormat('yyyy-MM-dd').parse(date);
      final formattedDate = DateFormat("dd-MMMM-yyyy").format(dateTime);
      return formattedDate;
    } catch (e) {
      return "Invalid format"; // Handle parsing errors
    }
  }

  Future<void> _launchURL(String liveStreamUrl) async {
    if (liveStreamUrl.isNotEmpty) {
      final Uri url = Uri.parse(liveStreamUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $liveStreamUrl");
      }
    } else {
      debugPrint("URL is empty.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return trackModelData?.order?.orderId == null
        ? Container(
            color: Colors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            )))
        : RefreshIndicator(
            color: Colors.amber,
            onRefresh: () async {
              getTrackData("${widget.userID}");
              getTrackPrasad("${widget.userID}");
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey.shade50,
                title: Column(
                  children: [
                    Text.rich(TextSpan(children: [
                      const TextSpan(
                          text: "Order -",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      TextSpan(
                          text: " #${trackModelData?.order?.orderId}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Text.rich(TextSpan(children: [
                      const TextSpan(
                          text: " Your Order is - ",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      TextSpan(
                          text: "${trackModelData?.order?.orderStatus}",
                          style: TextStyle(
                              color: getStatusColor(
                                  "${trackModelData?.order?.orderStatus}"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(convertDate("${trackModelData?.order?.bookingDate}"),
                        style: const TextStyle(
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black)),
                  ],
                ),
                centerTitle: true,
                toolbarHeight: 100,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Pooja Tracking Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: trackModelData?.order?.status ==
                                          "Rejected"
                                      ? 40
                                      : 45,
                                  width: trackModelData?.order?.status ==
                                          "Rejected"
                                      ? 40
                                      : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData?.order?.status ==
                                          "Rejected"
                                      ? Opacity(
                                          opacity: 0.5,
                                          child: Image.asset(
                                              "assets/animated/pooja_conformed_animation.gif"))
                                      : Image.asset(
                                          "assets/animated/pooja_conformed_animation.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Pooja Confirmed',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.status == "Rejected"
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.alarm,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                formatStringDate(
                                                    "${trackModelData?.order?.createdAt}"),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData?.order?.status ==
                                              "Rejected"
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              children: [
                                Container(
                                  height:
                                      trackModelData?.order?.scheduleCreated ==
                                              null
                                          ? 40
                                          : 45,
                                  width:
                                      trackModelData?.order?.scheduleCreated ==
                                              null
                                          ? 40
                                          : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData
                                              ?.order?.scheduleCreated ==
                                          null
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              "assets/animated/shadule_puja_gif.gif"))
                                      : Image.asset(
                                          "assets/animated/shadule_puja_gif.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Schedule Time',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.scheduleTime == null
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.alarm,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                formatStringTime(
                                                    "${trackModelData?.order?.scheduleTime}"),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.scheduleCreated ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),

                            /// Live Stream
                            Row(
                              children: [
                                Container(
                                    height: trackModelData
                                                ?.order?.liveCreatedStream ==
                                            null
                                        ? 40
                                        : 45,
                                    width: trackModelData
                                                ?.order?.liveCreatedStream ==
                                            null
                                        ? 40
                                        : 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: trackModelData
                                                ?.order?.liveCreatedStream ==
                                            null
                                        ? Opacity(
                                            opacity: 0.3,
                                            child: Image.asset(
                                                "assets/animated/live_streem_icon.gif"))
                                        : Image.asset(
                                            "assets/animated/live_streem_icon.gif")),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Live Stream',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.liveCreatedStream ==
                                            null
                                        ? const SizedBox.shrink()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.alarm,
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    formatStringDate(
                                                        "${trackModelData?.order?.liveCreatedStream}"),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              trackModelData?.order
                                                          ?.videoCreatedSharing !=
                                                      null
                                                  ? const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.video_label,
                                                          color: Colors.grey,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          "Play Video",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_right,
                                                          color: Colors.grey,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        // Navigator.push(
                                                        //   context,
                                                        //   CupertinoPageRoute(
                                                        //     builder: (context) =>
                                                        //         PoojaVideoPlayer(
                                                        //       streamKey:
                                                        //           streamKey,
                                                        //       isRecorded: false,
                                                        //     ),
                                                        //     //     FullScreenVideoPlayer(
                                                        //     //   videoUrl: '${trackModelData?.order?.poojaVideo}',
                                                        //     // ),
                                                        //   ),
                                                        // );
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          Icon(
                                                            Icons.video_label,
                                                            color:
                                                                Colors.amber,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            "Play Video",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          SizedBox(width: 20),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_right,
                                                            color: Colors
                                                                .amber,
                                                            size: 18,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.liveCreatedStream ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),

                            /// Preparing Video
                            Row(
                              children: [
                                Container(
                                  height: trackModelData
                                              ?.order?.videoCreatedSharing ==
                                          null
                                      ? 40
                                      : 45,
                                  width: trackModelData
                                              ?.order?.videoCreatedSharing ==
                                          null
                                      ? 40
                                      : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData
                                              ?.order?.videoCreatedSharing ==
                                          null
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              "assets/animated/prepairing_animation.gif"))
                                      : Image.asset(
                                          "assets/animated/prepairing_animation.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Preparing Video',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData
                                                ?.order?.videoCreatedSharing ==
                                            null
                                        ? const SizedBox.shrink()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.alarm,
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    formatStringDate(
                                                        "${trackModelData?.order?.videoCreatedSharing}"),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   CupertinoPageRoute(
                                                  //     builder: (context) =>
                                                  //         PoojaVideoPlayer(
                                                  //       streamKey: streamKey,
                                                  //       isRecorded: true,
                                                  //     ),
                                                  //     //     FullScreenVideoPlayer(
                                                  //     //   videoUrl: '${trackModelData?.order?.poojaVideo}',
                                                  //     // ),
                                                  //   ),
                                                  // );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .slow_motion_video_sharp,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Play Pooja Video",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: (){
                                              //     _launchURL("${trackModelData?.order?.poojaVideo}");
                                              //   },
                                              //   child: Row(
                                              //     children: [
                                              //       Icon(Icons.slow_motion_video_sharp,color: Colors.amber,size: 18,),
                                              //       SizedBox(width: 5,),
                                              //       // Text("${trackModelData?.order?.poojaVideo}",
                                              //       //   style: TextStyle(
                                              //       //     fontSize: 16,
                                              //       //     color: Colors.blue,
                                              //       //     fontWeight: FontWeight.bold,
                                              //       //     overflow: TextOverflow.ellipsis
                                              //       //   ),
                                              //       // ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData?.order
                                                  ?.videoCreatedSharing ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),

                            /// Certificate Generating
                            Row(
                              children: [
                                Container(
                                  height:
                                      trackModelData?.order?.poojaCertificate ==
                                              ""
                                          ? 40
                                          : 45,
                                  width:
                                      trackModelData?.order?.poojaCertificate ==
                                              ""
                                          ? 40
                                          : 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: trackModelData
                                              ?.order?.poojaCertificate ==
                                          ""
                                      ? Opacity(
                                          opacity: 0.3,
                                          child: Image.asset(
                                              "assets/animated/pooja_certificate_animation.gif"))
                                      : Image.asset(
                                          "assets/animated/pooja_certificate_animation.gif"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Certificate Generating',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.poojaCertificate ==
                                            ""
                                        ? const SizedBox.shrink()
                                        : Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.alarm,
                                                    color: Colors.amber,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    formatStringDate(
                                                        "${trackModelData?.order?.orderCompleted}"),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          CertificateViewScreen(
                                                        certificateImageUrl:
                                                            '${trackModelData?.order?.poojaCertificate}',
                                                        issuedDate:
                                                            "${trackModelData?.order?.bookingDate}",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .document_scanner_sharp,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "View Certificate",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                      color: Colors.amber,
                                                      size: 18,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.poojaCertificate ==
                                              ""
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              children: [
                                Container(
                                    height:
                                        trackModelData?.order?.orderCompleted ==
                                                null
                                            ? 40
                                            : 45,
                                    width:
                                        trackModelData?.order?.orderCompleted ==
                                                null
                                            ? 40
                                            : 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: trackModelData
                                                ?.order?.orderCompleted ==
                                            null
                                        ? Opacity(
                                            opacity: 0.3,
                                            child: Image.asset(
                                                "assets/animated/Pooja_done_animation.gif"))
                                        : Image.asset(
                                            "assets/animated/Pooja_done_animation.gif")),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Order Completed',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trackModelData?.order?.orderCompleted ==
                                            null
                                        ? const SizedBox.shrink()
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.alarm,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                formatStringDate(
                                                    "${trackModelData?.order?.orderCompleted}"),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: trackModelData
                                                  ?.order?.orderCompleted ==
                                              null
                                          ? Colors.amber.withOpacity(0.3)
                                          : Colors.amber),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.isPrashad == 0
                          ? const SizedBox.shrink()
                          : Column(children: [
                              trackModelData?.order?.orderCompleted != null
                                  ? const Divider(
                                      color: Colors.grey,
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(
                                height: 10,
                              ),
                              trackModelData?.order?.orderCompleted != null
                                  ? const Text(
                                      'Prashad Tracking Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 20),
                              trackModelData?.order?.orderCompleted != null
                                  ? OrderStatusWidget()
                                  : const SizedBox.shrink(),
                            ]),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPlayer({super.key, required this.videoUrl});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  YoutubePlayerController? _youtubeController;
  late YoutubeMetaData videoMetaData;
  var isPlayerReady = false;

  @override
  void initState() {
    _initializeYoutubePlayer(widget.videoUrl);
    super.initState();
  }

  void _initializeYoutubePlayer(String videoUrl) {
    final videoID = YoutubePlayer.convertUrlToId(videoUrl);
    _youtubeController = YoutubePlayerController(
      initialVideoId: "$videoID",
      flags: const YoutubePlayerFlags(
        useHybridComposition: true,
        mute: false,
        autoPlay: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (isPlayerReady && mounted && !_youtubeController!.value.isFullScreen) {
      setState(() {
        videoMetaData = _youtubeController!.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _youtubeController!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _youtubeController!.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: YoutubePlayer(
        controller: _youtubeController!,
        topActions: [
          InkWell(
              onTap: () {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ))
        ],
        showVideoProgressIndicator: true,
        onReady: () {
          isPlayerReady = true;
          print('Player is ready.');
        },
      )),
    );
  }
}

class CertificateViewScreen extends StatefulWidget {
  final String certificateImageUrl;
  final String issuedDate;

  const CertificateViewScreen(
      {super.key, required this.certificateImageUrl, required this.issuedDate});

  @override
  State<CertificateViewScreen> createState() => _CertificateViewScreenState();
}

class _CertificateViewScreenState extends State<CertificateViewScreen> {
  String? imagePath;
  bool isLoading = true;
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchCertificateImage();
    userName =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
  }

  /// **Download Image and Save Locally**
  Future<void> _fetchCertificateImage() async {
    if (widget.certificateImageUrl.isEmpty) {
      print('Certificate URL is empty');
      return;
    }

    try {
      final response = await http.get(Uri.parse(widget.certificateImageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        String tempImagePath = '${directory.path}/certificate.png';

        final file = File(tempImagePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          imagePath = tempImagePath;
          isLoading = false;
        });

        print("Certificate downloaded at: $imagePath");
      } else {
        print('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching certificate image: $e');
    }
  }

  /// **Download Certificate to Device Storage**
  Future<void> _downloadCertificate(
      BuildContext context, String imageUrl) async {
    FileDownloader.downloadFile(
      url: imageUrl,
      onDownloadCompleted: (path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Download Successfully!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
      },
    );
  }

  /// **Share Certificate
  void shareCertificate() async {
    if (imagePath != null) {
      String shareUrl = '';
      shareUrl = "${AppConstants.baseUrl}/download";

      // Share the image with a custom message
      await Share.shareXFiles(
        [XFile(imagePath ?? '')],
        text: "🌟 **आपका प्रमाण पत्र** 🌟\n"
            "यह प्रमाण पत्र Mahakal.com ऐप द्वारा आयोजित पूजा में भागीदारी के लिए दिया गया है। 🔱💖\n"
            "आपका आभार! 🙏\n"
            "Download App Now: $shareUrl",
      );
    } else {
      print('Image not available for sharing');
    }
  }

  /// **Format Date**
  String formatDate(String apiDate) {
    DateTime dateTime = DateTime.parse(apiDate.split('.').first);
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(widget.issuedDate);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '🎖 Certificate of Honor',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Certificate Image with Glassmorphism Effect
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.certificateImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Name
            Text(
              "🏅 Congratulations, $userName!",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

            // Certificate Issued Date
            Text(
              '📅 Issued on: $formattedDate',
              style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Certificate Description

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  children: [
                    TextSpan(
                        text:
                            '🎊 You have been awarded this certificate for your dedicated involvement in the Pooja Ceremony, facilitated by ',
                        style: TextStyle(fontWeight: FontWeight.w300)),
                    TextSpan(
                      text: 'Mahakal.com',
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    TextSpan(
                        text:
                            '.\n\n🙏 May Lord Mahakal bless you with wisdom and prosperity!'),
                  ],
                ),
              ),
            ),

            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   margin: const EdgeInsets.symmetric(horizontal: 20),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.amber.withOpacity(0.2),
            //         blurRadius: 8,
            //         offset: const Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: const Text(
            //     '🎊 You have been awarded this certificate for your dedicated involvement in the Pooja Ceremony, facilitated by Mahakal.com.\n\n🙏 May Lord Mahakal bless you with wisdom and prosperity!',
            //     style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 16),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            const SizedBox(height: 20),

            // Download & Share Buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.amber.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _downloadCertificate(
                            context, widget.certificateImageUrl),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download, color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text('Download\nCertificate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.amber.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: shareCertificate,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text('Share\nCertificate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Closing Message
            const Text(
              "✨ Thank you for being a part of this spiritual journey! ✨",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
