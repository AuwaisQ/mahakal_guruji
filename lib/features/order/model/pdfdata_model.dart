// To parse this JSON data, do
//
//     final pdfDataModel = pdfDataModelFromJson(jsonString);

import 'dart:convert';

PdfDataModel pdfDataModelFromJson(String str) =>
    PdfDataModel.fromJson(json.decode(str));

String pdfDataModelToJson(PdfDataModel data) => json.encode(data.toJson());

class PdfDataModel {
  int? status;
  String? message;
  int? recode;
  List<Pdfdatum>? pdfdata;

  PdfDataModel({
    this.status,
    this.message,
    this.recode,
    this.pdfdata,
  });

  factory PdfDataModel.fromJson(Map<String, dynamic> json) => PdfDataModel(
        status: json["status"],
        message: json["message"],
        recode: json["recode"],
        pdfdata: json["pdfdata"] == null
            ? []
            : List<Pdfdatum>.from(
                json["pdfdata"]!.map((x) => Pdfdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "recode": recode,
        "pdfdata": pdfdata == null
            ? []
            : List<dynamic>.from(pdfdata!.map((x) => x.toJson())),
      };
}

class Pdfdatum {
  dynamic id;
  dynamic userId;
  dynamic orderId;
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
  dynamic paymentStatus;
  dynamic amount;
  String? transactionId;
  dynamic milanVerify;
  DateTime? createdAt;
  String? image;
  String? kundaliPdf;

  Pdfdatum({
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
    this.image,
    this.kundaliPdf,
  });

  factory Pdfdatum.fromJson(Map<String, dynamic> json) => Pdfdatum(
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
        "image": image,
        "kundali_pdf": kundaliPdf,
      };
}
