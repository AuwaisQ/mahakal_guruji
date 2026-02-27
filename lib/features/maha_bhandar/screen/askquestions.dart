import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mahakal/features/maha_bhandar/model/faq_details_model.dart';
import 'package:toggle_list/toggle_list.dart';

import '../../../../data/datasource/remote/http/httpClient.dart';

class Askquestions extends StatefulWidget {
  final String type;
  final String translateEn;
  const Askquestions(
      {super.key, required this.type, required this.translateEn});

  @override
  State<Askquestions> createState() => _AskquestionsState();
}

class _AskquestionsState extends State<Askquestions> {
  List<Faqdetail> faqModelList = <Faqdetail>[];

  void getFaqDetails(String type) async {
    var res = await HttpService().postApi("/api/v1/faq", {"type": type});
    print("Api response data FAQ $res");
    setState(() {
      List faqList = res["data"];
      faqModelList.addAll(faqList.map((e) => Faqdetail.fromJson(e)));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFaqDetails(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Circular badge with icon
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Headline with animated underline
              Stack(
                children: [
                  Text(
                    widget.translateEn == "en" ? "FAQs" : "सामान्य प्रश्न",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade400,
                            Colors.orange.shade200,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            itemCount: faqModelList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12.0), // More rounded corners
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.shade50, // Light amber background
                      Colors.orange.shade100,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.orange.shade400, // Richer amber border
                    width: 1.5, // Slightly thicker border
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1), // Subtle shadow
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ToggleList(
                  trailing: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.deepOrange,
                    size: 30,
                  ),
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ToggleListItem(
                      isInitiallyExpanded: false,
                      title: widget.translateEn == "en"
                          ? Html(data: faqModelList[index].enQuestion)
                          : Html(data: faqModelList[index].hiQuestion),
                      content: Column(
                        children: [
                          const Divider(
                            color: Colors.grey,
                          ),
                          widget.translateEn == "en"
                              ? Html(data: faqModelList[index].enDetail)
                              : Html(data: faqModelList[index].hiDetail),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
