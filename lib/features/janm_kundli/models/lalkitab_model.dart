// To parse this JSON data, do
//
//     final lalkitabModel = lalkitabModelFromJson(jsonString);

import 'dart:convert';

List<LalkitabModel> lalkitabModelFromJson(String str) =>
    List<LalkitabModel>.from(
        json.decode(str).map((x) => LalkitabModel.fromJson(x)));

String lalkitabModelToJson(List<LalkitabModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LalkitabModel {
  String debtName;
  String indications;
  String events;

  LalkitabModel({
    required this.debtName,
    required this.indications,
    required this.events,
  });

  factory LalkitabModel.fromJson(Map<String, dynamic> json) => LalkitabModel(
        debtName: json["debt_name"],
        indications: json["indications"],
        events: json["events"],
      );

  Map<String, dynamic> toJson() => {
        "debt_name": debtName,
        "indications": indications,
        "events": events,
      };
}
