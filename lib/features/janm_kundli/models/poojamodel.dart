// To parse this JSON data, do
//
//     final poojasuggestionModel = poojasuggestionModelFromJson(jsonString);

import 'dart:convert';

List<PoojasuggestionModel> poojasuggestionModelFromJson(String str) =>
    List<PoojasuggestionModel>.from(
        json.decode(str).map((x) => PoojasuggestionModel.fromJson(x)));

String poojasuggestionModelToJson(List<PoojasuggestionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PoojasuggestionModel {
  bool status;
  int priority;
  String title;
  String pujaId;
  String summary;
  String oneLine;

  PoojasuggestionModel({
    required this.status,
    required this.priority,
    required this.title,
    required this.pujaId,
    required this.summary,
    required this.oneLine,
  });

  factory PoojasuggestionModel.fromJson(Map<String, dynamic> json) =>
      PoojasuggestionModel(
        status: json["status"],
        priority: json["priority"],
        title: json["title"],
        pujaId: json["puja_id"],
        summary: json["summary"],
        oneLine: json["one_line"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "priority": priority,
        "title": title,
        "puja_id": pujaId,
        "summary": summary,
        "one_line": oneLine,
      };
}
