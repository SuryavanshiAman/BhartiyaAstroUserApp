class ReportTypeModel {
  ReportTypeModel({
    required this.id,
    required this.reportImage,
    required this.title,
    required this.description,
  });

  int id;
  String reportImage;
  String title;
  String description;

  factory ReportTypeModel.fromJson(Map<String, dynamic> json) =>
      ReportTypeModel(
        id: json["id"],
        reportImage: json["reportImage"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reportImage": reportImage,
        "title": title,
        "description": description
      };
}
