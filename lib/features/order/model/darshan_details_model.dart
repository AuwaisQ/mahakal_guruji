// To parse this JSON data, do
//
//     final mandirDarshandetailsModel = mandirDarshandetailsModelFromJson(jsonString);

import 'dart:convert';

MandirDarshandetailsModel mandirDarshandetailsModelFromJson(String str) =>
    MandirDarshandetailsModel.fromJson(json.decode(str));

String mandirDarshandetailsModelToJson(MandirDarshandetailsModel data) =>
    json.encode(data.toJson());

class MandirDarshandetailsModel {
  int status;
  String message;
  Darshandetail data;

  MandirDarshandetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MandirDarshandetailsModel.fromJson(Map<String, dynamic> json) =>
      MandirDarshandetailsModel(
        status: json["status"],
        message: json["message"],
        data: Darshandetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Darshandetail {
  int id;
  String orderId;
  String title;
  String packageName;
  int peopleQty;
  dynamic price;
  int status;
  String createdAt;
  String enTempleName;
  String hiTempleName;
  String invoice;
  String image;
  String userName;
  String userPhone;
  String userEmail;
  String bookingDate;
  String timeSlot;
  String paymentStatus;
  String paymentMethod;
  dynamic subTotal;
  dynamic totalTax;
  dynamic payAmount;
  List<MemberList> memberList;

  Darshandetail({
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
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.bookingDate,
    required this.timeSlot,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subTotal,
    required this.totalTax,
    required this.payAmount,
    required this.memberList,
  });

  factory Darshandetail.fromJson(Map<String, dynamic> json) => Darshandetail(
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
        userName: json["user_name"],
        userPhone: json["user_phone"],
        userEmail: json["user_email"],
        bookingDate: json["booking_date"],
        timeSlot: json["time_slot"],
        paymentStatus: json["payment_status"],
        paymentMethod: json["payment_method"],
        subTotal: json["sub_total"],
        totalTax: json["total_tax"],
        payAmount: json["pay_amount"],
        memberList: List<MemberList>.from(
            json["member_list"].map((x) => MemberList.fromJson(x))),
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
        "user_name": userName,
        "user_phone": userPhone,
        "user_email": userEmail,
        "booking_date": bookingDate,
        "time_slot": timeSlot,
        "payment_status": paymentStatus,
        "payment_method": paymentMethod,
        "sub_total": subTotal,
        "total_tax": totalTax,
        "pay_amount": payAmount,
        "member_list": List<dynamic>.from(memberList.map((x) => x.toJson())),
      };
}

class MemberList {
  String name;
  String phone;
  String aadhar;
  String image;
  String pass;

  MemberList({
    required this.name,
    required this.phone,
    required this.aadhar,
    required this.image,
    required this.pass,
  });

  factory MemberList.fromJson(Map<String, dynamic> json) => MemberList(
        name: json["name"],
        phone: json["phone"],
        aadhar: json["aadhar"],
        image: json["image"],
        pass: json["pass"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "aadhar": aadhar,
        "image": image,
        "pass": pass,
      };
}
