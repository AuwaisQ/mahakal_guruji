// To parse this JSON data, do
//
//     final astroReviewModel = astroReviewModelFromJson(jsonString);

import 'dart:convert';

AstroReviewModel astroReviewModelFromJson(String str) =>
    AstroReviewModel.fromJson(json.decode(str));

String astroReviewModelToJson(AstroReviewModel data) =>
    json.encode(data.toJson());

class AstroReviewModel {
  bool status;
  List<Astrologyreview> astrologyreview;

  AstroReviewModel({
    required this.status,
    required this.astrologyreview,
  });

  factory AstroReviewModel.fromJson(Map<String, dynamic> json) =>
      AstroReviewModel(
        status: json["status"],
        astrologyreview: List<Astrologyreview>.from(
            json["astrologyreview"].map((x) => Astrologyreview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "astrologyreview":
            List<dynamic>.from(astrologyreview.map((x) => x.toJson())),
      };
}

class Astrologyreview {
  int id;
  String orderId;
  int astroId;
  int userId;
  int serviceId;
  String comment;
  String serviceType;
  int rating;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  UserData userData;

  Astrologyreview({
    required this.id,
    required this.orderId,
    required this.astroId,
    required this.userId,
    required this.serviceId,
    required this.comment,
    required this.serviceType,
    required this.rating,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userData,
  });

  factory Astrologyreview.fromJson(Map<String, dynamic> json) =>
      Astrologyreview(
        id: json["id"],
        orderId: json["order_id"],
        astroId: json["astro_id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        comment: json["comment"],
        serviceType: json["service_type"],
        rating: json["rating"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userData: UserData.fromJson(json["user_data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "astro_id": astroId,
        "user_id": userId,
        "service_id": serviceId,
        "comment": comment,
        "service_type": serviceType,
        "rating": rating,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_data": userData.toJson(),
      };
}

class UserData {
  int id;
  String name;
  String fName;
  String lName;
  String phone;
  String image;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic streetAddress;
  dynamic country;
  dynamic city;
  dynamic zip;
  dynamic houseNo;
  dynamic apartmentNo;
  String cmFirebaseToken;
  int isActive;
  dynamic paymentCardLastFour;
  dynamic paymentCardBrand;
  dynamic paymentCardFawryToken;
  dynamic loginMedium;
  dynamic socialId;
  int isPhoneVerified;
  String temporaryToken;
  int isEmailVerified;
  int walletBalance;
  dynamic loyaltyPoint;
  int loginHitCount;
  int isTempBlocked;
  dynamic tempBlockTime;
  dynamic referralCode;
  dynamic referredBy;
  String appLanguage;

  UserData({
    required this.id,
    required this.name,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.image,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.streetAddress,
    required this.country,
    required this.city,
    required this.zip,
    required this.houseNo,
    required this.apartmentNo,
    required this.cmFirebaseToken,
    required this.isActive,
    required this.paymentCardLastFour,
    required this.paymentCardBrand,
    required this.paymentCardFawryToken,
    required this.loginMedium,
    required this.socialId,
    required this.isPhoneVerified,
    required this.temporaryToken,
    required this.isEmailVerified,
    required this.walletBalance,
    required this.loyaltyPoint,
    required this.loginHitCount,
    required this.isTempBlocked,
    required this.tempBlockTime,
    required this.referralCode,
    required this.referredBy,
    required this.appLanguage,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        fName: json["f_name"],
        lName: json["l_name"],
        phone: json["phone"],
        image: json["image"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        streetAddress: json["street_address"],
        country: json["country"],
        city: json["city"],
        zip: json["zip"],
        houseNo: json["house_no"],
        apartmentNo: json["apartment_no"],
        cmFirebaseToken: json["cm_firebase_token"],
        isActive: json["is_active"],
        paymentCardLastFour: json["payment_card_last_four"],
        paymentCardBrand: json["payment_card_brand"],
        paymentCardFawryToken: json["payment_card_fawry_token"],
        loginMedium: json["login_medium"],
        socialId: json["social_id"],
        isPhoneVerified: json["is_phone_verified"],
        temporaryToken: json["temporary_token"],
        isEmailVerified: json["is_email_verified"],
        walletBalance: json["wallet_balance"],
        loyaltyPoint: json["loyalty_point"],
        loginHitCount: json["login_hit_count"],
        isTempBlocked: json["is_temp_blocked"],
        tempBlockTime: json["temp_block_time"],
        referralCode: json["referral_code"],
        referredBy: json["referred_by"],
        appLanguage: json["app_language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "f_name": fName,
        "l_name": lName,
        "phone": phone,
        "image": image,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "street_address": streetAddress,
        "country": country,
        "city": city,
        "zip": zip,
        "house_no": houseNo,
        "apartment_no": apartmentNo,
        "cm_firebase_token": cmFirebaseToken,
        "is_active": isActive,
        "payment_card_last_four": paymentCardLastFour,
        "payment_card_brand": paymentCardBrand,
        "payment_card_fawry_token": paymentCardFawryToken,
        "login_medium": loginMedium,
        "social_id": socialId,
        "is_phone_verified": isPhoneVerified,
        "temporary_token": temporaryToken,
        "is_email_verified": isEmailVerified,
        "wallet_balance": walletBalance,
        "loyalty_point": loyaltyPoint,
        "login_hit_count": loginHitCount,
        "is_temp_blocked": isTempBlocked,
        "temp_block_time": tempBlockTime,
        "referral_code": referralCode,
        "referred_by": referredBy,
        "app_language": appLanguage,
      };
}
