class PaymentModel {
  PaymentModel({
    this.id,
    required this.paymentMode,
    required this.paymentReference,
    required this.amount,
    this.userId,
    required this.paymentStatus,
  });
  int? id;
  String paymentMode;
  String paymentReference;
  int amount;
  int? userId;
  String paymentStatus;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        paymentMode: json["paymentMode"] ?? "",
        paymentReference: json["paymentReference"] ?? "",
        amount: json["amount"] ?? "",
        userId: json["userId"] ?? "",
        paymentStatus: json["paymentStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paymentMode": paymentMode,
        "paymentReference": paymentReference,
        "amount": amount,
        "userId": userId,
        "paymentStatus": paymentStatus
      };
}
