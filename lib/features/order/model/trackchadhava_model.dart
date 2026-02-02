// To parse this JSON data, do
//
//     final chadhavaTrackModel = chadhavaTrackModelFromJson(jsonString);

import 'dart:convert';

ChadhavaTrackModel chadhavaTrackModelFromJson(String str) =>
    ChadhavaTrackModel.fromJson(json.decode(str));

String chadhavaTrackModelToJson(ChadhavaTrackModel data) =>
    json.encode(data.toJson());

class ChadhavaTrackModel {
  bool success;
  Order order;
  int? isReview;
  String refundDayLimit;
  DateTime currentDate;

  ChadhavaTrackModel({
    required this.success,
    required this.order,
    this.isReview,
    required this.refundDayLimit,
    required this.currentDate,
  });

  factory ChadhavaTrackModel.fromJson(Map<String, dynamic> json) =>
      ChadhavaTrackModel(
        success: json["success"],
        order: Order.fromJson(json["order"]),
        isReview: json["is_review"],
        refundDayLimit: json["refund_day_limit"],
        currentDate: DateTime.parse(json["current_date"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "order": order.toJson(),
        "is_review": isReview,
        "refund_day_limit": refundDayLimit,
        "current_date": currentDate.toIso8601String(),
      };
}

class Order {
  int? id;
  int? customerId;
  int? serviceId;
  String? type;
  int? leadsId;
  dynamic panditAssign;
  String? paymentId;
  String? walletTranslationId;
  int? transectionAmount;
  int? walletAmount;
  String? orderId;
  String? payAmount;
  dynamic newphone;
  dynamic members;
  dynamic gotra;
  dynamic reason;
  String? paymentStatus;
  DateTime bookingDate;
  String? status;
  int? checked;
  String? orderStatus;
  int? isEdited;
  int? isRejected;
  int? isCompleted;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic scheduleTime;
  dynamic scheduleCreated;
  dynamic liveStream;
  dynamic liveCreatedStream;
  dynamic poojaVideo;
  dynamic videoCreatedSharing;
  dynamic poojaCertificate;
  dynamic rejectReason;
  dynamic orderCompleted;
  dynamic orderCanceled;
  dynamic orderCanceledReason;
  Customer customer;
  Leads? leads;
  Chadhava chadhava;
  dynamic packages;
  dynamic payments;
  Pandit? pandit;
  List<ProductLead> productLeads;

  Order({
    required this.id,
    required this.customerId,
    required this.serviceId,
    required this.type,
    required this.leadsId,
    required this.panditAssign,
    required this.paymentId,
    required this.walletTranslationId,
    required this.transectionAmount,
    required this.walletAmount,
    required this.orderId,
    required this.payAmount,
    required this.newphone,
    required this.members,
    required this.gotra,
    required this.reason,
    required this.paymentStatus,
    required this.bookingDate,
    required this.status,
    required this.checked,
    required this.orderStatus,
    required this.isEdited,
    required this.isRejected,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduleTime,
    required this.scheduleCreated,
    required this.liveStream,
    required this.liveCreatedStream,
    required this.poojaVideo,
    required this.videoCreatedSharing,
    required this.poojaCertificate,
    required this.rejectReason,
    required this.orderCompleted,
    required this.orderCanceled,
    required this.orderCanceledReason,
    required this.customer,
    required this.leads,
    required this.chadhava,
    required this.packages,
    required this.payments,
    required this.pandit,
    required this.productLeads,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        customerId: json["customer_id"],
        serviceId: json["service_id"],
        type: json["type"],
        leadsId: json["leads_id"],
        panditAssign: json["pandit_assign"],
        paymentId: json["payment_id"],
        walletTranslationId: json["wallet_translation_id"],
        transectionAmount: json["transection_amount"],
        walletAmount: json["wallet_amount"],
        orderId: json["order_id"],
        payAmount: json["pay_amount"],
        newphone: json["newphone"],
        members: json["members"],
        gotra: json["gotra"],
        reason: json["reason"],
        paymentStatus: json["payment_status"],
        bookingDate: DateTime.parse(json["booking_date"]),
        status: json["status"],
        checked: json["checked"],
        orderStatus: json["order_status"],
        isEdited: json["is_edited"],
        isRejected: json["is_rejected"],
        isCompleted: json["is_completed"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        scheduleTime: json["schedule_time"],
        scheduleCreated: json["schedule_created"],
        liveStream: json["live_stream"],
        liveCreatedStream: json["live_created_stream"],
        poojaVideo: json["pooja_video"],
        videoCreatedSharing: json["video_created_sharing"],
        poojaCertificate: json["pooja_certificate"],
        rejectReason: json["reject_reason"],
        orderCompleted: json["order_completed"],
        orderCanceled: json["order_canceled"],
        orderCanceledReason: json["order_canceled_reason"],
        customer: Customer.fromJson(json["customer"]),
        leads: Leads.fromJson(json["leads"]),
        chadhava: Chadhava.fromJson(json["chadhava"]),
        packages: json["packages"],
        payments: json["payments"],
        pandit: json["pandit"] == null ? null : Pandit.fromJson(json["pandit"]),
        productLeads: List<ProductLead>.from(
            json["product_leads"].map((x) => ProductLead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "service_id": serviceId,
        "type": type,
        "leads_id": leadsId,
        "pandit_assign": panditAssign,
        "payment_id": paymentId,
        "wallet_translation_id": walletTranslationId,
        "transection_amount": transectionAmount,
        "wallet_amount": walletAmount,
        "order_id": orderId,
        "pay_amount": payAmount,
        "newphone": newphone,
        "members": members,
        "gotra": gotra,
        "reason": reason,
        "payment_status": paymentStatus,
        "booking_date":
            "${bookingDate.year.toString().padLeft(4, '0')}-${bookingDate.month.toString().padLeft(2, '0')}-${bookingDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "checked": checked,
        "order_status": orderStatus,
        "is_edited": isEdited,
        "is_rejected": isRejected,
        "is_completed": isCompleted,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "schedule_time": scheduleTime,
        "schedule_created": scheduleCreated,
        "live_stream": liveStream,
        "live_created_stream": liveCreatedStream,
        "pooja_video": poojaVideo,
        "video_created_sharing": videoCreatedSharing,
        "pooja_certificate": poojaCertificate,
        "reject_reason": rejectReason,
        "order_completed": orderCompleted,
        "order_canceled": orderCanceled,
        "order_canceled_reason": orderCanceledReason,
        "customer": customer.toJson(),
        "leads": leads,
        "chadhava": chadhava.toJson(),
        "packages": packages,
        "payments": payments,
        "pandit": pandit?.toJson(),
        "product_leads":
            List<dynamic>.from(productLeads.map((x) => x.toJson())),
      };
}

class Chadhava {
  int id;
  String name;
  String thumbnail;
  String hiName;
  List<dynamic> translations;

  Chadhava({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.hiName,
    required this.translations,
  });

  factory Chadhava.fromJson(Map<String, dynamic> json) => Chadhava(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        hiName: json["hi_name"],
        translations: List<dynamic>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "hi_name": hiName,
        "translations": List<dynamic>.from(translations.map((x) => x)),
      };
}

class Customer {
  int id;
  dynamic name;
  String email;
  String phone;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
      };
}

class Leads {
  int id;
  int serviceId;
  dynamic leadno;
  dynamic orderId;
  String type;
  dynamic packageId;
  String productId;
  dynamic packageName;
  dynamic noperson;
  String packagePrice;
  String personName;
  String personPhone;
  DateTime bookingDate;
  String? paymentStatus;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> translations;

  Leads({
    required this.id,
    required this.serviceId,
    required this.leadno,
    required this.orderId,
    required this.type,
    required this.packageId,
    required this.productId,
    required this.packageName,
    required this.noperson,
    required this.packagePrice,
    required this.personName,
    required this.personPhone,
    required this.bookingDate,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory Leads.fromJson(Map<String, dynamic> json) => Leads(
        id: json["id"],
        serviceId: json["service_id"],
        leadno: json["leadno"],
        orderId: json["order_id"],
        type: json["type"],
        packageId: json["package_id"],
        productId: json["product_id"],
        packageName: json["package_name"],
        noperson: json["noperson"],
        packagePrice: json["package_price"],
        personName: json["person_name"],
        personPhone: json["person_phone"],
        bookingDate: DateTime.parse(json["booking_date"]),
        paymentStatus: json["payment_status"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        translations: List<dynamic>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "leadno": leadno,
        "order_id": orderId,
        "type": type,
        "package_id": packageId,
        "product_id": productId,
        "package_name": packageName,
        "noperson": noperson,
        "package_price": packagePrice,
        "person_name": personName,
        "person_phone": personPhone,
        "booking_date": bookingDate.toIso8601String(),
        "payment_status": paymentStatus,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "translations": List<dynamic>.from(translations.map((x) => x)),
      };
}

class ProductLead {
  int id;
  int leadsId;
  String finalPrice;
  String qty;
  String productName;
  String productPrice;

  ProductLead({
    required this.id,
    required this.leadsId,
    required this.finalPrice,
    required this.qty,
    required this.productName,
    required this.productPrice,
  });

  factory ProductLead.fromJson(Map<String, dynamic> json) => ProductLead(
        id: json["id"],
        leadsId: json["leads_id"],
        finalPrice: json["final_price"],
        qty: json["qty"],
        productName: json["product_name"],
        productPrice: json["product_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "leads_id": leadsId,
        "final_price": finalPrice,
        "qty": qty,
        "product_name": productName,
        "product_price": productPrice,
      };
}

class Pandit {
  int? id;
  String? name;
  String? email;
  String? mobileNo;
  int? ordercount;

  Pandit({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.ordercount,
  });

  factory Pandit.fromJson(Map<String, dynamic> json) => Pandit(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobileNo: json["mobile_no"],
        ordercount: json["ordercount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile_no": mobileNo,
        "ordercount": ordercount,
      };
}
