// To parse this JSON data, do
//
//     final festivalEvents = festivalEventsFromJson(jsonString);

import 'dart:convert';

List<FestivalEvents> festivalEventsFromJson(String str) =>
    List<FestivalEvents>.from(
        json.decode(str).map((x) => FestivalEvents.fromJson(x)));

String festivalEventsToJson(List<FestivalEvents> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FestivalEvents {
  String eventName;
  String eventDate;
  List<String> eventContents;
  String eventType;
  String enDescription;
  String hiDescription;
  String image;

  FestivalEvents({
    required this.eventName,
    required this.eventDate,
    required this.eventContents,
    required this.eventType,
    required this.enDescription,
    required this.hiDescription,
    required this.image,
  });

  factory FestivalEvents.fromJson(Map<String, dynamic> json) => FestivalEvents(
        eventName: json["eventName"],
        eventDate: json["eventDate"],
        eventContents: List<String>.from(json["eventContents"].map((x) => x)),
        eventType: json["eventType"],
        enDescription: json["en_description"],
        hiDescription: json["hi_description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "eventName": eventName,
        "eventDate": eventDate,
        "eventContents": List<dynamic>.from(eventContents.map((x) => x)),
        "eventType": eventType,
        "en_description": enDescription,
        "hi_description": hiDescription,
        "image": image,
      };
}
