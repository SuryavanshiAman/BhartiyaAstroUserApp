class MessageModel {
  int? id;
  String? message;
  String? userName;
  String? profile;
  bool? isMe;
  String? gift;
  MessageModel({this.id, this.message, this.userName, this.profile, this.isMe, this.gift = 'null'});
}
