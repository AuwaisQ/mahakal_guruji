import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';

double fontSizeDefault = 20;
bool gridList = false;
String translateEn = 'hi';
detailSheet(
  BuildContext context,
  String title,
  String image,
  String infohi,
  String infoen,
) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetter) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "✤ $title ✤",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: BouncingWidgetInOut(
                              onPressed: () {
                                modalSetter(() {
                                  gridList = !gridList;
                                  translateEn = gridList ? 'en' : 'hi';
                                });
                              },
                              bouncingType: BouncingType.bounceInAndOut,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color:
                                        gridList ? Colors.orange : Colors.white,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2)),
                                child: Center(
                                  child: Icon(Icons.translate,
                                      color: gridList
                                          ? Colors.white
                                          : Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //Image
                              Container(
                                padding: const EdgeInsets.all(1),
                                margin: const EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(image)),
                              ),

                              Text(
                                "⦿ More Detail's",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.030,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),

                              //information
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
                              //   child: Text(
                              //     info,
                              //     style: TextStyle(
                              //       fontSize: MediaQuery.of(context).size.height * 0.017,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.black,
                              //     ),
                              //   ),
                              // ),

                              Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15, top: 10),
                                  child: Html(
                                      data:
                                          translateEn == 'hi' ? infohi : infoen,
                                      style: {
                                        'p': Style(
                                            fontSize: FontSize(fontSizeDefault))
                                      })),

                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 40,
                      child: Slider(
                        inactiveColor: Colors.grey,
                        activeColor: Colors.orange,
                        label: "$fontSizeDefault",
                        value: fontSizeDefault,
                        min: 12.0,
                        max: 32.0,
                        onChanged: (double value) {
                          modalSetter(() {
                            fontSizeDefault = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}
