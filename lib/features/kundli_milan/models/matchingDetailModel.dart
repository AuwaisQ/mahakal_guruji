// To parse this JSON data, do
//
//     final matchingDetailModel = matchingDetailModelFromJson(jsonString);

import 'dart:convert';

MatchingDetailModel matchingDetailModelFromJson(String str) =>
    MatchingDetailModel.fromJson(json.decode(str));

String matchingDetailModelToJson(MatchingDetailModel data) =>
    json.encode(data.toJson());

class MatchingDetailModel {
  int status;
  MatchData matchData;

  MatchingDetailModel({
    required this.status,
    required this.matchData,
  });

  factory MatchingDetailModel.fromJson(Map<String, dynamic> json) =>
      MatchingDetailModel(
        status: json["status"],
        matchData: MatchData.fromJson(json["matchData"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "matchData": matchData.toJson(),
      };
}

class MatchData {
  Ashtakoota ashtakoota;
  Manglik manglik;
  Dosha rajjuDosha;
  Dosha vedhaDosha;
  Conclusion conclusion;

  MatchData({
    required this.ashtakoota,
    required this.manglik,
    required this.rajjuDosha,
    required this.vedhaDosha,
    required this.conclusion,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
        ashtakoota: Ashtakoota.fromJson(json["ashtakoota"]),
        manglik: Manglik.fromJson(json["manglik"]),
        rajjuDosha: Dosha.fromJson(json["rajju_dosha"]),
        vedhaDosha: Dosha.fromJson(json["vedha_dosha"]),
        conclusion: Conclusion.fromJson(json["conclusion"]),
      );

  Map<String, dynamic> toJson() => {
        "ashtakoota": ashtakoota.toJson(),
        "manglik": manglik.toJson(),
        "rajju_dosha": rajjuDosha.toJson(),
        "vedha_dosha": vedhaDosha.toJson(),
        "conclusion": conclusion.toJson(),
      };
}

class Ashtakoota {
  bool status;
  double receivedPoints;

  Ashtakoota({
    required this.status,
    required this.receivedPoints,
  });

  factory Ashtakoota.fromJson(Map<String, dynamic> json) => Ashtakoota(
        status: json["status"],
        receivedPoints: json["received_points"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "received_points": receivedPoints,
      };
}

class Conclusion {
  String matchReport;

  Conclusion({
    required this.matchReport,
  });

  factory Conclusion.fromJson(Map<String, dynamic> json) => Conclusion(
        matchReport: json["match_report"],
      );

  Map<String, dynamic> toJson() => {
        "match_report": matchReport,
      };
}

class Manglik {
  bool status;
  double malePercentage;
  double femalePercentage;

  Manglik({
    required this.status,
    required this.malePercentage,
    required this.femalePercentage,
  });

  factory Manglik.fromJson(Map<String, dynamic> json) => Manglik(
        status: json["status"],
        malePercentage: json["male_percentage"]?.toDouble(),
        femalePercentage: json["female_percentage"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "male_percentage": malePercentage,
        "female_percentage": femalePercentage,
      };
}

class Dosha {
  bool status;

  Dosha({
    required this.status,
  });

  factory Dosha.fromJson(Map<String, dynamic> json) => Dosha(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
