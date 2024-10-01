class LiveAstrologerModel {
  LiveAstrologerModel({required this.name, required this.charge, this.profileImage, required this.id, required this.astrologerId, required this.channelName, required this.token, required this.chatToken, required this.videoCallRate, this.isFollow});

  String name;
  dynamic profileImage;
  int id;
  int astrologerId;
  String channelName;
  String token;
  String chatToken;
  double charge;
  double videoCallRate;
  bool? isFollow;

  factory LiveAstrologerModel.fromJson(Map<String, dynamic> json) => LiveAstrologerModel(
        name: json["name"] ?? "",
        profileImage: json["profileImage"] ?? "",
        id: json["id"],
        astrologerId: json["astrologerId"],
        channelName: json["channelName"] ?? "",
        token: json["token"] ?? "",
        chatToken: json['liveChatToken'] ?? "",
        charge: json['charge'] != null ? double.parse(json['charge'].toString()) : 0.0,
        videoCallRate: json['videoCallRate'] != null ? double.parse(json['videoCallRate'].toString()) : 0.0,
        isFollow: json["isFollow"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "profileImage": profileImage,
        "id": id,
        "astrologerId": astrologerId,
        "channelName": channelName,
        "token": token,
        "videoCallRate": videoCallRate,
        "isFollow": isFollow ?? false,
      };
}
