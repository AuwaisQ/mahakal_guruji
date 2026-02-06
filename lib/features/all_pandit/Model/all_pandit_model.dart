// To parse this JSON data, do
//
//     final allPanditModel = allPanditModelFromJson(jsonString);

import 'dart:convert';

AllPanditModel allPanditModelFromJson(String str) => AllPanditModel.fromJson(json.decode(str));

String allPanditModelToJson(AllPanditModel data) => json.encode(data.toJson());

class AllPanditModel {
  bool? status;
  String? message;
  int? totalGuruji;
  List<AllPanditData>? allPanditData;

  AllPanditModel({
    this.status,
    this.message,
    this.totalGuruji,
    this.allPanditData,
  });

  factory AllPanditModel.fromJson(Map<String, dynamic> json) => AllPanditModel(
    status: json['status'],
    message: json['message'],
    totalGuruji: json['total_guruji'],
    allPanditData: json['data'] == null ? [] : List<AllPanditData>.from(json['data']!.map((x) => AllPanditData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'total_guruji': totalGuruji,
    'All_pandit_data': allPanditData == null ? [] : List<dynamic>.from(allPanditData!.map((x) => x.toJson())),
  };
}

class AllPanditData {
  int? id;
  String? enName;
  dynamic hiName;
  String?   image;
  dynamic banner;
  dynamic primarySkills;
  dynamic sellerId;
  dynamic eventId;
  List<IsPanditPoojaCategory>? isPanditPoojaCategory;
  int? serviceCount;

  AllPanditData({
    this.id,
    this.enName,
    this.hiName,
    this.image,
    this.banner,
    this.primarySkills,
    this.sellerId,
    this.eventId,
    this.isPanditPoojaCategory,
    this.serviceCount,
  });

  factory AllPanditData.fromJson(Map<String, dynamic> json) => AllPanditData(
    id: json['id'],
    enName: json['en_name'],
    hiName: json['hi_name'],
    image: json['image'],
    banner: json['banner'],
    primarySkills: json['primary_skills'],
    sellerId: json['seller_id'],
    eventId: json['event_id'],
    isPanditPoojaCategory: json['is_pandit_pooja_category'] == null ? [] : List<IsPanditPoojaCategory>.from(json['is_pandit_pooja_category']!.map((x) => IsPanditPoojaCategory.fromJson(x))),
    serviceCount: json['service_count'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'en_name': enName,
    'hi_name': hiName,
    'image': image,
    'banner': banner,
    'primary_skills': primarySkills,
    'seller_id': sellerId,
    'event_id': eventId,
    'is_pandit_pooja_category': isPanditPoojaCategory == null ? [] : List<dynamic>.from(isPanditPoojaCategory!.map((x) => x.toJson())),
    'service_count': serviceCount,
  };
}

class IsPanditPoojaCategory {
  int? id;
  String? name;
  String? slug;
  String? icon;
  int? parentId;
  int? position;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? homeStatus;
  int? priority;
  List<dynamic>? translations;

  IsPanditPoojaCategory({
    this.id,
    this.name,
    this.slug,
    this.icon,
    this.parentId,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.homeStatus,
    this.priority,
    this.translations,
  });

  factory IsPanditPoojaCategory.fromJson(Map<String, dynamic> json) => IsPanditPoojaCategory(
    id: json['id'],
    name: json['name'],
    slug: json['slug'],
    icon: json['icon'],
    parentId: json['parent_id'],
    position: json['position'],
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    homeStatus: json['home_status'],
    priority: json['priority'],
    translations: json['translations'] == null ? [] : List<dynamic>.from(json['translations']!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'icon': icon,
    'parent_id': parentId,
    'position': position,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'home_status': homeStatus,
    'priority': priority,
    'translations': translations == null ? [] : List<dynamic>.from(translations!.map((x) => x)),
  };
}
