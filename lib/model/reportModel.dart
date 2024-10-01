// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

class GetReportModel {
  String screen = 'reportModel.dart';
  GetReportModel({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.contactNo,
    this.gender,
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.occupation,
    this.maritalStatus,
    this.answerLanguage,
    this.partnerName,
    this.partnerBirthDate,
    this.partnerBirthTime,
    this.partnerBirthPlace,
    this.comments,
    this.reportFile,
    this.reportType,
    this.astrologerId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
  });

  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? contactNo;
  String? gender;
  DateTime? birthDate;
  String? birthTime;
  String? birthPlace;
  String? occupation;
  String? maritalStatus;
  String? answerLanguage;
  String? partnerName;
  DateTime? partnerBirthDate;
  String? partnerBirthTime;
  String? partnerBirthPlace;
  String? comments;
  dynamic reportFile;
  dynamic reportType;
  int? astrologerId;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;

  GetReportModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      userId = json["userId"];
      firstName = json["firstName"] ?? '';
      lastName = json["lastName"] ?? '';
      contactNo = json["contactNo"] ?? '';
      gender = json["gender"] ?? '';
      birthDate = DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String());
      birthTime = json["birthTime"] ?? '';
      birthPlace = json["birthPlace"] ?? '';
      occupation = json["occupation"] ?? '';
      maritalStatus = json["maritalStatus"] ?? '';
      answerLanguage = json["answerLanguage"] ?? '';
      partnerName = json["partnerName"] ?? '';
      partnerBirthDate = DateTime.parse(json["partnerBirthDate"] ?? DateTime.now().toIso8601String());
      partnerBirthTime = json["partnerBirthTime"] ?? '';
      partnerBirthPlace = json["partnerBirthPlace"] ?? '';
      comments = json["comments"] ?? '';
      reportFile = json["reportFile"];
      reportType = json["reportType"];
      astrologerId = json["astrologerId"];
      isActive = json["isActive"];
      isDelete = json["isDelete"];
      createdAt = DateTime.parse(json["created_at"]);
      updatedAt = DateTime.parse(json["updated_at"]);
      createdBy = json["createdBy"];
      modifiedBy = json["modifiedBy"];
    } catch (e) {
      print('Exception: $screen - ReportModel.fromJson():-' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "contactNo": contactNo,
        "gender": gender,
        "birthDate": birthDate!.toIso8601String(),
        "birthTime": birthTime,
        "birthPlace": birthPlace,
        "occupation": occupation,
        "maritalStatus": maritalStatus,
        "answerLanguage": answerLanguage,
        "partnerName": partnerName,
        "partnerBirthDate": partnerBirthDate!.toIso8601String(),
        "partnerBirthTime": partnerBirthTime,
        "partnerBirthPlace": partnerBirthPlace,
        "comments": comments,
        "reportFile": reportFile,
        "reportType": reportType,
        "astrologerId": astrologerId,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt != null ? createdAt!.toIso8601String() : null,
        "updated_at": updatedAt != null ? updatedAt!.toIso8601String() : null,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
      };
}

class ReportModel {
  int? id;
  String? name;
  bool? isSeledted;
  String? value;

  ReportModel({this.id, this.name, this.isSeledted, this.value});
}
