import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/maha_bhandar/api_service.dart';
import 'package:mahakal/features/maha_bhandar/model/newtabs_model.dart';
import 'package:mahakal/features/maha_bhandar/model/playlist_model.dart';
import 'package:mahakal/features/maha_bhandar/screen/custom_colors.dart';
import 'package:mahakal/features/maha_bhandar/screen/player_screen.dart';
import '../../../../../utill/app_constants.dart';
import '../../../../../utill/flutter_toast_helper.dart';

class PlaylistVideos extends StatefulWidget {
  const PlaylistVideos({
    super.key,
    required this.subCategoryIdd,
    required this.categoryNamee,
    required this.tabType,
  });

  final int subCategoryIdd;
  final String categoryNamee;
  final String tabType;

  @override
  State<PlaylistVideos> createState() => _PlaylistVideosState();
}

class _PlaylistVideosState extends State<PlaylistVideos> {
  bool _hasData = false;
  bool _isLoading = true;
  late Future<void> _fetchDataFuture;
  PlayListModel? playListModel;
  DynamicTabs? dynamicTabs;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await getList(widget.subCategoryIdd);
      // print('Fetched Data: ${data.toJson()}'); // Debug print
      setState(() {
        playListModel = data;
        _hasData = playListModel!.data.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
        _hasData = false;
      });
      ToastHelper.showError("${e}");
    }
  }

  Future<void> _refreshData() async {
    await _fetchData();
  }

  Future<PlayListModel> getList(int subCategory) async {
    final url =
        '${AppConstants.baseUrl}${AppConstants.youtubeAllVideosUrl}$subCategory&list_type=${widget.tabType}';
    var response = await ApiService().getPlayList(url);
    print('API Response: $response'); // Debug print
    return PlayListModel.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: CustomColors.clrblack,
      backgroundColor: CustomColors.clrwhite,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : _hasData
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playListModel!.data.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    final video = playListModel!.data[index];

                    // Filter out videos with status other than 1
                    if (video.status != 1) {
                      return const SizedBox.shrink(); // Skip this item
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => PlayerScreen(
                                    currentIndex: index,
                                    playListModel: playListModel!)));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(
                                  0.2), // Shadow color with opacity
                              spreadRadius: 3, // Spread radius
                              blurRadius: 2, // Blur radius
                              offset: const Offset(
                                  0, 1), // Offset in x and y directions
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: screenWidth * 0.23,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(7),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            video.videos[0].image),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: screenWidth * 0.23,
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.playlist_add_check,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          Text(
                                            "${video.videos.length} Videos",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "${video.playlistName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.orange,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Play Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Icon(
                                          Icons.play_circle,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text('${playListModel!.data.length}'),
                ),
    );
  }
}
