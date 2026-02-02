// To parse this JSON data, do
//
//     final pdfOrderDetailModel = pdfOrderDetailModelFromJson(jsonString);

import 'dart:convert';

PdfOrderDetailModel pdfOrderDetailModelFromJson(String str) =>
    PdfOrderDetailModel.fromJson(json.decode(str));

String pdfOrderDetailModelToJson(PdfOrderDetailModel data) =>
    json.encode(data.toJson());

class PdfOrderDetailModel {
  int? status;
  String? message;
  int? recode;
  Pdforderdetails? pdforderdetails;

  PdfOrderDetailModel({
    this.status,
    this.message,
    this.recode,
    this.pdforderdetails,
  });

  factory PdfOrderDetailModel.fromJson(Map<String, dynamic> json) =>
      PdfOrderDetailModel(
        status: json["status"],
        message: json["message"],
        recode: json["recode"],
        pdforderdetails: json["pdforderdetails"] == null
            ? null
            : Pdforderdetails.fromJson(json["pdforderdetails"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "recode": recode,
        "pdforderdetails": pdforderdetails?.toJson(),
      };
}

class Pdforderdetails {
  int? id;
  int? userId;
  String? orderId;
  String? maleName;
  String? maleGender;
  DateTime? maleBod;
  String? maleTime;
  String? maleCountry;
  String? maleState;
  String? femaleName;
  String? femaleGender;
  String? femaleBod;
  String? femaleTime;
  String? femaleCountry;
  String? femaleState;
  String? language;
  String? chartStyle;
  int? paymentStatus;
  int? amount;
  String? transactionId;
  int? milanVerify;
  DateTime? createdAt;
  String? invoicePdf;
  String? image;
  String? kundaliPdf;

  Pdforderdetails({
    this.id,
    this.userId,
    this.orderId,
    this.maleName,
    this.maleGender,
    this.maleBod,
    this.maleTime,
    this.maleCountry,
    this.maleState,
    this.femaleName,
    this.femaleGender,
    this.femaleBod,
    this.femaleTime,
    this.femaleCountry,
    this.femaleState,
    this.language,
    this.chartStyle,
    this.paymentStatus,
    this.amount,
    this.transactionId,
    this.milanVerify,
    this.createdAt,
    this.invoicePdf,
    this.image,
    this.kundaliPdf,
  });

  factory Pdforderdetails.fromJson(Map<String, dynamic> json) =>
      Pdforderdetails(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        maleName: json["male_name"],
        maleGender: json["male_gender"],
        maleBod:
            json["male_bod"] == null ? null : DateTime.parse(json["male_bod"]),
        maleTime: json["male_time"],
        maleCountry: json["male_country"],
        maleState: json["male_state"],
        femaleName: json["female_name"],
        femaleGender: json["female_gender"],
        femaleBod: json["female_bod"],
        femaleTime: json["female_time"],
        femaleCountry: json["female_country"],
        femaleState: json["female_state"],
        language: json["language"],
        chartStyle: json["chart_style"],
        paymentStatus: json["payment_status"],
        amount: json["amount"],
        transactionId: json["transaction_id"],
        milanVerify: json["milan_verify"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        invoicePdf: json["invoice_url"],
        image: json["image"],
        kundaliPdf: json["kundali_pdf"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "order_id": orderId,
        "male_name": maleName,
        "male_gender": maleGender,
        "male_bod":
            "${maleBod!.year.toString().padLeft(4, '0')}-${maleBod!.month.toString().padLeft(2, '0')}-${maleBod!.day.toString().padLeft(2, '0')}",
        "male_time": maleTime,
        "male_country": maleCountry,
        "male_state": maleState,
        "female_name": femaleName,
        "female_gender": femaleGender,
        "female_bod": femaleBod,
        "female_time": femaleTime,
        "female_country": femaleCountry,
        "female_state": femaleState,
        "language": language,
        "chart_style": chartStyle,
        "payment_status": paymentStatus,
        "amount": amount,
        "transaction_id": transactionId,
        "milan_verify": milanVerify,
        "created_at": createdAt?.toIso8601String(),
        "invoice_url": invoicePdf,
        "image": image,
        "kundali_pdf": kundaliPdf,
      };
}

// class PdfOrderDetailModel {
//   PdfOrderDetailModel({
//     required this.status,
//     required this.message,
//     required this.recode,
//     required this.data,
//   });
//
//   final int status;
//   final String message;
//   final int recode;
//   final Pdforderdetails? data;
//
//   factory PdfOrderDetailModel.fromJson(Map<String, dynamic> json){
//     return PdfOrderDetailModel(
//       status: json["status"] ?? 0,
//       message: json["message"] ?? "",
//       recode: json["recode"] ?? 0,
//       data: json["data"] == null ? null : Pdforderdetails.fromJson(json["data"]),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "recode": recode,
//     "data": data?.toJson(),
//   };
//
//   @override
//   String toString(){
//     return "$status, $message, $recode, $data, ";
//   }
// }
//
// class Pdforderdetails {
//   Pdforderdetails({
//     required this.id,
//     required this.userId,
//     required this.orderId,
//     required this.maleName,
//     required this.maleGender,
//     required this.maleBod,
//     required this.maleTime,
//     required this.maleCountry,
//     required this.maleState,
//     required this.language,
//     required this.chartStyle,
//     required this.paymentStatus,
//     required this.amount,
//     required this.transactionId,
//     required this.milanVerify,
//     required this.createdAt,
//     required this.invoiceUrl,
//     required this.image,
//     required this.kundaliPdf,
//   });
//
//   final int id;
//   final int userId;
//   final String orderId;
//   final String maleName;
//   final String maleGender;
//   final DateTime? maleBod;
//   final String maleTime;
//   final String maleCountry;
//   final String maleState;
//   final String language;
//   final String chartStyle;
//   final int paymentStatus;
//   final int amount;
//   final String transactionId;
//   final int milanVerify;
//   final DateTime? createdAt;
//   final String invoiceUrl;
//   final String image;
//   final String kundaliPdf;
//
//   factory Pdforderdetails.fromJson(Map<String, dynamic> json){
//     return Pdforderdetails(
//       id: json["id"] ?? 0,
//       userId: json["user_id"] ?? 0,
//       orderId: json["order_id"] ?? "",
//       maleName: json["male_name"] ?? "",
//       maleGender: json["male_gender"] ?? "",
//       maleBod: DateTime.tryParse(json["male_bod"] ?? ""),
//       maleTime: json["male_time"] ?? "",
//       maleCountry: json["male_country"] ?? "",
//       maleState: json["male_state"] ?? "",
//       language: json["language"] ?? "",
//       chartStyle: json["chart_style"] ?? "",
//       paymentStatus: json["payment_status"] ?? 0,
//       amount: json["amount"] ?? 0,
//       transactionId: json["transaction_id"] ?? "",
//       milanVerify: json["milan_verify"] ?? 0,
//       createdAt: DateTime.tryParse(json["created_at"] ?? ""),
//       invoiceUrl: json["invoice_url"] ?? "",
//       image: json["image"] ?? "",
//       kundaliPdf: json["kundali_pdf"] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "order_id": orderId,
//     "male_name": maleName,
//     "male_gender": maleGender,
//     "male_bod": maleBod != null
//         ? "${maleBod?.year.toString().padLeft(4, '0')}-${maleBod?.month.toString().padLeft(2, '0')}-${maleBod?.day.toString().padLeft(2, '0')}"
//         : null,
//     "male_time": maleTime,
//     "male_country": maleCountry,
//     "male_state": maleState,
//     "language": language,
//     "chart_style": chartStyle,
//     "payment_status": paymentStatus,
//     "amount": amount,
//     "transaction_id": transactionId,
//     "milan_verify": milanVerify,
//     "created_at": createdAt?.toIso8601String(),
//     "invoice_url": invoiceUrl,
//     "image": image,
//     "kundali_pdf": kundaliPdf,
//   };
//
//   @override
//   String toString(){
//     return "$id, $userId, $orderId, $maleName, $maleGender, $maleBod, $maleTime, $maleCountry, $maleState, $language, $chartStyle, $paymentStatus, $amount, $transactionId, $milanVerify, $createdAt, $invoiceUrl, $image, $kundaliPdf, ";
//   }
// }
