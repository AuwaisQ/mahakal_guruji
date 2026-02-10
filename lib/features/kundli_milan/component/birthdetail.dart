import 'package:flutter/material.dart';

import '../models/birthDetailModel.dart';

class BirthDetailsView extends StatefulWidget {
  BirthDetailModel? data;
  String translateEn;
  BirthDetailsView({super.key, required this.data, required this.translateEn});

  @override
  State<BirthDetailsView> createState() => _BirthDetailsViewState();
}

class _BirthDetailsViewState extends State<BirthDetailsView> {
  @override
  Widget build(BuildContext context) {
    return widget.data == null
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.orange,
          ))
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.orange,
                        height: 20,
                        width: 4,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.translateEn == "hi"
                            ? "जन्म विवरण"
                            : "Birth Details",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/framebg.png")),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    border: Border.all(color: Colors.orange)),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "पुरुष" : "Male",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange)),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "विवरण"
                                      : "Details",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    border: Border.all(color: Colors.orange)),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "महिला"
                                      : "Female",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.day}/${widget.data?.birthData.maleAstroDetails.month}/${widget.data?.birthData.maleAstroDetails.year}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "जन्म दिनांक"
                                      : "Date Of Birth",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.day}/${widget.data?.birthData.maleAstroDetails.month}/${widget.data?.birthData.maleAstroDetails.year}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.hour}:${widget.data?.birthData.maleAstroDetails.minute}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "जन्म समय"
                                      : "Birth Time",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.hour}:${widget.data?.birthData.femaleAstroDetails.hour}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.latitude}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "अक्षांश"
                                      : "Latitude",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.latitude}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.longitude}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "देशांतर"
                                      : "Longitude",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.longitude}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.timezone}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "समय क्षेत्र"
                                      : "Time Zone ",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.timezone}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.sunrise}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "सूर्योदय"
                                      : "Sun Rise",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.sunrise}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.sunset}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "सूर्यास्त"
                                      : "Sun Set",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.sunset}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.maleAstroDetails.ayanamsha}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "अयनांश"
                                      : "Aynamsha",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.birthData.femaleAstroDetails.ayanamsha}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.orange,
                        height: 20,
                        width: 4,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.translateEn == "hi"
                            ? "अवखड़ा विवरण"
                            : "Avakhada Details",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/frambg2.png")),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    border: Border.all(color: Colors.orange)),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "पुरुष" : "Male",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange)),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "विवरण"
                                      : "Details",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    border: Border.all(color: Colors.orange)),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "महिला"
                                      : "Female",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.ascendant}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "स्वभाव"
                                      : "Character",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.ascendant}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.varna}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "वर्ण" : "Varna",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.varna}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.vashya}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "वश्य"
                                      : "Vashya",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.vashya}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.yoni}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "योनि" : "Yoni",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.yoni}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.gan}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "गण" : "Gan",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.gan}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.nadi}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "नाड़ी" : "Pulse",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.nadi}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.signLord}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "राशि स्वामी"
                                      : "Sign Lord",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.signLord}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.sign}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "राशि" : "Sign",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.sign}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.naksahtra}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "नक्षत्र"
                                      : "Naksahtra",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.naksahtra}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.naksahtraLord}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "देवता" : "God",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.naksahtraLord}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.charan}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "चरण" : "Charan",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.charan}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.yog}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "योग" : "Yog",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.yog}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.karan}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "करण" : "Karan",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.karan}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.tithi}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "तिथि" : "Tithi",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.tithi}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.yunja}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "युंज" : "Yunja",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.yunja}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.tatva}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "तत्व" : "Tatva",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.tatva}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.nameAlphabet}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi"
                                      ? "नाम के अक्षर"
                                      : "Name letters",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.nameAlphabet}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.maleAstroDetails.paya}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: Colors.grey.shade400)),
                                ),
                                child: Center(
                                    child: Text(
                                  widget.translateEn == "hi" ? "पाय" : "paya",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Center(
                                    child: Text(
                                  "${widget.data?.astroData.femaleAstroDetails.paya}",
                                  style: const TextStyle(fontSize: 18),
                                )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          );
  }
}
