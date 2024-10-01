import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:BharatiyAstro/controllers/astromallController.dart';
import 'package:BharatiyAstro/controllers/razorPayController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/model/phonePayModel.dart';
import 'package:BharatiyAstro/views/CheckPayment.dart';
import 'package:BharatiyAstro/views/phonePayPaymentScreen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:quantupi/quantupi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:upi_india/upi_india.dart';
import '../controllers/loginController.dart';
import '../controllers/phonepayController.dart';
import '../controllers/walletController.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import '../model/paymentStatus.dart';
import '../widget/commonAppbar.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';

class PaymentInformationScreen extends StatefulWidget {
  final double amount;
  final int? flag;
  final double?extraAmount;
  const PaymentInformationScreen({Key? key, required this.amount, this.flag, this.extraAmount})
      : super(key: key);

  @override
  _PaymentInformationScreenState createState() =>
      _PaymentInformationScreenState();
}

class _PaymentInformationScreenState extends State<PaymentInformationScreen> {
  final WalletController walletController = Get.find<WalletController>();
  RazorPayController razorPay = Get.find<RazorPayController>();
  SplashController splashController = Get.find<SplashController>();
  AstromallController astromallController = Get.find<AstromallController>();
  // Future<UpiResponse>? transaction;
  PhonePayController phonepayController =
      Get.put<PhonePayController>(PhonePayController());
  LoginController loginController = Get.put(LoginController());

  String truncateString(String input) {
    if (input.length <= 15) {
      return input;
    } else {
      return input.substring(0, 15) + "...";
    }
  }

//payment sdk setting

  String PRO_environment = "PRODUCTION";
  String UAT_environment = "UAT";
  String UAT_SIM_enviroment = "UAT_SIM";

  // String PRO_appId = "66380dc99d264f269f705ae1507c5885";
  String PRO_appId = "422bbc5a9fa54795aa3349df0dd04427";
  // String PRO_appId = "92813af75cee43279e4d278f6700035f";

  String Production_Package_Name = "com.phonepe.app";
  String UAT_Package_Name = "com.phonepe.app.preprod";
  String UAT_SIM_Package_Name = "com.phonepe.simulator";

  String transactionId = DateTime.now().millisecondsSinceEpoch.toString();

  // String merchantId = "M1HWPNY5AGA4";
  String merchantId = "M1HWPNY5AGA4";
  // String merchantId = "PGTESTPAYUAT";
  String saltKey = "02c275ae-a76a-4c39-b668-418874698d21";
  // String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  // String saltKey = "02c275ae-a76a-4c39-b668-418874698d21";
  bool enableLogging = true;
  String checksum = "";

  String saltIndex = "1";

  String callbackUrl = "https://bharatiyastro.com/api/phonepeResponse";

  String body = "";
  String apiEndPoint = "/pg/v1/pay";

  Object? result;
  String base64Body = "";
  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": phonepayController.generateMerchandiseId(),
      "merchantUserId": phonepayController.generateMerchanduserIdId(),
      "amount": (widget.amount +
              widget.amount *
                  double.parse(global
                      .getSystemFlagValue(global.systemFlagNameList.gst)) /
                  100) *
          100,
      "mobileNumber": 7667340560,
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';

    log('checksum is here $checksum');
    log('body is here $base64Body');
    return base64Body;
  }

  getsignatureid() async {
    String id = await PhonePePaymentSdk.getPackageSignatureForAndroid() ?? "";
    log('App signature key         =========> $id');
    // Get.snackbar('$id', 'This is a GetX Snackbar!',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.blue,
    //     colorText: Colors.white,
    //     duration: Duration(seconds: 3),
    //     margin: EdgeInsets.all(20),
    //     borderRadius: 10,
    //     isDismissible: true,
    //     forwardAnimationCurve: Curves.easeOutBack,
    //     reverseAnimationCurve: Curves.easeInBack,
    //     animationDuration: Duration(milliseconds: 500),
    //     backgroundGradient: LinearGradient(
    //       colors: [Colors.blue, Colors.green],
    //     ));
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(
            PRO_environment, PRO_appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              }),
              log('phone pay initialted    $val')
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  startPgTransaction() async {
    body = getChecksum().toString();
    var response = PhonePePaymentSdk.startTransaction(
        body, callbackUrl, checksum, "$Production_Package_Name");
    response.then((val) async {
      if (val != null) {
        log('here is result $val');

        String status = val['status'].toString();
        // String error = val['error'].toString();

        if (status == 'SUCCESS') {
          result = "Flow complete - status : SUCCESS";
          // Get.to(() => CheckPayment());
          log("after transaction" + val.toString());
          await checkStatus();
        } else {
          // result = "Flow complete - status : $status and error $error";
        }
      } else {
        result = "Flow Incomplete";
      }
    }).catchError((error) {
      // log('here is error for phonpay    $error');
      print(error);
      // handleError(error);
      // return <dynamic>{};
    });
    // try {

    // } catch (error) {
    //   handleError(error);
    // }
  }

  //print("ygh");

  checkStatus() async {
    log("transactionId:" + transactionId.toString());
    log("merchandTransectionId:" +
        phonepayController.merchandTransectionId.toString());
    log("saltKey:" + saltKey.toString());
    String url =
        "https://api.phonepe.com/apis/hermes/pg/v1/status/$merchantId/${phonepayController.merchandTransectionId}";
    // "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/${phonepayController.merchandTransectionId}"; //Test

    String concatString =
        "/pg/v1/status/$merchantId/${phonepayController.merchandTransectionId}$saltKey";

    var bytes = utf8.encode(concatString);
    var digest = sha256.convert(bytes).toString();

    //  combine with salt index
    String xVerify = "$digest###$saltIndex";

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-MERCHANT-ID": merchantId,
      "X-VERIFY": xVerify,
    };

    log("APIs Url:" + Uri.parse(url).toString());
    log("headers:" + headers.toString());

    await http.get(Uri.parse(url), headers: headers).then((value) {
      final res = jsonDecode(value.body);
      phonepayController.paymentSuccees.value = false;
      log("After Phonepe APIs :" + res.toString());
      if (res["code"] == "PAYMENT_SUCCESS" &&
          res['data']['responseCode'] == "SUCCESS") {
        phonepayController.paymentSuccees.value = true;

        phonepayController.statusResponse = PaymentStatusModel.fromJson(res);
        // phonepayController.update();
        phonepayController.statusCode.value =
            phonepayController.statusResponse.data?.state ?? "";
        log('${phonepayController.statusResponse.data?.state}');
        Get.to(() => CheckPayment(
              amount: widget.amount,
            ));
        log(res['data']['responseCode']);
        // global.showToast(message: '', textColor: textColor, bgColor: bgColor)
      } else {
        // Fluttertoast.showToast(msg:" Something went wrong");
        phonepayController.paymentSuccees.value = true;
        phonepayController.statusCode.value =
            phonepayController.statusResponse.data?.state ?? "";
        phonepayController.statusResponse = PaymentStatusModel.fromJson(res);
        phonepayController.update();
        Get.to(() => CheckPayment(
              amount: widget.amount,
            ));
        log(res['data']);
      }
    });
  }

  void handleError(error) {
    setState(() {
      result = {"error": error};
    });
  }

  // final UpiIndia _upiIndia = UpiIndia();

  TextStyle header = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  // Instance of razor pay
  final Razorpay _razorpay = Razorpay();
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("${response.paymentId}");
    // razorPay.handlePaymentSuccess(response);
// Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("${response.message}");
// Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
// Do something when an external wallet is selected
    log("${response.walletName}");
  }

  initiateRazorPay() {
// To handle different event with previous functions
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  double amount = 0.0;
  razorpayOption(double amount) {
    return {
      'key': 'rzp_test_1oRIOZTx8DNxQ2', //Razor pay API Key
      'amount': amount,
      //in the smallest currency sub-unit.
      'name': 'Company Name.',
      // 'order_id': orderId, // Generate order_id using Orders API
      'description':
          'Description for order', //Order Description to be shown in razor pay page
      'timeout': 120, // in seconds
      'prefill': {
        'contact': '9123456789',
        'email': 'flutterwings304@gmail.com'
      } //contact number and email id of user
    };
  }

  @override
  void initState() {
    // _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
    //   // setState(() {
    //   //   apps = value;
    //   // });
    //   phonepayController.apps = value;
    //   phonepayController.update();
    // }).catchError((e) {
    //   phonepayController.apps = [];
    //   phonepayController.update();
    // });

    initiateRazorPay();
    super.initState();
    phonepeInit();
    // getsignatureid();
    body = getChecksum().toString();
    // phonepayController.paymentMethod.value = "razorpay";
  }

  // Future<UpiResponse> initiateTransaction(
  //     UpiApp app, String transactionRefId, double amount) async {
  //   return _upiIndia.startTransaction(
  //       app: app,
  //       receiverUpiId: "thakurbipul353-2@okhdfcbank",
  //       receiverName: 'Bipul',
  //       transactionRefId: '$transactionRefId',
  //       transactionNote: '',
  //       amount: amount,
  //       merchantId: '');
  // }

  // Future<UpiResponse> initiateTransaction(UpiApp app) async {
  //   return _upiIndia.startTransaction(
  //       app: app,
  //       receiverUpiId: "7667340560@ybl",
  //       receiverName: 'Bipul',
  //       transactionRefId: 'Testing Upi India Plugin',
  //       transactionNote: 'Not actual. Just an example.',
  //       amount: 1.00,
  //       merchantId: '');
  // }

  // Widget displayUpiApps() {
  //   return GetBuilder<PhonePayController>(
  //     builder: (phonepayController) {
  //       if (phonepayController.apps == null) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (phonepayController.apps!.isEmpty) {
  //         return Center(
  //           child: Text(
  //             "No apps found to handle transaction.",
  //             style: header,
  //           ),
  //         );
  //       } else {
  //         return SizedBox(
  //           height: 80,
  //           width: Get.width * 0.90,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: phonepayController.apps!.length,
  //             itemBuilder: (context, index) {
  //               return InkWell(
  //                 onTap: () {
  //                   phonepayController.appIndex = index;
  //                   phonepayController.isPayusingApp = false;
  //                   phonepayController.update();
  //                 },
  //                 child: Container(
  //                   height: 50,
  //                   width: 90,
  //                   margin: EdgeInsets.only(left: 8),
  //                   decoration: BoxDecoration(
  //                       // shape: BoxShape.circle,
  //                       borderRadius: BorderRadius.circular(12),
  //                       color: phonepayController.appIndex == index
  //                           ? Get.theme.primaryColor
  //                           : Colors.white,
  //                       boxShadow: [
  //                         BoxShadow(
  //                             color: Colors.black.withOpacity(0.50),
  //                             offset: Offset(2, 4),
  //                             spreadRadius: 0,
  //                             blurRadius: 8)
  //                       ]),
  //                   child: Image.memory(phonepayController.apps![index].icon),
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // String _upiErrorHandler(error) {
  //   switch (error) {
  //     case UpiIndiaAppNotInstalledException:
  //       return 'Requested app not installed on device';
  //     case UpiIndiaUserCancelledException:
  //       return 'You cancelled the transaction';
  //     case UpiIndiaNullResponseException:
  //       return 'Requested app didn\'t return any response';
  //     case UpiIndiaInvalidParametersException:
  //       return 'Requested app cannot handle the transaction';
  //     default:
  //       return 'An Unknown error has occurred';
  //   }
  // }

  // void _checkTxnStatus(String status, amount, transectionId, refid) {
  //   switch (status) {
  //     case UpiPaymentStatus.SUCCESS:
  //       print('Transaction Successful');
  //       razorPay.AddmoneyToWallet(amount, refid ?? "", transectionId ?? "", status ?? "");
  //       break;
  //     case UpiPaymentStatus.SUBMITTED:
  //       print('Transaction Submitted');
  //       break;
  //     case UpiPaymentStatus.FAILURE:
  //       print('Transaction Failed');
  //       break;
  //     default:
  //       print('Received an Unknown transaction status');
  //   }
  // }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Payment Information',
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<WalletController>(builder: (c) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Details',
                                style: Get.textTheme.subtitle1!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(
                              height: 5,
                            ),
                            widget.flag == 1
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${astromallController.astroProductbyId[0].name}'),
                                      Text(
                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${double.parse(astromallController.astroProductbyId[0].amount.toString())}'),
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Amount'),
                                Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.amount}'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'GST ${global.getSystemFlagValue(global.systemFlagNameList.gst)}%'),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${widget.amount * double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) / 100}'),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Payable Amount',
                                    style: Get.textTheme.subtitle1!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${(widget.amount + widget.amount * double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) / 100).toStringAsFixed(2)}',
                                    style: Get.textTheme.subtitle1!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                              SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Extra Amount',
                                    style: Get.textTheme.subtitle1!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.extraAmount?.toStringAsFixed(2)}',
                                    style: Get.textTheme.subtitle1!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('Payment Mode',
                        style: Get.textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            phonepayController.paymentMethod.value = "razorpay";
                          },
                          child: Obx(
                            () => Container(
                              height: 100,
                              width: 100,
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 0),
                                      blurRadius: 5,
                                      spreadRadius: 3)
                                ],
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    phonepayController.paymentMethod.value ==
                                            "razorpay"
                                        ? Border.all(
                                            color: Colors.orange,
                                            width: 2.0,
                                          )
                                        : Border.all(color: Colors.transparent),
                              ),
                              child: Image.asset('assets/images/razorpay.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: () {
                            phonepayController.paymentMethod.value = "phonepay";
                          },
                          child: Obx(
                            () => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 0),
                                      blurRadius: 5,
                                      spreadRadius: 3)
                                ],
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    phonepayController.paymentMethod.value ==
                                            "phonepay"
                                        ? Border.all(
                                            color: Colors.orange,
                                            width: 2.0,
                                          )
                                        : Border.all(color: Colors.transparent),
                              ),
                              child: Image.asset(
                                fit: BoxFit.cover,
                                'assets/images/phonepe.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]);
          }),
        ),
      ),
      bottomSheet: SizedBox(
        height: 60,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () async {
              razorPay.addWalletAmount = widget.amount+(widget.extraAmount)!.toDouble();
              razorPay.update();
              // phonepayController.transectionId.value =
              //     phonepayController.generateMerchandiseId();
              // if (phonepayController.isPayusingApp) {
              // phonepayController.base64Value.value = phonepayController
              //         .converjsontobase64(phonepayController.createjson(
              //             'M1OOMQHEBGSA',
              //             '${phonepayController.transectionId.value}',
              //             100,
              //             // (widget.amount +
              //             //         widget.amount *
              //             //             double.parse(global.getSystemFlagValue(
              //             //                 global.systemFlagNameList.gst)) /
              //             //             100) *
              //             //     100,
              //             '${global.currentUserId}',
              //             'https://bharatiyastro.com/payloader',
              //             'REDIRECT',
              //             //  '/CheckPayment',
              //             '${loginController.loginModel.contactNo ?? 1234567890}')) ??
              //     "";

              // phonepayController.sh256value.value =
              //     await phonepayController.sha256New(
              //   "b63aa755-f5cb-4656-8b1a-707a87b68fb5",
              //   phonepayController.base64Value.value,
              // );

              // await phonepayController.makePayment(
              //   loginController.loginModel.contactNo ?? "",
              //   "${(widget.amount + widget.amount * double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) / 100) * 100}",
              // );

              // Get.to(() => PhonePayPaymentScreen());

              // initiateQuantTransaction();
              //  getsignatureid();
              if (phonepayController.paymentMethod.value != "") {
                if (phonepayController.paymentMethod.value == "phonepay") {
                  startPgTransaction();
                } else if (phonepayController.paymentMethod.value ==
                    "razorpay") {
                  razorPay.openCheckout((widget.amount +
                      widget.amount *
                          double.parse(global.getSystemFlagValue(
                              global.systemFlagNameList.gst)) /
                          100));
                  // _razorpay.open(razorpayOption(100.0));
                }
              } else {
                Get.snackbar(
                  'Payment Method not Found', 'Please choose payment Method',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                  duration: Duration(seconds: 3),
                  margin: EdgeInsets.all(20),
                  borderRadius: 10,
                  isDismissible: true,
                  forwardAnimationCurve: Curves.easeOutBack,
                  reverseAnimationCurve: Curves.easeInBack,
                  animationDuration: Duration(milliseconds: 500),
                  // backgroundGradient: LinearGradient(
                  //   colors: [Colors.blue, Colors.green],
                  // )
                );
              }

              // } else {
              //   // setState(() {
              //   //   transaction = initiateTransaction(
              //   //       phonepayController.apps![phonepayController.appIndex],
              //   //       phonepayController.transectionId.value,
              //   //       1.0);
              //   // });
              // }
              // Check if the URL can be launched.

              // setState(() {
              //   amount = (widget.amount +
              //           widget.amount *
              //               double.parse(global.getSystemFlagValue(
              //                   global.systemFlagNameList.gst)) /
              //               100) *
              //       100;
              // });
              // _razorpay.open({
              //     'key': 'rzp_test_1oRIOZTx8DNxQ2',
              //       'amount': 100,
              //       'name': 'BharatiyAstro',
              //       'description': 'Fin',
              //       'retry': {'enabled': true, 'max_count': 1},
              //       'send_sms_hash': true,
              //       'prefill': {'contact': '7667340560', 'email': 'thakurbipul353@gmail.com'},
              //       'external': {
              //         'wallets': ['paytm']
              //       } //contact number and email id of user
              // });
            },
            child: Text('Proceed to Pay',
                style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
              backgroundColor:
                  MaterialStateProperty.all(Get.theme.primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
