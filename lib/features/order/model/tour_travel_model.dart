class TourTravelModel {
  TourTravelModel({
    required this.status,
    required this.count,
    required this.data,
  });

  final dynamic status;
  final dynamic count;
  final List<Tourorderlist> data;

  factory TourTravelModel.fromJson(Map<String, dynamic> json) {
    return TourTravelModel(
      status: json["status"] ?? 0,
      count: json["count"] ?? 0,
      data: json["data"] == null
          ? []
          : List<Tourorderlist>.from(
              json["data"]!.map((x) => Tourorderlist.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "data": data.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$status, $count, $data, ";
  }
}

class Tourorderlist {
  Tourorderlist({
    required this.id,
    required this.orderId,
    required this.qty,
    required this.enTourName,
    required this.hiTourName,
    required this.tourImage,
    required this.amount,
    required this.couponAmount,
    required this.payAmount,
    required this.amountStatus,
    required this.transactionId,
    required this.refundStatus,
    required this.pickupAddress,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupOtp,
    required this.pickupStatus,
    required this.dropOpt,
    required this.dropStatus,
    required this.bookingTime,
    required this.partPayment,
  });

  final dynamic id;
  final dynamic orderId;
  final dynamic qty;
  final String enTourName;
  final String hiTourName;
  final String tourImage;
  final dynamic amount;
  final dynamic couponAmount;
  final dynamic payAmount;
  final dynamic amountStatus;
  final dynamic transactionId;
  final dynamic refundStatus;
  final String pickupAddress;
  final DateTime? pickupDate;
  final dynamic pickupTime;
  final dynamic pickupOtp;
  final dynamic pickupStatus;
  final dynamic dropOpt;
  final dynamic dropStatus;
  final DateTime? bookingTime;
  final String partPayment;

  factory Tourorderlist.fromJson(Map<String, dynamic> json) {
    return Tourorderlist(
      id: json["id"] ?? 0,
      orderId: json["order_id"] ?? "",
      qty: json["qty"] ?? 0,
      enTourName: json["en_tour_name"] ?? "",
      hiTourName: json["hi_tour_name"] ?? "",
      tourImage: json["tour_image"] ?? "",
      amount: json["amount"] ?? 0.0,
      couponAmount: json["coupon_amount"] ?? 0,
      payAmount: json["pay_amount"] ?? 0.0,
      amountStatus: json["amount_status"] ?? 0,
      transactionId: json["transaction_id"] ?? "",
      refundStatus: json["refund_status"] ?? 0,
      pickupAddress: json["pickup_address"] ?? "",
      pickupDate: DateTime.tryParse(json["pickup_date"] ?? ""),
      pickupTime: json["pickup_time"] ?? "",
      pickupOtp: json["pickup_otp"] ?? 0,
      pickupStatus: json["pickup_status"] ?? 0,
      dropOpt: json["drop_opt"] ?? 0,
      dropStatus: json["drop_status"] ?? 0,
      bookingTime: DateTime.tryParse(json["booking_time"] ?? ""),
      partPayment: json["part_payment"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "qty": qty,
        "en_tour_name": enTourName,
        "hi_tour_name": hiTourName,
        "tour_image": tourImage,
        "amount": amount,
        "coupon_amount": couponAmount,
        "pay_amount": payAmount,
        "amount_status": amountStatus,
        "transaction_id": transactionId,
        "refund_status": refundStatus,
        "pickup_address": pickupAddress,
        "pickup_date": pickupDate != null
            ? "${pickupDate?.year.toString().padLeft(4, '0')}-${pickupDate?.month.toString().padLeft(2, '0')}-${pickupDate?.day.toString().padLeft(2, '0')}"
            : null,
        "pickup_time": pickupTime,
        "pickup_otp": pickupOtp,
        "pickup_status": pickupStatus,
        "drop_opt": dropOpt,
        "drop_status": dropStatus,
        "booking_time": bookingTime?.toIso8601String(),
        "part_payment": partPayment,
      };

  @override
  String toString() {
    return "$id, $orderId, $qty, $enTourName, $hiTourName, $tourImage, $amount, $couponAmount, $payAmount, $amountStatus, $transactionId, $refundStatus, $pickupAddress, $pickupDate, $pickupTime, $pickupOtp, $pickupStatus, $dropOpt, $dropStatus, $bookingTime, $partPayment, ";
  }
}

// class TourTravelModel {
//   TourTravelModel({
//     required this.status,
//     required this.count,
//     required this.data,
//   });
//
//   final int status;
//   final int count;
//   final List<Tourorderlist> data;
//
//   factory TourTravelModel.fromJson(Map<String, dynamic> json){
//     return TourTravelModel(
//       status: json["status"] ?? 0,
//       count: json["count"] ?? 0,
//       data: json["data"] == null ? [] : List<Tourorderlist>.from(json["data"]!.map((x) => Tourorderlist.fromJson(x))),
//     );
//   }
//
// }
//
// class Tourorderlist {
//   Tourorderlist({
//     required this.id,
//     required this.orderId,
//     required this.qty,
//     required this.enTourName,
//     required this.hiTourName,
//     required this.tourImage,
//     required this.amount,
//     required this.couponAmount,
//     required this.payAmount,
//     required this.amountStatus,
//     required this.transactionId,
//     required this.refundStatus,
//     required this.pickupAddress,
//     required this.pickupDate,
//     required this.pickupTime,
//     required this.pickupOtp,
//     required this.pickupStatus,
//     required this.dropOpt,
//     required this.dropStatus,
//     required this.bookingTime,
//     required this.partPayment,
//   });
//
//   final int id;
//   final String orderId;
//   final int qty;
//   final String enTourName;
//   final String hiTourName;
//   final String tourImage;
//   final double amount;
//   final double couponAmount;
//   final double payAmount;
//   final int amountStatus;
//   final String transactionId;
//   final int refundStatus;
//   final String pickupAddress;
//   final DateTime? pickupDate;
//   final String pickupTime;
//   final int pickupOtp;
//   final int pickupStatus;
//   final int dropOpt;
//   final int dropStatus;
//   final DateTime? bookingTime;
//   final String partPayment;
//
//   factory Tourorderlist.fromJson(Map<String, dynamic> json){
//     return Tourorderlist(
//       id: json["id"] ?? 0,
//       orderId: json["order_id"] ?? "",
//       qty: json["qty"] ?? 0,
//       enTourName: json["en_tour_name"] ?? "",
//       hiTourName: json["hi_tour_name"] ?? "",
//       tourImage: json["tour_image"] ?? "",
//       amount: json["amount"] ?? 0.0,
//       couponAmount: json["coupon_amount"] ?? 0.0,
//       payAmount: json["pay_amount"] ?? 0.0,
//       amountStatus: json["amount_status"] ?? 0,
//       transactionId: json["transaction_id"] ?? "",
//       refundStatus: json["refund_status"] ?? 0,
//       pickupAddress: json["pickup_address"] ?? "",
//       pickupDate: DateTime.tryParse(json["pickup_date"] ?? ""),
//       pickupTime: json["pickup_time"] ?? "",
//       pickupOtp: json["pickup_otp"] ?? 0,
//       pickupStatus: json["pickup_status"] ?? 0,
//       dropOpt: json["drop_opt"] ?? 0,
//       dropStatus: json["drop_status"] ?? 0,
//       bookingTime: DateTime.tryParse(json["booking_time"] ?? ""),
//       partPayment: json["part_payment"] ?? "",
//     );
//   }
//
// }
