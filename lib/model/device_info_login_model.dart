class DeviceInfoLoginModel {
  DeviceInfoLoginModel({
    this.appId,
    this.appVersion,
    this.deviceId,
    this.deviceLocation,
    this.deviceManufacturer,
    this.deviceModel,
    this.fcmToken,
  });

  String? appId;
  String? deviceId;
  String? fcmToken;
  String? deviceLocation;
  String? deviceManufacturer;
  String? deviceModel;
  String? appVersion;

  factory DeviceInfoLoginModel.fromJson(Map<String, dynamic> json) => DeviceInfoLoginModel();

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "deviceId": deviceId,
        "fcmToken": fcmToken,
        "deviceLocation": deviceLocation ?? "",
        "deviceManufacturer": deviceManufacturer,
        "deviceModel": deviceModel,
        "appVersion": appVersion,
      };
}
