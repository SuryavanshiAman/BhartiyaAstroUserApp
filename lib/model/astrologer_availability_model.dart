class AstrologerAvailibilityModel {
  AstrologerAvailibilityModel({
    this.day,
    this.time,
  });

  String? day;
  List<Time>? time;

  factory AstrologerAvailibilityModel.fromJson(Map<String, dynamic> json) => AstrologerAvailibilityModel(
        day: json["day"],
        time: List<Time>.from(json["time"].map((x) => Time.fromMap(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "time": List<dynamic>.from(time!.map((x) => x.toMap())),
      };
}

class Time {
  Time({
    this.fromTime,
    this.toTime,
  });

  dynamic fromTime;
  dynamic toTime;

  factory Time.fromMap(Map<String, dynamic> json) => Time(
        fromTime: json["fromTime"],
        toTime: json["toTime"],
      );

  Map<String, dynamic> toMap() => {
        "fromTime": fromTime,
        "toTime": toTime,
      };
}
