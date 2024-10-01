class IntakeModel {
  IntakeModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.countryCode,
    this.birthDate,
    this.birthTime,
    this.maritalStatus,
    this.occupation,
    this.topicOfConcern,
    this.partnerName,
    this.gender,
    this.partnerBirthDate,
    this.partnerBirthPlace,
    this.partnerBirthTime,
    this.birthPlace,
  });
  int? id;
  String? name;
  String? phoneNumber;
  String? countryCode;
  String? gender;
  DateTime? birthDate;
  String? birthPlace;
  String? birthTime;
  String? maritalStatus;
  String? occupation;
  String? topicOfConcern;
  String? partnerName;
  DateTime? partnerBirthDate;
  String? partnerBirthTime;
  String? partnerBirthPlace;

  factory IntakeModel.fromJson(Map<String, dynamic> json) => IntakeModel(
        id: json["id"],
        name: json["name"] ?? "",
        phoneNumber: json["phoneNumber"],
        countryCode: json["countryCode"] ?? "IN",
        birthDate: DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String()),
        birthTime: json["birthTime"] ?? "",
        maritalStatus: json["maritalStatus"] ?? "",
        birthPlace: json["birthPlace"] ?? "",
        occupation: json["occupation"] ?? "",
        topicOfConcern: json["topicOfConcern"] ?? "",
        partnerName: json["partnerName"] ?? null,
        gender: json["gender"] ?? "Male",
        partnerBirthDate: json["partnerBirthDate"] != null ? DateTime.parse(json["partnerBirthDate"]) : null,
        partnerBirthTime: json["partnerBirthTime"] ?? "",
        partnerBirthPlace: json["partnerBirthPlace"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "birthDate": birthDate!.toIso8601String(),
        "birthTime": birthTime,
        "maritalStatus": maritalStatus,
        "birthPlace": birthPlace,
        "occupation": occupation,
        "topicOfConcern": topicOfConcern,
        "partnerName": partnerName ?? "",
        "gender": gender,
        "partnerBirthDate": partnerBirthDate != null ? partnerBirthDate!.toIso8601String() : null,
        "partnerBirthTime": partnerBirthTime ?? "",
        "partnerBirthPlace": partnerBirthPlace ?? "",
      };
}
