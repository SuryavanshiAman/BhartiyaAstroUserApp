class AmountModel {
  AmountModel({
    this.id,
    this.amount,
    this.offer,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? amount;
  int? offer;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AmountModel.fromJson(Map<String, dynamic> json) => AmountModel(
        id: json["id"],
        amount: json["amount"],
        offer: json["offer"],
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer": offer,
        "amount": amount,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
