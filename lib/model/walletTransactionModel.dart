class WalletTransaction {
  WalletTransaction({this.id, required this.name, required this.value});
  int? id;
  String name;
  String value;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
        id: json["id"],
        name: json["name"] ?? "",
        value: json["value"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
      };
}
