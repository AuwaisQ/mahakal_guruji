class DonationOrderModel {
  DonationOrderModel({
    required this.status,
    required this.message,
    required this.recode,
    required this.data,
  });

  final dynamic status;
  final String message;
  final dynamic recode;
  final List<Donation> data;

  factory DonationOrderModel.fromJson(Map<String, dynamic> json) {
    return DonationOrderModel(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      recode: json["recode"] ?? 0,
      data: json["data"] == null
          ? []
          : List<Donation>.from(json["data"]!.map((x) => Donation.fromJson(x))),
    );
  }
}

class Donation {
  Donation({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.amountStatus,
    required this.subscriptionId,
    required this.frequency,
    required this.date,
    required this.enAdsName,
    required this.hiAdsName,
    required this.enTrustName,
    required this.hiTrustName,
    required this.image,
  });

  final dynamic id;
  final dynamic orderId;
  final dynamic type;
  final dynamic amount;
  final dynamic amountStatus;
  final dynamic subscriptionId;
  final dynamic frequency;
  final dynamic date;
  final dynamic enAdsName;
  final dynamic hiAdsName;
  final dynamic enTrustName;
  final dynamic hiTrustName;
  final dynamic image;

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json["id"] ?? 0,
      orderId: json["order_id"] ?? "",
      type: json["type"] ?? "",
      amount: json["amount"] ?? 0,
      amountStatus: json["amount_status"] ?? 0,
      subscriptionId: json["subscription_id"] ?? "",
      frequency: json["frequency"] ?? "",
      date: json["date"] ?? "",
      enAdsName: json["en_ads_name"] ?? "",
      hiAdsName: json["hi_ads_name"] ?? "",
      enTrustName: json["en_trust_name"] ?? "",
      hiTrustName: json["hi_trust_name"] ?? "",
      image: json["image"] ?? "",
    );
  }
}
