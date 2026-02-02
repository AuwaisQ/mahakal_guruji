// To parse this JSON data, do
//
//     final callHistoryModel = callHistoryModelFromJson(jsonString);

import 'dart:convert';

CallHistoryModel callHistoryModelFromJson(String str) =>
    CallHistoryModel.fromJson(json.decode(str));

String callHistoryModelToJson(CallHistoryModel data) =>
    json.encode(data.toJson());

class CallHistoryModel {
  final bool success;
  final List<CallRequest> callRequests;

  CallHistoryModel({
    required this.success,
    required this.callRequests,
  });

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) =>
      CallHistoryModel(
        success: json["success"] ?? false,
        callRequests: json["callRequests"] == null
            ? []
            : List<CallRequest>.from(
                json["callRequests"]!.map((x) => CallRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "callRequests": List<dynamic>.from(callRequests.map((x) => x.toJson())),
      };
}

class CallRequest {
  final int id;
  final int userId;
  final int astrologerId;
  final String callType;
  final bool isConnected;
  final bool completed;
  final bool isRejected;
  final DateTime? startTime;
  final DateTime? endTime;
  final int duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Astrologer astrologer;

  CallRequest({
    required this.id,
    required this.userId,
    required this.astrologerId,
    required this.callType,
    required this.isConnected,
    required this.completed,
    required this.isRejected,
    this.startTime,
    this.endTime,
    required this.duration,
    this.createdAt,
    this.updatedAt,
    required this.astrologer,
  });

  factory CallRequest.fromJson(Map<String, dynamic> json) => CallRequest(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        astrologerId: json["astrologer_id"] ?? 0,
        callType: json["call_type"] ?? "",
        isConnected: json["is_connected"] ?? false,
        completed: json["completed"] ?? false,
        isRejected: json["is_rejected"] ?? false,
        startTime: json["start_time"] == null
            ? null
            : DateTime.tryParse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.tryParse(json["end_time"]),
        duration: json["duration"] ?? 0,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"]),
        astrologer: Astrologer.fromJson(json["astrologer"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "astrologer_id": astrologerId,
        "call_type": callType,
        "is_connected": isConnected,
        "completed": completed,
        "is_rejected": isRejected,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "duration": duration,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "astrologer": astrologer.toJson(),
      };
}

class Astrologer {
  final int id;
  final String name;
  final String image;

  Astrologer({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Astrologer.fromJson(Map<String, dynamic> json) => Astrologer(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}