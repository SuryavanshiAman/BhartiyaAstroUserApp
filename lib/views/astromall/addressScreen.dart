// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/walletController.dart';
import 'package:BharatiyAstro/views/astromall/addNewAddressScreen.dart';
import 'package:BharatiyAstro/views/astromall/productPurchaseScreen.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../controllers/astromallController.dart';
import '../../controllers/razorPayController.dart';
import '../../widget/commonAppbar.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({Key? key,}) : super(key: key);
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Address',
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width,
                child: GetBuilder<AstromallController>(builder: (astromallController) {
                  return TextButton(
                    onPressed: () async {
                      await astromallController.removeData();
                      Get.to(() => AddNewAddressScreen());
                    },
                    child: Text(
                      'Add new address',
                      style: Get.textTheme.headline6,
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.black)),
                      ),
                    ),
                  );
                }),
              ),
              GetBuilder<AstromallController>(builder: (astromallController) {
                return astromallController.userAddress.isEmpty
                    ? Center(
                        child: Text('Please add your address'),
                      )
                    : ListView.builder(
                        itemCount: astromallController.userAddress.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //padding:,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${astromallController.userAddress[index].name}'),
                                          Text('${astromallController.userAddress[index].flatNo},${astromallController.userAddress[index].locality},${astromallController.userAddress[index].city},${astromallController.userAddress[index].state},${astromallController.userAddress[index].country}'),
                                          Text('${astromallController.userAddress[index].pincode}'),
                                          Text('${astromallController.userAddress[index].phoneNumber}'),
                                          if (astromallController.userAddress[index].phoneNumber2 != "") Text('${astromallController.userAddress[index].phoneNumber2}'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                global.showOnlyLoaderDialog(context);
                                                await astromallController.getEditAddress(index);
                                                astromallController.update();
                                                global.hideLoader();
                                                Get.to(() => AddNewAddressScreen(
                                                      id: astromallController.userAddress[index].id,
                                                    ));
                                              },
                                              child: Icon(Icons.edit)),
                                          TextButton(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                              fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                              backgroundColor: MaterialStateProperty.all(Colors.white),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              double charge = double.parse(astromallController.astroProductbyId[0].amount.toString());
                                              if (charge <= global.splashController.currentUser!.walletAmount!) {
                                                Get.to(() => OrderPurchaseScreen(amount: double.parse(astromallController.astroProductbyId[0].amount.toString())));
                                              } else {
                                                global.showOnlyLoaderDialog(context);
                                                await walletController.getAmount();
                                                global.hideLoader();
                                                openBottomSheetRechrage(context, charge.toString());
                                              }
                                            },
                                            child: Text(
                                              'Select',
                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              )
                            ],
                          );
                        });
              })
            ],
          ),
        ),
      ),
    );
  }

  void openBottomSheetRechrage(BuildContext context, String minBalance) {
    Get.bottomSheet(
              Wrap(
                children: [
                     Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     Expanded(
              child: GridView.builder(
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:MediaQuery.of(context).size.width<300?2:3,
                        childAspectRatio: 3 / 3.5,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                  // physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: walletController.rechrage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.delete<RazorPayController>();
                        Get.to(() => PaymentInformationScreen(
                              amount: double.parse(walletController.paymentAmount[index].amount.toString()),
                              extraAmount: walletController.paymentAmount[index].amount! * (walletController.paymentAmount[index].offer! / 100),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Container(
                          // padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 2, color: Colors.black38)],
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
                                  gradient: LinearGradient(transform: GradientRotation(180), colors: [Colors.white, Get.theme.primaryColor]),
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.paymentAmount[index].amount}',
                                    style: Get.textTheme.titleSmall!.copyWith(color: Colors.black, fontSize: 16),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Text(
                                    'Get',
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}  ${walletController.paymentAmount[index].amount! + (walletController.paymentAmount[index].offer! / 100) * int.parse("${walletController.paymentAmount[index].amount}")}',
                                    style: Get.textTheme.titleSmall!.copyWith(
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
                  })),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3.8 / 2.3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: walletController.rechrage.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.delete<RazorPayController>();
                          Get.to(() => PaymentInformationScreen(flag: 0, amount: double.parse(walletController.payment[index])));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.rechrage[index]}',
                              style: TextStyle(fontSize: 13),
                            )),
                          ),
                        ),
                      );
                    }))
                ],
              ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }
}
