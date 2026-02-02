class AllPanditModel {
  AllPanditModel({
    required this.status,
    required this.message,
    required this.totalGuruji,
    required this.data,
  });

  final bool? status;
  final String? message;
  final int? totalGuruji;
  final List<AllPanditData> data;

  factory AllPanditModel.fromJson(Map<String, dynamic> json){
    return AllPanditModel(
      status: json["status"],
      message: json["message"],
      totalGuruji: json["total_guruji"],
      data: json["data"] == null ? [] : List<AllPanditData>.from(json["data"]!.map((x) => AllPanditData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total_guruji": totalGuruji,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class AllPanditData {
  AllPanditData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.image,
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
    required this.vendorId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.serviceCount,
    required this.ordercount,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? mobileNo;
  final String? image;
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
  final String? college;
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
  final String? working;
  final dynamic bio;
  final dynamic qualities;
  final dynamic challenge;
  final dynamic repeatQuestion;
  final dynamic vendorId;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int? serviceCount;
  final int? ordercount;

  factory AllPanditData.fromJson(Map<String, dynamic> json){
    return AllPanditData(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      mobileNo: json["mobile_no"],
      image: json["image"],
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
      vendorId: json["vendor_id"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      serviceCount: json["service_count"],
      ordercount: json["ordercount"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "image": image,
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
    "vendor_id": vendorId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "service_count": serviceCount,
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
