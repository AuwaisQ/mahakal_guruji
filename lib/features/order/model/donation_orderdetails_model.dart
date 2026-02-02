class DonationOrderDetails {
  DonationOrderDetails({
    required this.status,
    required this.message,
    required this.recode,
    required this.data,
  });

  final int status;
  final String message;
  final int recode;
  final Data? data;

  factory DonationOrderDetails.fromJson(Map<String, dynamic> json){
    return DonationOrderDetails(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      recode: json["recode"] ?? 0,
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "recode": recode,
    "data": data?.toJson(),
  };

}

class Data {
  Data({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    required this.amountStatus,
    required this.subscriptionId,
    required this.subscriptionStatus,
    required this.frequency,
    required this.date,
    required this.enAdsName,
    required this.hiAdsName,
    required this.enTrustName,
    required this.information,
    required this.hiTrustName,
    required this.invoiceUrl,
    required this.ertigaCertificate,
    required this.image,
  });

  final int id;
  final String orderId;
  final String type;
  final int amount;
  final int amountStatus;
  final String subscriptionId;
  final String subscriptionStatus;
  final String frequency;
  final String date;
  final String enAdsName;
  final String hiAdsName;
  final String enTrustName;
  final List<Information> information;
  final String hiTrustName;
  final String invoiceUrl;
  final String ertigaCertificate;
  final String image;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"] ?? 0,
      orderId: json["order_id"] ?? "",
      type: json["type"] ?? "",
      amount: json["amount"] ?? 0,
      amountStatus: json["amount_status"] ?? 0,
      subscriptionId: json["subscription_id"] ?? "",
      subscriptionStatus: json["subscription_status"] ?? "",
      frequency: json["frequency"] ?? "",
      date: json["date"] ?? "",
      enAdsName: json["en_ads_name"] ?? "",
      hiAdsName: json["hi_ads_name"] ?? "",
      enTrustName: json["en_trust_name"] ?? "",
      information: json["information"] == null ? [] : List<Information>.from(json["information"]!.map((x) => Information.fromJson(x))),
      hiTrustName: json["hi_trust_name"] ?? "",
      invoiceUrl: json["invoice_url"] ?? "",
      ertigaCertificate: json["ertiga_certificate"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "type": type,
    "amount": amount,
    "amount_status": amountStatus,
    "subscription_id": subscriptionId,
    "subscription_status": subscriptionStatus,
    "frequency": frequency,
    "date": date,
    "en_ads_name": enAdsName,
    "hi_ads_name": hiAdsName,
    "en_trust_name": enTrustName,
    "information": information.map((x) => x?.toJson()).toList(),
    "hi_trust_name": hiTrustName,
    "invoice_url": invoiceUrl,
    "ertiga_certificate": ertigaCertificate,
    "image": image,
  };

}

class Information {
  Information({
    required this.id,
    required this.name,
    required this.title,
    required this.amount,
    required this.image,
    required this.qty,
    required this.fullamount,
  });

  final String id;
  final String name;
  final String title;
  final String amount;
  final String image;
  final int qty;
  final int fullamount;

  factory Information.fromJson(Map<String, dynamic> json){
    return Information(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      title: json["title"] ?? "",
      amount: json["amount"] ?? "",
      image: json["image"] ?? "",
      qty: json["qty"] ?? 0,
      fullamount: json["fullamount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "title": title,
    "amount": amount,
    "image": image,
    "qty": qty,
    "fullamount": fullamount,
  };

}
