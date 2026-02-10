import 'package:flutter/material.dart';
import 'package:mahakal/features/maha_bhandar/screen/choghadiya_screen.dart';
import 'package:mahakal/features/maha_bhandar/screen/festival_screen.dart';
import 'package:mahakal/features/maha_bhandar/screen/ghrahokiSthiti_screen.dart';
import 'package:mahakal/features/maha_bhandar/screen/hora_screen.dart';
import 'package:mahakal/features/maha_bhandar/screen/panchang_screen.dart';
import 'package:mahakal/features/maha_bhandar/screen/shubh_muhurt.dart';
import 'package:mahakal/features/maha_bhandar/screen/today_screen.dart';
import 'package:intl/intl.dart';

import '../../../localization/language_constrants.dart';
import 'fast_screen.dart';

class MahaBhandar extends StatefulWidget {
  final int? tab;
  const MahaBhandar({super.key, this.tab});

  @override
  State<MahaBhandar> createState() => _MahaBhandarState();
}

class _MahaBhandarState extends State<MahaBhandar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController _pageController;
  final ScrollController scrollController = ScrollController();
  // int imageIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: 8, vsync: this, initialIndex: widget.tab!);
    _pageController = PageController(initialPage: widget.tab!);

    // Synchronize PageController with TabController
    _pageController.addListener(() {
      int newIndex = _pageController.page!.round();
      setState(() {
        tabController.index = newIndex;
        print("tab index ${tabController.index}");
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  String getNameindex(int index) {
    switch (index) {
      case 0:
        return "Today";
      case 1:
        return "Panchang";
      case 2:
        return "Choghadiya";
      case 3:
        return "Hora";
      case 4:
        return "Graho Ki Sthiti";
      case 5:
        return "Shubh Muhrt";
      case 6:
        return "Fast";
      case 7:
        return "Festival";
      default:
        return "Explore";
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String moonDate = DateFormat('dd-MMMM-yyyy').format(now);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          getNameindex(tabController.index),
          style: TextStyle(
            fontSize: h * 0.026,
            // color: Theme.of(context).primaryColor,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //TabView
            PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    tabController.index = index;
                  });
                },
                children: const [
                  TodayTab(),
                  PanchangScreen(),
                  ChoghadiyaScreen(),
                  HoraScreen(),
                  GrahiKiSthiti(),
                  ShubhMuhurat(),
                  FastView(),
                  FestivalsView(),
                ]),
            //Tabs
            Container(
              height: h * 0.1,
              color: Colors.white,
              child: TabBar(
                  onTap: (int int) {
                    setState(() {
                      getNameindex(int);
                      tabController.index = int;
                      _pageController.animateToPage(int,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    });
                  },
                  physics: const BouncingScrollPhysics(),
                  controller: tabController,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  dividerColor: Colors.white,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey.shade700,
                  unselectedLabelStyle: const TextStyle(letterSpacing: 0.1),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 0.7),
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(
                      text: getTranslated('today', context) ?? "Today",
                      icon: 0 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/Today_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/Today_icon_in.png",
                              height: 35,
                            ),
                    ),
                    Tab(
                      text: getTranslated('panchang', context) ?? "Panchang",
                      icon: 1 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/panchang_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/panchang_in.png",
                              height: 35,
                            ),
                    ),
                    Tab(
                      text:
                          getTranslated('choghadiya', context) ?? "Choghadiya",
                      icon: 2 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/chogadhiya_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/chogadhiya_in.png",
                              height: 35,
                            ),
                    ),
                    Tab(
                      text: getTranslated('hora', context) ?? "Hora",
                      icon: 3 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/hora_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/hora_in.png",
                              height: 35,
                            ),
                    ),
                    Tab(
                      text: getTranslated('graho_ki_isthiti', context) ??
                          "Graho Ki Isthiti",
                      icon: 4 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/grahoki_sthiti_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/graho_ki_sthiti_in.png",
                              height: 35,
                            ),
                    ),
                    Tab(
                      text: getTranslated('shubh_muhurt', context) ??
                          "Shubh Muhrt",
                      icon: 5 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/subh_muhurt_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/subh_muhurt _in.png",
                              height: 35,
                            ),
                    ),
                    Tab(
                      text: getTranslated('fast', context) ?? "Fast",
                      icon: 6 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/fast_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/fast_in.png",
                              height: 35,
                            ),
                    ),
                    Tab(
                      iconMargin: const EdgeInsets.only(bottom: 5),
                      text: getTranslated('festival', context) ?? "Festival",
                      icon: 7 == tabController.index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                "assets/testImage/panchangImages/images/festival_bg_ac.gif",
                                height: 35,
                              ))
                          : Image.asset(
                              "assets/testImage/panchangImages/images/festival_in.png",
                              height: 35,
                            ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
