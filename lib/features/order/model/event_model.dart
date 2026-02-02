// import 'dart:convert';
//
// EventOrderModel eventOrderModelFromJson(String str) => EventOrderModel.fromJson(json.decode(str));
//
// String eventOrderModelToJson(EventOrderModel data) => json.encode(data.toJson());
//
// class EventOrderModel {
//   int? status;
//   String? message;
//   int? recode;
//   List<Eventdata>? data;
//
//   EventOrderModel({
//     this.status,
//     this.message,
//     this.recode,
//     this.data,
//   });
//
//   factory EventOrderModel.fromJson(Map<String, dynamic> json) => EventOrderModel(
//     status: json["status"],
//     message: json["message"],
//     recode: json["recode"],
//     data: json["data"] == null ? [] : List<Eventdata>.from(json["data"]!.map((x) => Eventdata.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "recode": recode,
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }
//
// class Eventdata {
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
//   dynamic organizerId;
//   String? enOrganizerName;
//   String? hiOrganizerName;
//   String? organizerImage;
//   dynamic categoryId;
//   String? enCategoryName;
//   String? hiCategoryName;
//   String? categoryImage;
//   String? eventImage;
//
//   Eventdata({
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
//   });
//
//   factory Eventdata.fromJson(Map<String, dynamic> json) => Eventdata(
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
//   };
// }

import 'dart:convert';

EventOrderModel eventOrderModelFromJson(String str) =>
    EventOrderModel.fromJson(json.decode(str));

String eventOrderModelToJson(EventOrderModel data) =>
    json.encode(data.toJson());

class EventOrderModel {
  EventOrderModel({
    required this.status,
    required this.message,
    required this.recode,
    required this.data,
  });

  final dynamic status;
  final String message;
  final dynamic recode;
  final List<Eventdata> data;

  factory EventOrderModel.fromJson(Map<String, dynamic> json) {
    return EventOrderModel(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      recode: json["recode"] ?? 0,
      data: json["data"] == null
          ? []
          : List<Eventdata>.from(
              json["data"]!.map((x) => Eventdata.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "recode": recode,
        "data": data.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$status, $message, $recode, $data, ";
  }
}

class Eventdata {
  Eventdata({
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
    required this.eventBookingDate,
  });

  final dynamic id;
  final dynamic orderNo;
  final dynamic amount;
  final dynamic totalSeats;
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
  final String eventBookingDate;

  factory Eventdata.fromJson(Map<String, dynamic> json) {
    return Eventdata(
      id: json["id"] ?? 0,
      orderNo: json["order_no"] ?? "",
      amount: json["amount"] ?? 0,
      totalSeats: json["total_seats"] ?? 0,
      packageId: json["package_id"] ?? 0,
      enPackageName: json["en_package_name"] ?? "",
      hiPackageName: json["hi_package_name"] ?? "",
      amountStatus: json["amount_status"] ?? 0,
      userName: json["user_name"] ?? "",
      userPhone: json["user_phone"] ?? "",
      userEmail: json["user_email"] ?? "",
      eventId: json["event_id"] ?? 0,
      enEventName: json["en_event_name"] ?? "",
      hiEventName: json["hi_event_name"] ?? "",
      artistId: json["artist_id"] ?? "",
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
      eventBookingDate: json["event_booking_date"] ?? "",
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
        "event_booking_date": eventBookingDate,
      };

  @override
  String toString() {
    return "$id, $orderNo, $amount, $totalSeats, $packageId, $enPackageName, $hiPackageName, $amountStatus, $userName, $userPhone, $userEmail, $eventId, $enEventName, $hiEventName, $artistId, $enArtistName, $hiArtistName, $artistImage, $organizerId, $enOrganizerName, $hiOrganizerName, $organizerImage, $categoryId, $enCategoryName, $hiCategoryName, $categoryImage, $eventImage, $eventBookingDate, ";
  }
}
