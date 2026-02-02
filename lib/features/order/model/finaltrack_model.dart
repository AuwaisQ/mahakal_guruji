// To parse this JSON data, do
//
//     final finalTrackDetailModel = finalTrackDetailModelFromJson(jsonString);

import 'dart:convert';

FinalTrackDetailModel finalTrackDetailModelFromJson(String str) =>
    FinalTrackDetailModel.fromJson(json.decode(str));

String finalTrackDetailModelToJson(FinalTrackDetailModel data) =>
    json.encode(data.toJson());

class FinalTrackDetailModel {
  bool? success;
  String? message;
  Order? order;

  FinalTrackDetailModel({
    this.success,
    this.message,
    this.order,
  });

  factory FinalTrackDetailModel.fromJson(Map<String, dynamic> json) =>
      FinalTrackDetailModel(
        success: json["success"],
        message: json["message"],
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "order": order?.toJson(),
      };
}

class Order {
  String? orderId;
  String? status;
  String? scheduleTime;
  DateTime? scheduleCreated;
  String? liveStream;
  DateTime? liveCreatedStream;
  String? poojaVideo;
  DateTime? videoCreatedSharing;
  String? rejectReason;
  String? poojaCertificate;
  DateTime? orderCompleted;
  String? orderCanceled;
  String? orderCanceledReason;
  String? orderStatus;
  DateTime? bookingDate;
  DateTime? createdAt;
  String? counsellingReport;
  String? prashadStatus;

  Order({
    this.orderId,
    this.status,
    this.scheduleTime,
    this.scheduleCreated,
    this.liveStream,
    this.liveCreatedStream,
    this.poojaVideo,
    this.videoCreatedSharing,
    this.rejectReason,
    this.poojaCertificate,
    this.orderCompleted,
    this.orderCanceled,
    this.orderCanceledReason,
    this.orderStatus,
    this.bookingDate,
    this.createdAt,
    this.counsellingReport,
    this.prashadStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        status: json["status"],
        scheduleTime: json["schedule_time"],
        scheduleCreated: json["schedule_created"] == null
            ? null
            : DateTime.parse(json["schedule_created"]),
        liveStream: json["live_stream"],
        liveCreatedStream: json["live_created_stream"] == null
            ? null
            : DateTime.parse(json["live_created_stream"]),
        poojaVideo: json["pooja_video"],
        videoCreatedSharing: json["video_created_sharing"] == null
            ? null
            : DateTime.parse(json["video_created_sharing"]),
        rejectReason: json["reject_reason"],
        poojaCertificate: json["pooja_certificate"],
        orderCompleted: json["order_completed"] == null
            ? null
            : DateTime.parse(json["order_completed"]),
        orderCanceled: json["order_canceled"],
        orderCanceledReason: json["order_canceled_reason"],
        orderStatus: json["order_status"],
        bookingDate: json["booking_date"] == null
            ? null
            : DateTime.parse(json["booking_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        counsellingReport: json["counselling_report"],
        prashadStatus: json["prashad_status"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "status": status,
        "schedule_time": scheduleTime,
        "schedule_created": scheduleCreated?.toIso8601String(),
        "live_stream": liveStream,
        "live_created_stream": liveCreatedStream?.toIso8601String(),
        "pooja_video": poojaVideo,
        "video_created_sharing": videoCreatedSharing?.toIso8601String(),
        "reject_reason": rejectReason,
        "pooja_certificate": poojaCertificate,
        "order_completed": orderCompleted?.toIso8601String(),
        "order_canceled": orderCanceled,
        "order_canceled_reason": orderCanceledReason,
        "order_status": orderStatus,
        "booking_date":
            "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "counselling_report": counsellingReport,
        "prashad_status": prashadStatus,
      };
}
