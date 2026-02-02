import 'dart:convert';

class AstrologersModel {
  List<AstrologerListModelData>? data;
  dynamic? total;
  dynamic? page;
  dynamic? totalPages;

  AstrologersModel({this.data, this.total, this.page, this.totalPages});

  AstrologersModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AstrologerListModelData>[];
      json['data'].forEach((v) {
        data!.add(AstrologerListModelData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['page'] = page;
    data['totalPages'] = totalPages;
    return data;
  }
}

class AstrologerListModelData {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic mobileNo;
  dynamic image;
  dynamic password;
  dynamic gender;
  dynamic dob;
  dynamic pancard;
  dynamic pancardImage;
  dynamic adharcard;
  dynamic adharcardFrontImage;
  dynamic adharcardBackImage;
  dynamic type;
  dynamic salary;
  dynamic state;
  dynamic city;
  dynamic address;
  dynamic pincode;
  dynamic latitude;
  dynamic longitude;
  dynamic primarySkills;
  dynamic isPanditPoojaCategory;
  dynamic isPanditPooja;
  dynamic isPanditVippooja;
  dynamic isPanditAnushthan;
  dynamic isPanditChadhava;
  dynamic isPanditOfflinepooja;
  dynamic isPanditPanda;
  dynamic isPanditGotra;
  dynamic isPanditPrimaryMandir;
  dynamic isPanditPrimaryMandirLocation;
  dynamic isPanditMinCharge;
  dynamic isPanditMaxCharge;
  dynamic isPanditPoojaPerDay;
  dynamic isPanditPoojaCommission;
  dynamic isPanditVippoojaCommission;
  dynamic isPanditAnushthanCommission;
  dynamic isPanditChadhavaCommission;
  dynamic isPanditOfflinepoojaCommission;
  dynamic isPanditPoojaTime;
  dynamic isPanditVippoojaTime;
  dynamic isPanditAnushthanTime;
  dynamic isPanditChadhavaTime;
  dynamic isPanditOfflinepoojaTime;
  dynamic isPanditLiveStreamCharge;
  dynamic isPanditLiveStreamCommission;
  dynamic otherSkills;
  dynamic category;
  dynamic language;
  dynamic isAstrologerLiveStreamCharge;
  dynamic isAstrologerLiveStreamCommission;
  dynamic isAstrologerCallCharge;
  dynamic isAstrologerCallCommission;
  dynamic isAstrologerChatCharge;
  dynamic isAstrologerChatCommission;
  dynamic isAstrologerReportCharge;
  dynamic isAstrologerReportCommission;
  dynamic consultationCharge;
  dynamic consultationCommission;
  dynamic isKundaliMake;
  dynamic kundaliMakeCharge;
  dynamic kundaliMakeChargePro;
  dynamic kundaliMakeCommission;
  dynamic kundaliMakeCommissionPro;
  dynamic experience;
  dynamic dailyHoursContribution;
  dynamic officeAddress;
  dynamic highestQualification;
  dynamic otherQualification;
  dynamic secondaryQualification;
  dynamic secondaryDegree;
  dynamic college;
  dynamic onboardYou;
  dynamic interviewTime;
  dynamic businessSource;
  dynamic learnPrimarySkill;
  dynamic instagram;
  dynamic facebook;
  dynamic linkedin;
  dynamic youtube;
  dynamic website;
  dynamic minEarning;
  dynamic maxEarning;
  dynamic bankName;
  dynamic holderName;
  dynamic branchName;
  dynamic bankIfsc;
  dynamic accountNo;
  dynamic bankPassbookImage;
  dynamic foreignCountry;
  dynamic working;
  dynamic bio;
  dynamic qualities;
  dynamic challenge;
  dynamic repeatQuestion;
  dynamic status;

  AstrologerListModelData(
      {this.id,
      this.name,
      this.email,
      this.mobileNo,
      this.image,
      this.password,
      this.gender,
      this.dob,
      this.pancard,
      this.pancardImage,
      this.adharcard,
      this.adharcardFrontImage,
      this.adharcardBackImage,
      this.type,
      this.salary,
      this.state,
      this.city,
      this.address,
      this.pincode,
      this.latitude,
      this.longitude,
      this.primarySkills,
      this.isPanditPoojaCategory,
      this.isPanditPooja,
      this.isPanditVippooja,
      this.isPanditAnushthan,
      this.isPanditChadhava,
      this.isPanditOfflinepooja,
      this.isPanditPanda,
      this.isPanditGotra,
      this.isPanditPrimaryMandir,
      this.isPanditPrimaryMandirLocation,
      this.isPanditMinCharge,
      this.isPanditMaxCharge,
      this.isPanditPoojaPerDay,
      this.isPanditPoojaCommission,
      this.isPanditVippoojaCommission,
      this.isPanditAnushthanCommission,
      this.isPanditChadhavaCommission,
      this.isPanditOfflinepoojaCommission,
      this.isPanditPoojaTime,
      this.isPanditVippoojaTime,
      this.isPanditAnushthanTime,
      this.isPanditChadhavaTime,
      this.isPanditOfflinepoojaTime,
      this.isPanditLiveStreamCharge,
      this.isPanditLiveStreamCommission,
      this.otherSkills,
      this.category,
      this.language,
      this.isAstrologerLiveStreamCharge,
      this.isAstrologerLiveStreamCommission,
      this.isAstrologerCallCharge,
      this.isAstrologerCallCommission,
      this.isAstrologerChatCharge,
      this.isAstrologerChatCommission,
      this.isAstrologerReportCharge,
      this.isAstrologerReportCommission,
      this.consultationCharge,
      this.consultationCommission,
      this.isKundaliMake,
      this.kundaliMakeCharge,
      this.kundaliMakeChargePro,
      this.kundaliMakeCommission,
      this.kundaliMakeCommissionPro,
      this.experience,
      this.dailyHoursContribution,
      this.officeAddress,
      this.highestQualification,
      this.otherQualification,
      this.secondaryQualification,
      this.secondaryDegree,
      this.college,
      this.onboardYou,
      this.interviewTime,
      this.businessSource,
      this.learnPrimarySkill,
      this.instagram,
      this.facebook,
      this.linkedin,
      this.youtube,
      this.website,
      this.minEarning,
      this.maxEarning,
      this.bankName,
      this.holderName,
      this.branchName,
      this.bankIfsc,
      this.accountNo,
      this.bankPassbookImage,
      this.foreignCountry,
      this.working,
      this.bio,
      this.qualities,
      this.challenge,
      this.repeatQuestion,
      this.status});

  AstrologerListModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    image = json['image'];
    password = json['password'];
    gender = json['gender'];
    dob = json['dob'];
    pancard = json['pancard'];
    pancardImage = json['pancard_image'];
    adharcard = json['adharcard'];
    adharcardFrontImage = json['adharcard_front_image'];
    adharcardBackImage = json['adharcard_back_image'];
    type = json['type'];
    salary = json['salary'];
    city = json['city'];
    address = json['address'];
    pincode = json['pincode'];
    latitude = json['latitude'];    
    longitude = json['longitude'];
    primarySkills = json['primary_skills'];
    isPanditPoojaCategory = json['is_pandit_pooja_category'];
    isPanditPooja = json['is_pandit_pooja'];
    isPanditVippooja = json['is_pandit_vippooja'];
    isPanditAnushthan = json['is_pandit_anushthan'];
    isPanditChadhava = json['is_pandit_chadhava'];
    isPanditOfflinepooja = json['is_pandit_offlinepooja'];
    isPanditPanda = json['is_pandit_panda'];
    isPanditGotra = json['is_pandit_gotra'];
    isPanditPrimaryMandir = json['is_pandit_primary_mandir'];
    isPanditPrimaryMandirLocation = json['is_pandit_primary_mandir_location'];
    isPanditMinCharge = json['is_pandit_min_charge'];
    isPanditMaxCharge = json['is_pandit_max_charge'];
    isPanditPoojaPerDay = json['is_pandit_pooja_per_day'];
    isPanditPoojaCommission = json['is_pandit_pooja_commission'];
    isPanditVippoojaCommission = json['is_pandit_vippooja_commission'];
    isPanditAnushthanCommission = json['is_pandit_anushthan_commission'];
    isPanditChadhavaCommission = json['is_pandit_chadhava_commission'];
    isPanditOfflinepoojaCommission = json['is_pandit_offlinepooja_commission'];
    isPanditPoojaTime = json['is_pandit_pooja_time'];
    isPanditVippoojaTime = json['is_pandit_vippooja_time'];
    isPanditAnushthanTime = json['is_pandit_anushthan_time'];
    isPanditChadhavaTime = json['is_pandit_chadhava_time'];
    isPanditOfflinepoojaTime = json['is_pandit_offlinepooja_time'];
    isPanditLiveStreamCharge = json['is_pandit_live_stream_charge'];
    isPanditLiveStreamCommission = json['is_pandit_live_stream_commission'];
    otherSkills = json['other_skills'];
    category = json['category'];
    language = json['language'];
    isAstrologerLiveStreamCharge = json['is_astrologer_live_stream_charge'];
    isAstrologerLiveStreamCommission =
        json['is_astrologer_live_stream_commission'];
    isAstrologerCallCharge = json['is_astrologer_call_charge'];
    isAstrologerCallCommission = json['is_astrologer_call_commission'];
    isAstrologerChatCharge = json['is_astrologer_chat_charge'];
    isAstrologerChatCommission = json['is_astrologer_chat_commission'];    
    isAstrologerReportCharge = json['is_astrologer_report_charge'];
    isAstrologerReportCommission = json['is_astrologer_report_commission'];
    consultationCharge = json['consultation_charge'];
    consultationCommission = json['consultation_commission'];
    isKundaliMake = json['is_kundali_make'];
    kundaliMakeCharge = json['kundali_make_charge'];
    kundaliMakeChargePro = json['kundali_make_charge_pro'];
    kundaliMakeCommission = json['kundali_make_commission'];
    kundaliMakeCommissionPro = json['kundali_make_commission_pro'];
    experience = json['experience'];
    dailyHoursContribution = json['daily_hours_contribution'];
    officeAddress = json['office_address'];
    highestQualification = json['highest_qualification'];
    otherQualification = json['other_qualification'];
    secondaryQualification = json['secondary_qualification'];
    secondaryDegree = json['secondary_degree'];
    college = json['college'];
    onboardYou = json['onboard_you'];
    interviewTime = json['interview_time'];
    businessSource = json['business_source'];
    learnPrimarySkill = json['learn_primary_skill'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    linkedin = json['linkedin'];
    youtube = json['youtube'];
    website = json['website'];
    minEarning = json['min_earning'];
    maxEarning = json['max_earning'];
    bankName = json['bank_name'];
    holderName = json['holder_name'];
    branchName = json['branch_name'];
    bankIfsc = json['bank_ifsc'];
    accountNo = json['account_no'];
    bankPassbookImage = json['bank_passbook_image'];
    foreignCountry = json['foreign_country'];
    working = json['working'];
    bio = json['bio'];
    qualities = json['qualities'];
    challenge = json['challenge'];
    repeatQuestion = json['repeat_question'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile_no'] = mobileNo;
    data['image'] = image;
    data['password'] = password;
    data['gender'] = gender;
    data['dob'] = dob;
    data['pancard'] = pancard;
    data['pancard_image'] = pancardImage;
    data['adharcard'] = adharcard;
    data['adharcard_front_image'] = adharcardFrontImage;
    data['adharcard_back_image'] = adharcardBackImage;
    data['type'] = type;
    data['salary'] = salary;
    data['state'] = state;
    data['city'] = city;
    data['address'] = address;
    data['pincode'] = pincode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['primary_skills'] = primarySkills;
    data['is_pandit_pooja_category'] = isPanditPoojaCategory;
    data['is_pandit_pooja'] = isPanditPooja;
    data['is_pandit_vippooja'] = isPanditVippooja;
    data['is_pandit_anushthan'] = isPanditAnushthan;
    data['is_pandit_chadhava'] = isPanditChadhava;
    data['is_pandit_offlinepooja'] = isPanditOfflinepooja;
    data['is_pandit_panda'] = isPanditPanda;
    data['is_pandit_gotra'] = isPanditGotra;
    data['is_pandit_primary_mandir'] = isPanditPrimaryMandir;
    data['is_pandit_primary_mandir_location'] = isPanditPrimaryMandirLocation;
    data['is_pandit_min_charge'] = isPanditMinCharge;
    data['is_pandit_max_charge'] = isPanditMaxCharge;
    data['is_pandit_pooja_per_day'] = isPanditPoojaPerDay;
    data['is_pandit_pooja_commission'] = isPanditPoojaCommission;
    data['is_pandit_vippooja_commission'] = isPanditVippoojaCommission;
    data['is_pandit_anushthan_commission'] = isPanditAnushthanCommission;
    data['is_pandit_chadhava_commission'] = isPanditChadhavaCommission;
    data['is_pandit_offlinepooja_commission'] = isPanditOfflinepoojaCommission;
    data['is_pandit_pooja_time'] = isPanditPoojaTime;
    data['is_pandit_vippooja_time'] = isPanditVippoojaTime;
    data['is_pandit_anushthan_time'] = isPanditAnushthanTime;
    data['is_pandit_chadhava_time'] = isPanditChadhavaTime;
    data['is_pandit_offlinepooja_time'] = isPanditOfflinepoojaTime;
    data['is_pandit_live_stream_charge'] = isPanditLiveStreamCharge;
    data['is_pandit_live_stream_commission'] = isPanditLiveStreamCommission;
    data['other_skills'] = otherSkills;
    data['category'] = category;
    data['language'] = language;
    data['is_astrologer_live_stream_charge'] = isAstrologerLiveStreamCharge;
    data['is_astrologer_live_stream_commission'] =
        isAstrologerLiveStreamCommission;
    data['is_astrologer_call_charge'] = isAstrologerCallCharge;
    data['is_astrologer_call_commission'] = isAstrologerCallCommission;
    data['is_astrologer_chat_charge'] = isAstrologerChatCharge;
    data['is_astrologer_chat_commission'] = isAstrologerChatCommission;
    data['is_astrologer_report_charge'] = isAstrologerReportCharge;
    data['is_astrologer_report_commission'] = isAstrologerReportCommission;
    data['consultation_charge'] = consultationCharge;
    data['consultation_commission'] = consultationCommission;
    data['is_kundali_make'] = isKundaliMake;
    data['kundali_make_charge'] = kundaliMakeCharge;
    data['kundali_make_charge_pro'] = kundaliMakeChargePro;
    data['kundali_make_commission'] = kundaliMakeCommission;
    data['kundali_make_commission_pro'] = kundaliMakeCommissionPro;
    data['experience'] = experience;
    data['daily_hours_contribution'] = dailyHoursContribution;
    data['office_address'] = officeAddress;
    data['highest_qualification'] = highestQualification;
    data['other_qualification'] = otherQualification;
    data['secondary_qualification'] = secondaryQualification;
    data['secondary_degree'] = secondaryDegree;
    data['college'] = college;
    data['onboard_you'] = onboardYou;
    data['interview_time'] = interviewTime;
    data['business_source'] = businessSource;
    data['learn_primary_skill'] = learnPrimarySkill;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['linkedin'] = linkedin;
    data['youtube'] = youtube;
    data['website'] = website;
    data['min_earning'] = minEarning;
    data['max_earning'] = maxEarning;
    data['bank_name'] = bankName;
    data['holder_name'] = holderName;
    data['branch_name'] = branchName;
    data['bank_ifsc'] = bankIfsc;
    data['account_no'] = accountNo;
    data['bank_passbook_image'] = bankPassbookImage;
    data['foreign_country'] = foreignCountry;
    data['working'] = working;
    data['bio'] = bio;
    data['qualities'] = qualities;
    data['challenge'] = challenge;
    data['repeat_question'] = repeatQuestion;
    data['status'] = status;
    return data;
  }
}
