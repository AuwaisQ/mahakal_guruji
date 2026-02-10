import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mahakal/features/astrotalk/screen/call_history_model.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:provider/provider.dart';

import '../../../utill/app_constants.dart';

class AstroCallLogPage extends StatefulWidget {
  const AstroCallLogPage({super.key});

  @override
  State<AstroCallLogPage> createState() => _AstroCallLogPageState();
}

class _AstroCallLogPageState extends State<AstroCallLogPage> {
  String? userId;
  bool _isLoading = true;
  List<CallRequest> _callHistory = [];

  @override
  initState() {
    super.initState();
    userId = Provider.of<ProfileController>(context, listen: false).userID;
    getChatHistory();
  }

  Future<void> getChatHistory() async {
    const url = '${AppConstants.expressURI}/api/call/history';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'user_id': '$userId'}),
      );

      if (response.statusCode == 200) {
        final callHistoryModel = callHistoryModelFromJson(response.body);
        if (mounted) {
          setState(() {
            _callHistory = callHistoryModel.callRequests;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        debugPrint('Failed to load call history: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error fetching call history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Call History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getChatHistory,
              child: _callHistory.isEmpty
                  ? const Center(child: Text('No call history found.'))
                  : ListView.builder(
                      itemCount: _callHistory.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        final call = _callHistory[index];
                        final durationMinutes = (call.duration / 60).floor();
                        final durationSeconds = call.duration % 60;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.only(bottom: 15),
                          elevation: 2,
                          shadowColor: Colors.grey.withOpacity(0.2),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: NetworkImage(
                                    '${AppConstants.astrologersImages}${call.astrologer.image}',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        call.astrologer.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (call.createdAt != null)
                                        Text(
                                          DateFormat('dd MMM yyyy, hh:mm a')
                                              .format(call.createdAt!),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      call.callType == 'audio'
                                          ? Icons.call
                                          : call.callType == 'video'
                                              ? Icons.videocam
                                              : Icons.chat,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    Text(
                                      '${durationMinutes}m ${durationSeconds}s',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

/*
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Free 25/min",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreenView()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [Colors.amber, Colors.amber],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ]),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.phone,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  "Call",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
*/
