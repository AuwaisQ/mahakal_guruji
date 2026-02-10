// To parse this JSON data, do
//
//     final chaughdiyaModel = chaughdiyaModelFromJson(jsonString);

import 'dart:convert';

List<ChaughdiyaModel> chaughdiyaModelFromJson(String str) =>
    List<ChaughdiyaModel>.from(
        json.decode(str).map((x) => ChaughdiyaModel.fromJson(x)));

String chaughdiyaModelToJson(List<ChaughdiyaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChaughdiyaModel {
  String startTime;
  String endTime;
  String muhurta;
  String color;
  String chaughdiyadetail;

  ChaughdiyaModel({
    required this.startTime,
    required this.endTime,
    required this.muhurta,
    required this.color,
    required this.chaughdiyadetail,
  });

  factory ChaughdiyaModel.fromJson(Map<String, dynamic> json) =>
      ChaughdiyaModel(
        startTime: json["start_time"],
        endTime: json["end_time"],
        muhurta: json["muhurta"],
        color: json["color"],
        chaughdiyadetail: json["chaughdiyadetail"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime,
        "end_time": endTime,
        "muhurta": muhurta,
        "color": color,
        "chaughdiyadetail": chaughdiyadetail,
      };
}

class choghadiyaModel {
  int? status;
  List<Result>? result;

  choghadiyaModel({this.status, this.result});

  choghadiyaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? startTime;
  String? endTime;
  String? muhurta;
  String? color;
  String? chaughdiyadetail;

  Result(
      {this.startTime,
      this.endTime,
      this.muhurta,
      this.color,
      this.chaughdiyadetail});

  Result.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    muhurta = json['muhurta'];
    color = json['color'];
    chaughdiyadetail = json['chaughdiyadetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['muhurta'] = muhurta;
    data['color'] = color;
    data['chaughdiyadetail'] = chaughdiyadetail;
    return data;
  }
}
