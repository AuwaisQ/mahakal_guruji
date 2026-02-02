import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:mahakal/utill/app_constants.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? _socket;
  final String _serverUrl =
      AppConstants.expressURI; // Replace with your server IP and port

  IO.Socket? get socket => _socket;

  void connect() {
    _socket = IO.io(
      _serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(5000)
          .build(),
    );

    _socket!.onConnect((_) {
      print('Socket connected');
    });

    // socket!.onConnect((val) {
    //   debugPrint('Connected to socket server si');
    //   SharedPreferenceHelper.getUserType().then((value){
    //     print('value $value');
    //     if(value != null && value == 'Astrologer'){
    //       SharedPreferenceHelper.getUserId().then((value){
    //         print("user id $value");
    //         registerAstrologer(value.toString());
    //       });
    //     }
    //   });
    // });

    socket!.onDisconnect((val) {
      debugPrint('Disconnected from socket server');
    });

    _socket!.onError((err) {
      debugPrint('Socket error: $err');
    });

    socket!.onReconnect((val) {
      debugPrint('Reconnected to socket server');
    });

    _socket!.connect();

    _socket!.on('receive_message', (data) {
      print('data $data');
    });
  }

  void registerFrontUser(String userId) {
    _socket?.emit('register-front-user', {'userId': userId});
  }

  void registerAstrologer(String astrologerId) {
    _socket?.emit('register-astrologer', {'astrologerId': astrologerId});
  }

  void joinRoom(String roomId, String userId, Function(dynamic)? ack) {
    _socket?.emitWithAck('join-room', {'roomId': roomId, 'userId': userId},
        ack: ack);
  }

  void sendSignal(
      {required String to, required String type, required dynamic data}) {
    _socket?.emit('signal', {
      'to': to,
      'type': type,
      'data': data,
    });
  }

  void connectChat(Map<String, dynamic> userData) {
    print("chat Emitted: $userData");
    _socket?.emit('chat-connected', userData);
  }

  void sendMessage({
    required String message,
    required String from,
    required String datetime,
    String? toUserId,
    required String msgFrom, // 'user' or 'astrologer'
  }) {
    _socket?.emit('send_message', {
      'message': message,
      'from': from,
      'datetime': datetime,
      'toUserId': toUserId,
      'msg_from': msgFrom,
    });
  }

  void sendChatMessage(String roomId, String message, String userId) {
    _socket?.emit('chat-message', {
      'roomId': roomId,
      'message': message,
      'userId': userId,
    });
  }

  void startLivestream(String roomId, dynamic streamInfo, String userId) {
    _socket?.emit('livestream-start', {
      'roomId': roomId,
      'streamInfo': streamInfo,
      'userId': userId,
    });
  }

  void sendChatMessageLivestream(String streamId, dynamic userName, String userImage, String message) {
    _socket?.emit('group-send-message', {
      'streamId': streamId,
      'username': userName,
      'userimage': userImage,
      'message':  message,
    });
    print(streamId);
    print(userName);
    print(userImage);
    print(message);
  }

  void stopLivestream(String roomId, String userId) {
    _socket?.emit('livestream-stop', {
      'roomId': roomId,
      'userId': userId,
    });
  }

  void onChatMessage(Function(dynamic) callback) {
    _socket?.on('chat-message', callback);
  }

  void onLiveStreamMessage(Function(dynamic) callback) {
    _socket?.on('group-receive-message', callback);
  }

  void onReceiveMessage(Function(dynamic) callback) {
    print('check message $callback');
    _socket?.on('receive_message', callback);
  }

  void onSignal(Function(dynamic) callback) {
    _socket?.on('signal', callback);
  }

  void onUserJoined(Function(dynamic) callback) {
    _socket?.on('user-joined', callback);
  }

  void onUserLeft(Function(dynamic) callback) {
    _socket?.on('user-left', callback);
  }

  void onLivestreamStart(Function(dynamic) callback) {
    _socket?.on('livestream-start', callback);
  }

  void onStreamStart(Function(dynamic) callback) {
    _socket?.on('start-live', callback);
  }

  void onStreamEnd(Function(dynamic) callback) {
    _socket?.on('end-live', callback);
  }

  void onLivestreamStop(Function(dynamic) callback) {
    _socket?.on('livestream-stop', callback);
  }

  void getAstrologerOnline(Function(dynamic) callback) {
    _socket?.on('online-astrologers', callback);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
}
