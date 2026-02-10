// To parse this JSON data, do
//
//     final shubhMuhuratModel = shubhMuhuratModelFromJson(jsonString);

import 'dart:convert';

ShubhMuhuratModel shubhMuhuratModelFromJson(String str) =>
    ShubhMuhuratModel.fromJson(json.decode(str));

String shubhMuhuratModelToJson(ShubhMuhuratModel data) =>
    json.encode(data.toJson());

class ShubhMuhuratModel {
  bool status;
  List<Muhurat> muhurat;

  ShubhMuhuratModel({
    required this.status,
    required this.muhurat,
  });

  factory ShubhMuhuratModel.fromJson(Map<String, dynamic> json) =>
      ShubhMuhuratModel(
        status: json["status"],
        muhurat:
            List<Muhurat>.from(json["muhurat"].map((x) => Muhurat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "muhurat": List<dynamic>.from(muhurat.map((x) => x.toJson())),
      };
}

class Muhurat {
  dynamic year;
  String type;
  String titleLink;
  String message;
  String muhurat;
  String nakshatra;
  String tithi;

  Muhurat({
    required this.year,
    required this.type,
    required this.titleLink,
    required this.message,
    required this.muhurat,
    required this.nakshatra,
    required this.tithi,
  });

  factory Muhurat.fromJson(Map<String, dynamic> json) => Muhurat(
        year: json["year"],
        type: json["type"],
        titleLink: json["titleLink"],
        message: json["message"],
        muhurat: json["muhurat"],
        nakshatra: json["nakshatra"],
        tithi: json["tithi"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "type": type,
        "titleLink": titleLink,
        "message": message,
        "muhurat": muhurat,
        "nakshatra": nakshatra,
        "tithi": tithi,
      };
}
