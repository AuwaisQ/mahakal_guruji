import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mahakal/utill/app_constants.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../../helper/socket_services.dart';

class SocketController extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  SocketService get socketService => _socketService;

  Future<void> initSocket(String userId) async {
    try {
      _socketService.connect();
      _socketService.socket!.onConnect((_) {
        debugPrint('Socket Connected Successfully');
        _isConnected = true;
        _socketService.registerFrontUser(userId);
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error initializing socket: $e');
    }
  }

  Future<void> sendChatMessage({
    required String to,
    required String from,
    required String message,
    String msgFrom = 'user',
  }) async {
    final url = Uri.parse(AppConstants.sendAstrologersChat);
    final body = jsonEncode({
      "to": to,
      "from": from,
      "message": message,
      "msg_from": msgFrom,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print("Message sent successfully");
      } else {
        print(
            "Failed to send message: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}
