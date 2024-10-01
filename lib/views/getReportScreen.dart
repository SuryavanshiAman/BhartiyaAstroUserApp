// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/languageController.dart';
import 'package:BharatiyAstro/controllers/reportController.dart';
import 'package:BharatiyAstro/controllers/reportTabFiltter.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/skillController.dart';
import 'package:BharatiyAstro/views/addMoneyToWallet.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:BharatiyAstro/views/profile/editUserProfileScreen.dart';
import 'package:BharatiyAstro/views/reportTypeScreen.dart';
import 'package:BharatiyAstro/views/search_astrologer_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../controllers/razorPayController.dart';
import '../controllers/walletController.dart';
import '../utils/images.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import 'Report Form/report_form.dart';
import 'astrologerProfile/astrologerProfile.dart';

class GetReportScreen extends StatelessWidget {
  GetReportScreen({Key? key}) : super(key: key);

  ReportController reportController = Get.find<ReportController>();
  ReportFilterTabController reportFilter = Get.find<ReportFilterTabController>();
  SkillController skillController = Get.find<SkillController>();
  LanguageController languageController = Get.find<LanguageController>();
  BottomNavigationController bottomController = Get.find<BottomNavigationController>();
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
        title: Text(
          'Get Detailed Report',
          style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Get.theme.iconTheme.color,
          ),
        ),
        actions: [
          global.currentUserId == null
              ? const SizedBox()
              : InkWell(
                  onTap: () {
                    Get.to(() => AddmoneyToWallet());
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}',
                      style: Get.theme.primaryTextTheme.bodySmall,
                    ),
                  )),
          IconButton(
              onPressed: () {
                Get.to(() => SeachAstrologerReportScreen());
              },
              icon: Icon(
                Icons.search,
                color: Get.theme.iconTheme.color,
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          bottomController.astrologerList = [];
          bottomController.astrologerList.clear();
          bottomController.isAllDataLoaded = false;
          bottomController.update();
          await bottomController.getAstrologerList(isLazyLoading: false);
        },
        child: GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
          return bottomNavigationController.astrologerList.isEmpty
              ? Center(
                  child: Text('Astrologer not Available'),
                )
              : ListView.builder(
                  itemCount: bottomNavigationController.astrologerList.length,
                  shrinkWrap: true,
                  controller: bottomNavigationController.getReportscrollController,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        Get.find<ReviewController>().getReviewData(bottomNavigationController.astrologerList[index].id!);
                        global.showOnlyLoaderDialog(context);
                        await bottomNavigationController.getAstrologerbyId(bottomNavigationController.astrologerList[index].id!);
                        global.hideLoader();
                        Get.to(() => AstrologerProfile(
                              index: index,
                            ));
                      },
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Container(
                                              height: 85,
                                              width: 85,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  border: Border.all(color: Get.theme.primaryColor)),
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                child: CachedNetworkImage(
                                                  height: 85,
                                                  width: 85,
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      '${global.imgBaseurl}${bottomNavigationController.astrologerList[index].profileImage}',
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
                                          // Positioned(
                                          //     right: 0,
                                          //     child: ),
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
                                                '${bottomNavigationController.astrologerList[index].totalOrder} orders',
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
                                                bottomNavigationController.astrologerList[index].name!,
                                              ),
                                              Text(
                                                bottomNavigationController.astrologerList[index].allSkill!,
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                bottomNavigationController.astrologerList[index].languageKnown!,
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                'Expireance: ${bottomNavigationController.astrologerList[index].experienceInYears} Years',
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerList[index].reportRate}/report',
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
                                      Icon(
                                        Icons.verified,
                                        color: Color.fromARGB(255, 21, 123, 17),
                                      ),
                                      // Column(
                                      //   children: [

                                      //   ],
                                      // )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
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
                                            if (global.user.name == "") {
                                              global.showOnlyLoaderDialog(context);
                                              await global.splashController.getCurrentUserData();
                                              global.hideLoader();
                                              Get.to(() => EditUserProfile());
                                            }
                                            double charge = double.parse(
                                                bottomNavigationController.astrologerList[index].reportRate.toString());
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
                                                    astrologerId: bottomNavigationController.astrologerList[index].id!,
                                                    astrologerName: bottomNavigationController.astrologerList[index].name!,
                                                  ));
                                            } else {
                                              global.showOnlyLoaderDialog(context);
                                              await walletController.getAmount();
                                              global.hideLoader();
                                              openBottomSheetRechrage(context, charge.toString(),
                                                  '${bottomNavigationController.astrologerList[index].name!}');
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Get report',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          bool isLogin = await global.isLogin();
                                          if (isLogin) {
                                            if (global.user.name == "") {
                                              global.showOnlyLoaderDialog(context);
                                              await global.splashController.getCurrentUserData();
                                              global.hideLoader();
                                              Get.to(() => EditUserProfile());
                                            }
                                            double charge = double.parse(
                                                bottomNavigationController.astrologerList[index].reportRate.toString());
                                            if (charge <= global.splashController.currentUser!.walletAmount!) {
                                              global.showOnlyLoaderDialog(context);
                                              reportController.searchString = null;
                                              reportController.reportTypeList = [];
                                              reportController.reportTypeList.clear();
                                              reportController.isAllDataLoaded = false;
                                              reportController.update();
                                              await reportController.getReportTypes(null, false);
                                              global.hideLoader();
                                              Get.to(() => ReportForm(
                                                    type: 'Vastu Request',
                                                    astrlogerId: bottomNavigationController.astrologerList[index].userId,
                                                  ));
                                            } else {
                                              global.showOnlyLoaderDialog(context);
                                              await walletController.getAmount();
                                              global.hideLoader();
                                              openBottomSheetRechrage(context, charge.toString(),
                                                  '${bottomNavigationController.astrologerList[index].name!}');
                                            }
                                          }
                                        },
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
                                        child: Text(
                                          'Vastu request',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          bool isLogin = await global.isLogin();
                                          if (isLogin) {
                                            if (global.user.name == "") {
                                              global.showOnlyLoaderDialog(context);
                                              await global.splashController.getCurrentUserData();
                                              global.hideLoader();
                                              Get.to(() => EditUserProfile());
                                            }
                                            double charge = double.parse(
                                                bottomNavigationController.astrologerList[index].reportRate.toString());
                                            if (charge <= global.splashController.currentUser!.walletAmount!) {
                                              global.showOnlyLoaderDialog(context);
                                              reportController.searchString = null;
                                              reportController.reportTypeList = [];
                                              reportController.reportTypeList.clear();
                                              reportController.isAllDataLoaded = false;
                                              reportController.update();
                                              await reportController.getReportTypes(null, false);
                                              global.hideLoader();
                                              Get.to(() => ReportForm(
                                                    astrlogerId: bottomNavigationController.astrologerList[index].userId,
                                                    type: 'Palm request',
                                                  ));
                                            } else {
                                              global.showOnlyLoaderDialog(context);
                                              await walletController.getAmount();
                                              global.hideLoader();
                                              openBottomSheetRechrage(context, charge.toString(),
                                                  '${bottomNavigationController.astrologerList[index].name!}');
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                                          fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                          backgroundColor: MaterialStateProperty.all(Colors.green),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Palm request',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          bottomNavigationController.isMoreDataAvailable == true &&
                                  !bottomNavigationController.isAllDataLoaded &&
                                  bottomNavigationController.astrologerList.length - 1 == index
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                          index == bottomNavigationController.astrologerList.length - 1
                              ? const SizedBox(
                                  height: 50,
                                )
                              : const SizedBox()
                        ],
                      ),
                    );
                  },
                );
        }),
      ),
      bottomSheet: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 1),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: GetBuilder<ReportController>(builder: (report) {
                            return SizedBox(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, right: 8, top: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Sort by'),
                                          IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: Icon(Icons.close))
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: reportController.reportSorting.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  for (var i = 0; i < reportController.reportSorting.length; i++) {
                                                    if (reportController.reportSorting[i].isSeledted == false) {
                                                      if (i == index) {
                                                        reportController.reportSorting[index].isSeledted = true;
                                                        reportController.update();
                                                        print(
                                                            'aif ${reportController.reportSorting[index].name} ${reportController.reportSorting[index].isSeledted}');
                                                      } else {
                                                        reportController.reportSorting[i].isSeledted = false;
                                                        print(
                                                            'else ${reportController.reportSorting[i].name} ${reportController.reportSorting[i].isSeledted}');
                                                      }
                                                    } else {
                                                      reportController.reportSorting[i].isSeledted = false;
                                                      print(
                                                          'else ${reportController.reportSorting[i].name} ${reportController.reportSorting[i].isSeledted}');
                                                    }
                                                  }
                                                  print(
                                                      'if ${reportController.reportSorting[index].isSeledted} ${reportController.reportSorting[index].name}');
                                                  if (reportController.reportSorting[index].isSeledted == true) {
                                                    global.showOnlyLoaderDialog(context);
                                                    await reportController
                                                        .getAstrologerSorting(reportController.reportSorting[index].value!);
                                                    global.hideLoader();
                                                  }
                                                  Get.back();
                                                  reportController.update();
                                                },
                                                child: Container(
                                                  color: reportController.reportSorting[index].isSeledted == true
                                                      ? Colors.grey.shade200
                                                      : Colors.transparent,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                                                        child: Text(reportController.reportSorting[index].name!),
                                                      )),
                                                ),
                                              ),
                                              Divider(height: 0)
                                            ],
                                          );
                                        })
                                  ]),
                            );
                          }),
                        );
                      });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.sort,
                      size: 18,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('SORT')
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  for (var i = 0; i < reportFilter.gender.length; i++) {
                    reportFilter.gender[i].isCheck = true;
                    reportFilter.update();
                  }
                  openBottomSheetFilter(context);
                  skillController.getSkills();
                  languageController.getLanguages();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.sort,
                      size: 18,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Filter')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openBottomSheetFilter(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sort & Filter'),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Obx(
                    () => RotatedBox(
                      quarterTurns: 1,
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: reportFilter.reportFilterTab,
                        indicatorColor: Colors.pink,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.grey[50],
                        onTap: (index) {
                          reportFilter.selectedFilterIndex.value = index;
                          reportFilter.update();
                        },
                        tabs: List.generate(
                          reportFilter.reportFilter.length,
                          (ind) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                color: reportFilter.selectedFilterIndex.value == ind ? Colors.white : Colors.grey[50],
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: reportFilter.selectedFilterIndex.value == ind ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        reportFilter.reportFilter[ind],
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBarView(
                      controller: reportFilter.reportFilterTab,
                      children: [
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<SkillController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: skillController.skillList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: skillController.skillList[index].isSelected,
                                          onChanged: (value) {
                                            skillController.skillList[index].isSelected = value!;
                                            skillController.update();
                                          },
                                          title: Text(skillController.skillList[index].name),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<LanguageController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: languageController.languageList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: languageController.languageList[index].isSelected,
                                          onChanged: (value) {
                                            languageController.languageList[index].isSelected = value!;
                                            languageController.update();
                                          },
                                          title: Text(languageController.languageList[index].languageName),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: reportFilter.gender.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return GetBuilder<ReportFilterTabController>(builder: (filterController) {
                                          return CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.zero,
                                            activeColor: Colors.black,
                                            value: reportFilter.gender[index].isCheck,
                                            onChanged: (value) {
                                              reportFilter.gender[index].isCheck = value!;
                                              reportFilter.update();
                                            },
                                            title: Text(reportFilter.gender[index].name),
                                          );
                                        });
                                      }))),
                        ),
                        SizedBox()
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: 0,
                          child: TextButton(
                            onPressed: () async {
                              skillController.skillFilterList = [];
                              languageController.languageFilterList = [];
                              reportController.sortingFilter = null;
                              reportFilter.genderFilterList = [];
                              bottomController.astrologerList.clear();
                              for (var i = 0; i < skillController.skillList.length; i++) {
                                skillController.skillList[i].isSelected = false;

                                skillController.update();
                              }
                              for (var i = 0; i < languageController.languageList.length; i++) {
                                languageController.languageList[i].isSelected = false;

                                languageController.update();
                              }
                              for (var i = 0; i < reportFilter.gender.length; i++) {
                                reportFilter.gender[i].isCheck = false;

                                reportFilter.update();
                              }

                              await bottomController.getAstrologerList(
                                skills: skillController.skillFilterList,
                                gender: reportFilter.genderFilterList,
                                language: languageController.languageFilterList,
                              );

                              Get.back();
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )),
                        Expanded(child: GetBuilder<SkillController>(
                          builder: (controller) {
                            return SizedBox(
                              width: 80,
                              height: 55,
                              child: TextButton(
                                onPressed: () async {
                                  global.showOnlyLoaderDialog(context);
                                  skillController.skillFilterList = [];
                                  languageController.languageFilterList = [];
                                  reportController.sortingFilter = null;
                                  reportFilter.genderFilterList = [];

                                  for (var i = 0; i < skillController.skillList.length; i++) {
                                    if (skillController.skillList[i].isSelected == true) {
                                      skillController.skillFilterList.add(skillController.skillList[i].id!);
                                      skillController.update();
                                    }
                                  }
                                  for (var i = 0; i < reportFilter.gender.length; i++) {
                                    if (reportFilter.gender[i].isCheck == true) {
                                      reportFilter.genderFilterList.add(reportFilter.gender[i].name);
                                      reportFilter.update();
                                    }
                                  }
                                  for (var i = 0; i < languageController.languageList.length; i++) {
                                    if (languageController.languageList[i].isSelected == true) {
                                      languageController.languageFilterList.add(languageController.languageList[i].id!);
                                      languageController.update();
                                    }
                                  }
                                  bottomController.astrologerList = [];
                                  bottomController.getAstrologerList(
                                      skills: skillController.skillFilterList,
                                      language: languageController.languageFilterList,
                                      gender: reportFilter.genderFilterList);

                                  global.hideLoader();
                                  global.hideLoader();
                                },
                                child: Text('Apply'),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                                  backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                              extraAmount: walletController.paymentAmount[index].amount! *
                                  (walletController.paymentAmount[index].offer! / 100),
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
                                  gradient: LinearGradient(
                                      transform: GradientRotation(180), colors: [Colors.white, Get.theme.primaryColor]),
                                  borderRadius:
                                      BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
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
