class GeoCodingModel {
  GeoCodingModel({
    required this.id,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.timezoneId,
  });

  int id;
  String placeName;
  double latitude;
  double longitude;
  String timezoneId;

  factory GeoCodingModel.fromJson(Map<String, dynamic> json) => GeoCodingModel(
        id: json["id"],
        placeName: json["place_name"] ?? "",
        latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
        longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
        timezoneId: json["timezone_id"] == null ? 0 : json["timezone_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "place_name": placeName,
        "latitude": latitude,
        "longitude": longitude,
        "timezone_id": timezoneId,
      };
}
