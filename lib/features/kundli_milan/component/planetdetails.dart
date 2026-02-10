import 'package:flutter/material.dart';
import '../models/planetDetailModel.dart';

class PlanetDetailView extends StatelessWidget {
  PlanetDetailModel? data;
  final double fontSizeDefault;
  PlanetDetailView(
      {super.key, required this.data, required this.fontSizeDefault});

  List<PlanetDetailModel> parsePlanetDetails(Map<String, dynamic> jsonData) {
    List planetList = jsonData['planetData']['male_planet_details'];
    return planetList
        .map((planet) => PlanetDetailModel.fromJson(planet))
        .toList();
  }

  Widget MaleTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: DataTable(
          // ignore: deprecated_member_use
          dataRowHeight: 45,
          border: const TableBorder(
            bottom: BorderSide(color: Colors.orange),
          ),
          columnSpacing: 20,
          headingTextStyle:
              TextStyle(color: Colors.white, fontSize: fontSizeDefault),
          dataTextStyle: TextStyle(fontSize: fontSizeDefault),
          headingRowColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return Colors.black; // Change this to your desired color
          }),
          dataRowColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return Colors.orange.shade50; // Change this to your desired color
          }),
          columns: const <DataColumn>[
            DataColumn(label: Text('ग्रह')),
            DataColumn(label: Text('वक्री')),
            DataColumn(label: Text('राशि')),
            DataColumn(label: Text('अंश')),
            DataColumn(label: Text('राशि स्वामी')),
            DataColumn(label: Text('नक्षत्र')),
            DataColumn(label: Text('नक्षत्र स्वामी')),
            DataColumn(label: Text('भाव')),
          ],
          rows: data!.planetData.malePlanetDetails.map((planet) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Center(child: Text(planet.name.toString()))),
                const DataCell(Center(child: Text("-"))),
                DataCell(Center(child: Text(planet.sign.toString()))),
                const DataCell(Center(child: Text("Soon"))),
                DataCell(Center(child: Text(planet.signLord.toString()))),
                DataCell(Text(planet.nakshatra.toString())),
                DataCell(Center(child: Text(planet.nakshatraLord.toString()))),
                DataCell(Center(child: Text(planet.house.toString()))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget FemaleTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: DataTable(
          // ignore: deprecated_member_use
          dataRowHeight: 45,
          border: const TableBorder(
            bottom: BorderSide(color: Colors.orange),
          ),
          columnSpacing: 20,
          headingTextStyle:
              TextStyle(color: Colors.white, fontSize: fontSizeDefault),
          dataTextStyle: TextStyle(fontSize: fontSizeDefault),
          headingRowColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return Colors.black; // Change this to your desired color
          }),
          dataRowColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return Colors.orange.shade50; // Change this to your desired color
          }),
          columns: const <DataColumn>[
            DataColumn(label: Text('ग्रह')),
            DataColumn(label: Text('वक्री')),
            DataColumn(label: Text('राशि')),
            DataColumn(label: Text('अंश')),
            DataColumn(label: Text('राशि स्वामी')),
            DataColumn(label: Text('नक्षत्र')),
            DataColumn(label: Text('नक्षत्र स्वामी')),
            DataColumn(label: Text('भाव')),
          ],
          rows: data!.planetData.femalePlanetDetails.map((planet) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Center(child: Text(planet.name.toString()))),
                const DataCell(Center(child: Text("-"))),
                DataCell(Center(child: Text(planet.sign.toString()))),
                const DataCell(Center(child: Text("Soon"))),
                DataCell(Center(child: Text(planet.signLord.toString()))),
                DataCell(Text(planet.nakshatra.toString())),
                DataCell(Center(child: Text(planet.nakshatraLord.toString()))),
                DataCell(Center(child: Text(planet.house.toString()))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              const TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Male",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Female",
                    ),
                  ),
                ],
                indicatorColor: Colors.orange,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.5),
                unselectedLabelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Roboto-Regular',
                    letterSpacing: 0.5),
              ),
              Expanded(
                child: TabBarView(
                  children: [MaleTab(), FemaleTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DataColumn(label: Text('ग्रह'))),
// DataColumn(label: Text('वक्री')),
// DataColumn(label: Text('राशि')),
// DataColumn(label: Text('अंश')),
// DataColumn(label: Text('राशि स्वामी')),
// DataColumn(label: Text('नक्षत्र')),
// DataColumn(label: Text('नक्षत्र स्वामी')),
// DataColumn(label: Text('भाव')),
