class HelpAndSupportModel {
  HelpAndSupportModel({
    required this.id,
    required this.name,
    this.isSubCategory,
  });

  int id;
  String name;
  bool? isSubCategory;

  factory HelpAndSupportModel.fromJson(Map<String, dynamic> json) => HelpAndSupportModel(
        id: json["id"],
        name: json["name"],
        isSubCategory: json["isSubCategory"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isSubCategory": isSubCategory,
      };
}
