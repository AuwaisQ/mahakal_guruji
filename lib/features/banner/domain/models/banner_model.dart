import 'package:mahakal/features/product/domain/models/product_model.dart';

class BannerModel {
  int? id;
  String? photo;
  String? bannerType;
  int? published;
  String? createdAt;
  String? updatedAt;
  String? url;
  String? resourceType;
  int? resourceId;
  Product? product;
  String? title;
  String? subTitle;
  String? buttonText;
  String? backgroundColor;
  Mahakalapp? mahakalApp;

  BannerModel({
    this.id,
    this.photo,
    this.bannerType,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.url,
    this.resourceType,
    this.resourceId,
    this.product,
    this.title,
    this.subTitle,
    this.buttonText,
    this.backgroundColor,
    this.mahakalApp,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    bannerType = json['banner_type'];
    published = json['published'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
    resourceType = json['resource_type'];
    resourceId = json['resource_id'];
    title = json['title'];
    subTitle = json['sub_title'];
    buttonText = json['button_text'];
    backgroundColor = json['background_color'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    mahakalApp = json['mahakalapp'] != null
        ? Mahakalapp.fromJson(json['mahakalapp'])
        : null;
  }
}

class Mahakalapp {
  int? id;
  String? name;
  String? slug;
  String? nextPoojaDate;
  String? type;

  Mahakalapp({
    required this.id,
    required this.name,
    required this.slug,
    required this.nextPoojaDate,
    required this.type,
  });

  factory Mahakalapp.fromJson(Map<String, dynamic> json) => Mahakalapp(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        nextPoojaDate:
            json["next_pooja_date"] == null ? null : json["next_pooja_date"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "next_pooja_date": nextPoojaDate,
        "type": type,
      };
}
