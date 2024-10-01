class GiftModel {
  GiftModel({
    required this.id,
    required this.name,
    required this.image,
    required this.amount,
    required this.displayOrder,
    this.isSelected = false,
  });

  int id;
  String name;
  String image;
  int amount;
  int displayOrder;
  bool? isSelected;

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        id: json["id"],
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        amount: json["amount"] ?? 0,
        displayOrder: json["displayOrder"] == null ? 0 : json["displayOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "amount": amount,
        "displayOrder": displayOrder == 0 ? null : displayOrder,
      };
}
