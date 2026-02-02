// // To parse this JSON data, do
// //
// //     final offlinePoojaModel = offlinePoojaModelFromJson(jsonString);
//
// import 'dart:convert';
//
// OfflinePoojaModel offlinePoojaModelFromJson(String str) => OfflinePoojaModel.fromJson(json.decode(str));
//
// String offlinePoojaModelToJson(OfflinePoojaModel data) => json.encode(data.toJson());
//
// class OfflinePoojaModel {
//   bool status;
//   String message;
//   List<Offlinelist> offlinelist;
//
//   OfflinePoojaModel({
//     required this.status,
//     required this.message,
//     required this.offlinelist,
//   });
//
//   factory OfflinePoojaModel.fromJson(Map<String, dynamic> json) => OfflinePoojaModel(
//     status: json["status"],
//     message: json["message"],
//     offlinelist: List<Offlinelist>.from(json["offlinelist"].map((x) => Offlinelist.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "offlinelist": List<dynamic>.from(offlinelist.map((x) => x.toJson())),
//   };
// }
//
// class Offlinelist {
//   int id;
//   int serviceId;
//   String orderId;
//   String poojaPrice;
//   String payAmount;
//   String status;
//   String? bookingDate;
//   Services services;
//   DateTime createdAt;
//
//   Offlinelist({
//     required this.id,
//     required this.serviceId,
//     required this.orderId,
//     required this.poojaPrice,
//     required this.payAmount,
//     required this.status,
//     required this.bookingDate,
//     required this.services,
//     required this.createdAt,
//   });
//
//   factory Offlinelist.fromJson(Map<String, dynamic> json) => Offlinelist(
//     id: json["id"],
//     serviceId: json["service_id"],
//     orderId: json["order_id"],
//     poojaPrice: json["pooja_price"],
//     payAmount: json["pay_amount"],
//     status: json["status"],
//     bookingDate: json["booking_date"],
//     services: Services.fromJson(json["services"]),
//     createdAt: DateTime.parse(json["created_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "service_id": serviceId,
//     "order_id": orderId,
//     "pooja_price": poojaPrice,
//     "pay_amount": payAmount,
//     "status": status,
//     "booking_date": bookingDate,
//     "services": services.toJson(),
//     "created_at": createdAt.toIso8601String(),
//   };
// }
//
// class Services {
//   int id;
//   String name;
//   String slug;
//   String type;
//   String shortBenifits;
//   String details;
//   String benefits;
//   String process;
//   String termsConditions;
//   String packageDetails;
//   String thumbnail;
//   String images;
//   String videoUrl;
//   String metaTitle;
//   String metaDescription;
//   String metaImage;
//   int status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<dynamic> translations;
//   String hiName;
//
//   Services({
//     required this.id,
//     required this.name,
//     required this.slug,
//     required this.type,
//     required this.shortBenifits,
//     required this.details,
//     required this.benefits,
//     required this.process,
//     required this.termsConditions,
//     required this.packageDetails,
//     required this.thumbnail,
//     required this.images,
//     required this.videoUrl,
//     required this.metaTitle,
//     required this.metaDescription,
//     required this.metaImage,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.translations,
//     required this.hiName,
//   });
//
//   factory Services.fromJson(Map<String, dynamic> json) => Services(
//     id: json["id"],
//     name: json["name"],
//     slug: json["slug"],
//     type: json["type"],
//     shortBenifits: json["short_benifits"],
//     details: json["details"],
//     benefits: json["benefits"],
//     process: json["process"],
//     termsConditions: json["terms_conditions"],
//     packageDetails: json["package_details"],
//     thumbnail: json["thumbnail"],
//     images: json["images"],
//     videoUrl: json["video_url"],
//     metaTitle: json["meta_title"],
//     metaDescription: json["meta_description"],
//     metaImage: json["meta_image"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     translations: List<dynamic>.from(json["translations"].map((x) => x)),
//     hiName: json["hi_name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "slug": slug,
//     "type": type,
//     "short_benifits": shortBenifits,
//     "details": details,
//     "benefits": benefits,
//     "process": process,
//     "terms_conditions": termsConditions,
//     "package_details": packageDetails,
//     "thumbnail": thumbnail,
//     "images": images,
//     "video_url": videoUrl,
//     "meta_title": metaTitle,
//     "meta_description": metaDescription,
//     "meta_image": metaImage,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "translations": List<dynamic>.from(translations.map((x) => x)),
//     "hi_name": hiName,
//   };
// }
//

class OfflinePoojaModel {
  OfflinePoojaModel({
    required this.status,
    required this.message,
    required this.orders,
  });

  final bool status;
  final String message;
  final List<Offlinelist> orders;

  factory OfflinePoojaModel.fromJson(Map<String, dynamic> json) {
    return OfflinePoojaModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      orders: json["orders"] == null
          ? []
          : List<Offlinelist>.from(
              json["orders"]!.map((x) => Offlinelist.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "orders": orders.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$status, $message, $orders, ";
  }
}

class Offlinelist {
  Offlinelist({
    required this.id,
    required this.serviceId,
    required this.orderId,
    required this.poojaPrice,
    required this.payAmount,
    required this.status,
    required this.bookingDate,
    required this.services,
    required this.createdAt,
  });

  final int id;
  final int serviceId;
  final String orderId;
  final String poojaPrice;
  final String payAmount;
  final String status;
  final DateTime? bookingDate;
  final Services? services;
  final DateTime? createdAt;

  factory Offlinelist.fromJson(Map<String, dynamic> json) {
    return Offlinelist(
      id: json["id"] ?? 0,
      serviceId: json["service_id"] ?? 0,
      orderId: json["order_id"] ?? "",
      poojaPrice: json["pooja_price"] ?? "",
      payAmount: json["pay_amount"] ?? "",
      status: json["status"] ?? "",
      bookingDate: DateTime.tryParse(json["booking_date"] ?? ""),
      services:
          json["services"] == null ? null : Services.fromJson(json["services"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "order_id": orderId,
        "pooja_price": poojaPrice,
        "pay_amount": payAmount,
        "status": status,
        "booking_date":
            "${bookingDate?.year.toString().padLeft(4, '0')}-${bookingDate?.month.toString().padLeft(2, '0')}-${bookingDate?.day.toString().padLeft(2, '0')}",
        "services": services?.toJson(),
        "created_at": createdAt?.toIso8601String(),
      };

  @override
  String toString() {
    return "$id, $serviceId, $orderId, $poojaPrice, $payAmount, $status, $bookingDate, $services, $createdAt, ";
  }
}

class Services {
  Services({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.shortBenifits,
    required this.details,
    required this.benefits,
    required this.process,
    required this.termsConditions,
    required this.packageDetails,
    required this.thumbnail,
    required this.images,
    required this.videoUrl,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
    required this.hiName,
  });

  final int id;
  final String name;
  final String slug;
  final String type;
  final String shortBenifits;
  final String details;
  final String benefits;
  final String process;
  final String termsConditions;
  final String packageDetails;
  final String thumbnail;
  final String images;
  final String videoUrl;
  final String metaTitle;
  final String metaDescription;
  final String metaImage;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> translations;
  final String hiName;

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      type: json["type"] ?? "",
      shortBenifits: json["short_benifits"] ?? "",
      details: json["details"] ?? "",
      benefits: json["benefits"] ?? "",
      process: json["process"] ?? "",
      termsConditions: json["terms_conditions"] ?? "",
      packageDetails: json["package_details"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      images: json["images"] ?? "",
      videoUrl: json["video_url"] ?? "",
      metaTitle: json["meta_title"] ?? "",
      metaDescription: json["meta_description"] ?? "",
      metaImage: json["meta_image"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      translations: json["translations"] == null
          ? []
          : List<dynamic>.from(json["translations"]!.map((x) => x)),
      hiName: json["hi_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "type": type,
        "short_benifits": shortBenifits,
        "details": details,
        "benefits": benefits,
        "process": process,
        "terms_conditions": termsConditions,
        "package_details": packageDetails,
        "thumbnail": thumbnail,
        "images": images,
        "video_url": videoUrl,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_image": metaImage,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "translations": translations.map((x) => x).toList(),
        "hi_name": hiName,
      };

  @override
  String toString() {
    return "$id, $name, $slug, $type, $shortBenifits, $details, $benefits, $process, $termsConditions, $packageDetails, $thumbnail, $images, $videoUrl, $metaTitle, $metaDescription, $metaImage, $status, $createdAt, $updatedAt, $translations, $hiName, ";
  }
}
