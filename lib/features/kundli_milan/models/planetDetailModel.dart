// To parse this JSON data, do
//
//     final planetDetailModel = planetDetailModelFromJson(jsonString);

import 'dart:convert';

PlanetDetailModel planetDetailModelFromJson(String str) =>
    PlanetDetailModel.fromJson(json.decode(str));

String planetDetailModelToJson(PlanetDetailModel data) =>
    json.encode(data.toJson());

class PlanetDetailModel {
  int status;
  PlanetData planetData;

  PlanetDetailModel({
    required this.status,
    required this.planetData,
  });

  factory PlanetDetailModel.fromJson(Map<String, dynamic> json) =>
      PlanetDetailModel(
        status: json["status"],
        planetData: PlanetData.fromJson(json["planetData"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "planetData": planetData.toJson(),
      };
}

class PlanetData {
  List<MalePlanetDetail> malePlanetDetails;
  List<MalePlanetDetail> femalePlanetDetails;

  PlanetData({
    required this.malePlanetDetails,
    required this.femalePlanetDetails,
  });

  factory PlanetData.fromJson(Map<String, dynamic> json) => PlanetData(
        malePlanetDetails: List<MalePlanetDetail>.from(
            json["male_planet_details"]
                .map((x) => MalePlanetDetail.fromJson(x))),
        femalePlanetDetails: List<MalePlanetDetail>.from(
            json["female_planet_details"]
                .map((x) => MalePlanetDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "male_planet_details":
            List<dynamic>.from(malePlanetDetails.map((x) => x.toJson())),
        "female_planet_details":
            List<dynamic>.from(femalePlanetDetails.map((x) => x.toJson())),
      };
}

class MalePlanetDetail {
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
  bool isPlanetSet;
  String planetAwastha;

  MalePlanetDetail({
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
    required this.isPlanetSet,
    required this.planetAwastha,
  });

  factory MalePlanetDetail.fromJson(Map<String, dynamic> json) =>
      MalePlanetDetail(
        id: json["id"],
        name: json["name"],
        fullDegree: json["fullDegree"]?.toDouble(),
        normDegree: json["normDegree"]?.toDouble(),
        speed: json["speed"]?.toDouble(),
        isRetro: json["isRetro"],
        sign: json["sign"],
        signLord: json["signLord"],
        nakshatra: json["nakshatra"],
        nakshatraLord: json["nakshatraLord"],
        nakshatraPad: json["nakshatra_pad"],
        house: json["house"],
        isPlanetSet: json["is_planet_set"],
        planetAwastha: json["planet_awastha"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fullDegree": fullDegree,
        "normDegree": normDegree,
        "speed": speed,
        "isRetro": isRetro,
        "sign": sign,
        "signLord": signLord,
        "nakshatra": nakshatra,
        "nakshatraLord": nakshatraLord,
        "nakshatra_pad": nakshatraPad,
        "house": house,
        "is_planet_set": isPlanetSet,
        "planet_awastha": planetAwastha,
      };
}
