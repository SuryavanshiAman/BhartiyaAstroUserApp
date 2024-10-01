// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/counsellorController.dart';
import 'package:BharatiyAstro/views/counsellor/callWithCounsellor.dart';
import 'package:BharatiyAstro/views/counsellor/chatWithCounSellor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../widget/customAppbarWidget.dart';
import '../../widget/drawerWidget.dart';
import '../addMoneyToWallet.dart';

class CounsellorScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  CounsellorScreen({Key? key}) : super(key: key);

  CounsellorController counsellor = Get.find<CounsellorController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CounsellorController>(builder: (c) {
      return Scaffold(
          key: drawerKey,
          drawer: DrawerWidget(),
          appBar: CustomAppBar(
            onBackPressed: () {},
            scaffoldKey: drawerKey,
            title: counsellor.isCall ? 'Call With Counsellors' : 'Chat With Counsellors',
            titleStyle: Get.theme.primaryTextTheme.subtitle2!.copyWith(fontWeight: FontWeight.w300),
            bgColor: Get.theme.primaryColor,
            actions: [
              InkWell(
                onTap: () {
                  Get.to(() => AddmoneyToWallet());
                },
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    global.splashController.currentUser?.walletAmount != null
                        ? Container(
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}',
                              style: Get.theme.primaryTextTheme.bodySmall,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              counsellor.counsellorList.clear();
              counsellor.isAllDataLoaded = false;
              await counsellor.getCounsellorsData(false);
            },
            child: GetBuilder<CounsellorController>(builder: (counsellorController) {
              return counsellorController.isCall
                  ? CallWithCounsellors(
                      counsellorController: counsellorController,
                    )
                  : ChatWithCounSellor(
                      counsellorController: counsellorController,
                    );
            }),
          ),
          bottomSheet: Container(
            alignment: Alignment.bottomCenter,
            height: 40,
            child: GetBuilder<CounsellorController>(builder: (counsellorController) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        counsellor.counsellorList.clear();
                        counsellor.isAllDataLoaded = false;
                        global.showOnlyLoaderDialog(context);
                        await counsellor.getCounsellorsData(false);
                        global.hideLoader();
                        counsellorController.setBottomTab(chat: true, call: false);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                            color: counsellorController.isChat ? Get.theme.primaryColor : Colors.transparent,
                            border: Border.all(color: counsellorController.isChat ? Colors.grey : Colors.transparent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text('Chat')),
                    ),
                    GestureDetector(
                      onTap: () async {
                        global.showOnlyLoaderDialog(context);
                        await counsellor.getCounsellorsData(false);
                        global.hideLoader();
                        counsellorController.setBottomTab(chat: false, call: true);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                            color: counsellorController.isCall ? Get.theme.primaryColor : Colors.transparent,
                            border: Border.all(color: counsellorController.isCall ? Colors.grey : Colors.transparent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("Call")),
                    )
                  ],
                ),
              );
            }),
          ));
    });
  }
}
