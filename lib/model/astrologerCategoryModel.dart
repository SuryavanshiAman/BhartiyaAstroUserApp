class AstrologerCategoryModel {
  AstrologerCategoryModel({
    this.id,
    required this.name,
    required this.image,
  });
  int? id;
  String name;
  String image;

  factory AstrologerCategoryModel.fromJson(Map<String, dynamic> json) =>
      AstrologerCategoryModel(
        id: json["id"],
        name: json["name"] ?? "",
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
