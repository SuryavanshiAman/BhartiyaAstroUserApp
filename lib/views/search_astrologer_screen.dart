import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/languageController.dart';
import 'package:BharatiyAstro/controllers/reportController.dart';
import 'package:BharatiyAstro/controllers/reportTabFiltter.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/skillController.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:BharatiyAstro/views/reportTypeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../controllers/razorPayController.dart';
import '../controllers/search_controller.dart';
import '../controllers/walletController.dart';
import '../utils/images.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import 'astrologerProfile/astrologerProfile.dart';

// ignore: must_be_immutable
class SeachAstrologerReportScreen extends StatelessWidget {
  SeachAstrologerReportScreen({Key? key}) : super(key: key);

  ReportController reportController = Get.find<ReportController>();
  ReportFilterTabController reportFilter = Get.find<ReportFilterTabController>();
  SkillController skillController = Get.find<SkillController>();
  LanguageController languageController = Get.find<LanguageController>();
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Get.theme.iconTheme.color,
          ),
        ),
        title: GetBuilder<SearchController>(builder: (searchController) {
          return FutureBuilder(
              future: global.translatedText('Search by Name'),
              builder: (context, snapshot) {
                return TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    if (value.length > 2) {
                      searchController.astrologerList.clear();
                      searchController.isAllDataLoaded = false;
                      searchController.searchString = value;
                      searchController.update();
                      await searchController.getSearchResult(value, 'astrologer', false);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: snapshot.data ?? 'Search by Name',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                );
              });
        }),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Get.theme.iconTheme.color,
              ))
        ],
      ),
      body: GetBuilder<SearchController>(builder: (searchController) {
        return searchController.astrologerList.isEmpty
            ? Center(
                child: Text('Astrologer not found'),
              )
            : ListView.builder(
                itemCount: searchController.astrologerList.length,
                shrinkWrap: true,
                controller: searchController.searchScrollController,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Get.find<ReviewController>().getReviewData(searchController.astrologerList[index].id!);
                      BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                      global.showOnlyLoaderDialog(context);
                      await bottomNavigationController.getAstrologerbyId(searchController.astrologerList[index].id!);
                      global.hideLoader();
                      Get.to(() => AstrologerProfile(
                            index: index,
                          ));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Get.theme.primaryColor)),
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                child: CachedNetworkImage(
                                                  height: 55,
                                                  width: 55,
                                                  imageUrl: '${global.imgBaseurl}${searchController.astrologerList[index].profileImage}',
                                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) {
                                                    return CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor: Colors.white,
                                                        child: Image.asset(
                                                          Images.deafultUser,
                                                          fit: BoxFit.fill,
                                                          height: 50,
                                                        ));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 0,
                                              child: Image.asset(
                                                Images.right,
                                                height: 18,
                                              ))
                                        ],
                                      ),
                                    ),
                                    RatingBar.builder(
                                      initialRating: 0,
                                      itemCount: 5,
                                      allowHalfRating: false,
                                      itemSize: 15,
                                      ignoreGestures: true,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Get.theme.primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          Images.userProfile,
                                          height: 10,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${searchController.astrologerList[index].totalOrder} orders',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchController.astrologerList[index].name!,
                                        ),
                                        Text(
                                          searchController.astrologerList[index].allSkill!,
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          searchController.astrologerList[index].languageKnown!,
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'Experience : ${searchController.astrologerList[index].experienceInYears} Years',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${searchController.astrologerList[index].reportRate}/report',
                                              style: Get.theme.textTheme.subtitle1!.copyWith(
                                                color: Colors.black54,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                    fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                    backgroundColor: MaterialStateProperty.all(Colors.green),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    bool isLogin = await global.isLogin();
                                    if (isLogin) {
                                      double charge = double.parse(searchController.astrologerList[index].reportRate.toString());
                                      if (charge <= global.splashController.currentUser!.walletAmount!) {
                                        global.showOnlyLoaderDialog(context);
                                        reportController.searchString = null;
                                        reportController.reportTypeList = [];
                                        reportController.reportTypeList.clear();
                                        reportController.isAllDataLoaded = false;
                                        reportController.update();
                                        await reportController.getReportTypes(null, false);
                                        global.hideLoader();
                                        Get.to(() => ReportTypeScreen(
                                              astrologerId: searchController.astrologerList[index].id!,
                                              astrologerName: searchController.astrologerList[index].name!,
                                            ));
                                      } else {
                                        global.showOnlyLoaderDialog(context);
                                        await walletController.getAmount();
                                        global.hideLoader();
                                        openBottomSheetRechrage(context, charge.toString(), '${searchController.astrologerList[index].name!}');
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Get report',
                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        searchController.isMoreDataAvailable == true && !searchController.isAllDataLoaded && searchController.astrologerList.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                },
              );
      }),
    );
  }

  void openBottomSheetRechrage(BuildContext context, String minBalance, String astrologer) {
    Get.bottomSheet(
      Wrap(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.85,
                                  child: minBalance != ''
                                      ? Text(
                                          'Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start conversation with $astrologer ',
                                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red))
                                      : const SizedBox(),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: minBalance == '' ? const EdgeInsets.only(top: 8) : const EdgeInsets.only(top: 0),
                                    child: Icon(Icons.close, size: 18),
                                  ),
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                              child: Text('Recharge Now', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(Icons.lightbulb_rounded, color: Get.theme.primaryColor, size: 13),
                                ),
                                Expanded(
                                    child: Text(
                                        'Minimum balance required ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance',
                                        style: TextStyle(fontSize: 12)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
