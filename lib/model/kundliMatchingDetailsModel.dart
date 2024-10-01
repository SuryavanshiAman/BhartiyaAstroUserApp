// ignore_for_file: non_constant_identifier_names

class KundliMatchingDetailModel {
  KundliMatchingDetailModel({
    this.id,
    this.description,
    this.male_koot_attribute,
    this.female_koot_attribute,
    this.total_points,
    this.received_points,
  });
  int? id;
  String? description;
  String? male_koot_attribute;
  String? female_koot_attribute;
  int? total_points;
  double? received_points;

  KundliMatchingDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      description = json["description"] ?? "";
      male_koot_attribute = json["male_koot_attribute"] ?? "";
      female_koot_attribute = json["female_koot_attribute"] ?? "";
      total_points = json["total_points"] ?? 0;
      received_points = json["received_points"] != null ? double.parse(json["received_points"].toString()) : 0;
    } catch (e) {
      print('Exception in KundliMatchingDetailModel():' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {"id": id, "description": description, "male_koot_attribute": male_koot_attribute, "female_koot_attribute": female_koot_attribute, "total_points": total_points, "received_points": received_points};
}

class KundliMatchingTitleModel {
  KundliMatchingDetailModel? varnaList = KundliMatchingDetailModel();
  KundliMatchingDetailModel? vashyaList = KundliMatchingDetailModel();
  KundliMatchingDetailModel? taraList = KundliMatchingDetailModel();
  KundliMatchingDetailModel? maitriList = KundliMatchingDetailModel();
  KundliMatchingDetailModel? yoniList = KundliMatchingDetailModel();
  KundliMatchingDetailModel? ganList = KundliMatchingDetailModel();
  KundliMatchingDetailModel? bhakutList = KundliMatchingDetailModel();
  KundliMatchingDetailModel? nadiList = KundliMatchingDetailModel();
  TotalMatchModel? totalList = TotalMatchModel();
  ConclusionModel? conclusionList = ConclusionModel();
  KundliMatchingTitleModel({
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

  KundliMatchingTitleModel.fromJson(Map<String, dynamic> json) {
    try {
      varnaList = json['varna'] != null ? KundliMatchingDetailModel.fromJson(json['varna']) : KundliMatchingDetailModel();
      vashyaList = json["vashya"] != null ? KundliMatchingDetailModel.fromJson(json['vashya']) : KundliMatchingDetailModel();
      taraList = json["tara"] != null ? KundliMatchingDetailModel.fromJson(json['tara']) : KundliMatchingDetailModel();
      yoniList = json["yoni"] != null ? KundliMatchingDetailModel.fromJson(json['yoni']) : KundliMatchingDetailModel();
      maitriList = json["maitri"] != null ? KundliMatchingDetailModel.fromJson(json['maitri']) : KundliMatchingDetailModel();
      ganList = json["gan"] != null ? KundliMatchingDetailModel.fromJson(json['gan']) : KundliMatchingDetailModel();
      bhakutList = json["bhakut"] != null ? KundliMatchingDetailModel.fromJson(json['bhakut']) : KundliMatchingDetailModel();
      nadiList = json["nadi"] != null ? KundliMatchingDetailModel.fromJson(json['nadi']) : KundliMatchingDetailModel();
      totalList = json["total"] != null ? TotalMatchModel.fromJson(json['total']) : TotalMatchModel();
      conclusionList = json["conclusion"] != null ? ConclusionModel.fromJson(json['conclusion']) : ConclusionModel();
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

class TotalMatchModel {
  TotalMatchModel({
    this.totalPoints,
    this.receivedPoints,
    this.minimumRequired,
  });
  int? totalPoints;
  double? receivedPoints;
  int? minimumRequired;

  factory TotalMatchModel.fromJson(Map<String, dynamic> json) => TotalMatchModel(
        totalPoints: json["total_points"] ?? 0,
        receivedPoints: json["received_points"] != null ? double.parse(json["received_points"].toString()) : 0,
        minimumRequired: json["minimum_required"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "varna": totalPoints,
        "received_points": receivedPoints,
        "minimum_required": minimumRequired,
      };
}

class ConclusionModel {
  ConclusionModel({
    this.status,
    this.report,
  });
  bool? status;
  String? report;

  factory ConclusionModel.fromJson(Map<String, dynamic> json) => ConclusionModel(
        status: json["status"] ?? false,
        report: json["report"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "report": report,
      };
}
