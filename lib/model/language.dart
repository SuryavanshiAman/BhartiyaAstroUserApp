class Language {
  int? id;
  String title;
  String subTitle;
  bool isSelected;
  String lanCode;
  Language({
    required this.title,
    this.id,
    required this.subTitle,
    this.isSelected = false,
    this.lanCode = 'en',
  });
  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"],
        title: json["languageName"],
        lanCode: json["languageCode"],
        subTitle: json['language_sign'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "languageName": title,
        "languageCode": lanCode,
        "language_sign": subTitle,
      };
}

class TabModel {
  String title;
  bool isSelected;
  TabModel({required this.title, required this.isSelected});
}
