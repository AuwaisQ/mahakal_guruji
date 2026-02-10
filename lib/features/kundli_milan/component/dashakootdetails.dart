import 'package:flutter/material.dart';
import '../models/dashakootDetailModel.dart';

class DashakootDetailView extends StatefulWidget {
  DashakootDetailModel? data;
  String translateEn;
  DashakootDetailView(
      {super.key, required this.data, required this.translateEn});

  @override
  State<DashakootDetailView> createState() => _DashakootDetailViewState();
}

class _DashakootDetailViewState extends State<DashakootDetailView> {
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
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'दिन' : 'Day'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.dina.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.dina.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.dina.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.dina.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'गण' : 'Gan'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.gana.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.gana.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.gana.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.gana.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'योनि' : 'Yoni'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.yoni.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.yoni.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.yoni.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.yoni.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'राशि' : 'Sign'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.rashi.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.rashi.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.rashi.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.rashi.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi"
                          ? 'अधिपति'
                          : 'Lord of the Sign'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.rasyadhipati.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.rasyadhipati.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.rasyadhipati.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.rasyadhipati.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'रज्जू' : 'Rajjoo'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.rajju.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.rajju.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.rajju.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.rajju.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'वेध' : 'Vedh'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.vedha.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.vedha.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.vedha.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.vedha.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'वश्य' : 'Vashya'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.vashya.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.vashya.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.vashya.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.vashya.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi" ? 'महेंद्र' : 'Mahendra'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.mahendra.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.mahendra.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.mahendra.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.mahendra.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi"
                          ? 'स्त्री दीर्घा'
                          : 'Female Chart'),
                    ),
                    DataCell(Text(
                        "${widget.data?.dashakootData.streeDeergha.maleKootAttribute}")),
                    DataCell(Text(
                        "${widget.data?.dashakootData.streeDeergha.femaleKootAttribute}")),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.streeDeergha.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.streeDeergha.receivedPoints}"))),
                  ]),
                  DataRow(cells: [
                    DataCell(
                      Text(widget.translateEn == "hi"
                          ? 'कुल अंक'
                          : 'Total Marks'),
                    ),
                    const DataCell(Center(child: Text("-"))),
                    const DataCell(Center(child: Text("-"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.total.totalPoints}"))),
                    DataCell(Center(
                        child: Text(
                            "${widget.data?.dashakootData.total.receivedPoints}"))),
                  ]),
                ],
              )),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
//
// DataColumn(label: (Text(' गुण')),
// DataColumn(label: Text('पुरुष')),
// DataColumn(label: Text('महिला')),
// DataColumn(label: Text('कुल अंक')),
// DataColumn(label: Text('प्राप्त अंक')),
