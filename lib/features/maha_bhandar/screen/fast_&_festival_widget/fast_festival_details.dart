import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tdk_bouncingwidget/tdk_bouncingwidget.dart';

import '../../../splash/controllers/splash_controller.dart';

class FastFestivalsDetails extends StatefulWidget {
  final String title;
  final String hiDescription;
  final String enDescription;
  final String image;
  const FastFestivalsDetails(
      {super.key,
      required this.title,
      required this.hiDescription,
      required this.enDescription,
      required this.image});

  @override
  State<FastFestivalsDetails> createState() => _FastFestivalsDetailsState();
}

class _FastFestivalsDetailsState extends State<FastFestivalsDetails> {
  bool isTranslate = false;
  bool fontSizeChange = true;
  double fontSizeDefault = 18.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Row(
          children: [
            const Spacer(),
            fontSizeChange
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Slider(
                      inactiveColor: Colors.grey,
                      activeColor: Colors.orange,
                      label: "$fontSizeDefault",
                      value: fontSizeDefault,
                      min: 12.0,
                      max: 32.0,
                      onChanged: (double value) {
                        setState(() {
                          fontSizeDefault = value;
                        });
                      },
                    ),
                  ),
            FloatingActionButton.small(
              backgroundColor: Colors.orange,
              onPressed: () {
                setState(() {
                  fontSizeChange = !fontSizeChange;
                });
              },
              child: Icon(
                fontSizeChange ? Icons.text_fields : Icons.cancel,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: Text("${widget.title} Detail's",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              )),
          actions: [
            BouncingWidgetInOut(
              onPressed: () {
                setState(() {
                  isTranslate = !isTranslate;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: isTranslate ? Colors.orange : Colors.transparent,
                    border: Border.all(
                        color: isTranslate ? Colors.transparent : Colors.orange,
                        width: 2)),
                child: Icon(
                  Icons.translate,
                  color: isTranslate ? Colors.white : Colors.orange,
                  size: 20,
                ),
              ),
            ),
            BouncingWidgetInOut(
              onPressed: () {
                // SplashController se dynamically URL fetch karna
                var splashController =
                    Provider.of<SplashController>(context, listen: false);
                String? appUrl = 'https://google.com';

                if (Platform.isAndroid) {
                  appUrl = splashController
                      .configModel?.userAppVersionControl?.forAndroid?.link;
                } else if (Platform.isIOS) {
                  appUrl = splashController
                      .configModel?.userAppVersionControl?.forIos?.link;
                }

                // Null check (Agar appUrl null ho to default Google ka link use ho)
                appUrl ??= 'https://google.com';

                // Share content
                Share.share(
                  "📜 **${widget.title}** 🙏✨\n\n"
                  "${HtmlParser.parseHTML(widget.hiDescription).text}\n\n"
                  "अब पढ़ें **महाकाल ऐप** पर! 🔱🔥\n"
                  "अभी डाउनलोड करें और आध्यात्मिक ज्ञान प्राप्त करें! 📲💖\n"
                  "Download Now: $appUrl",
                  subject: '📖 धार्मिक ज्ञान और व्रत कथाएं',
                );

                // Share.share(
                //   "📜 **${widget.title}** 🙏✨\n\n"
                //       "${HtmlParser.parseHTML(widget.hiDescription).text}\n\n"
                //       "अब पढ़ें **महाकाल ऐप** पर! 🔱🔥\n"
                //       "अभी डाउनलोड करें और आध्यात्मिक ज्ञान प्राप्त करें! 📲💖\n"
                //       "Download Now: ${AppConstants.playStoreUrl}",
                //   subject: '📖 धार्मिक ज्ञान और व्रत कथाएं',
                // );

                setState(() {
                  isTranslate = !isTranslate;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.orange, width: 2)),
                child: const Icon(
                  Icons.share,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Center(
                  child: SizedBox(
                    width: 100,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 3,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    " ✤ ${widget.title} ✤ ",
                    style: TextStyle(
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
                //   child: Text(
                //     "⦿ ${isTranslate? widget.enDescription : widget.hiDescription}}",
                //     style: TextStyle(
                //       fontSize: screenHeight * 0.020,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  child: Html(
                      data: isTranslate
                          ? widget.enDescription
                          : widget.hiDescription,
                      style: {
                        'p': Style(fontSize: FontSize(fontSizeDefault)),
                        'li': Style(fontSize: FontSize(fontSizeDefault)),
                        'ul': Style(fontSize: FontSize(fontSizeDefault)),
                        'span': Style(fontSize: FontSize(fontSizeDefault)),
                        'strong': Style(fontSize: FontSize(fontSizeDefault)),
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
