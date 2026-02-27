import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:media_kit/media_kit.dart';

class PoojaVideoPlayer extends StatefulWidget {
  final String streamKey;
  final bool isRecorded;

  const PoojaVideoPlayer({
    super.key,
    required this.streamKey,
    required this.isRecorded,
  });

  @override
  State<PoojaVideoPlayer> createState() => _PoojaVideoPlayerState();
}

class _PoojaVideoPlayerState extends State<PoojaVideoPlayer> {
  Player? _mediaKitPlayer;
  VideoController? _mediaKitController;

  VideoPlayerController? _videoPlayerController; // for live stream
  bool _isPlayerInitialized = false;
  bool _isVisible = false;
  bool _isPlaying = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final String videoExt = widget.isRecorded ? 'flv' : 'm3u8';
      final String videoStreamUrlBase = widget.isRecorded
          ? 'https://stream.mahakal.com/pooja/'
          : 'https://stream.mahakal.com/live/';
      final String url = '$videoStreamUrlBase${widget.streamKey}.$videoExt';

      debugPrint('🎥 Video URL: $url');
      debugPrint('isRecorded: ${widget.isRecorded}');

      if (widget.isRecorded) {
        // media_kit for FLV recordings
        MediaKit.ensureInitialized();
        _mediaKitPlayer = Player();
        _mediaKitController = VideoController(_mediaKitPlayer!);
        await _mediaKitPlayer!.open(Media(url));
        _mediaKitPlayer!.play();
      } else {
        // video_player for live HLS streams
        _videoPlayerController = VideoPlayerController.network(url)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController!.play();
          })
          ..setLooping(true);
      }

      setState(() => _isPlayerInitialized = true);
    } catch (e, st) {
      debugPrint('❌ Player init error: $e\n$st');
      setState(() => _isPlayerInitialized = false);
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _mediaKitPlayer?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void _handleVisibility(bool visible) {
    if (widget.isRecorded) {
      if (_mediaKitPlayer == null) return;
      visible ? _mediaKitPlayer!.play() : _mediaKitPlayer!.pause();
    } else {
      if (_videoPlayerController == null ||
          !_videoPlayerController!.value.isInitialized) return;
      visible
          ? _videoPlayerController!.play()
          : _videoPlayerController!.pause();
    }
  }

  void _togglePlayPause() {
    if (_videoPlayerController == null) return;
    setState(() {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
        _isPlaying = false;
      } else {
        _videoPlayerController!.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      if (_isFullscreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: Text(
                  widget.isRecorded ? 'Recorded Video' : 'Pooja Live Stream'),
            ),
      body: SafeArea(
        child: VisibilityDetector(
          key: Key(widget.streamKey),
          onVisibilityChanged: (info) {
            bool isVisibleNow = info.visibleFraction > 0.5;
            if (_isVisible != isVisibleNow) {
              _isVisible = isVisibleNow;
              _handleVisibility(_isVisible);
            }
          },
          child: Center(
            child: _isPlayerInitialized
                ? widget.isRecorded
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Video(controller: _mediaKitController!),
                      )
                    : _videoPlayerController != null &&
                            _videoPlayerController!.value.isInitialized
                        ? Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              ),
                              _buildControlsOverlay(),
                            ],
                          )
                        : const CircularProgressIndicator()
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.white,
              size: 40,
            ),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: Icon(
              _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 35,
            ),
            onPressed: _toggleFullscreen,
          ),
        ],
      ),
    );
  }
}
