// To parse this JSON data, do
//
//     final allPanditServicesModel = allPanditServicesModelFromJson(jsonString);

import 'dart:convert';

AllPanditServicesModel allPanditServicesModelFromJson(String str) => AllPanditServicesModel.fromJson(json.decode(str));

String allPanditServicesModelToJson(AllPanditServicesModel data) => json.encode(data.toJson());

class AllPanditServicesModel {
  bool? status;
  String? message;
  Guruji? guruji;
  List<Service>? service;
  List<Counselling>? counselling;
  List<Event>? event;
  List<dynamic>? shop;

  AllPanditServicesModel({
    this.status,
    this.message,
    this.guruji,
    this.service,
    this.counselling,
    this.event,
    this.shop,
  });

  factory AllPanditServicesModel.fromJson(Map<String, dynamic> json) => AllPanditServicesModel(
    status: json['status'],
    message: json['message'],
    guruji: json['guruji'] == null ? null : Guruji.fromJson(json['guruji']),
    service: json['service'] == null ? [] : List<Service>.from(json['service']!.map((x) => Service.fromJson(x))),
    counselling: json['counselling'] == null ? [] : List<Counselling>.from(json['counselling']!.map((x) => Counselling.fromJson(x))),
    event: json['event'] == null ? [] : List<Event>.from(json['event']!.map((x) => Event.fromJson(x))),
    shop: json['shop'] == null ? [] : List<dynamic>.from(json['shop']!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'guruji': guruji?.toJson(),
    'service': service == null ? [] : List<dynamic>.from(service!.map((x) => x.toJson())),
    'counselling': counselling == null ? [] : List<dynamic>.from(counselling!.map((x) => x)),
    'event': event == null ? [] : List<dynamic>.from(event!.map((x) => x.toJson())),
    'shop': shop == null ? [] : List<dynamic>.from(shop!.map((x) => x)),
  };
}

class Guruji {
  int? id;
  String? enName;
  dynamic hiName;
  String? email;
  String? mobileNo;
  String? image;
  String? banner;
  String? gender;
  DateTime? dob;
  List<Category>? isPanditPoojaCategory;
  String? primarySkills;
  int? totalPuja;
  String? vendorId;
  String? eventId;

  Guruji({
    this.id,
    this.enName,
    this.hiName,
    this.email,
    this.mobileNo,
    this.image,
    this.banner,
    this.gender,
    this.dob,
    this.isPanditPoojaCategory,
    this.primarySkills,
    this.totalPuja,
    this.vendorId,
    this.eventId,
  });

  factory Guruji.fromJson(Map<String, dynamic> json) => Guruji(
    id: json['id'],
    enName: json['en_name'],
    hiName: json['hi_name'],
    email: json['email'],
    mobileNo: json['mobile_no'],
    image: json['image'],
    banner: json['banner'],
    gender: json['gender'],
    dob: json['dob'] == null ? null : DateTime.parse(json['dob']),
    isPanditPoojaCategory: json['is_pandit_pooja_category'] == null ? [] : List<Category>.from(json['is_pandit_pooja_category']!.map((x) => Category.fromJson(x))),
    primarySkills: json['primary_skills'],
    totalPuja: json['total_puja'],
    vendorId: json['vendor_id'],
    eventId: json['event_id'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'en_name': enName,
    'hi_name': hiName,
    'email': email,
    'mobile_no': mobileNo,
    'image': image,
    'banner': banner,
    'gender': gender,
    'dob': "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    'is_pandit_pooja_category': isPanditPoojaCategory == null ? [] : List<dynamic>.from(isPanditPoojaCategory!.map((x) => x.toJson())),
    'primary_skills': primarySkills,
    'total_puja': totalPuja,
    'vendor_id': vendorId,
    'event_id': eventId,
  };
}

class Category {
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

  Category({
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

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class Service {
  int? id;
  String? enName;
  String? hiName;
  String? enPoojaHeading;
  String? hiPoojaHeading;
  String? slug;
  String? image;
  int? status;
  int? userId;
  String? addedBy;
  String? enShortBenifits;
  String? hiShortBenifits;
  String? productType;
  int? poojaType;
  dynamic schedule;
  dynamic counsellingMainPrice;
  dynamic counsellingSellingPrice;
  String? enDetails;
  String? hiDetails;
  String? enBenefits;
  String? hiBenefits;
  String? enProcess;
  String? hiProcess;
  String? enTempleDetails;
  String? hiTempleDetails;
  String? categoryIds;
  int? categoryId;
  int? subCategoryId;
  dynamic subSubCategoryId;
  String? productId;
  String? packagesId;
  dynamic panditAssign;
  String? enPoojaVenue;
  String? hiPoojaVenue;
  DateTime? poojaTime;
  String? weekDays;
  String? videoProvider;
  dynamic videoUrl;
  String? thumbnail;
  String? digitalFileReady;
  String? enMetaTitle;
  dynamic hiMetaTitle;
  String? metaDescription;
  String? metaImage;
  List<Package>? packages;

  Service({
    this.id,
    this.enName,
    this.hiName,
    this.enPoojaHeading,
    this.hiPoojaHeading,
    this.slug,
    this.image,
    this.status,
    this.userId,
    this.addedBy,
    this.enShortBenifits,
    this.hiShortBenifits,
    this.productType,
    this.poojaType,
    this.schedule,
    this.counsellingMainPrice,
    this.counsellingSellingPrice,
    this.enDetails,
    this.hiDetails,
    this.enBenefits,
    this.hiBenefits,
    this.enProcess,
    this.hiProcess,
    this.enTempleDetails,
    this.hiTempleDetails,
    this.categoryIds,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.productId,
    this.packagesId,
    this.panditAssign,
    this.enPoojaVenue,
    this.hiPoojaVenue,
    this.poojaTime,
    this.weekDays,
    this.videoProvider,
    this.videoUrl,
    this.thumbnail,
    this.digitalFileReady,
    this.enMetaTitle,
    this.hiMetaTitle,
    this.metaDescription,
    this.metaImage,
    this.packages,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'],
    enName: json['en_name'],
    hiName: json['hi_name'],
    enPoojaHeading: json['en_pooja_heading'],
    hiPoojaHeading: json['hi_pooja_heading'],
    slug: json['slug'],
    image: json['image'],
    status: json['status'],
    userId: json['user_id'],
    addedBy: json['added_by'],
    enShortBenifits: json['en_short_benifits'],
    hiShortBenifits: json['hi_short_benifits'],
    productType: json['product_type'],
    poojaType: json['pooja_type'],
    schedule: json['schedule'],
    counsellingMainPrice: json['counselling_main_price'],
    counsellingSellingPrice: json['counselling_selling_price'],
    enDetails: json['en_details'],
    hiDetails: json['hi_details'],
    enBenefits: json['en_benefits'],
    hiBenefits: json['hi_benefits'],
    enProcess: json['en_process'],
    hiProcess: json['hi_process'],
    enTempleDetails: json['en_temple_details'],
    hiTempleDetails: json['hi_temple_details'],
    categoryIds: json['category_ids'],
    categoryId: json['category_id'],
    subCategoryId: json['sub_category_id'],
    subSubCategoryId: json['sub_sub_category_id'],
    productId: json['product_id'],
    packagesId: json['packages_id'],
    panditAssign: json['pandit_assign'],
    enPoojaVenue: json['en_pooja_venue'],
    hiPoojaVenue: json['hi_pooja_venue'],
    poojaTime: json['pooja_time'] == null ? null : DateTime.parse(json['pooja_time']),
    weekDays: json['week_days'],
    videoProvider: json['video_provider'],
    videoUrl: json['video_url'],
    thumbnail: json['thumbnail'],
    digitalFileReady: json['digital_file_ready'],
    enMetaTitle: json['en_meta_title'],
    hiMetaTitle: json['hi_meta_title'],
    metaDescription: json['meta_description'],
    metaImage: json['meta_image'],
    packages: json['packages'] == null ? [] : List<Package>.from(json['packages']!.map((x) => Package.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'en_name': enName,
    'hi_name': hiName,
    'en_pooja_heading': enPoojaHeading,
    'hi_pooja_heading': hiPoojaHeading,
    'slug': slug,
    'image': image,
    'status': status,
    'user_id': userId,
    'added_by': addedBy,
    'en_short_benifits': enShortBenifits,
    'hi_short_benifits': hiShortBenifits,
    'product_type': productType,
    'pooja_type': poojaType,
    'schedule': schedule,
    'counselling_main_price': counsellingMainPrice,
    'counselling_selling_price': counsellingSellingPrice,
    'en_details': enDetails,
    'hi_details': hiDetails,
    'en_benefits': enBenefits,
    'hi_benefits': hiBenefits,
    'en_process': enProcess,
    'hi_process': hiProcess,
    'en_temple_details': enTempleDetails,
    'hi_temple_details': hiTempleDetails,
    'category_ids': categoryIds,
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'sub_sub_category_id': subSubCategoryId,
    'product_id': productId,
    'packages_id': packagesId,
    'pandit_assign': panditAssign,
    'en_pooja_venue': enPoojaVenue,
    'hi_pooja_venue': hiPoojaVenue,
    'pooja_time': poojaTime?.toIso8601String(),
    'week_days': weekDays,
    'video_provider': videoProvider,
    'video_url': videoUrl,
    'thumbnail': thumbnail,
    'digital_file_ready': digitalFileReady,
    'en_meta_title': enMetaTitle,
    'hi_meta_title': hiMetaTitle,
    'meta_description': metaDescription,
    'meta_image': metaImage,
    'packages': packages == null ? [] : List<dynamic>.from(packages!.map((x) => x.toJson())),
  };
}

class Package {
  int? id;
  int? panditId;
  String? type;
  int? serviceId;
  int? packageId;
  int? price;
  dynamic thumbnail;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Package({
    this.id,
    this.panditId,
    this.type,
    this.serviceId,
    this.packageId,
    this.price,
    this.thumbnail,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json['id'],
    panditId: json['pandit_id'],
    type: json['type'],
    serviceId: json['service_id'],
    packageId: json['package_id'],
    price: json['price'],
    thumbnail: json['thumbnail'],
    status: json['status'],
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'pandit_id': panditId,
    'type': type,
    'service_id': serviceId,
    'package_id': packageId,
    'price': price,
    'thumbnail': thumbnail,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class Counselling {
  int? id;
  String? enName;
  String? hiName;
  String? enPoojaHeading;
  dynamic hiPoojaHeading;
  String? slug;
  String? image;
  int? status;
  int? userId;
  String? addedBy;
  String? enShortBenifits;
  dynamic hiShortBenifits;
  String? productType;
  int? poojaType;
  dynamic schedule;
  int? counsellingMainPrice;
  int? counsellingSellingPrice;
  String? enDetails;
  dynamic hiDetails;
  dynamic enBenefits;
  dynamic hiBenefits;
  String? enProcess;
  String? hiProcess;
  dynamic enTempleDetails;
  dynamic hiTempleDetails;
  String? categoryIds;
  int? categoryId;
  int? subCategoryId;
  dynamic subSubCategoryId;
  String? productId;
  String? packagesId;
  dynamic panditAssign;
  String? enPoojaVenue;
  String? hiPoojaVenue;
  DateTime? poojaTime;
  dynamic weekDays;
  String? videoProvider;
  String? videoUrl;
  String? thumbnail;
  dynamic digitalFileReady;
  String? enMetaTitle;
  dynamic hiMetaTitle;
  String? metaDescription;
  String? metaImage;
  List<Package>? packages;

  Counselling({
    this.id,
    this.enName,
    this.hiName,
    this.enPoojaHeading,
    this.hiPoojaHeading,
    this.slug,
    this.image,
    this.status,
    this.userId,
    this.addedBy,
    this.enShortBenifits,
    this.hiShortBenifits,
    this.productType,
    this.poojaType,
    this.schedule,
    this.counsellingMainPrice,
    this.counsellingSellingPrice,
    this.enDetails,
    this.hiDetails,
    this.enBenefits,
    this.hiBenefits,
    this.enProcess,
    this.hiProcess,
    this.enTempleDetails,
    this.hiTempleDetails,
    this.categoryIds,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.productId,
    this.packagesId,
    this.panditAssign,
    this.enPoojaVenue,
    this.hiPoojaVenue,
    this.poojaTime,
    this.weekDays,
    this.videoProvider,
    this.videoUrl,
    this.thumbnail,
    this.digitalFileReady,
    this.enMetaTitle,
    this.hiMetaTitle,
    this.metaDescription,
    this.metaImage,
    this.packages,
  });

  factory Counselling.fromJson(Map<String, dynamic> json) => Counselling(
    id: json['id'],
    enName: json['en_name'],
    hiName: json['hi_name'],
    enPoojaHeading: json['en_pooja_heading'],
    hiPoojaHeading: json['hi_pooja_heading'],
    slug: json['slug'],
    image: json['image'],
    status: json['status'],
    userId: json['user_id'],
    addedBy: json['added_by'],
    enShortBenifits: json['en_short_benifits'],
    hiShortBenifits: json['hi_short_benifits'],
    productType: json['product_type'],
    poojaType: json['pooja_type'],
    schedule: json['schedule'],
    counsellingMainPrice: json['counselling_main_price'],
    counsellingSellingPrice: json['counselling_selling_price'],
    enDetails: json['en_details'],
    hiDetails: json['hi_details'],
    enBenefits: json['en_benefits'],
    hiBenefits: json['hi_benefits'],
    enProcess: json['en_process'],
    hiProcess: json['hi_process'],
    enTempleDetails: json['en_temple_details'],
    hiTempleDetails: json['hi_temple_details'],
    categoryIds: json['category_ids'],
    categoryId: json['category_id'],
    subCategoryId: json['sub_category_id'],
    subSubCategoryId: json['sub_sub_category_id'],
    productId: json['product_id'],
    packagesId: json['packages_id'],
    panditAssign: json['pandit_assign'],
    enPoojaVenue: json['en_pooja_venue'],
    hiPoojaVenue: json['hi_pooja_venue'],
    poojaTime: json['pooja_time'] == null ? null : DateTime.parse(json['pooja_time']),
    weekDays: json['week_days'],
    videoProvider: json['video_provider'],
    videoUrl: json['video_url'],
    thumbnail: json['thumbnail'],
    digitalFileReady: json['digital_file_ready'],
    enMetaTitle: json['en_meta_title'],
    hiMetaTitle: json['hi_meta_title'],
    metaDescription: json['meta_description'],
    metaImage: json['meta_image'],
    packages: json['packages'] == null ? [] : List<Package>.from(json['packages']!.map((x) => Package.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'en_name': enName,
    'hi_name': hiName,
    'en_pooja_heading': enPoojaHeading,
    'hi_pooja_heading': hiPoojaHeading,
    'slug': slug,
    'image': image,
    'status': status,
    'user_id': userId,
    'added_by': addedBy,
    'en_short_benifits': enShortBenifits,
    'hi_short_benifits': hiShortBenifits,
    'product_type': productType,
    'pooja_type': poojaType,
    'schedule': schedule,
    'counselling_main_price': counsellingMainPrice,
    'counselling_selling_price': counsellingSellingPrice,
    'en_details': enDetails,
    'hi_details': hiDetails,
    'en_benefits': enBenefits,
    'hi_benefits': hiBenefits,
    'en_process': enProcess,
    'hi_process': hiProcess,
    'en_temple_details': enTempleDetails,
    'hi_temple_details': hiTempleDetails,
    'category_ids': categoryIds,
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'sub_sub_category_id': subSubCategoryId,
    'product_id': productId,
    'packages_id': packagesId,
    'pandit_assign': panditAssign,
    'en_pooja_venue': enPoojaVenue,
    'hi_pooja_venue': hiPoojaVenue,
    'pooja_time': poojaTime?.toIso8601String(),
    'week_days': weekDays,
    'video_provider': videoProvider,
    'video_url': videoUrl,
    'thumbnail': thumbnail,
    'digital_file_ready': digitalFileReady,
    'en_meta_title': enMetaTitle,
    'hi_meta_title': hiMetaTitle,
    'meta_description': metaDescription,
    'meta_image': metaImage,
    'packages': packages == null ? [] : List<dynamic>.from(packages!.map((x) => x.toJson())),
  };
}

class Event {
  int? id;
  dynamic title;
  List<PackageList>? packageList;

  Event({
    this.id,
    this.title,
    this.packageList,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    title: json['title'],
    packageList: json['package_list'] == null ? [] : List<PackageList>.from(json['package_list']!.map((x) => PackageList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'package_list': packageList == null ? [] : List<dynamic>.from(packageList!.map((x) => x.toJson())),
  };
}

class PackageList {
  int? id;
  String? packeageId;
  String? seatsNo;
  String? price;

  PackageList({
    this.id,
    this.packeageId,
    this.seatsNo,
    this.price,
  });

  factory PackageList.fromJson(Map<String, dynamic> json) => PackageList(
    id: json['id'],
    packeageId: json['packeage_id'],
    seatsNo: json['seats_no'],
    price: json['price'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'packeage_id': packeageId,
    'seats_no': seatsNo,
    'price': price,
  };
}
