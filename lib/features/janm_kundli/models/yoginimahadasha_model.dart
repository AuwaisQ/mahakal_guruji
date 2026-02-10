// To parse this JSON data, do
//
//     final yoginiMahaModel = yoginiMahaModelFromJson(jsonString);

import 'dart:convert';

List<YoginiMahaModel> yoginiMahaModelFromJson(String str) =>
    List<YoginiMahaModel>.from(
        json.decode(str).map((x) => YoginiMahaModel.fromJson(x)));

String yoginiMahaModelToJson(List<YoginiMahaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class YoginiMahaModel {
  int dashaId;
  String dashaName;
  String startDate;
  String endDate;
  int startMs;
  int endMs;
  int duration;

  YoginiMahaModel({
    required this.dashaId,
    required this.dashaName,
    required this.startDate,
    required this.endDate,
    required this.startMs,
    required this.endMs,
    required this.duration,
  });

  factory YoginiMahaModel.fromJson(Map<String, dynamic> json) =>
      YoginiMahaModel(
        dashaId: json["dasha_id"],
        dashaName: json["dasha_name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        startMs: json["start_ms"],
        endMs: json["end_ms"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "dasha_id": dashaId,
        "dasha_name": dashaName,
        "start_date": startDate,
        "end_date": endDate,
        "start_ms": startMs,
        "end_ms": endMs,
        "duration": duration,
      };
}
