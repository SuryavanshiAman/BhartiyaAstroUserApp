class LiveUserModel {
  LiveUserModel({
    this.id,
    this.userId,
    required this.fcmToken,
    required this.channelName,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? fcmToken;
  String? channelName;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory LiveUserModel.fromJson(Map<String, dynamic> json) => LiveUserModel(
        id: json["id"],
        userId: json["userId"],
        fcmToken: json["fcmToken"] ?? "",
        channelName: json["channelName"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "fcmToken": fcmToken,
        "channelName": channelName,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
      };
}
