import 'dart:convert';

PoojaOrderModel poojaOrderModelFromJson(String str) =>
    PoojaOrderModel.fromJson(json.decode(str));

String poojaOrderModelToJson(PoojaOrderModel data) =>
    json.encode(data.toJson());

class PoojaOrderModel {
  bool? status;
  String? message;
  List<Poojaorder>? poojaorder;

  PoojaOrderModel({
    this.status,
    this.message,
    this.poojaorder,
  });

  factory PoojaOrderModel.fromJson(Map<String, dynamic> json) =>
      PoojaOrderModel(
        status: json["status"],
        message: json["message"],
        poojaorder: json["poojaorder"] == null
            ? []
            : List<Poojaorder>.from(
                json["poojaorder"]!.map((x) => Poojaorder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "poojaorder": poojaorder == null
            ? []
            : List<dynamic>.from(poojaorder!.map((x) => x.toJson())),
      };
}

class Poojaorder {
  int? id;
  int? serviceId;
  dynamic orderId;
  dynamic payAmount;
  String? status;
  String? orderStatus;
  String? bookingDate;
  String? createdAt;
  Services? services;

  Poojaorder({
    this.id,
    this.serviceId,
    this.orderId,
    this.payAmount,
    this.status,
    this.orderStatus,
    this.bookingDate,
    this.createdAt,
    this.services,
  });

  factory Poojaorder.fromJson(Map<String, dynamic> json) => Poojaorder(
        id: json["id"],
        serviceId: json["service_id"],
        orderId: json["order_id"],
        payAmount: json["pay_amount"],
        status: json["status"],
        orderStatus: json["order_status"],
        bookingDate: json["booking_date"],
        createdAt: json["created_at"],
        services: json["services"] == null
            ? null
            : Services.fromJson(json["services"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "order_id": orderId,
        "pay_amount": payAmount,
        "status": status,
        "order_status": orderStatus,
        "booking_date": bookingDate,
        "created_at": createdAt,
        "services": services?.toJson(),
      };
}

class Services {
  int? id;
  String? name;
  String? thumbnail;
  List<dynamic>? translations;
  String? hiName;

  Services({
    this.id,
    this.name,
    this.thumbnail,
    this.translations,
    this.hiName,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
        hiName: json["hi_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
        "hi_name": hiName,
      };
}
