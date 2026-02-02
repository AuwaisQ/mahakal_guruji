// To parse this JSON data, do
//
//     final chadhavaOrderModel = chadhavaOrderModelFromJson(jsonString);

import 'dart:convert';

ChadhavaOrderModel chadhavaOrderModelFromJson(String str) =>
    ChadhavaOrderModel.fromJson(json.decode(str));

String chadhavaOrderModelToJson(ChadhavaOrderModel data) =>
    json.encode(data.toJson());

class ChadhavaOrderModel {
  bool status;
  List<Chadhavalist> chadhavalist;

  ChadhavaOrderModel({
    required this.status,
    required this.chadhavalist,
  });

  factory ChadhavaOrderModel.fromJson(Map<String, dynamic> json) =>
      ChadhavaOrderModel(
        status: json["status"],
        chadhavalist: List<Chadhavalist>.from(
            json["Chadhavalist"].map((x) => Chadhavalist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Chadhavalist": List<dynamic>.from(chadhavalist.map((x) => x.toJson())),
      };
}

class Chadhavalist {
  int? id;
  int? customerId;
  int? serviceId;
  String? type;
  int? leadsId;
  dynamic panditAssign;
  String? paymentId;
  String? orderId;
  String? payAmount;
  dynamic newphone;
  String? members;
  String? gotra;
  String? reason;
  String? paymentStatus;
  DateTime bookingDate;
  int? status;
  int? checked;
  int? orderStatus;
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
  dynamic couponCode;
  dynamic couponAmount;
  Chadhava chadhava;

  Chadhavalist({
    required this.id,
    required this.customerId,
    required this.serviceId,
    required this.type,
    required this.leadsId,
    required this.panditAssign,
    required this.paymentId,
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
    required this.couponCode,
    required this.couponAmount,
    required this.chadhava,
  });

  factory Chadhavalist.fromJson(Map<String, dynamic> json) => Chadhavalist(
        id: json["id"],
        customerId: json["customer_id"],
        serviceId: json["service_id"],
        type: json["type"],
        leadsId: json["leads_id"],
        panditAssign: json["pandit_assign"],
        paymentId: json["payment_id"],
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
        couponCode: json["coupon_code"],
        couponAmount: json["coupon_amount"],
        chadhava: Chadhava.fromJson(json["chadhava"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "service_id": serviceId,
        "type": type,
        "leads_id": leadsId,
        "pandit_assign": panditAssign,
        "payment_id": paymentId,
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
        "coupon_code": couponCode,
        "coupon_amount": couponAmount,
        "chadhava": chadhava.toJson(),
      };
}

class Chadhava {
  int id;
  int userId;
  String addedBy;
  String name;
  String slug;
  String shortDetails;
  String chadhavaVenue;
  String poojaHeading;
  String details;
  int chadhavaType;
  String chadhavaWeek;
  dynamic startDate;
  dynamic endDate;
  int isVideo;
  String productId;
  String images;
  String thumbnail;
  String metaTitle;
  String metaDescription;
  String metaImage;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> translations;

  Chadhava({
    required this.id,
    required this.userId,
    required this.addedBy,
    required this.name,
    required this.slug,
    required this.shortDetails,
    required this.chadhavaVenue,
    required this.poojaHeading,
    required this.details,
    required this.chadhavaType,
    required this.chadhavaWeek,
    required this.startDate,
    required this.endDate,
    required this.isVideo,
    required this.productId,
    required this.images,
    required this.thumbnail,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory Chadhava.fromJson(Map<String, dynamic> json) => Chadhava(
        id: json["id"],
        userId: json["user_id"],
        addedBy: json["added_by"],
        name: json["name"],
        slug: json["slug"],
        shortDetails: json["short_details"],
        chadhavaVenue: json["chadhava_venue"],
        poojaHeading: json["pooja_heading"],
        details: json["details"],
        chadhavaType: json["chadhava_type"],
        chadhavaWeek: json["chadhava_week"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        isVideo: json["is_video"],
        productId: json["product_id"],
        images: json["images"],
        thumbnail: json["thumbnail"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaImage: json["meta_image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        translations: List<dynamic>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "added_by": addedBy,
        "name": name,
        "slug": slug,
        "short_details": shortDetails,
        "chadhava_venue": chadhavaVenue,
        "pooja_heading": poojaHeading,
        "details": details,
        "chadhava_type": chadhavaType,
        "chadhava_week": chadhavaWeek,
        "start_date": startDate,
        "end_date": endDate,
        "is_video": isVideo,
        "product_id": productId,
        "images": images,
        "thumbnail": thumbnail,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_image": metaImage,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "translations": List<dynamic>.from(translations.map((x) => x)),
      };
}
