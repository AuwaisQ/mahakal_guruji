import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/product/controllers/product_controller.dart';
import 'package:mahakal/features/product/controllers/seller_product_controller.dart';
import 'package:mahakal/features/product_details/controllers/product_details_controller.dart';
import 'package:mahakal/features/product_details/widgets/bottom_cart_widget.dart';
import 'package:mahakal/features/product_details/widgets/product_image_widget.dart';
import 'package:mahakal/features/product_details/widgets/product_specification_widget.dart';
import 'package:mahakal/features/product_details/widgets/product_title_widget.dart';
import 'package:mahakal/features/product_details/widgets/promise_widget.dart';
import 'package:mahakal/features/product_details/widgets/related_product_widget.dart';
import 'package:mahakal/features/product_details/widgets/review_and_specification_widget.dart';
import 'package:mahakal/features/product_details/widgets/shop_info_widget.dart';
import 'package:mahakal/features/product_details/widgets/youtube_video_widget.dart';
import 'package:mahakal/features/review/controllers/review_controller.dart';
import 'package:mahakal/common/basewidget/custom_app_bar_widget.dart';
import 'package:mahakal/features/home/shimmers/product_details_shimmer.dart';
import 'package:mahakal/features/review/widgets/review_section.dart';
import 'package:mahakal/features/shop/screens/shop_screen.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/common/basewidget/title_row_widget.dart';
import 'package:mahakal/features/shop/widgets/shop_product_view_list.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../widgets/cart_bottom_sheet_widget.dart';

class ProductDetails extends StatefulWidget {
  final dynamic? productId;
  final dynamic? slug;
  final bool isFromWishList;
  const ProductDetails(
      {super.key,
      required this.productId,
      required this.slug,
      this.isFromWishList = false});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsController>(context, listen: false)
        .getProductDetails(
            context, widget.productId.toString(), widget.slug.toString());
    Provider.of<ReviewController>(context, listen: false).removePrevReview();
    Provider.of<ReviewController>(context, listen: false)
        .getReviewList(widget.productId, widget.slug, context);
    Provider.of<ProductController>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductController>(context, listen: false)
        .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsController>(context, listen: false)
        .getCount(widget.productId.toString(), context);
  }

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('product_details', context)),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(context),
        child: Consumer<ProductDetailsController>(
          builder: (context, details, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: !details.isDetails
                  ? Column(
                      children: [
                        ProductImageWidget(
                            productModel: details.productDetailsModel),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0),
                                    builder: (con) => CartBottomSheetWidget(
                                          product: details.productDetailsModel,
                                          callback: () {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'added_to_cart', context),
                                                context,
                                                isError: false);
                                          },
                                        ));
                              },
                              child: ProductTitleWidget(
                                  productModel: details.productDetailsModel,
                                  averageRatting: details
                                          .productDetailsModel?.averageReview ??
                                      "0"),
                            ),
                            const ReviewAndSpecificationSectionWidget(),
                            details.isReviewSelected
                                ? ReviewSection(details: details)
                                : Column(
                                    children: [
                                      (details.productDetailsModel?.details !=
                                                  null &&
                                              details.productDetailsModel!
                                                  .details!.isNotEmpty)
                                          ? Container(
                                              height: 250,
                                              margin: const EdgeInsets.only(
                                                  top: Dimensions
                                                      .paddingSizeSmall),
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeSmall),
                                              child: ProductSpecificationWidget(
                                                  productSpecification: details
                                                          .productDetailsModel!
                                                          .details ??
                                                      ''),
                                            )
                                          : const SizedBox(),
                                      details.productDetailsModel?.videoUrl !=
                                              null
                                          ? YoutubeVideoWidget(
                                              url: details.productDetailsModel!
                                                  .videoUrl)
                                          : const SizedBox(),
                                      (details.productDetailsModel != null)
                                          ? ShopInfoWidget(
                                              sellerId: details
                                                          .productDetailsModel!
                                                          .addedBy ==
                                                      'seller'
                                                  ? details.productDetailsModel!
                                                      .userId
                                                      .toString()
                                                  : "0")
                                          : const SizedBox.shrink(),
                                      const SizedBox(
                                        height: Dimensions.paddingSizeLarge,
                                      ),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              top: Dimensions.paddingSizeLarge,
                                              bottom: Dimensions
                                                  .paddingSizeDefault),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor),
                                          child: const PromiseWidget()),
                                      (details.productDetailsModel != null &&
                                              details.productDetailsModel!
                                                      .addedBy ==
                                                  'seller')
                                          ? Consumer<SellerProductController>(
                                              builder: (context,
                                                  sellerProductController, _) {
                                              return (sellerProductController
                                                              .sellerProduct !=
                                                          null &&
                                                      sellerProductController
                                                              .sellerProduct!
                                                              .products !=
                                                          null &&
                                                      sellerProductController
                                                          .sellerProduct!
                                                          .products!
                                                          .isNotEmpty)
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: Dimensions
                                                              .paddingSizeDefault),
                                                      child: TitleRowWidget(
                                                        title: getTranslated(
                                                            'more_from_the_shop',
                                                            context),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                  builder: (_) =>
                                                                      TopSellerProductScreen(
                                                                        fromMore:
                                                                            true,
                                                                        sellerId: details
                                                                            .productDetailsModel
                                                                            ?.seller
                                                                            ?.id,
                                                                        temporaryClose: details
                                                                            .productDetailsModel
                                                                            ?.seller
                                                                            ?.shop
                                                                            ?.temporaryClose,
                                                                        vacationStatus:
                                                                            details.productDetailsModel?.seller?.shop?.vacationStatus ??
                                                                                false,
                                                                        vacationEndDate: details
                                                                            .productDetailsModel
                                                                            ?.seller
                                                                            ?.shop
                                                                            ?.vacationEndDate,
                                                                        vacationStartDate: details
                                                                            .productDetailsModel
                                                                            ?.seller
                                                                            ?.shop
                                                                            ?.vacationStartDate,
                                                                        name: details
                                                                            .productDetailsModel
                                                                            ?.seller
                                                                            ?.shop
                                                                            ?.name,
                                                                        banner: details
                                                                            .productDetailsModel
                                                                            ?.seller
                                                                            ?.shop
                                                                            ?.banner,
                                                                        image: details
                                                                            .productDetailsModel
                                                                            ?.seller
                                                                            ?.shop
                                                                            ?.image,
                                                                      )));
                                                        },
                                                      ),
                                                    )
                                                  : const SizedBox();
                                            })
                                          : const SizedBox(),
                                      (details.productDetailsModel?.addedBy ==
                                              'seller')
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeDefault),
                                              child: ShopProductViewList(
                                                  scrollController:
                                                      scrollController,
                                                  sellerId: details
                                                      .productDetailsModel!
                                                      .userId!))
                                          : const SizedBox(),
                                      Consumer<ProductController>(builder:
                                          (context, productController, _) {
                                        return (productController
                                                        .relatedProductList !=
                                                    null &&
                                                productController
                                                    .relatedProductList!
                                                    .isNotEmpty)
                                            ? Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: TitleRowWidget(
                                                    title: getTranslated(
                                                        'related_products',
                                                        context),
                                                    isDetailsPage: true))
                                            : const SizedBox();
                                      }),
                                      const SizedBox(height: 5),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault),
                                        child: RelatedProductWidget(),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    )
                  : const ProductDetailsShimmer(),
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<ProductDetailsController>(
          builder: (context, details, child) {
        return !details.isDetails
            ? BottomCartWidget(product: details.productDetailsModel)
            : const SizedBox();
      }),
    );
  }
}
