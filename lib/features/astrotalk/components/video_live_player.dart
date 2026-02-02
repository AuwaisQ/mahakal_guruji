import 'package:flutter/material.dart';
import 'package:mahakal/features/astrotalk/controller/astrotalk_controller.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/features/splash/controllers/splash_controller.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/services.dart';

class ShortVideoPlayer extends StatefulWidget {
  final String url;
  final bool isStarted;
  final String astrologerName;
  final String astrologerImageUrl;

  const ShortVideoPlayer(
      {super.key,
      required this.url,
      required this.isStarted,
      required this.astrologerName,
      required this.astrologerImageUrl});

  @override
  State<ShortVideoPlayer> createState() => _ShortVideoPlayerState();
}

// Simple chat message model for the overlay
class _ChatMessage {
  final String userName;
  final String userImageUrl;
  final String text;

  _ChatMessage(
      {required this.userName,
      required this.userImageUrl,
      required this.text});
}



class _ShortVideoPlayerState extends State<ShortVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVisible = false;
  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;
  final ScrollController _messageScrollController = ScrollController();
  // Static messages to display on the UI (with user info)
  final List<_ChatMessage> _messages = [];

  late final SocketController socketController;
  String userName = '';
  String userImage = '';
  String userId = '';

  Future<void> _initializePlayer() async {
    print('Video URL - ${widget.url}');
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      draggableProgressBar: false,
      showControlsOnInitialize: false,
      isLive: true,
      looping: true,
      aspectRatio: (MediaQuery.of(context).size.width + 25) /
          MediaQuery.of(context).size.height,
      errorBuilder: (context, errorMessage) {
        // Return an empty container to hide the default error icon (exclamation mark).
        return Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: Text(
                    'Live has ended',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
      },
    );
    if (mounted) setState(() {});
  }




  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode();
    userName = Provider.of<ProfileController>(context, listen: false).userNAME;
    userImage = Provider.of<ProfileController>(context, listen: false).userIMAGE;
    userId = Provider.of<ProfileController>(context, listen: false).userID;
    socketController = Provider.of<SocketController>(context, listen: false);
    print('Socket Connection: ${socketController.isConnected}');
    if (socketController.isConnected == false) {
      socketController.initSocket(userId);
    }

    socketController.socketService.sendChatMessageLivestream(
        widget.url.split('/').last.split('.').first,
        userName,
        '${Provider.of<SplashController>(context, listen: false).baseUrls!.customerImageUrl}/''$userImage',
        'joined the live stream!'
      );
      final joinMessage = _ChatMessage(
          userName: userName,
          userImageUrl: '${Provider.of<SplashController>(context, listen: false).baseUrls!.customerImageUrl}/''$userImage',
          text: 'Joined the live stream!',
        );
        setState(() {
          _messages.add(joinMessage);
        });

    socketController.socketService
        .onLiveStreamMessage((data) {
      print('Live Stream Message Received-$data');
      if (data is Map &&
          data.containsKey('username') &&
          data.containsKey('userimage') &&
          data.containsKey('message')) {
        final newMessage = _ChatMessage(
          userName: data['username'],
          userImageUrl: '${Provider.of<SplashController>(context, listen: false).baseUrls!.customerImageUrl}/''${data['userimage']}',
          text: data['message'],
        );
        setState(() {
          _messages.add(newMessage);
        });
      }
    });
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ShortVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isStarted && !widget.isStarted) {
      // The stream has just ended, so pause the player to prevent it from
      // trying to buffer and showing an error.
      _videoPlayerController?.pause();
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    _messageScrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Create a new message from current user
    final newMessage = _ChatMessage(
      userName: userName,
      userImageUrl: '${Provider.of<SplashController>(context, listen: false).baseUrls!.customerImageUrl}/$userImage',
      text: messageText,
    );

    // Add to local messages list
    setState(() {
      _messages.add(newMessage);
    });

    // Send via socket
    socketController.socketService.sendChatMessageLivestream(
      widget.url.split('/').last.split('.').first,
      userName,
      '${Provider.of<SplashController>(context, listen: false).baseUrls!.customerImageUrl}/$userImage',
      messageText,
    );

    // Clear the text field
    _messageController.clear();

    // Auto-scroll to bottom
    if (_messageScrollController.hasClients) {
      _messageScrollController.animateTo(
        _messageScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleVisibility(bool visible) {
    if (_videoPlayerController != null) {
      if (visible) {
        _videoPlayerController!.play();
      } else {
        _videoPlayerController!.pause();
      }
    }
  }

@override
Widget build(BuildContext context) {
  return VisibilityDetector(
    key: Key(widget.url),
    onVisibilityChanged: (info) {
      bool isVisible = info.visibleFraction > 0.5;
      if (_isVisible != isVisible) {
        _isVisible = isVisible;
        _handleVisibility(_isVisible);
      }
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player
          _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : const Center(child: CircularProgressIndicator()),

          // Top Gradient + Astrologer Info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      widget.astrologerImageUrl.isNotEmpty
                          ? '${AppConstants.astrologersImages}${widget.astrologerImageUrl}'
                          : 'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.astrologerName.isNotEmpty
                            ? widget.astrologerName
                            : 'Astrologer',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.circle,
                              color: Colors.green, size: 10),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 25),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Action Buttons
          Positioned(
            right: 16,
            bottom: 20,
            child: Column(
              children: [
                _actionButton(Icons.shopping_bag, 'Gift'),
              ],
            ),
          ),

          // Messages Overlay
          Positioned(
            left: 16,
            right: 16,
            bottom: 75,
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: ListView.builder(
                controller: _messageScrollController,
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[_messages.length - 1 - index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(msg.userImageUrl),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.userName,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                              Text(
                                msg.text,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // `Chat` Input
          Positioned(
            bottom: 20,
            left: 16,
            right: 80,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(_messageFocusNode);
                SystemChannels.textInput.invokeMethod('TextInput.show');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Send a message...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                        SystemChannels.textInput
                            .invokeMethod('TextInput.hide');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.send,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Overlay for ended stream
          if (!widget.isStarted)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: Text(
                    'Live has ended',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.black45,
          radius: 25,
          child: Icon(icon, color: Colors.white),
        ),
      ],
    );
  }
}
