class OrderCreateModel {
  OrderCreateModel({
    this.id,
    this.productCategoryId,
    this.productId,
    this.orderAddressId,
    this.payableAmount,
    this.gstPercent,
    this.paymentMethod,
    this.totalPayable,
  });

  int? id;
  int? productCategoryId;
  int? productId;
  int? orderAddressId;
  double? payableAmount;
  int? gstPercent;
  String? paymentMethod;
  double? totalPayable;

  OrderCreateModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    productCategoryId = json["productCategoryId"];
    productId = json["productId"];
    orderAddressId = json["orderAddressId"];
    payableAmount = (json["payableAmount"] != null && json["payableAmount"] != '') ? double.parse(json["payableAmount"].toString()) : 0;
    paymentMethod = json["paymentMethod"] ?? "";
    totalPayable = (json["totalPayable"] != null && json["totalPayable"] != '') ? double.parse(json["totalPayable"].toString()) : 0;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "productCategoryId": productCategoryId,
        "productId": productId,
        "orderAddressId": orderAddressId,
        "payableAmount": payableAmount,
        "paymentMethod": paymentMethod,
        "totalPayable": totalPayable,
      };
}
