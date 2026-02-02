// // To parse this JSON data, do
// //
// //     final refundPolicyModel = refundPolicyModelFromJson(jsonString);
//
// import 'dart:convert';
//
// RefundPolicyModel refundPolicyModelFromJson(String str) => RefundPolicyModel.fromJson(json.decode(str));
//
// String refundPolicyModelToJson(RefundPolicyModel data) => json.encode(data.toJson());
//
// class RefundPolicyModel {
//   int? status;
//   String? message;
//   List<RefundPolicyData>? data;
//
//   RefundPolicyModel({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory RefundPolicyModel.fromJson(Map<String, dynamic> json) => RefundPolicyModel(
//     status: json["status"],
//     message: json["message"],
//     data: json["data"] == null ? [] : List<RefundPolicyData>.from(json["data"]!.map((x) => RefundPolicyData.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }
//
// class RefundPolicyData {
//   String? enMessage;
//   String? hiMessage;
//   String? percentage;
//   int? amount;
//   String? date;
//
//   RefundPolicyData({
//     this.enMessage,
//     this.hiMessage,
//     this.percentage,
//     this.amount,
//     this.date,
//   });
//
//   factory RefundPolicyData.fromJson(Map<String, dynamic> json) => RefundPolicyData(
//     enMessage: json["en_message"],
//     hiMessage: json["hi_message"],
//     percentage: json["percentage"],
//     amount: json["amount"],
//     date: json["date"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "en_message": enMessage,
//     "hi_message": hiMessage,
//     "percentage": percentage,
//     "amount": amount,
//     "date": date,
//   };
// }
//

// To parse this JSON data, do
//
//     final refundPolicyModel = refundPolicyModelFromJson(jsonString);

import 'dart:convert';

RefundPolicyModel refundPolicyModelFromJson(String str) =>
    RefundPolicyModel.fromJson(json.decode(str));

String refundPolicyModelToJson(RefundPolicyModel data) =>
    json.encode(data.toJson());

class RefundPolicyModel {
  int? status;
  String? message;
  List<RefundPolicyData>? data;

  RefundPolicyModel({
    this.status,
    this.message,
    this.data,
  });

  factory RefundPolicyModel.fromJson(Map<String, dynamic> json) =>
      RefundPolicyModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<RefundPolicyData>.from(
                json["data"]!.map((x) => RefundPolicyData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RefundPolicyData {
  String? enMessage;
  String? hiMessage;
  String? percentage;
  double? amount;
  String? date;

  RefundPolicyData({
    this.enMessage,
    this.hiMessage,
    this.percentage,
    this.amount,
    this.date,
  });

  factory RefundPolicyData.fromJson(Map<String, dynamic> json) =>
      RefundPolicyData(
        enMessage: json["en_message"],
        hiMessage: json["hi_message"],
        percentage: json["percentage"],
        amount: json["amount"]?.toDouble(),
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "en_message": enMessage,
        "hi_message": hiMessage,
        "percentage": percentage,
        "amount": amount,
        "date": date,
      };
}
