// To parse this JSON data, do
//
//     final consultationModel = consultationModelFromJson(jsonString);

import 'dart:convert';

ConsultationModel consultationModelFromJson(String str) =>
    ConsultationModel.fromJson(json.decode(str));

String consultationModelToJson(ConsultationModel data) =>
    json.encode(data.toJson());

class ConsultationModel {
  int? status;
  List<Astroconsultant>? astroconsultant;

  ConsultationModel({
    this.status,
    this.astroconsultant,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      ConsultationModel(
        status: json["status"],
        astroconsultant: json["astroconsultant"] == null
            ? []
            : List<Astroconsultant>.from(json["astroconsultant"]!
                .map((x) => Astroconsultant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "astroconsultant": astroconsultant == null
            ? []
            : List<dynamic>.from(astroconsultant!.map((x) => x.toJson())),
      };
}

class Astroconsultant {
  int? id;
  String? enName;
  String? hiName;
  List<String>? images;
  String? thumbnail;
  ProductType? productType;
  int? counsellingMainPrice;
  int? counsellingSellingPrice;

  Astroconsultant({
    this.id,
    this.enName,
    this.hiName,
    this.images,
    this.thumbnail,
    this.productType,
    this.counsellingMainPrice,
    this.counsellingSellingPrice,
  });

  factory Astroconsultant.fromJson(Map<String, dynamic> json) =>
      Astroconsultant(
        id: json["id"],
        enName: json["en_name"],
        hiName: json["hi_name"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        thumbnail: json["thumbnail"],
        productType: productTypeValues.map[json["product_type"]]!,
        counsellingMainPrice: json["counselling_main_price"],
        counsellingSellingPrice: json["counselling_selling_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_name": enName,
        "hi_name": hiName,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "thumbnail": thumbnail,
        "product_type": productTypeValues.reverse[productType],
        "counselling_main_price": counsellingMainPrice,
        "counselling_selling_price": counsellingSellingPrice,
      };
}

enum ProductType { COUNSELLING }

final productTypeValues = EnumValues({"counselling": ProductType.COUNSELLING});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
