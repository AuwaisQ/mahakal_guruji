// To parse this JSON data, do
//
//     final allRecentOrderModel = allRecentOrderModelFromJson(jsonString);

import 'dart:convert';

AllRecentOrderModel allRecentOrderModelFromJson(String str) =>
    AllRecentOrderModel.fromJson(json.decode(str));

String allRecentOrderModelToJson(AllRecentOrderModel data) =>
    json.encode(data.toJson());

class AllRecentOrderModel {
  bool status;
  String message;
  List<Recentorder> recentorders;

  AllRecentOrderModel({
    required this.status,
    required this.message,
    required this.recentorders,
  });

  factory AllRecentOrderModel.fromJson(Map<String, dynamic> json) =>
      AllRecentOrderModel(
        status: json["status"],
        message: json["message"],
        recentorders: List<Recentorder>.from(
            json["recentorders"].map((x) => Recentorder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "recentorders": List<dynamic>.from(recentorders.map((x) => x.toJson())),
      };
}

class Recentorder {
  int id;
  dynamic type;
  dynamic serviceId;
  dynamic orderId;
  dynamic payAmount;
  dynamic status;
  dynamic orderStatus;
  DateTime? bookingDate;
  dynamic createdAt;
  Services services;

  Recentorder({
    required this.id,
    required this.type,
    required this.serviceId,
    required this.orderId,
    required this.payAmount,
    required this.status,
    required this.orderStatus,
    required this.bookingDate,
    required this.createdAt,
    required this.services,
  });

  factory Recentorder.fromJson(Map<String, dynamic> json) => Recentorder(
        id: json["id"],
        type: json["type"],
        serviceId: json["service_id"],
        orderId: json["order_id"],
        payAmount: json["pay_amount"],
        status: json["status"],
        orderStatus: json["order_status"],
        bookingDate: json["booking_date"] == null
            ? null
            : DateTime.parse(json["booking_date"]),
        createdAt: json["created_at"],
        services: Services.fromJson(json["services"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "service_id": serviceId,
        "order_id": orderId,
        "pay_amount": payAmount,
        "status": status,
        "order_status": orderStatus,
        "booking_date":
            "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt,
        "services": services.toJson(),
      };
}

class Services {
  int? id;
  String? name;
  String? thumbnail;
  List<dynamic>? translations;
  String? hiName;

  Services({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.translations,
    required this.hiName,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        translations: List<dynamic>.from(json["translations"].map((x) => x)),
        hiName: json["hi_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "translations": List<dynamic>.from(translations!.map((x) => x)),
        "hi_name": hiName,
      };
}
