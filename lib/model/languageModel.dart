class LanguageModel {
  LanguageModel({
    this.id,
    required this.languageName,
    this.isSelected,
  });
  int? id;
  String languageName;
  bool? isSelected = true;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        id: json["id"],
        languageName: json["languageName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "languageName": languageName,
      };
}
