import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/utill/app_constants.dart';
import '../../data/datasource/remote/http/httpClient.dart';
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

  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<Service> fullList = [];
  List<Service> filteredList = [];
  //List<Category> categories = [];

  AllPanditServicesModel? gurujiInfo;

  List<Category> allCategories = [];

  @override
  void initState() {
    super.initState();
    fetchAllPanditService();
  }

  Future<void> fetchAllPanditService() async {
    setState(() => isLoading = true);

    try {
      final url = "${AppConstants.allPanditServiceUrl}${widget.panditId}&type=pooja";
      final response = await HttpService().getApi(url);

      print("Response is:$response");

      gurujiInfo = AllPanditServicesModel.fromJson(response);
      setState(() {
        fullList = gurujiInfo?.service ?? [];
        filteredList = fullList;
      });

      print("All List Data is:$fullList");

      List<Category> apiCategories = gurujiInfo?.guruji?.isPanditPoojaCategory ?? [];
      Category allPoojaCategory = Category(
        id: 0,
        name: "All Pooja",
        slug: "all", icon: '', parentId: 0, position: 0, createdAt: null, updatedAt: null, homeStatus: 0, priority: 0, translations: [],
        // Add other required fields
      );

      setState(() {
        allCategories = [allPoojaCategory] + apiCategories;
        isLoading = false;
        _selectedCategoryIndex = 0; // Default All Pooja selected
      });
    } catch (e) {
      print('All Pandit Pooja:${e}');
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
        final name = item.name?.toLowerCase() ?? "";
        final venue = item.poojaVenue?.toLowerCase() ?? "";
        return name.contains(value.toLowerCase()) ||
            venue.contains(value.toLowerCase());
      }).toList();
    });
  }

  Widget buildPoojaCard(Service panditDetails, {bool isList = false}) {
    return filteredList.isEmpty ? _buildNoPoojaWidget() : InkWell(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => PanditPoojaDetails(
            panditId: widget.panditId,
            poojaSlug: panditDetails.slug,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: isList ? EdgeInsets.only(bottom: 16) : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade100,
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: panditDetails.thumbnail,
                    height: isList ? 150 : 90,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    // placeholder: (_, __) => placeholderImage(),
                    // errorWidget: (_, __, ___) => NoImageWidget()
                  ),
                ),

                // Gradient Overlay
                Container(
                  height: isList ? 150 : 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
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
                          panditDetails.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Location
                  if (panditDetails.poojaVenue != null && panditDetails.poojaVenue!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            panditDetails.poojaVenue!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 10),

                  // Booking Button with Enhanced Design
                  Container(
                    height: 40,
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
                          offset: Offset(0, 4),
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
                              poojaSlug: panditDetails.slug,
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
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Book Now",
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : fullList.isEmpty ? NoDataScreen(title: 'No Pooja', subtitle: 'Data Not Available',) : CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          // ----------------- TOP SEARCH APPBAR -----------------
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                // IconButton(
                //   icon: const Icon(Icons.arrow_back_ios,
                //       color: Colors.black),
                //   onPressed: () => Navigator.pop(context),
                // ),

                _isSearchActive
                    ? _buildSearchBox()
                    : const Text(
                  "Pandit Pooja Services",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),

                Spacer(),

                _buildSearchToggle(),
                SizedBox(width: 10),
                _buildGridToggle(),
              ],
            ),
          ),

          // ----------------- PANIDT PROFILE HEADER -----------------
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildGurujiHeader(),
            ),
          ),

          // ---------- Free Service---------
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: 170,
          //     color: Colors.white,
          //     child: Column(
          //       children: [
          //         // Title with decorative divider
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          //           child: Row(
          //             children: [
          //               Expanded(
          //                 child: Divider(
          //                   color: Colors.deepOrange.shade200,
          //                   thickness: 1,
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(horizontal: 15),
          //                 child: Text(
          //                   "Free Services",
          //                   style: TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.deepOrange.shade800,
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Divider(
          //                   color: Colors.deepOrange.shade200,
          //                   thickness: 1,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //
          //         // Horizontal Categories List
          //         Expanded(
          //           child: ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             padding: EdgeInsets.symmetric(horizontal: 16),
          //             itemCount: items.length,
          //             itemBuilder: (context, index) {
          //               return _buildServiceItem(items[index]);
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // ---------- Paid Service---------
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 100,
              maxHeight: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    Expanded(
                      child: Padding(
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
                                "Paid Services",
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
                    ),

                    // Tabs
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: allCategories.length,
                          itemBuilder: (context, index) {
                            return _buildEnhancedCategoryTab(allCategories[index], index);                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          isGridview
              ? SliverPadding(
            padding: const EdgeInsets.all(14),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    buildPoojaCard(filteredList[index]),
                childCount: filteredList.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.70,
              ),
            ),
          )
              : SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    buildPoojaCard(filteredList[index], isList: true),
                childCount: filteredList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // No Pooja Widget
  Widget _buildNoPoojaWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Title
            Text(
              "No Pooja Available",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange.shade800,
              ),
            ),
            SizedBox(height: 10),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Currently there are no poojas available for this category. Please check other categories or contact the Guruji.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Get Short Name for Display
  String _getShortName(String fullName) {
    Map<String, String> shortNames = {
      "Samsya Nivaran Puja": "Samsya Nivaran",
      "Vastu Puja": "Vastu",
      "Manglik Puja": "Manglik",
      "Graha Shanti": "Graha Shanti",
      "Kundli Milan": "Kundli",
      "Remedies": "Remedies",
      "Gemstone": "Gemstone",
      "Other Pujas": "Others",
    };

    return shortNames[fullName] ?? fullName;
  }

  Widget _buildEnhancedCategoryTab(Category category, int index) {
    String shortName = category.name == "All Pooja"
        ? "All Pooja"
        : _getShortName(category.name);

    bool isSelected = _selectedCategoryIndex == index;

    return GestureDetector(
      onTap: () => _onCategoryTap(index, category),
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16),
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
                offset: Offset(0, 4),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with background circle
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.deepOrange.withOpacity(0.2),
                ),
                child: Icon(
                  category.name == "All Pooja"
                      ? Icons.all_inclusive
                      : _getCategoryIcon(category.name),
                  size: 16,
                  color: isSelected ? Colors.white : Colors.deepOrange,
                ),
              ),
              SizedBox(width: 8),
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
      ),
    );
  }

  void _onCategoryTap(int index, Category category) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    if (category.name == "All Pooja") {
      // All Pooja selected - show all poojas
      _showAllPoojas();
    } else {
      // Specific category selected
      _filterByCategory(category);
    }
  }

  void _showAllPoojas() {
    setState(() {
      filteredList = fullList;
    });
  }

  void _filterByCategory(Category category) {
    setState(() {
      // Check different possible field names for category matching
      filteredList = fullList.where((pooja) {
        // Try multiple ways to match category
        return pooja.categoryId == category.id ||
            pooja.slug == category.slug ||
            pooja.name == category.name ||
            (pooja.category != null && pooja.category!.id == category.id) ||
            (pooja.category != null && pooja.category!.name == category.name);
      }).toList();

      // Debug print
      print("Filtered list length: ${filteredList.length}");
      print("Category ID to filter: ${category.id}");
      print("Category Name to filter: ${category.name}");
    });
  }

  Color _getCategoryColor(String categoryName) {
    switch (categoryName) {
      case "Samsya Nivaran Puja":
        return Color(0xFF1DD1A1); // Emerald Green
      case "Vastu Puja":
        return Color(0xFF5F27CD); // Royal Purple
      case "Manglik Puja":
        return Color(0xFFFF9F43); // Orange
      case "Graha Shanti":
        return Color(0xFFFF4757); // Vibrant Red
      case "Kundli Milan":
        return Color(0xFF2E86DE); // Ocean Blue
      case "Remedies":
        return Color(0xFF10AC84); // Forest Green
      case "Gemstone":
        return Color(0xFFFF6B9D); // Hot Pink
      case "Other Pujas":
        return Color(0xFFFECA57); // Golden Yellow
      default:
        return Colors.deepOrange;
    }
  }

  // Get Icon for Category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Samsya Nivaran Puja":
        return Icons.psychology;
      case "Vastu Puja":
        return Icons.home;
      case "Manglik Puja":
        return Icons.favorite;
      case "Graha Shanti":
        return Icons.star;
      case "Kundli Milan":
        return Icons.auto_awesome;
      case "Remedies":
        return Icons.healing;
      case "Gemstone":
        return Icons.diamond;
      default:
        return Icons.celebration;
    }
  }

  // SEARCH BOX
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
                hintText: "Search pooja...",
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

  Widget _buildGurujiHeader() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://astromanch.com/public/storage/images/blog_2531759311506.webp'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4), // Dark overlay for better text visibility
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE with border and shadow
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(2), // border thickness
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: gurujiInfo?.guruji?.image ?? "",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.white.withOpacity(0.1),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Colors.white.withOpacity(0.7),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),

            // NAME + STATS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gurujiInfo?.guruji?.name ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),

                  // Stats with better styling
                  Row(
                    children: [
                      _buildStatWithIcon(Icons.work_history, "6+ Yrs", "Experience"),
                      SizedBox(width: 8),
                      _buildStatWithIcon(Icons.people, "10K+", "Devotees"),
                      SizedBox(width: 8),
                      _buildStatWithIcon(Icons.favorite, "1.2K", "Followers"),
                    ],
                  ),

                  // Follow Button
                  //_buildFollowBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatWithIcon(IconData icon, String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
              SizedBox(width: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
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

  Widget _buildFollowBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_add, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            "Follow Guruji",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


}

// Delegate class for SliverPersistentHeader
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}