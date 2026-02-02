// // To parse this JSON data, do
// //
// //     final eventOrderDetailsModel = eventOrderDetailsModelFromJson(jsonString);
//
// import 'dart:convert';
//
// EventOrderDetailsModel eventOrderDetailsModelFromJson(String str) => EventOrderDetailsModel.fromJson(json.decode(str));
//
// String eventOrderDetailsModelToJson(EventOrderDetailsModel data) => json.encode(data.toJson());
//
// class EventOrderDetailsModel {
//   int? status;
//   String? message;
//   int? recode;
//   Data? data;
//
//   EventOrderDetailsModel({
//     this.status,
//     this.message,
//     this.recode,
//     this.data,
//   });
//
//   factory EventOrderDetailsModel.fromJson(Map<String, dynamic> json) => EventOrderDetailsModel(
//     status: json["status"],
//     message: json["message"],
//     recode: json["recode"],
//     data: json["data"] == null ? null : Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "recode": recode,
//     "data": data?.toJson(),
//   };
// }
//
// class Data {
//   int? id;
//   String? orderNo;
//   int? amount;
//   int? totalSeats;
//   int? packageId;
//   String? enPackageName;
//   String? hiPackageName;
//   int? amountStatus;
//   String? userName;
//   String? userPhone;
//   String? userEmail;
//   int? eventId;
//   String? enEventName;
//   String? hiEventName;
//   String? artistId;
//   String? enArtistName;
//   String? hiArtistName;
//   String? artistImage;
//   int? organizerId;
//   String? enOrganizerName;
//   String? hiOrganizerName;
//   String? organizerImage;
//   int? categoryId;
//   String? enCategoryName;
//   String? hiCategoryName;
//   String? categoryImage;
//   String? eventImage;
//   String? enEventVenue;
//   String? hiEventVenue;
//   String? eventDate;
//   String? eventBookingDate;
//   dynamic couponAmount;
//   int? reviewStatus;
//
//   Data({
//     this.id,
//     this.orderNo,
//     this.amount,
//     this.totalSeats,
//     this.packageId,
//     this.enPackageName,
//     this.hiPackageName,
//     this.amountStatus,
//     this.userName,
//     this.userPhone,
//     this.userEmail,
//     this.eventId,
//     this.enEventName,
//     this.hiEventName,
//     this.artistId,
//     this.enArtistName,
//     this.hiArtistName,
//     this.artistImage,
//     this.organizerId,
//     this.enOrganizerName,
//     this.hiOrganizerName,
//     this.organizerImage,
//     this.categoryId,
//     this.enCategoryName,
//     this.hiCategoryName,
//     this.categoryImage,
//     this.eventImage,
//     this.enEventVenue,
//     this.hiEventVenue,
//     this.eventDate,
//     this.eventBookingDate,
//     this.couponAmount,
//     this.reviewStatus,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["id"],
//     orderNo: json["order_no"],
//     amount: json["amount"],
//     totalSeats: json["total_seats"],
//     packageId: json["package_id"],
//     enPackageName: json["en_package_name"],
//     hiPackageName: json["hi_package_name"],
//     amountStatus: json["amount_status"],
//     userName: json["user_name"],
//     userPhone: json["user_phone"],
//     userEmail: json["user_email"],
//     eventId: json["event_id"],
//     enEventName: json["en_event_name"],
//     hiEventName: json["hi_event_name"],
//     artistId: json["artist_id"],
//     enArtistName: json["en_artist_name"],
//     hiArtistName: json["hi_artist_name"],
//     artistImage: json["artist_image"],
//     organizerId: json["organizer_id"],
//     enOrganizerName: json["en_organizer_name"],
//     hiOrganizerName: json["hi_organizer_name"],
//     organizerImage: json["organizer_image"],
//     categoryId: json["category_id"],
//     enCategoryName: json["en_category_name"],
//     hiCategoryName: json["hi_category_name"],
//     categoryImage: json["category_image"],
//     eventImage: json["event_image"],
//     enEventVenue: json["en_event_venue"],
//     hiEventVenue: json["hi_event_venue"],
//     eventDate: json["event_date"],
//     eventBookingDate: json["event_booking_date"],
//     couponAmount: json["coupon_amount"],
//       reviewStatus: json["review_status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "order_no": orderNo,
//     "amount": amount,
//     "total_seats": totalSeats,
//     "package_id": packageId,
//     "en_package_name": enPackageName,
//     "hi_package_name": hiPackageName,
//     "amount_status": amountStatus,
//     "user_name": userName,
//     "user_phone": userPhone,
//     "user_email": userEmail,
//     "event_id": eventId,
//     "en_event_name": enEventName,
//     "hi_event_name": hiEventName,
//     "artist_id": artistId,
//     "en_artist_name": enArtistName,
//     "hi_artist_name": hiArtistName,
//     "artist_image": artistImage,
//     "organizer_id": organizerId,
//     "en_organizer_name": enOrganizerName,
//     "hi_organizer_name": hiOrganizerName,
//     "organizer_image": organizerImage,
//     "category_id": categoryId,
//     "en_category_name": enCategoryName,
//     "hi_category_name": hiCategoryName,
//     "category_image": categoryImage,
//     "event_image": eventImage,
//     "en_event_venue": enEventVenue,
//     "hi_event_venue": hiEventVenue,
//     "event_date": eventDate,
//     "event_booking_date": eventBookingDate,
//     "coupon_amount": couponAmount,
//     "review_status": reviewStatus,
//   };
// }
//

import 'dart:convert';

EventOrderDetailsModel eventOrderDetailsModelFromJson(String str) =>
    EventOrderDetailsModel.fromJson(json.decode(str));

String eventOrderDetailsModelToJson(EventOrderDetailsModel data) =>
    json.encode(data.toJson());

class EventOrderDetailsModel {
  EventOrderDetailsModel({
    required this.status,
    required this.message,
    required this.recode,
    required this.data,
  });

  final int status;
  final String message;
  final int recode;
  final Data? data;

  factory EventOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventOrderDetailsModel(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      recode: json["recode"] ?? 0,
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "recode": recode,
        "data": data?.toJson(),
      };

  @override
  String toString() {
    return "$status, $message, $recode, $data, ";
  }
}

class Data {
  Data({
    required this.id,
    required this.orderNo,
    required this.amount,
    required this.totalSeats,
    required this.packageId,
    required this.enPackageName,
    required this.hiPackageName,
    required this.amountStatus,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.eventId,
    required this.enEventName,
    required this.hiEventName,
    required this.artistId,
    required this.enArtistName,
    required this.hiArtistName,
    required this.artistImage,
    required this.organizerId,
    required this.enOrganizerName,
    required this.hiOrganizerName,
    required this.organizerImage,
    required this.categoryId,
    required this.enCategoryName,
    required this.hiCategoryName,
    required this.categoryImage,
    required this.eventImage,
    required this.enEventVenue,
    required this.hiEventVenue,
    required this.eventDate,
    required this.eventBookingDate,
    required this.couponAmount,
    required this.reviewStatus,
  });

  final int id;
  final dynamic orderNo;
  final dynamic amount;
  final int totalSeats;
  final dynamic packageId;
  final String enPackageName;
  final String hiPackageName;
  final dynamic amountStatus;
  final String userName;
  final String userPhone;
  final String userEmail;
  final dynamic eventId;
  final String enEventName;
  final String hiEventName;
  final dynamic artistId;
  final String enArtistName;
  final String hiArtistName;
  final String artistImage;
  final dynamic organizerId;
  final String enOrganizerName;
  final String hiOrganizerName;
  final String organizerImage;
  final dynamic categoryId;
  final String enCategoryName;
  final String hiCategoryName;
  final String categoryImage;
  final String eventImage;
  final String enEventVenue;
  final String hiEventVenue;
  final String eventDate;
  final String eventBookingDate;
  final dynamic couponAmount;
  final dynamic reviewStatus;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] ?? 0,
      orderNo: json["order_no"] ?? "",
      amount: json["amount"] ?? 0,
      totalSeats: json["total_seats"] ?? 0,
      packageId: json["package_id"] ?? 0,
      enPackageName: json["en_package_name"] ?? "",
      hiPackageName: json["hi_package_name"] ?? "",
      amountStatus: json["amount_status"] ?? 0,
      userName: json["user_name"] ?? "N/A",
      userPhone: json["user_phone"] ?? "",
      userEmail: json["user_email"] ?? "",
      eventId: json["event_id"] ?? 0,
      enEventName: json["en_event_name"] ?? "",
      hiEventName: json["hi_event_name"] ?? "",
      artistId: json["artist_id"] ?? 0,
      enArtistName: json["en_artist_name"] ?? "",
      hiArtistName: json["hi_artist_name"] ?? "",
      artistImage: json["artist_image"] ?? "",
      organizerId: json["organizer_id"] ?? 0,
      enOrganizerName: json["en_organizer_name"] ?? "",
      hiOrganizerName: json["hi_organizer_name"] ?? "",
      organizerImage: json["organizer_image"] ?? "",
      categoryId: json["category_id"] ?? 0,
      enCategoryName: json["en_category_name"] ?? "",
      hiCategoryName: json["hi_category_name"] ?? "",
      categoryImage: json["category_image"] ?? "",
      eventImage: json["event_image"] ?? "",
      enEventVenue: json["en_event_venue"] ?? "",
      hiEventVenue: json["hi_event_venue"] ?? "",
      eventDate: json["event_date"] ?? "",
      eventBookingDate: json["event_booking_date"] ?? "",
      couponAmount: json["coupon_amount"] ?? 0,
      reviewStatus: json["review_status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "amount": amount,
        "total_seats": totalSeats,
        "package_id": packageId,
        "en_package_name": enPackageName,
        "hi_package_name": hiPackageName,
        "amount_status": amountStatus,
        "user_name": userName,
        "user_phone": userPhone,
        "user_email": userEmail,
        "event_id": eventId,
        "en_event_name": enEventName,
        "hi_event_name": hiEventName,
        "artist_id": artistId,
        "en_artist_name": enArtistName,
        "hi_artist_name": hiArtistName,
        "artist_image": artistImage,
        "organizer_id": organizerId,
        "en_organizer_name": enOrganizerName,
        "hi_organizer_name": hiOrganizerName,
        "organizer_image": organizerImage,
        "category_id": categoryId,
        "en_category_name": enCategoryName,
        "hi_category_name": hiCategoryName,
        "category_image": categoryImage,
        "event_image": eventImage,
        "en_event_venue": enEventVenue,
        "hi_event_venue": hiEventVenue,
        "event_date": eventDate,
        "event_booking_date": eventBookingDate,
        "coupon_amount": couponAmount,
        "review_status": reviewStatus,
      };

  @override
  String toString() {
    return "$id, $orderNo, $amount, $totalSeats, $packageId, $enPackageName, $hiPackageName, $amountStatus, $userName, $userPhone, $userEmail, $eventId, $enEventName, $hiEventName, $artistId, $enArtistName, $hiArtistName, $artistImage, $organizerId, $enOrganizerName, $hiOrganizerName, $organizerImage, $categoryId, $enCategoryName, $hiCategoryName, $categoryImage, $eventImage, $enEventVenue, $hiEventVenue, $eventDate, $eventBookingDate, $couponAmount, $reviewStatus, ";
  }
}
