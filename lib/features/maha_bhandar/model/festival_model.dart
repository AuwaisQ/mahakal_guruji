// To parse this JSON data, do
//
//     final festivalModel = festivalModelFromJson(jsonString);

import 'dart:convert';

List<FestivalModel> festivalModelFromJson(String str) =>
    List<FestivalModel>.from(
        json.decode(str).map((x) => FestivalModel.fromJson(x)));

String festivalModelToJson(List<FestivalModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FestivalModel {
  String eventName;
  String eventDate;
  List<String> eventContents;
  String eventType;
  String enDescription;
  String hiDescription;
  String image;
  String eventNameHi;

  FestivalModel({
    required this.eventName,
    required this.eventDate,
    required this.eventContents,
    required this.eventType,
    required this.enDescription,
    required this.hiDescription,
    required this.image,
    required this.eventNameHi,
  });

  factory FestivalModel.fromJson(Map<String, dynamic> json) => FestivalModel(
        eventName: json["eventName"] ?? "",
        eventDate: json["eventDate"] ?? "",
        eventContents: json["eventContents"] == null
            ? []
            : List<String>.from(json["eventContents"].map((x) => x)),
        eventType: json["eventType"] ?? "",
        enDescription: json["en_description"] ?? "",
        hiDescription: json["hi_description"] ?? "",
        image: json["image"] ?? "",
        eventNameHi: json["event_name_hi"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "eventName": eventName,
        "eventDate": eventDate,
        "eventContents": List<dynamic>.from(eventContents.map((x) => x)),
        "eventType": eventType,
        "en_description": enDescription,
        "hi_description": hiDescription,
        "image": image,
        "event_name_hi": eventNameHi,
      };
}
