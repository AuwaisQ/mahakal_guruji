class AllPanditCounsLead {
  AllPanditCounsLead({
    required this.status,
    required this.message,
    required this.orderId,
  });

  final bool status;
  final String message;
  final String orderId;

  factory AllPanditCounsLead.fromJson(Map<String, dynamic> json){
    return AllPanditCounsLead(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      orderId: json["order_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "order_id": orderId,
  };

}
