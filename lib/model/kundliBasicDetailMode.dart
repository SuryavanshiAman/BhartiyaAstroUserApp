// ignore_for_file: non_constant_identifier_names

class KundliBasicDetail {
  KundliBasicDetail({this.day, this.month, this.year, this.hour, this.min, this.lat, this.lon, this.tzone, this.ayanamsha, this.sunrise, this.sunset});

  int? day;
  int? month;
  int? year;
  int? hour;
  int? min;
  double? lat;
  double? lon;
  double? tzone;
  double? ayanamsha;
  String? sunrise;
  String? sunset;
  factory KundliBasicDetail.fromJson(Map<String, dynamic> json) => KundliBasicDetail(
        day: json["day"] ?? 0,
        month: json["month"] ?? 0,
        year: json["year"] ?? 0,
        hour: json["hour"] ?? 0,
        min: json["minute"] ?? 0,
        lat: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
        lon: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
        tzone: json['timezone'] != null ? double.parse(json['timezone'].toString()) : 0.0,
        ayanamsha: json['ayanamsha'] != null ? double.parse(json['ayanamsha'].toString()) : 0.0,
        sunrise: json["sunrise"] ?? "",
        sunset: json["sunset"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
        "hour": hour,
        "minute": min,
        "latitude": lat,
        "longitude": lon,
        "timezone": tzone,
        "ayanamsha": ayanamsha,
        "sunset": sunset,
        "sunrise": sunrise,
      };
}

class KundliBasicPanchangDetail {
  KundliBasicPanchangDetail({this.day, this.vedic_sunrise, this.vedic_sunset, this.month, this.year, this.hour, this.min, this.lat, this.lon, this.tzone, this.sunrise, this.sunset, this.karan, this.nakshatra, this.tithi, this.yog});

  String? day;
  int? month;
  int? year;
  int? hour;
  int? min;
  double? lat;
  double? lon;
  double? tzone;
  String? sunrise;
  String? sunset;
  String? tithi;
  String? nakshatra;
  String? yog;
  String? karan;
  String? vedic_sunrise;
  String? vedic_sunset;

  factory KundliBasicPanchangDetail.fromJson(Map<String, dynamic> json) => KundliBasicPanchangDetail(
        day: json["day"] ?? "",
        month: json["month"] ?? 0,
        year: json["year"] ?? 0,
        hour: json["hour"] ?? 0,
        min: json["minute"] ?? 0,
        lat: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
        lon: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
        tzone: json['timezone'] != null ? double.parse(json['timezone'].toString()) : 0.0,
        sunrise: json["sunrise"] ?? "",
        sunset: json["sunset"] ?? "",
        karan: json["karan"] ?? "",
        nakshatra: json["nakshatra"] ?? "",
        tithi: json["tithi"] ?? "",
        vedic_sunrise: json["vedic_sunrise"] ?? "",
        vedic_sunset: json["vedic_sunset"] ?? "",
      );

  Map<String, dynamic> toJson() => {"day": day, "month": month, "vedic_sunset": vedic_sunset, "vedic_sunrise": vedic_sunrise, "year": year, "hour": hour, "minute": min, "latitude": lat, "longitude": lon, "timezone": tzone, "sunset": sunset, "sunrise": sunrise, "yog": yog, "tithi": tithi, "nakshatra": nakshatra, "karan": karan};
}

class KundliAvakhdaDetail {
  KundliAvakhdaDetail({
    this.gan,
    this.karan,
    this.nadi,
    this.naksahtra,
    this.nameAlphabet,
    this.paya,
    this.sign,
    this.signLord,
    this.tatva,
    this.tithi,
    this.varna,
    this.vashya,
    this.yog,
    this.yoni,
    this.yunja,
  });

  String? varna;
  String? vashya;
  String? yoni;
  String? gan;
  String? nadi;
  String? sign;
  String? signLord;
  String? naksahtra;
  String? yog;
  String? karan;
  String? tithi;
  String? yunja;
  String? tatva;
  String? nameAlphabet;
  String? paya;

  factory KundliAvakhdaDetail.fromJson(Map<String, dynamic> json) =>
      KundliAvakhdaDetail(gan: json["Gan"] ?? "", nadi: json["Nadi"] ?? "", naksahtra: json["Naksahtra"] ?? "", nameAlphabet: json["name_alphabet"] ?? "", paya: json["paya"] ?? "", sign: json['sign'] ?? "", signLord: json['SignLord'] ?? "", tatva: json['tatva'] ?? "", varna: json["Varna"] ?? "", vashya: json["Vashya"] ?? "", karan: json["Karan"] ?? "", yoni: json["Yoni"] ?? "", tithi: json["Tithi"] ?? "", yog: json["Yog"] ?? "", yunja: json["yunja"] ?? "");

  Map<String, dynamic> toJson() => {"Varna": varna, "Vashya": vashya, "Yoni": yoni, "Gan": gan, "Nadi": nadi, "sign": sign, "SignLord": signLord, "Naksahtra": naksahtra, "Yog": yog, "Karan": karan, "yog": yog, "Tithi": tithi, "name_alphabet": nameAlphabet, "paya": paya};
}

class KundliPlanetsDetail {
  KundliPlanetsDetail({this.fullDegree, this.house, this.id, this.nakshatra, this.nakshatraLord, this.name, this.normDegree, this.sign, this.signLord});

  int? id;
  String? name;
  double? fullDegree;
  double? normDegree;
  String? sign;
  String? signLord;
  String? nakshatra;
  String? nakshatraLord;
  int? house;

  factory KundliPlanetsDetail.fromJson(Map<String, dynamic> json) => KundliPlanetsDetail(
        id: json["id"] ?? 0,
        fullDegree: json['fullDegree'] != null ? double.parse(json['fullDegree'].toString()) : 0.0,
        normDegree: json['normDegree'] != null ? double.parse(json['normDegree'].toString()) : 0.0,
        house: json['house'] ?? 0,
        nakshatraLord: json["nakshatraLord"] ?? "",
        name: json["name"] ?? "",
        sign: json["sign"] ?? "",
        nakshatra: json["nakshatra"] ?? "",
        signLord: json["signLord"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "nakshatra": nakshatra,
        "signLord": signLord,
        "sign": sign,
        "nakshatraLord": nakshatraLord,
        "normDegree": normDegree,
        "fullDegree": fullDegree,
        "house": house,
        "name": name,
        "id": id,
      };
}

class KundliBasicPlanetModel {
  KundliPlanetsDetail? varnaList = KundliPlanetsDetail();
  KundliPlanetsDetail? vashyaList = KundliPlanetsDetail();
  KundliPlanetsDetail? taraList = KundliPlanetsDetail();
  KundliPlanetsDetail? maitriList = KundliPlanetsDetail();
  KundliPlanetsDetail? yoniList = KundliPlanetsDetail();
  KundliPlanetsDetail? ganList = KundliPlanetsDetail();
  KundliPlanetsDetail? bhakutList = KundliPlanetsDetail();
  KundliPlanetsDetail? nadiList = KundliPlanetsDetail();
  KundliPlanetsDetail? totalList = KundliPlanetsDetail();
  KundliPlanetsDetail? conclusionList = KundliPlanetsDetail();
  KundliBasicPlanetModel({
    this.varnaList,
    this.vashyaList,
    this.taraList,
    this.yoniList,
    this.maitriList,
    this.ganList,
    this.bhakutList,
    this.nadiList,
    this.totalList,
    this.conclusionList,
  });

  KundliBasicPlanetModel.fromJson(Map<String, dynamic> json) {
    try {
      varnaList = json['varna'] != null ? KundliPlanetsDetail.fromJson(json['varna']) : KundliPlanetsDetail();
      vashyaList = json["vashya"] != null ? KundliPlanetsDetail.fromJson(json['vashya']) : KundliPlanetsDetail();
      taraList = json["tara"] != null ? KundliPlanetsDetail.fromJson(json['tara']) : KundliPlanetsDetail();
      yoniList = json["yoni"] != null ? KundliPlanetsDetail.fromJson(json['yoni']) : KundliPlanetsDetail();
      maitriList = json["maitri"] != null ? KundliPlanetsDetail.fromJson(json['maitri']) : KundliPlanetsDetail();
      ganList = json["gan"] != null ? KundliPlanetsDetail.fromJson(json['gan']) : KundliPlanetsDetail();
      bhakutList = json["bhakut"] != null ? KundliPlanetsDetail.fromJson(json['bhakut']) : KundliPlanetsDetail();
      nadiList = json["nadi"] != null ? KundliPlanetsDetail.fromJson(json['nadi']) : KundliPlanetsDetail();
      totalList = json["total"] != null ? KundliPlanetsDetail.fromJson(json['total']) : KundliPlanetsDetail();
      conclusionList = json["conclusion"] != null ? KundliPlanetsDetail.fromJson(json['conclusion']) : KundliPlanetsDetail();
    } catch (e) {
      print('Exception in KundliMatchmodel():' + e.toString());
    }
  }
  Map<String, dynamic> toJson() => {
        "varna": varnaList,
        "vashya": varnaList,
        "tara": taraList,
        "yoni": yoniList,
        "maitri": maitriList,
        "gan": ganList,
        "bhakut": bhakutList,
        "nadi": nadiList,
        "total": totalList,
        "conclusion": conclusionList,
      };
}

class GemstoneModel {
  GemstoneDetailModel? lifeStone = GemstoneDetailModel();
  GemstoneDetailModel? luckyStone = GemstoneDetailModel();
  GemstoneDetailModel? fortuneStone = GemstoneDetailModel();

  GemstoneModel({
    this.lifeStone,
    this.luckyStone,
    this.fortuneStone,
  });

  GemstoneModel.fromJson(Map<String, dynamic> json) {
    try {
      lifeStone = json['LIFE'] != null ? GemstoneDetailModel.fromJson(json['LIFE']) : GemstoneDetailModel();
      luckyStone = json["LUCKY"] != null ? GemstoneDetailModel.fromJson(json['LUCKY']) : GemstoneDetailModel();
      fortuneStone = json["BENEFIC"] != null ? GemstoneDetailModel.fromJson(json['BENEFIC']) : GemstoneDetailModel();
    } catch (e) {
      print('Exception in GemstoneModel():' + e.toString());
    }
  }
  Map<String, dynamic> toJson() => {
        "LIFE": lifeStone,
        "BENEFIC": fortuneStone,
        "LUCKY": luckyStone,
      };
}

class GemstoneDetailModel {
  GemstoneDetailModel({this.name, this.wearFinger, this.wearMetal});

  String? name;
  String? wearFinger;
  String? wearMetal;

  GemstoneDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"] ?? "";
      wearFinger = json["wear_finger"] ?? "";
      wearMetal = json["wear_metal"] ?? "";
    } catch (e) {
      print('Exception in KundliMatchingDetailModel():' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "wear_finger": wearFinger,
        "wear_metal": wearMetal,
      };
}

class VimshattariModel {
  VimshattariModel({this.planet, this.start, this.end, this.planetId});

  int? planetId;
  String? planet;
  String? start;
  String? end;

  VimshattariModel.fromJson(Map<String, dynamic> json) {
    try {
      planetId = json["planet_id"] ?? 0;
      planet = json["planet"] ?? "";
      start = json["start"] ?? "";
      end = json["end"] ?? "";
    } catch (e) {
      print('Exception in KundliMatchingDetailModel():' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {"planet": planet, "start": start, "end": end, "planet_id": planetId};
}

class YoginiModel {
  YoginiModel({this.planet, this.start, this.end, this.planetId});

  int? planetId;
  String? planet;
  String? start;
  String? end;

  YoginiModel.fromJson(Map<String, dynamic> json) {
    try {
      planetId = json["planet_id"] ?? 0;
      planet = json["planet"] ?? "";
      start = json["start"] ?? "";
      end = json["end"] ?? "";
    } catch (e) {
      print('Exception in KundliMatchingDetailModel():' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {"planet": planet, "start": start, "end": end, "planet_id": planetId};
}
