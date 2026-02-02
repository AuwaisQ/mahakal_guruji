// To parse this JSON data, do
//
//     final liveStreamModel = liveStreamModelFromJson(jsonString);

import 'dart:convert';

LiveStreamModel liveStreamModelFromJson(String str) =>
    LiveStreamModel.fromJson(json.decode(str));

String liveStreamModelToJson(LiveStreamModel data) =>
    json.encode(data.toJson());

class LiveStreamModel {
  String streamId;
  String astrologerId;
  String astrologerName;
  String astrologerImage;
  String startedAt;
  String? url;
  bool? stream;

  LiveStreamModel({
    required this.streamId,
    required this.astrologerId,
    required this.astrologerName,
    required this.astrologerImage,
    required this.startedAt,
    this.url,
    this.stream,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) =>
      LiveStreamModel(
        streamId: json["streamId"],
        astrologerId: json["astrologerId"].toString(),
        astrologerName: json["astrologerName"],
        astrologerImage: json["astrologerImage"],
        startedAt: json["startedAt"],
        url: json["url"],
        stream: json["stream"],
      );

  Map<String, dynamic> toJson() => {
        "streamId": streamId,
        "astrologerId": astrologerId,
        "astrologerName": astrologerName,
        "astrologerImage": astrologerImage,
        "startedAt": startedAt,
        "url": url,
        "stream": stream,
      };
}
