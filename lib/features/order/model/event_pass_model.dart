class EventPassModel {
  EventPassModel({
    required this.status,
    required this.data,
  });

  final int status;
  final List<EventPass> data;

  factory EventPassModel.fromJson(Map<String, dynamic> json) {
    return EventPassModel(
      status: json["status"] ?? 0,
      data: json["data"] == null
          ? []
          : List<EventPass>.from(
              json["data"]!.map((x) => EventPass.fromJson(x))),
    );
  }
}

class EventPass {
  EventPass({
    required this.amount,
    required this.totalSeats,
    required this.enPackageName,
    required this.hiPackageName,
    required this.enEventName,
    required this.hiEventName,
    required this.enArtistName,
    required this.hiArtistName,
    required this.enOrganizerName,
    required this.hiOrganizerName,
    required this.enCategoryName,
    required this.hiCategoryName,
    required this.eventImage,
    required this.enEventVenue,
    required this.hiEventVenue,
    required this.eventDate,
    required this.footerPhone,
    required this.footerEmail,
    required this.footerUrl,
    required this.footerCopyright,
    required this.passUrl,
    required this.passUserName,
  });

  final int amount;
  final int totalSeats;
  final String enPackageName;
  final String hiPackageName;
  final String enEventName;
  final String hiEventName;
  final String enArtistName;
  final String hiArtistName;
  final String enOrganizerName;
  final String hiOrganizerName;
  final String enCategoryName;
  final String hiCategoryName;
  final String eventImage;
  final String enEventVenue;
  final String hiEventVenue;
  final String eventDate;
  final String footerPhone;
  final String footerEmail;
  final String footerUrl;
  final String footerCopyright;
  final String passUrl;
  final String passUserName;

  factory EventPass.fromJson(Map<String, dynamic> json) {
    return EventPass(
      amount: json["amount"] ?? 0,
      totalSeats: json["total_seats"] ?? 0,
      enPackageName: json["en_package_name"] ?? "",
      hiPackageName: json["hi_package_name"] ?? "",
      enEventName: json["en_event_name"] ?? "",
      hiEventName: json["hi_event_name"] ?? "",
      enArtistName: json["en_artist_name"] ?? "",
      hiArtistName: json["hi_artist_name"] ?? "",
      enOrganizerName: json["en_organizer_name"] ?? "",
      hiOrganizerName: json["hi_organizer_name"] ?? "",
      enCategoryName: json["en_category_name"] ?? "",
      hiCategoryName: json["hi_category_name"] ?? "",
      eventImage: json["event_image"] ?? "",
      enEventVenue: json["en_event_venue"] ?? "",
      hiEventVenue: json["hi_event_venue"] ?? "",
      eventDate: json["event_date"] ?? "",
      footerPhone: json["footer_phone"] ?? "",
      footerEmail: json["footer_email"] ?? "",
      footerUrl: json["footer_url"] ?? "",
      footerCopyright: json["footer_copyright"] ?? "",
      passUrl: json["pass_url"] ?? "",
      passUserName: json["pass_user_name"] ?? "",
    );
  }
}
