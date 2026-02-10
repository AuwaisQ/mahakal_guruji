import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../common/basewidget/custom_image_widget.dart';
import '../../common/basewidget/paginated_list_view_widget.dart';
import '../../common/basewidget/product_shimmer_widget.dart';
import '../../common/basewidget/product_widget.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import '../../helper/responsive_helper.dart';
import '../../localization/controllers/localization_controller.dart';
import '../../localization/language_constrants.dart';
import '../../main.dart';
import '../../utill/color_resources.dart';
import '../../utill/custom_themes.dart';
import '../../utill/dimensions.dart';
import '../../utill/images.dart';
import '../../utill/no_image_widget.dart';
import '../janm_kundli/screens/kundliForm.dart';
import '../kundli_milan/kundalimatching.dart';
import '../lalkitab/lalkitabform.dart';
import '../maha_bhandar/screen/maha_bhandar_screen.dart';
import '../maha_bhandar/screen/panchang_screen.dart';
import '../notification/controllers/notification_controller.dart';
import '../notification/screens/notification_screen.dart';
import '../product/controllers/seller_product_controller.dart';
import '../profile/controllers/profile_contrroller.dart';
import '../rashi_fal/Model/rashifalModel.dart';
import '../rashi_fal/rsahi_fal_screen.dart';
import '../splash/controllers/splash_controller.dart';
import 'Model/all_pandit_service_model.dart';
import 'Pandit_Bottom_bar.dart';
import 'Pandit_Pooja_Details.dart';
import 'detailspage_product.dart';

class AllPanditPoojaScreen extends StatefulWidget {
  final int panditId;
  final int sellerId;
  final ScrollController scrollController;

  const AllPanditPoojaScreen({
    super.key,
    required this.panditId,
    required this.sellerId,
    required this.scrollController,
  });

  @override
  State<AllPanditPoojaScreen> createState() => _AllPanditPoojaScreenState();
}

class _AllPanditPoojaScreenState extends State<AllPanditPoojaScreen> {

  final oneKey = GlobalKey();
  final twoKey = GlobalKey();
  final threeKey = GlobalKey();
  final fourKey = GlobalKey();
  final fiveKey = GlobalKey();

  bool isLoading = false;
  bool _isSearchActive = false;
  bool isGridview = true;
  String isLanguage = 'IN';

  int _selectedCategoryIndex = 0;
  int activeIndex = 0;

  bool isScrolling = false;
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

  Future<void> fetchAllPanditService() async {
    setState(() => isLoading = true);

    try {
      final url = '${AppConstants.allPanditServiceUrl}${widget
          .panditId}&type=pooja';
      final response = await HttpService().getApi(url);

      print('Response is:$response');

      gurujiInfo = AllPanditServicesModel.fromJson(response);
      setState(() {
        fullList = gurujiInfo?.service ?? [];
        filteredList = fullList;
      });

      print('All List Data is:$fullList');

      List<Category> apiCategories = gurujiInfo?.guruji
          ?.isPanditPoojaCategory ?? [];
      Category allPoojaCategory = Category(
        id: 0,
        name: 'All Pooja',
        slug: 'all',
        icon: '',
        parentId: 0,
        position: 0,
        createdAt: null,
        updatedAt: null,
        homeStatus: 0,
        priority: 0,
        translations: [],
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
      onTap: () =>
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) =>
                  PanditPoojaDetails(
                    panditId: widget.panditId,
                    poojaSlug: '${panditDetails.slug}', isLanguage: isLanguage,
                  ),
            ),
          ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: isList ? const EdgeInsets.only(bottom: 16) : const EdgeInsets
            .only(left: 10),
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
                          isLanguage == 'IN'
                              ? '${panditDetails.hiName}'
                              : '${panditDetails.enName}',
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
                  if (panditDetails.enPoojaVenue != null &&
                      panditDetails.enPoojaVenue!.isNotEmpty)
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
                            isLanguage == 'IN'
                                ? '${panditDetails.hiPoojaVenue}'
                                : panditDetails.enPoojaVenue!,
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
                          Colors.amber,
                          Colors.deepOrange.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
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
                            builder: (_) =>
                                PanditPoojaDetails(
                                    panditId: widget.panditId,
                                    poojaSlug: '${panditDetails.slug}',
                                    isLanguage: isLanguage
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text('${getTranslated('book_now', context)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
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

  void scrollTo(String title) {
    final Map<String, GlobalKey> sectionKeys = {
      'free_rashifal': oneKey,
      'free_calculater': twoKey,
      'free_birth': threeKey,
    };
    final GlobalKey? key = sectionKeys[title];

    if (key == null || key.currentContext == null) {
      debugPrint('No matching key found for $title');
      return;
    }

    setState(() => isScrolling = true);

    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onItemTap(BuildContext context, String title) {
      switch (title) {
        case 'free_rashifal':
          scrollTo(title);
          break;

        case 'free_kundli':
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const KundliForm()));
          break;

        case 'kundli_mialn':
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const KundaliMatchingView()));
          break;

        case 'view_panchang':
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MahaBhandar(tab: 0,)));
          break;

        case 'lal_kitab':
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const LalKitabForm()));
          break;
        case 'free_birth':
          scrollTo(title);
          break;

        case 'free_calculater':
          scrollTo(title);
          break;

        default:
          debugPrint('No route found for $title');
      }
    }

  final List<String> rashiListName = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  final List<Map<String, String>> items = [
    {
      'title': 'view_panchang',
      'image': 'assets/images/allcategories/animate/Panchang_icon_animated_1.gif',
      'color': '0xFFFFB74D', // 🟠 Soft Orange
    },
    {
      'title': 'free_kundli',
      'image': 'assets/images/allcategories/Janam_kundli.png',
      'color': '0xFFFF8A65', // 🔴 Soft Red-Orange
    },
    {
      'title': 'kundli_milan',
      'image': 'assets/images/allcategories/animate/Kundli_milan_icon animation.gif',
      'color': '0xFF4DB6AC', // 🟢 Teal
    },
    {
      'title': 'lal_kitab',
      'image': 'assets/images/allcategories/LalKitab_icon.png',
      'color': '0xFF9575CD', // 🟣 Lavender Purple
    },
    {
      'title': 'free_rashifal',
      'image': 'assets/testImage/rashifall/taurus.png',
      'color': '0xFF81C784', // 🟢 Soft Green
    },
    // {
    //   'title': 'free_birth',
    //   'image': 'assets/images/allcategories/Janam_kundli.png',
    //   'color': '0xFF64B5F6', // 🔵 Soft Blue
    // },
    // {
    //   'title': 'free_calculater',
    //   'image': 'assets/images/calculator/mulk_ank.png',
    //   'color': '0xFFFFD54F', // 🟡 Soft Yellow
    // },
  ];

  @override
  void initState() {
    super.initState();
    fetchAllPanditService();
    isLanguage =
    Provider
        .of<LocalizationController>(Get.context!, listen: false)
        .getCurrentLanguage()!;
  }

  @override
  void dispose() {
    _searchController.dispose();
  }

  @override
    Widget build(BuildContext context) {
    final List<Rashi> rashiList = [
      Rashi(
          image: 'assets/testImage/rashifall/aries.jpg',
          name: getTranslated('mesh', context) ?? 'Mesh'),
      Rashi(
          image: 'assets/testImage/rashifall/taurus.jpg',
          name: getTranslated('vrashab', context) ?? 'Vrashab'),
      Rashi(
          image: 'assets/testImage/rashifall/gemini.jpg',
          name: getTranslated('mithun', context) ?? 'Mithun'),
      Rashi(
          image: 'assets/testImage/rashifall/cancer.jpg',
          name: getTranslated('kark', context) ?? 'Kark'),
      Rashi(
          image: 'assets/testImage/rashifall/leo.jpg',
          name: getTranslated('singh', context) ?? 'Singh'),
      Rashi(
          image: 'assets/testImage/rashifall/vergo.jpg',
          name: getTranslated('kanya', context) ?? 'Kanya'),
      Rashi(
          image: 'assets/testImage/rashifall/tula.gif',
          name: getTranslated('tula', context) ?? 'Tula'),
      Rashi(
          image: 'assets/testImage/rashifall/scorpio.gif',
          name: getTranslated('vrashik', context) ?? 'Vrashik'),
      Rashi(
          image: 'assets/testImage/rashifall/sagittarius.gif',
          name: getTranslated('dhanu', context) ?? 'Dhanu'),
      Rashi(
          image: 'assets/testImage/rashifall/capricorn.jpg',
          name: getTranslated('makar', context) ?? 'Makar'),
      Rashi(
          image: 'assets/testImage/rashifall/Aquarius.jpg',
          name: getTranslated('kumbh', context) ?? 'Kumbh'),
      Rashi(
          image: 'assets/testImage/rashifall/min.gif',
          name: getTranslated('meen', context) ?? 'Meen'),
    ];
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
            Consumer<NotificationController>(
                builder: (context, notificationProvider, _) {
                  return IconButton(
                      onPressed: () =>
                          Navigator.push(
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
            ? const Center(
            child: CircularProgressIndicator(color: Colors.amber))
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
                  viewportFraction: 0.9,
                  // 🔥 side images visible
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

              // free services
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
                        'Free Services',
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
              Container(
                height: 180,
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 6),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onItemTap(context, items[index]['title']!),
                      child: Container(
                        width: 110, // Slightly wider for better text display
                        margin: const EdgeInsets.symmetric(horizontal: 5,
                            vertical: 3),
                        decoration: BoxDecoration(
                          gradient: items[index]['color'] != null
                              ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(int.parse(items[index]['color']!))
                                  .withOpacity(0.25), // Increased opacity
                              Color(int.parse(items[index]['color']!))
                                  .withOpacity(0.05), // Subtle fade
                              Colors.white.withOpacity(0.8),
                            ],
                            stops: const [
                              0.0,
                              0.4,
                              1.0
                            ], // Smooth gradient control
                          )
                              : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          // More rounded corners
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.15),
                            width: 0.8,
                          ),
                        ),
                        child: Stack(
                          children: [

                            /// Content
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14, 16, 14, 65),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// Title
                                  Text(
                                    getTranslated(
                                        items[index]['title']!, context) ??
                                        'Free Service',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      // Bolder weight
                                      color: Colors.black87,
                                      height: 1.25,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  /// Optional Subtitle/Description
                                  if (items[index]['subtitle'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      items[index]['subtitle']!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade600,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            /// Image with enhanced styling
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: items[index]['color'] != null
                                        ? Color(
                                        int.parse(items[index]['color']!))
                                        .withOpacity(0.1)
                                        : Colors.grey.shade100,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Image.asset(
                                      items[index]['image']!,
                                      height: 50,
                                      // Slightly smaller but with padding
                                      width: 50,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) {
                                        return const Icon(
                                          Icons.error_outline,
                                          size: 45,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// Optional Badge/Corner Tag
                            if (items[index]['tag'] != null)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(0.95),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    items[index]['tag']!,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // text paid services
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
                        'Paid Services',
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
              Column(
                children: allCategories
                    .asMap()
                    .entries
                    .map((entry) {
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
                              onTap: () =>
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          AllCategoryScreen(
                                            service: categoryList,
                                            panditId: widget.panditId,
                                            isLanguage: isLanguage,
                                            title: category.name ?? 'Details',
                                          ),
                                    ),
                                  ),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      'View all',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Colors.amber,
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

              // rashi fall
              Container(
                key: oneKey,
                child: Padding(
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
                          'Free Rashi Fall',
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
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: rashiList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => RashiFallView(
                                    rashiNameList: rashiList,
                                    rashiName: rashiList[0].name,
                                    index: 0,
                                    context: context,
                                  )));
                        },
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              backgroundColor:
                              Theme.of(context).primaryColor,
                              radius: 31,
                              child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                  AssetImage(rashiList[index].image)),
                            ),
                          ),
                          const SizedBox(
                              height:
                              Dimensions.paddingSizeExtraExtraSmall),
                          Center(
                              child: SizedBox(
                                  width: 80,
                                  child: Text(rashiList[index].name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textRegular.copyWith(
                                          fontWeight:
                                          Provider.of<LocalizationController>(
                                              context)
                                              .locale
                                              .languageCode ==
                                              'hi'
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          letterSpacing: 0.7,
                                          fontSize:
                                          Dimensions.fontSizeSmall,
                                          color:
                                          ColorResources.getTextTitle(
                                              context)))))
                        ]));
                  },
                ),
              ),

              // text recommended product
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
                        'Recommended Products',
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
              Consumer<SellerProductController>(
                  builder: (context, productController, _) {
                    return productController.sellerWiseRecommandedProduct !=
                        null
                        ? (productController.sellerWiseRecommandedProduct !=
                        null &&
                        productController.sellerWiseRecommandedProduct!
                            .products !=
                            null &&
                        productController
                            .sellerWiseRecommandedProduct!.products!.isNotEmpty)
                        ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: PaginatedListView(
                          scrollController: widget.scrollController,
                          onPaginate: (offset) async =>
                          await productController.getSellerProductList(
                              widget.sellerId.toString(), offset!, ""),
                          totalSize:
                          productController.sellerWiseRecommandedProduct
                              ?.totalSize,
                          offset:
                          productController.sellerWiseRecommandedProduct
                              ?.offset,
                          itemView: MasonryGridView.count(
                            itemCount: productController
                                .sellerWiseRecommandedProduct?.products?.length,
                            crossAxisCount: 2,
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ProductWidget(
                                  productModel: productController
                                      .sellerWiseRecommandedProduct!
                                      .products![index]);
                            },
                          )),
                    )
                        : const SizedBox()
                        : ProductShimmer(
                        isEnabled: productController
                            .sellerWiseRecommandedProduct == null,
                        isHomePage: false);
                  }),

              const SizedBox(height: 100,)
            ],
          ),
        ),
      );
    }

  }
