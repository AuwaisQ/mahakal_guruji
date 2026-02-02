// To parse this JSON data, do
//
//     final mandirDarshanModel = mandirDarshanModelFromJson(jsonString);

import 'dart:convert';

MandirDarshanModel mandirDarshanModelFromJson(String str) =>
    MandirDarshanModel.fromJson(json.decode(str));

String mandirDarshanModelToJson(MandirDarshanModel data) =>
    json.encode(data.toJson());

class MandirDarshanModel {
  int status;
  String message;
  List<Darshanorder> darshanorder;

  MandirDarshanModel({
    required this.status,
    required this.message,
    required this.darshanorder,
  });

  factory MandirDarshanModel.fromJson(Map<String, dynamic> json) =>
      MandirDarshanModel(
        status: json["status"],
        message: json["message"],
        darshanorder: List<Darshanorder>.from(
            json["darshanorder"].map((x) => Darshanorder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "darshanorder": List<dynamic>.from(darshanorder.map((x) => x.toJson())),
      };
}

class Darshanorder {
  int id;
  String orderId;
  String title;
  String packageName;
  int peopleQty;
  int price;
  int status;
  String createdAt;
  String enTempleName;
  String hiTempleName;
  String invoice;
  String image;

  Darshanorder({
    required this.id,
    required this.orderId,
    required this.title,
    required this.packageName,
    required this.peopleQty,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.enTempleName,
    required this.hiTempleName,
    required this.invoice,
    required this.image,
  });

  factory Darshanorder.fromJson(Map<String, dynamic> json) => Darshanorder(
        id: json["id"],
        orderId: json["order_id"],
        title: json["title"],
        packageName: json["package_name"],
        peopleQty: json["people_qty"],
        price: json["price"],
        status: json["status"],
        createdAt: json["created_at"],
        enTempleName: json["en_temple_name"],
        hiTempleName: json["hi_temple_name"],
        invoice: json["invoice"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "title": title,
        "package_name": packageName,
        "people_qty": peopleQty,
        "price": price,
        "status": status,
        "created_at": createdAt,
        "en_temple_name": enTempleName,
        "hi_temple_name": hiTempleName,
        "invoice": invoice,
        "image": image,
      };
}
