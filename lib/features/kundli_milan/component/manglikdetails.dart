import 'package:flutter/material.dart';

import '../models/manglikDetailModel.dart';

class ManglikDetailView extends StatefulWidget {
  ManglikDetailModel? data;
  final double fontSizeDefault;
  final String translateEn;
  ManglikDetailView(
      {super.key,
      required this.data,
      required this.fontSizeDefault,
      required this.translateEn});

  @override
  State<ManglikDetailView> createState() => _ManglikDetailViewState();
}

class _ManglikDetailViewState extends State<ManglikDetailView> {
  Widget MaleTab() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.cyan.shade50,
                    borderRadius: BorderRadius.circular(4.0)),
                child: Center(
                    child: Text(
                  widget.translateEn == "hi"
                      ? "पुरुष का मंगली प्रतिशत: ${widget.data?.manglikData.male.percentageManglikPresent} %"
                      : "Male is ${widget.data?.manglikData.male.percentageManglikPresent} % manglik",
                  style: TextStyle(
                      fontSize: widget.fontSizeDefault,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ))),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.translateEn == "hi"
                  ? "भाव के आधार पर :"
                  : "Based on Bhava :",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data?.manglikData.male.manglikPresentRule
                  .basedOnHouse.length,
              itemBuilder: (context, index) {
                return Text(
                  "${index + 1}.  ${widget.data?.manglikData.male.manglikPresentRule.basedOnHouse[index]}",
                  style: TextStyle(fontSize: widget.fontSizeDefault),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.translateEn == "hi"
                  ? "दृष्टि के आधार पर :"
                  : "Based on Drishti :",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data?.manglikData.male.manglikPresentRule
                  .basedOnAspect.length,
              itemBuilder: (context, index) {
                return Text(
                  "${index + 1}.  ${widget.data?.manglikData.male.manglikPresentRule.basedOnAspect[index]}",
                  style: TextStyle(fontSize: widget.fontSizeDefault),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.translateEn == "hi"
                  ? "मांगलिक प्रभाव :"
                  : "Manglik Effect",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Text(
              "${widget.data?.manglikData.male.manglikStatus}",
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.translateEn == "hi"
                  ? "मांगलिक विश्लेषण :"
                  : "Manglik Analysis",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Text(
              "${widget.data?.manglikData.male.manglikReport}",
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4.0)),
                child: Column(
                  children: [
                    Text(
                      widget.translateEn == "hi" ? "निष्कर्ष:" : "Conclusion",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      "${widget.data?.manglikData.conclusion.report}",
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
      ),
    );
  }

  Widget FemaleTab() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.cyan.shade50,
                    borderRadius: BorderRadius.circular(4.0)),
                child: Center(
                    child: Text(
                  "Female is ${widget.data?.manglikData.female.percentageManglikPresent} % manglik",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: widget.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                ))),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "भाव के आधार पर :",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data?.manglikData.female.manglikPresentRule
                  .basedOnHouse.length,
              itemBuilder: (context, index) {
                return Text(
                  "${index + 1}.  ${widget.data?.manglikData.female.manglikPresentRule.basedOnHouse[index]}",
                  style: TextStyle(fontSize: widget.fontSizeDefault),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "दृष्टि के आधार पर :",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data?.manglikData.female.manglikPresentRule
                  .basedOnAspect.length,
              itemBuilder: (context, index) {
                return Text(
                  "${index + 1}.  ${widget.data?.manglikData.female.manglikPresentRule.basedOnAspect[index]}",
                  style: TextStyle(fontSize: widget.fontSizeDefault),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "मांगलिक प्रभाव :",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Text(
              "${widget.data?.manglikData.female.manglikStatus}",
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "मांगलिक विश्लेषण :",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Text(
              "${widget.data?.manglikData.female.manglikReport}",
              style: TextStyle(fontSize: widget.fontSizeDefault),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
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
                      "${widget.data?.manglikData.conclusion.report}",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
    );
  }
}
