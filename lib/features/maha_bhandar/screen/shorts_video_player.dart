import 'package:flutter/material.dart';
import 'package:mahakal/features/maha_bhandar/api_service.dart';
import 'package:mahakal/features/maha_bhandar/model/playlist_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../../utill/app_constants.dart';

class ShortVideoPlayer extends StatefulWidget {
  const ShortVideoPlayer({super.key, required this.subCategoryId});

  final int subCategoryId;
  @override
  ShortVideoPlayerState createState() => ShortVideoPlayerState();
}

class ShortVideoPlayerState extends State<ShortVideoPlayer> {
  List<Video> items = []; // List to hold all videos
  bool _isLoading = true;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await getList(widget.subCategoryId); // Fetch data from API
      setState(() {
        items = data.data
            .expand((item) => item.videos)
            .toList(); // Flatten the list of videos
        _hasData = items.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
        _hasData = false;
      });
    }
  }

  Future<PlayListModel> getList(int subCategory) async {
    final url =
        '${AppConstants.baseUrl}${AppConstants.youtubeAllVideosUrl}$subCategory&list_type=shorts';
    var response = await ApiService().getPlayList(url);
    print('API Response: $response'); // Debug print
    return PlayListModel.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.orange,
      ));
    }

    if (!_hasData) {
      return const Center(child: Text('No videos available'));
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final video = items[index];
        final isYouTubeUrl = YoutubePlayer.convertUrlToId(video.url) != null;

        return Container(
          height: 800,
          margin: const EdgeInsets.all(2),
          child: isYouTubeUrl
              ? YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(video.url)!,
                    flags: const YoutubePlayerFlags(autoPlay: true),
                  ),
                  showVideoProgressIndicator: true,
                )
              : const Center(
                  child: Text("Unsupported video type"),
                ),
        );
      },
    );
  }
}
