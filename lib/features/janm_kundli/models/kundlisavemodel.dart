// To parse this JSON data, do
//
//     final kundliSaveModel = kundliSaveModelFromJson(jsonString);

import 'dart:convert';

List<KundliSaveModel> kundliSaveModelFromJson(String str) =>
    List<KundliSaveModel>.from(
        json.decode(str).map((x) => KundliSaveModel.fromJson(x)));

String kundliSaveModelToJson(List<KundliSaveModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KundliSaveModel {
  int id;
  int userId;
  String deviceId;
  String name;
  String dob;
  String time;
  String country;
  String city;
  String latitude;
  String longitude;
  double timezone;
  DateTime createdAt;
  DateTime updatedAt;

  KundliSaveModel({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.name,
    required this.dob,
    required this.time,
    required this.country,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KundliSaveModel.fromJson(Map<String, dynamic> json) =>
      KundliSaveModel(
        id: json["id"],
        userId: json["user_id"],
        deviceId: json["device_id"],
        name: json["name"],
        dob: json["dob"],
        time: json["time"],
        country: json["country"],
        city: json["city"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        timezone: json["timezone"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "device_id": deviceId,
        "name": name,
        "dob": dob,
        "time": time,
        "country": country,
        "city": city,
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
