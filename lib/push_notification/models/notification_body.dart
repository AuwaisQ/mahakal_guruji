class NotificationBody {
  int? orderId;
  String? type;
  String? service_id;
  String? slug;

  NotificationBody({
    this.orderId,
    this.type,
    this.service_id,
    this.slug
  });

  NotificationBody.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    type = json['type'];
    service_id = json['service_id'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['type'] = type;
    data['service_id'] = service_id;
    data['slug'] = slug;
    return data;
  }
}
