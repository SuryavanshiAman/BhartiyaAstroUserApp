class CallHistoryModel {
  CallHistoryModel({
    this.id,
    this.userId,
    this.astrologerId,
    this.callStatus,
    this.channelName,
    this.token,
    this.totalMin,
    this.deduction,
    this.astrologerName,
    this.contactNo,
    this.callRate,
    this.profileImage,
    this.charge,
    this.createdAt,
    this.sId,
    this.sId1,
    this.isFreeSession,
  });

  int? id;
  int? userId;
  int? astrologerId;
  String? callStatus;
  String? channelName;
  String? token;
  String? totalMin;
  String? callRate;
  double? deduction;
  String? astrologerName;
  String? contactNo;
  String? profileImage;
  int? charge;
  DateTime? createdAt;
  String? sId;
  String? sId1;
  bool? isFreeSession;

  CallHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"] ?? 0;
    astrologerId = json["astrologerId"] ?? 0;
    callStatus = json["callStatus"] ?? "";
    channelName = json["channelName"] ?? "";
    token = json["token"] ?? "";
    totalMin = json["totalMin"] ?? "";
    callRate = json["callRate"] ?? "";
    deduction = json["deduction"] != null ? double.parse(json["deduction"].toString()) : 0;
    astrologerName = json["astrologerName"] ?? "";
    contactNo = json["contactNo"] ?? "";
    profileImage = json["profileImage"] ?? "";
    charge = json["charge"] ?? 0;
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : null;
    sId = json['sId'] ?? "";
    sId1 = json['sId1'] ?? "";
    isFreeSession = json['isFreeSession'] ?? false;
  }
}
