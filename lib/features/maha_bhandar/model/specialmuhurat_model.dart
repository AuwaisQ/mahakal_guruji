// To parse this JSON data, do
//
//     final specialMuhuratModel = specialMuhuratModelFromJson(jsonString);

import 'dart:convert';

SpecialMuhuratModel specialMuhuratModelFromJson(String str) =>
    SpecialMuhuratModel.fromJson(json.decode(str));

String specialMuhuratModelToJson(SpecialMuhuratModel data) =>
    json.encode(data.toJson());

class SpecialMuhuratModel {
  bool status;
  List<Specialmuhurat> specialmuhurat;

  SpecialMuhuratModel({
    required this.status,
    required this.specialmuhurat,
  });

  factory SpecialMuhuratModel.fromJson(Map<String, dynamic> json) =>
      SpecialMuhuratModel(
        status: json["status"],
        specialmuhurat: List<Specialmuhurat>.from(
            json["specialmuhurat"].map((x) => Specialmuhurat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "specialmuhurat":
            List<dynamic>.from(specialmuhurat.map((x) => x.toJson())),
      };
}

class Specialmuhurat {
  String year;
  String type;
  String titleLink;
  String message;
  String image;
  String muhurat;
  String nakshatra;
  String tithi;

  Specialmuhurat({
    required this.year,
    required this.type,
    required this.titleLink,
    required this.message,
    required this.image,
    required this.muhurat,
    required this.nakshatra,
    required this.tithi,
  });

  factory Specialmuhurat.fromJson(Map<String, dynamic> json) => Specialmuhurat(
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
