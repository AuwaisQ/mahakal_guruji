import 'dart:convert';

class Rashi {
  Rashi({required this.image, required this.name});
  late String image;
  late String name;
}

List<RashiComponentModel> rashiComponentModelFromJson(String str) =>
    List<RashiComponentModel>.from(
        json.decode(str).map((x) => RashiComponentModel.fromJson(x)));

String rashiComponentModelToJson(List<RashiComponentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RashiComponentModel {
  int id;
  String name;
  String slug;
  String image;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String hiName;
  List<dynamic> translations;

  RashiComponentModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.hiName,
    required this.translations,
  });

  factory RashiComponentModel.fromJson(Map<String, dynamic> json) =>
      RashiComponentModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        hiName: json["hi_name"],
        translations: List<dynamic>.from(json["translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "hi_name": hiName,
        "translations": List<dynamic>.from(translations.map((x) => x)),
      };
}
