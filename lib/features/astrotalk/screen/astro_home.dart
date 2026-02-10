import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mahakal/common/basewidget/custom_image_widget.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart' as http_service;
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/features/astrotalk/components/wallet_recharge_screen.dart';
import 'package:mahakal/features/astrotalk/screen/userProfile_update_sheet.dart';
import 'package:mahakal/features/banner/controllers/banner_controller.dart';
import 'package:mahakal/features/banner/widgets/banner_shimmer.dart';
import 'package:mahakal/features/astrotalk/model/astro_category_model';
import 'package:mahakal/features/category/domain/models/category_model.dart';
import 'package:mahakal/features/more/screens/more_screen_view.dart';
import 'package:mahakal/features/splash/controllers/splash_controller.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:mahakal/utill/images.dart';
import 'package:page_animation_transition/animations/left_to_right_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:provider/provider.dart';
import '../../../helper/socket_services.dart';
import '../../../main.dart';
import '../../profile/controllers/profile_contrroller.dart';
import '../controller/astrotalk_controller.dart';
import '../model/astrologers_list_model.dart';
import 'astro_chatscreen.dart';
import 'astro_profilepage.dart';

class AstroTalkHome extends StatefulWidget {  
  final ScrollController scrollController;
  const AstroTalkHome({super.key, required this.scrollController});
  @override
  State<AstroTalkHome> createState() => _AstroTalkHomeState();
}

class _AstroTalkHomeState extends State<AstroTalkHome> {
  bool isGridView = true;
  bool isLoading = false;
  bool hasMoreData = true;
  bool isOpen = true;
  List<AstrologerListModelData> astrologers = [];
  int currentPage = 1;
  int? selectedCategoryIndex;
  int selectedSortOption = 0;
  List onLineAstrologers = [];
  List <AstroCategoryModel> astroCategoriesList = [];

  final List<String> categories = ['Popular', 'Price', 'Rating', 'Newest'];
  final List<String> sortOptions = [
    'Low to High',
    'High to Low',
    'Top Rated',
    'Latest'
  ];
  String userId = '';
  String userName = '';
  String userPhone = '';
  String userEmail = '';
  String userGender = '';
  String userDob = '';
  String userTob = '';
  String userPob = '';
  String walletAmt= '0';
  final ScrollController _scrollController = ScrollController();

  final socketService = SocketService();

  Future<List<AstrologerListModelData>> fetchAstrologers(int page) async {
    final response =
        await http.get(Uri.parse('${AppConstants.astrologersList}?page=$page'));
    print("URL- ${Uri.parse('${AppConstants.astrologersList}?page=$page')}");

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      print('Astrologers- $data');
      return data
          .map((json) => AstrologerListModelData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load astrologers');
    }
  }

  void fetchOnlineAstrologers() async {
    final response =
        await http.get(Uri.parse(AppConstants.onlineAstrologersList));
    print('URL- ${Uri.parse(AppConstants.onlineAstrologersList)}');
    if (response.statusCode == 200) {
      getOnlineAstrologers(response.body);
    }
  }

  Future<void> getAstrologersGategory() async {
    try {
      final response = await http_service.HttpService().getApi(AppConstants.astrologersCategory);
      print('Category response--->${response['data']}');
      if (response['status'] == 200) {
        List data = response['data'];
        setState(() {
          astroCategoriesList = data
              .map<AstroCategoryModel>(
                  (json) => AstroCategoryModel.fromJson(json))
              .toList();
        });
        print('Categories List--->${astroCategoriesList.length}');
      }
    } catch (e) {
      print('Error fetching Astrlogers Category: $e');
    }
  }
  
  Future<void> fetchAstrologersByCategory(int categoryId) async {
    setState(() {
      isLoading = true;
      astrologers.clear();
      hasMoreData = false;
    });
    try {
      final response = await http.get(
        Uri.parse(AppConstants.fetchAstrologersByCategory + categoryId.toString())
      );
      print('Category Response-${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['data'] != null) {
          List list = data['data'];
          if (mounted) {
            setState(() {
              astrologers = list
                  .map((json) => AstrologerListModelData.fromJson(json))
                  .toList();
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching category astrologers: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        sortAstrologers();
      }
    }
  }

  void _loadAstrologers() async {
    if (isLoading || !hasMoreData) return;

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      List<AstrologerListModelData> newAstrologers =
          await fetchAstrologers(currentPage);

      if (mounted) {
        setState(() {
          if (newAstrologers.isEmpty) {
            hasMoreData = false;
          }
          astrologers.addAll(newAstrologers);
          currentPage++;
        });
      }
    } catch (e) {
      print('Error loading astrologers: $e');
      if (mounted) {
        setState(() {
          hasMoreData = false; // Stop trying to load more if an error occurs
        });
      }
    } finally {
      fetchOnlineAstrologers();
      if (mounted) {
        setState(() {
          isLoading = false;
          sortAstrologers();
        });
      }
    }
  }

  getOnlineAstrologers(val) {
    print('Astrologers online-$val');
    if (mounted) {
      setState(() {
        onLineAstrologers = val is String ? json.decode(val) : val;
      });
      sortAstrologers();
    }
  }

  sortAstrologers() {
    setState(() {
      List<AstrologerListModelData> sortedAstrologers = List.from(astrologers);
      sortedAstrologers.sort((a, b) {
        bool isAOnline = onLineAstrologers
            .map((e) => e.toString())
            .contains(a.id.toString());
        bool isBOnline = onLineAstrologers
            .map((e) => e.toString())
            .contains(b.id.toString());
        if (isBOnline && !isAOnline) return 1;
        if (!isBOnline && isAOnline) return -1;
        return 0;
      });
      astrologers = sortedAstrologers;
      print('Astrologers online Sorted-${astrologers.map((e) => e.name)}');
    });
  }

  @override
  void initState() {
    
    getAstrologersGategory();
    userId = Provider.of<ProfileController>(Get.context!, listen: false).userID;
    print('user_id-$userId');
    walletAmount();
    userName =
        Provider.of<ProfileController>(Get.context!, listen: false).userNAME;
    userPhone =
        Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
    userEmail =
        Provider.of<ProfileController>(Get.context!, listen: false).userEMAIL;
    userGender =
        Provider.of<ProfileController>(Get.context!, listen: false).userGender;
    print('userGender-$userGender');
    if (userGender == 'Male' ||
        userGender == 'male' ||
        userGender == 'Female' ||
        userGender == 'female' ||
        userGender == 'Other' ||
        userGender == 'other') {
      setState(() {
        isOpen = false;
        print('From SetState isOpen-$isOpen');
      });
    }
    userDob =
        Provider.of<ProfileController>(Get.context!, listen: false).userDob;
    userTob =
        Provider.of<ProfileController>(Get.context!, listen: false).userTob;
    userPob =
        Provider.of<ProfileController>(Get.context!, listen: false).userPob;
    final socketController =
        Provider.of<SocketController>(context, listen: false);
    socketController.initSocket(userId);
    _loadAstrologers();
    print(userId);
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
              widget.scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMoreData) {
        _loadAstrologers();
      }
    });
    socketController.socketService.getAstrologerOnline((val) {
      getOnlineAstrologers(val);
    });
    super.initState();
  }

  // Future<bool> walletAmount() async {
  //   var res =
  //       await HttpService().getApi('${AppConstants.fetchWalletAmount}$userId');
  //   if (res['success']) {
  //     if (res['wallet_balance'] == 0) {
  //       print('Wallet amount is zero');
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       return false;
  //     } else {
  //       print('Wallet amount is-${res['wallet_balance']}');
  //       setState(() {
  //         walletBalance = res['wallet_balance'].toString();
  //         _isLoading = false;
  //       });
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  Future<bool> walletAmount() async {
    var res =
        await HttpService().getApi('${AppConstants.fetchWalletAmount}$userId');
    if (res['success']) {
      if (res['wallet_balance'] == 0) {
        print('Wallet amount is zero');
        return false;
      } else {
        print('Wallet amount is-${res['wallet_balance']}');
        setState(() {
          walletAmt = res['wallet_balance'].toString();
        });
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Astrologers',
          style: TextStyle(color: Colors.amber),
        ),
        leading: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageAnimationTransition(
                              page: MoreScreen(scrollController: _scrollController),
                              pageAnimationType: LeftToRightTransition()));
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomImageWidget(
                              image:
                                  '${Provider.of<SplashController>(context, listen: false).baseUrls!.customerImageUrl}/'
                                  '${Provider.of<ProfileController>(context, listen: false).userInfoModel?.image}',
                              width: 40,
                              height: 40,
                              fit: BoxFit.fill,
                              placeholder: Images.guestProfile),
                        ),
                      ],
                    ),
                  ),
                ),
        actions: [
          const SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                print('userId:$userId');
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => RechargeBottomSheet(
                    userId: userId,
                    userEmail: userEmail,
                    userName: userName,
                    userPhone: userPhone,
                  ),
                );
              },
              child: const Icon(
                    Icons.account_balance_wallet,
                    size: 27,
                    color: Colors.amber,
                  ),),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Consumer<BannerController>(
                      builder: (context, bannerProvider, child) {
                        if (bannerProvider.chatBannerList == null) {
                          return const BannerShimmer();
                        }
                        if (bannerProvider.chatBannerList!.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 180.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            autoPlayInterval: const Duration(seconds: 3),
                            onPageChanged: (index, reason) {
                              bannerProvider.setCurrentIndex(index);
                            },
                          ),
                          itemCount: bannerProvider.chatBannerList!.length,
                          itemBuilder: (context, index, realIndex) {
                            final banner = bannerProvider.chatBannerList![index];
                            final imageUrl =
                                '${Provider.of<SplashController>(context, listen: false).baseUrls?.bannerImageUrl}/${banner.photo}';
                            return InkWell(
                              onTap: () {
                                bannerProvider.clickBannerRedirect(
                                  context,
                                  banner.resourceId,
                                  banner.product,
                                  banner.resourceType,
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(imageUrl,
                                    fit: BoxFit.cover, width: double.infinity),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.fiber_manual_record,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 5),
                          const Text(
                            'Explore Your Preference',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  print('is grid view change');
                                  setState(() {
                                    isGridView = !isGridView;
                                  });
                                },
                                child: Center(
                                    child: Icon(
                                  isGridView == true
                                      ? Icons.list
                                      : Icons.grid_view,
                                  color: Colors.amber,
                                ))),
                          )
                        ],
                      ),
                    ),
                    _buildPreferenceChips(),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    _sectionTitle('Mahakal Astrologers'),
                    isGridView == true
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount:
                                astrologers.length + (hasMoreData ? 1 : 0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) {
                              if (index < astrologers.length) {
                                final astrologer = astrologers[index];
                                return GestureDetector(
                                  onTap: () {
                                    print('Astrologer ID: ${astrologer.id}');
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) =>
                                                AstrologerprofileView(
                                                  id: astrologer.id.toString(),
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              blurRadius: 10,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                          border: Border.all(
                                              color:onLineAstrologers
                                                .map((e) => e.toString())
                                                .contains(
                                                    astrologer.id.toString()) 
                                                    ? Colors.green.shade300
                                                    : Colors.grey.shade300,
                                              width:1),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Profile Image with Badge
                                            Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.amber,
                                                        Colors.amber
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 32,
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    backgroundImage:
                                                        NetworkImage(
                                                      '${AppConstants.astrologersImages}${astrologer.image}',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          blurRadius: 4,
                                                        )
                                                      ]),
                                                  child: const Icon(
                                                      Icons.verified,
                                                      color: Colors.blue,
                                                      size: 16),
                                                ),
                                              ],
                                            ),

                                            // Name and Details
                                            Column(
                                              children: [
                                                Text(
                                                  astrologer.name!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey[800],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.star,
                                                        color: Colors.amber,
                                                        size: 16),
                                                    const SizedBox(width: 4),
                                                    const Text('4.9',
                                                        style: TextStyle(
                                                            fontSize: 13)),
                                                    const SizedBox(width: 8),
                                                    const Icon(
                                                        Icons.work_outline,
                                                        color: Colors.grey,
                                                        size: 14),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                        '${astrologer.experience} yrs',
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .blueGrey)),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    '₹ ${astrologer.isAstrologerChatCharge}/min',
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.amber,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // Chat Button
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() => isLoading = true);
                                                final hasBalance = await walletAmount();
                                                setState(() => isLoading = false);

                                                print('Chat Now tapped');                                                
                                                print('isNavigate-$hasBalance');
                                                print('isOpen-$isOpen');

                                                if (isOpen) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.white,
                                                    builder: (context) =>
                                                        UserProfileUpdateSheet(
                                                      userId: userId,
                                                      onProfileUpdate:
                                                          (gender, dob, tob,
                                                              pob) {
                                                        setState(() {
                                                          isOpen = false;
                                                          userGender = gender;
                                                          userDob = dob;
                                                          userTob = tob;
                                                          userPob = pob;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                } else if (hasBalance) {
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (_) =>
                                                              ChatScreenView(
                                                                astrologerId:
                                                                    astrologer
                                                                        .id!
                                                                        .toString(),
                                                                        chargePerMin: astrologer.isAstrologerChatCharge,
                                                                astrologerName:
                                                                    astrologer
                                                                        .name!,
                                                                astrologerImage:
                                                                    astrologer
                                                                        .image!,
                                                                userId: userId,
                                                              )));
                                                  return;
                                                } else {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (context) =>
                                                        RechargeBottomSheet(
                                                      userId: userId,
                                                      userEmail: userEmail,
                                                      userName: userName,
                                                      userPhone: userPhone,
                                                    ),
                                                  );
                                                  return;
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Colors.amber,
                                                        Colors.amber
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.amber
                                                            .withOpacity(0.3),
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 4),
                                                      )
                                                    ]),
                                                child: const Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.chat,
                                                          color: Colors.white,
                                                          size: 16),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        'Chat Now',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: onLineAstrologers
                                                .map((e) => e.toString())
                                                .contains(
                                                    astrologer.id.toString())
                                            ? const Icon(
                                                Icons.circle,
                                                color: Colors.green,
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        : ListView.builder(
                            itemCount: astrologers.length + (isLoading ? 1 : 0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              if (index < astrologers.length) {
                                final astrologer = astrologers[index];
                                final languages = astrologer.language ?? [];
                                return GestureDetector(
                                  onTap: () {

                                    print('Astrologer ID: ${astrologer.id}');
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) =>
                                                AstrologerprofileView(
                                                  id: astrologer.id.toString(),
                                                )));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    elevation: 2,
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.grey[50]!
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // Profile Image with Badge
                                          Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.amber,
                                                      Colors.amber
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  backgroundImage: NetworkImage(
                                                    '${AppConstants.astrologersImages}${astrologer.image}',
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        blurRadius: 3,
                                                      )
                                                    ]),
                                                child: const Icon(
                                                    Icons.verified,
                                                    color: Colors.blue,
                                                    size: 14),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(width: 12),

                                          // Details Column
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min, // Makes Row wrap its content
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        astrologer.name ??
                                                            'Mahakal Astrologer',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 3),
                                                    const Icon(Icons.verified,
                                                        color:
                                                            Colors.amber,
                                                        size: 16),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(Icons.work_outline,
                                                        size: 14,
                                                        color:
                                                            Colors.grey[600]),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "${astrologer.experience ?? "1"} years of exp",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.language,
                                                        size: 14,
                                                        color:
                                                            Colors.grey[600]),
                                                    const SizedBox(width: 4),
                                                    Row(
                                                      children: List.generate(
                                                        languages.length,
                                                        (i) => Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 4.0),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: Text(
                                                            '${languages[i]}'
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors
                                                                  .grey[700],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: List.generate(
                                                          5,
                                                          (i) => Icon(
                                                                i < 4
                                                                    ? Icons.star
                                                                    : Icons
                                                                        .star_border,
                                                                color: Colors
                                                                    .amber,
                                                                size: 16,
                                                              )),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      '4.9 (1.8k)',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Right Column with CTA
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber[50],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "${astrologer.isAstrologerChatCharge ?? "50"}र/min",
                                                  style: const TextStyle(
                                                      color: Colors.amber,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              GestureDetector(
                                                onTap: () async {
                                                setState(() => isLoading = true);
                                                final hasBalance = await walletAmount();
                                                setState(() => isLoading = false);

                                                print('Chat Now tapped');                                                
                                                print('isNavigate-$hasBalance');
                                                print('isOpen-$isOpen');

                                                if (isOpen) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.white,
                                                    builder: (context) =>
                                                        UserProfileUpdateSheet(
                                                      userId: userId,
                                                      onProfileUpdate:
                                                          (gender, dob, tob,
                                                              pob) {
                                                        setState(() {
                                                          isOpen = false;
                                                          userGender = gender;
                                                          userDob = dob;
                                                          userTob = tob;
                                                          userPob = pob;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                } else if (hasBalance) {
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (_) =>
                                                              ChatScreenView(
                                                                astrologerId:
                                                                    astrologer
                                                                        .id!
                                                                        .toString(),
                                                                        chargePerMin: astrologer.isAstrologerChatCharge,
                                                                astrologerName:
                                                                    astrologer
                                                                        .name!,
                                                                astrologerImage:
                                                                    astrologer
                                                                        .image!,
                                                                userId: userId,
                                                              )));
                                                  return;
                                                } else {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (context) =>
                                                        RechargeBottomSheet(
                                                      userId: userId,
                                                      userEmail: userEmail,
                                                      userName: userName,
                                                      userPhone: userPhone,
                                                    ),
                                                  );
                                                  return;
                                                }
                                              },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Colors.amber,
                                                          Colors.amber
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.amber
                                                              .withOpacity(0.2),
                                                          blurRadius: 6,
                                                          offset: const Offset(
                                                              0, 3),
                                                        )
                                                      ]),
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.chat,
                                                          color: Colors.white,
                                                          size: 14),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        'Chat',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, color: Colors.blue, size: 18),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
      children: List.generate(
        astroCategoriesList.length,
        (index) => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          side: BorderSide(color: selectedCategoryIndex == index ? Colors.amber : Colors.grey.shade300),
            avatar: CircleAvatar(
            backgroundImage: NetworkImage(astroCategoriesList[index].image),
            radius: 12,
            ),
          label: Text(astroCategoriesList[index].enName ?? ''),
          backgroundColor: Colors.grey[200],
          selected: selectedCategoryIndex == index,
          selectedColor: Colors.amber[100],
          onSelected: (selected) {
            if (selectedCategoryIndex == index) {
              setState(() {
                selectedCategoryIndex = null;
                currentPage = 1;
                astrologers.clear();
                hasMoreData = true;
              });
              print('Category unselected');
              _loadAstrologers();
            } else {
              setState(() {
                selectedCategoryIndex = index;
              });
              print('Selected Category ID: ${astroCategoriesList[index].id}');
              fetchAstrologersByCategory(int.parse(astroCategoriesList[index].id.toString()));
            }
          },
          labelStyle: TextStyle(color: selectedCategoryIndex == index ? Colors.amber : Colors.black),
        ),
        ),
      ),
      ),
    );
    }
  }
