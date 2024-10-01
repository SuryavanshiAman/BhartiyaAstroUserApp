class CounsellorModel {
  CounsellorModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.gender,
    required this.birthDate,
    this.primarySkill,
    this.allSkill,
    required this.languageKnown,
    this.profileImage,
    required this.charge,
    required this.experienceInYears,
    required this.dailyContribution,
    this.hearAboutBharatiyAstro,
    this.isWorkingOnAnotherPlatform,
    this.whyOnBoard,
    this.interviewSuitableTime,
    this.currentCity,
    this.mainSourceOfBusiness,
    this.highestQualification,
    this.degree,
    this.college,
    this.learnAstrology,
    required this.astrologerCategoryId,
    this.instaProfileLink,
    this.facebookProfileLink,
    this.linkedInProfileLink,
    this.youtubeChannelLink,
    this.websiteProfileLink,
    this.isAnyBodyRefer,
    required this.minimumEarning,
    required this.maximumEarning,
    this.loginBio,
    this.noofforeignCountriesTravel,
    this.currentlyworkingfulltimejob,
    this.goodQuality,
    this.biggestChallenge,
    this.whatwillDo,
    this.isVerified,
    this.totalOrder,
    this.country,
    this.isFreeAvailable,
  });

  int id;
  int userId;
  String name;
  String email;
  String contactNo;
  String gender;
  DateTime birthDate;
  String? primarySkill;
  String? allSkill;
  String languageKnown;
  String? profileImage;
  int charge;
  int experienceInYears;
  int dailyContribution;
  String? hearAboutBharatiyAstro;
  int? isWorkingOnAnotherPlatform;
  String? whyOnBoard;
  String? interviewSuitableTime;
  String? currentCity;
  String? mainSourceOfBusiness;
  String? highestQualification;
  String? degree;
  String? college;
  String? learnAstrology;
  String astrologerCategoryId;
  String? instaProfileLink;
  String? facebookProfileLink;
  String? linkedInProfileLink;
  String? youtubeChannelLink;
  String? websiteProfileLink;
  int? isAnyBodyRefer;
  int minimumEarning;
  int maximumEarning;
  String? loginBio;
  String? noofforeignCountriesTravel;
  String? currentlyworkingfulltimejob;
  String? goodQuality;
  String? biggestChallenge;
  String? whatwillDo;
  int? isVerified;
  int? totalOrder;
  String? country;
  bool? isFreeAvailable;

  factory CounsellorModel.fromJson(Map<String, dynamic> json) => CounsellorModel(
        id: json["id"],
        userId: json["userId"],
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        contactNo: json["contactNo"],
        gender: json["gender"] ?? "",
        birthDate: DateTime.parse(json["birthDate"]),
        primarySkill: json["primarySkill"] ?? "",
        allSkill: json["allSkill"] ?? "",
        languageKnown: json["languageKnown"] ?? "",
        profileImage: json["profileImage"] ?? "",
        charge: json["charge"] ?? "",
        experienceInYears: json["experienceInYears"] ?? 0,
        dailyContribution: json["dailyContribution"] ?? 0,
        hearAboutBharatiyAstro: json["hearAboutBharatiyAstro"] ?? '',
        isWorkingOnAnotherPlatform: json["isWorkingOnAnotherPlatform"] ?? 0,
        whyOnBoard: json["whyOnBoard"] ?? "",
        interviewSuitableTime: json["interviewSuitableTime"] ?? "",
        currentCity: json["currentCity"] ?? "",
        mainSourceOfBusiness: json["mainSourceOfBusiness"] ?? "",
        highestQualification: json["highestQualification"] ?? "",
        degree: json["degree"] ?? "",
        college: json["college"] ?? "",
        learnAstrology: json["learnAstrology"] ?? "",
        astrologerCategoryId: json["astrologerCategoryId"] ?? "",
        instaProfileLink: json["instaProfileLink"] ?? "",
        facebookProfileLink: json["facebookProfileLink"] ?? "",
        linkedInProfileLink: json["linkedInProfileLink"] ?? "",
        youtubeChannelLink: json["youtubeChannelLink"] ?? "",
        websiteProfileLink: json["websiteProfileLink"] ?? "",
        isAnyBodyRefer: json["isAnyBodyRefer"] ?? 0,
        minimumEarning: json["minimumEarning"] ?? "",
        maximumEarning: json["maximumEarning"] ?? "",
        loginBio: json["loginBio"] ?? "",
        noofforeignCountriesTravel: json["NoofforeignCountriesTravel"] ?? 0,
        currentlyworkingfulltimejob: json["currentlyworkingfulltimejob"] ?? "",
        goodQuality: json["goodQuality"] ?? "",
        biggestChallenge: json["biggestChallenge"] ?? "",
        whatwillDo: json["whatwillDo"] ?? "",
        isVerified: json["isVerified"] ?? "",
        totalOrder: json["totalOrder"] ?? 0,
        country: json["country"] ?? "",
        isFreeAvailable: json['isFreeAvailable'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "email": email,
        "contactNo": contactNo,
        "gender": gender,
        "birthDate": birthDate.toIso8601String(),
        "primarySkill": primarySkill,
        "allSkill": allSkill,
        "languageKnown": languageKnown,
        "profileImage": profileImage,
        "charge": charge,
        "experienceInYears": experienceInYears,
        "dailyContribution": dailyContribution,
        "hearAboutBharatiyAstro": hearAboutBharatiyAstro,
        "isWorkingOnAnotherPlatform": isWorkingOnAnotherPlatform,
        "whyOnBoard": whyOnBoard,
        "interviewSuitableTime": interviewSuitableTime,
        "currentCity": currentCity,
        "mainSourceOfBusiness": mainSourceOfBusiness,
        "highestQualification": highestQualification,
        "degree": degree,
        "college": college,
        "learnAstrology": learnAstrology,
        "astrologerCategoryId": astrologerCategoryId,
        "instaProfileLink": instaProfileLink,
        "facebookProfileLink": facebookProfileLink,
        "linkedInProfileLink": linkedInProfileLink,
        "youtubeChannelLink": youtubeChannelLink,
        "websiteProfileLink": websiteProfileLink,
        "isAnyBodyRefer": isAnyBodyRefer,
        "minimumEarning": minimumEarning,
        "maximumEarning": maximumEarning,
        "loginBio": loginBio,
        "NoofforeignCountriesTravel": noofforeignCountriesTravel,
        "currentlyworkingfulltimejob": currentlyworkingfulltimejob,
        "goodQuality": goodQuality,
        "biggestChallenge": biggestChallenge,
        "whatwillDo": whatwillDo,
        "isVerified": isVerified,
        "totalOrder": totalOrder,
        "country": country,
        "isFreeAvailable": isFreeAvailable,
      };
}
