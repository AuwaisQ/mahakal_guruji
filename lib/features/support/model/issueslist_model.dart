// To parse this JSON data, do
//
//     final supportTicketisuuesModel = supportTicketisuuesModelFromJson(jsonString);

import 'dart:convert';

SupportTicketisuuesModel supportTicketisuuesModelFromJson(String str) =>
    SupportTicketisuuesModel.fromJson(json.decode(str));

String supportTicketisuuesModelToJson(SupportTicketisuuesModel data) =>
    json.encode(data.toJson());

class SupportTicketisuuesModel {
  int status;
  String message;
  List<Issuelist> issuelist;

  SupportTicketisuuesModel({
    required this.status,
    required this.message,
    required this.issuelist,
  });

  factory SupportTicketisuuesModel.fromJson(Map<String, dynamic> json) =>
      SupportTicketisuuesModel(
        status: json["status"],
        message: json["message"],
        issuelist: List<Issuelist>.from(
            json["issuelist"].map((x) => Issuelist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "issuelist": List<dynamic>.from(issuelist.map((x) => x.toJson())),
      };
}

class Issuelist {
  int id;
  String issueName;
  int typeId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Issuelist({
    required this.id,
    required this.issueName,
    required this.typeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Issuelist.fromJson(Map<String, dynamic> json) => Issuelist(
        id: json["id"],
        issueName: json["issue_name"],
        typeId: json["type_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "issue_name": issueName,
        "type_id": typeId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
