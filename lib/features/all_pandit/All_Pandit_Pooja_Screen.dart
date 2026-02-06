import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../common/basewidget/custom_image_widget.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import '../../helper/responsive_helper.dart';
import '../../utill/color_resources.dart';
import '../../utill/custom_themes.dart';
import '../../utill/dimensions.dart';
import '../../utill/images.dart';
import '../../utill/no_image_widget.dart';
import '../notification/controllers/notification_controller.dart';
import '../notification/screens/notification_screen.dart';
import '../profile/controllers/profile_contrroller.dart';
import '../splash/controllers/splash_controller.dart';
import 'Model/all_pandit_service_model.dart';
import 'Pandit_Bottom_bar.dart';
import 'Pandit_Pooja_Details.dart';

class AllPanditPoojaScreen extends StatefulWidget {
  final int panditId;
  final ScrollController scrollController;

  const AllPanditPoojaScreen({
    super.key,
    required this.panditId,
    required this.scrollController,
  });

  @override
  State<AllPanditPoojaScreen> createState() => _AllPanditPoojaScreenState();
}

class _AllPanditPoojaScreenState extends State<AllPanditPoojaScreen> {

  bool isLoading = false;
  bool _isSearchActive = false;
  bool isGridview = true;

  int _selectedCategoryIndex = 0;
  int activeIndex = 0;

  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<Service> fullList = [];
  List<Service> filteredList = [];
  //List<Category> categories = [];

  AllPanditServicesModel? gurujiInfo;

  List<Category> allCategories = [];

  final List<Color> softBgColors = [
    const Color(0xFFFCFCFC),
    const Color(0xFFFFFDFB),
    const Color(0xFFFDFEFF),
    const Color(0xFFFEFCFF),
    const Color(0xFFFBFFFD),
    const Color(0xFFFFFEFC),
  ];


  @override
  void initState() {
    super.initState();
    fetchAllPanditService();
  }

  Future<void> fetchAllPanditService() async {
    setState(() => isLoading = true);

    try {
      final url = '${AppConstants.allPanditServiceUrl}${widget.panditId}&type=pooja';
      final response = await HttpService().getApi(url);

      print('Response is:$response');

      gurujiInfo = AllPanditServicesModel.fromJson(response);
      setState(() {
        fullList = gurujiInfo?.service ?? [];
        filteredList = fullList;
      });

      print('All List Data is:$fullList');

      List<Category> apiCategories = gurujiInfo?.guruji?.isPanditPoojaCategory ?? [];
      Category allPoojaCategory = Category(
        id: 0,
        name: 'All Pooja',
        slug: 'all', icon: '', parentId: 0, position: 0, createdAt: null, updatedAt: null, homeStatus: 0, priority: 0, translations: [],
        // Add other required fields
      );

      setState(() {
        allCategories = [allPoojaCategory] + apiCategories;
        isLoading = false;
        _selectedCategoryIndex = 0; // Default All Pooja selected
      });
    } catch (e) {
      print('All Pandit Pooja:$e');
      setState(() => isLoading = false);
    }
  }

  List<Service> getPoojaByCategory(Category category) {
    if (category.id == 0) {
      return fullList; // All Pooja
    }

    return fullList.where((pooja) {
      return pooja.subCategoryId != null &&
          category.id != null &&
          pooja.subCategoryId.toString() == category.id.toString();
    }).toList();
  }



  void searchItems(String value) {
    if (value.isEmpty) {
      setState(() => filteredList = fullList);
      return;
    }

    setState(() {
      filteredList = fullList.where((item) {
        final name = item.enName?.toLowerCase() ?? '';
        final venue = item.enPoojaVenue?.toLowerCase() ?? '';
        return name.contains(value.toLowerCase()) ||
            venue.contains(value.toLowerCase());
      }).toList();
    });
  }

  Widget buildPoojaCard(Service panditDetails, {bool isList = false}) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => PanditPoojaDetails(
            panditId: widget.panditId,
            poojaSlug: '${panditDetails.slug}',
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: isList ? const EdgeInsets.only(bottom: 16) : const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section with Gradient Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                      imageUrl: '${panditDetails.thumbnail}',
                      height: isList ? 150 : 100,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      errorWidget: (_, __, ___) => const NoImageWidget()
                  ),
                ),

                // Gradient Overlay
                Container(
                  height: isList ? 150 : 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pooja Name with Icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${panditDetails.enName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  if (panditDetails.enPoojaVenue != null && panditDetails.enPoojaVenue!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            panditDetails.enPoojaVenue!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 10),

                  // Booking Button with Enhanced Design
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange,
                          Colors.orange.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PanditPoojaDetails(
                              panditId: widget.panditId,
                              poojaSlug: '${panditDetails.slug}',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Book Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
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

  final List<Map<String, String>> items = [
    {
      'title': 'free_rashifal',
      'image': 'assets/testImage/rashifall/taurus.png',
      'color': '0xFF1DD1A1' // Emerald Green
    },
    {
      'title': 'free_kundli',
      'image': 'assets/images/allcategories/animate/Kundli_milan_icon animation.gif',
      'color': '0xFFFF9F43' // Orange
    },
    {
      'title': 'free_birth',
      'image': 'assets/images/allcategories/Janam_kundli.png',
      'color': '0xFF2E86DE' // Ocean Blue
    },
    {
      'title': 'free_calculater',
      'image': 'assets/images/calculator/mulk_ank.png',
      'color': '0xFF341F97' // Deep Purple
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10),
          child: Image.asset(Images.logoNameImage, height: 70),
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
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
            child: Column(
                    children: [
            // ----------------- PANIDT PROFILE HEADER -----------------
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
                          activeDotColor: Colors.deepOrange,
                          dotColor: Colors.grey.shade400,
                        ),
                      ),

                      // Container(
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: const NetworkImage('https://astromanch.com/public/storage/images/blog_2531759311506.webp'),
                      //       fit: BoxFit.cover,
                      //       colorFilter: ColorFilter.mode(
                      //         Colors.black.withOpacity(0.4), // Dark overlay for better text visibility
                      //         BlendMode.darken,
                      //       ),
                      //     ),
                      //   ),
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16),
                      //     decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //         begin: Alignment.topCenter,
                      //         end: Alignment.bottomCenter,
                      //         colors: [
                      //           Colors.black.withOpacity(0.5),
                      //           Colors.transparent,
                      //           Colors.black.withOpacity(0.3),
                      //         ],
                      //       ),
                      //     ),
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //
                      //         // IMAGE with border and shadow
                      //         Container(
                      //           width: 80,
                      //           height: 80,
                      //           padding: const EdgeInsets.all(2), // border thickness
                      //           decoration: BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             border: Border.all(
                      //               color: Colors.white,
                      //               width: 2,
                      //             ),
                      //           ),
                      //           child: ClipOval(
                      //             child: CachedNetworkImage(
                      //               imageUrl: gurujiInfo?.guruji?.image ?? '',
                      //               width: 80,
                      //               height: 80,
                      //               fit: BoxFit.cover,
                      //               placeholder: (context, url) => Container(
                      //                 color: Colors.white.withOpacity(0.1),
                      //                 child: const Center(
                      //                   child: CircularProgressIndicator(
                      //                     color: Colors.white,
                      //                     strokeWidth: 2,
                      //                   ),
                      //                 ),
                      //               ),
                      //               errorWidget: (_, __, ___) => Container(
                      //                 color: Colors.white.withOpacity(0.1),
                      //                 child: Icon(
                      //                   Icons.person,
                      //                   color: Colors.white.withOpacity(0.7),
                      //                   size: 30,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(width: 12),
                      //
                      //         // NAME + STATS
                      //         Expanded(
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 gurujiInfo?.guruji?.enName ?? '',
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Colors.white,
                      //                   shadows: [
                      //                     Shadow(
                      //                       blurRadius: 4,
                      //                       color: Colors.black.withOpacity(0.5),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               const SizedBox(height: 8),
                      //
                      //               // Stats with better styling
                      //               Row(
                      //                 children: [
                      //                   _buildStatWithIcon(Icons.work_history, '6+ Yrs', 'Experience'),
                      //                   const SizedBox(width: 8),
                      //                   _buildStatWithIcon(Icons.people, '10K+', 'Devotees'),
                      //                   const SizedBox(width: 8),
                      //                   _buildStatWithIcon(Icons.favorite, '1.2K', 'Followers'),
                      //                 ],
                      //               ),
                      //
                      //               // Follow Button
                      //               //_buildFollowBtn(),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.withOpacity(0.08),
                      //         blurRadius: 15,
                      //         offset: const Offset(0, 5),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     children: [
                      //
                      //       // // Tabs
                      //       // Container(
                      //       //   margin: const EdgeInsets.symmetric(horizontal: 10),
                      //       //   height: 45, // 🔥 MUST
                      //       //   child: ListView.builder(
                      //       //     scrollDirection: Axis.horizontal,
                      //       //     padding: EdgeInsets.zero,
                      //       //     itemCount: allCategories.length,
                      //       //     itemBuilder: (context, index) {
                      //       //       return _buildEnhancedCategoryTab(allCategories[index], index);
                      //       //     },
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),

                      // headline
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.deepOrange.shade200,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                'Paid Services',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade800,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.deepOrange.shade200,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: allCategories.asMap().entries.map((entry) {
                          final index = entry.key;
                          final category = entry.value;

                          final categoryList = getPoojaByCategory(category);
                          if (categoryList.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          final bgColor = softBgColors[index % softBgColors.length];

                          return Container(
                            color: bgColor,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔥 Category Header
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(20),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Row(
                                          children: [
                                            Text(
                                              'View all',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color: Colors.deepOrange,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                // 🔥 Horizontal list
                                SizedBox(
                                  height: 220,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoryList.length,
                                    itemBuilder: (context, i) {
                                      return SizedBox(
                                        width: 170,
                                        child: buildPoojaCard(categoryList[i]),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 100,)

                      // isGridview
                      // ? GridView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(), // 🔥 IMPORTANT
                      //   padding: const EdgeInsets.all(14),
                      //   itemCount: filteredList.length,
                      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2,
                      //     mainAxisSpacing: 10,
                      //     crossAxisSpacing: 10,
                      //     childAspectRatio: 0.75,
                      //   ),
                      //   itemBuilder: (context, index) {
                      //     return buildPoojaCard(filteredList[index]);
                      //   },
                      // )
                      // : ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   padding: const EdgeInsets.all(10),
                      //   itemCount: filteredList.length,
                      //   itemBuilder: (context, index) {
                      //     return buildPoojaCard(
                      //       filteredList[index],
                      //       isList: true,
                      //     );
                      //   },
                      // ),


                      //     : ListView.builder(
                  //   shrinkWrap: true,
                  //   padding: const EdgeInsets.all(10),
                  //   itemCount: filteredList.length,
                  //   itemBuilder: (context, index) {
                  //     return buildPoojaCard(filteredList[index], isList: true,
                  //     );
                  //   },
                  // ),

                  ],
                  ),
          ),
    );
  }


  // Get Short Name for Display
  String _getShortName(String fullName) {
    Map<String, String> shortNames = {
      'Samsya Nivaran Puja': 'Samsya Nivaran',
      'Vastu Puja': 'Vastu',
      'Manglik Puja': 'Manglik',
      'Graha Shanti': 'Graha Shanti',
      'Kundli Milan': 'Kundli',
      'Remedies': 'Remedies',
      'Gemstone': 'Gemstone',
      'Other Pujas': 'Others',
    };

    return shortNames[fullName] ?? fullName;
  }

  Widget _buildEnhancedCategoryTab(Category category, int index) {
    String shortName = category.name == 'All Pooja'
        ? 'All Pooja'
        : _getShortName('${category.name}');

    bool isSelected = _selectedCategoryIndex == index;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              Colors.deepOrange,
              Colors.orange.shade600,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? Colors.deepOrange.withOpacity(0.8)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with background circle
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.deepOrange.withOpacity(0.2),
              ),
              child: Icon(
                category.name == 'All Pooja'
                    ? Icons.all_inclusive
                    : _getCategoryIcon('${category.name}'),
                size: 16,
                color: isSelected ? Colors.white : Colors.deepOrange,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              shortName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.deepOrange.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _onCategoryTap(int index, Category category) {
  //   setState(() {
  //     _selectedCategoryIndex = index;
  //   });
  //
  //   if (category.name == 'All Pooja') {
  //     // All Pooja selected - show all poojas
  //     _showAllPoojas();
  //   } else {
  //     // Specific category selected
  //     _filterByCategory(category);
  //   }
  // }

  void _showAllPoojas() {
    setState(() {
      filteredList = fullList;
    });
  }

  // void _filterByCategory(Category category) {
  //   setState(() {
  //     filteredList = fullList.where((pooja) {
  //       return pooja.categoryId != null &&
  //           category.id != null &&
  //           pooja.subCategoryId.toString() == category.id.toString();
  //     }).toList();
  //
  //     print('Filtered list length: ${filteredList.length}');
  //   });
  // }

  // Get Icon for Category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Samsya Nivaran Puja':
        return Icons.psychology;
      case 'Vastu Puja':
        return Icons.home;
      case 'Manglik Puja':
        return Icons.favorite;
      case 'Graha Shanti':
        return Icons.star;
      case 'Kundli Milan':
        return Icons.auto_awesome;
      case 'Remedies':
        return Icons.healing;
      case 'Gemstone':
        return Icons.diamond;
      default:
        return Icons.celebration;
    }
  }

  Widget _buildSearchBox() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.deepOrange),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: true,
              onChanged: searchItems,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search pooja...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SEARCH BUTTON
  Widget _buildSearchToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSearchActive = !_isSearchActive;

          if (!_isSearchActive) {
            _searchController.clear();
            filteredList = fullList; // 🔥 IMPORTANT LINE
            FocusScope.of(context).unfocus();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepOrange),
        ),
        child: Icon(
          _isSearchActive ? Icons.close : Icons.search,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  // GRID / LIST TOGGLE BUTTON
  Widget _buildGridToggle() {
    return GestureDetector(
      onTap: () => setState(() => isGridview = !isGridview),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepOrange),
        ),
        child: Icon(
          isGridview ? Icons.list : Icons.grid_view,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildStatWithIcon(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
