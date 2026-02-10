// To parse this JSON data, do
//
//     final vimshotriDashaModel = vimshotriDashaModelFromJson(jsonString);

import 'dart:convert';

VimshotriDashaModel vimshotriDashaModelFromJson(String str) =>
    VimshotriDashaModel.fromJson(json.decode(str));

String vimshotriDashaModelToJson(VimshotriDashaModel data) =>
    json.encode(data.toJson());

class VimshotriDashaModel {
  int status;
  VimshottariDasha vimshottariDasha;
  YoginiDasha yoginiDasha;
  List<MahaVimshottari> mahaVimshottari;
  List<MajorYoginiDasha> majorYoginiDasha;

  VimshotriDashaModel({
    required this.status,
    required this.vimshottariDasha,
    required this.yoginiDasha,
    required this.mahaVimshottari,
    required this.majorYoginiDasha,
  });

  factory VimshotriDashaModel.fromJson(Map<String, dynamic> json) =>
      VimshotriDashaModel(
        status: json["status"],
        vimshottariDasha: VimshottariDasha.fromJson(json["vimshottariDasha"]),
        yoginiDasha: YoginiDasha.fromJson(json["yoginiDasha"]),
        mahaVimshottari: List<MahaVimshottari>.from(
            json["mahaVimshottari"].map((x) => MahaVimshottari.fromJson(x))),
        majorYoginiDasha: List<MajorYoginiDasha>.from(
            json["majorYoginiDasha"].map((x) => MajorYoginiDasha.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "vimshottariDasha": vimshottariDasha.toJson(),
        "yoginiDasha": yoginiDasha.toJson(),
        "mahaVimshottari":
            List<dynamic>.from(mahaVimshottari.map((x) => x.toJson())),
        "majorYoginiDasha":
            List<dynamic>.from(majorYoginiDasha.map((x) => x.toJson())),
      };
}

class MahaVimshottari {
  String planet;
  int? planetId;
  String start;
  String end;

  MahaVimshottari({
    required this.planet,
    this.planetId,
    required this.start,
    required this.end,
  });

  factory MahaVimshottari.fromJson(Map<String, dynamic> json) =>
      MahaVimshottari(
        planet: json["planet"],
        planetId: json["planet_id"] as int?,
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "planet": planet,
        "planet_id": planetId,
        "start": start,
        "end": end,
      };
}

class MajorYoginiDasha {
  int? dashaId;
  String dashaName;
  String startDate;
  String endDate;
  int? startMs;
  int? endMs;
  int? duration;

  MajorYoginiDasha({
    this.dashaId,
    required this.dashaName,
    required this.startDate,
    required this.endDate,
    this.startMs,
    this.endMs,
    this.duration,
  });

  factory MajorYoginiDasha.fromJson(Map<String, dynamic> json) =>
      MajorYoginiDasha(
        dashaId: json["dasha_id"] as int?,
        dashaName: json["dasha_name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        startMs: json["start_ms"] as int?,
        endMs: json["end_ms"] as int?,
        duration: json["duration"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "dasha_id": dashaId,
        "dasha_name": dashaName,
        "start_date": startDate,
        "end_date": endDate,
        "start_ms": startMs,
        "end_ms": endMs,
        "duration": duration,
      };
}

class VimshottariDasha {
  MahaVimshottari major;
  MahaVimshottari minor;
  MahaVimshottari subMinor;
  MahaVimshottari subSubMinor;
  MahaVimshottari subSubSubMinor;

  VimshottariDasha({
    required this.major,
    required this.minor,
    required this.subMinor,
    required this.subSubMinor,
    required this.subSubSubMinor,
  });

  factory VimshottariDasha.fromJson(Map<String, dynamic> json) =>
      VimshottariDasha(
        major: MahaVimshottari.fromJson(json["major"]),
        minor: MahaVimshottari.fromJson(json["minor"]),
        subMinor: MahaVimshottari.fromJson(json["sub_minor"]),
        subSubMinor: MahaVimshottari.fromJson(json["sub_sub_minor"]),
        subSubSubMinor: MahaVimshottari.fromJson(json["sub_sub_sub_minor"]),
      );

  Map<String, dynamic> toJson() => {
        "major": major.toJson(),
        "minor": minor.toJson(),
        "sub_minor": subMinor.toJson(),
        "sub_sub_minor": subSubMinor.toJson(),
        "sub_sub_sub_minor": subSubSubMinor.toJson(),
      };
}

class YoginiDasha {
  Dasha majorDasha;
  Dasha subDasha;
  Dasha subSubDasha;

  YoginiDasha({
    required this.majorDasha,
    required this.subDasha,
    required this.subSubDasha,
  });

  factory YoginiDasha.fromJson(Map<String, dynamic> json) => YoginiDasha(
        majorDasha: Dasha.fromJson(json["major_dasha"]),
        subDasha: Dasha.fromJson(json["sub_dasha"]),
        subSubDasha: Dasha.fromJson(json["sub_sub_dasha"]),
      );

  Map<String, dynamic> toJson() => {
        "major_dasha": majorDasha.toJson(),
        "sub_dasha": subDasha.toJson(),
        "sub_sub_dasha": subSubDasha.toJson(),
      };
}

class Dasha {
  int dashaId;
  String dashaName;
  String? duration;
  String startDate;
  String endDate;

  Dasha({
    required this.dashaId,
    required this.dashaName,
    this.duration,
    required this.startDate,
    required this.endDate,
  });

  factory Dasha.fromJson(Map<String, dynamic> json) => Dasha(
        dashaId: json["dasha_id"],
        dashaName: json["dasha_name"],
        duration: json["duration"],
        startDate: json["start_date"],
        endDate: json["end_date"],
      );

  Map<String, dynamic> toJson() => {
        "dasha_id": dashaId,
        "dasha_name": dashaName,
        "duration": duration,
        "start_date": startDate,
        "end_date": endDate,
      };
}
