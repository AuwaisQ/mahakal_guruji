import 'package:flutter/material.dart';
import 'package:mahakal/features/product/controllers/seller_product_controller.dart';
import 'package:mahakal/localization/controllers/localization_controller.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/features/brand/controllers/brand_controller.dart';
import 'package:mahakal/features/category/controllers/category_controller.dart';
import 'package:mahakal/features/coupon/controllers/coupon_controller.dart';
import 'package:mahakal/features/shop/controllers/shop_controller.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/theme/controllers/theme_controller.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/common/basewidget/custom_app_bar_widget.dart';
import 'package:mahakal/common/basewidget/product_filter_dialog_widget.dart';
import 'package:mahakal/common/basewidget/search_widget.dart';
import 'package:mahakal/features/home/screens/home_screens.dart';
import 'package:mahakal/features/shop/screens/overview_screen.dart';
import 'package:mahakal/features/shop/widgets/shop_info_widget.dart';
import 'package:mahakal/features/shop/widgets/shop_product_view_list.dart';
import 'package:provider/provider.dart';

class TopSellerProductScreen extends StatefulWidget {
  final int? sellerId;
  final bool? temporaryClose;
  final bool? vacationStatus;
  final String? vacationEndDate;
  final String? vacationStartDate;
  final String? name;
  final String? banner;
  final String? image;
  final bool fromMore;
  final ScrollController? scrollController;
  const TopSellerProductScreen(
      {super.key,
      this.sellerId,
      this.temporaryClose,
      this.vacationStatus,
      this.vacationEndDate,
      this.vacationStartDate,
      this.name,
      this.banner,
      this.image,
      this.fromMore = false, this.scrollController,
      });

  @override
  State<TopSellerProductScreen> createState() => _TopSellerProductScreenState();
}

class _TopSellerProductScreenState extends State<TopSellerProductScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  bool vacationIsOn = false;
  TabController? _tabController;
  int selectedIndex = 0;

  void _load() async {
    if (widget.sellerId == null) {
      debugPrint('⚠️ sellerId is null, skipping _load()');
      return;
    }
    await Provider.of<SellerProductController>(context, listen: false)
        .getSellerProductList(widget.sellerId.toString(), 1, '');
    await Provider.of<ShopController>(Get.context!, listen: false)
        .getSellerInfo(widget.sellerId.toString());
    await Provider.of<SellerProductController>(Get.context!, listen: false)
        .getSellerWiseBestSellingProductList(widget.sellerId.toString(), 1);
    await Provider.of<SellerProductController>(Get.context!, listen: false)
        .getSellerWiseFeaturedProductList(widget.sellerId.toString(), 1);
    await Provider.of<SellerProductController>(Get.context!, listen: false)
        .getSellerWiseRecommandedProductList(widget.sellerId.toString(), 1);
    await Provider.of<CouponController>(Get.context!, listen: false)
        .getSellerWiseCouponList(widget.sellerId!, 1);
    await Provider.of<CategoryController>(Get.context!, listen: false)
        .getSellerWiseCategoryList(widget.sellerId!);
    await Provider.of<BrandController>(Get.context!, listen: false)
        .getSellerWiseBrandList(widget.sellerId!);
  }

  @override
  void initState() {
    super.initState();

    debugPrint('🟠 Initializing ${runtimeType.toString()}...');
    debugPrint('➡️ Received widget values:');
    debugPrint('   • sellerId: ${widget.sellerId}');
    debugPrint('   • temporaryClose: ${widget.temporaryClose}');
    debugPrint('   • vacationStatus: ${widget.vacationStatus}');
    debugPrint('   • vacationStartDate: ${widget.vacationStartDate}');
    debugPrint('   • vacationEndDate: ${widget.vacationEndDate}');
    debugPrint('   • name: ${widget.name}');
    debugPrint('   • banner: ${widget.banner}');
    debugPrint('   • image: ${widget.image}');
    debugPrint('   • fromMore: ${widget.fromMore}');
    debugPrint('---------------------------------------------');

    // Set the shop menu tab based on fromMore flag
    if (widget.fromMore) {
      debugPrint('🟢 fromMore = true → Setting menu index to 1');
      Provider.of<ShopController>(context, listen: false)
          .setMenuItemIndex(1, notify: false);
    } else {
      debugPrint('🔵 fromMore = false → Setting menu index to 0');
      Provider.of<ShopController>(context, listen: false)
          .setMenuItemIndex(0, notify: false);
    }

    // Clear the search field
    debugPrint('🧹 Clearing search controller...');
    searchController.clear();

    // Load initial data
    debugPrint('📦 Loading initial shop data via _load()...');
    _load();

    // Initialize tab controller based on fromMore flag
    if (widget.fromMore) {
      debugPrint('🟩 Creating TabController(initialIndex: 1)');
      _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
    } else {
      debugPrint('🟦 Creating TabController(initialIndex: 0)');
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    }

    debugPrint('✅ initState() complete for ${runtimeType.toString()}');
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.fromMore) {
  //     Provider.of<ShopController>(context, listen: false)
  //         .setMenuItemIndex(1, notify: false);
  //   } else {
  //     Provider.of<ShopController>(context, listen: false)
  //         .setMenuItemIndex(0, notify: false);
  //   }
  //
  //   searchController.clear();
  //   _load();
  //   if (widget.fromMore) {
  //     _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
  //   } else {
  //     _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.vacationEndDate != null && widget.vacationStartDate != null) {
      DateTime vacationDate = DateTime.parse(widget.vacationEndDate!);
      DateTime vacationStartDate = DateTime.parse(widget.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if (difference >= 0 && widget.vacationStatus == true && startDate <= 0) {
        vacationIsOn = true;
      } else {
        vacationIsOn = false;
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Pandit Shop",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        // appBar: CustomAppBar(
        //   title: widget.name,
        // ),
        body: Consumer<ShopController>(builder: (context, sellerProvider, _) {
          return CustomScrollView(controller: widget.scrollController, slivers: [
            SliverToBoxAdapter(
                child: ShopInfoWidget(
                    vacationIsOn: vacationIsOn,
                    sellerName: widget.name ?? "",
                    sellerId: widget.sellerId ?? 0,
                    banner: widget.banner ?? '',
                    shopImage: widget.image ?? '',
                    temporaryClose: widget.temporaryClose ?? false)),
            SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                    height: sellerProvider.shopMenuIndex == 1 ? 110 : 40,
                    child: Container(
                        color: Theme.of(context).canvasColor,
                        child: Column(children: [
                          Row(children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                color: Theme.of(context).canvasColor,
                                child: TabBar(
                                  physics: const NeverScrollableScrollPhysics(),
                                  isScrollable: true,
                                  dividerColor: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                  controller: _tabController,
                                  labelColor: Theme.of(context).primaryColor,
                                  unselectedLabelColor:
                                      Theme.of(context).hintColor,
                                  indicatorColor:
                                      Theme.of(context).primaryColor,
                                  indicatorWeight: 1,
                                  onTap: (value) {
                                    sellerProvider.setMenuItemIndex(value);
                                    searchController.clear();
                                  },
                                  indicatorPadding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.paddingSizeDefault),
                                  unselectedLabelStyle: textRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.w400),
                                  labelStyle: textRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.w700),
                                  tabs: [
                                    Tab(
                                        text:
                                            getTranslated('overview', context)),
                                    Tab(
                                        text: getTranslated(
                                            'all_products', context)),
                                  ],
                                ),
                              ),
                            ),
                            if (sellerProvider.shopMenuIndex == 1)
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: Provider.of<LocalizationController>(context, listen: false).isLtr
                                          ? Dimensions.paddingSizeDefault
                                          : 0,
                                      left: Provider.of<LocalizationController>(context, listen: false).isLtr
                                          ? 0
                                          : Dimensions.paddingSizeDefault),
                                  child: InkWell(
                                      onTap: () => showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (c) => ProductFilterDialog(
                                              sellerId: widget.sellerId!)),
                                      child: Container(
                                          decoration:
                                              BoxDecoration(color: Provider.of<ThemeController>(context, listen: false).darkTheme ? Colors.white : Theme.of(context).cardColor, border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.5)), borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                                          width: 30,
                                          height: 30,
                                          child: Padding(padding: const EdgeInsets.all(5.0), child: Image.asset(Images.filterImage)))))
                          ]),
                          if (sellerProvider.shopMenuIndex == 1)
                            Container(
                                color: Theme.of(context).canvasColor,
                                child: SearchWidget(
                                    hintText:
                                        '${getTranslated('search_hint', context)}',
                                    sellerId: widget.sellerId ?? 0))
                        ])))),
            SliverToBoxAdapter(
                child: sellerProvider.shopMenuIndex == 0
                    ? ShopOverviewScreen(
                        sellerId: widget.sellerId ?? 0,
                        scrollController: widget.scrollController ?? _scrollController,
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeSmall,
                            Dimensions.paddingSizeSmall,
                            Dimensions.paddingSizeSmall,
                            0),
                        child: ShopProductViewList(
                            scrollController: widget.scrollController ?? _scrollController,
                            sellerId: widget.sellerId ?? 0))),
          ]);
        }));
  }
}
