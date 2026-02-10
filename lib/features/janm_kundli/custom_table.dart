import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final String title;
  final List<List<String>> data;

  const CustomTable({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 20,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(),
                        child: Center(
                            child: Image.asset(
                          'assets/images/table.png',
                          fit: BoxFit.cover,
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: Table(
                          border: const TableBorder(
                            verticalInside:
                                BorderSide(color: Colors.orange, width: 1),
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(),
                            1: FlexColumnWidth(),
                          },
                          children: List<TableRow>.generate(
                              data.length,
                              (index) => TableRow(
                                      decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? Colors.white.withOpacity(0.5)
                                            : const Color(0xFFFFD7AF)
                                                .withOpacity(0.5),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(data[index][0],
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  fontFamily: 'Roboto-Regular',
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(data[index][1],
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  fontFamily: 'Roboto-Regular',
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ])),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
