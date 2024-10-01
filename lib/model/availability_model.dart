import 'availableTimes_model.dart';

class Availability {
  Availability({this.day, this.time});

  String? day;
  List<AvailableTimes>? time = [];

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        day: json["day"],
        time: json['time'] != null ? List<AvailableTimes>.from(json['time'].map((p) => AvailableTimes.fromJson(p))) : [],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
      };
}
