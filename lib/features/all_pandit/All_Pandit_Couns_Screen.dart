import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import '../../helper/responsive_helper.dart';
import '../../localization/controllers/localization_controller.dart';
import '../../localization/language_constrants.dart';
import '../../main.dart';
import '../../utill/color_resources.dart';
import '../../utill/custom_themes.dart';
import '../../utill/dimensions.dart';
import '../../utill/images.dart';
import '../notification/controllers/notification_controller.dart';
import '../notification/screens/notification_screen.dart';
import 'Model/all_pandit_service_model.dart';
import 'Pandit_Counselling_Details.dart';

class AllPanditCounsScreen extends StatefulWidget {
  final int panditId;
  final ScrollController scrollController;

  const AllPanditCounsScreen({
    super.key,
    required this.panditId,
    required this.scrollController,
  });

  @override
  State<AllPanditCounsScreen> createState() => _AllPanditCounsScreenState();
}

class _AllPanditCounsScreenState extends State<AllPanditCounsScreen> {
  bool isLoading = false;
  bool isGridview = true;
  String isLanguage = 'IN';
  List<Counselling> fullList = [];
  List<Counselling> filteredList = [];
  AllPanditServicesModel? gurujiInfo;
  int activeIndex = 0;


  @override
  void initState() {
    super.initState();
    fetchAllPanditService();
    isLanguage = Provider.of<LocalizationController>(Get.context!, listen: false).getCurrentLanguage()!;
  }

  Future<void> fetchAllPanditService() async {
    setState(() => isLoading = true);

    try {
      final url = '/api/v1/guruji/detail?id=${widget.panditId}&type=counselling';
      final response = await HttpService().getApi(url);

      gurujiInfo = AllPanditServicesModel.fromJson(response);

      fullList = gurujiInfo?.counselling ?? [];
      filteredList = fullList;

      setState(() => isLoading = false);
    } catch (e) {
      log('Error: $e');
      setState(() => isLoading = false);
    }
  }

  void searchItems(String value) {
    if (value.isEmpty) {
      setState(() => filteredList = fullList);
      return;
    }

    setState(() {
      filteredList = fullList.where((item) {
        final name = item.enName?.toLowerCase() ?? '';
        // final venue = item.category?.name.toLowerCase() ?? '';
        return name.contains(value.toLowerCase());
      }).toList();
    });
  }

  Widget buildCounsellingCard(Counselling counselling, {bool isList = false}) {
    return InkWell(
      onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => PanditCounsellingDetails(gurujiId: '${gurujiInfo?.guruji?.id}', slug: '${counselling.slug}',)
            ),
          ),
      child: Container(
        margin: isList ? const EdgeInsets.only(bottom: 14) : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: counselling.thumbnail ?? '',
                height: isList ? 180 : 110,
                width: double.infinity,
                fit: BoxFit.cover, // 🔥 natural look
                placeholder: (_, __) => Container(
                  height: isList ? 210 : 115,
                  color: Colors.grey.shade200,
                ),
                errorWidget: (_, __, ___) =>
                    Image.asset(Images.placeholder, fit: BoxFit.cover),
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    counselling.enName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '(${counselling.hiName})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Price Row
                  Row(
                    children: [
                      Text(
                        '₹${counselling.counsellingSellingPrice}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '₹${counselling.counsellingMainPrice}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PanditCounsellingDetails(
                              gurujiId: '${gurujiInfo?.guruji?.id}',
                              slug: counselling.slug ?? '',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade400,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('${getTranslated('book_now', context)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SMALL BOX FOR STATS
  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 50, left: 10),
          child: Image.asset(Images.logoNameImage, height: 38),
        ),
        title: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(Images.appLogo, height: 40)),
        actions: [
          Consumer<NotificationController>(builder: (context, notificationProvider, _) {
            return IconButton(
                onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => const NotificationScreen())),
                icon: Stack(clipBehavior: Clip.none, children: [
                  Image.asset(Images.notification,
                      height: Dimensions.iconSizeDefault,
                      width: Dimensions.iconSizeDefault,
                      color: ColorResources.getPrimary(context)),
                  Positioned(
                      top: -4,
                      right: -4,
                      child: CircleAvatar(
                          radius:
                          ResponsiveHelper.isTab(context) ? 10 : 7,
                          backgroundColor: ColorResources.red,
                          child: Text(
                              notificationProvider.notificationModel
                                  ?.newNotificationItem
                                  .toString() ??
                                  '0',
                              style: titilliumSemiBold.copyWith(
                                  color: ColorResources.white,
                                  fontSize:
                                  Dimensions.fontSizeExtraSmall))))
                ]));
          }),
          const SizedBox(width: 10,),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: 4,
                  options: CarouselOptions(
                    height: 160,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 700),
                    viewportFraction: 0.9, // 🔥 side images visible
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    enableInfiniteScroll: true,
                    // onPageChanged: (index, reason) {
                    //   setState(() => activeIndex = index);
                    // },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    const imageUrl = 'https://www.nyckel.com/assets/images/functions/hindu-guru-by-picture.webp';
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill, // ⬅ better than fill
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
            
                // DOT INDICATOR
                AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: 4,
                  effect: ExpandingDotsEffect(
                    dotHeight: 5,
                    dotWidth: 5,
                    activeDotColor: Colors.amber,
                    dotColor: Colors.grey.shade400,
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.amber.shade200,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Astro Consultancy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade800,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.amber.shade200,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
            
            
                isGridview
                    ? GridView.builder(
                    shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 14,left: 14,right: 14,bottom: 120),
                      itemCount: filteredList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        return buildCounsellingCard(filteredList[index]);
                      },
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return buildCounsellingCard(
                filteredList[index],
                isList: true,
                        );
                      },
                    ),
              ],
            ),
          ),
    );
  }
}
