class CustomerSuppportModel {
  CustomerSuppportModel({
    this.id,
    this.helpSupportId,
    this.subject,
    this.description,
    this.ticketNumber,
    this.userId,
    this.createdAt,
    this.ticketStatus,
    this.chatId,
    this.name,
  });

  int? id;
  int? helpSupportId;
  String? subject;
  String? description;
  String? ticketNumber;
  int? userId;
  DateTime? createdAt;
  String? ticketStatus;
  String? chatId;
  String? name;

  factory CustomerSuppportModel.fromJson(Map<String, dynamic> json) => CustomerSuppportModel(
        id: json["id"],
        helpSupportId: json["helpSupportId"],
        subject: json["subject"],
        description: json["description"],
        ticketNumber: json["ticketNumber"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["created_at"]),
        ticketStatus: json["ticketStatus"],
        chatId: json["chatId"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "helpSupportId": helpSupportId,
        "subject": subject,
        "description": description,
        "ticketNumber": ticketNumber,
        "userId": userId,
        "created_at": createdAt != null ? createdAt!.toIso8601String() : DateTime.now().toIso8601String(),
        "ticketStatus": ticketStatus,
        "chatId": chatId ?? "",
      };
}
