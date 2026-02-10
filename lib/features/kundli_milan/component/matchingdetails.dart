import 'package:flutter/material.dart';

import '../models/matchingDetailModel.dart';

// ignore: must_be_immutable
class MatchingDetailsView extends StatefulWidget {
  MatchingDetailModel? data;
  final double fontSizeDefault;
  final String translateEn;
  MatchingDetailsView(
      {super.key,
      required this.data,
      required this.fontSizeDefault,
      required this.translateEn});

  @override
  State<MatchingDetailsView> createState() => _MatchingDetailsViewState();
}

class _MatchingDetailsViewState extends State<MatchingDetailsView> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
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
                            widget.translateEn == "hi"
                                ? "अष्टकूट"
                                : "Ashtakoot",
                            style: TextStyle(
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                          Text(
                              "${widget.data?.matchData.ashtakoota.receivedPoints}",
                              style: TextStyle(
                                  fontSize: widget.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
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
                        color: Colors.orange.shade50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.translateEn == "hi"
                                ? "मांगलिक मिलान"
                                : "Manglik Matching",
                            style: TextStyle(
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                          Text(
                              widget.data?.matchData.manglik.status == true
                                  ? " हां"
                                  : " नहीं",
                              style: TextStyle(
                                  fontSize: widget.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange)),
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
                        color: Colors.orange.shade50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.translateEn == "hi"
                                ? "रज्जू दोष"
                                : "Rajju Dosha",
                            style: TextStyle(
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                          Text(
                              widget.data?.matchData.rajjuDosha.status == true
                                  ? " हां"
                                  : " नहीं",
                              style: TextStyle(
                                  fontSize: widget.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange)),
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
                            widget.translateEn == "hi"
                                ? "वेध दोष"
                                : "Vedh Dosha",
                            style: TextStyle(
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                          Text(
                              widget.data?.matchData.vedhaDosha.status == true
                                  ? " हां"
                                  : " नहीं",
                              style: TextStyle(
                                  fontSize: widget.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.translateEn == "hi" ? "निष्कर्ष" : "Conclusion",
              style: TextStyle(
                  fontSize: screenHeight * 0.022,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            Text(
              "${widget.data?.matchData.conclusion.matchReport}",
              style: TextStyle(fontSize: widget.fontSizeDefault),
            )
          ],
        ),
      ),
    );
  }
}
