// To parse this JSON data, do
//
//     final oflineTrackdetailModel = oflineTrackdetailModelFromJson(jsonString);

import 'dart:convert';

OflineTrackdetailModel oflineTrackdetailModelFromJson(String str) =>
    OflineTrackdetailModel.fromJson(json.decode(str));

String oflineTrackdetailModelToJson(OflineTrackdetailModel data) =>
    json.encode(data.toJson());

class OflineTrackdetailModel {
  bool? success;
  Order? order;
  dynamic isReview;
  DateTime? currentDate;

  OflineTrackdetailModel({
    this.success,
    this.order,
    this.isReview,
    this.currentDate,
  });

  factory OflineTrackdetailModel.fromJson(Map<String, dynamic> json) =>
      OflineTrackdetailModel(
        success: json["success"],
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
        isReview: json["is_review"],
        currentDate: json["current_date"] == null
            ? null
            : DateTime.parse(json["current_date"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "order": order?.toJson(),
        "is_review": isReview,
        "current_date": currentDate?.toIso8601String(),
      };
}

class Order {
  int? id;
  int? customerId;
  int? serviceId;
  int? type;
  int? leadsId;
  int? packageId;
  String? packageMainPrice;
  String? packagePrice;
  String? panditAssign;
  String? paymentId;
  dynamic walletTranslationId;
  int? transectionAmount;
  int? walletAmount;
  String? orderId;
  String? payAmount;
  int? remainAmount;
  int? remainAmountStatus;
  int? scheduleStatus;
  dynamic scheduleAmount;
  dynamic newPhone;
  String? poojaMethod;
  String? poojaVenueType;
  int? templeId;
  String? city;
  String? state;
  String? pincode;
  String? venueAddress;
  double? latitude;
  double? longitude;
  String? landmark;
  int? paymentStatus;
  String? bookingDate;
  int? checked;
  String? status;
  int? isBlock;
  int? isEdited;
  dynamic timeSchedule;
  dynamic liveUrl;
  DateTime? orderCompleted;
  dynamic orderCanceled;
  dynamic orderCanceledReason;
  dynamic canceledBy;
  int? refundStatus;
  int? refundAmount;
  dynamic couponCode;
  dynamic couponAmount;
  String? poojaCertificate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Customer? customer;
  List<City>? cities;
  Leads? leads;
  Offlinepooja? offlinepooja;
  Package? package;
  dynamic payments;
  Pandit? pandit;
  TempleDetails? templeDetails;

  Order({
    this.id,
    this.customerId,
    this.serviceId,
    this.type,
    this.leadsId,
    this.packageId,
    this.packageMainPrice,
    this.packagePrice,
    this.panditAssign,
    this.paymentId,
    this.walletTranslationId,
    this.transectionAmount,
    this.walletAmount,
    this.orderId,
    this.payAmount,
    this.remainAmount,
    this.remainAmountStatus,
    this.scheduleStatus,
    this.scheduleAmount,
    this.newPhone,
    this.poojaMethod,
    this.poojaVenueType,
    this.templeId,
    this.city,
    this.state,
    this.pincode,
    this.venueAddress,
    this.latitude,
    this.longitude,
    this.landmark,
    this.paymentStatus,
    this.bookingDate,
    this.checked,
    this.status,
    this.isBlock,
    this.isEdited,
    this.timeSchedule,
    this.liveUrl,
    this.orderCompleted,
    this.orderCanceled,
    this.orderCanceledReason,
    this.canceledBy,
    this.refundStatus,
    this.refundAmount,
    this.couponCode,
    this.couponAmount,
    this.poojaCertificate,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.cities,
    this.leads,
    this.offlinepooja,
    this.package,
    this.payments,
    this.pandit,
    this.templeDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        customerId: json["customer_id"],
        serviceId: json["service_id"],
        type: json["type"],
        leadsId: json["leads_id"],
        packageId: json["package_id"],
        packageMainPrice: json["package_main_price"],
        packagePrice: json["package_price"],
        panditAssign: json["pandit_assign"],
        paymentId: json["payment_id"],
        walletTranslationId: json["wallet_translation_id"],
        transectionAmount: json["transection_amount"],
        walletAmount: json["wallet_amount"],
        orderId: json["order_id"],
        payAmount: json["pay_amount"],
        remainAmount: json["remain_amount"],
        remainAmountStatus: json["remain_amount_status"],
        scheduleStatus: json["schedule_status"],
        scheduleAmount: json["schedule_amount"],
        newPhone: json["new_phone"],
        poojaMethod: json["pooja_method"],
        poojaVenueType: json["pooja_venue_type"],
        templeId: json["temple_id"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        venueAddress: json["venue_address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        landmark: json["landmark"],
        paymentStatus: json["payment_status"],
        bookingDate: json["booking_date"],
        checked: json["checked"],
        status: json["status"],
        isBlock: json["is_block"],
        isEdited: json["is_edited"],
        timeSchedule: json["time_schedule"],
        liveUrl: json["live_url"],
        orderCompleted: json["order_completed"] == null
            ? null
            : DateTime.parse(json["order_completed"]),
        orderCanceled: json["order_canceled"],
        orderCanceledReason: json["order_canceled_reason"],
        canceledBy: json["canceled_by"],
        refundStatus: json["refund_status"],
        refundAmount: json["refund_amount"],
        couponCode: json["coupon_code"],
        couponAmount: json["coupon_amount"],
        poojaCertificate: json["pooja_certificate"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        cities: json["cities"] == null
            ? []
            : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
        leads: json["leads"] == null ? null : Leads.fromJson(json["leads"]),
        offlinepooja: json["offlinepooja"] == null
            ? null
            : Offlinepooja.fromJson(json["offlinepooja"]),
        package:
            json["package"] == null ? null : Package.fromJson(json["package"]),
        payments: json["payments"],
        pandit: json["pandit"] == null ? null : Pandit.fromJson(json["pandit"]),
        templeDetails: json["temple"] == null
            ? null
            : TempleDetails.fromJson(json["temple"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "service_id": serviceId,
        "type": type,
        "leads_id": leadsId,
        "package_id": packageId,
        "package_main_price": packageMainPrice,
        "package_price": packagePrice,
        "pandit_assign": panditAssign,
        "payment_id": paymentId,
        "wallet_translation_id": walletTranslationId,
        "transection_amount": transectionAmount,
        "wallet_amount": walletAmount,
        "order_id": orderId,
        "pay_amount": payAmount,
        "remain_amount": remainAmount,
        "remain_amount_status": remainAmountStatus,
        "schedule_status": scheduleStatus,
        "schedule_amount": scheduleAmount,
        "new_phone": newPhone,
        "pooja_method": poojaMethod,
        "pooja_venue_type": poojaVenueType,
        "temple_id": templeId,
        "city": city,
        "state": state,
        "pincode": pincode,
        "venue_address": venueAddress,
        "latitude": latitude,
        "longitude": longitude,
        "landmark": landmark,
        "payment_status": paymentStatus,
        "booking_date": bookingDate,
        "checked": checked,
        "status": status,
        "is_block": isBlock,
        "is_edited": isEdited,
        "time_schedule": timeSchedule,
        "live_url": liveUrl,
        "order_completed": orderCompleted?.toIso8601String(),
        "order_canceled": orderCanceled,
        "order_canceled_reason": orderCanceledReason,
        "canceled_by": canceledBy,
        "refund_status": refundStatus,
        "refund_amount": refundAmount,
        "coupon_code": couponCode,
        "coupon_amount": couponAmount,
        "pooja_certificate": poojaCertificate,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customer": customer?.toJson(),
        "cities": cities == null
            ? []
            : List<dynamic>.from(cities!.map((x) => x.toJson())),
        "leads": leads?.toJson(),
        "offlinepooja": offlinepooja?.toJson(),
        "package": package?.toJson(),
        "payments": payments,
        "pandit": pandit?.toJson(),
        "templeDetails": templeDetails?.toJson(),
      };
}

class City {
  int? id;
  String? name;
  List<dynamic>? translations;

  City({
    this.id,
    this.name,
    this.translations,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
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
  int? id;
  int? poojaId;
  String? leadNo;
  String? orderId;
  int? packageId;
  String? packageName;
  int? noperson;
  String? packageMainPrice;
  String? packagePrice;
  String? personName;
  String? personPhone;
  String? paymentStatus;
  int? status;
  dynamic bookingDate;
  int? finalAmount;
  int? remainAmount;
  int? viaWallet;
  int? viaOnline;
  int? couponAmount;
  dynamic platform;
  String? paymentType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Leads({
    this.id,
    this.poojaId,
    this.leadNo,
    this.orderId,
    this.packageId,
    this.packageName,
    this.noperson,
    this.packageMainPrice,
    this.packagePrice,
    this.personName,
    this.personPhone,
    this.paymentStatus,
    this.status,
    this.bookingDate,
    this.finalAmount,
    this.remainAmount,
    this.viaWallet,
    this.viaOnline,
    this.couponAmount,
    this.platform,
    this.paymentType,
    this.createdAt,
    this.updatedAt,
  });

  factory Leads.fromJson(Map<String, dynamic> json) => Leads(
        id: json["id"],
        poojaId: json["pooja_id"],
        leadNo: json["lead_no"],
        orderId: json["order_id"],
        packageId: json["package_id"],
        packageName: json["package_name"],
        noperson: json["noperson"],
        packageMainPrice: json["package_main_price"],
        packagePrice: json["package_price"],
        personName: json["person_name"],
        personPhone: json["person_phone"],
        paymentStatus: json["payment_status"],
        status: json["status"],
        bookingDate: json["booking_date"],
        finalAmount: json["final_amount"],
        remainAmount: json["remain_amount"],
        viaWallet: json["via_wallet"],
        viaOnline: json["via_online"],
        couponAmount: json["coupon_amount"],
        platform: json["platform"],
        paymentType: json["payment_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pooja_id": poojaId,
        "lead_no": leadNo,
        "order_id": orderId,
        "package_id": packageId,
        "package_name": packageName,
        "noperson": noperson,
        "package_main_price": packageMainPrice,
        "package_price": packagePrice,
        "person_name": personName,
        "person_phone": personPhone,
        "payment_status": paymentStatus,
        "status": status,
        "booking_date": bookingDate,
        "final_amount": finalAmount,
        "remain_amount": remainAmount,
        "via_wallet": viaWallet,
        "via_online": viaOnline,
        "coupon_amount": couponAmount,
        "platform": platform,
        "payment_type": paymentType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Offlinepooja {
  int? id;
  String? name;
  String? thumbnail;
  String? hiName;
  List<dynamic>? translations;

  Offlinepooja({
    this.id,
    this.name,
    this.thumbnail,
    this.hiName,
    this.translations,
  });

  factory Offlinepooja.fromJson(Map<String, dynamic> json) => Offlinepooja(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        hiName: json["hi_name"],
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "hi_name": hiName,
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class Package {
  int? id;
  String? title;
  String? slug;
  String? type;
  int? person;
  String? color;
  String? image;
  String? description;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? translations;

  Package({
    this.id,
    this.title,
    this.slug,
    this.type,
    this.person,
    this.color,
    this.image,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.translations,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        type: json["type"],
        person: json["person"],
        color: json["color"],
        image: json["image"],
        description: json["description"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        translations: json["translations"] == null
            ? []
            : List<dynamic>.from(json["translations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "type": type,
        "person": person,
        "color": color,
        "image": image,
        "description": description,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x)),
      };
}

class Pandit {
  int? id;
  String? name;
  String? email;
  String? mobileNo;
  String? image;
  int? ordercount;

  Pandit({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.image,
    this.ordercount,
  });

  factory Pandit.fromJson(Map<String, dynamic> json) => Pandit(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobileNo: json["mobile_no"],
        image: json["image"],
        ordercount: json["ordercount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile_no": mobileNo,
        "image": image,
        "ordercount": ordercount,
      };
}

class TempleDetails {
  int id;
  int userId;
  String addedBy;
  String name;
  int categoryId;
  String slug;
  String shortDescription;
  String details;
  String moreDetails;
  int countryId;
  String stateId;
  String cityId;
  String entryFee;
  String openingTime;
  String closeingTime;
  String vipPlans;
  String facilities;
  String tipsRestrictions;
  String requireTime;
  String videoProvider;
  dynamic videoUrl;
  String thumbnail;
  String metaTitle;
  String metaDescription;
  String metaImage;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String images;
  String latitude;
  String longitude;
  String expectDetails;
  String tipsDetails;
  String templeKnown;
  String templeServices;
  String? packageService;
  String templeAarti;
  String touristPlace;
  String templeLocalFood;
  dynamic trustId;
  int aadhaarVerifyStatus;
  List<dynamic> translations;

  TempleDetails({
    required this.id,
    required this.userId,
    required this.addedBy,
    required this.name,
    required this.categoryId,
    required this.slug,
    required this.shortDescription,
    required this.details,
    required this.moreDetails,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.entryFee,
    required this.openingTime,
    required this.closeingTime,
    required this.vipPlans,
    required this.facilities,
    required this.tipsRestrictions,
    required this.requireTime,
    required this.videoProvider,
    required this.videoUrl,
    required this.thumbnail,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.expectDetails,
    required this.tipsDetails,
    required this.templeKnown,
    required this.templeServices,
    required this.packageService,
    required this.templeAarti,
    required this.touristPlace,
    required this.templeLocalFood,
    required this.trustId,
    required this.aadhaarVerifyStatus,
    required this.translations,
  });

  factory TempleDetails.fromJson(Map<String, dynamic> json) => TempleDetails(
        id: json["id"],
        userId: json["user_id"],
        addedBy: json["added_by"],
        name: json["name"],
        categoryId: json["category_id"],
        slug: json["slug"],
        shortDescription: json["short_description"],
        details: json["details"],
        moreDetails: json["more_details"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        entryFee: json["entry_fee"],
        openingTime: json["opening_time"],
        closeingTime: json["closeing_time"],
        vipPlans: json["vip_plans"],
        facilities: json["facilities"],
        tipsRestrictions: json["tips_restrictions"],
        requireTime: json["require_time"],
        videoProvider: json["video_provider"],
        videoUrl: json["video_url"],
        thumbnail: json["thumbnail"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaImage: json["meta_image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        images: json["images"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        expectDetails: json["expect_details"],
        tipsDetails: json["tips_details"],
        templeKnown: json["temple_known"],
        templeServices: json["temple_services"],
        packageService: json["package_service"],
        templeAarti: json["temple_aarti"],
        touristPlace: json["tourist_place"],
        templeLocalFood: json["temple_local_food"],
        trustId: json["trust_id"],
        aadhaarVerifyStatus: json["aadhaar_verify_status"],
        translations: List<dynamic>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "added_by": addedBy,
        "name": name,
        "category_id": categoryId,
        "slug": slug,
        "short_description": shortDescription,
        "details": details,
        "more_details": moreDetails,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "entry_fee": entryFee,
        "opening_time": openingTime,
        "closeing_time": closeingTime,
        "vip_plans": vipPlans,
        "facilities": facilities,
        "tips_restrictions": tipsRestrictions,
        "require_time": requireTime,
        "video_provider": videoProvider,
        "video_url": videoUrl,
        "thumbnail": thumbnail,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_image": metaImage,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "images": images,
        "latitude": latitude,
        "longitude": longitude,
        "expect_details": expectDetails,
        "tips_details": tipsDetails,
        "temple_known": templeKnown,
        "temple_services": templeServices,
        "package_service": packageService,
        "temple_aarti": templeAarti,
        "tourist_place": touristPlace,
        "temple_local_food": templeLocalFood,
        "trust_id": trustId,
        "aadhaar_verify_status": aadhaarVerifyStatus,
        "translations": List<dynamic>.from(translations.map((x) => x)),
      };
}
