import 'dart:convert';

//RashiFal Model
class RashiModel {
  String name;
  String discription;
  String image;

  RashiModel(
      {required this.name, required this.discription, required this.image});
}

//Monthly Rashi Model
List<RashiMonthlyModel> rashiMonthlyModelFromJson(String str) =>
    List<RashiMonthlyModel>.from(
        json.decode(str).map((x) => RashiMonthlyModel.fromJson(x)));
String rashiMonthlyModelToJson(List<RashiMonthlyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RashiMonthlyModel {
  String name;
  String description;
  String urlHref;
  String health;
  String financialCondition;
  String familyAndSocialLife;
  String loveLife;
  String educationAndCareer;

  RashiMonthlyModel({
    required this.name,
    required this.description,
    required this.urlHref,
    required this.health,
    required this.financialCondition,
    required this.familyAndSocialLife,
    required this.loveLife,
    required this.educationAndCareer,
  });

  factory RashiMonthlyModel.fromJson(Map<String, dynamic> json) =>
      RashiMonthlyModel(
        name: json["name"],
        description: json["description"],
        urlHref: json["urlHref"],
        health: json["health"],
        financialCondition: json["financialCondition"],
        familyAndSocialLife: json["familyAndSocialLife"],
        loveLife: json["loveLife"],
        educationAndCareer: json["educationAndCareer"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "urlHref": urlHref,
        "health": health,
        "financialCondition": financialCondition,
        "familyAndSocialLife": familyAndSocialLife,
        "loveLife": loveLife,
        "educationAndCareer": educationAndCareer,
      };
}

//Rashi Yearly Model
List<YearlyRashiModel> yearlyRashiModelFromJson(String str) =>
    List<YearlyRashiModel>.from(
        json.decode(str).map((x) => YearlyRashiModel.fromJson(x)));
String yearlyRashiModelToJson(List<YearlyRashiModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class YearlyRashiModel {
  String name;
  String description;
  String urlHref;
  String health;
  String financialCondition;
  String familyAndSocialLife;
  String loveLife;
  String educationAndCareer;

  YearlyRashiModel({
    required this.name,
    required this.description,
    required this.urlHref,
    required this.health,
    required this.financialCondition,
    required this.familyAndSocialLife,
    required this.loveLife,
    required this.educationAndCareer,
  });

  factory YearlyRashiModel.fromJson(Map<String, dynamic> json) =>
      YearlyRashiModel(
        name: json["name"],
        description: json["description"],
        urlHref: json["urlHref"],
        health: json["health"],
        financialCondition: json["financialCondition"],
        familyAndSocialLife: json["familyAndSocialLife"],
        loveLife: json["loveLife"],
        educationAndCareer: json["educationAndCareer"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "urlHref": urlHref,
        "health": health,
        "financialCondition": financialCondition,
        "familyAndSocialLife": familyAndSocialLife,
        "loveLife": loveLife,
        "educationAndCareer": educationAndCareer,
      };
}
