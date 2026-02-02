// To parse this JSON data, do
//
//     final supportTicketHomeModel = supportTicketHomeModelFromJson(jsonString);

import 'dart:convert';

SupportTicketHomeModel supportTicketHomeModelFromJson(String str) =>
    SupportTicketHomeModel.fromJson(json.decode(str));

String supportTicketHomeModelToJson(SupportTicketHomeModel data) =>
    json.encode(data.toJson());

class SupportTicketHomeModel {
  int status;
  String message;
  List<Getticketlist> getticketlist;

  SupportTicketHomeModel({
    required this.status,
    required this.message,
    required this.getticketlist,
  });

  factory SupportTicketHomeModel.fromJson(Map<String, dynamic> json) =>
      SupportTicketHomeModel(
        status: json["status"],
        message: json["message"],
        getticketlist: List<Getticketlist>.from(
            json["getticketlist"].map((x) => Getticketlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "getticketlist":
            List<dynamic>.from(getticketlist.map((x) => x.toJson())),
      };
}

class Getticketlist {
  int id;
  String type;
  String issueName;
  String subject;
  String description;
  String priority;
  String status;
  DateTime createdAt;

  Getticketlist({
    required this.id,
    required this.type,
    required this.issueName,
    required this.subject,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  factory Getticketlist.fromJson(Map<String, dynamic> json) => Getticketlist(
        id: json["id"],
        type: json["type"],
        issueName: json["issue_name"],
        subject: json["subject"],
        description: json["description"],
        priority: json["priority"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "issue_name": issueName,
        "subject": subject,
        "description": description,
        "priority": priority,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}
