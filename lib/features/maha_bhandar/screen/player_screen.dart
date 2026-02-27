import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahakal/features/maha_bhandar/model/playlist_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final int currentIndex;
  final PlayListModel playListModel;
  const PlayerScreen(
      {super.key, required this.currentIndex, required this.playListModel});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late YoutubePlayerController youtubePlayerController;
  late YoutubeMetaData videoMetaData;
  bool isPlayerReady = false;
  int _selectedVideoIndex = 0;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    videoMetaData = const YoutubeMetaData();

    youtubePlayerController = YoutubePlayerController(
      initialVideoId: getVideoId(widget
          .playListModel.data[_currentIndex].videos[_selectedVideoIndex].url),
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
                  ))
            ],
            showVideoProgressIndicator: true,
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios,
                        color: Colors.red, size: screenWidth * 0.07),
                  ),
                  automaticallyImplyLeading: false,
                  title: Text(
                    widget.playListModel.data[_currentIndex].listType! ??
                        'Playlist',
                    style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        color: Colors.black,
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
                    widget.playListModel.data[_currentIndex]
                        .videos[_selectedVideoIndex].title,
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
                      itemCount: widget
                          .playListModel.data[_currentIndex].videos.length,
                      itemBuilder: (context, videoIndex) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedVideoIndex = videoIndex;
                            });
                            youtubePlayerController.load(getVideoId(widget
                                .playListModel
                                .data[_currentIndex]
                                .videos[videoIndex]
                                .url));
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
                                          widget
                                              .playListModel
                                              .data[_currentIndex]
                                              .videos[videoIndex]
                                              .image,
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
                                      widget.playListModel.data[_currentIndex]
                                          .videos[videoIndex].title,
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
