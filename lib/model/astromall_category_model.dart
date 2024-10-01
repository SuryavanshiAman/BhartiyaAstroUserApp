class AstromallCategoryModel {
  AstromallCategoryModel({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.categoryImage,
  });

  int id;
  String name;
  int displayOrder;
  String categoryImage;

  factory AstromallCategoryModel.fromJson(Map<String, dynamic> json) => AstromallCategoryModel(
        id: json["id"],
        name: json["name"] ?? "",
        displayOrder: json["displayOrder"] == null ? 0 : json["displayOrder"],
        categoryImage: json["categoryImage"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // ignore: unnecessary_null_comparison
        "displayOrder": displayOrder == null ? null : displayOrder,
        "categoryImage": categoryImage,
      };
}
