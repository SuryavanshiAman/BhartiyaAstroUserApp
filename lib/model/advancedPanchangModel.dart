class PanchangModel {
  PanchangModel({
    required this.id,
    required this.day,
    required this.month,
    required this.year,
    required this.hour,
    required this.min,
    required this.lat,
    required this.lon,
    required this.tzone,
  });

  int id;
  String day;
  String month;
  String year;
  String hour;
  String min;
  String lat;
  String lon;
  String tzone;
  factory PanchangModel.fromJson(Map<String, dynamic> json) => PanchangModel(
        id: json["id"],
        day: json["day"] ?? "",
        month: json["month"] ?? "",
        year: json["year"] ?? "",
        hour: json["hour"] ?? "",
        min: json["min"] ?? "",
        lat: json["lat"] ?? "",
        lon: json["lon"] ?? "",
        tzone: json["tzone"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "month": month,
        "year": year,
        "hour": hour,
        "min": min,
        "lat": lat,
        "lon": lon,
        "tzone": tzone
      };
}
