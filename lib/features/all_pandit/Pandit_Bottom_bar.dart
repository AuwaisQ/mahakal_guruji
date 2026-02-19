import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
import 'package:mahakal/call_service/call_service.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import '../../../common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import '../../../utill/dimensions.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import '../../localization/language_constrants.dart';
import '../../utill/customPainter.dart';
import '../astrotalk/components/astro_bottomItem.dart';
import '../astrotalk/screen/astro_calldetails.dart';
import '../astrotalk/screen/astro_home.dart';
import '../astrotalk/screen/astro_live_streampage.dart';
import '../astrotalk/screen/astro_profilepage.dart';
import '../auth/controllers/auth_controller.dart';
import '../more/screens/more_screen_view.dart';
import '../shop/controllers/shop_controller.dart';
import '../shop/domain/models/seller_model.dart';
import '../shop/screens/shop_screen.dart';
import 'All_Pandit_Couns_Screen.dart';
import 'All_Pandit_Pooja_Screen.dart';
import 'Model/all_pandit_model.dart';
import 'Model/all_pandit_service_model.dart';
import 'PanditBottomNavItem.dart';


/// PanditBottomBar StatefulWidget
class   PanditBottomBar extends StatefulWidget {
  final int pageIndex;
  final dynamic panditId;
  final dynamic sellerId;
  final String astroImage;

  const PanditBottomBar({
    super.key,
    required this.pageIndex,
    required this.panditId,
    required this.sellerId,
    required this.astroImage,
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
  final ScrollController menuScrollController = ScrollController();
  ScrollController? activeScrollController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  SellerModel? sellerModel;

  @override
  void initState() {
    super.initState();
      Provider.of<CallServiceProvider>(Get.context!, listen: false).getSIPData();
     Provider.of<ProfileController>(Get.context!, listen: false).getUserInfo(context);
    sellerModel =  Provider.of<ShopController>(Get.context!, listen: false).sellerModel;
    print('Pandit Id: ${widget.panditId}');
    print('Seller Id: ${widget.sellerId}');
    print('Seller model : $sellerModel');

    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);

    /// Screens with ID checks
    _screens = [
      // Pooja Screen
      AllPanditPoojaScreen(
        panditId: widget.panditId,
        sellerId: widget.sellerId,
        scrollController: poojaScrollController,
      ),

      // Counselling Screen
      AllPanditCounsScreen(
        panditId: widget.panditId,
        scrollController: counsellingScrollController,
      ),

      // Chat / Placeholder
      const SizedBox(),

      // Shop Screen
      TopSellerProductScreen(
        sellerId: int.tryParse('${widget.sellerId}'),
        temporaryClose: Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[1].shop?.temporaryClose,
        vacationStatus: Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[1].shop?.vacationStatus,
        vacationEndDate: Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[1].shop?.vacationEndDate,
        vacationStartDate: Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[1].shop?.vacationStartDate,
        name: Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[1].shop?.name,
        banner: Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[1].shop?.banner,
        image: Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[1].shop?.image,
        scrollController: shopScrollController,
      ),

      // menu Screen
      MoreScreen(scrollController: menuScrollController),
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
        activeScrollController = menuScrollController;
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
                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: AstrologerprofileView(
                                    id: '${widget.panditId}', // astroId still used for navigation
                                  ),
                                  pageAnimationType: BottomToTopTransition(),
                                ),
                              );

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
                                  title: '${getTranslated('POOJA', context)}',
                                  iconData: Icons.temple_hindu,
                                  isSelected: _pageIndex == 0,
                                  onTap: () => _setPage(0),
                                ),
                                PanditBottomNavItem(
                                  title: '${getTranslated('CONSULT', context)}',
                                  iconData: Icons.article_outlined,
                                  isSelected: _pageIndex == 1,
                                  onTap: () => _setPage(1),
                                ),
                                PanditBottomNavItem(
                                  title: '${getTranslated('chat', context)}',
                                  iconData: CupertinoIcons.minus,
                                  isSelected: _pageIndex == 5,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageAnimationTransition(
                                        page: AstrologerprofileView(
                                          id: '${widget.panditId}', // Still needed for navigation
                                        ),
                                        pageAnimationType: BottomToTopTransition(),
                                      ),
                                    );
                                  },
                                ),
                                PanditBottomNavItem(
                                  title: '${getTranslated('only_shop', context)}',
                                  iconData: CupertinoIcons.shopping_cart,
                                  isSelected: _pageIndex == 3,
                                  onTap: () => _setPage(3),
                                ),
                                PanditBottomNavItem(
                                  title: '${getTranslated('menu', context)}',
                                  iconData: Icons.menu,
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
