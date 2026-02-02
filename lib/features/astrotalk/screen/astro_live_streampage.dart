import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahakal/utill/app_constants.dart';
import 'package:mahakal/features/astrotalk/model/live_stream_model.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../components/video_live_player.dart';
import '../controller/astrotalk_controller.dart';

class ShortsFeedScreen extends StatefulWidget {
  const ShortsFeedScreen({super.key});

  @override
  State<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends State<ShortsFeedScreen> {
  final PageController _pageController = PageController();
  List<LiveStreamModel> videoUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('objects');
    fetchVideoUrls();
    final socketController =
        Provider.of<SocketController>(context, listen: false);
    socketController.socketService.onStreamStart((data) {
      print("Message Received-$data");
      onStreamStart(data);
    });
    socketController.socketService.onStreamEnd((data) {
      print("Message Received-$data");
      onStreamEnd(data);
    });
  }

  onStreamStart(data) async {
    print("Message Live Received-$data");
    if (data is Map && data.containsKey('streamId')) {
      await Future.delayed(const Duration(seconds: 10));
      videoUrls.add(LiveStreamModel(
        astrologerId: data['astrologerId'],
        url: 'http://89.116.32.44:8888/hls/${data['streamId']}.m3u8',
        stream: true,
        startedAt: data['startedAt'],
        streamId: data['streamId'],
        astrologerName:
            data['astrologerName'] ?? 'N/A', // Provide default if null
        astrologerImage:
            data['astrologerImage'] ?? '', // Provide default if null
      ));
    }
    if (mounted) {
      setState(() {});
    }
  }

  onStreamEnd(data) async {
    print("Message Live Received End-$data");
    if (data != null) {
      final streamUrl = 'http://89.116.32.44:8888/hls/$data.m3u8';
      var index = videoUrls.indexWhere((item) => item.url == streamUrl);
      if (index != -1) {
        await Future.delayed(const Duration(seconds: 5));
        // Re-find index as list might have changed during delay
        index = videoUrls.indexWhere((item) => item.url == streamUrl);
        if (index != -1) {
          videoUrls[index].stream = false;
          if (mounted) setState(() {});
          print(
              'Stream ended: ${videoUrls[index].stream} / URL - ${videoUrls[index].url}');
        }

        await Future.delayed(const Duration(seconds: 15));
        
        // Re-find index again before removal
        index = videoUrls.indexWhere((item) => item.url == streamUrl);
        if (index != -1) {
          videoUrls.removeAt(index);
          if (mounted) setState(() {});
          
          // If we removed the last item and the user was viewing it, animate to the new last item
          if (videoUrls.isNotEmpty && _pageController.hasClients) {
            final currentIndex = _pageController.page?.round() ?? 0;
            if (currentIndex >= videoUrls.length) {
              _pageController.animateToPage(videoUrls.length - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          }
        }
      }
    }
  }

  Future<void> fetchVideoUrls() async {
    final url = Uri.parse(AppConstants.liveAstrologers); // Your actual API
    try {
      videoUrls.clear();

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Extract streamIds and build HLS URLs
        final List<dynamic> streams = data['activeStreams'] ?? [];
        final List<LiveStreamModel> fetchedStreams =
            streams.map<LiveStreamModel>((streamData) {
          return LiveStreamModel(
            url:
                '${AppConstants.astrologerLiveStreamURL}${streamData['streamId']}.m3u8',
            stream: true,
            astrologerId: streamData['astrologerId'],
            startedAt: streamData['startedAt'],
            streamId: streamData['streamId'],
            astrologerName: streamData['astrologerName'] ?? 'N/A',
            astrologerImage: streamData['astrologerImage'] ?? '',
          );
        }).toList();

        setState(() {
          videoUrls = fetchedStreams;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load video URLs");
      }
    } catch (e) {
      debugPrint("Error fetching video URLs: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (videoUrls.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("No Astrologers are Live")),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          padEnds: false,
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: videoUrls.length,
          itemBuilder: (context, index) {
            return ShortVideoPlayer(
              key: ValueKey(videoUrls[index].url),
              url: videoUrls[index].url!,
              isStarted: videoUrls[index].stream!,
              astrologerName: videoUrls[index].astrologerName,
              astrologerImageUrl: videoUrls[index].astrologerImage,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
