import 'package:BharatiyAstro/utils/global.dart' as global;

class MessageModelLive {
  int? id;
  int? userId1;
  int? userId2;
  String? message;
  bool? isRead;
  bool? isActive;
  bool? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderId;
  MessageModelLive({this.id, this.userId1, this.userId2, this.message, this.isActive, this.isRead, this.isDelete, this.createdAt, this.updatedAt, this.orderId});
  static MessageModelLive fromJson(Map<String, dynamic> json) => MessageModelLive(
        userId1: json['userId1'],
        userId2: json['userId2'],
        message: json['message'],
        isActive: json['isActive'],
        orderId: json['orderId'],
        isDelete: json['isDelete'],
        isRead: json['isRead'],
        createdAt: global.DateFormatter.toDateTime(json['createdAt']),
        updatedAt: global.DateFormatter.toDateTime(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId1': userId1,
        'userId2': userId2,
        'message': message,
        'orderId': orderId,
        'isDelete': isDelete,
        'isRead': isRead,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
      };
}
