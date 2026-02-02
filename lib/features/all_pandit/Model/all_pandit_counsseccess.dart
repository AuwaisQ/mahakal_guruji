class AllPanditCounsSucess {
  AllPanditCounsSucess({
    required this.status,
    required this.message,
    required this.order,
    required this.sankalpData,
  });

  final bool status;
  final String message;
  final Order? order;
  final SankalpData? sankalpData;

  factory AllPanditCounsSucess.fromJson(Map<String, dynamic> json){
    return AllPanditCounsSucess(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      order: json["order"] == null ? null : Order.fromJson(json["order"]),
      sankalpData: json["sankalpData"] == null ? null : SankalpData.fromJson(json["sankalpData"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "order": order?.toJson(),
    "sankalpData": sankalpData?.toJson(),
  };

}

class Order {
  Order({
    required this.id,
    required this.customerId,
    required this.serviceId,
    required this.type,
    required this.leadsId,
    required this.packageId,
    required this.indivisual,
    required this.packagePrice,
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
    required this.isPrashad,
    required this.city,
    required this.state,
    required this.pincode,
    required this.houseNo,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.landmark,
    required this.prashadStatus,
    required this.paymentStatus,
    required this.bookingDate,
    required this.status,
    required this.counsellingReport,
    required this.counsellingReportVerified,
    required this.counsellingReportRejectReason,
    required this.checked,
    required this.orderStatus,
    required this.isEdited,
    required this.isRejected,
    required this.isBlock,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduleTime,
    required this.scheduleCreated,
    required this.liveStream,
    required this.liveCreatedStream,
    required this.poojaVideo,
    required this.videoCreatedSharing,
    required this.rejectReason,
    required this.poojaCertificate,
    required this.orderCompleted,
    required this.orderCanceled,
    required this.orderCanceledReason,
    required this.couponCode,
    required this.couponAmount,
    required this.deliveryPartner,
    required this.deliveryOrderId,
    required this.deliveryChannelId,
    required this.deliveryShipmentId,
  });

  final dynamic id;
  final dynamic customerId;
  final dynamic serviceId;
  final String type;
  final dynamic leadsId;
  final dynamic packageId;
  final dynamic indivisual;
  final String packagePrice;
  final String panditAssign;
  final dynamic paymentId;
  final dynamic walletTranslationId;
  final dynamic transectionAmount;
  final dynamic walletAmount;
  final dynamic orderId;
  final dynamic payAmount;
  final dynamic newphone;
  final dynamic members;
  final dynamic gotra;
  final dynamic isPrashad;
  final dynamic city;
  final dynamic state;
  final dynamic pincode;
  final dynamic houseNo;
  final dynamic area;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic landmark;
  final dynamic prashadStatus;
  final String paymentStatus;
  final dynamic bookingDate;
  final dynamic status;
  final dynamic counsellingReport;
  final dynamic counsellingReportVerified;
  final dynamic counsellingReportRejectReason;
  final int checked;
  final int orderStatus;
  final int isEdited;
  final int isRejected;
  final int isBlock;
  final int isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic scheduleTime;
  final dynamic scheduleCreated;
  final dynamic liveStream;
  final dynamic liveCreatedStream;
  final dynamic poojaVideo;
  final dynamic videoCreatedSharing;
  final dynamic rejectReason;
  final dynamic poojaCertificate;
  final dynamic orderCompleted;
  final dynamic orderCanceled;
  final dynamic orderCanceledReason;
  final dynamic couponCode;
  final dynamic couponAmount;
  final String deliveryPartner;
  final dynamic deliveryOrderId;
  final dynamic deliveryChannelId;
  final dynamic deliveryShipmentId;

  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
      id: json["id"] ?? 0,
      customerId: json["customer_id"] ?? 0,
      serviceId: json["service_id"] ?? 0,
      type: json["type"] ?? "",
      leadsId: json["leads_id"] ?? 0,
      packageId: json["package_id"],
      indivisual: json["indivisual"] ?? 0,
      packagePrice: json["package_price"] ?? "",
      panditAssign: json["pandit_assign"] ?? "",
      paymentId: json["payment_id"] ?? "",
      walletTranslationId: json["wallet_translation_id"],
      transectionAmount: json["transection_amount"] ?? 0,
      walletAmount: json["wallet_amount"] ?? 0,
      orderId: json["order_id"] ?? "",
      payAmount: json["pay_amount"] ?? 0,
      newphone: json["newphone"],
      members: json["members"],
      gotra: json["gotra"],
      isPrashad: json["is_prashad"] ?? 0,
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"],
      houseNo: json["house_no"],
      area: json["area"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      landmark: json["landmark"],
      prashadStatus: json["prashad_status"] ?? 0,
      paymentStatus: json["payment_status"] ?? "",
      bookingDate: json["booking_date"],
      status: json["status"] ?? 0,
      counsellingReport: json["counselling_report"],
      counsellingReportVerified: json["counselling_report_verified"] ?? 0,
      counsellingReportRejectReason: json["counselling_report_reject_reason"],
      checked: json["checked"] ?? 0,
      orderStatus: json["order_status"] ?? 0,
      isEdited: json["is_edited"] ?? 0,
      isRejected: json["is_rejected"] ?? 0,
      isBlock: json["is_block"] ?? 0,
      isCompleted: json["is_completed"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      scheduleTime: json["schedule_time"],
      scheduleCreated: json["schedule_created"],
      liveStream: json["live_stream"],
      liveCreatedStream: json["live_created_stream"],
      poojaVideo: json["pooja_video"],
      videoCreatedSharing: json["video_created_sharing"],
      rejectReason: json["reject_reason"],
      poojaCertificate: json["pooja_certificate"],
      orderCompleted: json["order_completed"],
      orderCanceled: json["order_canceled"],
      orderCanceledReason: json["order_canceled_reason"],
      couponCode: json["coupon_code"],
      couponAmount: json["coupon_amount"],
      deliveryPartner: json["delivery_partner"] ?? "",
      deliveryOrderId: json["delivery_order_id"],
      deliveryChannelId: json["delivery_channel_id"],
      deliveryShipmentId: json["delivery_shipment_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "service_id": serviceId,
    "type": type,
    "leads_id": leadsId,
    "package_id": packageId,
    "indivisual": indivisual,
    "package_price": packagePrice,
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
    "is_prashad": isPrashad,
    "city": city,
    "state": state,
    "pincode": pincode,
    "house_no": houseNo,
    "area": area,
    "latitude": latitude,
    "longitude": longitude,
    "landmark": landmark,
    "prashad_status": prashadStatus,
    "payment_status": paymentStatus,
    "booking_date": bookingDate,
    "status": status,
    "counselling_report": counsellingReport,
    "counselling_report_verified": counsellingReportVerified,
    "counselling_report_reject_reason": counsellingReportRejectReason,
    "checked": checked,
    "order_status": orderStatus,
    "is_edited": isEdited,
    "is_rejected": isRejected,
    "is_block": isBlock,
    "is_completed": isCompleted,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "schedule_time": scheduleTime,
    "schedule_created": scheduleCreated,
    "live_stream": liveStream,
    "live_created_stream": liveCreatedStream,
    "pooja_video": poojaVideo,
    "video_created_sharing": videoCreatedSharing,
    "reject_reason": rejectReason,
    "pooja_certificate": poojaCertificate,
    "order_completed": orderCompleted,
    "order_canceled": orderCanceled,
    "order_canceled_reason": orderCanceledReason,
    "coupon_code": couponCode,
    "coupon_amount": couponAmount,
    "delivery_partner": deliveryPartner,
    "delivery_order_id": deliveryOrderId,
    "delivery_channel_id": deliveryChannelId,
    "delivery_shipment_id": deliveryShipmentId,
  };

}

class SankalpData {
  SankalpData({
    required this.orderId,
    required this.name,
    required this.gender,
    required this.mobile,
    required this.dob,
    required this.time,
    required this.country,
    required this.city,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.translations,
  });

  final String orderId;
  final String name;
  final String gender;
  final String mobile;
  final DateTime? dob;
  final String time;
  final String country;
  final String city;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int id;
  final List<dynamic> translations;

  factory SankalpData.fromJson(Map<String, dynamic> json){
    return SankalpData(
      orderId: json["order_id"] ?? "",
      name: json["name"] ?? "",
      gender: json["gender"] ?? "",
      mobile: json["mobile"] ?? "",
      dob: DateTime.tryParse(json["dob"] ?? ""),
      time: json["time"] ?? "",
      country: json["country"] ?? "",
      city: json["city"] ?? "",
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      id: json["id"] ?? 0,
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "name": name,
    "gender": gender,
    "mobile": mobile,
    "dob": "${dob!.year.toString().padLeft(4,'0')}-${dob!.month.toString().padLeft(2,'0')}-${dob!.day.toString().padLeft(2,'0')}",
    "time": time,
    "country": country,
    "city": city,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "translations": translations.map((x) => x).toList(),
  };

}
