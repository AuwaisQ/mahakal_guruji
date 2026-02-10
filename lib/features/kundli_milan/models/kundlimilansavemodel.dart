// To parse this JSON data, do
//
//     final kundliMilanSaveModel = kundliMilanSaveModelFromJson(jsonString);

import 'dart:convert';

List<KundliMilanSaveModel> kundliMilanSaveModelFromJson(String str) =>
    List<KundliMilanSaveModel>.from(
        json.decode(str).map((x) => KundliMilanSaveModel.fromJson(x)));

String kundliMilanSaveModelToJson(List<KundliMilanSaveModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KundliMilanSaveModel {
  int id;
  int userId;
  String deviceId;
  String maleName;
  String maleDob;
  String maleTime;
  String maleCountry;
  String maleCity;
  String maleLatitude;
  String maleLongitude;
  double maleTimezone;
  String femaleName;
  String femaleDob;
  String femaleTime;
  String femaleCountry;
  String femaleCity;
  String femaleLatitude;
  String femaleLongitude;
  double femaleTimezone;
  DateTime createdAt;
  DateTime updatedAt;

  KundliMilanSaveModel({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.maleName,
    required this.maleDob,
    required this.maleTime,
    required this.maleCountry,
    required this.maleCity,
    required this.maleLatitude,
    required this.maleLongitude,
    required this.maleTimezone,
    required this.femaleName,
    required this.femaleDob,
    required this.femaleTime,
    required this.femaleCountry,
    required this.femaleCity,
    required this.femaleLatitude,
    required this.femaleLongitude,
    required this.femaleTimezone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KundliMilanSaveModel.fromJson(Map<String, dynamic> json) =>
      KundliMilanSaveModel(
        id: json["id"],
        userId: json["user_id"],
        deviceId: json["device_id"],
        maleName: json["male_name"],
        maleDob: json["male_dob"],
        maleTime: json["male_time"],
        maleCountry: json["male_country"],
        maleCity: json["male_city"],
        maleLatitude: json["male_latitude"],
        maleLongitude: json["male_longitude"],
        maleTimezone: json["male_timezone"]?.toDouble(),
        femaleName: json["female_name"],
        femaleDob: json["female_dob"],
        femaleTime: json["female_time"],
        femaleCountry: json["female_country"],
        femaleCity: json["female_city"],
        femaleLatitude: json["female_latitude"],
        femaleLongitude: json["female_longitude"],
        femaleTimezone: json["female_timezone"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "device_id": deviceId,
        "male_name": maleName,
        "male_dob": maleDob,
        "male_time": maleTime,
        "male_country": maleCountry,
        "male_city": maleCity,
        "male_latitude": maleLatitude,
        "male_longitude": maleLongitude,
        "male_timezone": maleTimezone,
        "female_name": femaleName,
        "female_dob": femaleDob,
        "female_time": femaleTime,
        "female_country": femaleCountry,
        "female_city": femaleCity,
        "female_latitude": femaleLatitude,
        "female_longitude": femaleLongitude,
        "female_timezone": femaleTimezone,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
