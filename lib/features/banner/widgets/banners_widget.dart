import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/banner/controllers/banner_controller.dart';
import 'package:mahakal/features/banner/widgets/banner_shimmer.dart';
import 'package:mahakal/features/splash/controllers/splash_controller.dart';
import 'package:mahakal/theme/controllers/theme_controller.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class BannersWidget extends StatelessWidget {
  const BannersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<BannerController>(
          builder: (context, bannerProvider, child) {
            double width = MediaQuery.of(context).size.width;
            return Stack(
              children: [
                bannerProvider.mainBannerList != null
                    ? bannerProvider.mainBannerList!.isNotEmpty
                        ? SizedBox(
                            height: width * 0.5,
                            width: width,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: width * 0.45,
                                  width: width,
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
                                    itemCount: bannerProvider
                                            .mainBannerList!.isEmpty
                                        ? 1
                                        : bannerProvider.mainBannerList?.length,
                                    itemBuilder: (context, index, _) {
                                      return InkWell(
                                        onTap: () {
                                          if (bannerProvider
                                                  .mainBannerList![index]
                                                  .resourceId !=
                                              null) {
                                            bannerProvider.clickBannerRedirect(
                                                context,
                                                bannerProvider
                                                    .mainBannerList![index]
                                                    .resourceId,
                                                bannerProvider
                                                            .mainBannerList![
                                                                index]
                                                            .resourceType ==
                                                        'product'
                                                    ? bannerProvider
                                                        .mainBannerList![index]
                                                        .product
                                                    : null,
                                                bannerProvider
                                                    .mainBannerList![index]
                                                    .resourceType);
                                          }
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
                                                  image:
                                                      '${Provider.of<SplashController>(context, listen: false).baseUrls?.bannerImageUrl}'
                                                      '/${bannerProvider.mainBannerList?[index].photo}')),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox()
                    : const BannerShimmer(),

                // if(bannerProvider.mainBannerList != null &&  bannerProvider.mainBannerList!.isNotEmpty)
                //   Positioned(
                //     bottom: 25, left: 0, right: 0,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center, children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: bannerProvider.mainBannerList!.map((banner) {
                //             int index = bannerProvider.mainBannerList!.indexOf(banner);
                //             return index == bannerProvider.currentIndex ?
                //             Container(
                //               padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                //               margin: const EdgeInsets.symmetric(horizontal: 6.0),
                //               decoration: BoxDecoration(
                //                 color:  Theme.of(context).primaryColor ,
                //                 borderRadius: BorderRadius.circular(100)),
                //               child:  Text("${bannerProvider.mainBannerList!.indexOf(banner) + 1}",
                //                 style: const TextStyle(color: Colors.white,fontSize: 12),),
                //             ):const SizedBox();
                //           }).toList(),
                //         ),
                //       ],),
                //   ),
              ],
            );
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  List<Widget> _indicators(BuildContext context, int length, int currentIndex) {
    List<Widget> indicators = [];
    for (int index = 0; index < length; index++) {
      indicators.add(Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraExtraSmall),
        child: Container(
          width: index == currentIndex ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: index == currentIndex
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor,
          ),
        ),
      ));
    }
    return indicators;
  }
}
