import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/product/domain/models/product_model.dart';
import 'package:mahakal/features/product/screens/productlist_details_page.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/basewidget/custom_image_widget.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/responsive_helper.dart';
import '../../../localization/language_constrants.dart';
import '../../../main.dart';
import '../../../theme/controllers/theme_controller.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../all_pandit/location_search_widget.dart';
import '../../banner/controllers/banner_controller.dart';
import '../../banner/domain/models/banner_model.dart';
import '../../category/domain/models/category_model.dart';
import '../../deal/controllers/featured_deal_controller.dart';
import '../../product_details/screens/product_details_screen.dart';
import '../../shop/domain/models/seller_model.dart';
import '../../shop/widgets/seller_card.dart';
import '../../shop/widgets/top_seller_shimmer.dart';
import '../../splash/controllers/splash_controller.dart';

import 'brand_and_category_product_screen.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // category product
  List<Product> homeDecorList = [];
  List<Product> pujaEssentialList = [];
  List<Product> braceletList = [];
  List<Product> poojaList = [];
  List<Product> rosaryList = [];
  List<Product> handmadeProductsList = [];
  List<Product> statueList = [];
  List<Product> yogaMeditationList = [];
  List<Product> rudrakshList = [];
  List<Product> devotionalClothesList = [];
  List<Product> gemsList = [];
  List<Product> attarList = [];


  List<Product> latestProducts = [];
  List<Product> featureProducts = [];
  List<CategoryModel> categoryList = [];
  List<Seller> sellerList = [];
  List<BannerModel> bannerList = [];

  // List<Product> filteredProducts = [];
  TextEditingController countryController = TextEditingController();
  String searchText = '';
  String currentLocation = 'Fetching location...';
  bool isLoading = true;
  String onlyCity = '';
  double latiTude = 0.0;
  double longiTude = 0.0;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    fetchCurrentAddressAndCity();
    Provider.of<FeaturedDealController>(Get.context!, listen: false)
        .getFeaturedDealList(false);
  }

  @override
  void dispose() {
    countryController.dispose();
    super.dispose();
  }


  String selectedCity = '';

  Future<void> fetchCurrentAddressAndCity() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1️⃣ Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Location Service Disabled'),
          content: const Text(
            'Please enable location service to fetch your address.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  isLoading = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // 2️⃣ Check permissions
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      bool userChoice = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Allow Location Access'),
          content: const Text(
            'We need your location to fetch nearby products and offers. Do you want to allow?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Allow'),
            ),
          ],
        ),
      );

      if (userChoice == true) {
        permission = await Geolocator.requestPermission();
      } else {
        return; // user declined
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Permission Permanently Denied'),
          content: const Text(
            'You have permanently denied location access. Please enable it from settings manually.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // 3️⃣ Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4️⃣ Reverse geocoding
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      // Full address
      String fullAddress =
          "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
      countryController.text = fullAddress;

      // Only city
      selectedCity = place.locality ?? '';

      print('Full address: $fullAddress');
      print('City: $selectedCity');

      // ✅ Call getProducts with city
      getProducts(selectedCity.toLowerCase());
    }
  }

  void getProducts(String city) async {
    setState(() {
      isLoading = true;
      onlyCity = city;
    });
    var res = await HttpService().getApi('/api/v1/products/same-day-delivery?city=$city');
    if (res['status']) {
      setState(() {
        categoryList.clear();
        homeDecorList.clear();
        pujaEssentialList.clear();
        braceletList.clear();
        poojaList.clear();
        rosaryList.clear();
        handmadeProductsList.clear();
        statueList.clear();
        yogaMeditationList.clear();
        rudrakshList.clear();
        devotionalClothesList.clear();
        gemsList.clear();
        attarList.clear();

        latestProducts.clear();
        featureProducts.clear();
        categoryList.clear();
        sellerList.clear();
        bannerList.clear();
        // category products
        List homeDecor =  res['category-product']['Home Decor'] ?? [];
        List pujaEssential =  res['category-product']['Pujan Essentials'] ?? [];
        List bracelet =  res['category-product']['Bracelet'] ?? [];
        List pooja =  res['category-product']['Pooja'] ?? [];
        List rosary =  res['category-product']['Rosary'] ?? [];
        List handmadeProducts =  res['category-product']['Handmade Products'] ?? [];
        List statue =  res['category-product']['Statue'] ?? [];
        List yogaMeditation =  res['category-product']['Yoga & Meditation'] ?? [];
        List rudraksh =  res['category-product']['Rudraksh'] ?? [];
        List devotionalClothes =  res['category-product']['Devotional Clothes'] ?? [];
        List gems =  res['category-product']['Gems'] ?? [];
        List attar =  res['category-product']['Attar'] ?? [];

        List latest =  res['latest-product']['products'] ?? [];
        List product =  res['featured-product']['products'] ?? [];
        List category = res['categories'] ?? [];
        List seller = res['seller'] ?? [];
        List banner = res['banner'] ?? [];

        // catefory products
        homeDecorList.addAll(homeDecor.map((e) => Product.fromJson(e)));
        pujaEssentialList.addAll(pujaEssential.map((e) => Product.fromJson(e)));
        braceletList.addAll(bracelet.map((e) => Product.fromJson(e)));
        poojaList.addAll(pooja.map((e) => Product.fromJson(e)));
        rosaryList.addAll(rosary.map((e) => Product.fromJson(e)));
        handmadeProductsList.addAll(handmadeProducts.map((e) => Product.fromJson(e)));
        statueList.addAll(statue.map((e) => Product.fromJson(e)));
        yogaMeditationList.addAll(yogaMeditation.map((e) => Product.fromJson(e)));
        rudrakshList.addAll(rudraksh.map((e) => Product.fromJson(e)));
        devotionalClothesList.addAll(devotionalClothes.map((e) => Product.fromJson(e)));
        gemsList.addAll(gems.map((e) => Product.fromJson(e)));
        attarList.addAll(attar.map((e) => Product.fromJson(e)));

        latestProducts.addAll(latest.map((e) => Product.fromJson(e)));
        featureProducts.addAll(product.map((e) => Product.fromJson(e)));
        categoryList.addAll(category.map((e) => CategoryModel.fromJson(e)));
        sellerList.addAll(seller.map((e) => Seller.fromJson(e)));
        bannerList.addAll(banner.map((e) => BannerModel.fromJson(e)));

        isLoading = false;
        AppLocationData.selectedCityProduct = city;
      });
      print('APi response product ${featureProducts.length} $res');
    } else {
      setState(() {
        featureProducts.clear();
        isLoading = false;
        AppLocationData.selectedCityProduct = city;
      });

    }
  }

  // Future<void> getProducts(String city) async {
  //   setState(() => isLoading = true);
  //
  //   try {
  //     final res = await HttpService()
  //         .getApi('/api/v1/products/same-day-delivery?city=$city');
  //
  //     if (res['status'] != true) {
  //       throw Exception("API Failed");
  //     }
  //
  //     _clearAllLists();
  //
  //     final categoryProduct = res['category-product'] ?? {};
  //
  //     _addProducts(homeDecorList, categoryProduct['Home Decor']);
  //     _addProducts(pujaEssentialList, categoryProduct['Pujan Essentials']);
  //     _addProducts(braceletList, categoryProduct['Bracelet']);
  //     _addProducts(poojaList, categoryProduct['Pooja']);
  //     _addProducts(rosaryList, categoryProduct['Rosary']);
  //     _addProducts(handmadeProductsList, categoryProduct['Handmade Products']);
  //     _addProducts(statueList, categoryProduct['Statue']);
  //     _addProducts(yogaMeditationList, categoryProduct['Yoga & Meditation']);
  //     _addProducts(rudrakshList, categoryProduct['Rudraksh']);
  //     _addProducts(devotionalClothesList, categoryProduct['Devotional Clothes']);
  //     _addProducts(gemsList, categoryProduct['Gems']);
  //     _addProducts(attarList, categoryProduct['Attar']);
  //
  //     _addProducts(latestProducts, res['latest-product']?['products']);
  //     _addProducts(featureProducts, res['featured-product']?['products']);
  //
  //     List category = res['categories'] ?? [];
  //     List seller = res['seller'] ?? [];
  //     List banner = res['banner'] ?? [];
  //     categoryList.addAll(category.map((e) => CategoryModel.fromJson(e)));
  //     sellerList.addAll(seller.map((e) => Seller.fromJson(e)));
  //     bannerList.addAll(banner.map((e) => BannerModel.fromJson(e)));
  //
  //     AppLocationData.selectedCityProduct = city;
  //
  //   } catch (e) {
  //     featureProducts.clear();
  //     debugPrint("Product API Error: $e");
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }
  //
  //
  // void _addProducts(List<Product> target, dynamic data) {
  //   if (data != null && data is List) {
  //     target.addAll(data.map((e) => Product.fromJson(e)));
  //   }
  // }
  //
  // void _clearAllLists() {
  //   categoryList.clear();
  //   homeDecorList.clear();
  //   pujaEssentialList.clear();
  //   braceletList.clear();
  //   poojaList.clear();
  //   rosaryList.clear();
  //   handmadeProductsList.clear();
  //   statueList.clear();
  //   yogaMeditationList.clear();
  //   rudrakshList.clear();
  //   devotionalClothesList.clear();
  //   gemsList.clear();
  //   attarList.clear();
  //   latestProducts.clear();
  //   featureProducts.clear();
  //   sellerList.clear();
  //   bannerList.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LocationSearchWidget(
                mapController: _controller,
                controller: countryController,
                onLocationSelected: (lat, lng, address) {
                  setState(() {
                    latiTude = lat;
                    longiTude = lng;
                    String fullAddress = address;
                    String city = fullAddress.split(',')[0];
                    getProducts(city);
                  });
                },
              ),
            ),

            bannerCarouselWidget(),
            
            _sectionTitle('Categories',Icons.category, showButton: false,),
            categoryList.isNotEmpty
            ? _categoryGrid()
            : categoryGridShimmer(context),


            // Featured Product day
            _sectionTitle('Featured Products',Icons.shopping_cart ,type: 'featured',),
            productWidget(featureProducts),

            _sectionTitle('Top Seller',Icons.add_business, type: 'seller'),
            Padding(
                padding: const EdgeInsets.only(
                    bottom: Dimensions.homePagePadding),
                child: SizedBox(
                    height: ResponsiveHelper.isTab(context)
                        ? 170
                        : 165,
                    child: sellerList.isNotEmpty
                        ? ListView.builder(
                      itemCount: sellerList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection:Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            width: 250,
                            child: SellerCard(
                                sellerModel: sellerList[index],
                                isHomePage: true,
                                index: index,
                                length: sellerList.length ??
                                    0));
                      },
                    ) : const TopSellerShimmer())),

            // latest products
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(20)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFF7043),
                    Color(0xFFFFB74D),
                    Colors.white,
                    Colors.white
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Left content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.local_fire_department_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Latest Products',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                'Same-day delivery on our newest arrivals',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// CTA
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ProductDetailsScreen(city: onlyCity, type: 'latest',),
                              ),);
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: Color(0xFFFF7043),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🛍 Products
                  productWidget(latestProducts),
                ],
              ),
            ),
            // ------------------------------------------- //


            // category products
            _sectionTitle('Home Decore',Icons.maps_home_work_outlined, type: 'category',subType: 'home'),
            productWidget(homeDecorList),

            _sectionTitle('Pujan Essential',Icons.temple_hindu, type: 'category',subType: 'pujan'),
            productWidget(pujaEssentialList),

            _sectionTitle('Bracelet',Icons.filter_b_and_w, type: 'category',subType: 'bracelet'),
            productWidget(braceletList),

            _sectionTitle('Puja',Icons.shopping_bag, type: 'category',subType: 'puja'),
            productWidget(poojaList),

            _sectionTitle('Rosary',Icons.shopping_bag, type: 'category',subType: 'rosary'),
            productWidget(rosaryList),

            _sectionTitle('Handmade Products',Icons.shopping_cart, type: 'category',subType: 'handmade'),
            productWidget(handmadeProductsList),

            _sectionTitle('Statue',Icons.person_4, type: 'category',subType: 'statue'),
            productWidget(statueList),

            _sectionTitle('Yoga & Meditation',Icons.shopping_cart, type: 'category',subType: 'yoga'),
            productWidget(yogaMeditationList),

            _sectionTitle('Rudraksh',Icons.circle, type: 'category',subType: 'rudraksh'),
            productWidget(rudrakshList),

            _sectionTitle('Devotional Clothes',Icons.shopping_cart, type: 'category',subType: 'devotees'),
            productWidget(devotionalClothesList),

            _sectionTitle('Gems',Icons.circle, type: 'category',subType: 'gems'),
            productWidget(gemsList),

            _sectionTitle('Attar',Icons.local_grocery_store, type: 'category',subType: 'attar'),
            productWidget(attarList),


            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget bannerCarouselWidget() {
    return bannerList.isNotEmpty
        ? SizedBox(
      height: MediaQuery.of(context).size.width * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  aspectRatio: 4 / 1,
                  viewportFraction: 0.8,
                  autoPlay: true,
                  pauseAutoPlayOnTouch: true,
                  pauseAutoPlayOnManualNavigate: true,
                  pauseAutoPlayInFiniteScroll: true,
                  enlargeFactor: .2,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  onPageChanged: (index, reason) {
                    Provider.of<BannerController>(context,
                        listen: false)
                        .setCurrentIndex(index);
                  }),
              itemCount: bannerList.length,
              itemBuilder: (context, index, _) {
                return InkWell(
                  onTap: () {
                    // if (bannerProvider
                    //     .mainBannerList![index]
                    //     .resourceId !=
                    //     null) {
                    //   bannerProvider.clickBannerRedirect(
                    //       context,
                    //       bannerProvider
                    //           .mainBannerList![index]
                    //           .resourceId,
                    //       bannerProvider
                    //           .mainBannerList![
                    //       index]
                    //           .resourceType ==
                    //           'product'
                    //           ? bannerProvider
                    //           .mainBannerList![index]
                    //           .product
                    //           : null,
                    //       bannerProvider
                    //           .mainBannerList![index]
                    //           .resourceType);
                    // }
                    print("APi banner Url '${Provider.of<SplashController>(context, listen: false).baseUrls?.bannerImageUrl}''/${bannerList[index].photo}'");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Dimensions.paddingSizeSmall),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius
                                .circular(Dimensions
                                .paddingSizeSmall),
                            color:
                            Provider.of<ThemeController>(
                                context,
                                listen: false)
                                .darkTheme
                                ? Theme.of(context)
                                .primaryColor
                                .withOpacity(.1)
                                : Theme.of(context)
                                .primaryColor
                                .withOpacity(
                                .05)),
                        child: CustomImageWidget(
                            image: '${Provider.of<SplashController>(context, listen: false).baseUrls!.productThumbnailUrl}'
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ) : const SizedBox();
  }

  Widget _categoryGrid() {
    return Container(
      padding: EdgeInsets.only(left: 10,top: 10),
      height: MediaQuery.of(context).size.width / 3.2 * 2, // ⭐ height for 2 rows
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // ⭐ 2 items in COLUMN
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.5,
        ),
        itemCount: categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BrandAndCategoryProductScreen(
                    isBrand: false,
                    id: categoryList[index].id.toString(),
                    name: categoryList[index].name,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// 🖼 Icon (Fixed position)
                Container(
                  height: MediaQuery.of(context).size.width / 6.2,
                  width: MediaQuery.of(context).size.width / 6.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.withOpacity(0.12),
                        Colors.orange.withOpacity(0.04),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${Provider.of<SplashController>(context, listen: false).baseUrls?.categoryImageUrl}/${categoryList[index].icon}',
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// 📝 Text (Same height for all items)
                SizedBox(
                  height: 32, // ⭐ fixed height for 2 lines
                  width: MediaQuery.of(context).size.width / 6.2,
                  child: Text(
                    categoryList[index].name ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      letterSpacing: 0.3,
                      color: ColorResources.getTextTitle(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget productWidget(List<Product> product) {
    return product.isEmpty
        ? productHorizontalShimmer(context)
        : SizedBox(
      height: 240,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 10),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: product.length,
        itemBuilder: (context, index) {
          final productModel = product[index];

          return SizedBox(
            width: 180,
            child:  InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => ProductDetails(
                      productId: productModel.id,
                      slug: productModel.slug,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                  Provider.of<ThemeController>(context, listen: false).darkTheme
                      ? null
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [

                    /// Main Content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        /// 🖼 Image + Discount Badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(12)),
                              child: CustomImageWidget(
                                image:
                                '${Provider.of<SplashController>(context, listen: false).baseUrls!.productThumbnailUrl}/${productModel.thumbnail}',
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            /// 🔥 Discount Badge
                            if (productModel.discount != null &&
                                productModel.discount! > 0)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: ColorResources.getPrimary(context),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    PriceConverter.percentageCalculation(
                                      context,
                                      productModel.unitPrice,
                                      productModel.discount,
                                      productModel.discountType,
                                    ),
                                    style: textRegular.copyWith(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        /// 📄 Details
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              /// Out of stock
                              if (productModel.currentStock! <
                                  productModel.minimumOrderQuantity! &&
                                  productModel.productType == 'physical')
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    getTranslated('out_of_stock', context) ?? '',
                                    style: textRegular.copyWith(
                                      color: const Color(0xFFF36A6A),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),


                              /// 📦 Product Name
                              Text(
                                productModel.name ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textRegular.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// Old Price
                              Row(
                                children: [
                                  if (productModel.discount != null &&
                                      productModel.discount! > 0)
                                    Text(
                                      PriceConverter.convertPrice(
                                          context, productModel.unitPrice),
                                      style: titleRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12,
                                      ),
                                    ),

                                  const SizedBox(width: 5),

                                  /// Final Price
                                  Text(
                                    PriceConverter.convertPrice(
                                      context,
                                      productModel.unitPrice,
                                      discountType: productModel.discountType,
                                      discount: productModel.discount,
                                    ),
                                    style: titilliumSemiBold.copyWith(
                                      color: ColorResources.getPrimary(context),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget productHorizontalShimmer(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        itemCount: 6,
        itemBuilder: (_, index) {
          return Container(
            width: 180,
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🖼 Image shimmer
                  Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Title shimmer
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 14,
                          width: 100,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 10),

                        /// Price shimmer
                        Container(
                          height: 14,
                          width: 60,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(
      String title,
      IconData icon, {
        String type = '',
        String subType = '',
        bool showButton = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, bottom: 6, right: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),

          /// Button sirf tab jab showButton true ho
          if (showButton)
            InkWell(
              onTap: () {
                Navigator.push(context,
                  CupertinoPageRoute(
                    builder: (_) => ProductDetailsScreen(city: onlyCity, type: type,subType: subType,),
                  ),);
                },
              child: const Text(
                'View all',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),

          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget categoryGridShimmer(BuildContext context) {
    final double itemSize = MediaQuery.of(context).size.width / 6.2;

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.65,
      ),
      itemCount: 10, // shimmer count
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              /// 🧱 Icon box shimmer
              Container(
                height: itemSize,
                width: itemSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              /// 📝 Text line shimmer
              Container(
                height: 12,
                width: itemSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              /// second line (optional)
              Container(
                height: 12,
                width: itemSize * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

class LocationLoadingWidget extends StatelessWidget {
  const LocationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.orange.shade200,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular loader
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.deepOrange.shade400),
              ),
            ),
            const SizedBox(height: 18),

            // Title text
            Text(
              'Fetching Your Location',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.deepOrange.shade700,
              ),
            ),

            const SizedBox(height: 6),

            // Subtitle / friendly message
            Text(
              'Please wait a moment while we find your current city...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.brown.shade600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
