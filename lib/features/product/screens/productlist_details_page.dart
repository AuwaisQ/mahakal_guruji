
import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mahakal/features/product/domain/models/product_model.dart';
import '../../../common/basewidget/custom_image_widget.dart';
import '../../../common/basewidget/paginated_list_view_widget.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/responsive_helper.dart';
import '../../../localization/language_constrants.dart';
import '../../../theme/controllers/theme_controller.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../product_details/screens/product_details_screen.dart';
import '../../shop/widgets/seller_card.dart';
import '../../shop/widgets/seller_shimmer.dart';
import '../../shop/widgets/top_seller_shimmer.dart';
import '../../shop/domain/models/seller_model.dart';
import '../../splash/controllers/splash_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String city;
  final String type;
  final String? subType;
  const ProductDetailsScreen({super.key, required this.city, required this.type, this.subType});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  List<Product> featureProduct = [];
  List<Seller> sellerProduct = [];

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

  void getDetails() async{
    print('checking var ${widget.city} ${widget.type}');
    var res =  await  HttpService().getApi('/api/v1/products/same-day-delivery/product-data?city=${widget.city}&data_from=${widget.type}');
    if(res['status']){
      if(widget.type == 'category'){
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
        setState(() {
          // category products
          List homeDecor =  res['products']['Home Decor'] ?? [];
          List pujaEssential =  res['products']['Pujan Essentials'] ?? [];
          List bracelet =  res['products']['Bracelet'] ?? [];
          List pooja =  res['products']['Pooja'] ?? [];
          List rosary =  res['products']['Rosary'] ?? [];
          List handmadeProducts =  res['products']['Handmade Products'] ?? [];
          List statue =  res['products']['Statue'] ?? [];
          List yogaMeditation =  res['products']['Yoga & Meditation'] ?? [];
          List rudraksh =  res['products']['Rudraksh'] ?? [];
          List devotionalClothes =  res['products']['Devotional Clothes'] ?? [];
          List gems =  res['products']['Gems'] ?? [];
          List attar =  res['products']['Attar'] ?? [];


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
        });
      }else{
      setState(() {
      List feature = res['products']['products'];
      featureProduct = feature.map((e) => Product.fromJson(e)).toList();
      });
      }
    }
    print('api response product details $res');
  }

  void getSeller() async{
    print('checking seller ${widget.city} ${widget.type}');
    var res =  await  HttpService().getApi('/api/v1/products/same-day-delivery/seller?city=${widget.city}');
    if(res['status']){
      setState(() {
        List seller = res['sellers'];
        sellerProduct = seller.map((e) => Seller.fromJson(e)).toList();
      });
    }
    print('api response product details $res');
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  loadData(){
    if(widget.type == 'seller'){
      getSeller();
    }else{
      getDetails();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${capitalizeFirst(widget.type)} products'),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),

        body: widget.type == 'category'
            ? SingleChildScrollView(
          child: Column(
            children: [
              if (widget.subType == 'home')
                _buildCategorySection(
                  'Home Decore',
                  Icons.maps_home_work_outlined,
                  homeDecorList,
                ),

              if (widget.subType == 'pujan')
                _buildCategorySection(
                  'Pujan Essential',
                  Icons.temple_hindu,
                  pujaEssentialList,
                ),

              if (widget.subType == 'bracelet')
                _buildCategorySection(
                  'Bracelet',
                  Icons.filter_b_and_w,
                  braceletList,
                ),

              if (widget.subType == 'puja')
                _buildCategorySection(
                  'Puja',
                  Icons.shopping_bag,
                  poojaList,
                ),

              if (widget.subType == 'rosary')
                _buildCategorySection(
                  'Rosary',
                  Icons.shopping_bag,
                  rosaryList,
                ),

              if (widget.subType == 'handmade')
                _buildCategorySection(
                  'Handmade Products',
                  Icons.shopping_cart,
                  handmadeProductsList,
                ),

              if (widget.subType == 'statue')
                _buildCategorySection(
                  'Statue',
                  Icons.person_4,
                  statueList,
                ),

              if (widget.subType == 'yoga')
                _buildCategorySection(
                  'Yoga & Meditation',
                  Icons.shopping_cart,
                  yogaMeditationList,
                ),

              if (widget.subType == 'rudraksh')
                _buildCategorySection(
                  'Rudraksh',
                  Icons.circle,
                  rudrakshList,
                ),

              if (widget.subType == 'devotees')
                _buildCategorySection(
                  'Devotional Clothes',
                  Icons.shopping_cart,
                  devotionalClothesList,
                ),

              if (widget.subType == 'gems')
                _buildCategorySection(
                  'Gems',
                  Icons.circle,
                  gemsList,
                ),

              if (widget.subType == 'attar')
                _buildCategorySection(
                  'Attar',
                  Icons.local_grocery_store,
                  attarList,
                ),
            ],
          ),
        )
            : widget.type == 'seller'
            ? sellerWidget(sellerProduct)
            : productWidget(featureProduct)

    );
  }

  Widget _buildCategorySection(
      String title,
      IconData icon,
      List<Product> list,
      ) {
    return Column(
      children: [
        _sectionTitle(title, icon, showButton: false),
        productWidget(list),
      ],
    );
  }

  Widget sellerWidget(List<Seller> seller) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: seller.isNotEmpty
        ? SingleChildScrollView(
                  child:  ListView.builder(
        itemCount: seller.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return SellerCard(
              sellerModel: seller[index],
              isHomePage: false,
              index: index,
              length: seller.length ??
                  0);
        },
                  ),
                ) : const SellerShimmer());
  }
  Widget productWidget(List<Product> product) {
    return product.isEmpty
        ? productGridShimmer(context)
        : GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: product.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final productModel = product[index];

        return InkWell(
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
                            height: 150,
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
        );
      },
    );
  }
  Widget categoryProductWidget(List<Product> product) {
    return product.isEmpty
        ? productGridShimmer(context)
        : GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: product.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final productModel = product[index];

        return InkWell(
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
                            height: 150,
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
        );
      },
    );
  }
  Widget productGridShimmer(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (_, index) {
        return Container(
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
                /// Image shimmer
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: double.infinity, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 14, width: 100, color: Colors.white),
                      const SizedBox(height: 10),
                      Container(height: 14, width: 60, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget categoryGridShimmer(BuildContext context) {
    final double itemSize = MediaQuery.of(context).size.width / 6.2;

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.85,
      ),
      itemCount: 8, // shimmer count
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
  Widget _sectionTitle(
      String title,
      IconData icon, {
        VoidCallback? onTap,
        bool showButton = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.amber,
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
              onTap: onTap,
              child: const Text(
                'View all',
                style: TextStyle(color: Colors.amber),
              ),
            ),

          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
