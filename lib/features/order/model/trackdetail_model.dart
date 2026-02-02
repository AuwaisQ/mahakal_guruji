import 'dart:convert';

TrackDetailModel trackDetailModelFromJson(String str) =>
    TrackDetailModel.fromJson(json.decode(str));

String trackDetailModelToJson(TrackDetailModel data) =>
    json.encode(data.toJson());

class TrackDetailModel {
  bool? success;
  Order? order;
  int? isReview;
  String? refundDayLimit;
  DateTime? currentDate;

  TrackDetailModel({
    this.success,
    this.order,
    this.isReview,
    this.refundDayLimit,
    this.currentDate,
  });

  factory TrackDetailModel.fromJson(Map<String, dynamic> json) =>
      TrackDetailModel(
        success: json['success'],
        order: json['order'] == null ? null : Order.fromJson(json['order']),
        isReview: json['is_review'],
        refundDayLimit: json['refund_day_limit'],
        currentDate: json['current_date'] == null
            ? null
            : DateTime.parse(json['current_date']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'order': order?.toJson(),
        'is_review': isReview,
        'refund_day_limit': refundDayLimit,
        'current_date': currentDate?.toIso8601String(),
      };
}

class Order {
  int? id;
  int? customerId;
  int? serviceId;
  String? type;
  int? leadsId;
  String? packageId;
  String? packagePrice;
  dynamic panditAssign;
  String? paymentId;
  String? walletTranslationId;
  dynamic transectionAmount;
  dynamic walletAmount;
  String? orderId;
  dynamic payAmount;
  String? newphone;
  String? members;
  String? gotra;
  int? isPrashad;
  dynamic city;
  dynamic state;
  dynamic pincode;
  dynamic houseNo;
  dynamic area;
  dynamic landmark;
  int? prashadStatus;
  String? paymentStatus;
  DateTime? bookingDate;
  String? status;
  dynamic counsellingReport;
  int? counsellingReportVerified;
  int? checked;
  String? orderStatus;
  int? isEdited;
  int? isRejected;
  int? isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic scheduleTime;
  dynamic scheduleCreated;
  dynamic liveStream;
  dynamic liveCreatedStream;
  dynamic poojaVideo;
  dynamic videoCreatedSharing;
  dynamic rejectReason;
  dynamic poojaCertificate;
  dynamic orderCompleted;
  dynamic orderCanceled;
  dynamic orderCanceledReason;
  dynamic couponCode;
  dynamic couponAmount;
  String? deliveryPartner;
  dynamic deliveryOrderId;
  dynamic deliveryChannelId;
  dynamic deliveryShipmentId;
  Customer? customer;
  CounsellingUser? counsellingUser;
  Leads? leads;
  Services? services;
  Packages? packages;
  dynamic payments;
  Pandit? pandit;
  List<ProductLead>? productLeads;

  Order({
    this.id,
    this.customerId,
    this.serviceId,
    this.type,
    this.leadsId,
    this.packageId,
    this.packagePrice,
    this.panditAssign,
    this.paymentId,
    this.walletTranslationId,
    this.transectionAmount,
    this.walletAmount,
    this.orderId,
    this.payAmount,
    this.newphone,
    this.members,
    this.gotra,
    this.isPrashad,
    this.city,
    this.state,
    this.pincode,
    this.houseNo,
    this.area,
    this.landmark,
    this.prashadStatus,
    this.paymentStatus,
    this.bookingDate,
    this.status,
    this.counsellingReport,
    this.counsellingReportVerified,
    this.checked,
    this.orderStatus,
    this.isEdited,
    this.isRejected,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
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
    this.couponCode,
    this.couponAmount,
    this.deliveryPartner,
    this.deliveryOrderId,
    this.deliveryChannelId,
    this.deliveryShipmentId,
    this.customer,
    this.counsellingUser,
    this.leads,
    this.services,
    this.packages,
    this.payments,
    this.pandit,
    this.productLeads,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        customerId: json['customer_id'],
        serviceId: json['service_id'],
        type: json['type'],
        leadsId: json['leads_id'],
        packageId: json['package_id'],
        packagePrice: json['package_price'],
        panditAssign: json['pandit_assign'],
        paymentId: json['payment_id'],
        walletTranslationId: json['wallet_translation_id'],
        transectionAmount: json['transection_amount'],
        walletAmount: json['wallet_amount'],
        orderId: json['order_id'],
        payAmount: json['pay_amount'],
        newphone: json['newphone'],
        members: json['members'],
        gotra: json['gotra'],
        isPrashad: json['is_prashad'],
        city: json['city'],
        state: json['state'],
        pincode: json['pincode'],
        houseNo: json['house_no'],
        area: json['area'],
        landmark: json['landmark'],
        prashadStatus: json['prashad_status'],
        paymentStatus: json['payment_status'],
        bookingDate: json['booking_date'] == null
            ? null
            : DateTime.parse(json['booking_date']),
        status: json['status'],
        counsellingReport: json['counselling_report'],
        counsellingReportVerified: json['counselling_report_verified'],
        checked: json['checked'],
        orderStatus: json['order_status'],
        isEdited: json['is_edited'],
        isRejected: json['is_rejected'],
        isCompleted: json['is_completed'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        scheduleTime: json['schedule_time'],
        scheduleCreated: json['schedule_created'],
        liveStream: json['live_stream'],
        liveCreatedStream: json['live_created_stream'],
        poojaVideo: json['pooja_video'],
        videoCreatedSharing: json['video_created_sharing'],
        rejectReason: json['reject_reason'],
        poojaCertificate: json['pooja_certificate'],
        orderCompleted: json['order_completed'],
        orderCanceled: json['order_canceled'],
        orderCanceledReason: json['order_canceled_reason'],
        couponCode: json['coupon_code'],
        couponAmount: json['coupon_amount'],
        deliveryPartner: json['delivery_partner'],
        deliveryOrderId: json['delivery_order_id'],
        deliveryChannelId: json['delivery_channel_id'],
        deliveryShipmentId: json['delivery_shipment_id'],
        customer: json['customer'] == null
            ? null
            : Customer.fromJson(json['customer']),
        counsellingUser: json['counselling_user'] == null
            ? null
            : CounsellingUser.fromJson(json['counselling_user']),
        leads: json['leads'] == null ? null : Leads.fromJson(json['leads']),
        services: json['services'] == null
            ? Services.fromJson(json['vippoojas'])
            : Services.fromJson(json['services']),
        packages: json['packages'] == null
            ? null
            : Packages.fromJson(json['packages']),
        payments: json['payments'],
        pandit: json['pandit'] == null ? null : Pandit.fromJson(json['pandit']),
        productLeads: json['product_leads'] == null
            ? []
            : List<ProductLead>.from(
                json['product_leads']!.map((x) => ProductLead.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'service_id': serviceId,
        'type': type,
        'leads_id': leadsId,
        'package_id': packageId,
        'package_price': packagePrice,
        'pandit_assign': panditAssign,
        'payment_id': paymentId,
        'wallet_translation_id': walletTranslationId,
        'transection_amount': transectionAmount,
        'wallet_amount': walletAmount,
        'order_id': orderId,
        'pay_amount': payAmount,
        'newphone': newphone,
        'members': members,
        'gotra': gotra,
        'is_prashad': isPrashad,
        'city': city,
        'state': state,
        'pincode': pincode,
        'house_no': houseNo,
        'area': area,
        'landmark': landmark,
        'prashad_status': prashadStatus,
        'payment_status': paymentStatus,
        'booking_date':
            "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        'status': status,
        'counselling_report': counsellingReport,
        'counselling_report_verified': counsellingReportVerified,
        'checked': checked,
        'order_status': orderStatus,
        'is_edited': isEdited,
        'is_rejected': isRejected,
        'is_completed': isCompleted,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'schedule_time': scheduleTime,
        'schedule_created': scheduleCreated,
        'live_stream': liveStream,
        'live_created_stream': liveCreatedStream,
        'pooja_video': poojaVideo,
        'video_created_sharing': videoCreatedSharing,
        'reject_reason': rejectReason,
        'pooja_certificate': poojaCertificate,
        'order_completed': orderCompleted,
        'order_canceled': orderCanceled,
        'order_canceled_reason': orderCanceledReason,
        'coupon_code': couponCode,
        'coupon_amount': couponAmount,
        'delivery_partner': deliveryPartner,
        'delivery_order_id': deliveryOrderId,
        'delivery_channel_id': deliveryChannelId,
        'delivery_shipment_id': deliveryShipmentId,
        'customer': customer?.toJson(),
        'CounsellingUser': counsellingUser?.toJson(),
        'leads': leads?.toJson(),
        'services': services?.toJson(),
        'packages': packages?.toJson(),
        'payments': payments,
        'pandit': pandit?.toJson(),
        'product_leads': productLeads == null
            ? []
            : List<dynamic>.from(productLeads!.map((x) => x.toJson())),
      };
}

class Customer {
  int? id;
  String? name;
  String? email;
  String? phone;

  Customer({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };
}

class Leads {
  int? id;
  int? serviceId;
  dynamic leadno;
  dynamic orderId;
  String? type;
  int? packageId;
  String? productId;
  String? packageName;
  String? noperson;
  String? packagePrice;
  String? personName;
  String? personPhone;
  DateTime? bookingDate;
  String? paymentStatus;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? translations;

  Leads({
    this.id,
    this.serviceId,
    this.leadno,
    this.orderId,
    this.type,
    this.packageId,
    this.productId,
    this.packageName,
    this.noperson,
    this.packagePrice,
    this.personName,
    this.personPhone,
    this.bookingDate,
    this.paymentStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.translations,
  });

  factory Leads.fromJson(Map<String, dynamic> json) => Leads(
        id: json['id'],
        serviceId: json['service_id'],
        leadno: json['leadno'],
        orderId: json['order_id'],
        type: json['type'],
        packageId: json['package_id'],
        productId: json['product_id'],
        packageName: json['package_name'],
        noperson: json['noperson'],
        packagePrice: json['package_price'],
        personName: json['person_name'],
        personPhone: json['person_phone'],
        bookingDate: json['booking_date'] == null
            ? null
            : DateTime.parse(json['booking_date']),
        paymentStatus: json['payment_status'],
        status: json['status'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        translations: json['translations'] == null
            ? []
            : List<dynamic>.from(json['translations']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_id': serviceId,
        'leadno': leadno,
        'order_id': orderId,
        'type': type,
        'package_id': packageId,
        'product_id': productId,
        'package_name': packageName,
        'noperson': noperson,
        'package_price': packagePrice,
        'person_name': personName,
        'person_phone': personPhone,
        'booking_date': bookingDate?.toIso8601String(),
        'payment_status': paymentStatus,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'translations': translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class Packages {
  int? id;
  String? title;
  String? slug;
  int? person;
  String? color;
  String? description;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? translations;

  Packages({
    this.id,
    this.title,
    this.slug,
    this.person,
    this.color,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.translations,
  });

  factory Packages.fromJson(Map<String, dynamic> json) => Packages(
        id: json['id'],
        title: json['title'],
        slug: json['slug'],
        person: json['person'],
        color: json['color'],
        description: json['description'],
        status: json['status'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        translations: json['translations'] == null
            ? []
            : List<dynamic>.from(json['translations']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'person': person,
        'color': color,
        'description': description,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'translations': translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class CounsellingUser {
  int? id;
  String? orderId;
  String? name;
  String? gender;
  String? mobile;
  String? dob;
  String? time;
  String? country;
  String? city;
  int? isUpdate;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? translations;

  CounsellingUser({
    this.id,
    this.orderId,
    this.name,
    this.gender,
    this.mobile,
    this.dob,
    this.time,
    this.country,
    this.city,
    this.isUpdate,
    this.createdAt,
    this.updatedAt,
    this.translations,
  });

  factory CounsellingUser.fromJson(Map<String, dynamic> json) =>
      CounsellingUser(
        id: json['id'],
        orderId: json['order_id'],
        name: json['name'],
        gender: json['gender'],
        mobile: json['mobile'],
        dob: json['dob'],
        time: json['time'],
        country: json['country'],
        city: json['city'],
        isUpdate: json['is_update'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        translations: json['translations'] == null
            ? []
            : List<dynamic>.from(json['translations']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'name': name,
        'gender': gender,
        'mobile': mobile,
        'dob': dob,
        'time': time,
        'country': country,
        'city': city,
        'is_update': isUpdate,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'translations': translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class ProductLead {
  int? id;
  int? leadsId;
  String? finalPrice;
  String? qty;
  String? productName;
  String? productPrice;

  ProductLead({
    this.id,
    this.leadsId,
    this.finalPrice,
    this.qty,
    this.productName,
    this.productPrice,
  });

  factory ProductLead.fromJson(Map<String, dynamic> json) => ProductLead(
        id: json['id'],
        leadsId: json['leads_id'],
        finalPrice: json['final_price'],
        qty: json['qty'],
        productName: json['product_name'],
        productPrice: json['product_price'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'leads_id': leadsId,
        'final_price': finalPrice,
        'qty': qty,
        'product_name': productName,
        'product_price': productPrice,
      };
}

class Services {
  int? id;
  String? name;
  String? thumbnail;
  String? hiName;
  List<dynamic>? translations;

  Services({
    this.id,
    this.name,
    this.thumbnail,
    this.hiName,
    this.translations,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        id: json['id'],
        name: json['name'],
        thumbnail: json['thumbnail'],
        hiName: json['hi_name'],
        translations: json['translations'] == null
            ? []
            : List<dynamic>.from(json['translations']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'thumbnail': thumbnail,
        'hi_name': hiName,
        'translations': translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
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
        id: json['id'],
        name: json['name'],
        email: json['email'],
        mobileNo: json['mobile_no'],
        ordercount: json['ordercount'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile_no': mobileNo,
        'ordercount': ordercount,
      };
}
