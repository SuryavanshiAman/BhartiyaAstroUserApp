class NotificationsModel {
  NotificationsModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.notificationId,
    this.createdAt,
  });

  int? id;
  int? userId;
  String? title;
  String? description;
  int? notificationId;
  DateTime? createdAt;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        notificationId: json["notificationId"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "notificationId": notificationId,
        "created_at": createdAt!.toIso8601String(),
      };
}
