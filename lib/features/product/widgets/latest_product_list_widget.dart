import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:mahakal/features/product/controllers/product_controller.dart';
import 'package:mahakal/features/product/domain/models/product_model.dart';
import 'package:mahakal/features/product/screens/view_all_product_screen.dart';
import 'package:mahakal/features/product/widgets/latest_product_widget.dart';
import 'package:mahakal/features/product/enums/product_type.dart';
import 'package:mahakal/helper/responsive_helper.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/common/basewidget/title_row_widget.dart';
import 'package:mahakal/features/home/shimmers/latest_product_shimmer.dart';
import 'package:mahakal/utill/images.dart';
import 'package:provider/provider.dart';

class LatestProductListWidget extends StatelessWidget {
  const LatestProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.lProductList;

        return productList != null
            ? productList.isNotEmpty
                ? Column(
                    children: [
                      TitleRowWidget(
                          title: getTranslated('latest_products', context),
                          onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => AllProductScreen(
                                      productType:
                                          ProductType.latestProduct)))),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  right: ResponsiveHelper.isTab(context)
                                      ? MediaQuery.of(context).size.width * .18
                                      : 0),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.width * 1,
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: Image.asset(Images.bgLatest))),
                          SizedBox(
                              height: MediaQuery.of(context).size.width,
                              child: Swiper(
                                  autoplay: false,
                                  allowImplicitScrolling: true,
                                  autoplayDisableOnInteraction: true,
                                  autoplayDelay: Duration.minutesPerHour,
                                  layout: SwiperLayout.TINDER,
                                  itemWidth:
                                      MediaQuery.of(context).size.width * .8,
                                  itemHeight:
                                      MediaQuery.of(context).size.width * .8,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      LatestProductWidget(
                                          productModel: productList![index]),
                                  itemCount: productList.length)),
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink()
            : const LatestProductShimmer();
      },
    );
  }
}
