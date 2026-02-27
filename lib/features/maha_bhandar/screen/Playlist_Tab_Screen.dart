import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mahakal/features/maha_bhandar/api_service.dart';
import 'package:mahakal/features/maha_bhandar/model/newtabs_model.dart';
import 'package:mahakal/features/maha_bhandar/screen/all_videos.dart';
import 'package:mahakal/features/maha_bhandar/screen/custom_colors.dart';
import 'package:mahakal/features/maha_bhandar/screen/playlist_videos.dart';
import 'package:mahakal/features/maha_bhandar/screen/shorts_video_player.dart';
import '../../../../utill/app_constants.dart';

class PlaylistTabScreen extends StatefulWidget {
  const PlaylistTabScreen({
    super.key,
    required this.categoryName,
    required this.subCategoryId,
  });

  final String categoryName;
  final int subCategoryId;

  @override
  State<PlaylistTabScreen> createState() => _PlaylistTabScreenState();
}

class _PlaylistTabScreenState extends State<PlaylistTabScreen> {
  DynamicTabs? dynamicTabs;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getTabs();
  }

  Future<void> refresh() async {
    await getTabs();
  }

  Future<void> getTabs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final jsonData = await ApiService().getTabs(
          '${AppConstants.baseUrl}${AppConstants.youtubeAllVideosUrl}${widget.subCategoryId}');

      print(jsonData);

      setState(() {
        dynamicTabs = DynamicTabs.fromJson(jsonData);
        _isLoading = false;

        print(dynamicTabs!.data.length);
        print(dynamicTabs!.availableListTypes.length);
      });
    } catch (e) {
      print('Error fetching tabs: $e');
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    List<Widget> tabs = [
      const Tab(
        text: "All",
      ),
      // Generate tabs based on the available list types

      if (dynamicTabs != null) ...[
        ...List.generate(
          dynamicTabs!.availableListTypes.length,
          (index) {
            final datum = dynamicTabs!.availableListTypes[index];
            return Tab(
              text: (datum.isNotEmpty)
                  ? datum
                  : 'Default Tab', // Fallback for null or empty
            );
          },
        ),
      ]
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
          backgroundColor: CustomColors.clrwhite,
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            title: Text(
              widget.categoryName,
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: screenWidth * 0.07),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                labelStyle: TextStyle(
                    fontSize: screenWidth * 0.05, color: CustomColors.clrblack),
                dividerColor: Colors.transparent,
                indicatorColor: CustomColors.clrorange,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.grey,
                labelPadding:
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: tabs,
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange))
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: refresh,
                        color: Colors.orange,
                        child: TabBarView(
                          children: [
                            AllVideos(
                                subcategoryId: widget.subCategoryId,
                                categoryName: widget.categoryName),
                            ...List.generate(
                              dynamicTabs?.availableListTypes.length ?? 0,
                              (index) {
                                final datum = dynamicTabs!
                                    .availableListTypes[index]
                                    .toLowerCase();

                                if (datum == 'shorts') {
                                  return ShortVideoPlayer(
                                    subCategoryId: widget.subCategoryId,
                                  );
                                } else if (datum == 'playlist') {
                                  return PlaylistVideos(
                                    subCategoryIdd: widget.subCategoryId,
                                    categoryNamee: widget.categoryName,
                                    tabType: 'playlist',
                                  );
                                } else if (datum == 'live') {
                                  return PlaylistVideos(
                                    subCategoryIdd: widget.subCategoryId,
                                    categoryNamee: widget.categoryName,
                                    tabType: 'live',
                                  );
                                } else {
                                  // Handle any other unexpected tab types, or return an empty widget
                                  return const SizedBox
                                      .shrink(); // Or you can return a default widget
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          )),
    );
  }
}
