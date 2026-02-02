class NotificationItemModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? newNotificationItem;
  List<NotificationItem>? notification;

  NotificationItemModel(
      {this.totalSize,
      this.limit,
      this.offset,
      this.newNotificationItem,
      this.notification});

  NotificationItemModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    newNotificationItem = json['new_notification'];
    if (json['notification'] != null) {
      notification = <NotificationItem>[];
      json['notification'].forEach((v) {
        notification!.add(NotificationItem.fromJson(v));
      });
    }
  }
}

class NotificationItem {
  int? id;
  String? sentBy;
  String? sentTo;
  String? title;
  String? description;
  String? type;
  String? serviceId;
  String? slug;
  int? notificationCount;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  NotificationSeenBy? seen;

  NotificationItem({
    this.id,
    this.sentBy,
    this.sentTo,
    this.title,
    this.description,
    this.type,
    this.serviceId,
    this.slug,
    this.notificationCount,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.seen,
  });

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sentBy = json['sent_by'];
    sentTo = json['sent_to'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    serviceId = json['service_id'];
    slug = json['slug'];
    notificationCount = int.parse(json['notification_count'].toString());
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    seen = json['notification_seen_by'] != null
        ? NotificationSeenBy.fromJson(json['notification_seen_by'])
        : null;
  }
}

class NotificationSeenBy {
  int? id;
  int? userId;
  int? notificationId;
  String? createdAt;

  NotificationSeenBy({
    this.id,
    this.userId,
    this.notificationId,
    this.createdAt,
  });

  NotificationSeenBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = int.parse(json['user_id'].toString());
    notificationId = int.parse(json['notification_id'].toString());
    createdAt = json['created_at'];
  }
}
