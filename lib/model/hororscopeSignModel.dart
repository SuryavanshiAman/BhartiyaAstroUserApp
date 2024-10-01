class HororscopeSignModel {
  HororscopeSignModel({this.id, required this.name, required this.image, this.isSelected = false});
  int? id;
  String name;
  String image;
  bool isSelected;

  factory HororscopeSignModel.fromJson(Map<String, dynamic> json) => HororscopeSignModel(
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
