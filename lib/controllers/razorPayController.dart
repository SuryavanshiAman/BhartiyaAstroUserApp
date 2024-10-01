import 'dart:developer';

import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/main.dart';
import 'package:BharatiyAstro/model/card_model.dart';
import 'package:BharatiyAstro/utils/global.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:BharatiyAstro/views/stripeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:http/http.dart' as http;

class RazorPayController extends GetxController {
  SplashController splashController = Get.find<SplashController>();
  APIHelper apiHelper = APIHelper();
  Razorpay? _razorpay;
  late double totalAmount;
  late double addWalletAmount;
  String? number;
  int? _month;
  int? _year;
  // ignore: unused_field
  int _walletCount = 0;
  final _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  TextEditingController _cCardNumber = new TextEditingController();
  TextEditingController _cExpiry = new TextEditingController();
  TextEditingController _cCvv = new TextEditingController();
  TextEditingController _cName = new TextEditingController();

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {
    try {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    } catch (e) {
      print("Exception - event_payment_gateways_screen.dart - _init():" +
          e.toString());
    }
  }

  Future AddmoneyToWallet(double addWalletAmount, String paymentId,
      String orderId, String status) async {
    print("Paymant success");

    try {
      //   //phonePeResponce
      // global.showOnlyLoaderDialog(Get.context);
      double tax = addWalletAmount *
          double.parse(
              global.getSystemFlagValue(global.systemFlagNameList.gst)) /
          100;
      await apiHelper
          .addAmountInWallet(
              paymentMode: 'PhonePay',
              amount: addWalletAmount,
              orderId: orderId,
              paymentId: paymentId,
              tax: tax,
              status: 'Success')
          .then((result) {
        // global.hideLoader();
        splashController.getCurrentUserData();
        splashController.update();
        // hideLoader();
        //   global.showToast(
        //   message: 'Payment transaction sucessfull',
        //   textColor: global.textColor,
        //   bgColor: global.toastBackGoundColor,
        // );
        // bottomController.setIndex(1, 0);
        // Get.to(() => BottomNavigationBarScreen(index: 0));

        // }
      });
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart - _handlePaymentSuccess" +
          e.toString());
    }
  }

  Future _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      print("${response.orderId} ${response.paymentId} ${response.signature}");

      double tax =addWalletAmount  *
          double.parse(
              global.getSystemFlagValue(global.systemFlagNameList.gst)) /
          100;
      // log("total amount=========================================>${ double.parse(
      //         global.getSystemFlagValue(global.systemFlagNameList.gst)) /
      //     100}");
          // log("total tax=========================================>${ tax}");
      global.showOnlyLoaderDialog(Get.context);
      await apiHelper
          .addAmountInWallet(
              paymentMode: 'Razorpay',
              amount: addWalletAmount,
              orderId: response.orderId!,
              paymentId: response.paymentId!,
              tax: tax,
              status: 'Success'
              )
          .then((result) {
        global.hideLoader();
        splashController.getCurrentUserData();
        splashController.update();
        hideLoader();
        bottomController.setIndex(1, 0);
        Get.to(() => BottomNavigationBarScreen(index: 0));
        global.showToast(
          message: 'Payment transaction sucessfull',
          textColor: global.textColor,
          bgColor: global.toastBackGoundColor,
        );

        // }
      });
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart - _handlePaymentSuccess" +
          e.toString());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    // print("${response.} ${response.paymentId} ${response.signature}");
    try {
      await apiHelper.addAmountInWallet(
          paymentMode: 'Razorpay',
          amount: addWalletAmount,
          paymentId: '',
          orderId: '',
          tax: 0.0,
          status: 'failed');

      tryAgainDialog(openCheckout);
      global.showToast(
          message: 'Payment Failed. Amount not added into your wallet.',
          bgColor: global.toastBackGoundColor,
          textColor: global.textColor);
    } catch (e) {
      print("Exception - paymentGatewaysScreen.dart -  _handlePaymentError" +
          e.toString());
    }
  }

  void openCheckout(double amount) async {
    totalAmount = amount;
    var options;

    Map<String, String> _notes = {
      "userId": "${global.currentUserId}",
      "userName": "${splashController.currentUser!.name}",
      "userEmail": "${splashController.currentUser!.email}",
      "userContact": "${splashController.currentUser!.contactNo}",
      // "eventId": event.id,
      // "eventNumber": event.eventNo,
    };
    showOnlyLoaderDialog(Get.context);
    String _razorPayOrderId = await apiHelper.razorpayCreateWallet(
        // totalAmount: (100).toString(),
        totalAmount: (amount.toInt() * 100).toString(),
        notes: _notes,
        razorpayKey:
            global.getSystemFlagValue(global.systemFlagNameList.razorPayKeyId),
        razorpaySecret: global
            .getSystemFlagValue(global.systemFlagNameList.razorPayKeySecret));
    hideLoader();
    // ignore: unnecessary_null_comparison
    if (_razorPayOrderId != null && _razorPayOrderId.isNotEmpty) {
      options = {
        'key':
            global.getSystemFlagValue(global.systemFlagNameList.razorPayKeyId),
        'order_id': _razorPayOrderId,
        'amount': 100,
        'name': splashController.currentUser!.name,
        'prefill': {
          'contact': splashController.currentUser!.contactNo,
          'email': splashController.currentUser!.email
        },
        'currency': "INR",
        "notes": _notes
      };
      _razorpay!.open(options);
    } else {
      global.showToast(
          message: 'Failed to transction',
          bgColor: global.toastBackGoundColor,
          textColor: global.textColor);
    }
    // try {

    // } catch (e) {
    //   debugPrint('Error: ${e.toString()}');
    // }
  }

  tryAgainDialog(Function onClickAction) {
    try {
      showCupertinoDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'Transaction Failed',
                ),
                content: Text(
                  'Please Try Again',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Try Again'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      global.showOnlyLoaderDialog(context);
                      onClickAction();
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print(
          "Exception - event_payment_gateways_screen.dart - _tryAgainDialog(): " +
              e.toString());
    }
  }

  //Strip implement

  cardDialog({int? paymentCallId, double? amount}) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Theme(
                  data: ThemeData(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    elevation: 0.5,
                    scrollable: true,
                    title: Text(
                      'Card Details',
                      style: TextStyle(),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text('Cancel',
                                style:
                                    TextStyle(color: Get.theme.primaryColor)),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextButton(
                              child: Text(
                                'Pay',
                                style: TextStyle(color: Get.theme.primaryColor),
                              ),
                              onPressed: () async {
                                // Get.back();
                                await _save(
                                    callId: paymentCallId!, amount: amount);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                    content: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: global.translatedText('Card Number'),
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    controller: _cCardNumber,
                                    inputFormatters: [
                                      MaskedTextInputFormatter(
                                        mask: 'xxxx-xxxx-xxxx-xxxx',
                                        separator: '-',
                                      ),
                                    ],
                                    style: TextStyle(color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                      hintText: snapshot.data,
                                      hintStyle: Theme.of(context)
                                          .inputDecorationTheme
                                          .hintStyle,
                                      prefixIcon: Icon(
                                        Icons.credit_card,
                                        color: Get.theme.primaryColor,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Get.theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.number,
                                    onSaved: (String? value) {
                                      number = global.getCleanedNumber(value!);
                                    },
                                    // ignore: missing_return
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Enter Card Number';
                                      }

                                      input = global.getCleanedNumber(input);

                                      if (input.length < 8) {
                                        return 'Enter Valid Card Number';
                                      }

                                      int sum = 0;
                                      int length = input.length;
                                      for (var i = 0; i < length; i++) {
                                        // get digits in reverse order
                                        int digit =
                                            int.parse(input[length - i - 1]);

                                        // every 2nd number multiply with 2
                                        if (i % 2 == 1) {
                                          digit *= 2;
                                        }
                                        sum += digit > 9 ? (digit - 9) : digit;
                                      }

                                      if (sum % 10 == 0) {
                                        return null;
                                      }

                                      return 'Enter Valid Card Number';
                                    },
                                  );
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      CardMonthInputFormatter(),
                                    ],
                                    controller: _cExpiry,
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.date_range,
                                          color: Get.theme.primaryColor,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                        hintText: 'MM/YY',
                                        hintStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .hintStyle),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    onFieldSubmitted: (value) {
                                      List<int> expiryDate =
                                          global.getExpiryDate(value);
                                      _month = expiryDate[0];
                                      _year = expiryDate[1];
                                    },
                                    onEditingComplete: () {
                                      List<int> expiryDate =
                                          global.getExpiryDate(_cExpiry.text);
                                      _month = expiryDate[0];
                                      _year = expiryDate[1];
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Expiry Date';
                                      }
                                      int year;
                                      int month;
                                      // The value contains a forward slash if the month and year has been
                                      // entered.
                                      if (value.contains(new RegExp(r'(\/)'))) {
                                        var split =
                                            value.split(new RegExp(r'(\/)'));
                                        // The value before the slash is the month while the value to right of
                                        // it is the year.
                                        month = int.parse(split[0]);
                                        year = int.parse(split[1]);
                                      } else {
                                        // Only the month was entered
                                        month = int.parse(
                                            value.substring(0, (value.length)));
                                        year =
                                            -1; // Lets use an invalid year intentionally
                                      }

                                      if ((month < 1) || (month > 12)) {
                                        // A valid month is between 1 (January) and 12 (December)
                                        return 'Expiry month is invalid';
                                      }

                                      var fourDigitsYear =
                                          global.convertYearTo4Digits(year);
                                      if ((fourDigitsYear < 1) ||
                                          (fourDigitsYear > 2099)) {
                                        // We are assuming a valid should be between 1 and 2099.
                                        // Note that, it's valid doesn't mean that it has not expired.
                                        return 'Expiry year is invalid';
                                      }

                                      if (!global.hasDateExpired(month, year)) {
                                        return 'Card has expired';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      // ignore: deprecated_member_use
                                      MyFilter(),
                                      new LengthLimitingTextInputFormatter(3),
                                    ],
                                    controller: _cCvv,
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(
                                          MdiIcons.creditCard,
                                          color: Get.theme.primaryColor,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                        hintText: 'CVV',
                                        hintStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .hintStyle),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter CVV';
                                      } else if (value.length < 3 ||
                                          value.length > 4) {
                                        return 'Cvv is invalid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                                future:
                                    global.translatedText('Card holder name'),
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    controller: _cName,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[a-zA-Z ]')),
                                    ],
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Get.theme.primaryColor,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                        hintText: snapshot.data,
                                        hintStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .hintStyle),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return null;
                                      }
                                      return null;
                                    },
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  )));
        });
  }

  Future _save({int? callId, double? amount}) async {
    try {
      totalAmount = amount!;
      if (_cCardNumber.text.trim().isEmpty) {
        global.showToast(
            message: 'Enter your card number',
            bgColor: global.toastBackGoundColor,
            textColor: global.textColor);
      } else if (_cExpiry.text.trim().isEmpty) {
        global.showToast(
            message: 'Enter your expiry date',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor);
      } else if (_cName.text.trim().isEmpty) {
        global.showToast(
            message: 'Enter your card name',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor);
      } else {
        if (_formKey.currentState!.validate()) {
          var split = _cExpiry.text.split(new RegExp(r'(\/)'));
          _month = int.parse(split[0]);
          _year = int.parse(split[1]);
          CardModel stripeCard = CardModel(
            number: _cCardNumber.text,
            expiryMonth: _month,
            expiryYear: _year,
            cvv: _cCvv.text,
            name: _cName.text,
          );

          await payWithNewCard(
              card: stripeCard, amount: amount.toInt(), currency: '');
          // }
        } else {}
      }
    } catch (e) {
      print("Exception - payment_gateways_screen.dart - _save(): " +
          e.toString());
    }
  }

  Future<StripeTransactionResponse> payWithNewCard(
      {required int amount, CardModel? card, String? currency}) async {
    var customers;
    try {
      global.showOnlyLoaderDialog(Get.context);
      customers = await StripeService.createCustomer(
          email: "${splashController.currentUser!.email}");

      var paymentMethodsObject = await StripeService.createPaymentMethod(card!);

      var paymentIntent = await StripeService.createPaymentIntent(
          amount * 100,
          currency!,
          customerId: customers["id"],
          paymentMethodsObject["id"]);
      await StripeService.retrivePaymentIntent(paymentIntent["id"]);
      var response = await StripeService.confirmPaymentIntent(
          paymentIntent["id"], paymentMethodsObject["id"]);
      String responseId = response["id"];
      global.hideLoader();
      if (response["status"] == 'succeeded') {
        try {
          print("Paymant success");
          global.showOnlyLoaderDialog(Get.context);

          await apiHelper
              .addStrip(
                  amount: addWalletAmount,
                  status: 'Success',
                  paymentId: responseId)
              .then((result) {
            global.hideLoader();
            splashController.getCurrentUserData();
            splashController.update();
            bottomController.setIndex(0, 0);
            Get.to(() => BottomNavigationBarScreen(index: 0));
            global.showToast(
                message: 'Payment transaction successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor);

            // }
          });
        } catch (e) {
          print(
              "Exception - paymentGatewaysScreen.dart - _handlePaymentSuccess" +
                  e.toString());
        }
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else if (response["status"] == 'requires_action') {
        var url = response["next_action"]["use_stripe_sdk"]["stripe_js"];
        print(url);
        var res = http.get(Uri.parse(url));
        print(res);
        try {
          print("Paymant success");
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper
              .addStrip(
                  amount: addWalletAmount,
                  status: 'Success',
                  paymentId: responseId)
              .then((result) {
            global.hideLoader();
            splashController.getCurrentUserData();
            splashController.update();
            bottomController.setIndex(1, 0);
            Get.to(() => BottomNavigationBarScreen(index: 0));
            global.showToast(
                message: 'Payment transaction sucessfull',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor);

            // }
          });
        } catch (e) {
          print(
              "Exception - paymentGatewaysScreen.dart - _handlePaymentSuccess" +
                  e.toString());
        }
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        try {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.addStrip(
              amount: addWalletAmount, status: 'failed', paymentId: responseId);
          global.hideLoader();
          Get.back();
          tryAgainDialog(openCheckout);
          global.showToast(
            message: 'Payment Failed amount not added into your wallet.',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        } catch (e) {
          print(
              "Exception - paymentGatewaysScreen.dart -  _handlePaymentError" +
                  e.toString());
        }
        _tryAgain(payWithNewCard);
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      print(
          'Platfrom Exception: payment_gateways_screen.dart -  payWithNewCard() : ${err.toString()}');
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      print(
          'Exception: payment_gateways_screen.dart -  payWithNewCard() : ${err.toString()}');
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  _tryAgain(Function onClickAction) {
    try {
      showCupertinoDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'Transaction failed',
                ),
                content: Text(
                  'Please try again',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Try Again'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showOnlyLoaderDialog(context);
                      onClickAction();
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print("Exception - payment_gateways_screen.dart - _tryAgainDialog(): " +
          e.toString());
    }
  }
}

class MyFilter extends TextInputFormatter {
  static final _reg = RegExp(r'^\d+$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _reg.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
