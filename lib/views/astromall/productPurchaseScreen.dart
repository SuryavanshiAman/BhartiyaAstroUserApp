import 'package:BharatiyAstro/controllers/astromallController.dart';
import 'package:BharatiyAstro/controllers/razorPayController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/controllers/walletController.dart';
import 'package:BharatiyAstro/widget/commonAppbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

// ignore: must_be_immutable
class OrderPurchaseScreen extends StatelessWidget {
  final double amount;
  final int? flag;
  OrderPurchaseScreen({Key? key, required this.amount, this.flag}) : super(key: key);
  final WalletController walletController = Get.find<WalletController>();
  RazorPayController razorPay = Get.find<RazorPayController>();
  SplashController splashController = Get.find<SplashController>();
  AstromallController astromallController = Get.find<AstromallController>();

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
            return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        Text('Payment Details', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(
                          height: 5,
                        ),
                        flag == 1
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${astromallController.astroProductbyId[0].name}'),
                                  Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${double.parse(astromallController.astroProductbyId[0].amount.toString())}'),
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
                            Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $amount'),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('GST ${global.getSystemFlagValue(global.systemFlagNameList.gst)}'),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('${amount * double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) / 100}'),
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
                            Text('Total Payable Amount', style: Get.textTheme.subtitle1!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                            Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${(amount + amount * double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) / 100).toStringAsFixed(2)}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
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

              await astromallController.orderRequest(
                addId: astromallController.userAddress[0].id,
                catId: astromallController.astroProductbyId[0].productCategoryId,
                gstPercent: int.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)),
                payAmount: double.parse(astromallController.astroProductbyId[0].amount.toString()),
                payMethod: 'RazorPay',
                prodId: astromallController.astroProductbyId[0].id,
                totalPayment: double.parse(astromallController.astroProductbyId[0].amount.toString()) + (double.parse(astromallController.astroProductbyId[0].amount.toString()) * int.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) / 100),
                context: context
              );
              astromallController.update();
              // Get.back();
            },
            child: Text('Proceed to Pay', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
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
