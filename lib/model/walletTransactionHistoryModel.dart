class WalletTransactionHistoryModel {
  WalletTransactionHistoryModel({this.id, this.userId, this.orderId, this.isCredit = false, this.amount, this.transactionType, this.name, this.totalMin, this.createdAt, this.updatedAt});

  int? id;
  int? userId;
  int? orderId;
  double? amount;
  String? transactionType;
  String? name;
  String? totalMin;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isCredit;
  String? description;

  WalletTransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"] ?? 0;
    orderId = json["orderId"] ?? 0;
    amount = json["amount"] != null ? double.parse(json["amount"].toString()) : 0;
    name = json["name"] ?? "";
    totalMin = json["totalMin"] ?? "";
    transactionType = json["transactionType"] ?? "";
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    updatedAt = DateTime.parse(json["updated_at"]);
    isCredit = json['isCredit'] != null
        ? json['isCredit'] == 1
            ? true
            : false
        : false;
        description = json['description'];
  }
}
