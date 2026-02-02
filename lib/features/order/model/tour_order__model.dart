// class TourOrderDetails {
//   TourOrderDetails({
//     required this.status,
//     required this.count,
//     required this.data,
//   });
//
//   final int status;
//   final int count;
//   final TourOrderData? data;
//
//   factory TourOrderDetails.fromJson(Map<String, dynamic> json){
//     return TourOrderDetails(
//       status: json["status"] ?? 0,
//       count: json["count"] ?? 0,
//       data: json["data"] == null ? null : TourOrderData.fromJson(json["data"]),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "count": count,
//     "data": data?.toJson(),
//   };
//
//   @override
//   String toString(){
//     return "$status, $count, $data, ";
//   }
// }
//
// class TourOrderData {
//   TourOrderData({
//     required this.id,
//     required this.orderId,
//     required this.qty,
//     required this.enTourName,
//     required this.tourId,
//     required this.reviewStatus,
//     required this.hiTourName,
//     required this.tourImage,
//     required this.amount,
//     required this.couponAmount,
//     required this.totalAmount,
//     required this.remainingAmount,
//     required this.paidAmount,
//     required this.refundStatus,
//     required this.refundAmount,
//     required this.payAmount,
//     required this.totalTaxPrice,
//     required this.bookingPackages,
//     required this.partPayment,
//     required this.amountStatus,
//     required this.transactionId,
//     required this.pickupAddress,
//     required this.pickupDate,
//     required this.pickupTime,
//     required this.pickupOtp,
//     required this.pickupStatus,
//     required this.dropOpt,
//     required this.dropStatus,
//     required this.bookingTime,
//     required this.cancelRefundAmountGiven,
//     required this.invoiceUrl,
//     required this.itineraryPlace,
//   });
//
//   final int id;
//   final String orderId;
//   final dynamic qty;
//   final String enTourName;
//   final int tourId;
//   final int reviewStatus;
//   final String hiTourName;
//   final String tourImage;
//   final dynamic amount;
//   final dynamic couponAmount;
//   final dynamic totalAmount;
//   final dynamic remainingAmount;
//   final dynamic paidAmount;
//   final int refundStatus;
//   final dynamic refundAmount;
//   final dynamic payAmount;
//   final dynamic totalTaxPrice;
//   final List<BookingPackage> bookingPackages;
//   final String partPayment;
//   final int amountStatus;
//   final String transactionId;
//   final String pickupAddress;
//   final String pickupDate;
//   final String pickupTime;
//   final int pickupOtp;
//   final int pickupStatus;
//   final int dropOpt;
//   final int dropStatus;
//   final String bookingTime;
//   final dynamic cancelRefundAmountGiven;
//   final String invoiceUrl;
//   final List<dynamic> itineraryPlace;
//
//   factory TourOrderData.fromJson(Map<String, dynamic> json){
//     return TourOrderData(
//       id: json["id"] ?? 0,
//       orderId: json["order_id"] ?? "",
//       qty: json["qty"] ?? 0,
//       enTourName: json["en_tour_name"] ?? "",
//       tourId: json["tour_id"] ?? 0,
//       reviewStatus: json["review_status"] ?? 0,
//       hiTourName: json["hi_tour_name"] ?? "",
//       tourImage: json["tour_image"] ?? "",
//       amount: json["amount"] ?? 0,
//       couponAmount: json["coupon_amount"] ?? 0,
//       totalAmount: json["total_amount"] ?? 0,
//       remainingAmount: json["remaining_amount"] ?? 0,
//       paidAmount: json["paid_amount"] ?? 0,
//       refundStatus: json["refund_status"] ?? 0,
//       refundAmount: json["refund_amount"] ?? 0,
//       payAmount: json["pay_amount"] ?? 0,
//       totalTaxPrice: json["total_tax_price"] ?? 0,
//       bookingPackages: json["booking_packages"] == null ? [] : List<BookingPackage>.from(json["booking_packages"]!.map((x) => BookingPackage.fromJson(x))),
//       partPayment: json["part_payment"] ?? "",
//       amountStatus: json["amount_status"] ?? 0,
//       transactionId: json["transaction_id"] ?? "",
//       pickupAddress: json["pickup_address"] ?? "",
//       pickupDate: json["pickup_date"] ?? "",
//       pickupTime: json["pickup_time"] ?? "",
//       pickupOtp: json["pickup_otp"] ?? 0,
//       pickupStatus: json["pickup_status"] ?? 0,
//       dropOpt: json["drop_opt"] ?? 0,
//       dropStatus: json["drop_status"] ?? 0,
//       bookingTime: json["booking_time"] ?? "",
//       cancelRefundAmountGiven: json["cancel_refund_amount_given"] ?? 0,
//       invoiceUrl: json["invoice_url"] ?? "",
//       itineraryPlace: json["itinerary_place"] == null ? [] : List<dynamic>.from(json["itinerary_place"]!.map((x) => x)),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "order_id": orderId,
//     "qty": qty,
//     "en_tour_name": enTourName,
//     "tour_id": tourId,
//     "review_status": reviewStatus,
//     "hi_tour_name": hiTourName,
//     "tour_image": tourImage,
//     "amount": amount,
//     "coupon_amount": couponAmount,
//     "total_amount": totalAmount,
//     "remaining_amount": remainingAmount,
//     "paid_amount": paidAmount,
//     "refund_status": refundStatus,
//     "refund_amount": refundAmount,
//     "pay_amount": payAmount,
//     "total_tax_price": totalTaxPrice,
//     "booking_packages": bookingPackages.map((x) => x?.toJson()).toList(),
//     "part_payment": partPayment,
//     "amount_status": amountStatus,
//     "transaction_id": transactionId,
//     "pickup_address": pickupAddress,
//     "pickup_date": pickupDate,
//     "pickup_time": pickupTime,
//     "pickup_otp": pickupOtp,
//     "pickup_status": pickupStatus,
//     "drop_opt": dropOpt,
//     "drop_status": dropStatus,
//     "booking_time": bookingTime,
//     "cancel_refund_amount_given": cancelRefundAmountGiven,
//     "invoice_url": invoiceUrl,
//     "itinerary_place": itineraryPlace.map((x) => x).toList(),
//   };
//
//   @override
//   String toString(){
//     return "$id, $orderId, $qty, $enTourName, $tourId, $reviewStatus, $hiTourName, $tourImage, $amount, $couponAmount, $totalAmount, $remainingAmount, $paidAmount, $refundStatus, $refundAmount, $payAmount, $totalTaxPrice, $bookingPackages, $partPayment, $amountStatus, $transactionId, $pickupAddress, $pickupDate, $pickupTime, $pickupOtp, $pickupStatus, $dropOpt, $dropStatus, $bookingTime, $cancelRefundAmountGiven, $invoiceUrl, $itineraryPlace, ";
//   }
// }
//
// class BookingPackage {
//   BookingPackage({
//     required this.enName,
//     required this.hiName,
//     required this.image,
//     required this.price,
//     required this.qty,
//   });
//
//   final String enName;
//   final String hiName;
//   final String image;
//   final dynamic price;
//   final dynamic qty;
//
//   factory BookingPackage.fromJson(Map<String, dynamic> json){
//     return BookingPackage(
//       enName: json["en_name"] ?? "",
//       hiName: json["hi_name"] ?? "",
//       image: json["image"] ?? "",
//       price: json["price"],
//       qty: json["qty"],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "en_name": enName,
//     "hi_name": hiName,
//     "image": image,
//     "price": price,
//     "qty": qty,
//   };
//
//   @override
//   String toString(){
//     return "$enName, $hiName, $image, $price, $qty, ";
//   }
// }

class TourOrderDetails {
  TourOrderDetails({
    required this.status,
    required this.count,
    required this.data,
  });

  final int status;
  final int count;
  final TourOrderData? data;

  factory TourOrderDetails.fromJson(Map<String, dynamic> json) {
    return TourOrderDetails(
      status: json["status"] ?? 0,
      count: json["count"] ?? 0,
      data: json["data"] == null ? null : TourOrderData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "data": data?.toJson(),
      };

  @override
  String toString() {
    return "$status, $count, $data, ";
  }
}

class TourOrderData {
  TourOrderData({
    required this.id,
    required this.orderId,
    required this.qty,
    required this.enTourName,
    required this.tourId,
    required this.reviewStatus,
    required this.hiTourName,
    required this.tourImage,
    required this.amount,
    required this.couponAmount,
    required this.totalAmount,
    required this.remainingAmount,
    required this.paidAmount,
    required this.refundStatus,
    required this.refundAmount,
    required this.payAmount,
    required this.totalTaxPrice,
    required this.bookingPackages,
    required this.partPayment,
    required this.amountStatus,
    required this.transactionId,
    required this.pickupAddress,
    required this.pickupDate,
    required this.pickupTime,
    required this.pickupOtp,
    required this.pickupStatus,
    required this.dropOpt,
    required this.dropStatus,
    required this.bookingTime,
    required this.cancelRefundAmountGiven,
    required this.invoiceUrl,
    required this.itineraryPlace,
  });

  final int id;
  final dynamic orderId;
  final dynamic qty;
  final String enTourName;
  final dynamic tourId;
  final dynamic reviewStatus;
  final String hiTourName;
  final String tourImage;
  final dynamic amount;
  final dynamic couponAmount;
  final dynamic totalAmount;
  final dynamic remainingAmount;
  final dynamic paidAmount;
  final dynamic refundStatus;
  final dynamic refundAmount;
  final dynamic payAmount;
  final dynamic totalTaxPrice;
  final List<BookingPackage> bookingPackages;
  final String partPayment;
  final dynamic amountStatus;
  final String transactionId;
  final String pickupAddress;
  final String pickupDate;
  final String pickupTime;
  final dynamic pickupOtp;
  final dynamic pickupStatus;
  final dynamic dropOpt;
  final dynamic dropStatus;
  final String bookingTime;
  final dynamic cancelRefundAmountGiven;
  final String invoiceUrl;
  final List<ItineraryPlace> itineraryPlace;

  factory TourOrderData.fromJson(Map<String, dynamic> json) {
    return TourOrderData(
      id: json["id"] ?? 0,
      orderId: json["order_id"] ?? "",
      qty: json["qty"] ?? 0,
      enTourName: json["en_tour_name"] ?? "",
      tourId: json["tour_id"] ?? 0,
      reviewStatus: json["review_status"] ?? 0,
      hiTourName: json["hi_tour_name"] ?? "",
      tourImage: json["tour_image"] ?? "",
      amount: json["amount"] ?? 0,
      couponAmount: json["coupon_amount"] ?? 0,
      totalAmount: json["total_amount"] ?? 0,
      remainingAmount: json["remaining_amount"] ?? 0,
      paidAmount: json["paid_amount"] ?? 0,
      refundStatus: json["refund_status"] ?? 0,
      refundAmount: json["refund_amount"] ?? 0,
      payAmount: json["pay_amount"] ?? 0,
      totalTaxPrice: json["total_tax_price"] ?? 0,
      bookingPackages: json["booking_packages"] == null
          ? []
          : List<BookingPackage>.from(
              json["booking_packages"]!.map((x) => BookingPackage.fromJson(x))),
      partPayment: json["part_payment"] ?? "",
      amountStatus: json["amount_status"] ?? 0,
      transactionId: json["transaction_id"] ?? "",
      pickupAddress: json["pickup_address"] ?? "",
      pickupDate: json["pickup_date"] ?? "",
      pickupTime: json["pickup_time"] ?? "",
      pickupOtp: json["pickup_otp"] ?? 0,
      pickupStatus: json["pickup_status"] ?? 0,
      dropOpt: json["drop_opt"] ?? 0,
      dropStatus: json["drop_status"] ?? 0,
      bookingTime: json["booking_time"] ?? "",
      cancelRefundAmountGiven: json["cancel_refund_amount_given"] ?? 0,
      invoiceUrl: json["invoice_url"] ?? "",
      itineraryPlace: json["itinerary_place"] == null
          ? []
          : List<ItineraryPlace>.from(
              json["itinerary_place"]!.map((x) => ItineraryPlace.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "qty": qty,
        "en_tour_name": enTourName,
        "tour_id": tourId,
        "review_status": reviewStatus,
        "hi_tour_name": hiTourName,
        "tour_image": tourImage,
        "amount": amount,
        "coupon_amount": couponAmount,
        "total_amount": totalAmount,
        "remaining_amount": remainingAmount,
        "paid_amount": paidAmount,
        "refund_status": refundStatus,
        "refund_amount": refundAmount,
        "pay_amount": payAmount,
        "total_tax_price": totalTaxPrice,
        "booking_packages": bookingPackages.map((x) => x.toJson()).toList(),
        "part_payment": partPayment,
        "amount_status": amountStatus,
        "transaction_id": transactionId,
        "pickup_address": pickupAddress,
        "pickup_date": pickupDate,
        "pickup_time": pickupTime,
        "pickup_otp": pickupOtp,
        "pickup_status": pickupStatus,
        "drop_opt": dropOpt,
        "drop_status": dropStatus,
        "booking_time": bookingTime,
        "cancel_refund_amount_given": cancelRefundAmountGiven,
        "invoice_url": invoiceUrl,
        "itinerary_place": itineraryPlace.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$id, $orderId, $qty, $enTourName, $tourId, $reviewStatus, $hiTourName, $tourImage, $amount, $couponAmount, $totalAmount, $remainingAmount, $paidAmount, $refundStatus, $refundAmount, $payAmount, $totalTaxPrice, $bookingPackages, $partPayment, $amountStatus, $transactionId, $pickupAddress, $pickupDate, $pickupTime, $pickupOtp, $pickupStatus, $dropOpt, $dropStatus, $bookingTime, $cancelRefundAmountGiven, $invoiceUrl, $itineraryPlace, ";
  }
}

class BookingPackage {
  BookingPackage({
    required this.enName,
    required this.hiName,
    required this.image,
    required this.price,
    required this.qty,
  });

  final String enName;
  final String hiName;
  final String image;
  final dynamic price;
  final dynamic qty;

  factory BookingPackage.fromJson(Map<String, dynamic> json) {
    return BookingPackage(
      enName: json["en_name"] ?? "",
      hiName: json["hi_name"] ?? "",
      image: json["image"] ?? "",
      price: json["price"] ?? "",
      qty: json["qty"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "en_name": enName,
        "hi_name": hiName,
        "image": image,
        "price": price,
        "qty": qty,
      };

  @override
  String toString() {
    return "$enName, $hiName, $image, $price, $qty, ";
  }
}

class ItineraryPlace {
  ItineraryPlace({
    required this.id,
    required this.enName,
    required this.hiName,
    required this.enTime,
    required this.hiTime,
    required this.enDescription,
    required this.hiDescription,
    required this.image,
  });

  final int id;
  final String enName;
  final String hiName;
  final String enTime;
  final String hiTime;
  final String enDescription;
  final String hiDescription;
  final List<dynamic> image;

  factory ItineraryPlace.fromJson(Map<String, dynamic> json) {
    return ItineraryPlace(
      id: json["id"] ?? 0,
      enName: json["en_name"] ?? "",
      hiName: json["hi_name"] ?? "",
      enTime: json["en_time"] ?? "",
      hiTime: json["hi_time"] ?? "",
      enDescription: json["en_description"] ?? "",
      hiDescription: json["hi_description"] ?? "",
      image: json["image"] == null
          ? []
          : List<dynamic>.from(json["image"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "en_name": enName,
        "hi_name": hiName,
        "en_time": enTime,
        "hi_time": hiTime,
        "en_description": enDescription,
        "hi_description": hiDescription,
        "image": image.map((x) => x).toList(),
      };

  @override
  String toString() {
    return "$id, $enName, $hiName, $enTime, $hiTime, $enDescription, $hiDescription, $image, ";
  }
}
