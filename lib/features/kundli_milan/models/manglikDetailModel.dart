// To parse this JSON data, do
//
//     final manglikDetailModel = manglikDetailModelFromJson(jsonString);

import 'dart:convert';

ManglikDetailModel manglikDetailModelFromJson(String str) =>
    ManglikDetailModel.fromJson(json.decode(str));

String manglikDetailModelToJson(ManglikDetailModel data) =>
    json.encode(data.toJson());

class ManglikDetailModel {
  int status;
  ManglikData manglikData;

  ManglikDetailModel({
    required this.status,
    required this.manglikData,
  });

  factory ManglikDetailModel.fromJson(Map<String, dynamic> json) =>
      ManglikDetailModel(
        status: json["status"],
        manglikData: ManglikData.fromJson(json["manglikData"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "manglikData": manglikData.toJson(),
      };
}

class ManglikData {
  Male male;
  Male female;
  Conclusion conclusion;

  ManglikData({
    required this.male,
    required this.female,
    required this.conclusion,
  });

  factory ManglikData.fromJson(Map<String, dynamic> json) => ManglikData(
        male: Male.fromJson(json["male"]),
        female: Male.fromJson(json["female"]),
        conclusion: Conclusion.fromJson(json["conclusion"]),
      );

  Map<String, dynamic> toJson() => {
        "male": male.toJson(),
        "female": female.toJson(),
        "conclusion": conclusion.toJson(),
      };
}

class Conclusion {
  bool match;
  String report;

  Conclusion({
    required this.match,
    required this.report,
  });

  factory Conclusion.fromJson(Map<String, dynamic> json) => Conclusion(
        match: json["match"],
        report: json["report"],
      );

  Map<String, dynamic> toJson() => {
        "match": match,
        "report": report,
      };
}

class Male {
  ManglikPresentRule manglikPresentRule;
  List<dynamic> manglikCancelRule;
  bool isMarsManglikCancelled;
  String manglikStatus;
  double percentageManglikPresent;
  double percentageManglikAfterCancellation;
  String manglikReport;
  bool isPresent;

  Male({
    required this.manglikPresentRule,
    required this.manglikCancelRule,
    required this.isMarsManglikCancelled,
    required this.manglikStatus,
    required this.percentageManglikPresent,
    required this.percentageManglikAfterCancellation,
    required this.manglikReport,
    required this.isPresent,
  });

  factory Male.fromJson(Map<String, dynamic> json) => Male(
        manglikPresentRule:
            ManglikPresentRule.fromJson(json["manglik_present_rule"]),
        manglikCancelRule:
            List<dynamic>.from(json["manglik_cancel_rule"].map((x) => x)),
        isMarsManglikCancelled: json["is_mars_manglik_cancelled"],
        manglikStatus: json["manglik_status"],
        percentageManglikPresent:
            json["percentage_manglik_present"]?.toDouble(),
        percentageManglikAfterCancellation:
            json["percentage_manglik_after_cancellation"]?.toDouble(),
        manglikReport: json["manglik_report"],
        isPresent: json["is_present"],
      );

  Map<String, dynamic> toJson() => {
        "manglik_present_rule": manglikPresentRule.toJson(),
        "manglik_cancel_rule":
            List<dynamic>.from(manglikCancelRule.map((x) => x)),
        "is_mars_manglik_cancelled": isMarsManglikCancelled,
        "manglik_status": manglikStatus,
        "percentage_manglik_present": percentageManglikPresent,
        "percentage_manglik_after_cancellation":
            percentageManglikAfterCancellation,
        "manglik_report": manglikReport,
        "is_present": isPresent,
      };
}

class ManglikPresentRule {
  List<String> basedOnAspect;
  List<String> basedOnHouse;

  ManglikPresentRule({
    required this.basedOnAspect,
    required this.basedOnHouse,
  });

  factory ManglikPresentRule.fromJson(Map<String, dynamic> json) =>
      ManglikPresentRule(
        basedOnAspect: List<String>.from(json["based_on_aspect"].map((x) => x)),
        basedOnHouse: List<String>.from(json["based_on_house"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "based_on_aspect": List<dynamic>.from(basedOnAspect.map((x) => x)),
        "based_on_house": List<dynamic>.from(basedOnHouse.map((x) => x)),
      };
}
