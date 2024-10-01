import 'package:BharatiyAstro/model/systemFlagModel.dart';

class CurrentUserModel {
  CurrentUserModel({
    this.id,
    this.name,
    this.contactNo,
    this.email,
    this.birthDate,
    this.birthTime,
    this.profile,
    this.birthPlace,
    this.addressLine1,
    this.pincode,
    this.gender,
    this.location,
    this.addressLine2,
    this.walletAmount,
    this.latitude,
    this.longitude,
    this.systemFlagList,
    this.sessionToken,
    this.countryCode,
  });
  int? id;
  String? name;
  String? contactNo;
  String? email;
  DateTime? birthDate;
  String? birthTime;
  String? profile;
  String? birthPlace;
  String? addressLine1;
  String? addressLine2;
  int? pincode;
  String? gender;
  String? location;
  double? walletAmount;
  double? latitude;
  double? longitude;
  List<SystemFlag>? systemFlagList;
  String? sessionToken;
  String? countryCode;

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) => CurrentUserModel(
        id: json["id"],
        name: json["name"] ?? "User",
        contactNo: json["contactNo"],
        email: json["email"] ?? "",
        birthDate: DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String()), //?? DateTime.now(),
        birthTime: json["birthTime"] ?? "",
        profile: json["profile"] ?? "",
        birthPlace: json["birthPlace"] ?? "",
        addressLine1: json["addressLine1"] ?? "",
        addressLine2: json["addressLine2"] ?? "",
        pincode: json["pincode"] ?? null,
        gender: json["gender"] ?? "Male",
        location: json["location"] ?? "",
        sessionToken: json["sessionToken"] ?? "",
        walletAmount: (json["totalWalletAmount"] != null && json["totalWalletAmount"] != '') ? double.parse(json["totalWalletAmount"].toString()) : 0,
        latitude: (json["latitude"] != null && json["latitude"] != '') ? double.parse(json["latitude"].toString()) : 0,
        longitude: (json["longitude"] != null && json["longitude"] != '') ? double.parse(json["longitude"].toString()) : 0,
        systemFlagList: json['systemFlag'] != null ? List<SystemFlag>.from(json['systemFlag'].map((p) => SystemFlag.fromJson(p))) : [],
        countryCode: json["countryCode"] ?? "+91",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name ?? "",
        "contactNo": contactNo,
        "email": email ?? "",
        "birthDate": birthDate!.toIso8601String(),
        "birthTime": birthTime ?? "",
        "profile": profile ?? "",
        "birthPlace": birthPlace ?? "",
        "addressLine1": addressLine1 ?? "",
        "addressLine2": addressLine2 ?? "",
        "pincode": pincode,
        "gender": gender,
        "location": location,
        "totalWalletAmount": walletAmount,
        "systemFlag": systemFlagList,
        "sessionToken": sessionToken,
        "latitude": latitude,
        "longitude": longitude,
        "countryCode": countryCode
      };
}
