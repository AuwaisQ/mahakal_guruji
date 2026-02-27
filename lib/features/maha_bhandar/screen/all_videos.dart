import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahakal/features/maha_bhandar/api_service.dart';
import 'package:mahakal/features/maha_bhandar/model/newtabs_model.dart';
import 'package:mahakal/features/maha_bhandar/screen/custom_colors.dart';
import 'package:mahakal/features/maha_bhandar/screen/shorts_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../utill/app_constants.dart';

class AllVideos extends StatefulWidget {
  const AllVideos({
    super.key,
    required this.subcategoryId,
    required this.categoryName,
  });

  final String categoryName;
  final int subcategoryId;

  @override
  State<AllVideos> createState() => _AllVideosState();
}

class _AllVideosState extends State<AllVideos> {
  bool _isLoading = false;

  DynamicTabs? dynamicTabs;

  List<Video> allVideos = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await getList(widget.subcategoryId);
      setState(() {
        dynamicTabs = data;
        _isLoading = false;

        // Extract videos from dynamicTabs and add to allVideos
        allVideos = _extractVideos(dynamicTabs);

        print("All Videos length is ${allVideos.length}");
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  List<Video> _extractVideos(DynamicTabs? dynamicTabs) {
    List<Video> videos = [];

    if (dynamicTabs != null) {
      for (var category in dynamicTabs.data) {
        // Check if playlistName and listType are null at the category level
        if (category.playlistName == null && category.listType == null) {
          for (var video in category.videos) {
            videos.add(Video(
              title: video.title,
              url: video.url,
              image: video.image,
              urlStatus: video
                  .urlStatus, // Assuming urlStatus is a property in the Video class
            ));
          }
        }
      }
    }

    return videos;
  }

  Future<DynamicTabs> getList(int subCategory) async {
    final url =
        '${AppConstants.baseUrl}${AppConstants.youtubeAllVideosUrl}$subCategory';

    var response = await ApiService().getPlayList(url);

    print(response);

    return DynamicTabs.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: CustomColors.clrwhite,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    final regularVideos = dynamicTabs?.data
        .where((datum) =>
            datum.status == 1 && datum.listType?.toLowerCase() != 'shorts')
        .toList();
    final shortsVideos = dynamicTabs?.data
        .where((datum) =>
            datum.status == 1 && datum.listType?.toLowerCase() == 'shorts')
        .toList();

    return RefreshIndicator(
      onRefresh: _fetchData,
      color: CustomColors.clrblack,
      backgroundColor: CustomColors.clrwhite,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03, vertical: screenWidth * 0.02),
        child: dynamicTabs == null || dynamicTabs!.data.isEmpty
            ? _buildEmptyState(screenWidth)
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlaylistAndDirectVideos(
                        regularVideos, screenWidth, allVideos),
                    const SizedBox(height: 20),
                    _buildShortsVideoSection(shortsVideos, screenWidth),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(double screenWidth) {
    return Scaffold(
      backgroundColor: CustomColors.clrwhite,
      body: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.3,
          ),
          Center(
            child: SizedBox(
              width: 300,
              height: 330,
              child: Card(
                shadowColor: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/image/connection.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      "No Data Found !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black.withOpacity(0.5)),
                    ),
                    Text(
                      "Please try again later...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black.withOpacity(0.5)),
                    ),
                    SizedBox(
                      height: screenWidth * 0.05,
                    ),
                    GestureDetector(
                      onTap: () {
                        _fetchData();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.red.withOpacity(0.7),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.2,
                              vertical: screenWidth * 0.03),
                          child: Text(
                            "Try Again",
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    const Text(
                      "Or",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      "Empty Data",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaylistAndDirectVideos(
      List<Datum>? regularVideos, double screenWidth, List<Video> allVideos) {
    if (regularVideos == null || regularVideos.isEmpty) {
      return Container();
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: regularVideos.length,
      itemBuilder: (BuildContext ctx, int index) {
        final datum = regularVideos[index];
        final playlistName = datum.playlistName;

        if (playlistName != null) {
          // Show playlist as a single entry
          return _buildPlaylistTile(datum, screenWidth);
        } else {
          // Show single videos directly
          return _buildDirectVideosList(
              datum.videos, screenWidth, datum, allVideos);
        }
      },
    );
  }

  Widget _buildPlaylistTile(Datum datum, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PlayListPlayer(playlist: datum),
          ),
        );
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
              color: Colors.grey.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 3, // Spread radius
              blurRadius: 2, // Blur radius
              offset: const Offset(0, 1), // Offset in x and y directions
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
                        image: NetworkImage(datum.videos.first.image),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.playlist_add_check,
                            color: Colors.white,
                            size: 32,
                          ),
                          Text(
                            "${datum.videos.length} Videos",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
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
                    "${datum.playlistName}",
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Play Now",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
  }

  Widget _buildDirectVideosList(List<Video> videos, double screenWidth,
      Datum datum, List<Video> allVideos) {
    return Column(
      children: videos.map((video) {
        return _buildVideoTile(screenWidth, video, datum, allVideos);
      }).toList(),
    );
  }

  Widget _buildVideoTile(
      double screenWidth, Video video, Datum datum, List<Video> allVideos) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SingleVideoPlayer(
              playlist: datum,
              allVideos: allVideos,
              video: video.url,
              isNamePassed: true,
              videoTitle: video.title,
            ),
          ),
        );
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
              color: Colors.grey.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 3, // Spread radius
              blurRadius: 2, // Blur radius
              offset: const Offset(0, 1), // Offset in x and y directions
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: screenWidth * 0.23,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: NetworkImage(video.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    video.title,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Play Now",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
  }

  Widget _buildShortsVideoSection(
      List<Datum>? shortsVideos, double screenWidth) {
    if (shortsVideos == null || shortsVideos.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shorts',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: shortsVideos.length.clamp(0, 4),
          // Limit to 4 shorts
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (BuildContext ctx, int index) {
            return _buildShortsLayout(screenWidth, shortsVideos[index].videos,
                index, widget.subcategoryId);
          },
        ),
      ],
    );
  }

  Widget _buildShortsLayout(
      double screenWidth, List<Video> video, int myIndex, int subCategoryId) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, CupertinoPageRoute(builder: (context) =>
        //   AllShortsPlayer()));
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ShortVideoPlayer(
                subCategoryId: widget.subcategoryId,
              ),
            ));
        //ShortsPlayer(dynamicTabs: dynamicTabs!, currentIndex: myIndex),));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: NetworkImage(video[myIndex].image), fit: BoxFit.cover),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: screenWidth * 0.5, left: screenWidth * 0.02),
          child: Stack(
            children: [
              Text(
                video[myIndex].title,
                style: TextStyle(
                    color: CustomColors.clrwhite, fontSize: screenWidth * 0.04),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayListPlayer extends StatefulWidget {
  final Datum playlist;

  const PlayListPlayer({
    super.key,
    required this.playlist,
  });

  @override
  _PlayListPlayerState createState() => _PlayListPlayerState();
}

class _PlayListPlayerState extends State<PlayListPlayer> {
  late YoutubePlayerController youtubePlayerController;
  late YoutubeMetaData videoMetaData;
  bool isPlayerReady = false;
  int _selectedVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    videoMetaData = const YoutubeMetaData();

    youtubePlayerController = YoutubePlayerController(
      initialVideoId:
          getVideoId(widget.playlist.videos[_selectedVideoIndex].url),
      //initialVideoId: getVideoId("https://www.youtube.com/watch?v=K8bWhiM7hJE"),
      flags: const YoutubePlayerFlags(
        useHybridComposition: true,
        mute: false,
        autoPlay: true,
        forceHD: true,
        enableCaption: false,
      ),
    )..addListener(listener);
  }

  /// Safely extracts the video ID from any YouTube URL
  String getVideoId(String url) {
    return YoutubePlayer.convertUrlToId(url) ?? '';
  }

  void listener() {
    if (isPlayerReady &&
        mounted &&
        !youtubePlayerController.value.isFullScreen) {
      setState(() {
        videoMetaData = youtubePlayerController.metadata;
      });
    }
  }

  @override
  void deactivate() {
    youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: youtubePlayerController,
            showVideoProgressIndicator: true,
            topActions: [
              InkWell(
                onTap: () {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )
            ],
            onReady: () {
              isPlayerReady = true;
              print('🎬 Player is ready.');
            },
          ),
          builder: (BuildContext context, Widget player) {
            return Column(
              children: [
                AppBar(
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios,
                        color: Colors.green, size: screenWidth * 0.07),
                  ),
                  automaticallyImplyLeading: false,
                  title: Text(
                    widget.playlist.playlistName ?? 'Playlist',
                    style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: player,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(7),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    widget.playlist.videos[_selectedVideoIndex].title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3.0,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15,
                        crossAxisCount: 1,
                      ),
                      itemCount: widget.playlist.videos.length,
                      itemBuilder: (context, videoIndex) {
                        final video = widget.playlist.videos[videoIndex];
                        return InkWell(
                          onTap: () {
                            final videoId = getVideoId(video.url);
                            print(
                                "🎥 Playing video ID: $videoId from URL: ${video.url}");
                            if (videoId.isNotEmpty) {
                              setState(() {
                                _selectedVideoIndex = videoIndex;
                              });
                              youtubePlayerController.load(videoId);
                            } else {
                              print("⚠️ Invalid YouTube URL: ${video.url}");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade600),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(7),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            video.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 5, bottom: 5),
                                    child: Text(
                                      video.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// class _PlayListPlayerState extends State<PlayListPlayer> {
//   late YoutubePlayerController youtubePlayerController;
//   late YoutubeMetaData videoMetaData;
//   bool isPlayerReady = false;
//   int _selectedVideoIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     videoMetaData = const YoutubeMetaData();
//
//     youtubePlayerController = YoutubePlayerController(
//       initialVideoId: getVideoId(widget.playlist.videos[_selectedVideoIndex].url),
//       flags: const YoutubePlayerFlags(
//         useHybridComposition: true,
//         mute: false,
//         autoPlay: true,
//       ),
//     )..addListener(listener);
//   }
//
//   String getVideoId(String url) {
//     final RegExp regExp = RegExp(r"[?&]v=([^&#]*)");
//     final match = regExp.firstMatch(url);
//     return match?.group(1) ?? '';
//   }
//
//   void listener() {
//     if (isPlayerReady &&
//         mounted &&
//         !youtubePlayerController.value.isFullScreen) {
//       setState(() {
//         videoMetaData = youtubePlayerController.metadata;
//       });
//     }
//   }
//
//   @override
//   void deactivate() {
//     youtubePlayerController.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     youtubePlayerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: SafeArea(
//         child: YoutubePlayerBuilder(
//           player: YoutubePlayer(
//             controller: youtubePlayerController,
//             showVideoProgressIndicator: true,
//             topActions: [
//               InkWell(
//                   onTap: () {
//                     SystemChrome.setPreferredOrientations(
//                         [DeviceOrientation.portraitUp]);
//                     Navigator.pop(context);
//                   },
//                   child: const Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.white,
//                   ))
//             ],
//             onReady: () {
//               isPlayerReady = true;
//               print('Player is ready.');
//             },
//           ),
//           builder: (BuildContext context, Widget player) {
//             return Column(
//               children: [
//                 AppBar(
//                   leading: GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(Icons.arrow_back_ios,
//                         color: Colors.green, size: screenWidth * 0.07),
//                   ),
//                   automaticallyImplyLeading: false,
//                   title: Text(
//                     widget.playlist.playlistName ?? 'Playlist',
//                     style: TextStyle(
//                         fontSize: screenWidth * 0.06,
//                         color: CustomColors.clrorange,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: player,
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(7),
//                   margin: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Text(
//                     widget.playlist.videos[_selectedVideoIndex].title,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                   ),
//                 ),
//                 Flexible(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         childAspectRatio: 3.0,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 15,
//                         crossAxisCount: 1,
//                       ),
//                       itemCount: widget.playlist.videos.length,
//                       itemBuilder: (context, videoIndex) {
//                         return InkWell(
//                           onTap: () {
//                             print("My Video Url: ${widget.playlist.videos[_selectedVideoIndex].url}");
//                             setState(() {
//                               _selectedVideoIndex = videoIndex;
//                             });
//                             youtubePlayerController.load(getVideoId(widget.playlist.videos[videoIndex].url));
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey.shade600),
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey),
//                                       borderRadius: BorderRadius.circular(7),
//                                       image: DecorationImage(
//                                         image: CachedNetworkImageProvider(
//                                           widget.playlist.videos[videoIndex]
//                                               .image,
//                                         ),
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 10, top: 5, bottom: 5),
//                                     child: Text(
//                                       widget.playlist.videos[videoIndex].title,
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class SingleVideoPlayer extends StatefulWidget {
  String videoTitle;
  bool isNamePassed;
  String? video;
  List<Video> allVideos;
  final Datum playlist;

  SingleVideoPlayer(
      {super.key,
      required this.playlist,
      required this.allVideos,
      required this.video,
      required this.isNamePassed,
      required this.videoTitle});

  @override
  _SingleVideoPlayerState createState() => _SingleVideoPlayerState();
}

class _SingleVideoPlayerState extends State<SingleVideoPlayer> {
  late YoutubePlayerController youtubePlayerController;
  late YoutubeMetaData videoMetaData;
  bool isPlayerReady = false;
  int _selectedVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    videoMetaData = const YoutubeMetaData();

    youtubePlayerController = YoutubePlayerController(
      initialVideoId: getVideoId(widget.video!),
      flags: const YoutubePlayerFlags(
        useHybridComposition: true,
        mute: false,
        autoPlay: true,
      ),
    )..addListener(listener);
  }

  String getVideoId(String url) {
    final RegExp regExp = RegExp(r"[?&]v=([^&#]*)");
    final match = regExp.firstMatch(url);
    return match?.group(1) ?? '';
  }

  void listener() {
    if (isPlayerReady &&
        mounted &&
        !youtubePlayerController.value.isFullScreen) {
      setState(() {
        videoMetaData = youtubePlayerController.metadata;
      });
    }
  }

  @override
  void deactivate() {
    youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: youtubePlayerController,
            showVideoProgressIndicator: true,
            topActions: [
              InkWell(
                  onTap: () {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))
            ],
            onReady: () {
              isPlayerReady = true;
              print('Player is ready.');
            },
          ),
          builder: (BuildContext context, Widget player) {
            return Column(
              children: [
                AppBar(
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios,
                        color: CustomColors.clrblack, size: screenWidth * 0.05),
                  ),
                  title: Text(
                    widget.videoTitle,
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: CustomColors.clrorange,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: player,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(7),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    widget.isNamePassed
                        ? widget.videoTitle
                        : widget.allVideos[_selectedVideoIndex].title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3.0,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15,
                        crossAxisCount: 1,
                      ),
                      itemCount: widget.allVideos.length,
                      itemBuilder: (context, videoIndex) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedVideoIndex = videoIndex;
                              widget.isNamePassed = false;
                              widget.videoTitle =
                                  widget.allVideos[videoIndex].title;
                            });
                            youtubePlayerController.load(
                                getVideoId(widget.allVideos[videoIndex].url));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade600),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(7),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.allVideos[videoIndex].image,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 5, bottom: 5),
                                    child: Text(
                                      widget.allVideos[videoIndex].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
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
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
