class AssistantModel {
  AssistantModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    required this.astrologerId,
    required this.customerId,
    this.profileImage,
    this.astrologerName,
    this.lastMessage,
    this.lastMessageTime,
  });

  int id;
  int senderId;
  int receiverId;
  String chatId;
  DateTime createdAt;
  DateTime updatedAt;
  int astrologerId;
  int customerId;
  String? profileImage;
  String? astrologerName;
  String? lastMessage;
  DateTime? lastMessageTime;

  factory AssistantModel.fromJson(Map<String, dynamic> json) => AssistantModel(
        id: json["id"],
        senderId: json["senderId"] ?? 0,
        receiverId: json["receiverId"] ?? 0,
        chatId: json["chatId"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        astrologerId: json["astrologerId"],
        customerId: json["customerId"],
        profileImage: json["profileImage"] ?? "",
        astrologerName: json["astrologerName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "chatId": chatId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "astrologerId": astrologerId,
        "customerId": customerId,
        "profileImage": profileImage,
        "astrologerName": astrologerName,
      };
}
