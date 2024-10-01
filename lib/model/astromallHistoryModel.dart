class AstroMallHistoryModel {
  AstroMallHistoryModel(
      {this.id,
      this.userId,
      this.astrologerId,
      this.city,
      this.country,
      this.couponCode,
      this.description,
      this.flatNo,
      this.gstPercent,
      this.landmark,
      this.locality,
      this.orderAddressId,
      this.orderAddressName,
      this.orderStatus,
      this.orderType,
      this.payableAmount,
      this.paymentMethod,
      this.phoneNumber,
      this.pincode,
      this.productAmount,
      this.productCategory,
      this.productCategoryId,
      this.productId,
      this.productImage,
      this.state,
      this.totalMin,
      this.totalPayable,
      this.productName,
      this.createdAt,
      this.trakingno,
      this.couriername,
      this.walletBalanceDeducted});

  int? id;
  int? userId;
  String? orderType;
  int? productCategoryId;
  int? productId;
  int? orderAddressId;
  String? payableAmount;
  String? walletBalanceDeducted;
  String? gstPercent;
  String? totalPayable;
  String? couponCode;
  String? paymentMethod;
  String? orderStatus;
  String? totalMin;
  String? productCategory;
  int? astrologerId;
  String? productImage;
  double? productAmount;
  String? description;
  String? orderAddressName;
  String? phoneNumber;
  String? flatNo;
  String? locality;
  String? landmark;
  String? city;
  String? state;
  String? country;
  int? pincode;
  String? productName;
  String?trakingno;
  String?couriername;
  DateTime? createdAt;

  AstroMallHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"] ?? 0;
    orderType = json["orderType"] ?? "";
    astrologerId = json["astrologerId"] ?? 0;
    productCategoryId = json["productCategoryId"] ?? 0;
    productId = json["productId"] ?? 0;
    orderAddressId = json["orderAddressId"] ?? 0;
    payableAmount = json["payableAmount"] ?? "";
    walletBalanceDeducted = json["walletBalanceDeducted"] ?? "";
    gstPercent = json["gstPercent"] ?? "";
    totalPayable = json["totalPayable"] ?? "";
    couponCode = json["couponCode"] ?? "";
    paymentMethod = json["paymentMethod"] ?? "";
    orderStatus = json["orderStatus"] ?? "Pending";
    totalMin = json["totalMin"] ?? "";
    productCategory = json["productCategory"] ?? "";
    productImage = json["productImage"] ?? "";
    productAmount = json['productAmount'] != null ? double.parse(json['productAmount'].toString()) : 0.0;
    description = json["description"] ?? "";
    orderAddressName = json["orderAddressName"] ?? "";
    phoneNumber = json["phoneNumber"] ?? "";
    flatNo = json["flatNo"] ?? "";
    locality = json["locality"] ?? "";
    landmark = json["landmark"] ?? "";
    city = json["city"] ?? "";
    state = json["state"] ?? "";
    productName = json["productName"] ?? "";
    country = json["country"] ?? "";
    pincode = json["pincode"] ?? 0;
    trakingno= json["trakingno"]??"";
    couriername = json["couriername"]??"";
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
  }
}
