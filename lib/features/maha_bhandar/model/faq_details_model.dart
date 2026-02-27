// // To parse this JSON data, do
// //
// //     final faqDetailsModel = faqDetailsModelFromJson(jsonString);
//
// import 'dart:convert';
//
// FaqDetailsModel faqDetailsModelFromJson(String str) => FaqDetailsModel.fromJson(json.decode(str));
//
// String faqDetailsModelToJson(FaqDetailsModel data) => json.encode(data.toJson());
//
// class FaqDetailsModel {
//   int status;
//   String message;
//   List<Faqdetail> faqdetails;
//
//   FaqDetailsModel({
//     required this.status,
//     required this.message,
//     required this.faqdetails,
//   });
//
//   factory FaqDetailsModel.fromJson(Map<String, dynamic> json) => FaqDetailsModel(
//     status: json["status"],
//     message: json["message"],
//     faqdetails: List<Faqdetail>.from(json["faqdetails"].map((x) => Faqdetail.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "faqdetails": List<dynamic>.from(faqdetails.map((x) => x.toJson())),
//   };
// }
//
// class Faqdetail {
//   int id;
//   String enQuestion;
//   String enDetail;
//   String hiQuestion;
//   String hiDetail;
//
//   Faqdetail({
//     required this.id,
//     required this.enQuestion,
//     required this.enDetail,
//     required this.hiQuestion,
//     required this.hiDetail,
//   });
//
//   factory Faqdetail.fromJson(Map<String, dynamic> json) => Faqdetail(
//     id: json["id"],
//     enQuestion: json["en_question"],
//     enDetail: json["en_detail"],
//     hiQuestion: json["hi_question"],
//     hiDetail: json["hi_detail"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "en_question": enQuestion,
//     "en_detail": enDetail,
//     "hi_question": hiQuestion,
//     "hi_detail": hiDetail,
//   };
// }

class FaqDetailsModel {
  FaqDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final List<Faqdetail> data;

  factory FaqDetailsModel.fromJson(Map<String, dynamic> json) {
    return FaqDetailsModel(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<Faqdetail>.from(
              json["data"]!.map((x) => Faqdetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$status, $message, $data, ";
  }
}

class Faqdetail {
  Faqdetail({
    required this.id,
    required this.enQuestion,
    required this.enDetail,
    required this.hiQuestion,
    required this.hiDetail,
  });

  final int id;
  final String enQuestion;
  final String enDetail;
  final String hiQuestion;
  final String hiDetail;

  factory Faqdetail.fromJson(Map<String, dynamic> json) {
    return Faqdetail(
      id: json["id"] ?? 0,
      enQuestion: json["en_question"] ?? "",
      enDetail: json["en_detail"] ?? "",
      hiQuestion: json["hi_question"] ?? "",
      hiDetail: json["hi_detail"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_question": enQuestion,
        "en_detail": enDetail,
        "hi_question": hiQuestion,
        "hi_detail": hiDetail,
      };

  @override
  String toString() {
    return "$id, $enQuestion, $enDetail, $hiQuestion, $hiDetail, ";
  }
}
