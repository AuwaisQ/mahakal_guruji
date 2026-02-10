// To parse this JSON data, do
//
//     final grahModel = grahModelFromJson(jsonString);

import 'dart:convert';

GrahModel grahModelFromJson(String str) => GrahModel.fromJson(json.decode(str));

String grahModelToJson(GrahModel data) => json.encode(data.toJson());

class GrahModel {
  int status;
  List<Planate> planate;
  List<PlanateImage> planateImages;

  GrahModel({
    required this.status,
    required this.planate,
    required this.planateImages,
  });

  factory GrahModel.fromJson(Map<String, dynamic> json) => GrahModel(
        status: json["status"],
        planate:
            List<Planate>.from(json["planate"].map((x) => Planate.fromJson(x))),
        planateImages: List<PlanateImage>.from(
            json["planate_images"].map((x) => PlanateImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "planate": List<dynamic>.from(planate.map((x) => x.toJson())),
        "planate_images":
            List<dynamic>.from(planateImages.map((x) => x.toJson())),
      };
}

class Planate {
  int id;
  String name;
  double fullDegree;
  double normDegree;
  double speed;
  dynamic isRetro;
  String sign;
  String signLord;
  String nakshatra;
  String nakshatraLord;
  int nakshatraPad;
  int house;

  Planate({
    required this.id,
    required this.name,
    required this.fullDegree,
    required this.normDegree,
    required this.speed,
    required this.isRetro,
    required this.sign,
    required this.signLord,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.nakshatraPad,
    required this.house,
  });

  factory Planate.fromJson(Map<String, dynamic> json) => Planate(
        id: json["id"],
        name: json["name"],
        fullDegree: json["fullDegree"]?.toDouble(),
        normDegree: json["normDegree"]?.toDouble(),
        speed: json["speed"]?.toDouble(),
        isRetro: json["isRetro"],
        sign: json["sign"],
        signLord: json["sign_lord"],
        nakshatra: json["nakshatra"],
        nakshatraLord: json["nakshatra_lord"],
        nakshatraPad: json["nakshatra_pad"],
        house: json["house"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fullDegree": fullDegree,
        "normDegree": normDegree,
        "speed": speed,
        "isRetro": isRetro,
        "sign": sign,
        "sign_lord": signLord,
        "nakshatra": nakshatra,
        "nakshatra_lord": nakshatraLord,
        "nakshatra_pad": nakshatraPad,
        "house": house,
      };
}

class PlanateImage {
  String name;
  String image;

  PlanateImage({
    required this.name,
    required this.image,
  });

  factory PlanateImage.fromJson(Map<String, dynamic> json) => PlanateImage(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
