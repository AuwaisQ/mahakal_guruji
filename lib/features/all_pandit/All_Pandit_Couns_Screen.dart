import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/datasource/remote/http/httpClient.dart';
import 'Model/all_pandit_service_model.dart';
import 'Pandit_Bottom_bar.dart';
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
  bool _isSearchActive = false;
  bool isGridview = true;

  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<Counselling> fullList = [];
  List<Counselling> filteredList = [];

  AllPanditServicesModel? gurujiInfo;

  @override
  void initState() {
    super.initState();
    fetchAllPanditService();
  }

  Future<void> fetchAllPanditService() async {
    setState(() => isLoading = true);

    try {
      final url = "/api/v1/guruji/detail?id=${widget.panditId}&type=counselling";
      final response = await HttpService().getApi(url);

      gurujiInfo = AllPanditServicesModel.fromJson(response);

      fullList = gurujiInfo?.counselling ?? [];
      filteredList = fullList;

      setState(() => isLoading = false);
    } catch (e) {
      log("Error: $e");
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
        final name = item.name.toLowerCase() ?? "";
        final venue = item.category?.name.toLowerCase() ?? "";
        return name.contains(value.toLowerCase()) || venue.contains(value.toLowerCase());
      }).toList();
    });
  }

  Widget buildCounsellingCard(Counselling counselling, {bool isList = false}) {
    return InkWell(
      onTap: () =>
          Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => PanditCounsellingDetails(gurujiId: '${gurujiInfo?.guruji?.id}', slug: '${counselling.slug}',)
        ),
      ),
      child: Container(
        margin: isList ? EdgeInsets.only(bottom: 12) : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
              child: CachedNetworkImage(
                imageUrl: counselling.thumbnail,
                height: isList ? 215 : 110,
                width: double.infinity,
                fit: BoxFit.fill,
                placeholder: (_, __) => Container(
                  height: 215,
                  color: Colors.grey.shade200,
                ),
                //errorWidget: (_, __, ___) => NoImageWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    counselling.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text("Rs: ${counselling.counsellingPackage?.price}",
                    maxLines: 1,
                    style: TextStyle(color: Colors.blue,fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PanditCounsellingDetails(gurujiId: '${gurujiInfo?.guruji?.id}', slug: '${counselling.slug}',)
                          ),
                        );
                      },
                      child: const Text("Book Now",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : fullList.isEmpty ? NoDataScreen(title: 'No Counselling', subtitle: 'Data Not Available',) :  CustomScrollView(
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
                  "Vendor Profile",
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
            expandedHeight: 140,
            backgroundColor: Colors.deepOrange.shade50,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildGurujiHeader(),
            ),
          ),

          // ----------------- GRID / LIST CONTENT -----------------
          isGridview
              ? SliverPadding(
            padding: const EdgeInsets.all(14),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    buildCounsellingCard(filteredList[index]),
                childCount: filteredList.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
            ),
          )
              : SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => buildCounsellingCard(filteredList[index], isList: true),
                childCount: filteredList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SEARCH BOX
  Widget _buildSearchBox() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.55,
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
                hintText: "Search Counsell...",
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

  // GURUJI PROFILE HEADER
  Widget _buildGurujiHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.orange.shade200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: gurujiInfo?.guruji?.image ?? "",
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Icon(Icons.broken_image),
              ),
            ),
          ),
          SizedBox(width: 16),

          // NAME + STATS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gurujiInfo?.guruji?.name ?? "",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                Row(
                  children: [
                    _buildStat("6+ Yrs", "Experience"),
                    SizedBox(width: 10),
                    _buildStat("10,000+", "Devotees"),
                    SizedBox(width: 10),
                    _buildStat("1200", "Followers"),
                  ],
                ),
                SizedBox(height: 14),

                Row(
                  children: [
                    _buildFollowBtn(),
                    //SizedBox(width: 10),
                    // _buildShopBtn(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowBtn() {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Following",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}
