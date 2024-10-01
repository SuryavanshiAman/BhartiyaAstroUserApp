import 'package:BharatiyAstro/model/availableTimes_model.dart';

import 'availability_model.dart';

class AstrologerModel {
  AstrologerModel({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.mobileNo,
    this.gender,
    this.birthDate,
    this.primarySkill,
    this.allSkill,
    this.languageKnown,
    this.profileImage,
    this.charge,
    this.experienceInYears,
    this.dailyContribution,
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
    this.astrologerCategoryId,
    this.instaProfileLink,
    this.facebookProfileLink,
    this.linkedInProfileLink,
    this.youtubeChannelLink,
    this.websiteProfileLink,
    this.isAnyBodyRefer,
    this.minimumEarning,
    this.maximumEarning,
    this.loginBio,
    this.noofforeignCountriesTravel,
    this.currentlyworkingfulltimejob,
    this.goodQuality,
    this.biggestChallenge,
    this.whatwillDo,
    this.totalOrder,
    this.isFollow,
    this.isBlock,
    this.isTimeSlotAvailable,
    this.createdAt,
    this.chatStatus,
    this.callStatus,
    this.availability,
    this.availableTimes,
    this.callWaitTime,
    this.chatWaitTime,
    this.chatMin,
    this.callMin,
    this.astrologerRating,
    this.astorlogerId,
    this.reportRate,
    this.isFreeAvailable,
    this.similiarConsultant,
    this.videoCallWaitTime
  });

  int? id;
  int? userId;
  String? name;
  String? email;
  int? mobileNo;
  String? gender;
  DateTime? birthDate;
  String? primarySkill;
  String? allSkill;
  String? languageKnown;
  String? profileImage;
  int? charge;
  int? experienceInYears;
  int? dailyContribution;
  String? hearAboutBharatiyAstro;
  int? isWorkingOnAnotherPlatform;
  String? whyOnBoard;
  String? interviewSuitableTime;
  String? currentCity;
  String? mainSourceOfBusiness;
  String? highestQualification;
  bool? isTimeSlotAvailable = false;
  String? degree;
  String? college;
  String? learnAstrology;
  String? astrologerCategoryId;
  String? instaProfileLink;
  String? facebookProfileLink;
  String? linkedInProfileLink;
  String? youtubeChannelLink;
  String? websiteProfileLink;
  int? isAnyBodyRefer;
  int? minimumEarning;
  int? maximumEarning;
  String? loginBio;
  String? noofforeignCountriesTravel;
  String? currentlyworkingfulltimejob;
  String? goodQuality;
  String? biggestChallenge;
  String? whatwillDo;
  int? totalOrder;
  bool? isFollow;
  bool? isBlock;
  int? chatMin;
  int? callMin;
  Rating? astrologerRating;
  double? rating;
  DateTime? createdAt;
  List<Availability>? availability = [];
  List<AvailableTimes>? availableTimes = [];
  String? chatStatus;
  String? callStatus;
  DateTime? chatWaitTime;
  DateTime? callWaitTime;
  DateTime? videoCallWaitTime;
  int? astorlogerId;
  int? reportRate;
  bool? isFreeAvailable;
  List<SimiliarConsultant>? similiarConsultant;

  AstrologerModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    name = json["name"] ?? "";
    email = json["email"] ?? "";
    mobileNo = json["mobileNo"];
    gender = json["gender"] ?? "";
    birthDate = DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String());
    chatWaitTime = json["chatWaitTime"] != null ? DateTime.parse(json["chatWaitTime"] ?? DateTime.now().toIso8601String()) : DateTime.now();
    callWaitTime = json["callWaitTime"] != null ? DateTime.parse(json["callWaitTime"] ?? DateTime.now().toIso8601String()) : DateTime.now();
    primarySkill = json["primarySkill"] ?? "";
    allSkill = json["allSkill"] ?? "";
    languageKnown = json["languageKnown"] ?? "";
    chatStatus = json['chatStatus'] ?? "Online";
    callStatus = json['callStatus'] ?? "Online";
    profileImage = json["profileImage"] ?? "";
    charge = json["charge"] ?? 0;
    experienceInYears = json["experienceInYears"] ?? 0;
    dailyContribution = json["dailyContribution"] ?? 0;
    hearAboutBharatiyAstro = json["hearAboutBharatiyAstro"] ?? "";
    isWorkingOnAnotherPlatform = json["isWorkingOnAnotherPlatform"] ?? 0;
    whyOnBoard = json["whyOnBoard"] ?? "";
    interviewSuitableTime = json["interviewSuitableTime"] ?? "";
    currentCity = json["currentCity"] ?? "";
    mainSourceOfBusiness = json["mainSourceOfBusiness"] ?? "";
    highestQualification = json["highestQualification"] ?? "";
    degree = json["degree"] ?? "";
    college = json["college"] ?? "";
    learnAstrology = json["learnAstrology"] ?? "";
    astrologerCategoryId = json["astrologerCategoryId"] ?? "";
    instaProfileLink = json["instaProfileLink"] ?? "";
    facebookProfileLink = json["facebookProfileLink"] ?? "";
    linkedInProfileLink = json["linkedInProfileLink"] ?? "";
    youtubeChannelLink = json["youtubeChannelLink"] ?? "";
    websiteProfileLink = json["websiteProfileLink"] ?? "";
    isAnyBodyRefer = json["isAnyBodyRefer"] ?? 0;
    minimumEarning = json["minimumEarning"] ?? 0;
    maximumEarning = json["maximumEarning"] ?? 0;
    loginBio = json["loginBio"] ?? "";
    noofforeignCountriesTravel = json["NoofforeignCountriesTravel"] ?? "";
    currentlyworkingfulltimejob = json["currentlyworkingfulltimejob"] ?? "";
    goodQuality = json["goodQuality"] ?? "";
    biggestChallenge = json["biggestChallenge"] ?? "";
    whatwillDo = json["whatwillDo"] ?? "";
    totalOrder = json["totalOrder"] ?? 0;
    isFollow = json["isFollow"] ?? false;
    isBlock = json["isBlock"] ?? false;
    chatMin = json["chatMin"] ?? 0;
    callMin = json["callMin"] ?? 0;
    astorlogerId = json["astorlogerId"] ?? 0;
    reportRate = json["reportRate"] ?? 0;
    videoCallWaitTime =  json["videoCallWaitTime"]??DateTime.now();
    astrologerRating = Rating.fromMap(json["astrologerRating"] ?? {});
    rating = json["rating"] != null ? double.parse(json["rating"].toString()) : 0;
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : null;
    availability = json['availability'] != null ? List<Availability>.from(json['availability'].map((p) => Availability.fromJson(p))) : [];
    isFreeAvailable = json['isFreeAvailable'];
    similiarConsultant = json['similiarConsultant'] != null ? List<SimiliarConsultant>.from(json["similiarConsultant"].map((x) => SimiliarConsultant.fromJson(x))) : [];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "email": email,
        "mobileNo": mobileNo,
        "gender": gender,
        "birthDate": birthDate,
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
        "totalOrder": totalOrder ?? 0,
        "isFollow": isFollow ?? false,
        "isBlock": isBlock ?? false,
        "chatMin": chatMin,
        "callMin": callMin,
        "reportRate": reportRate,
        "astrologerRating": astrologerRating!.toMap(),
        "rating": rating,
        "videoCallWaitTime" :videoCallWaitTime,
        "isFreeAvailable": isFreeAvailable,
        "similiarConsultant": similiarConsultant != null ? List<dynamic>.from(similiarConsultant!.map((x) => x.toJson())) : null,
      };
}

class Rating {
  Rating({
    this.oneStarRating,
    this.twoStarRating,
    this.threeStarRating,
    this.fourStarRating,
    this.fiveStarRating,
  });

  double? oneStarRating;
  double? twoStarRating;
  double? threeStarRating;
  double? fourStarRating;
  double? fiveStarRating;

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
        oneStarRating: json["oneStarRating"] != null ? double.parse(json["oneStarRating"].toString()) : 0,
        twoStarRating: json["twoStarRating"] != null ? double.parse(json["twoStarRating"].toString()) : 0,
        threeStarRating: json["threeStarRating"] != null ? double.parse(json["threeStarRating"].toString()) : 0,
        fourStarRating: json["fourStarRating"] != null ? double.parse(json["fourStarRating"].toString()) : 0,
        fiveStarRating: json["fiveStarRating"] != null ? double.parse(json["fiveStarRating"].toString()) : 0,
      );

  Map<String, dynamic> toMap() => {
        "oneStarRating": oneStarRating ?? 0,
        "twoStarRating": twoStarRating ?? 0,
        "threeStarRating": threeStarRating ?? 0,
        "fourStarRating": fourStarRating ?? 0,
        "fiveStarRating": fiveStarRating ?? 0,
      };
}

class SimiliarConsultant {
  String? profileImage;
  String? name;
  int? charge;
  String? primarySkill;
  int? id;

  SimiliarConsultant({
    this.profileImage,
    this.name,
    this.charge,
    this.primarySkill,
    this.id,
  });

  factory SimiliarConsultant.fromJson(Map<String, dynamic> json) => SimiliarConsultant(
        profileImage: json["profileImage"] ?? "",
        name: json["name"] ?? "",
        charge: json["charge"] ?? 0,
        primarySkill: json["primarySkill"] ?? "",
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "profileImage": profileImage,
        "name": name,
        "charge": charge,
        "primarySkill": primarySkill,
        "id": id,
      };
}
