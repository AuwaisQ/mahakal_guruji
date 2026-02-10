// To parse this JSON data, do
//
//     final shubhMuhratModel = shubhMuhratModelFromJson(jsonString);

import 'dart:convert';

List<ShubhMuhratModel> shubhMuhratModelFromJson(String str) =>
    List<ShubhMuhratModel>.from(
        json.decode(str).map((x) => ShubhMuhratModel.fromJson(x)));

String shubhMuhratModelToJson(List<ShubhMuhratModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShubhMuhratModel {
  dynamic year;
  String? type;
  String? titleLink;
  String? message;
  String? image;
  String? muhurat;
  String? nakshatra;
  String? tithi;

  ShubhMuhratModel({
    this.year,
    this.type,
    this.titleLink,
    this.message,
    this.image,
    this.muhurat,
    this.nakshatra,
    this.tithi,
  });

  factory ShubhMuhratModel.fromJson(Map<String, dynamic> json) =>
      ShubhMuhratModel(
        year: json["year"],
        type: json["type"],
        titleLink: json["titleLink"],
        message: json["message"],
        image: json["image"],
        muhurat: json["muhurat"],
        nakshatra: json["nakshatra"],
        tithi: json["tithi"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "type": type,
        "titleLink": titleLink,
        "message": message,
        "image": image,
        "muhurat": muhurat,
        "nakshatra": nakshatra,
        "tithi": tithi,
      };
}
