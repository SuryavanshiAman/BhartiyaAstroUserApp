class ReportHistoryModel {
  ReportHistoryModel({required this.id, this.userId, this.astrologerId, this.firstName, this.lastName, this.gender, this.birthDate, this.birthTime, this.birthPlace, this.occupation, this.maritalStatus, this.astrologerName, this.contactNo, this.answerLanguage, this.profileImage, this.reportRate, this.comments, this.reportFile, this.reportType, required this.createdAt, this.isFileUpload, this.title});

  int id;
  int? userId;
  String? firstName;
  String? lastName;
  String? gender;
  String? birthDate;
  String? birthTime;
  String? birthPlace;
  String? occupation;
  String? maritalStatus;
  String? answerLanguage;
  String? comments;
  String? contactNo;
  String? reportFile;
  int? reportType;
  int? astrologerId;
  String? astrologerName;
  String? title;
  String? profileImage;
  int? reportRate;
  String createdAt;
  bool? isFileUpload;

  factory ReportHistoryModel.fromJson(Map<String, dynamic> json) => ReportHistoryModel(
        id: json["id"],
        userId: json["userId"] ?? 0,
        firstName: json["firstName"] ?? "",
        astrologerId: json["astrologerId"] ?? 0,
        lastName: json["lastName"] ?? "",
        answerLanguage: json["answerLanguage"] ?? "",
        birthDate: json["birthDate"] ?? "",
        birthPlace: json["birthPlace"] ?? "",
        birthTime: json["birthTime"] ?? "",
        comments: json["comments"] ?? "",
        gender: json["gender"] ?? "",
        maritalStatus: json["maritalStatus"] ?? 0,
        astrologerName: json["astrologerName"] ?? "",
        contactNo: json["contactNo"] ?? "",
        profileImage: json["profileImage"] ?? "",
        occupation: json["occupation"] ?? "",
        reportFile: json["reportFile"] ?? "",
        reportType: json["reportType"] ?? "",
        title: json["title"] ?? "",
        reportRate: json["charge"] ?? 0,
        createdAt: json["created_at"] ?? "",
        isFileUpload: json['isFileUpload'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "astrologerId": astrologerId,
        "answerLanguage": answerLanguage,
        "birthDate": birthDate,
        "birthPlace": birthPlace,
        "birthTime": birthTime,
        "comments": comments,
        "gender": gender,
        "maritalStatus": maritalStatus,
        "occupation": occupation,
        "astrologerName": astrologerName,
        "contactNo": contactNo,
        "profileImage": profileImage,
        "reportRate": reportRate,
        "reportFile": reportFile,
        "reportType": reportType,
        "title": title,
        "created_at": createdAt,
        "isFileUpload": isFileUpload ?? false,
      };
}
