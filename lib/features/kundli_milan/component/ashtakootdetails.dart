import 'package:flutter/material.dart';

import '../models/ashtakootDetailsModel.dart';

class AshtakootDetailView extends StatefulWidget {
  AshtakootDetailModel? data;
  final double fontSizeDefault;
  final String translateEn;
  AshtakootDetailView(
      {super.key,
      required this.data,
      required this.fontSizeDefault,
      required this.translateEn});

  @override
  State<AshtakootDetailView> createState() => _AshtakootDetailViewState();
}

class _AshtakootDetailViewState extends State<AshtakootDetailView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              child: DataTable(
                // ignore: deprecated_member_use
                dataRowHeight: 55,
                border: const TableBorder(
                  bottom: BorderSide(color: Colors.orange),
                ),
                columnSpacing: 10,
                headingTextStyle: const TextStyle(color: Colors.white),
                headingRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  return Colors.black; // Change this to your desired color
                }),
                dataRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  return Colors
                      .orange.shade50; // Change this to your desired color
                }),
                columns: <DataColumn>[
                  DataColumn(
                      label: Text(
                          widget.translateEn == "hi" ? 'गुण' : 'character')),
                  DataColumn(
                      label:
                          Text(widget.translateEn == "hi" ? 'पुरुष' : 'Male')),
                  DataColumn(
                      label: Text(
                          widget.translateEn == "hi" ? 'महिला' : 'Female')),
                  DataColumn(
                      label: Text(widget.translateEn == "hi"
                          ? 'कुलअंक'
                          : 'Total Marks')),
                  DataColumn(
                      label: Text(widget.translateEn == "hi"
                          ? 'प्राप्तअंक'
                          : 'Obtained Marks')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(
                            widget.translateEn == "hi" ? 'वर्ण' : 'Varna'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.varna.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.varna.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.varna.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.varna.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(
                            widget.translateEn == "hi" ? 'वश्य' : 'Vashya'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(
                            widget.translateEn == "hi" ? 'तारा' : 'Tara'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.tara.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.tara.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.tara.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.tara.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(
                            widget.translateEn == "hi" ? 'योनि' : 'Yoni'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.yoni.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.yoni.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.yoni.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.yoni.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(
                            widget.translateEn == "hi" ? 'मैत्री' : 'Maitri'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.maitri.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.maitri.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.maitri.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.maitri.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child:
                            Text(widget.translateEn == "hi" ? 'गण' : 'Gan'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.gan.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.gan.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.gan.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.gan.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(
                            widget.translateEn == "hi" ? 'भकूट' : 'Bhakoot'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.bhakut.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.bhakut.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.bhakut.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.bhakut.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(
                            widget.translateEn == "hi" ? 'नाड़ी' : 'Naadi'))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.maleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.femaleKootAttribute}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.vashya.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(Center(
                        child: Text(widget.translateEn == "hi"
                            ? 'कुल अंक'
                            : 'Total Marks'))),
                    const DataCell(Center(child: Text("-"))),
                    const DataCell(Center(child: Text("-"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.total.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.ashtakootData.total.receivedPoints}"))),
                  ]),
                ],
              )),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4.0)),
              child: Column(
                children: [
                  const Text(
                    "निष्कर्ष:",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text(
                    "${widget.data?.ashtakootData.conclusion.report}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: widget.fontSizeDefault),
                  ),
                ],
              )),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
