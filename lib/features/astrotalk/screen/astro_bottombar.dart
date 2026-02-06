import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:mahakal/features/all_pandit/Pandit_Bottom_bar.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/main.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import '../../../common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import '../../../utill/dimensions.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../more/screens/more_screen_view.dart';
import '../components/astro_bottomItem.dart';
import 'astro_calldetails.dart';
import 'astro_live_streampage.dart';
import 'astro_home.dart';

class AstroBottomBar extends StatefulWidget {
  final int pageIndex;
  const AstroBottomBar({super.key, required this.pageIndex});

  @override
  State<AstroBottomBar> createState() => _AstroBottomBarState();
}

class _AstroBottomBarState extends State<AstroBottomBar> {
  PageController? _pageController;
  final ScrollController exploreScrollController = ScrollController();
  final ScrollController orderScrollController = ScrollController();
  final ScrollController menuScrollController = ScrollController();
  final ScrollController moreScrollController = ScrollController();
  final ScrollController homeScrollController = ScrollController();
  ScrollController? activeScrollController;
  int _pageIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    Provider.of<ProfileController>(Get.context!, listen: false)
        .getUserInfo(context);
    super.initState();
    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);
    _screens = [
      const SizedBox(),
      AstroTalkHome(scrollController: homeScrollController),
      const SizedBox(),
      const AstroCallLogPage(),
      PanditBottomBar(pageIndex: 0, panditId: 22, sellerId: 123, astroImage: "",)
      //AllPanditPage(isEngView: true, scrollController: moreScrollController,),
    ];
    _updateActiveScrollController();
  }

  void _updateActiveScrollController() {
    switch (_pageIndex) {
      case 0:
        activeScrollController = exploreScrollController;
        break;
      case 1:
        activeScrollController = homeScrollController;
        break;
      case 3:
        activeScrollController = orderScrollController;
        break;
      case 4:
        activeScrollController = moreScrollController;
        break;
      default:
        activeScrollController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool isGuestMode =
        !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          Navigator.pop(context);
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: ExpandableBottomSheet(
          background: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                    _updateActiveScrollController();
                  });
                },
                itemBuilder: (context, index) => _screens[index],
              ),
              Hidable(
                controller: activeScrollController ?? ScrollController(),
                preferredWidgetSize: MediaQuery.of(context).size,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: size.width,
                    height: 95,
                    child: Stack(
                      children: [
                        // CustomPaint(
                        //   size: Size(size.width, 95),
                        //   painter: BNBCustomPainter(context: context),
                        // ),
                        Center(
                          heightFactor: 0.6,
                          child: FloatingActionButton(
                            shape: CircleBorder(
                              side: BorderSide(
                                width: 2,
                                color: _pageIndex == 5
                                    ? Theme.of(context).cardColor
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            backgroundColor: _pageIndex == 5
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                            onPressed: () {
                              print('Astrologer Bottom Bar');
                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: const ShortsFeedScreen(),
                                  pageAnimationType: BottomToTopTransition(),
                                ),
                              );
                            },
                            elevation: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Icon(
                                Icons.live_tv,
                                color: _pageIndex == 5
                                    ? Theme.of(context).cardColor
                                    : Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.paddingSizeDefault),
                            width: size.width,
                            height: 95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AstroBottomNavItem(
                                  title: 'Explore',
                                  iconData: Icons.dashboard,
                                  isSelected: _pageIndex == 0,
                                  onTap: () {
                                     Navigator.pop(context);
                                  },
                                ),
                                AstroBottomNavItem(
                                  title: 'Astrologer',
                                  iconData: CupertinoIcons.chat_bubble_fill,
                                  isSelected: _pageIndex == 1,
                                  onTap: () => _setPage(1),
                                ),
                                AstroBottomNavItem(
                                  title: 'Live',
                                  iconData: CupertinoIcons.minus,
                                  isSelected: _pageIndex == 5,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageAnimationTransition(
                                        page: const ShortsFeedScreen(),
                                        pageAnimationType:
                                            BottomToTopTransition(),
                                      ),
                                    );
                                  },
                                ),
                                AstroBottomNavItem(
                                  title: 'Call',
                                  iconData: CupertinoIcons.phone_circle,
                                  isSelected: _pageIndex == 3,
                                  // onTap: () => _setPage(3),
                                  onTap: () {
                                    if (isGuestMode) {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (_) =>
                                              const NotLoggedInBottomSheetWidget());
                                    } else {
                                      _setPage(3);
                                    }
                                  },
                                ),
                                AstroBottomNavItem(
                                  title: 'GuruJi',
                                  iconData: Icons.person_2_sharp,
                                  isSelected: _pageIndex == 4,
                                  onTap: () => _setPage(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          enableToggle: false,
          expandableContent: const SizedBox(height: 300),
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
      _updateActiveScrollController();
    });
  }
}
