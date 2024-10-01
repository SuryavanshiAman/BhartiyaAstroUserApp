class DailyHororscopeModel {
  DailyHororscopeModel({this.id, this.category, this.name, this.coverImage, this.description, this.horoscopeDate, this.link, this.title, this.horoscopeSignId, this.percent});

  int? id;
  int? percent;
  String? category;
  int? horoscopeSignId;
  String? description;
  DateTime? horoscopeDate;
  String? coverImage;
  String? title;
  String? name;
  String? link;

  DailyHororscopeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    percent = json["percentage"];
    category = json["category"] ?? "";
    horoscopeSignId = json["horoscopeSignId"] ?? "";
    description = json["description"] ?? "";
    horoscopeDate = DateTime.parse(json["horoscopeDate"] ?? DateTime.now().toIso8601String());
    coverImage = json["coverImage"] ?? "";
    title = json["title"] ?? "";
    link = json["link"] ?? "";
    name = json["name"] ?? "";
  }

  Map<String, dynamic> toJson() => {"id": id, "percentage": percent, "category": category, "description": description, "horoscopeSignId": horoscopeSignId, "horoscopeDate": horoscopeDate, "coverImage": coverImage, "title": title, "link": link, "name": name};
}

class DailyscopeModel {
  List<DailyHororscopeModel>? todayHoroscope = [];
  List<DailyHororscopeModel>? yeasterDayHoroscope = [];
  List<DailyHororscopeModel>? tomorrowHoroscope = [];
  List<DailyHororscopeModel>? todayInsight = [];
  List<DailyHororscopeModel>? yeasterdayInsight = [];
  List<DailyHororscopeModel>? tomorrowInsight = [];
  List<DailyHororscopeModel>? weeklyHoroScope = [];
  List<DailyHororscopeModel>? monthlyHoroScope = [];
  List<DailyHororscopeModel>? yearlyHoroScope = [];
  List<HoroscopeStatic>? todayHoroscopeStatics = [];
  List<HoroscopeStatic>? yeasterdayHoroscopeStatics = [];
  List<HoroscopeStatic>? tomorrowHoroscopeStatics = [];

  DailyscopeModel({
    this.todayHoroscope,
    this.yeasterDayHoroscope,
    this.tomorrowHoroscope,
    this.todayInsight,
    this.yeasterdayInsight,
    this.tomorrowInsight,
    this.weeklyHoroScope,
    this.monthlyHoroScope,
    this.yearlyHoroScope,
    this.todayHoroscopeStatics,
    this.tomorrowHoroscopeStatics,
    this.yeasterdayHoroscopeStatics,
  });

  DailyscopeModel.fromJson(Map<String, dynamic> json) {
    try {
      todayHoroscope = json['todayHoroscope'] != null ? List<DailyHororscopeModel>.from(json['todayHoroscope'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      yeasterDayHoroscope = json["yeasterDayHoroscope"] != null ? List<DailyHororscopeModel>.from(json['yeasterDayHoroscope'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      tomorrowHoroscope = json["tomorrowHoroscope"] != null ? List<DailyHororscopeModel>.from(json['tomorrowHoroscope'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      todayInsight = json["todayInsight"] != null ? List<DailyHororscopeModel>.from(json['todayInsight'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      yeasterdayInsight = json["yeasterdayInsight"] != null ? List<DailyHororscopeModel>.from(json['yeasterdayInsight'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      tomorrowInsight = json["tomorrowInsight"] != null ? List<DailyHororscopeModel>.from(json['tomorrowInsight'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      weeklyHoroScope = json["weeklyHoroScope"] != null ? List<DailyHororscopeModel>.from(json['weeklyHoroScope'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      monthlyHoroScope = json["monthlyHoroScope"] != null ? List<DailyHororscopeModel>.from(json['monthlyHoroScope'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      yearlyHoroScope = json["yearlyHoroScope"] != null ? List<DailyHororscopeModel>.from(json['yearlyHoroScope'].map((p) => DailyHororscopeModel.fromJson(p))) : [];
      todayHoroscopeStatics = json["todayHoroscopeStatics"] != null ? List<HoroscopeStatic>.from(json['todayHoroscopeStatics'].map((p) => HoroscopeStatic.fromJson(p))) : [];
      yeasterdayHoroscopeStatics = json["yeasterdayHoroscopeStatics"] != null ? List<HoroscopeStatic>.from(json['yeasterdayHoroscopeStatics'].map((p) => HoroscopeStatic.fromJson(p))) : [];
      tomorrowHoroscopeStatics = json["tomorrowHoroscopeStatics"] != null ? List<HoroscopeStatic>.from(json['tomorrowHoroscopeStatics'].map((p) => HoroscopeStatic.fromJson(p))) : [];
    } catch (e) {
      print('Exception in DailyscopeModel():' + e.toString());
    }
  }
  Map<String, dynamic> toJson() => {
        "todayHoroscope": todayHoroscope,
        "yeasterDayHoroscope": yeasterDayHoroscope,
        "tomorrowHoroscope": tomorrowHoroscope,
        "todayInsight": todayInsight,
        "yeasterdayInsight": yeasterdayInsight,
        "tomorrowInsight": tomorrowInsight,
        "weeklyHoroScope": weeklyHoroScope,
        "monthlyHoroScope": monthlyHoroScope,
        "yearlyHoroScope": yearlyHoroScope,
        "todayHoroscopeStatics": todayHoroscopeStatics,
        "yeasterdayHoroscopeStatics": yeasterdayHoroscopeStatics,
        "tomorrowHoroscopeStatics": tomorrowHoroscopeStatics,
      };
}

class HoroscopeStatic {
  HoroscopeStatic({
    this.id,
    this.horoscopeSignId,
    this.horoscopeDate,
    this.luckyTime,
    this.luckyColor,
    this.luckyNumber,
    this.moodday,
  });

  int? id;
  int? horoscopeSignId;
  DateTime? horoscopeDate;
  String? luckyTime;
  String? luckyColor;
  String? luckyNumber;
  String? moodday;

  factory HoroscopeStatic.fromJson(Map<String, dynamic> json) => HoroscopeStatic(
        id: json["id"],
        horoscopeSignId: json["horoscopeSignId"],
        horoscopeDate: DateTime.parse(json["horoscopeDate"]),
        luckyTime: json["luckyTime"],
        luckyColor: json["luckyColor"],
        luckyNumber: json["luckyNumber"],
        moodday: json["moodday"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "horoscopeSignId": horoscopeSignId,
        "horoscopeDate": horoscopeDate != null ? horoscopeDate!.toIso8601String() : null,
        "luckyTime": luckyTime,
        "luckyColor": luckyColor,
        "luckyNumber": luckyNumber,
        "moodday": moodday,
      };
}
