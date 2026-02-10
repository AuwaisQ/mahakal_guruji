// To parse this JSON data, do
//
//     final suggestionModel = suggestionModelFromJson(jsonString);

import 'dart:convert';

SuggestionModel suggestionModelFromJson(String str) =>
    SuggestionModel.fromJson(json.decode(str));

String suggestionModelToJson(SuggestionModel data) =>
    json.encode(data.toJson());

class SuggestionModel {
  int status;
  RudrakshaSuggestion rudrakshaSuggestion;
  GemStone gemStone;
  PoojaSuggestion poojaSuggestion;

  SuggestionModel({
    required this.status,
    required this.rudrakshaSuggestion,
    required this.gemStone,
    required this.poojaSuggestion,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      SuggestionModel(
        status: json["status"],
        rudrakshaSuggestion:
            RudrakshaSuggestion.fromJson(json["rudrakshaSuggestion"]),
        gemStone: GemStone.fromJson(json["gemStone"]),
        poojaSuggestion: PoojaSuggestion.fromJson(json["poojaSuggestion"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "rudrakshaSuggestion": rudrakshaSuggestion.toJson(),
        "gemStone": gemStone.toJson(),
        "poojaSuggestion": poojaSuggestion.toJson(),
      };
}

class GemStone {
  Benefic life;
  Benefic benefic;
  Benefic lucky;

  GemStone({
    required this.life,
    required this.benefic,
    required this.lucky,
  });

  factory GemStone.fromJson(Map<String, dynamic> json) => GemStone(
        life: Benefic.fromJson(json["LIFE"]),
        benefic: Benefic.fromJson(json["BENEFIC"]),
        lucky: Benefic.fromJson(json["LUCKY"]),
      );

  Map<String, dynamic> toJson() => {
        "LIFE": life.toJson(),
        "BENEFIC": benefic.toJson(),
        "LUCKY": lucky.toJson(),
      };
}

class Benefic {
  String name;
  String gemKey;
  String semiGem;
  String wearFinger;
  String weightCaret;
  String wearMetal;
  String wearDay;
  String gemDeity;

  Benefic({
    required this.name,
    required this.gemKey,
    required this.semiGem,
    required this.wearFinger,
    required this.weightCaret,
    required this.wearMetal,
    required this.wearDay,
    required this.gemDeity,
  });

  factory Benefic.fromJson(Map<String, dynamic> json) => Benefic(
        name: json["name"],
        gemKey: json["gem_key"],
        semiGem: json["semi_gem"],
        wearFinger: json["wear_finger"],
        weightCaret: json["weight_caret"],
        wearMetal: json["wear_metal"],
        wearDay: json["wear_day"],
        gemDeity: json["gem_deity"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "gem_key": gemKey,
        "semi_gem": semiGem,
        "wear_finger": wearFinger,
        "weight_caret": weightCaret,
        "wear_metal": wearMetal,
        "wear_day": wearDay,
        "gem_deity": gemDeity,
      };
}

class PoojaSuggestion {
  String summary;
  List<Suggestion> suggestions;

  PoojaSuggestion({
    required this.summary,
    required this.suggestions,
  });

  factory PoojaSuggestion.fromJson(Map<String, dynamic> json) =>
      PoojaSuggestion(
        summary: json["summary"],
        suggestions: List<Suggestion>.from(
            json["suggestions"].map((x) => Suggestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "summary": summary,
        "suggestions": List<dynamic>.from(suggestions.map((x) => x.toJson())),
      };
}

class Suggestion {
  bool status;
  int priority;
  String title;
  String pujaId;
  String summary;
  String oneLine;

  Suggestion({
    required this.status,
    required this.priority,
    required this.title,
    required this.pujaId,
    required this.summary,
    required this.oneLine,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        status: json["status"],
        priority: json["priority"],
        title: json["title"],
        pujaId: json["puja_id"],
        summary: json["summary"],
        oneLine: json["one_line"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "priority": priority,
        "title": title,
        "puja_id": pujaId,
        "summary": summary,
        "one_line": oneLine,
      };
}

class RudrakshaSuggestion {
  String imgUrl;
  String rudrakshaKey;
  String name;
  String recommend;
  String detail;

  RudrakshaSuggestion({
    required this.imgUrl,
    required this.rudrakshaKey,
    required this.name,
    required this.recommend,
    required this.detail,
  });

  factory RudrakshaSuggestion.fromJson(Map<String, dynamic> json) =>
      RudrakshaSuggestion(
        imgUrl: json["img_url"],
        rudrakshaKey: json["rudraksha_key"],
        name: json["name"],
        recommend: json["recommend"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "img_url": imgUrl,
        "rudraksha_key": rudrakshaKey,
        "name": name,
        "recommend": recommend,
        "detail": detail,
      };
}
