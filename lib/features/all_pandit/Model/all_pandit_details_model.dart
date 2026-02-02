class AllPanditDetailsModel {
  AllPanditDetailsModel({
    required this.status,
    required this.message,
    required this.guruji,
    required this.packages,
    required this.images,
    required this.puja,
    required this.products,
  });

  final bool? status;
  final String? message;
  final Guruji? guruji;
  final List<PackageElement> packages;
  final List<String> images;
  final Puja? puja;
  final List<Product> products;

  factory AllPanditDetailsModel.fromJson(Map<String, dynamic> json){
    return AllPanditDetailsModel(
      status: json["status"],
      message: json["message"],
      guruji: json["guruji"] == null ? null : Guruji.fromJson(json["guruji"]),
      packages: json["packages"] == null ? [] : List<PackageElement>.from(json["packages"]!.map((x) => PackageElement.fromJson(x))),
      images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
      puja: json["puja"] == null ? null : Puja.fromJson(json["puja"]),
      products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "guruji": guruji?.toJson(),
    "packages": packages.map((x) => x?.toJson()).toList(),
    "images": images.map((x) => x).toList(),
    "puja": puja?.toJson(),
    "products": products.map((x) => x?.toJson()).toList(),
  };

}

class Guruji {
  Guruji({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.image,
    required this.banner,
    required this.password,
    required this.sipUsername,
    required this.sipPassword,
    required this.gender,
    required this.dob,
    required this.pancard,
    required this.pancardImage,
    required this.adharcard,
    required this.adharcardMobile,
    required this.adharcardFrontImage,
    required this.adharcardBackImage,
    required this.type,
    required this.salary,
    required this.state,
    required this.city,
    required this.address,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.primarySkills,
    required this.isPanditPoojaCategory,
    required this.isPanditPooja,
    required this.isPanditVippooja,
    required this.isPanditAnushthan,
    required this.isPanditChadhava,
    required this.isPanditOfflinepooja,
    required this.isPanditPanda,
    required this.isPanditGotra,
    required this.isPanditPrimaryMandir,
    required this.isPanditPrimaryMandirLocation,
    required this.isPanditMinCharge,
    required this.isPanditMaxCharge,
    required this.isPanditPoojaPerDay,
    required this.isPanditPoojaCommission,
    required this.isPanditVippoojaCommission,
    required this.isPanditAnushthanCommission,
    required this.isPanditChadhavaCommission,
    required this.isPanditOfflinepoojaCommission,
    required this.isPanditPoojaTime,
    required this.isPanditVippoojaTime,
    required this.isPanditAnushthanTime,
    required this.isPanditChadhavaTime,
    required this.isPanditOfflinepoojaTime,
    required this.isPanditLiveStreamCharge,
    required this.isPanditLiveStreamCommission,
    required this.otherSkills,
    required this.category,
    required this.language,
    required this.isAstrologerLiveStreamCharge,
    required this.isAstrologerLiveStreamCommission,
    required this.isAstrologerCallCharge,
    required this.isAstrologerCallCommission,
    required this.isAstrologerChatCharge,
    required this.isAstrologerChatCommission,
    required this.isAstrologerReportCharge,
    required this.isAstrologerReportCommission,
    required this.consultationCharge,
    required this.consultationCommission,
    required this.isKundaliMake,
    required this.kundaliMakeCharge,
    required this.kundaliMakeChargePro,
    required this.kundaliMakeCommission,
    required this.kundaliMakeCommissionPro,
    required this.experience,
    required this.dailyHoursContribution,
    required this.officeAddress,
    required this.highestQualification,
    required this.otherQualification,
    required this.secondaryQualification,
    required this.secondaryDegree,
    required this.college,
    required this.onboardYou,
    required this.interviewTime,
    required this.businessSource,
    required this.learnPrimarySkill,
    required this.instagram,
    required this.facebook,
    required this.linkedin,
    required this.youtube,
    required this.website,
    required this.minEarning,
    required this.maxEarning,
    required this.bankName,
    required this.holderName,
    required this.branchName,
    required this.bankIfsc,
    required this.accountNo,
    required this.bankPassbookImage,
    required this.foreignCountry,
    required this.working,
    required this.bio,
    required this.qualities,
    required this.challenge,
    required this.repeatQuestion,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.ordercount,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? mobileNo;
  final String? image;
  final String? banner;
  final String? password;
  final String? sipUsername;
  final String? sipPassword;
  final String? gender;
  final DateTime? dob;
  final String? pancard;
  final String? pancardImage;
  final String? adharcard;
  final dynamic adharcardMobile;
  final String? adharcardFrontImage;
  final String? adharcardBackImage;
  final String? type;
  final int? salary;
  final String? state;
  final String? city;
  final String? address;
  final int? pincode;
  final double? latitude;
  final double? longitude;
  final String? primarySkills;
  final List<IsPanditPoojaCategory> isPanditPoojaCategory;
  final String? isPanditPooja;
  final String? isPanditVippooja;
  final String? isPanditAnushthan;
  final String? isPanditChadhava;
  final String? isPanditOfflinepooja;
  final String? isPanditPanda;
  final String? isPanditGotra;
  final String? isPanditPrimaryMandir;
  final String? isPanditPrimaryMandirLocation;
  final int? isPanditMinCharge;
  final int? isPanditMaxCharge;
  final int? isPanditPoojaPerDay;
  final String? isPanditPoojaCommission;
  final String? isPanditVippoojaCommission;
  final String? isPanditAnushthanCommission;
  final String? isPanditChadhavaCommission;
  final String? isPanditOfflinepoojaCommission;
  final String? isPanditPoojaTime;
  final String? isPanditVippoojaTime;
  final String? isPanditAnushthanTime;
  final String? isPanditChadhavaTime;
  final String? isPanditOfflinepoojaTime;
  final dynamic isPanditLiveStreamCharge;
  final dynamic isPanditLiveStreamCommission;
  final List<OtherSkill> otherSkills;
  final List<Category> category;
  final List<String> language;
  final dynamic isAstrologerLiveStreamCharge;
  final dynamic isAstrologerLiveStreamCommission;
  final dynamic isAstrologerCallCharge;
  final dynamic isAstrologerCallCommission;
  final dynamic isAstrologerChatCharge;
  final dynamic isAstrologerChatCommission;
  final dynamic isAstrologerReportCharge;
  final dynamic isAstrologerReportCommission;
  final String? consultationCharge;
  final String? consultationCommission;
  final int? isKundaliMake;
  final int? kundaliMakeCharge;
  final int? kundaliMakeChargePro;
  final int? kundaliMakeCommission;
  final int? kundaliMakeCommissionPro;
  final int? experience;
  final int? dailyHoursContribution;
  final String? officeAddress;
  final String? highestQualification;
  final dynamic otherQualification;
  final dynamic secondaryQualification;
  final dynamic secondaryDegree;
  final dynamic college;
  final dynamic onboardYou;
  final dynamic interviewTime;
  final dynamic businessSource;
  final dynamic learnPrimarySkill;
  final dynamic instagram;
  final dynamic facebook;
  final dynamic linkedin;
  final dynamic youtube;
  final dynamic website;
  final dynamic minEarning;
  final dynamic maxEarning;
  final String? bankName;
  final String? holderName;
  final String? branchName;
  final String? bankIfsc;
  final String? accountNo;
  final String? bankPassbookImage;
  final String? foreignCountry;
  final dynamic working;
  final dynamic bio;
  final dynamic qualities;
  final dynamic challenge;
  final dynamic repeatQuestion;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int? ordercount;

  factory Guruji.fromJson(Map<String, dynamic> json){
    return Guruji(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      mobileNo: json["mobile_no"],
      image: json["image"],
      banner: json["banner"],
      password: json["password"],
      sipUsername: json["sip_username"],
      sipPassword: json["sip_password"],
      gender: json["gender"],
      dob: DateTime.tryParse(json["dob"] ?? ""),
      pancard: json["pancard"],
      pancardImage: json["pancard_image"],
      adharcard: json["adharcard"],
      adharcardMobile: json["adharcard_mobile"],
      adharcardFrontImage: json["adharcard_front_image"],
      adharcardBackImage: json["adharcard_back_image"],
      type: json["type"],
      salary: json["salary"],
      state: json["state"],
      city: json["city"],
      address: json["address"],
      pincode: json["pincode"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      primarySkills: json["primary_skills"],
      isPanditPoojaCategory: json["is_pandit_pooja_category"] == null ? [] : List<IsPanditPoojaCategory>.from(json["is_pandit_pooja_category"]!.map((x) => IsPanditPoojaCategory.fromJson(x))),
      isPanditPooja: json["is_pandit_pooja"],
      isPanditVippooja: json["is_pandit_vippooja"],
      isPanditAnushthan: json["is_pandit_anushthan"],
      isPanditChadhava: json["is_pandit_chadhava"],
      isPanditOfflinepooja: json["is_pandit_offlinepooja"],
      isPanditPanda: json["is_pandit_panda"],
      isPanditGotra: json["is_pandit_gotra"],
      isPanditPrimaryMandir: json["is_pandit_primary_mandir"],
      isPanditPrimaryMandirLocation: json["is_pandit_primary_mandir_location"],
      isPanditMinCharge: json["is_pandit_min_charge"],
      isPanditMaxCharge: json["is_pandit_max_charge"],
      isPanditPoojaPerDay: json["is_pandit_pooja_per_day"],
      isPanditPoojaCommission: json["is_pandit_pooja_commission"],
      isPanditVippoojaCommission: json["is_pandit_vippooja_commission"],
      isPanditAnushthanCommission: json["is_pandit_anushthan_commission"],
      isPanditChadhavaCommission: json["is_pandit_chadhava_commission"],
      isPanditOfflinepoojaCommission: json["is_pandit_offlinepooja_commission"],
      isPanditPoojaTime: json["is_pandit_pooja_time"],
      isPanditVippoojaTime: json["is_pandit_vippooja_time"],
      isPanditAnushthanTime: json["is_pandit_anushthan_time"],
      isPanditChadhavaTime: json["is_pandit_chadhava_time"],
      isPanditOfflinepoojaTime: json["is_pandit_offlinepooja_time"],
      isPanditLiveStreamCharge: json["is_pandit_live_stream_charge"],
      isPanditLiveStreamCommission: json["is_pandit_live_stream_commission"],
      otherSkills: json["other_skills"] == null ? [] : List<OtherSkill>.from(json["other_skills"]!.map((x) => OtherSkill.fromJson(x))),
      category: json["category"] == null ? [] : List<Category>.from(json["category"]!.map((x) => Category.fromJson(x))),
      language: json["language"] == null ? [] : List<String>.from(json["language"]!.map((x) => x)),
      isAstrologerLiveStreamCharge: json["is_astrologer_live_stream_charge"],
      isAstrologerLiveStreamCommission: json["is_astrologer_live_stream_commission"],
      isAstrologerCallCharge: json["is_astrologer_call_charge"],
      isAstrologerCallCommission: json["is_astrologer_call_commission"],
      isAstrologerChatCharge: json["is_astrologer_chat_charge"],
      isAstrologerChatCommission: json["is_astrologer_chat_commission"],
      isAstrologerReportCharge: json["is_astrologer_report_charge"],
      isAstrologerReportCommission: json["is_astrologer_report_commission"],
      consultationCharge: json["consultation_charge"],
      consultationCommission: json["consultation_commission"],
      isKundaliMake: json["is_kundali_make"],
      kundaliMakeCharge: json["kundali_make_charge"],
      kundaliMakeChargePro: json["kundali_make_charge_pro"],
      kundaliMakeCommission: json["kundali_make_commission"],
      kundaliMakeCommissionPro: json["kundali_make_commission_pro"],
      experience: json["experience"],
      dailyHoursContribution: json["daily_hours_contribution"],
      officeAddress: json["office_address"],
      highestQualification: json["highest_qualification"],
      otherQualification: json["other_qualification"],
      secondaryQualification: json["secondary_qualification"],
      secondaryDegree: json["secondary_degree"],
      college: json["college"],
      onboardYou: json["onboard_you"],
      interviewTime: json["interview_time"],
      businessSource: json["business_source"],
      learnPrimarySkill: json["learn_primary_skill"],
      instagram: json["instagram"],
      facebook: json["facebook"],
      linkedin: json["linkedin"],
      youtube: json["youtube"],
      website: json["website"],
      minEarning: json["min_earning"],
      maxEarning: json["max_earning"],
      bankName: json["bank_name"],
      holderName: json["holder_name"],
      branchName: json["branch_name"],
      bankIfsc: json["bank_ifsc"],
      accountNo: json["account_no"],
      bankPassbookImage: json["bank_passbook_image"],
      foreignCountry: json["foreign_country"],
      working: json["working"],
      bio: json["bio"],
      qualities: json["qualities"],
      challenge: json["challenge"],
      repeatQuestion: json["repeat_question"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      ordercount: json["ordercount"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "image": image,
    "banner": banner,
    "password": password,
    "sip_username": sipUsername,
    "sip_password": sipPassword,
    "gender": gender,
    "dob": "${dob!.year.toString().padLeft(4,'0')}-${dob!.month.toString().padLeft(2,'0')}-${dob!.day.toString().padLeft(2,'0')}",
    "pancard": pancard,
    "pancard_image": pancardImage,
    "adharcard": adharcard,
    "adharcard_mobile": adharcardMobile,
    "adharcard_front_image": adharcardFrontImage,
    "adharcard_back_image": adharcardBackImage,
    "type": type,
    "salary": salary,
    "state": state,
    "city": city,
    "address": address,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "primary_skills": primarySkills,
    "is_pandit_pooja_category": isPanditPoojaCategory.map((x) => x?.toJson()).toList(),
    "is_pandit_pooja": isPanditPooja,
    "is_pandit_vippooja": isPanditVippooja,
    "is_pandit_anushthan": isPanditAnushthan,
    "is_pandit_chadhava": isPanditChadhava,
    "is_pandit_offlinepooja": isPanditOfflinepooja,
    "is_pandit_panda": isPanditPanda,
    "is_pandit_gotra": isPanditGotra,
    "is_pandit_primary_mandir": isPanditPrimaryMandir,
    "is_pandit_primary_mandir_location": isPanditPrimaryMandirLocation,
    "is_pandit_min_charge": isPanditMinCharge,
    "is_pandit_max_charge": isPanditMaxCharge,
    "is_pandit_pooja_per_day": isPanditPoojaPerDay,
    "is_pandit_pooja_commission": isPanditPoojaCommission,
    "is_pandit_vippooja_commission": isPanditVippoojaCommission,
    "is_pandit_anushthan_commission": isPanditAnushthanCommission,
    "is_pandit_chadhava_commission": isPanditChadhavaCommission,
    "is_pandit_offlinepooja_commission": isPanditOfflinepoojaCommission,
    "is_pandit_pooja_time": isPanditPoojaTime,
    "is_pandit_vippooja_time": isPanditVippoojaTime,
    "is_pandit_anushthan_time": isPanditAnushthanTime,
    "is_pandit_chadhava_time": isPanditChadhavaTime,
    "is_pandit_offlinepooja_time": isPanditOfflinepoojaTime,
    "is_pandit_live_stream_charge": isPanditLiveStreamCharge,
    "is_pandit_live_stream_commission": isPanditLiveStreamCommission,
    "other_skills": otherSkills.map((x) => x?.toJson()).toList(),
    "category": category.map((x) => x?.toJson()).toList(),
    "language": language.map((x) => x).toList(),
    "is_astrologer_live_stream_charge": isAstrologerLiveStreamCharge,
    "is_astrologer_live_stream_commission": isAstrologerLiveStreamCommission,
    "is_astrologer_call_charge": isAstrologerCallCharge,
    "is_astrologer_call_commission": isAstrologerCallCommission,
    "is_astrologer_chat_charge": isAstrologerChatCharge,
    "is_astrologer_chat_commission": isAstrologerChatCommission,
    "is_astrologer_report_charge": isAstrologerReportCharge,
    "is_astrologer_report_commission": isAstrologerReportCommission,
    "consultation_charge": consultationCharge,
    "consultation_commission": consultationCommission,
    "is_kundali_make": isKundaliMake,
    "kundali_make_charge": kundaliMakeCharge,
    "kundali_make_charge_pro": kundaliMakeChargePro,
    "kundali_make_commission": kundaliMakeCommission,
    "kundali_make_commission_pro": kundaliMakeCommissionPro,
    "experience": experience,
    "daily_hours_contribution": dailyHoursContribution,
    "office_address": officeAddress,
    "highest_qualification": highestQualification,
    "other_qualification": otherQualification,
    "secondary_qualification": secondaryQualification,
    "secondary_degree": secondaryDegree,
    "college": college,
    "onboard_you": onboardYou,
    "interview_time": interviewTime,
    "business_source": businessSource,
    "learn_primary_skill": learnPrimarySkill,
    "instagram": instagram,
    "facebook": facebook,
    "linkedin": linkedin,
    "youtube": youtube,
    "website": website,
    "min_earning": minEarning,
    "max_earning": maxEarning,
    "bank_name": bankName,
    "holder_name": holderName,
    "branch_name": branchName,
    "bank_ifsc": bankIfsc,
    "account_no": accountNo,
    "bank_passbook_image": bankPassbookImage,
    "foreign_country": foreignCountry,
    "working": working,
    "bio": bio,
    "qualities": qualities,
    "challenge": challenge,
    "repeat_question": repeatQuestion,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "ordercount": ordercount,
  };

}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  final int? id;
  final String? name;
  final String? image;
  final bool? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> translations;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "translations": translations.map((x) => x).toList(),
  };

}

class IsPanditPoojaCategory {
  IsPanditPoojaCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.parentId,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.homeStatus,
    required this.priority,
    required this.translations,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? icon;
  final int? parentId;
  final int? position;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? homeStatus;
  final int? priority;
  final List<dynamic> translations;

  factory IsPanditPoojaCategory.fromJson(Map<String, dynamic> json){
    return IsPanditPoojaCategory(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      icon: json["icon"],
      parentId: json["parent_id"],
      position: json["position"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      homeStatus: json["home_status"],
      priority: json["priority"],
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "icon": icon,
    "parent_id": parentId,
    "position": position,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "home_status": homeStatus,
    "priority": priority,
    "translations": translations.map((x) => x).toList(),
  };

}

class OtherSkill {
  OtherSkill({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  final int? id;
  final String? name;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> translations;

  factory OtherSkill.fromJson(Map<String, dynamic> json){
    return OtherSkill(
      id: json["id"],
      name: json["name"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "translations": translations.map((x) => x).toList(),
  };

}

class PackageElement {
  PackageElement({
    required this.id,
    required this.panditId,
    required this.serviceId,
    required this.packageId,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.package,
  });

  final int? id;
  final int? panditId;
  final int? serviceId;
  final int? packageId;
  final int? price;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PackagePackage? package;

  factory PackageElement.fromJson(Map<String, dynamic> json){
    return PackageElement(
      id: json["id"],
      panditId: json["pandit_id"],
      serviceId: json["service_id"],
      packageId: json["package_id"],
      price: json["price"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      package: json["package"] == null ? null : PackagePackage.fromJson(json["package"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "pandit_id": panditId,
    "service_id": serviceId,
    "package_id": packageId,
    "price": price,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "package": package?.toJson(),
  };

}

class PackagePackage {
  PackagePackage({
    required this.id,
    required this.title,
    required this.slug,
    required this.type,
    required this.person,
    required this.color,
    required this.image,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  final int? id;
  final String? title;
  final String? slug;
  final String? type;
  final int? person;
  final String? color;
  final dynamic image;
  final String? description;
  final bool? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> translations;

  factory PackagePackage.fromJson(Map<String, dynamic> json){
    return PackagePackage(
      id: json["id"],
      title: json["title"],
      slug: json["slug"],
      type: json["type"],
      person: json["person"],
      color: json["color"],
      image: json["image"],
      description: json["description"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "type": type,
    "person": person,
    "color": color,
    "image": image,
    "description": description,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "translations": translations.map((x) => x).toList(),
  };

}

class Product {
  Product({
    required this.id,
    required this.addedBy,
    required this.userId,
    required this.name,
    required this.slug,
    required this.productType,
    required this.categoryIds,
    required this.categoryId,
    required this.subCategoryId,
    required this.subSubCategoryId,
    required this.brandId,
    required this.unit,
    required this.minQty,
    required this.refundable,
    required this.digitalProductType,
    required this.digitalFileReady,
    required this.images,
    required this.colorImage,
    required this.thumbnail,
    required this.featured,
    required this.flashDeal,
    required this.videoProvider,
    required this.videoUrl,
    required this.colors,
    required this.variantProduct,
    required this.attributes,
    required this.choiceOptions,
    required this.variation,
    required this.published,
    required this.packagePrice,
    required this.productPrice,
    required this.codPrice,
    required this.forwardPrice,
    required this.reversePrice,
    required this.unitPrice,
    required this.purchasePrice,
    required this.tax,
    required this.taxType,
    required this.taxModel,
    required this.discount,
    required this.discountType,
    required this.currentStock,
    required this.minimumOrderQty,
    required this.details,
    required this.freeShipping,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.featuredStatus,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.requestStatus,
    required this.deniedNote,
    required this.shippingCost,
    required this.multiplyQty,
    required this.tempShippingCost,
    required this.isShippingCostUpdated,
    required this.code,
    required this.productRefund,
    required this.translations,
    required this.reviews,
  });

  final int? id;
  final String? addedBy;
  final int? userId;
  final String? name;
  final String? slug;
  final String? productType;
  final String? categoryIds;
  final int? categoryId;
  final int? subCategoryId;
  final dynamic subSubCategoryId;
  final int? brandId;
  final dynamic unit;
  final int? minQty;
  final int? refundable;
  final dynamic digitalProductType;
  final dynamic digitalFileReady;
  final String? images;
  final String? colorImage;
  final String? thumbnail;
  final dynamic featured;
  final dynamic flashDeal;
  final String? videoProvider;
  final String? videoUrl;
  final String? colors;
  final int? variantProduct;
  final String? attributes;
  final String? choiceOptions;
  final String? variation;
  final int? published;
  final int? packagePrice;
  final int? productPrice;
  final String? codPrice;
  final int? forwardPrice;
  final int? reversePrice;
  final int? unitPrice;
  final int? purchasePrice;
  final int? tax;
  final String? taxType;
  final String? taxModel;
  final int? discount;
  final String? discountType;
  final int? currentStock;
  final int? minimumOrderQty;
  final String? details;
  final int? freeShipping;
  final dynamic attachment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? status;
  final int? featuredStatus;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaImage;
  final int? requestStatus;
  final dynamic deniedNote;
  final int? shippingCost;
  final int? multiplyQty;
  final dynamic tempShippingCost;
  final dynamic isShippingCostUpdated;
  final String? code;
  final int? productRefund;
  final List<dynamic> translations;
  final List<dynamic> reviews;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json["id"],
      addedBy: json["added_by"],
      userId: json["user_id"],
      name: json["name"],
      slug: json["slug"],
      productType: json["product_type"],
      categoryIds: json["category_ids"],
      categoryId: json["category_id"],
      subCategoryId: json["sub_category_id"],
      subSubCategoryId: json["sub_sub_category_id"],
      brandId: json["brand_id"],
      unit: json["unit"],
      minQty: json["min_qty"],
      refundable: json["refundable"],
      digitalProductType: json["digital_product_type"],
      digitalFileReady: json["digital_file_ready"],
      images: json["images"],
      colorImage: json["color_image"],
      thumbnail: json["thumbnail"],
      featured: json["featured"],
      flashDeal: json["flash_deal"],
      videoProvider: json["video_provider"],
      videoUrl: json["video_url"],
      colors: json["colors"],
      variantProduct: json["variant_product"],
      attributes: json["attributes"],
      choiceOptions: json["choice_options"],
      variation: json["variation"],
      published: json["published"],
      packagePrice: json["package_price"],
      productPrice: json["product_price"],
      codPrice: json["cod_price"],
      forwardPrice: json["forward_price"],
      reversePrice: json["reverse_price"],
      unitPrice: json["unit_price"],
      purchasePrice: json["purchase_price"],
      tax: json["tax"],
      taxType: json["tax_type"],
      taxModel: json["tax_model"],
      discount: json["discount"],
      discountType: json["discount_type"],
      currentStock: json["current_stock"],
      minimumOrderQty: json["minimum_order_qty"],
      details: json["details"],
      freeShipping: json["free_shipping"],
      attachment: json["attachment"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      status: json["status"],
      featuredStatus: json["featured_status"],
      metaTitle: json["meta_title"],
      metaDescription: json["meta_description"],
      metaImage: json["meta_image"],
      requestStatus: json["request_status"],
      deniedNote: json["denied_note"],
      shippingCost: json["shipping_cost"],
      multiplyQty: json["multiply_qty"],
      tempShippingCost: json["temp_shipping_cost"],
      isShippingCostUpdated: json["is_shipping_cost_updated"],
      code: json["code"],
      productRefund: json["product_refund"],
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
      reviews: json["reviews"] == null ? [] : List<dynamic>.from(json["reviews"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "added_by": addedBy,
    "user_id": userId,
    "name": name,
    "slug": slug,
    "product_type": productType,
    "category_ids": categoryIds,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "sub_sub_category_id": subSubCategoryId,
    "brand_id": brandId,
    "unit": unit,
    "min_qty": minQty,
    "refundable": refundable,
    "digital_product_type": digitalProductType,
    "digital_file_ready": digitalFileReady,
    "images": images,
    "color_image": colorImage,
    "thumbnail": thumbnail,
    "featured": featured,
    "flash_deal": flashDeal,
    "video_provider": videoProvider,
    "video_url": videoUrl,
    "colors": colors,
    "variant_product": variantProduct,
    "attributes": attributes,
    "choice_options": choiceOptions,
    "variation": variation,
    "published": published,
    "package_price": packagePrice,
    "product_price": productPrice,
    "cod_price": codPrice,
    "forward_price": forwardPrice,
    "reverse_price": reversePrice,
    "unit_price": unitPrice,
    "purchase_price": purchasePrice,
    "tax": tax,
    "tax_type": taxType,
    "tax_model": taxModel,
    "discount": discount,
    "discount_type": discountType,
    "current_stock": currentStock,
    "minimum_order_qty": minimumOrderQty,
    "details": details,
    "free_shipping": freeShipping,
    "attachment": attachment,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "featured_status": featuredStatus,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "meta_image": metaImage,
    "request_status": requestStatus,
    "denied_note": deniedNote,
    "shipping_cost": shippingCost,
    "multiply_qty": multiplyQty,
    "temp_shipping_cost": tempShippingCost,
    "is_shipping_cost_updated": isShippingCostUpdated,
    "code": code,
    "product_refund": productRefund,
    "translations": translations.map((x) => x).toList(),
    "reviews": reviews.map((x) => x).toList(),
  };

}

class Puja {
  Puja({
    required this.id,
    required this.isVisibleCity,
    required this.visibleCity,
    required this.userId,
    required this.addedBy,
    required this.name,
    required this.slug,
    required this.productType,
    required this.schedule,
    required this.poojaType,
    required this.counsellingMainPrice,
    required this.counsellingSellingPrice,
    required this.shortBenifits,
    required this.poojaHeading,
    required this.details,
    required this.benefits,
    required this.process,
    required this.templeDetails,
    required this.categoryIds,
    required this.categoryId,
    required this.subCategoryId,
    required this.subSubCategoryId,
    required this.productId,
    required this.prashadamId,
    required this.packagesId,
    required this.panditAssign,
    required this.poojaVenue,
    required this.poojaTime,
    required this.weekDays,
    required this.digitalProductType,
    required this.images,
    required this.videoProvider,
    required this.videoUrl,
    required this.thumbnail,
    required this.digitalFileReady,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.poojaOrderReviewCount,
    required this.reviewAvgRating,
    required this.finalVenue,
    required this.package,
    required this.translations,
  });

  final int? id;
  final int? isVisibleCity;
  final String? visibleCity;
  final int? userId;
  final String? addedBy;
  final String? name;
  final String? slug;
  final String? productType;
  final dynamic schedule;
  final int? poojaType;
  final dynamic counsellingMainPrice;
  final dynamic counsellingSellingPrice;
  final String? shortBenifits;
  final String? poojaHeading;
  final String? details;
  final String? benefits;
  final String? process;
  final String? templeDetails;
  final String? categoryIds;
  final int? categoryId;
  final int? subCategoryId;
  final dynamic subSubCategoryId;
  final String? productId;
  final dynamic prashadamId;
  final String? packagesId;
  final dynamic panditAssign;
  final String? poojaVenue;
  final DateTime? poojaTime;
  final String? weekDays;
  final String? digitalProductType;
  final String? images;
  final String? videoProvider;
  final String? videoUrl;
  final String? thumbnail;
  final dynamic digitalFileReady;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaImage;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? poojaOrderReviewCount;
  final String? reviewAvgRating;
  final String? finalVenue;
  final List<dynamic> package;
  final List<dynamic> translations;

  factory Puja.fromJson(Map<String, dynamic> json){
    return Puja(
      id: json["id"],
      isVisibleCity: json["is_visible_city"],
      visibleCity: json["visible_city"],
      userId: json["user_id"],
      addedBy: json["added_by"],
      name: json["name"],
      slug: json["slug"],
      productType: json["product_type"],
      schedule: json["schedule"],
      poojaType: json["pooja_type"],
      counsellingMainPrice: json["counselling_main_price"],
      counsellingSellingPrice: json["counselling_selling_price"],
      shortBenifits: json["short_benifits"],
      poojaHeading: json["pooja_heading"],
      details: json["details"],
      benefits: json["benefits"],
      process: json["process"],
      templeDetails: json["temple_details"],
      categoryIds: json["category_ids"],
      categoryId: json["category_id"],
      subCategoryId: json["sub_category_id"],
      subSubCategoryId: json["sub_sub_category_id"],
      productId: json["product_id"],
      prashadamId: json["prashadam_id"],
      packagesId: json["packages_id"],
      panditAssign: json["pandit_assign"],
      poojaVenue: json["pooja_venue"],
      poojaTime: DateTime.tryParse(json["pooja_time"] ?? ""),
      weekDays: json["week_days"],
      digitalProductType: json["digital_product_type"],
      images: json["images"],
      videoProvider: json["video_provider"],
      videoUrl: json["video_url"],
      thumbnail: json["thumbnail"],
      digitalFileReady: json["digital_file_ready"],
      metaTitle: json["meta_title"],
      metaDescription: json["meta_description"],
      metaImage: json["meta_image"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      poojaOrderReviewCount: json["pooja_order_review_count"],
      reviewAvgRating: json["review_avg_rating"],
      finalVenue: json["final_venue"],
      package: json["package"] == null ? [] : List<dynamic>.from(json["package"]!.map((x) => x)),
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_visible_city": isVisibleCity,
    "visible_city": visibleCity,
    "user_id": userId,
    "added_by": addedBy,
    "name": name,
    "slug": slug,
    "product_type": productType,
    "schedule": schedule,
    "pooja_type": poojaType,
    "counselling_main_price": counsellingMainPrice,
    "counselling_selling_price": counsellingSellingPrice,
    "short_benifits": shortBenifits,
    "pooja_heading": poojaHeading,
    "details": details,
    "benefits": benefits,
    "process": process,
    "temple_details": templeDetails,
    "category_ids": categoryIds,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "sub_sub_category_id": subSubCategoryId,
    "product_id": productId,
    "prashadam_id": prashadamId,
    "packages_id": packagesId,
    "pandit_assign": panditAssign,
    "pooja_venue": poojaVenue,
    "pooja_time": poojaTime?.toIso8601String(),
    "week_days": weekDays,
    "digital_product_type": digitalProductType,
    "images": images,
    "video_provider": videoProvider,
    "video_url": videoUrl,
    "thumbnail": thumbnail,
    "digital_file_ready": digitalFileReady,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "meta_image": metaImage,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "pooja_order_review_count": poojaOrderReviewCount,
    "review_avg_rating": reviewAvgRating,
    "final_venue": finalVenue,
    "package": package.map((x) => x).toList(),
    "translations": translations.map((x) => x).toList(),
  };

}
