import 'dart:convert';

DoshModel doshModelFromJson(String str) => DoshModel.fromJson(json.decode(str));

String doshModelToJson(DoshModel data) => json.encode(data.toJson());

class DoshModel {
  int? status;
  MangalDosh? mangalDosh;
  KalsarpDosha? kalsarpDosha;
  PitraDosh? pitraDosh;
  SadhesatiShani? sadhesatiShani;

  DoshModel({
    this.status,
    this.mangalDosh,
    this.kalsarpDosha,
    this.pitraDosh,
    this.sadhesatiShani,
  });

  factory DoshModel.fromJson(Map<String, dynamic> json) => DoshModel(
        status: json["status"] as int?,
        mangalDosh: json["mangalDosh"] != null
            ? MangalDosh.fromJson(json["mangalDosh"])
            : null,
        kalsarpDosha: json["kalsarpDosha"] != null
            ? KalsarpDosha.fromJson(json["kalsarpDosha"])
            : null,
        pitraDosh: json["pitraDosh"] != null
            ? PitraDosh.fromJson(json["pitraDosh"])
            : null,
        sadhesatiShani: json["sadhesatiShani"] != null
            ? SadhesatiShani.fromJson(json["sadhesatiShani"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "mangalDosh": mangalDosh?.toJson(),
        "kalsarpDosha": kalsarpDosha?.toJson(),
        "pitraDosh": pitraDosh?.toJson(),
        "sadhesatiShani": sadhesatiShani,
      };
}

class KalsarpDosha {
  bool? present;
  String? type;
  String? oneLine;
  String? name;
  Report? report;

  KalsarpDosha({
    this.present,
    this.type,
    this.oneLine,
    this.name,
    this.report,
  });

  factory KalsarpDosha.fromJson(Map<String, dynamic> json) => KalsarpDosha(
        present: json["present"] as bool?,
        type: json["type"] as String?,
        oneLine: json["one_line"] as String?,
        name: json["name"] as String?,
        report: json["report"] != null ? Report.fromJson(json["report"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "present": present,
        "type": type,
        "one_line": oneLine,
        "name": name,
        "report": report?.toJson(),
      };
}

class Report {
  int? houseId;
  String? report;

  Report({
    this.houseId,
    this.report,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        houseId: json["house_id"] as int?,
        report: json["report"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "house_id": houseId,
        "report": report,
      };
}

class MangalDosh {
  ManglikPresentRule? manglikPresentRule;
  List<dynamic>? manglikCancelRule;
  bool? isMarsManglikCancelled;
  String? manglikStatus;
  double? percentageManglikPresent;
  double? percentageManglikAfterCancellation;
  String? manglikReport;
  bool? isPresent;

  MangalDosh({
    this.manglikPresentRule,
    this.manglikCancelRule,
    this.isMarsManglikCancelled,
    this.manglikStatus,
    this.percentageManglikPresent,
    this.percentageManglikAfterCancellation,
    this.manglikReport,
    this.isPresent,
  });

  factory MangalDosh.fromJson(Map<String, dynamic> json) => MangalDosh(
        manglikPresentRule: json["manglik_present_rule"] != null
            ? ManglikPresentRule.fromJson(json["manglik_present_rule"])
            : null,
        manglikCancelRule: json["manglik_cancel_rule"] != null
            ? List<dynamic>.from(json["manglik_cancel_rule"])
            : [],
        isMarsManglikCancelled: json["is_mars_manglik_cancelled"] as bool?,
        manglikStatus: json["manglik_status"] as String?,
        percentageManglikPresent:
            (json["percentage_manglik_present"] as num?)?.toDouble(),
        percentageManglikAfterCancellation:
            (json["percentage_manglik_after_cancellation"] as num?)?.toDouble(),
        manglikReport: json["manglik_report"] as String?,
        isPresent: json["is_present"] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "manglik_present_rule": manglikPresentRule?.toJson(),
        "manglik_cancel_rule": List<dynamic>.from(manglikCancelRule ?? []),
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
  List<String>? basedOnAspect;
  List<String>? basedOnHouse;

  ManglikPresentRule({
    this.basedOnAspect,
    this.basedOnHouse,
  });

  factory ManglikPresentRule.fromJson(Map<String, dynamic> json) =>
      ManglikPresentRule(
        basedOnAspect: json["based_on_aspect"] != null
            ? List<String>.from(json["based_on_aspect"])
            : [],
        basedOnHouse: json["based_on_house"] != null
            ? List<String>.from(json["based_on_house"])
            : [],
      );

  Map<String, dynamic> toJson() => {
        "based_on_aspect": basedOnAspect,
        "based_on_house": basedOnHouse,
      };
}

class PitraDosh {
  String? whatIsPitriDosha;
  bool? isPitriDoshaPresent;
  List<String>? rulesMatched;
  String? conclusion;
  List<String>? remedies;
  List<String>? effects;

  PitraDosh({
    this.whatIsPitriDosha,
    this.isPitriDoshaPresent,
    this.rulesMatched,
    this.conclusion,
    this.remedies,
    this.effects,
  });

  factory PitraDosh.fromJson(Map<String, dynamic> json) => PitraDosh(
        whatIsPitriDosha: json["what_is_pitri_dosha"] as String?,
        isPitriDoshaPresent: json["is_pitri_dosha_present"] as bool?,
        rulesMatched: json["rules_matched"] != null
            ? List<String>.from(json["rules_matched"])
            : [],
        conclusion: json["conclusion"] as String?,
        remedies:
            json["remedies"] != null ? List<String>.from(json["remedies"]) : [],
        effects:
            json["effects"] != null ? List<String>.from(json["effects"]) : [],
      );

  Map<String, dynamic> toJson() => {
        "what_is_pitri_dosha": whatIsPitriDosha,
        "is_pitri_dosha_present": isPitriDoshaPresent,
        "rules_matched": rulesMatched,
        "conclusion": conclusion,
        "remedies": remedies,
        "effects": effects,
      };
}

class SadhesatiShani {
  String? considerationDate;
  bool? isSaturnRetrograde;
  String? moonSign;
  String? saturnSign;
  String? isUndergoingSadhesati;
  String? sadhesatiPhase;
  bool? sadhesatiStatus;
  String? startDate;
  String? endDate;
  String? whatIsSadhesati;

  SadhesatiShani({
    this.considerationDate,
    this.isSaturnRetrograde,
    this.moonSign,
    this.saturnSign,
    this.isUndergoingSadhesati,
    this.sadhesatiPhase,
    this.sadhesatiStatus,
    this.startDate,
    this.endDate,
    this.whatIsSadhesati,
  });

  factory SadhesatiShani.fromJson(Map<String, dynamic> json) => SadhesatiShani(
        considerationDate: json["consideration_date"] as String?,
        isSaturnRetrograde: json["is_saturn_retrograde"] as bool?,
        moonSign: json["moon_sign"] as String?,
        saturnSign: json["saturn_sign"] as String?,
        isUndergoingSadhesati: json["is_undergoing_sadhesati"] as String?,
        sadhesatiPhase: json["sadhesati_phase"] as String?,
        sadhesatiStatus: json["sadhesati_status"] as bool?,
        startDate: json["start_date"] as String?,
        endDate: json["end_date"] as String?,
        whatIsSadhesati: json["what_is_sadhesati"] as String?,
      );
}
