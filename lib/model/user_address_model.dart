class UserAddressModel {
  UserAddressModel({
    this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.phoneNumber2,
    required this.flatNo,
    required this.locality,
    this.landmark,
    required this.city,
    this.state,
    required this.country,
    required this.pincode,
    this.countryCode,
    this.alternateCountryCode,
  });

  int? id;
  int userId;
  String name;
  String phoneNumber;
  String? phoneNumber2;
  String flatNo;
  String locality;
  dynamic landmark;
  String city;
  String? state;
  String country;
  String? countryCode;
  String? alternateCountryCode;
  int pincode;

  factory UserAddressModel.fromJson(Map<String, dynamic> json) => UserAddressModel(
        id: json["id"],
        userId: json["userId"],
        name: json["name"] ?? "",
        phoneNumber: json["phoneNumber"],
        phoneNumber2: json["phoneNumber2"] ?? "",
        flatNo: json["flatNo"] ?? "",
        locality: json["locality"] ?? "",
        landmark: json["landmark"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        country: json["country"] ?? "",
        pincode: json["pincode"] ?? "",
        countryCode: json["countryCode"] ?? "IN",
        alternateCountryCode: json["alternateCountryCode"] ?? "IN",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "phoneNumber": phoneNumber,
        "phoneNumber2": phoneNumber2,
        "flatNo": flatNo,
        "locality": locality,
        "landmark": landmark,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "countryCode": countryCode,
        "alternateCountryCode": alternateCountryCode,
      };
}
