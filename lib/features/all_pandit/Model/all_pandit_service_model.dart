import 'dart:convert';

class AllPanditServicesModel {
  AllPanditServicesModel({
    required this.status,
    required this.message,
    required this.guruji,
    required this.service,
    required this.seller,
    required this.product,
    required this.event,
    required this.counselling,
  });

  final bool status;
  final String message;
  final Guruji? guruji;
  final List<Service> service;
  final Seller? seller;
  final List<Product> product;
  final List<Event> event;
  final List<Counselling> counselling;


  factory AllPanditServicesModel.fromJson(Map<String, dynamic> json){
    return AllPanditServicesModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      guruji: json["guruji"] == null ? null : Guruji.fromJson(json["guruji"]),
      service: json["service"] == null ? [] : List<Service>.from(json["service"]!.map((x) => Service.fromJson(x))),
      seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      product: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((x) => Product.fromJson(x))),
      event: json["event"] == null ? [] : List<Event>.from(json["event"]!.map((x) => Event.fromJson(x))),
      counselling: json["counselling"] == null ? [] : List<Counselling>.from(json["counselling"]!.map((x) => Counselling.fromJson(x))),

    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "guruji": guruji?.toJson(),
    "service": service.map((x) => x.toJson()).toList(),
    "seller": seller?.toJson(),
    "product": product.map((x) => x).toList(),
    "event": event.map((x) => x.toJson()).toList(),
    "counselling": counselling.map((x) => x?.toJson()).toList(),
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
    required this.gender,
    required this.dob,
    required this.pancard,
    required this.pancardImage,
    required this.adharcard,
    required this.adharcardMobile,
    required this.adharcardFrontImage,
    required this.adharcardBackImage,
    required this.state,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pincode,
    required this.isPanditPoojaCategory,
    required this.primarySkills,
    required this.isPanditPooja,
    required this.vendorId,
    required this.eventId,
    required this.ordercount,
  });

  final int id;
  final String name;
  final String email;
  final String mobileNo;
  final String image;
  final String banner;
  final String gender;
  final DateTime? dob;
  final String pancard;
  final String pancardImage;
  final String adharcard;
  final dynamic adharcardMobile;
  final String adharcardFrontImage;
  final String adharcardBackImage;
  final String state;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final int pincode;
  final List<Category> isPanditPoojaCategory;
  final String primarySkills;
  final String isPanditPooja;
  final String vendorId;
  final String eventId;
  final int ordercount;

  factory Guruji.fromJson(Map<String, dynamic> json){
    return Guruji(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      mobileNo: json["mobile_no"] ?? "",
      image: json["image"] ?? "",
      banner: json["banner"] ?? "",
      gender: json["gender"] ?? "",
      dob: DateTime.tryParse(json["dob"] ?? ""),
      pancard: json["pancard"] ?? "",
      pancardImage: json["pancard_image"] ?? "",
      adharcard: json["adharcard"] ?? "",
      adharcardMobile: json["adharcard_mobile"],
      adharcardFrontImage: json["adharcard_front_image"] ?? "",
      adharcardBackImage: json["adharcard_back_image"] ?? "",
      state: json["state"] ?? "",
      city: json["city"] ?? "",
      address: json["address"] ?? "",
      latitude: json["latitude"] ?? 0.0,
      longitude: json["longitude"] ?? 0.0,
      pincode: json["pincode"] ?? 0,
      isPanditPoojaCategory: json["is_pandit_pooja_category"] == null ? [] : List<Category>.from(json["is_pandit_pooja_category"]!.map((x) => Category.fromJson(x))),
      primarySkills: json["primary_skills"] ?? "",
      isPanditPooja: json["is_pandit_pooja"] ?? "",
      vendorId: json["vendor_id"] ?? "",
      eventId: json["event_id"] ?? "",
      ordercount: json["ordercount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "image": image,
    "banner": banner,
    "gender": gender,
    "dob": "${dob?.year.toString().padLeft(4,'0')}-${dob?.month.toString().padLeft(2,'0')}-${dob?.day.toString().padLeft(2,'0')}",
    "pancard": pancard,
    "pancard_image": pancardImage,
    "adharcard": adharcard,
    "adharcard_mobile": adharcardMobile,
    "adharcard_front_image": adharcardFrontImage,
    "adharcard_back_image": adharcardBackImage,
    "state": state,
    "city": city,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "pincode": pincode,
    "is_pandit_pooja_category": isPanditPoojaCategory.map((x) => x?.toJson()).toList(),
    "primary_skills": primarySkills,
    "is_pandit_pooja": isPanditPooja,
    "vendor_id": vendorId,
    "event_id": eventId,
    "ordercount": ordercount,
  };

}

class Category {
  Category({
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

  final int id;
  final String name;
  final String slug;
  final String icon;
  final int parentId;
  final int position;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int homeStatus;
  final int priority;
  final List<dynamic> translations;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      icon: json["icon"] ?? "",
      parentId: json["parent_id"] ?? 0,
      position: json["position"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      homeStatus: json["home_status"] ?? 0,
      priority: json["priority"] ?? 0,
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

class Service {
  Service({
    required this.id,
    required this.name,
    required this.slug,
    required this.shortBenifits,
    required this.poojaHeading,
    required this.categoryId,
    required this.subCategoryId,
    required this.thumbnail,
    required this.poojaVenue,
    required this.finalVenue,
    required this.category,
    required this.translations,
  });

  final int id;
  final String name;
  final String slug;
  final String shortBenifits;
  final String poojaHeading;
  final int categoryId;
  final int subCategoryId;
  final String thumbnail;
  final String poojaVenue;
  final String finalVenue;
  final Category? category;
  final List<dynamic> translations;

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      shortBenifits: json["short_benifits"] ?? "",
      poojaHeading: json["pooja_heading"] ?? "",
      categoryId: json["category_id"] ?? 0,
      subCategoryId: json["sub_category_id"] ?? 0,
      thumbnail: json["thumbnail"] ?? "",
      poojaVenue: json["pooja_venue"] ?? "",
      finalVenue: json["final_venue"] ?? "",
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "short_benifits": shortBenifits,
    "pooja_heading": poojaHeading,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "thumbnail": thumbnail,
    "pooja_venue": poojaVenue,
    "final_venue": finalVenue,
    "category": category?.toJson(),
    "translations": translations.map((x) => x).toList(),
  };

}

class Event {
  Event({
    required this.id,
    required this.uniqueId,
    required this.eventName,
    required this.slug,
    required this.categoryId,
    required this.organizerBy,
    required this.informationalStatus,
    required this.requiredAadharStatus,
    required this.eventOrganizerId,
    required this.eventAbout,
    required this.eventSchedule,
    required this.eventAttend,
    required this.eventTeamCondition,
    required this.ageGroup,
    required this.eventArtist,
    required this.language,
    required this.days,
    required this.startToEndDate,
    //required this.packageList,
    required this.eventImage,
    required this.images,
    required this.youtubeVideo,
    required this.isApprove,
    required this.eventApproveAmount,
    required this.approveAmountStatus,
    required this.commissionLive,
    required this.commissionSeats,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.bookingSeats,
    required this.eventInterested,
    required this.status,
    required this.profitInformation,
   // required this.review,
    required this.translations,
  });

  final int id;
  final String uniqueId;
  final String eventName;
  final String slug;
  final int categoryId;
  final String organizerBy;
  final int informationalStatus;
  final int requiredAadharStatus;
  final int eventOrganizerId;
  final String eventAbout;
  final String eventSchedule;
  final String eventAttend;
  final String eventTeamCondition;
  final String ageGroup;
  final String eventArtist;
  final String language;
  final int days;
  final String startToEndDate;
 // final List<PackageItem> packageList;
  final String eventImage;
  final List<String> images;
  final String youtubeVideo;
  final int isApprove;
  final int eventApproveAmount;
  final int approveAmountStatus;
  final int commissionLive;
  final int commissionSeats;
  final String metaTitle;
  final String metaDescription;
  final String metaImage;
  final String bookingSeats;
  final int eventInterested;
  final int status;
  final String profitInformation;
  //final List<Review> review;
  final List<dynamic> translations;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] ?? 0,
      uniqueId: json["unique_id"] ?? "",
      eventName: json["event_name"] ?? "",
      slug: json["slug"] ?? "",
      categoryId: json["category_id"] ?? 0,
      organizerBy: json["organizer_by"] ?? "",
      informationalStatus: json["informational_status"] ?? 0,
      requiredAadharStatus: json["required_aadhar_status"] ?? 0,
      eventOrganizerId: json["event_organizer_id"] ?? 0,
      eventAbout: json["event_about"] ?? "",
      eventSchedule: json["event_schedule"] ?? "",
      eventAttend: json["event_attend"] ?? "",
      eventTeamCondition: json["event_team_condition"] ?? "",
      ageGroup: json["age_group"] ?? "",
      eventArtist: json["event_artist"] ?? "",
      language: json["language"] ?? "",
      days: json["days"] ?? 0,
      startToEndDate: json["start_to_end_date"] ?? "",
      // packageList: json["package_list"] == null
      //     ? []
      //     : List<PackageItem>.from(
      //   json["package_list"].map((x) => PackageItem.fromJson(x)),
      // ),
      eventImage: json["event_image"] ?? "",
      images: json["images"] != null
          ? List<String>.from((jsonDecode(json["images"]) as List<dynamic>).map((x) => x.toString()))
          : [],
      youtubeVideo: json["youtube_video"] ?? "",
      isApprove: json["is_approve"] ?? 0,
      eventApproveAmount: json["event_approve_amount"] ?? 0,
      approveAmountStatus: json["approve_amount_status"] ?? 0,
      commissionLive: json["commission_live"] ?? 0,
      commissionSeats: json["commission_seats"] ?? 0,
      metaTitle: json["meta_title"] ?? "",
      metaDescription: json["meta_description"] ?? "",
      metaImage: json["meta_image"] ?? "",
      bookingSeats: json["booking_seats"]?.toString() ?? "",
      eventInterested: json["event_interested"] ?? 0,
      status: json["status"] ?? 0,
      profitInformation: json["profit_information"] ?? "",
      // review: json["review"] == null
      //     ? []
      //     : List<Review>.from(
      //   json["review"].map((x) => Review.fromJson(x)),
      // ),
      translations: json["translations"] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "event_name": eventName,
    "slug": slug,
    "category_id": categoryId,
    "organizer_by": organizerBy,
    "informational_status": informationalStatus,
    "required_aadhar_status": requiredAadharStatus,
    "event_organizer_id": eventOrganizerId,
    "event_about": eventAbout,
    "event_schedule": eventSchedule,
    "event_attend": eventAttend,
    "event_team_condition": eventTeamCondition,
    "age_group": ageGroup,
    "event_artist": eventArtist,
    "language": language,
    "days": days,
    "start_to_end_date": startToEndDate,
   // "package_list": packageList.map((x) => x.toJson()).toList(),
    "event_image": eventImage,
    "images": jsonEncode(images),
    "youtube_video": youtubeVideo,
    "is_approve": isApprove,
    "event_approve_amount": eventApproveAmount,
    "approve_amount_status": approveAmountStatus,
    "commission_live": commissionLive,
    "commission_seats": commissionSeats,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "meta_image": metaImage,
    "booking_seats": bookingSeats,
    "event_interested": eventInterested,
    "status": status,
    "profit_information": profitInformation,
   // "review": review.map((x) => x.toJson()).toList(),
    "translations": translations,
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
    //required this.categoryIds,
    required this.categoryId,
    required this.subCategoryId,
    required this.subSubCategoryId,
    required this.brandId,
    required this.unit,
    required this.minQty,
    required this.refundable,
    required this.images,
    required this.colorImage,
    required this.thumbnail,
    required this.videoProvider,
    required this.videoUrl,
    required this.colors,
    required this.variantProduct,
    required this.attributes,
    //required this.choiceOptions,
    //required this.variation,
    required this.unitPrice,
    required this.currentStock,
    required this.minimumOrderQty,
    required this.freeShipping,
    required this.status,
    required this.featuredStatus,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.shippingCost,
    required this.multiplyQty,
    required this.code,
    required this.productRefund,
    required this.translations,
    required this.reviews,
  });

  final int id;
  final String addedBy;
  final int userId;
  final String name;
  final String slug;
  final String productType;

  /// category_ids = "[{\"id\":\"233\",\"position\":1}]"
 // final List<CategoryIdItem> categoryIds;

  final int categoryId;
  final int? subCategoryId;
  final int? subSubCategoryId;
  final int brandId;
  final String unit;
  final int minQty;
  final int refundable;

  /// images = "[\"img1.webp\",\"img2.webp\"]"
  final List<String> images;

  /// color_image = "[]"
  final List<String> colorImage;

  final String thumbnail;
  final String videoProvider;
  final String? videoUrl;

  /// colors = "[]"
  final List<String> colors;

  final int variantProduct;

  /// attributes = "[\"1\"]"
  final List<String> attributes;

  /// choice_options = "[{\"name\":\"choice_1\",\"options\":[\"1 Carat\"]}]"
  //final List<ChoiceOption> choiceOptions;

  /// variation = "[{\"type\":\"1Carat\",\"price\":3500,...}]"
  //final List<Variation> variation;

  final int unitPrice;
  final int currentStock;
  final int minimumOrderQty;
  final int freeShipping;
  final int status;
  final int featuredStatus;
  final String metaTitle;
  final String metaDescription;
  final String metaImage;
  final int shippingCost;
  final int multiplyQty;
  final String code;
  final int productRefund;

  final List<dynamic> translations;
  final List<dynamic> reviews;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] ?? 0,
      addedBy: json["added_by"] ?? "",
      userId: json["user_id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      productType: json["product_type"] ?? "",
      //
      // categoryIds: json["category_ids"] != null
      //     ? List<CategoryIdItem>.from(
      //   (jsonDecode(json["category_ids"]) as List)
      //       .map((e) => CategoryIdItem.fromJson(e)),
      // )
      //     : [],

      categoryId: json["category_id"] ?? 0,
      subCategoryId: json["sub_category_id"],
      subSubCategoryId: json["sub_sub_category_id"],
      brandId: json["brand_id"] ?? 0,
      unit: json["unit"] ?? "",
      minQty: json["min_qty"] ?? 1,
      refundable: json["refundable"] ?? 0,

      images: json["images"] != null
          ? List<String>.from(jsonDecode(json["images"]))
          : [],

      colorImage: json["color_image"] != null
          ? List<String>.from(jsonDecode(json["color_image"]))
          : [],

      thumbnail: json["thumbnail"] ?? "",
      videoProvider: json["video_provider"] ?? "",
      videoUrl: json["video_url"],

      colors: json["colors"] != null
          ? List<String>.from(jsonDecode(json["colors"]))
          : [],

      variantProduct: json["variant_product"] ?? 0,

      attributes: json["attributes"] != null && json["attributes"] != "null"
          ? List<String>.from(jsonDecode(json["attributes"]))
          : [],

      // choiceOptions: json["choice_options"] != null
      //     ? List<ChoiceOption>.from(
      //   (jsonDecode(json["choice_options"]) as List)
      //       .map((e) => ChoiceOption.fromJson(e)),
      // )
      //     : [],

      // variation: json["variation"] != null
      //     ? List<Variation>.from(
      //   (jsonDecode(json["variation"]) as List)
      //       .map((e) => Variation.fromJson(e)),
      // )
      //     : [],

      unitPrice: json["unit_price"] ?? 0,
      currentStock: json["current_stock"] ?? 0,
      minimumOrderQty: json["minimum_order_qty"] ?? 1,
      freeShipping: json["free_shipping"] ?? 0,
      status: json["status"] ?? 0,
      featuredStatus: json["featured_status"] ?? 0,
      metaTitle: json["meta_title"] ?? "",
      metaDescription: json["meta_description"] ?? "",
      metaImage: json["meta_image"] ?? "",
      shippingCost: json["shipping_cost"] ?? 0,
      multiplyQty: json["multiply_qty"] ?? 0,
      code: json["code"] ?? "",
      productRefund: json["product_refund"] ?? 0,
      translations: json["translations"] ?? [],
      reviews: json["reviews"] ?? [],
    );
  }
}

class Counselling {
  Counselling({
    required this.id,
    required this.name,
    required this.slug,
    required this.counsellingMainPrice,
    required this.counsellingSellingPrice,
    required this.categoryId,
    required this.subCategoryId,
    required this.thumbnail,
    required this.counsellingPackage,
    required this.category,
    required this.translations,
  });

  final int id;
  final String name;
  final String slug;
  final int counsellingMainPrice;
  final int counsellingSellingPrice;
  final int categoryId;
  final int subCategoryId;
  final String thumbnail;
  final CounsellingPackage? counsellingPackage;
  final Category? category;
  final List<dynamic> translations;

  factory Counselling.fromJson(Map<String, dynamic> json){
    return Counselling(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      counsellingMainPrice: json["counselling_main_price"] ?? 0,
      counsellingSellingPrice: json["counselling_selling_price"] ?? 0,
      categoryId: json["category_id"] ?? 0,
      subCategoryId: json["sub_category_id"] ?? 0,
      thumbnail: json["thumbnail"] ?? "",
      counsellingPackage: json["counselling_package"] == null ? null : CounsellingPackage.fromJson(json["counselling_package"]),
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
      translations: json["translations"] == null ? [] : List<dynamic>.from(json["translations"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "counselling_main_price": counsellingMainPrice,
    "counselling_selling_price": counsellingSellingPrice,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "thumbnail": thumbnail,
    "category": category?.toJson(),
    "translations": translations.map((x) => x).toList(),
  };

}

class Seller {
  Seller({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.image,
    required this.email,
    required this.productCount,
    required this.shop,
  });

  final int id;
  final String fName;
  final String lName;
  final String phone;
  final String image;
  final String email;
  final int productCount;
  final Shop? shop;

  factory Seller.fromJson(Map<String, dynamic> json){
    return Seller(
      id: json["id"] ?? 0,
      fName: json["f_name"] ?? "",
      lName: json["l_name"] ?? "",
      phone: json["phone"] ?? "",
      image: json["image"] ?? "",
      email: json["email"] ?? "",
      productCount: json["product_count"] ?? 0,
      shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "f_name": fName,
    "l_name": lName,
    "phone": phone,
    "image": image,
    "email": email,
    "product_count": productCount,
    "shop": shop?.toJson(),
  };

}

class Shop {
  Shop({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.slug,
    required this.buildingNo,
    required this.address,
    required this.cityName,
    required this.stateName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
    required this.pincode,
    required this.gumasta,
    required this.fassaiNo,
    required this.fassaiImage,
    required this.contact,
    required this.image,
    required this.bottomBanner,
    required this.offerBanner,
    required this.vacationStartDate,
    required this.vacationEndDate,
    required this.vacationNote,
    required this.vacationStatus,
    required this.temporaryClose,
    required this.createdAt,
    required this.updatedAt,
    required this.banner,
  });

  final int id;
  final int sellerId;
  final String name;
  final String slug;
  final dynamic buildingNo;
  final String address;
  final dynamic cityName;
  final dynamic stateName;
  final dynamic countryName;
  final dynamic latitude;
  final dynamic longitude;
  final int pincode;
  final dynamic gumasta;
  final dynamic fassaiNo;
  final dynamic fassaiImage;
  final String contact;
  final String image;
  final String bottomBanner;
  final dynamic offerBanner;
  final dynamic vacationStartDate;
  final dynamic vacationEndDate;
  final dynamic vacationNote;
  final bool vacationStatus;
  final bool temporaryClose;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String banner;

  factory Shop.fromJson(Map<String, dynamic> json){
    return Shop(
      id: json["id"] ?? 0,
      sellerId: json["seller_id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      buildingNo: json["building_no"],
      address: json["address"] ?? "",
      cityName: json["city_name"],
      stateName: json["state_name"],
      countryName: json["country_name"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      pincode: json["pincode"] ?? 0,
      gumasta: json["gumasta"],
      fassaiNo: json["fassai_no"],
      fassaiImage: json["fassai_image"],
      contact: json["contact"] ?? "",
      image: json["image"] ?? "",
      bottomBanner: json["bottom_banner"] ?? "",
      offerBanner: json["offer_banner"],
      vacationStartDate: json["vacation_start_date"],
      vacationEndDate: json["vacation_end_date"],
      vacationNote: json["vacation_note"],
      vacationStatus: json["vacation_status"] ?? false,
      temporaryClose: json["temporary_close"] ?? false,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      banner: json["banner"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "seller_id": sellerId,
    "name": name,
    "slug": slug,
    "building_no": buildingNo,
    "address": address,
    "city_name": cityName,
    "state_name": stateName,
    "country_name": countryName,
    "latitude": latitude,
    "longitude": longitude,
    "pincode": pincode,
    "gumasta": gumasta,
    "fassai_no": fassaiNo,
    "fassai_image": fassaiImage,
    "contact": contact,
    "image": image,
    "bottom_banner": bottomBanner,
    "offer_banner": offerBanner,
    "vacation_start_date": vacationStartDate,
    "vacation_end_date": vacationEndDate,
    "vacation_note": vacationNote,
    "vacation_status": vacationStatus,
    "temporary_close": temporaryClose,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "banner": banner,
  };

}

class CounsellingPackage {
  CounsellingPackage({
    required this.id,
    required this.panditId,
    required this.type,
    required this.serviceId,
    required this.packageId,
    required this.price,
    required this.thumbnail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int panditId;
  final String type;
  final int serviceId;
  final dynamic packageId;
  final int price;
  final String thumbnail;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CounsellingPackage.fromJson(Map<String, dynamic> json){
    return CounsellingPackage(
      id: json["id"] ?? 0,
      panditId: json["pandit_id"] ?? 0,
      type: json["type"] ?? "",
      serviceId: json["service_id"] ?? 0,
      packageId: json["package_id"],
      price: json["price"] ?? 0,
      thumbnail: json["thumbnail"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "pandit_id": panditId,
    "type": type,
    "service_id": serviceId,
    "package_id": packageId,
    "price": price,
    "thumbnail": thumbnail,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}

