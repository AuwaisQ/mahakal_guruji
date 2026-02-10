// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../data/datasource/remote/http/httpClient.dart';
// import '../blogs_module/no_image_widget.dart';
// import 'Model/all_pandit_service_model.dart';
// import 'Pandit_Pooja_Details.dart';
//
//
// class AllPanditEventScreen extends StatefulWidget {
//   final int panditId;
//   final ScrollController scrollController;
//
//   const AllPanditEventScreen({
//     super.key,
//     required this.panditId,
//     required this.scrollController,
//   });
//
//   @override
//   State<AllPanditEventScreen> createState() => _AllPanditEventScreenState();
// }
//
// class _AllPanditEventScreenState extends State<AllPanditEventScreen> {
//   bool isLoading = false;
//   bool _isSearchActive = false;
//   bool isGridview = true;
//
//   TextEditingController _searchController = TextEditingController();
//   FocusNode _focusNode = FocusNode();
//
//   List<Event> fullList = [];
//   List<Event> filteredList = [];
//
//   AllPanditServicesModel? gurujiInfo;
//
//   @override
//   void initState() {
//     super.initState();
//     print("Pandit ID: ${widget.panditId}");
//     fetchAllPanditService();
//   }
//
//   Future<void> fetchAllPanditService() async {
//     setState(() => isLoading = true);
//
//     try {
//       final url = "/api/v1/guruji/detail?id=${widget.panditId}&type=event";
//       final response = await HttpService().getApi(url);
//
//       print("Response is:$response");
//
//       gurujiInfo = AllPanditServicesModel.fromJson(response);
//
//       fullList = gurujiInfo?.event ?? [];
//       filteredList = fullList;
//
//       setState(() => isLoading = false);
//     } catch (e) {
//       log("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   void searchItems(String value) {
//     if (value.isEmpty) {
//       setState(() => filteredList = fullList);
//       return;
//     }
//
//     setState(() {
//       filteredList = fullList.where((item) {
//         final name = item.metaTitle.toLowerCase() ?? "";
//         final venue = item.eventArtist.toLowerCase() ?? "";
//         return name.contains(value.toLowerCase()) ||
//             venue.contains(value.toLowerCase());
//       }).toList();
//     });
//   }
//
//   Widget buildEventCard(Event eventDetails, {bool isList = false}) {
//     return InkWell(
//         onTap: () {
//
//         },
//         //     Navigator.push(
//         //   context,
//         //   CupertinoPageRoute(
//         //     builder: (_) => PanditPoojaDetails(
//         //       panditId: widget.panditId,
//         //       poojaSlug: eventDetails.slug,
//         //     ),
//         //   ),
//         // ),
//         child: Container(
//     margin: isList ? EdgeInsets.only(bottom: 12) : null,
//     decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(14),
//     boxShadow: [
//     BoxShadow(
//     blurRadius: 5,
//     color: Colors.black12,
//     )
//     ],
//     ),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     ClipRRect(
//     borderRadius:
//     const BorderRadius.vertical(top: Radius.circular(14)),
//     child: CachedNetworkImage(
//     imageUrl: eventDetails.eventImage,
//     height: isList ? 215 : 110,
//     width: double.infinity,
//     fit: BoxFit.fill,
//     placeholder: (_, __) => Container(
//     height: 215,
//     color: Colors.grey.shade200,
//     ),
//     errorWidget: (_, __, ___) => NoImageWidget(),
//     ),
//     ),
//     Padding(
//     padding: const EdgeInsets.all(10),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Text(
//     eventDetails.metaTitle,
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//     style: const TextStyle(
//     fontWeight: FontWeight.bold, fontSize: 16),
//     ),
//     const SizedBox(height: 5),
//     Text(
//     eventDetails.eventArtist ?? "",
//     maxLines: 1,
//     style: TextStyle(color: Colors.grey.shade600),
//     ),
//     const SizedBox(height: 10),
//     SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//     style: ElevatedButton.styleFrom(
//     backgroundColor: Colors.amber),
//     onPressed: () {
//     // Navigator.push(
//     //   context,
//     //   CupertinoPageRoute(
//     //     builder: (_) => PanditPoojaDetails(
//     //       panditId: widget.panditId,
//     //       poojaSlug: eventDetails.slug,
//     //     ),
//     //   ),
//     // );
//     },
//     child: const Text("Book Now",
//     style: TextStyle(color: Colors.white)),
//     ),
//     ),
//     ],
//     ),
//     )
//     ],
//     ),
//     ),
//     );
//     }
//
//   // SMALL BOX FOR STATS
//   Widget _buildStat(String value, String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(value,
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 15)),
//         Text(label, style: TextStyle(color: Colors.grey.shade600)),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.amber))
//           : CustomScrollView(
//         controller: widget.scrollController,
//         slivers: [
//           // ----------------- TOP SEARCH APPBAR -----------------
//           SliverAppBar(
//             pinned: true,
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.white,
//             title: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios,
//                       color: Colors.black),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//
//                 _isSearchActive
//                     ? _buildSearchBox()
//                     : const Text(
//                   "Vendor Profile",
//                   style: TextStyle(
//                       color: Colors.amber,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold),
//                 ),
//
//                 Spacer(),
//
//                 _buildSearchToggle(),
//                 SizedBox(width: 10),
//                 _buildGridToggle(),
//               ],
//             ),
//           ),
//
//           // ----------------- PANIDT PROFILE HEADER -----------------
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             expandedHeight: 140,
//             backgroundColor: Colors.amber.shade50,
//             flexibleSpace: FlexibleSpaceBar(
//               background: _buildGurujiHeader(),
//             ),
//           ),
//
//           // ----------------- GRID / LIST CONTENT -----------------
//           isGridview
//               ? SliverPadding(
//             padding: const EdgeInsets.all(14),
//             sliver: SliverGrid(
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) =>
//                     buildEventCard(filteredList[index]),
//                 childCount: filteredList.length,
//               ),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//                 childAspectRatio: 0.65,
//               ),
//             ),
//           )
//               : SliverPadding(
//             padding: const EdgeInsets.all(10),
//             sliver: SliverList(
//               delegate: SliverChildBuilderDelegate(
//                     (context, index) =>
//                     buildEventCard(filteredList[index], isList: true),
//                 childCount: filteredList.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // SEARCH BOX
//   Widget _buildSearchBox() {
//     return Container(
//       height: 40,
//       width: MediaQuery.of(context).size.width * 0.55,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.grey.shade50,
//         border: Border.all(color: Colors.amber),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.search, color: Colors.grey),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: _searchController,
//               focusNode: _focusNode,
//               autofocus: true,
//               onChanged: searchItems,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Search pooja...",
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // SEARCH BUTTON
//   Widget _buildSearchToggle() {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _isSearchActive = !_isSearchActive;
//
//           if (!_isSearchActive) {
//             _searchController.clear();
//             filteredList = fullList; // 🔥 IMPORTANT LINE
//             FocusScope.of(context).unfocus();
//           }
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.amber.shade50,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.amber),
//         ),
//         child: Icon(
//           _isSearchActive ? Icons.close : Icons.search,
//           color: Colors.amber,
//         ),
//       ),
//     );
//   }
//
//   // GRID / LIST TOGGLE BUTTON
//   Widget _buildGridToggle() {
//     return GestureDetector(
//       onTap: () => setState(() => isGridview = !isGridview),
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.amber.shade50,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.amber),
//         ),
//         child: Icon(
//           isGridview ? Icons.list : Icons.grid_view,
//           color: Colors.amber,
//         ),
//       ),
//     );
//   }
//
//   // GURUJI PROFILE HEADER
//   Widget _buildGurujiHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // IMAGE
//           CircleAvatar(
//             radius: 45,
//             backgroundColor: Colors.amber.shade200,
//             child: ClipOval(
//               child: CachedNetworkImage(
//                 imageUrl: gurujiInfo?.guruji?.image ?? "",
//                 width: 90,
//                 height: 90,
//                 fit: BoxFit.cover,
//                 errorWidget: (_, __, ___) => Icon(Icons.broken_image),
//               ),
//             ),
//           ),
//           SizedBox(width: 16),
//
//           // NAME + STATS
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   gurujiInfo?.guruji?.name ?? "",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//
//                 Row(
//                   children: [
//                     _buildStat("6+ Yrs", "Experience"),
//                     SizedBox(width: 12),
//                     _buildStat("10,000+", "Devotees"),
//                     SizedBox(width: 12),
//                     _buildStat("1200", "Followers"),
//                   ],
//                 ),
//                 SizedBox(height: 14),
//
//                 Row(
//                   children: [
//                     _buildFollowBtn(),
//                     //SizedBox(width: 10),
//                     // _buildShopBtn(),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFollowBtn() {
//     return Container(
//       height: 40,
//       width: 150,
//       decoration: BoxDecoration(
//         color: Colors.amberAccent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: Text(
//           "Following",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';

class ComingSoonWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ComingSoonWidget({
    super.key,
    this.title = "No Events Available",
    this.subtitle = "New events are coming soon.\nStay tuned!",
    this.icon = Icons.event_busy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          'Info',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
