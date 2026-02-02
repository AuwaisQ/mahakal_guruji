import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/main.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import '../../../utill/dimensions.dart';
import '../../utill/customPainter.dart';
import '../astrotalk/screen/astro_profilepage.dart';
import '../auth/controllers/auth_controller.dart';
import '../more/screens/more_screen_view.dart';
import '../shop/controllers/shop_controller.dart';
import '../shop/screens/shop_screen.dart';
import 'All_Pandit_Couns_Screen.dart';
import 'All_Pandit_Pooja_Screen.dart';
import 'Model/all_pandit_model.dart';
import 'PanditBottomNavItem.dart';

/// ==========================
/// NoDataScreen Widget
/// ==========================
import 'package:flutter/material.dart';

class NoDataScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const NoDataScreen({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          'Info',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// PanditBottomBar StatefulWidget
class PanditBottomBar extends StatefulWidget {
  final int pageIndex;
  final dynamic panditId;
  final dynamic sellerId;
  final String astroImage;
  final List<OtherSkill> otherSkills;

  const PanditBottomBar({
    super.key,
    required this.pageIndex,
    required this.panditId,
    required this.sellerId,
    required this.astroImage, required this.otherSkills,
  });

  @override
  State<PanditBottomBar> createState() => _PanditBottomBarState();
}

class _PanditBottomBarState extends State<PanditBottomBar> {
  PageController? _pageController;
  final ScrollController poojaScrollController = ScrollController();
  final ScrollController counsellingScrollController = ScrollController();
  final ScrollController chatScrollController = ScrollController();
  final ScrollController shopScrollController = ScrollController();
  final ScrollController eventScrollController = ScrollController();
  ScrollController? activeScrollController;
  int _pageIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileController>(Get.context!, listen: false)
        .getUserInfo(context);

    print("Pandit Id: ${widget.panditId}");
    print("Seller Id: ${widget.sellerId}");
    print("Other Skills: ${widget.otherSkills}");

    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);

    /// Screens with ID checks
    _screens = [
      // Pooja Screen
      widget.panditId != null
          ? AllPanditPoojaScreen(
        panditId: widget.panditId,
        scrollController: poojaScrollController,
      )
          : const NoDataScreen(
        title: "No Pooja Data",
        subtitle: "Coming Soon. Please check back later.",
      ),

      // Counselling Screen
      widget.panditId != null
          ? AllPanditCounsScreen(
        panditId: widget.panditId,
        scrollController: counsellingScrollController,
      )
          : const NoDataScreen(
        title: "No Advising Data",
        subtitle: "Coming Soon. Please check back later.",
      ),

      // Chat / Placeholder
      const SizedBox(),

      // Shop Screen
      widget.sellerId != null
          ? TopSellerProductScreen(
        sellerId: int.tryParse("${widget.sellerId}"),
        temporaryClose:
        Provider.of<ShopController>(context, listen: false)
            .sellerModel
            ?.sellers?[1]
            .shop
            ?.temporaryClose,
        vacationStatus:
        Provider.of<ShopController>(context, listen: false)
            .sellerModel
            ?.sellers?[1]
            .shop
            ?.vacationStatus,
        vacationEndDate:
        Provider.of<ShopController>(context, listen: false)
            .sellerModel
            ?.sellers?[1]
            .shop
            ?.vacationEndDate,
        vacationStartDate:
        Provider.of<ShopController>(context, listen: false)
            .sellerModel
            ?.sellers?[1]
            .shop
            ?.vacationStartDate,
        name: Provider.of<ShopController>(context, listen: false)
            .sellerModel
            ?.sellers?[1]
            .shop
            ?.name,
        banner: Provider.of<ShopController>(context, listen: false)
            .sellerModel
            ?.sellers?[1]
            .shop
            ?.banner,
        image: Provider.of<ShopController>(context, listen: false)
            .sellerModel
            ?.sellers?[1]
            .shop
            ?.image,
        scrollController: shopScrollController,
      )
          : const NoDataScreen(
        title: "No Shop Data",
        subtitle: "Coming Soon. Please check back later.",
      ),

      MoreScreen(scrollController: eventScrollController),

      // // Event Screen
      // widget.panditId != null
      //     ? ComingSoonWidget(
      //  // panditId: widget.panditId,
      //  // scrollController: eventScrollController,
      // )
      //     : const NoDataScreen(
      //   title: "No Event Data",
      //   subtitle: "Coming Soon. Please check back later.",
      // ),
    ];

    _updateActiveScrollController();
  }

  void _updateActiveScrollController() {
    switch (_pageIndex) {
      case 0:
        activeScrollController = poojaScrollController;
        break;
      case 1:
        activeScrollController = counsellingScrollController;
        break;
      case 3:
        activeScrollController = shopScrollController;
        break;
      case 4:
        activeScrollController = eventScrollController;
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
          _setPage(0);
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
                        CustomPaint(
                          size: Size(size.width, 95),
                          painter: BNBCustomPainter(context: context),
                        ),
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
                              if (widget.otherSkills != null && widget.otherSkills.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  PageAnimationTransition(
                                    page: AstrologerprofileView(
                                      id: '${widget.otherSkills[0].id}', // astroId still used for navigation
                                      astrologerImage: '${widget.astroImage}',
                                    ),
                                    pageAnimationType: BottomToTopTransition(),
                                  ),
                                );
                              } else {
                                NoDataScreen(title: '', subtitle: '',);
                              }
                            },

                            elevation: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Icon(
                                Icons.chat,
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
                                PanditBottomNavItem(
                                  title: 'Pooja',
                                  iconData: Icons.temple_hindu,
                                  isSelected: _pageIndex == 0,
                                  onTap: () => _setPage(0),
                                ),
                                PanditBottomNavItem(
                                  title: 'Consult',
                                  iconData: Icons.article_outlined,
                                  isSelected: _pageIndex == 1,
                                  onTap: () => _setPage(1),
                                ),
                                PanditBottomNavItem(
                                  title: 'Chat',
                                  iconData: CupertinoIcons.minus,
                                  isSelected: _pageIndex == 5,
                                  onTap: () {
                                    if (widget.otherSkills != null && widget.otherSkills.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        PageAnimationTransition(
                                          page: AstrologerprofileView(
                                            id: '${widget.otherSkills[0].id}', // Still needed for navigation
                                            astrologerImage: '${widget.astroImage}',
                                          ),
                                          pageAnimationType: BottomToTopTransition(),
                                        ),
                                      );
                                    } else {
                                      NoDataScreen(title: '', subtitle: '',);
                                    }
                                  },
                                ),
                                PanditBottomNavItem(
                                  title: 'Shop',
                                  iconData: CupertinoIcons.shopping_cart,
                                  isSelected: _pageIndex == 3,
                                  onTap: () => _setPage(3),
                                ),
                                PanditBottomNavItem(
                                  title: 'Menu',
                                  iconData: Icons.event,
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
