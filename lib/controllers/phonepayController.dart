import 'dart:convert';
import 'dart:math';
import 'package:BharatiyAstro/model/paymentStatus.dart';
import 'package:BharatiyAstro/utils/global.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:BharatiyAstro/model/phonePayModel.dart';
// import 'package:upi_india/upi_india.dart';

class PhonePayController extends GetxController {
// using sdk

  //using with out sdk
  RxString base64Value = "".obs;
  RxString sh256value = "".obs;
  RxString transectionId = "".obs;
  RxString statusSh256Value = "".obs;
  RxBool paymentSuccees = false.obs;
  RxBool isPageLoaded = true.obs;
  RxInt progress = 0.obs;
  RxString paymentMethod = "razorpay".obs;
  RxString statusCode = "".obs;
  // List<UpiApp>? apps;
  // UpiResponse? upiResponse;
  // Future<UpiResponse>? transaction;
  int appIndex = -1;
  bool isPayusingApp = false;
  String merchandTransectionId = "";
  PhonePayModel phonePayModel = PhonePayModel().obs();
  PaymentStatusModel statusResponse = PaymentStatusModel().obs();

  String? converjsontobase64(dynamic json) {
    // convert json to base64 encoded
    String jsonString = jsonEncode(json);
    String base64String = base64.encode(utf8.encode(jsonString));
    return base64String;
  }

  Future<String> sha256New(
    String saltkey,
    String base,
  ) async {
    // generate sha256 for base64 + /pg/v1/pay + saltkey
    String data = base + "/pg/v1/pay" + saltkey;
    List<int> bytes = utf8.encode(data);
    Digest digest = await sha256.convert(bytes);
    String hash = digest.toString();
    return hash + "###1";
  }

  String generateMerchandiseId() {
    // Combine a timestamp with a random number to create a simple merchandise ID
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random =
        Random().nextInt(999999);
        merchandTransectionId =  'ASBHRT$timestamp$random';
        update();// Adjust the range based on your requirements
    return merchandTransectionId;
  }

  String generateMerchanduserIdId() {
    // Combine a timestamp with a random number to create a simple merchandise ID
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random =
        Random().nextInt(999999); // Adjust the range based on your requirements
    return 'Astr$timestamp$random';
  }

  dynamic createjson(
    String merchantId,
    String merchantTransactionId,
    double amount,
    String merchantUserId,
    String redirectUrl,
    String redirectMode,

    // String callbackUrl,
    String? mobileNumber,
  ) {
    // create json from given argument and note that paymentInstrument have type as enum
    return {
      "merchantId": merchantId,
      "merchantTransactionId": merchantTransactionId,
      "amount": amount,
      "merchantUserId": merchantUserId,
      "redirectUrl": redirectUrl,
      "redirectMode": redirectMode,
      // "callbackUrl": callbackUrl,
      "mobileNumber": mobileNumber,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
  }

//   makePayment(String xVerify, String base64) async {
//     final ffApiRequestBody = '''
// {
//   "request": "${base64}"
// }''';
//     final response = await http.post(
//       Uri.parse('https://api.phonepe.com/apis/hermes/pg/v1/pay'),
//       body: ffApiRequestBody,
//       headers: {
//         'Content-Type': 'application/json',
//         'X-VERIFY': '${xVerify}',
//       },
//     );
//     print("${response.body}");
//     if (response.statusCode == 200) {
//       phonePayModel = PhonePayModel.fromJson(json.decode(response.body));
//     } else {
//       Get.snackbar('PayMent Failed', '${response.statusCode}');
//     }
//   }

  makePayment(String mobileNumber,String amount) async {
  // should be dynamic
      String  response   =  await apiHelper.makePayment(mobileNumber, amount);
        phonePayModel = PhonePayModel.fromJson(json.decode(response));
  
    print("=========================>$response");
    // if (response == 200) {
  
    // } else {
    //   Get.snackbar('PayMent Failed', '${response.statusCode}');
    // }
  }

  Future<String> statusSHA(
    String merchantid,
    String transactionId,
    String saltkey,
  ) async {
    // genrate SHA256("/v3/transaction/{merchantId}/{transactionId}/status" +saltKey)
    String message =
        "/v3/transaction/$merchantid/$transactionId/status$saltkey";
    var bytes = utf8.encode(message);
    var digest = sha256.convert(bytes);
    return digest.toString() + "###1";
  }


}
