// To parse this JSON data, do
//
//     final dashakootDetailModel = dashakootDetailModelFromJson(jsonString);

import 'dart:convert';

DashakootDetailModel dashakootDetailModelFromJson(String str) =>
    DashakootDetailModel.fromJson(json.decode(str));

String dashakootDetailModelToJson(DashakootDetailModel data) =>
    json.encode(data.toJson());

class DashakootDetailModel {
  dynamic status;
  DashakootData dashakootData;

  DashakootDetailModel({
    required this.status,
    required this.dashakootData,
  });

  factory DashakootDetailModel.fromJson(Map<String, dynamic> json) =>
      DashakootDetailModel(
        status: json["status"],
        dashakootData: DashakootData.fromJson(json["dashakootData"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "dashakootData": dashakootData.toJson(),
      };
}

class DashakootData {
  Dina dina;
  Dina gana;
  Dina yoni;
  Dina rashi;
  Dina rasyadhipati;
  Dina rajju;
  Dina vedha;
  Dina vashya;
  Dina mahendra;
  Dina streeDeergha;
  Total total;

  DashakootData({
    required this.dina,
    required this.gana,
    required this.yoni,
    required this.rashi,
    required this.rasyadhipati,
    required this.rajju,
    required this.vedha,
    required this.vashya,
    required this.mahendra,
    required this.streeDeergha,
    required this.total,
  });

  factory DashakootData.fromJson(Map<String, dynamic> json) => DashakootData(
        dina: Dina.fromJson(json["dina"]),
        gana: Dina.fromJson(json["gana"]),
        yoni: Dina.fromJson(json["yoni"]),
        rashi: Dina.fromJson(json["rashi"]),
        rasyadhipati: Dina.fromJson(json["rasyadhipati"]),
        rajju: Dina.fromJson(json["rajju"]),
        vedha: Dina.fromJson(json["vedha"]),
        vashya: Dina.fromJson(json["vashya"]),
        mahendra: Dina.fromJson(json["mahendra"]),
        streeDeergha: Dina.fromJson(json["streeDeergha"]),
        total: Total.fromJson(json["total"]),
      );

  Map<String, dynamic> toJson() => {
        "dina": dina.toJson(),
        "gana": gana.toJson(),
        "yoni": yoni.toJson(),
        "rashi": rashi.toJson(),
        "rasyadhipati": rasyadhipati.toJson(),
        "rajju": rajju.toJson(),
        "vedha": vedha.toJson(),
        "vashya": vashya.toJson(),
        "mahendra": mahendra.toJson(),
        "streeDeergha": streeDeergha.toJson(),
        "total": total.toJson(),
      };
}

class Dina {
  String description;
  String maleKootAttribute;
  String femaleKootAttribute;
  dynamic totalPoints;
  dynamic receivedPoints;

  Dina({
    required this.description,
    required this.maleKootAttribute,
    required this.femaleKootAttribute,
    required this.totalPoints,
    required this.receivedPoints,
  });

  factory Dina.fromJson(Map<String, dynamic> json) => Dina(
        description: json["description"],
        maleKootAttribute: json["male_koot_attribute"],
        femaleKootAttribute: json["female_koot_attribute"],
        totalPoints: json["total_points"],
        receivedPoints: json["received_points"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "male_koot_attribute": maleKootAttribute,
        "female_koot_attribute": femaleKootAttribute,
        "total_points": totalPoints,
        "received_points": receivedPoints,
      };
}

class Total {
  dynamic totalPoints;
  dynamic receivedPoints;
  dynamic minimumRequired;

  Total({
    required this.totalPoints,
    required this.receivedPoints,
    required this.minimumRequired,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        totalPoints: json["total_points"],
        receivedPoints: json["received_points"],
        minimumRequired: json["minimum_required"],
      );

  Map<String, dynamic> toJson() => {
        "total_points": totalPoints,
        "received_points": receivedPoints,
        "minimum_required": minimumRequired,
      };
}
