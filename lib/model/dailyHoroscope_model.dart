class Zodic {
  Zodic({
    this.id,
    required this.title,
    required this.image,
    this.isSelected,
  });

  int? id;
  String title;
  String image;
  bool? isSelected = false;

  factory Zodic.fromJson(Map<String, dynamic> json) => Zodic(
        id: json["id"],
        title: json["name"],
        image: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": title,
        "profile": image,
      };
}
