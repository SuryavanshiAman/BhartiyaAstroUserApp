import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:BharatiyAstro/views/homeScreen.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/phonepayController.dart';
import '../controllers/razorPayController.dart';

class CheckPayment extends StatefulWidget {
  final double amount;
  const CheckPayment({Key? key, required this.amount}) : super(key: key);

  @override
  _CheckPaymentState createState() => _CheckPaymentState();
}

class _CheckPaymentState extends State<CheckPayment> {
  PhonePayController phonepayController =
      Get.put<PhonePayController>(PhonePayController());
  RazorPayController razorPayController = Get.put(RazorPayController());
  checkStatus() async {
    // phonepayController.statusSh256Value.value =
    //     await phonepayController.statusSHA(
    //         'M1HWPNY5AGA4',
    //         phonepayController.phonePayModel.data!.merchantTransactionId ?? "",
    //         '02c275ae-a76a-4c39-b668-418874698d21');

    // await phonepayController.checkStatus(
    //     merchantId: phonepayController.phonePayModel.data!.merchantId,
    //     transactionId: phonepayController.merchandTransectionId,
    //     xVerify: phonepayController.statusSh256Value.value);

    if (phonepayController.statusCode.value == 'COMPLETED') {
      razorPayController.AddmoneyToWallet(
        widget.amount,
          phonepayController.statusResponse.data!.merchantTransactionId ?? "",
          phonepayController.statusResponse.data!.transactionId ?? "",
          phonepayController.statusResponse.data!.state ?? "");
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    checkStatus();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ignore: unnecessary_statements
        phonepayController.paymentSuccees.value == false;
        Get.off(() => BottomNavigationBarScreen(index: 0));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Get.off(() => BottomNavigationBarScreen(index: 0));
            },
          ),
          title: Text(
            'Payment Status',
            style: Get.textTheme.headlineSmall!.copyWith(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: Center(
          child: Obx(() {
            return !(phonepayController.paymentSuccees.value)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Your Payment on Progress',
                        style: Get.textTheme.titleLarge!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CircularProgressIndicator()
                    ],
                  )
                : Center(
                    child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      height: Get.height * 0.9,
                      width: Get.width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.50),
                                offset: Offset(2, 4),
                                spreadRadius: 0,
                                blurRadius: 8)
                          ]),
                      child: Obx(() => phonepayController.statusCode.value ==
                              'COMPLETED'
                          ? Container(
                              // height: 100,
                              // width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 100,
                                        color: Colors.green,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        ' \u{20B9} ${phonepayController.statusResponse.data!.amount! / 100}',
                                        style: Get.textTheme.headlineMedium,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Order Id',
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 15,
                                                color: Colors.black),
                                      ),
                                      Text(
                                        '${phonepayController.statusResponse.data!.transactionId}',
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 12,
                                                color: Colors.black),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'TransactionId',
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 15,
                                                color: Colors.black),
                                      ),
                                      Text(
                                        '${phonepayController.statusResponse.data!.transactionId ?? "Not Availbale"}',
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 12,
                                                color: Colors.black),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Payment State',
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 15,
                                                color: Colors.black),
                                      ),
                                      Text(
                                        '${phonepayController.statusResponse.data!.state}',
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 12,
                                                color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : (phonepayController.statusCode.value == 'PENDING')
                              ? Container(
                                  // height: 100,
                                  // width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.pending,
                                            size: 100,
                                            color: Get.theme.primaryColor,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' \u{20B9} ${phonepayController.statusResponse.data!.amount! / 100}',
                                            style: Get.textTheme.headlineMedium,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Order Id',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                          ),
                                          Text(
                                            '${phonepayController.statusResponse.data!.transactionId}',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'TransactionId',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                          ),
                                          Text(
                                            '${phonepayController.statusResponse.data!.transactionId ?? "Not Availbale"}',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Payment State',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                          ),
                                          Text(
                                            '${phonepayController.statusResponse.data!.state}',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cancel,
                                            size: 100,
                                            color: Colors.red,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' \u{20B9} ${phonepayController.statusResponse.data!.amount! / 100}',
                                            style: Get.textTheme.headlineMedium,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Order Id',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                          ),
                                          Text(
                                            '${phonepayController.statusResponse.data!.transactionId}',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'TransactionId',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                          ),
                                          Text(
                                            '${phonepayController.statusResponse.data!.transactionId ?? "Not Availbale"}',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: 
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Payment State',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                          ),
                                          Text(
                                            '${phonepayController.statusResponse.data!.state}',
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          )
                                        ],
                                      )
                                      // ListTile(
                                      //   leading: Text(
                                      //     'Transaction Id',
                                      //     style: Get.textTheme.titleMedium!.copyWith(
                                      //       fontSize: 12
                                      //     ),
                                      //   ),
                                      //   trailing:Text(
                                      //     '${phonepayController.statusResponse.data!.transactionId}',
                                      //     style: Get.textTheme.titleMedium,
                                      //   ) ,
                                      // )
                                    ],
                                  ),
                                )),
                    ),
                  ));
          }),
        ),
      ),
    );
  }
}
