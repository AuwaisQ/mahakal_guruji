class PanditSuccessModel {
  PanditSuccessModel({
    required this.status,
    required this.message,
    required this.orderId,
  });

  final bool? status;
  final String? message;
  final String? orderId;

  factory PanditSuccessModel.fromJson(Map<String, dynamic> json){
    return PanditSuccessModel(
      status: json["status"],
      message: json["message"],
      orderId: json["order_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "order_id": orderId,
  };

}
