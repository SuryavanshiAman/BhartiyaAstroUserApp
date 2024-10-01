import 'package:BharatiyAstro/controllers/razorPayController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/controllers/walletController.dart';
import 'package:BharatiyAstro/model/businessLayer/baseRoute.dart';
import 'package:BharatiyAstro/utils/global.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'dart:developer';
import '../widget/commonAppbar.dart';

class AddmoneyToWallet extends BaseRoute {
  AddmoneyToWallet({a, o}) : super(a: a, o: o, r: 'AddMoneyToWallet');
  final WalletController walletController = Get.find<WalletController>();
    
  @override
  Widget build(BuildContext context) {
    log("===========================================>${MediaQuery.of(context).size.width}");
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Add money to wallet',
          )),
      body: SingleChildScrollView(
        child: GetBuilder<SplashController>(builder: (splash) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Balance',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${splashController.currentUser!.walletAmount.toString()}',
                    style: Get.textTheme.subtitle1!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                GetBuilder<WalletController>(builder: (c) {
                  return GridView.builder(
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:MediaQuery.of(context).size.width<300?2:3,
                        childAspectRatio: 3 / 3.5,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: walletController.paymentAmount.length,
                      itemBuilder: (context, index) {
                        return
                         GestureDetector(
                          onTap: () {
                            Get.delete<RazorPayController>();
                            Get.to(() => PaymentInformationScreen(
                                  amount: double.parse(walletController
                                      .paymentAmount[index].amount
                                      .toString()),
                                  extraAmount: walletController
                                          .paymentAmount[index].amount! *
                                      (walletController
                                              .paymentAmount[index].offer! /
                                          100),
                                ));
                          },
                          child: 
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Container(
                              // padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                      color: Colors.black38)
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Get.theme.primaryColor,
                                      gradient: LinearGradient(
                                          transform: GradientRotation(180),
                                          colors: [
                                            Colors.white,
                                            Get.theme.primaryColor
                                          ]),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    height: 25,
                                    child: Center(
                                      child: Text(
                                        '${walletController.paymentAmount[index].offer}% Extra',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.paymentAmount[index].amount}',
                                        style: Get.textTheme.titleSmall!
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 16),
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      Text(
                                        'Get',
                                        style:
                                            Get.textTheme.titleSmall!.copyWith(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // ),
                                      Text(
                                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}  ${walletController.paymentAmount[index].amount! + (walletController.paymentAmount[index].offer! / 100) * int.parse("${walletController.paymentAmount[index].amount}")}',
                                        style:
                                            Get.textTheme.titleSmall!.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                })
              ],
            ),
          );
        }),
      ),
    );
  }
}
