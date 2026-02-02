// To parse this JSON data, do
//
//     final cityPickerModel = cityPickerModelFromJson(jsonString);

import 'dart:convert';

List<CityPickerModel> cityPickerModelFromJson(String str) =>
    List<CityPickerModel>.from(
        json.decode(str).map((x) => CityPickerModel.fromJson(x)));

String cityPickerModelToJson(List<CityPickerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityPickerModel {
  String place;
  String country;
  String latitude;
  String longitude;

  CityPickerModel({
    required this.place,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory CityPickerModel.fromJson(Map<String, dynamic> json) =>
      CityPickerModel(
        place: json["place"],
        country: json["country"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
    "place": place,
    "country": country,
    "latitude": latitude,
    "longitude": longitude,
  };
}
