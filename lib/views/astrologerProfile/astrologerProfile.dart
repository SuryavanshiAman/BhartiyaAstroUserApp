// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:BharatiyAstro/controllers/astrologer_assistant_controller.dart';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/controllers/chatController.dart';
import 'package:BharatiyAstro/controllers/follow_astrologer_controller.dart';
import 'package:BharatiyAstro/controllers/gift_controller.dart';
import 'package:BharatiyAstro/controllers/razorPayController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/settings_controller.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/controllers/userProfileController.dart';
import 'package:BharatiyAstro/controllers/walletController.dart';
import 'package:BharatiyAstro/model/businessLayer/baseRoute.dart';
import 'package:BharatiyAstro/views/astrologerProfile/availabilityScreen.dart';
import 'package:BharatiyAstro/views/astrologerProfile/chat_with_assistant_screen.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:BharatiyAstro/widget/showReviewWidget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';
import '../../controllers/history_controller.dart';
import '../../utils/images.dart';
import '../callIntakeFormScreen.dart';

class AstrologerProfile extends BaseRoute {
  final int index;
  AstrologerProfile({a, o, required this.index}) : super(a: a, o: o, r: 'astologerProfile');
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  final ReviewController reviewController = Get.find<ReviewController>();
  WalletController walletController = Get.find<WalletController>();
  RazorPayController razorPay = Get.find<RazorPayController>();
  SplashController splashController = Get.find<SplashController>();
  ScreenshotController screenshotController = ScreenshotController();
  BottomNavigationController bottomNavigationController2 = Get.find<BottomNavigationController>();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  HistoryController historyController = Get.put(HistoryController());

  Future<void> dialogForJoinInWaitList(context, String astrologerName, bool forChat) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Get.theme.primaryColor,
                child: CachedNetworkImage(
                  imageUrl: "${global.imgBaseurl}${bottomNavigationController2.astrologerbyId[0].profileImage}",
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: imageProvider,
                    );
                  },
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) {
                    return Container(
                      child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            Images.deafultUser,
                            fit: BoxFit.fill,
                            height: 50,
                          )),
                    );
                  },
                ),
              ),
              Container(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "$astrologerName",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'If you join the waitlist,we will notify $astrologerName to take the session, if possible',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                          top: 10,
                          right: 20,
                        ),
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.back();
                        if (forChat == true) {
                          await bottomNavigationController.checkAlreadyInReq(bottomNavigationController.astrologerbyId[0].id!);
                          if (bottomNavigationController.isUserAlreadyInChatReq == false) {
                            global.showOnlyLoaderDialog(Get.context);
                            if (bottomNavigationController.astrologerbyId[0].chatWaitTime != null) {
                              if (bottomNavigationController.astrologerbyId[0].chatWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                await bottomNavigationController.changeOfflineStatus(bottomNavigationController.astrologerbyId[0].id!, "Online");
                              }
                            }
                            double charge = double.parse(bottomNavigationController.astrologerbyId[0].charge!.toString());
                                                            log("===${ bottomNavigationController.astrologerbyId[0].isFreeAvailable == true}========${charge
                                   * 5 <= global.splashController.currentUser!.walletAmount!}===================================>${global.splashController.currentUser!.walletAmount!}");
                            if (charge * 5 <= global.splashController.currentUser!.walletAmount!) {
                              await Get.to(() => CallIntakeFormScreen(
                                    type: "Chat",
                                    astrologerId: bottomNavigationController.astrologerbyId[0].id!,
                                    astrologerName: bottomNavigationController.astrologerbyId[0].name!,
                                    astrologerProfile: bottomNavigationController.astrologerbyId[0].profileImage!,
                                    isFreeAvailable: bottomNavigationController.astrologerbyId[0].isFreeAvailable!,
                                  )
                                  );
                            }
                            global.hideLoader();
                          } else {
                            bottomNavigationController.dialogForNotCreatingSession(Get.context);
                          }
                        } else {
                          await bottomNavigationController.checkAlreadyInReqForCall(bottomNavigationController.astrologerbyId[0].id!);
                          if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                            global.showOnlyLoaderDialog(context);
                            //need to check for already in req list
                            if (bottomNavigationController.astrologerbyId[0].callWaitTime != null) {
                              if (bottomNavigationController.astrologerbyId[0].callWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                await bottomNavigationController.changeOfflineCallStatus(bottomNavigationController.astrologerbyId[0].id!, "Online");
                              }
                            }
                            double charge = double.parse(bottomNavigationController.astrologerbyId[0].charge!.toString());
                            if (charge * 5 <= global.splashController.currentUser!.walletAmount! 
                            // ||
                            //     bottomNavigationController.astrologerbyId[0].isFreeAvailable! == true
                                ) {
                              await Get.to(() => CallIntakeFormScreen(
                                    astrologerProfile: bottomNavigationController.astrologerbyId[0].profileImage!,
                                    type: "Call",
                                    astrologerId: bottomNavigationController.astrologerbyId[0].id!,
                                    astrologerName: bottomNavigationController.astrologerbyId[0].name!,
                                    isFreeAvailable: bottomNavigationController.astrologerbyId[0].isFreeAvailable!,
                                  ));
                            }
                            global.hideLoader();
                          } else {
                            bottomNavigationController.dialogForNotCreatingSession(Get.context);
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Get.theme.primaryColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "Join Waitlist",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
            title: Text(
              'Profile',
              style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  ChatController chatController = Get.find<ChatController>();
                  global.showOnlyLoaderDialog(context);
                  await FlutterShare.share(
                          title: '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}',
                          text:
                              "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to Astrology.You should also try and see your future  https://play.google.com/store/apps/details?id=com.bharatiyastro.userapp")
                      .then((value) {})
                      .catchError((e) {
                    print(e);
                  });
                  global.hideLoader();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          Images.whatsapp,
                          height: 40,
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: Text('Share', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ]),
        body: SingleChildScrollView(
          child: GetBuilder<BottomNavigationController>(builder: (bController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bottomNavigationController.astrologerbyId[0].isBlock!
                    ? const SizedBox()
                    : SizedBox(
                        height: 10,
                      ),

                GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                  return bottomNavigationController.astrologerbyId[0].isBlock!
                      ? Container(
                          decoration: BoxDecoration(color: Colors.red),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'You have blocked the astrologer',
                                style: TextStyle(color: Colors.white),
                              ),
                              GetBuilder<SettingsController>(builder: (settingsController) {
                                return TextButton(
                                  onPressed: () async {
                                    global.showOnlyLoaderDialog(context);
                                    await settingsController.unblockAstrologer(bottomNavigationController.astrologerbyId[0].id!);
                                    global.hideLoader();
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                    fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                    backgroundColor: MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Unblock',
                                    style: Get.theme.primaryTextTheme.bodySmall,
                                  ),
                                );
                              })
                            ],
                          ),
                        )
                      : SizedBox();
                }),

                GetBuilder<BottomNavigationController>(builder: (bottomController) {
                  return Screenshot(
                    controller: screenshotController,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Get.theme.primaryColor)),
                                        child: CircleAvatar(
                                          radius: 36,
                                          backgroundColor: Colors.white,
                                          child: CachedNetworkImage(
                                            imageUrl: "${global.imgBaseurl}${bottomController.astrologerbyId[0].profileImage}",
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
                                    bottomController.astrologerbyId[0].isFollow!
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Get.theme.primaryColor,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                'Following',
                                                style: Get.textTheme.bodyText2!.copyWith(fontSize: 10, color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: GetBuilder<FollowAstrologerController>(builder: (followAstrologerController) {
                                                return InkWell(
                                                  onTap: () async {
                                                    log('message');
                                                    bool isLogin = await global.isLogin();
                                                    if (isLogin) {
                                                      global.showOnlyLoaderDialog(context);
                                                      await followAstrologerController.addFollowers(bottomNavigationController.astrologerbyId[0].id!);
                                                      global.hideLoader();
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: Get.theme.primaryColor,
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child: Text(
                                                      'Follow',
                                                      style: Get.textTheme.bodyText2!.copyWith(fontSize: 10, color: Colors.black),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            )),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              bottomController.astrologerbyId[0].name!,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Image.asset(
                                              Images.right,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        bottomController.astrologerbyId[0].primarySkill == ""
                                            ? const SizedBox()
                                            : Text(
                                                '${bottomController.astrologerbyId[0].primarySkill!}',
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                        // bottomController.astrologerbyId[0].currentCity == ""
                                        //     ? const SizedBox()
                                        //     : Text(
                                        //         bottomController.astrologerbyId[0].currentCity!,
                                        //         style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                        //           fontWeight: FontWeight.w300,
                                        //           color: Colors.grey[600],
                                        //         ),
                                        //       ),
                                        bottomController.astrologerbyId[0].languageKnown == ""
                                            ? const SizedBox()
                                            : Text(
                                                bottomController.astrologerbyId[0].languageKnown!,
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                        Text(
                                          'Experience : ${bottomController.astrologerbyId[0].experienceInYears} Years',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            // bottomController.astrologerbyId[0].isFreeAvailable == true
                                            //     ? Text(
                                            //         'FREE',
                                            //         style: Get.theme.textTheme.subtitle1!.copyWith(
                                            //           fontSize: 12,
                                            //           fontWeight: FontWeight.w500,
                                            //           letterSpacing: 0,
                                            //           color: Color.fromARGB(255, 167, 1, 1),
                                            //         ),
                                            //       )
                                            //     : const SizedBox(),
                                            // SizedBox(
                                            //   width: bottomController.astrologerbyId[0].isFreeAvailable == true ? 10 : 0,
                                            // ),
                                            Text(
                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${bottomController.astrologerbyId[0].charge}/min',
                                              style: Get.theme.textTheme.subtitle1!.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0,
                                                // decoration:
                                                //     bottomController.astrologerbyId[0].isFreeAvailable == true ? TextDecoration.lineThrough : null,
                                                color: 
                                                // bottomController.astrologerbyId[0].isFreeAvailable == true
                                                //     ? Colors.grey
                                                //     : 
                                                    Color.fromARGB(255, 167, 1, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                    ),
                                    onSelected: (value) async {
                                      if (value == "block") {
                                        bottomController.blockAstrologerController.clear();
                                        bool isLogin = await global.isLogin();
                                        if (isLogin) {
                                          Get.dialog(AlertDialog(
                                            scrollable: true,
                                            title: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                      onTap: () async {
                                                        Get.back();
                                                      },
                                                      child: Image.asset(
                                                        Images.closeRound,
                                                        height: 25,
                                                        width: 25,
                                                      )),
                                                ),
                                                Text(
                                                  'Report & Block',
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            content: SizedBox(
                                              height: Get.height * 0.5,
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 36,
                                                    backgroundColor: Get.theme.primaryColor,
                                                    child: CircleAvatar(
                                                      radius: 36,
                                                      backgroundColor: Colors.yellow,
                                                      child: CachedNetworkImage(
                                                        imageUrl: "${global.imgBaseurl}${bottomController.astrologerbyId[0].profileImage}",
                                                        imageBuilder: (context, imageProvider) {
                                                          return CircleAvatar(
                                                            radius: 35,
                                                            backgroundColor: Colors.white,
                                                            backgroundImage: imageProvider,
                                                          );
                                                        },
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
                                                  Center(
                                                    child: Text(
                                                      '${bottomController.astrologerbyId[0].name}',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Center(child: Text('Reason for blocking*')),
                                                  FutureBuilder(
                                                      future: global.translatedText('Write your reason...'),
                                                      builder: (context, snapshot) {
                                                        return TextField(
                                                          controller: bottomController.blockAstrologerController,
                                                          keyboardType: TextInputType.multiline,
                                                          minLines: 3,
                                                          maxLines: 3,
                                                          decoration: InputDecoration(
                                                            isDense: true,
                                                            hintText: snapshot.data,
                                                            helperStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                                            border: OutlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.grey),
                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.grey),
                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.grey),
                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      global.showOnlyLoaderDialog(context);
                                                      await bottomController.astrologerReportAndBlock(bottomController.astrologerbyId[0].id!);
                                                      global.hideLoader();
                                                      Get.back();
                                                    },
                                                    child: Text('Submit'),
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                      foregroundColor: MaterialStateProperty.all(Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                    '*You can unblock the astrologer from settings section.',
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                        }
                                      }

                                      if (value == "unblock") {
                                        SettingsController settingsController = Get.find<SettingsController>();
                                        global.showOnlyLoaderDialog(context);
                                        await settingsController.unblockAstrologer(bottomNavigationController.astrologerbyId[0].id!);
                                        global.hideLoader();
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: bottomNavigationController.astrologerbyId[0].isBlock! ? Text('Unblock') : Text('Report & Block'),
                                            value: bottomNavigationController.astrologerbyId[0].isBlock! ? "unblock" : "block",
                                          ),
                                        ]),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      print('chat');
                                      bool isLogin = await global.isLogin();
                                      if (isLogin) {
                                        double charge = double.parse(bottomNavigationController.astrologerbyId[0].charge!.toString());
                                  log("===${ bottomNavigationController.astrologerbyId[0].isFreeAvailable == true}========${charge
                                   * 5 <= global.splashController.currentUser!.walletAmount!}===================================>${global.splashController.currentUser!.walletAmount!}");
                                        if (charge * 5 <= global.splashController.currentUser!.walletAmount!) {
                                          if (bottomNavigationController.astrologerbyId[0].chatStatus == "Online" ||
                                              bottomNavigationController.astrologerbyId[0].chatStatus == "Wait Time") {
                                            await bottomNavigationController.checkAlreadyInReq(bottomNavigationController.astrologerbyId[0].id!);

                                            if (bottomNavigationController.isUserAlreadyInChatReq == false) {
                                              global.showOnlyLoaderDialog(context);
                                              if (bottomNavigationController.astrologerbyId[0].chatWaitTime != null) {
                                                if (bottomNavigationController.astrologerbyId[0].chatWaitTime!.difference(DateTime.now()).inMinutes <
                                                    0) {
                                                  await bottomNavigationController.changeOfflineStatus(
                                                      bottomNavigationController.astrologerbyId[0].id!, "Online");
                                                }
                                              }

                                              await Get.to(() => CallIntakeFormScreen(
                                                    type: "Chat",
                                                    astrologerId: bottomNavigationController.astrologerbyId[0].id!,
                                                    astrologerName: bottomNavigationController.astrologerbyId[0].name!,
                                                    astrologerProfile: bottomNavigationController.astrologerbyId[0].profileImage!,
                                                    isFreeAvailable: bottomNavigationController.astrologerbyId[0].isFreeAvailable!,
                                                  ));
                                              global.hideLoader();
                                            } else {
                                              bottomNavigationController.dialogForNotCreatingSession(context);
                                            }
                                          } else if (bottomNavigationController.astrologerbyId[0].chatStatus == "Offline") {
                                            dialogForJoinInWaitList(context, bottomNavigationController.astrologerbyId[0].name!, true);
                                          }
                                        } else {
                                          global.showOnlyLoaderDialog(context);
                                          await walletController.getAmount();
                                          global.hideLoader();
                                          openBottomSheetRechrage(
                                              context, (charge * 5).toString(), '${bottomNavigationController.astrologerbyId[0].name}');
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.chat,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("${bottomNavigationController.astrologerbyId[0].chatMin!} Mins"),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    thickness: 2,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      print('call');
                                      bool isLogin = await global.isLogin();
                                      if (isLogin) {
                                        double charge = double.parse(bottomNavigationController.astrologerbyId[0].charge!.toString());
                                        if (charge * 5 <= global.splashController.currentUser!.walletAmount!
                                        //  ||
                                        //     bottomNavigationController.astrologerbyId[0].isFreeAvailable == true
                                            ) {
                                          if (bottomNavigationController.astrologerbyId[0].callStatus == "Online" ||
                                              bottomNavigationController.astrologerbyId[0].callStatus == "Wait Time") {
                                            await bottomNavigationController
                                                .checkAlreadyInReqForCall(bottomNavigationController.astrologerbyId[0].id!);
                                            if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                                              global.showOnlyLoaderDialog(context);
                                              if (bottomNavigationController.astrologerbyId[0].callWaitTime != null) {
                                                if (bottomNavigationController.astrologerbyId[0].callWaitTime!.difference(DateTime.now()).inMinutes <
                                                    0) {
                                                  await bottomNavigationController.changeOfflineCallStatus(
                                                      bottomNavigationController.astrologerbyId[0].id!, "Online");
                                                }
                                              }
                                              await Get.to(() => CallIntakeFormScreen(
                                                    astrologerProfile: bottomNavigationController.astrologerbyId[0].profileImage!,
                                                    type: "Call",
                                                    astrologerId: bottomNavigationController.astrologerbyId[0].id!,
                                                    astrologerName: bottomNavigationController.astrologerbyId[0].name!,
                                                    isFreeAvailable: bottomNavigationController.astrologerbyId[0].isFreeAvailable,
                                                  ));
                                              global.hideLoader();
                                            } else {
                                              bottomNavigationController.dialogForNotCreatingSession(context);
                                            }
                                          } else if (bottomNavigationController.astrologerbyId[0].callStatus == "Offline") {
                                            dialogForJoinInWaitList(context, bottomNavigationController.astrologerbyId[0].name!, false);
                                          }
                                        } else {
                                          global.showOnlyLoaderDialog(context);
                                          await walletController.getAmount();
                                          global.hideLoader();
                                          openBottomSheetRechrage(
                                              context, (charge * 5).toString(),  '${bottomNavigationController.astrologerbyId[0].name}');
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("${bottomNavigationController.astrologerbyId[0].callMin!} mins"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: Get.width,
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GetBuilder<UserProfileController>(builder: (userProfileController) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bottomNavigationController.astrologerbyId[0].loginBio!,
                              maxLines: userProfileController.isShowMore ? null : 2,
                              style: Get.textTheme.subtitle1!.copyWith(fontSize: 14),
                            ),
                            InkWell(
                                onTap: () {
                                  userProfileController.showMoreText();
                                },
                                child: Text(
                                  userProfileController.isShowMore ? "Show less" : "..Show More",
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    margin: EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rating & Reviews'),
                              GestureDetector(
                                  onTap: () {
                                    reviewController.reviewList.isNotEmpty
                                        ? showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return ratingAndReview();
                                            })
                                        : global.showToast(
                                            message: 'There is no user review available for this astrologer!',
                                            textColor: global.textColor,
                                            bgColor: global.toastBackGoundColor,
                                          );
                                  },
                                  child: Icon(Icons.arrow_forward, color: Colors.grey))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${bottomNavigationController.astrologerbyId[0].rating!.toStringAsFixed(2)}',
                                    style: Get.textTheme.headline4,
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
                                      Icon(Icons.person, size: 14, color: Colors.grey),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${bottomNavigationController.astrologerbyId[0].totalOrder!} orders',
                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '5',
                                          style: Get.textTheme.subtitle1,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        LinearPercentIndicator(
                                          width: 200,
                                          lineHeight: 16,
                                          percent: bottomNavigationController.astrologerbyId[0].astrologerRating!.fiveStarRating != null
                                              ? bottomNavigationController.astrologerbyId[0].astrologerRating!.fiveStarRating! * 0.01
                                              : 0,
                                          progressColor: Colors.green,
                                          barRadius: Radius.circular(20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text('4', style: Get.textTheme.subtitle1),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        LinearPercentIndicator(
                                          width: 200,
                                          lineHeight: 16,
                                          percent: bottomNavigationController.astrologerbyId[0].astrologerRating!.fourStarRating != null
                                              ? bottomNavigationController.astrologerbyId[0].astrologerRating!.fourStarRating! * 0.01
                                              : 0,
                                          progressColor: Colors.blue,
                                          barRadius: Radius.circular(20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text('3', style: Get.textTheme.subtitle1),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        LinearPercentIndicator(
                                          width: 200,
                                          lineHeight: 16,
                                          percent: bottomNavigationController.astrologerbyId[0].astrologerRating!.threeStarRating != null
                                              ? bottomNavigationController.astrologerbyId[0].astrologerRating!.threeStarRating! * 0.01
                                              : 0,
                                          progressColor: Color.fromARGB(255, 135, 172, 235),
                                          barRadius: Radius.circular(20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text('2', style: Get.textTheme.subtitle1),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        LinearPercentIndicator(
                                          width: 200,
                                          lineHeight: 16,
                                          percent: bottomNavigationController.astrologerbyId[0].astrologerRating!.twoStarRating != null
                                              ? bottomNavigationController.astrologerbyId[0].astrologerRating!.twoStarRating! * 0.01
                                              : 0,
                                          progressColor: Colors.orange,
                                          barRadius: Radius.circular(20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text('1', style: Get.textTheme.subtitle1),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        LinearPercentIndicator(
                                          width: 200,
                                          lineHeight: 16,
                                          percent: bottomNavigationController.astrologerbyId[0].astrologerRating!.oneStarRating != null
                                              ? bottomNavigationController.astrologerbyId[0].astrologerRating!.oneStarRating! * 0.01
                                              : 0,
                                          progressColor: Colors.red,
                                          barRadius: Radius.circular(20),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                reviewController.reviewList.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('User Reviews'),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return ratingAndReview();
                                    });
                              },
                              child: Text(
                                'View All',
                                style: Get.textTheme.bodyText2!.copyWith(fontSize: 12, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),

                //Rating Review Page
                GetBuilder<ReviewController>(
                  builder: (controller) {
                    return ListView.builder(
                        itemCount: reviewController.reviewList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ShowReviewWidget(
                            index: index,
                            astologername: bottomNavigationController.astrologerbyId[0].name ?? "Astrologer",
                          );
                        });
                  },
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        builder: (context) {
                          return ratingAndReview();
                        });
                  },
                  child: reviewController.reviewList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Text(
                            'See all reviews',
                            style: Get.textTheme.subtitle1!.copyWith(color: Colors.green),
                          ),
                        )
                      : SizedBox(),
                ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        bottomNavigationController.astrologerbyId[0].similiarConsultant!.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Check Similar Astrologer'),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'People who spoke to this Consultant, also spoke to these Consultants. You may try them out!',
                                                    style: Get.textTheme.bodyText2,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  child: Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text('Ok'),
                                                      style: ButtonStyle(
                                                        maximumSize: MaterialStateProperty.all(Size(80, 40)),
                                                        foregroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Icon(Icons.info),
                                  )
                                ],
                              )
                            : SizedBox(),
                        bottomNavigationController.astrologerbyId[0].similiarConsultant!.isNotEmpty
                            ? GetBuilder<BottomNavigationController>(builder: (controller) {
                                return SizedBox(
                                  height: 135,
                                  child: Center(
                                    child: ListView.builder(
                                        itemCount: bottomNavigationController.astrologerbyId[0].similiarConsultant!.length,
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              log('similar consultant id:- ${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].id!}');
                                              Get.find<ReviewController>()
                                                  .getReviewData(bottomNavigationController.astrologerbyId[0].similiarConsultant![index].id!);
                                              global.showOnlyLoaderDialog(context);
                                              await bottomNavigationController
                                                  .getAstrologerbyId(bottomNavigationController.astrologerbyId[0].similiarConsultant![index].id!);
                                              global.hideLoader();
                                            },
                                            child: Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: CircleAvatar(
                                                        radius: 36,
                                                        backgroundColor: Get.theme.primaryColor,
                                                        child: CircleAvatar(
                                                          radius: 36,
                                                          backgroundColor: Colors.yellow,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                "${global.imgBaseurl}${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].profileImage}",
                                                            imageBuilder: (context, imageProvider) {
                                                              return CircleAvatar(
                                                                radius: 35,
                                                                backgroundColor: Colors.white,
                                                                backgroundImage: imageProvider,
                                                              );
                                                            },
                                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                            errorWidget: (context, url, error) {
                                                              return CircleAvatar(
                                                                  radius: 35,
                                                                  backgroundColor: Colors.white,
                                                                  child: Image.asset(
                                                                    Images.deafultUser,
                                                                    fit: BoxFit.fill,
                                                                    height: 40,
                                                                  ));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      bottomNavigationController.astrologerbyId[0].similiarConsultant![index].name ?? 'Astrologer',
                                                      textAlign: TextAlign.center,
                                                      style: Get.theme.textTheme.subtitle1!.copyWith(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w400,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].charge}/min',
                                                      textAlign: TextAlign.center,
                                                      style: Get.theme.textTheme.subtitle1!.copyWith(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w300,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                );
                              })
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Card(
                    margin: EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        // InkWell(
                        //     onTap: () async {
                        //       bool isLogin = await global.isLogin();
                        //       if (isLogin) {
                        //         AstrologerAssistantController astrologerAssistantController = Get.find<AstrologerAssistantController>();
                        //         global.showOnlyLoaderDialog(context);
                        //         await astrologerAssistantController.checkPaidSession(bottomNavigationController.astrologerbyId[0].id!);
                        //         global.hideLoader();
                        //         if (astrologerAssistantController.isPaidSession) {
                        //           global.showOnlyLoaderDialog(context);
                        //           await astrologerAssistantController.storeChatId(bottomNavigationController.astrologerbyId[0].id!);
                        //           global.hideLoader();
                        //           Get.to(() => ChatWithAstrologerAssistantScreen(
                        //                 flagId: 1,
                        //                 profileImage: '',
                        //                 astrologerName: bottomNavigationController.astrologerbyId[0].name!,
                        //                 fireBasechatId: astrologerAssistantController.firebaseChatId,
                        //                 astrologerId: bottomNavigationController.astrologerbyId[0].id!,
                        //                 chatId: 1,
                        //               ));
                        //         } else {
                        //           showDialog(
                        //               context: context,
                        //               builder: (context) {
                        //                 return Padding(
                        //                   padding: const EdgeInsets.all(13),
                        //                   child: SimpleDialog(
                        //                     titlePadding: EdgeInsets.all(8.0),
                        //                     insetPadding: EdgeInsets.all(8.0),
                        //                     contentPadding: EdgeInsets.all(8.0),
                        //                     children: [
                        //                       Text(
                        //                         'You can chat with astrologer\'s assistant only when you have taken a paid session with the astrologer',
                        //                         style: Get.textTheme.bodyText2,
                        //                       ),
                        //                       Center(
                        //                         child: SizedBox(
                        //                           width: 80,
                        //                           child: ElevatedButton(
                        //                             onPressed: () {
                        //                               Get.back();
                        //                             },
                        //                             child: Text('Ok'),
                        //                             style: ButtonStyle(
                        //                               maximumSize: MaterialStateProperty.all(Size(80, 40)),
                        //                               backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                        //                               foregroundColor: MaterialStateProperty.all(Colors.black),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 );
                        //               });
                        //         }
                        //       }
                        //     },
                        //     child: menuItem(Icons.contact_support_outlined, "Chat With Assistant")),
                        GetBuilder<BottomNavigationController>(builder: (bottomController) {
                          return InkWell(
                              onTap: () async {
                                global.showOnlyLoaderDialog(context);
                                await bottomController.getAstrologerAvailibility(bottomController.astrologerbyId[0].id!);
                                global.hideLoader();
                                Get.to(() => AvailabilityScreen(
                                      astrologerName: bottomController.astrologerbyId[0].name!,
                                      astrologerProfile: bottomController.astrologerbyId[0].profileImage!,
                                    ));
                              },
                              child: menuItem(Icons.calendar_today, "Availability"));
                        }),
                        GetBuilder<GiftController>(builder: (giftController) {
                          return InkWell(
                            onTap: () async {
                              bool isLogin = await global.isLogin();
                              if (isLogin) {
                                global.showOnlyLoaderDialog(context);
                                await giftController.getGiftData();
                                global.hideLoader();
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Get.theme.primaryColor),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Container(
                                      height: 280,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Send ${bottomNavigationController.astrologerbyId[0].name} a Gift'),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Icon(Icons.close))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: GetBuilder<GiftController>(builder: (c) {
                                              return ListView(children: [
                                                Center(
                                                  child: Wrap(
                                                    children: [
                                                      for (int index = 0; index < giftController.giftList.length; index++)
                                                        SizedBox(
                                                          height: 100,
                                                          width: 110,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print('ontap');
                                                                  giftController.updateOntap(index);
                                                                },
                                                                child: Container(
                                                                  height: 60,
                                                                  width: 60,
                                                                  padding: const EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(
                                                                    color: giftController.giftList[index].isSelected ?? false
                                                                        ? Color.fromARGB(255, 196, 192, 192)
                                                                        : Colors.transparent,
                                                                  ),
                                                                  child: CachedNetworkImage(
                                                                    imageUrl: '${global.imgBaseurl}${giftController.giftList[index].image}',
                                                                    imageBuilder: (context, imageProvider) {
                                                                      return Image.network(
                                                                        "${global.imgBaseurl}${giftController.giftList[index].image}",
                                                                        height: 40,
                                                                        width: 40,
                                                                        fit: BoxFit.cover,
                                                                      );
                                                                    },
                                                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                    errorWidget: (context, url, error) {
                                                                      return Image.asset(
                                                                        Images.palmistry,
                                                                        fit: BoxFit.fill,
                                                                        height: 40,
                                                                        width: 40,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(giftController.giftList[index].name,
                                                                  style: Get.textTheme.bodyText2!.copyWith(fontSize: 12)),
                                                              Text(
                                                                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${giftController.giftList[index].amount}',
                                                                  style: Get.textTheme.bodyText2!.copyWith(fontSize: 10, color: Colors.grey))
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ]);
                                            }),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('Wallet Balance', style: Get.textTheme.bodyText2!.copyWith(fontSize: 12)),
                                                    Text(
                                                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}'),
                                                  ],
                                                ),
                                                Container(
                                                  width: 110,
                                                  height: 40,
                                                  child: TextButton(
                                                      child: Text('Recharge', style: TextStyle(fontSize: 10)),
                                                      style: ButtonStyle(
                                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
                                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                          backgroundColor: MaterialStateProperty.all(Colors.yellow.shade100),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            side: BorderSide(color: Colors.yellow.shade200),
                                                          ))),
                                                      onPressed: () async {
                                                        global.showOnlyLoaderDialog(context);
                                                        await walletController.getAmount();
                                                        global.hideLoader();
                                                        Get.back();
                                                        openBottomSheetRechrage(context, '', '');
                                                      }),
                                                ),
                                                Container(
                                                  width: 110,
                                                  height: 40,
                                                  child: TextButton(
                                                      child: Text('Send Gift', style: TextStyle(fontSize: 10)),
                                                      style: ButtonStyle(
                                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
                                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                          backgroundColor: MaterialStateProperty.all(Colors.grey.shade100),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.black12)))),
                                                      onPressed: () async {
                                                        if (giftController.giftSelectIndex != null) {
                                                          double wallet = global.splashController.currentUser?.walletAmount ?? 0.0;
                                                          if (wallet < giftController.giftList[giftController.giftSelectIndex!].amount) {
                                                            global.showToast(
                                                              message: 'you do not have sufficient balance',
                                                              textColor: global.textColor,
                                                              bgColor: global.toastBackGoundColor,
                                                            );
                                                          } else {
                                                            global.showOnlyLoaderDialog(context);
                                                            await giftController.sendGift(
                                                                giftController.giftList[giftController.giftSelectIndex!].id,
                                                                bottomNavigationController.astrologerbyId[0].id!,
                                                                double.parse(
                                                                    giftController.giftList[giftController.giftSelectIndex!].amount.toString()));
                                                            global.hideLoader();
                                                          }
                                                        } else {
                                                          global.showToast(
                                                            message: 'Please select gift',
                                                            textColor: global.textColor,
                                                            bgColor: global.toastBackGoundColor,
                                                          );
                                                        }
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                              return menuItem(CupertinoIcons.gift, "Send Gift To ${bottomNavigationController.astrologerbyId[0].name}");
                            }),
                          );
                        }),
                        GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                          return bottomNavigationController.astrologerbyId[0].isFollow!
                              ? const SizedBox()
                              : Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_add,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text('Follow ${bottomNavigationController.astrologerbyId[0].name}')
                                          ],
                                        ),
                                        Text(
                                          'Follow ${bottomNavigationController.astrologerbyId[0].name} to get notifed when they go live,come online or run an offers!',
                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 12, color: Colors.grey),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: GetBuilder<FollowAstrologerController>(builder: (followAstrologerController) {
                                            return InkWell(
                                              onTap: () async {
                                                log('message');
                                                bool isLogin = await global.isLogin();
                                                if (isLogin) {
                                                  global.showOnlyLoaderDialog(context);
                                                  await followAstrologerController.addFollowers(bottomNavigationController.astrologerbyId[0].id!);
                                                  global.hideLoader();
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Get.theme.primaryColor,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                  'Follow',
                                                  style: Get.textTheme.bodyText2!.copyWith(fontSize: 10, color: Colors.grey),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        }),
                      ]),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
        bottomNavigationBar: GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GetBuilder<ChatController>(builder: (chatController) {
                      return InkWell(
                        onTap: () async {
                          bool isLogin = await global.isLogin();
                          if (isLogin) {
                            double charge = double.parse(bottomNavigationController.astrologerbyId[0].charge!.toString());
                                  log("===${ bottomNavigationController.astrologerbyId[0].isFreeAvailable == true}========${charge
                                   * 5 <= global.splashController.currentUser!.walletAmount!}===================================>${global.splashController.currentUser!.walletAmount!}");
                            if (charge * 5 <= global.splashController.currentUser!.walletAmount! ) {
                              if (bottomNavigationController.astrologerbyId[0].chatStatus == "Online" ||
                                  bottomNavigationController.astrologerbyId[0].chatStatus == "Wait Time") {
                                await bottomNavigationController.checkAlreadyInReq(bottomNavigationController.astrologerbyId[0].id!);
                                if (bottomNavigationController.isUserAlreadyInChatReq == false) {
                                  global.showOnlyLoaderDialog(context);

                                  if (bottomNavigationController.astrologerbyId[0].chatWaitTime != null) {
                                    if (bottomNavigationController.astrologerbyId[0].chatWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                      await bottomNavigationController.changeOfflineStatus(
                                          bottomNavigationController.astrologerbyId[0].id!, "Online");
                                    }
                                  }

                                  await Get.to(() => CallIntakeFormScreen(
                                        type: "Chat",
                                        astrologerId: bottomNavigationController.astrologerbyId[0].id!,
                                        astrologerName: bottomNavigationController.astrologerbyId[0].name!,
                                        astrologerProfile: bottomNavigationController.astrologerbyId[0].profileImage!,
                                        isFreeAvailable: bottomNavigationController.astrologerbyId[0].isFreeAvailable,
                                        //index: index,
                                      ));
                                  global.hideLoader();
                                } else {
                                  bottomNavigationController.dialogForNotCreatingSession(context);
                                }
                              } else if (bottomNavigationController.astrologerbyId[0].chatStatus == "Offline") {
                                dialogForJoinInWaitList(context, bottomNavigationController.astrologerbyId[0].name!, true);
                              }
                            } else {
                              global.showOnlyLoaderDialog(context);
                              await walletController.getAmount();
                              global.hideLoader();
                              openBottomSheetRechrage(
                                  context, (charge * 5).toString(),'${bottomNavigationController.astrologerbyId[0].name}');
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Get.theme.primaryColor,
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                CupertinoIcons.chat_bubble_2,
                                color: bottomNavigationController.astrologerbyId[0].chatStatus == "Online" ? Colors.white : Colors.grey,
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        bottomNavigationController.astrologerbyId[0].chatStatus == "Online"
                                            ? Text(
                                                "Chat",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white),
                                              )
                                            : Text(
                                                "Chat",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                        bottomNavigationController.astrologerbyId[0].chatStatus == "Offline"
                                            ? Text(
                                                "Currently Offline",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                              )
                                            : bottomNavigationController.astrologerbyId[0].chatStatus == "Online"
                                                ? SizedBox()
                                                : Text(
                                                    bottomNavigationController.astrologerbyId[0].chatWaitTime!.difference(DateTime.now()).inMinutes >
                                                            0
                                                        ? "Wait till - ${bottomNavigationController.astrologerbyId[0].chatWaitTime!.difference(DateTime.now()).inMinutes} min"
                                                        : "Wait till",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                                  ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox()
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    child: GetBuilder<CallController>(builder: (callController) {
                      return InkWell(
                        onTap: () async {
                          bool isLogin = await global.isLogin();
                          if (isLogin) {
                            double charge = double.parse(bottomNavigationController.astrologerbyId[0].charge!.toString());
                            if (charge * 5 <= global.splashController.currentUser!.walletAmount!
                            //  ||
                            //     bottomNavigationController.astrologerbyId[0].isFreeAvailable == true
                                ) {
                              if (bottomNavigationController.astrologerbyId[0].callStatus == "Online" ||
                                  bottomNavigationController.astrologerbyId[0].callStatus == "Wait Time") {
                                await bottomNavigationController.checkAlreadyInReqForCall(bottomNavigationController.astrologerbyId[0].id!);
                                if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                                  global.showOnlyLoaderDialog(context);
                                  if (bottomNavigationController.astrologerbyId[0].callWaitTime != null) {
                                    if (bottomNavigationController.astrologerbyId[0].callWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                                      await bottomNavigationController.changeOfflineCallStatus(
                                          bottomNavigationController.astrologerbyId[0].id!, "Online");
                                    }
                                  }
                                  await Get.to(() => CallIntakeFormScreen(
                                        astrologerProfile: bottomNavigationController.astrologerbyId[0].profileImage!,
                                        type: "Call",
                                        astrologerId: bottomNavigationController.astrologerbyId[0].id!,
                                        astrologerName: bottomNavigationController.astrologerbyId[0].name!,
                                        isFreeAvailable: bottomNavigationController.astrologerbyId[0].isFreeAvailable,
                                      ));

                                  global.hideLoader();
                                } else {
                                  bottomNavigationController.dialogForNotCreatingSession(context);
                                }
                              } else if (bottomNavigationController.astrologerbyId[0].callStatus == "Offline") {
                                dialogForJoinInWaitList(context, bottomNavigationController.astrologerbyId[0].name!, false);
                              }
                            } else {
                              global.showOnlyLoaderDialog(context);
                              await walletController.getAmount();
                              global.hideLoader();
                              openBottomSheetRechrage(
                                  context, (charge * 5).toString(),  '${bottomNavigationController.astrologerbyId[0].name}');
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Get.theme.primaryColor,
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.call,
                                  color: bottomNavigationController.astrologerbyId[0].callStatus == "Online" ? Colors.white : Colors.grey),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        bottomNavigationController.astrologerbyId[0].callStatus == "Online"
                                            ? Text(
                                                "Call",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white),
                                              )
                                            : Text(
                                                "Call",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                        bottomNavigationController.astrologerbyId[0].callStatus == "Offline"
                                            ? Text(
                                                "Currently Offline",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                              )
                                            : bottomNavigationController.astrologerbyId[0].callStatus == "Online"
                                                ? SizedBox()
                                                : Text(
                                                    bottomNavigationController.astrologerbyId[0].callWaitTime!.difference(DateTime.now()).inMinutes >
                                                            0
                                                        ? "Wait till - ${bottomNavigationController.astrologerbyId[0].callWaitTime!.difference(DateTime.now()).inMinutes} min"
                                                        : "Wait till",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                                  ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox()
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget menuItem(IconData icon, String s) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey,
                ),
                SizedBox(width: 5),
                Text(s),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Widget ratingAndReview() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(onTap: () => Get.back(), child: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back)),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Rating and Reviews'),
                  ],
                ),
              ],
            ),
            Expanded(
              child: GetBuilder<ReviewController>(builder: (r) {
                return ListView.builder(
                    itemCount: reviewController.reviewList.length,
                    itemBuilder: (context, index) {
                      return ShowReviewWidget(
                        index: index,
                        astologername: bottomNavigationController.astrologerbyId[0].name ?? "AStrologer",
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(String name, String image, callBack, bool isVideo) {
    return InkWell(
      onTap: callBack,
      child: Container(
        height: !isVideo ? 38 : 38,
        width: !isVideo ? 100 : 120,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(offset: Offset(1, 1), color: Colors.black.withOpacity(0.15), blurRadius: 8, spreadRadius: 0)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                image,
                height: 25,
                width: 20,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$name',
              style: Get.theme.primaryTextTheme.labelMedium!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 21, 123, 17)),
            )
          ],
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
          SingleChildScrollView(
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
