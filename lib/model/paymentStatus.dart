class PaymentStatusModel {
  bool? success;
  String? code;
  String? message;
  Data? data;

  PaymentStatusModel({this.success, this.code, this.message, this.data});

  PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? merchantId;
  String? merchantTransactionId;
  String? transactionId;
  dynamic amount;
  String? state;
  String? responseCode;
  PaymentInstrument? paymentInstrument;

  Data(
      {this.merchantId,
      this.merchantTransactionId,
      this.transactionId,
      this.amount,
      this.state,
      this.responseCode,
      this.paymentInstrument});

  Data.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantTransactionId = json['merchantTransactionId'];
    transactionId = json['transactionId'];
    amount = json['amount'];
    state = json['state'];
    responseCode = json['responseCode'];
    paymentInstrument = json['paymentInstrument'] != null
        ? new PaymentInstrument.fromJson(json['paymentInstrument'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merchantTransactionId'] = this.merchantTransactionId;
    data['transactionId'] = this.transactionId;
    data['amount'] = this.amount;
    data['state'] = this.state;
    data['responseCode'] = this.responseCode;
    if (this.paymentInstrument != null) {
      data['paymentInstrument'] = this.paymentInstrument!.toJson();
    }
    return data;
  }
}

class PaymentInstrument {
  String? type;
  dynamic? utr;
  String? upiTransactionId;
  String? cardNetwork;
  String? accountType;

  PaymentInstrument(
      {this.type,
      this.utr,
      this.upiTransactionId,
      this.cardNetwork,
      this.accountType});

  PaymentInstrument.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    utr = json['utr'];
    upiTransactionId = json['upiTransactionId'];
    cardNetwork = json['cardNetwork'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['utr'] = this.utr;
    data['upiTransactionId'] = this.upiTransactionId;
    data['cardNetwork'] = this.cardNetwork;
    data['accountType'] = this.accountType;
    return data;
  }
}
