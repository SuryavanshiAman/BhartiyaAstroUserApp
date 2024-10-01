// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/chatController.dart';
import 'package:BharatiyAstro/controllers/history_controller.dart';
import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../controllers/splashController.dart';
import '../controllers/walletController.dart';
import '../utils/global.dart' as global;

class BottomNavigationBarScreen extends StatelessWidget {
  final int index;

  BottomNavigationBarScreen({this.index = 0}) : super();

  int? currentIndex;
  List<IconData> iconList = [
    Icons.home,
    Icons.chat,
    Icons.live_tv,
    Icons.call,
    Icons.edit_calendar_sharp,
  ];
  final HomeController homeController = Get.find<HomeController>();
  HistoryController historyController = Get.find<HistoryController>();
  LiveController liveController = Get.find<LiveController>();
  ChatController chatController = Get.find<ChatController>();
  final WalletController walletController = Get.find<WalletController>();
  SplashController splashController = Get.find<SplashController>();
  BottomNavigationController bottomNavigationController =
      Get.find<BottomNavigationController>();
  List<String> tabList = [
    'Home',
    'Chat',
    'Live',
    'Call',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // global.exitAppDialog();
        return true;
      },
      child: GetBuilder<BottomNavigationController>(builder: (c) {
        return Scaffold(
            bottomNavigationBar: GetBuilder<BottomNavigationController>(
              builder: (c) {
                return SizedBox(
                  height: 60,
                  child: BottomNavigationBar(
                    iconSize: 30,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Get.theme.primaryColor,
                    unselectedItemColor: Colors.grey,
                    currentIndex: bottomNavigationController.bottomNavIndex,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedLabelStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 9, fontWeight: FontWeight.w300),
                    items: List.generate(iconList.length, (index) {
                      final translator = GoogleTranslator();
                      if (index == 0) {
                        if (bottomNavigationController.isValueShow == false) {
                          translator
                              .translate(tabList[index],
                                  to: splashController.currentLanguageCode)
                              .then(
                            (value) {
                              bottomNavigationController.bottomText =
                                  value.text;
                              bottomNavigationController.update();
                            },
                          );
                          bottomNavigationController.isValueShow = true;
                        }

                        return BottomNavigationBarItem(
                          icon: Icon(iconList[index]),
                          label: bottomNavigationController.bottomText,
                        );
                      } else if (index == 1) {
                        if (bottomNavigationController.isValueShowChat ==
                            false) {
                          translator
                              .translate(tabList[index],
                                  to: splashController.currentLanguageCode)
                              .then(
                            (value) {
                              bottomNavigationController.bottomTextChat =
                                  value.text;
                              bottomNavigationController.update();
                            },
                          );
                          bottomNavigationController.isValueShowChat = true;
                        }
                        return BottomNavigationBarItem(
                          icon: Icon(iconList[index]),
                          label: bottomNavigationController.bottomTextChat,
                        );
                      } else if (index == 2) {
                        if (bottomNavigationController.isValueShowLive ==
                            false) {
                          translator
                              .translate(tabList[index],
                                  to: splashController.currentLanguageCode)
                              .then(
                            (value) {
                              bottomNavigationController.bottomTextLive =
                                  value.text;
                              bottomNavigationController.update();
                            },
                          );
                          bottomNavigationController.isValueShowLive = true;
                        }
                        return BottomNavigationBarItem(
                          icon: Icon(iconList[index]),
                          label: bottomNavigationController.bottomTextLive,
                        );
                      } else if (index == 3) {
                        if (bottomNavigationController.isValueShowCall ==
                            false) {
                          translator
                              .translate(tabList[index],
                                  to: splashController.currentLanguageCode)
                              .then(
                            (value) {
                              bottomNavigationController.bottomTextCall =
                                  value.text;
                              bottomNavigationController.update();
                            },
                          );
                          bottomNavigationController.isValueShowCall = true;
                        }
                        return BottomNavigationBarItem(
                          icon: Icon(iconList[index]),
                          label: bottomNavigationController.bottomTextCall,
                        );
                      } else {
                        if (bottomNavigationController.isValueShowHist ==
                            false) {
                          translator
                              .translate(tabList[index],
                                  to: splashController.currentLanguageCode)
                              .then(
                            (value) {
                              bottomNavigationController.bottomTextHist =
                                  value.text;
                              bottomNavigationController.update();
                            },
                          );
                          bottomNavigationController.isValueShowHist = true;
                        }
                        return BottomNavigationBarItem(
                          icon: Icon(iconList[index]),
                          label: bottomNavigationController.bottomTextHist,
                        );
                      }
                    }),
                    elevation: 5,
                    onTap: (index) async {
                      if (index == 0) {
                        global.showOnlyLoaderDialog(context);
                        await homeController.getBanner();
                        await homeController.getBlog();
                        await homeController.getAstroNews();
                        await homeController.getMyOrder();
                        await homeController.getAstrologyVideos();
                        await homeController.getClientsTestimonals();
                        await walletController.getAmount();
                        await bottomNavigationController
                            .getLiveAstrologerList();
                        global.hideLoader();
                        bottomNavigationController.setBottomIndex(
                            index, bottomNavigationController.historyIndex);
                      } else if (index == 1 || index == 3) {
                        global.showOnlyLoaderDialog(context);
                        global.sp = await SharedPreferences.getInstance();
                        chatController.isSelected = 0;
                        chatController.update();
                        bottomNavigationController.astrologerList.clear();
                        bottomNavigationController.isAllDataLoaded = false;
                        bottomNavigationController.applyFilter = false;
                        bottomNavigationController.update();
                        await bottomNavigationController.getAstrologerList(
                            isLazyLoading: false);
                        global.hideLoader();
                        bottomNavigationController.setBottomIndex(
                            index, bottomNavigationController.historyIndex);
                      } else if (index == 2) {
                        // bool isLogin = await global.isLogin();
                        // if (isLogin) {
                        //   global.showOnlyLoaderDialog(context);
                        //   await bottomNavigationController.getLiveAstrologerList();
                        //   global.hideLoader();
                        //   bottomNavigationController.setBottomIndex(index, bottomNavigationController.historyIndex);
                        // }
                      } else if (index == 4) {
                        bool isLogin = await global.isLogin();
                        if (isLogin) {
                          global.showOnlyLoaderDialog(context);
                          await global.splashController.getCurrentUserData();
                          await historyController.getPaymentLogs(
                              global.currentUserId!, false);
                          historyController.walletTransactionList = [];
                          historyController.walletTransactionList.clear();
                          historyController.walletAllDataLoaded = false;
                          await historyController.getWalletTransaction(
                              global.currentUserId!, false);
                          global.hideLoader();
                          bottomNavigationController.setBottomIndex(
                              index, bottomNavigationController.historyIndex);
                        }
                      }
                    },
                  ),
                );
              },
            ),
            body: bottomNavigationController
                .screens()
                .elementAt(bottomNavigationController.bottomNavIndex));
      }),
    );
    //);
  }
}
