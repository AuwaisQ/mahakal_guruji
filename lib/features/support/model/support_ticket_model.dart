// To parse this JSON data, do
//
//     final supportTicketModel = supportTicketModelFromJson(jsonString);

import 'dart:convert';

SupportTicketModel supportTicketModelFromJson(String str) =>
    SupportTicketModel.fromJson(json.decode(str));

String supportTicketModelToJson(SupportTicketModel data) =>
    json.encode(data.toJson());

class SupportTicketModel {
  int status;
  String message;
  List<Ticketlist> ticketlist;

  SupportTicketModel({
    required this.status,
    required this.message,
    required this.ticketlist,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      SupportTicketModel(
        status: json["status"],
        message: json["message"],
        ticketlist: List<Ticketlist>.from(
            json["Ticketlist"].map((x) => Ticketlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Ticketlist": List<dynamic>.from(ticketlist.map((x) => x.toJson())),
      };
}

class Ticketlist {
  int id;
  String name;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Ticketlist({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ticketlist.fromJson(Map<String, dynamic> json) => Ticketlist(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
