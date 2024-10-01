class ChatHistoryModel {
  ChatHistoryModel({this.id, this.userId, this.astrologerId, this.isFreeSession, this.chatStatus, this.chatId, this.senderId, this.receiverId, this.channelName, this.token, this.totalMin, this.deduction, this.astrologerName, this.contactNo, this.chatRate, this.profileImage, this.charge, this.createdAt});

  int? id;
  int? userId;
  String? chatId;
  int? astrologerId;
  String? senderId;
  String? receiverId;
  String? chatStatus;
  String? channelName;
  String? token;
  String? totalMin;
  String? chatRate;
  double? deduction;
  String? astrologerName;
  String? contactNo;
  String? profileImage;
  int? charge;
  DateTime? createdAt;
  bool? isFreeSession;

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"] ?? 0;
    chatId = json["chatId"] ?? "";
    astrologerId = json["astrologerId"] ?? 0;
    chatStatus = json["chatStatus"] ?? "";
    channelName = json["channelName"] ?? "";
    token = json["token"] ?? "";
    receiverId = json["receiverId"] ?? "";
    senderId = json["senderId"] ?? "";
    totalMin = json["totalMin"] ?? "";
    chatRate = json["chatRate"] ?? "";
    deduction = json["deduction"] != null ? double.parse(json["deduction"].toString()) : 0;
    astrologerName = json["astrologerName"] ?? "";
    contactNo = json["contactNo"] ?? "";
    profileImage = json["profileImage"] ?? "";
    charge = json["charge"] ?? 0;
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    isFreeSession = json["isFreeSession"] ?? false;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "chatId": chatId,
        "astrologerId": astrologerId,
        "chatStatus": chatStatus,
        "channelName": channelName,
        "token": token,
        "senderId": senderId,
        "receiverId": receiverId,
        "totalMin": totalMin,
        "chatRate": chatRate,
        "deduction": deduction,
        "astrologerName": astrologerName,
        "contactNo": contactNo,
        "profileImage": profileImage,
        "charge": charge,
        "created_at": createdAt,
        "isFreeSession": isFreeSession ?? false,
      };
}
