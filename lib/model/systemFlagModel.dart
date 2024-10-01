class SystemFlag {
  SystemFlag(
      {this.id,
      required this.name,
      required this.value});
  int? id;
  String name;
  String value;

  factory SystemFlag.fromJson(Map<String, dynamic> json) => SystemFlag(
        id: json["id"],
        name: json["name"] ?? "",
        value: (json["value"]) ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
      };
}
