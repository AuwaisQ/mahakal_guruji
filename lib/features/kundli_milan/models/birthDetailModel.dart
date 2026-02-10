// ignore: file_names
// To parse this JSON data, do
//
//     final birthDetailModel = birthDetailModelFromJson(jsonString);

import 'dart:convert';

BirthDetailModel birthDetailModelFromJson(String str) =>
    BirthDetailModel.fromJson(json.decode(str));

String birthDetailModelToJson(BirthDetailModel data) =>
    json.encode(data.toJson());

class BirthDetailModel {
  int status;
  AstroData astroData;
  BirthData birthData;

  BirthDetailModel({
    required this.status,
    required this.astroData,
    required this.birthData,
  });

  factory BirthDetailModel.fromJson(Map<String, dynamic> json) =>
      BirthDetailModel(
        status: json["status"],
        astroData: AstroData.fromJson(json["astroData"]),
        birthData: BirthData.fromJson(json["birthData"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "astroData": astroData.toJson(),
        "birthData": birthData.toJson(),
      };
}

class AstroData {
  AstroDataFemaleAstroDetails maleAstroDetails;
  AstroDataFemaleAstroDetails femaleAstroDetails;

  AstroData({
    required this.maleAstroDetails,
    required this.femaleAstroDetails,
  });

  factory AstroData.fromJson(Map<String, dynamic> json) => AstroData(
        maleAstroDetails:
            AstroDataFemaleAstroDetails.fromJson(json["male_astro_details"]),
        femaleAstroDetails:
            AstroDataFemaleAstroDetails.fromJson(json["female_astro_details"]),
      );

  Map<String, dynamic> toJson() => {
        "male_astro_details": maleAstroDetails.toJson(),
        "female_astro_details": femaleAstroDetails.toJson(),
      };
}

class AstroDataFemaleAstroDetails {
  String ascendant;
  String varna;
  String vashya;
  String yoni;
  String gan;
  String nadi;
  String signLord;
  String sign;
  String naksahtra;
  String naksahtraLord;
  int charan;
  String yog;
  String karan;
  String tithi;
  String yunja;
  String tatva;
  String nameAlphabet;
  String paya;

  AstroDataFemaleAstroDetails({
    required this.ascendant,
    required this.varna,
    required this.vashya,
    required this.yoni,
    required this.gan,
    required this.nadi,
    required this.signLord,
    required this.sign,
    required this.naksahtra,
    required this.naksahtraLord,
    required this.charan,
    required this.yog,
    required this.karan,
    required this.tithi,
    required this.yunja,
    required this.tatva,
    required this.nameAlphabet,
    required this.paya,
  });

  factory AstroDataFemaleAstroDetails.fromJson(Map<String, dynamic> json) =>
      AstroDataFemaleAstroDetails(
        ascendant: json["ascendant"],
        varna: json["Varna"],
        vashya: json["Vashya"],
        yoni: json["Yoni"],
        gan: json["Gan"],
        nadi: json["Nadi"],
        signLord: json["SignLord"],
        sign: json["sign"],
        naksahtra: json["Naksahtra"],
        naksahtraLord: json["NaksahtraLord"],
        charan: json["Charan"],
        yog: json["Yog"],
        karan: json["Karan"],
        tithi: json["Tithi"],
        yunja: json["yunja"],
        tatva: json["tatva"],
        nameAlphabet: json["name_alphabet"],
        paya: json["paya"],
      );

  Map<String, dynamic> toJson() => {
        "ascendant": ascendant,
        "Varna": varna,
        "Vashya": vashya,
        "Yoni": yoni,
        "Gan": gan,
        "Nadi": nadi,
        "SignLord": signLord,
        "sign": sign,
        "Naksahtra": naksahtra,
        "NaksahtraLord": naksahtraLord,
        "Charan": charan,
        "Yog": yog,
        "Karan": karan,
        "Tithi": tithi,
        "yunja": yunja,
        "tatva": tatva,
        "name_alphabet": nameAlphabet,
        "paya": paya,
      };
}

class BirthData {
  BirthDataFemaleAstroDetails maleAstroDetails;
  BirthDataFemaleAstroDetails femaleAstroDetails;

  BirthData({
    required this.maleAstroDetails,
    required this.femaleAstroDetails,
  });

  factory BirthData.fromJson(Map<String, dynamic> json) => BirthData(
        maleAstroDetails:
            BirthDataFemaleAstroDetails.fromJson(json["male_astro_details"]),
        femaleAstroDetails:
            BirthDataFemaleAstroDetails.fromJson(json["female_astro_details"]),
      );

  Map<String, dynamic> toJson() => {
        "male_astro_details": maleAstroDetails.toJson(),
        "female_astro_details": femaleAstroDetails.toJson(),
      };
}

class BirthDataFemaleAstroDetails {
  int year;
  int month;
  int day;
  int hour;
  int minute;
  double latitude;
  double longitude;
  double timezone;
  String gender;
  double ayanamsha;
  String sunrise;
  String sunset;

  BirthDataFemaleAstroDetails({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.gender,
    required this.ayanamsha,
    required this.sunrise,
    required this.sunset,
  });

  factory BirthDataFemaleAstroDetails.fromJson(Map<String, dynamic> json) =>
      BirthDataFemaleAstroDetails(
        year: json["year"],
        month: json["month"],
        day: json["day"],
        hour: json["hour"],
        minute: json["minute"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        timezone: json["timezone"]?.toDouble(),
        gender: json["gender"],
        ayanamsha: json["ayanamsha"]?.toDouble(),
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "day": day,
        "hour": hour,
        "minute": minute,
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "gender": gender,
        "ayanamsha": ayanamsha,
        "sunrise": sunrise,
        "sunset": sunset,
      };
}
