

import 'dart:developer';

import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/model/astrologer_model.dart';
import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:BharatiyAstro/model/live_asrtrologer_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:BharatiyAstro/views/chatScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../model/astrologer_availability_model.dart';
import '../utils/global.dart' as global;
import '../utils/images.dart';
import '../views/callIntakeFormScreen.dart';
import '../views/callScreen.dart';
import '../views/historyScreen.dart';
import '../views/homeScreen.dart';
import '../views/liveAstrologerList.dart';
//views

class BottomNavigationController extends GetxController {
  int bottomNavIndex = 0.obs();
  int historyIndex = 0;
  APIHelper apiHelper = APIHelper();
   List<AstrologerModel> astrologerList = <AstrologerModel>[];
  List<AstrologerModel> astrologerbyId = <AstrologerModel>[];
  List<LiveAstrologerModel> liveAstrologer = [];
  List<AstrologerAvailibilityModel> astrologerAvailavility = [];
  LiveController liveController = Get.put(LiveController());
  SplashController splashController = Get.find<SplashController>();
  ScrollController scrollController = ScrollController();
  ScrollController callScrollController = ScrollController();
  ScrollController getReportscrollController = ScrollController();
  final GlobalKey<ScaffoldState> callScaffoldKey = GlobalKey<ScaffoldState>();
  int fetchRecord = 20;
  int startIndex = 0;
  String bottomText = "";
  String bottomTextChat = "";
  String bottomTextLive = "";
  String bottomTextCall = "";
  String bottomTextHist = "";
  bool isValueShow = false;
  bool isValueShowChat = false;
  bool isValueShowLive = false;
  bool isValueShowCall = false;
  bool isValueShowHist = false;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  String liveToken = "";
  String liveChannel = "";
  String astrologerName = "";
  bool isFollow = false;
  List<LiveAstrologerModel> anotherLiveAstrologers = [];
  int selectedLiveAstroIndex = 0;
  bool isUserAlreadyInChatReq = false;
  bool isUserAlreadyInCallReq = false;
 bool  isUserAlreadyInVideoCallReq = false;
  String chatToken = "";
  double? charge;
  double? videoCallCharge;
  String astrologerProfile = "";
  bool applyFilter = false;
  int? astrologerId;
  TextEditingController blockAstrologerController = TextEditingController();
  List<int>? skillFilterList;
  List<int>? languageFilter;
  List<String>? genderFilterList;
  int? categoryId;
  KundliModel? userModel;
  String? sortBy;
  String? sortingFilter = ''.obs();
  int? selectedCatId;
  bool isCallAstroDataLoadedOnce = false;
  bool isChatAstroDataLoadedOnce = false;
  List<Widget> screens() => [
        HomeScreen(userDetails: userModel),
       ChatScreen(),
        LiveAstrologerListScreen(isFromBottom: true),
        // CallScreen(),
          ChatScreen(),
        HistoryScreen(
          currentIndex: historyIndex,
        ),
      ];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }





var appVersion = "";


 getAppVersion() {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
    update();
  });
  return appVersion;
} 





  void paginateTask() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        update();
        if (selectedCatId == null || selectedCatId! == 0) {
          await getAstrologerList(skills: skillFilterList, gender: genderFilterList, language: languageFilter, sortBy: sortingFilter, isLazyLoading: true);
        } else {
          await astroCat(skills: skillFilterList, gender: genderFilterList, language: languageFilter, sortBy: sortingFilter, id: selectedCatId!, isLazyLoading: true);
        }
      }
    });

    getReportscrollController.addListener(() async {
      if (getReportscrollController.position.pixels == getReportscrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        update();
        await getAstrologerList(skills: skillFilterList, gender: genderFilterList, language: languageFilter, sortBy: sortingFilter, isLazyLoading: true);
      }
    });
  }

  setIndex(int index, int histIndexx) {
    int currentIndex = index;

    currentIndex = index;

    if (currentIndex == 1 || currentIndex == 3) {
      startIndex = 0;
      astrologerList.clear();
      isAllDataLoaded = false;
      print("on bottom ${astrologerList.length}");
      getAstrologerList(isLazyLoading: false);
    }
    if (currentIndex == 0) {
      getLiveAstrologerList();
    }

    setBottomIndex(currentIndex, histIndexx);
    currentIndex = 0;
  }

  Future<void> dialogForJoinInWaitListForListPageOnly(context, String astrologerName, bool forChat, int astrologerId, String astroProfile, int charge, bool isFree) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Get.theme.primaryColor,
                child: CachedNetworkImage(
                  imageUrl: "${global.imgBaseurl}$astroProfile",
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
                          global.showOnlyLoaderDialog(Get.context);
                          bool isLogin = await global.isLogin();
                          if (isLogin) {
                            if (charge * 5 <= global.splashController.currentUser!.walletAmount! 
                            // || isFree == true
                            ) {
                              await Get.to(() => CallIntakeFormScreen(
                                    type: "Chat",
                                    astrologerId: astrologerId,
                                    astrologerName: astrologerName,
                                    astrologerProfile: astrologerProfile,
                                    isFreeAvailable: isFree,
                                  ));
                            } else {
                              global.showToast(message: 'Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${charge * 5}) is required to start chat with $astrologerName', textColor: global.textColor, bgColor: global.toastBackGoundColor);
                            }
                          }
                          global.hideLoader();
                        } else {
                          global.showOnlyLoaderDialog(context);
                          bool isLogin = await global.isLogin();
                          if (isLogin) {
                            if (charge * 5 <= global.splashController.currentUser!.walletAmount! 
                            // || isFree == true
                            ) {
                              await Get.to(() => CallIntakeFormScreen(
                                    astrologerProfile: astrologerProfile,
                                    type: "Call",
                                    astrologerId: astrologerId,
                                    astrologerName: astrologerName,
                                    isFreeAvailable: isFree,
                                  ));
                            } else {
                              global.showToast(message: 'Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${charge * 5}) is required to start call with $astrologerName', textColor: global.textColor, bgColor: global.toastBackGoundColor);
                            }
                          }
                          global.hideLoader();
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

  Future<void> dialogForNotCreatingSession(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Request is already found.You can't make 2 session at the same time",
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
                        padding: EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }


void openBottomPopup() {
  Get.bottomSheet(
    Container(
      height: 1,
      padding: EdgeInsets.all(8),
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 15,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width:Get.width*90,
                child: Text('Congratulation,Your chat Accepted  by Astrologer',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                ),
                
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                           Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                            Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                               Get.back();
                          Get.to(()=>ChatScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
        ],
      ),
      // Your bottom popup content goes here
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
        ),  
    ),
  );
}


  Future<void> bindLiveAstroInfo({String? token, String? astroName, String? astroProfile, int? astrologerId, String? chatToken, double? charge2, String? channelName2}) async {
    liveToken = token!;
    liveChannel = channelName2!;
    astrologerName = astroName!;
    astrologerProfile = astroProfile!;
    astrologerId = astrologerId;
    chatToken = chatToken;
    charge = charge2;
    anotherLiveAstrologers = liveAstrologer.where((element) => element.astrologerId != astrologerId).toList();
    await liveController.getWaitList(channelName2);
    int index2 = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
    if (index2 != -1) {
      liveController.isImInWaitList = true;
      liveController.update();
    } else {
      liveController.isImInWaitList = false;
      liveController.update();
    }
    liveController.isImInLive = true;
    liveController.isJoinAsChat = false;
    liveController.isLeaveCalled = false;
    liveController.update();
  }

  _init() async {
    paginateTask();
    await getLiveAstrologerList();
    await setBottomIndex(bottomNavIndex, historyIndex);
    int index = liveAstrologer.length;
    if (global.currentUserId != null) {
      await splashController.getCurrentUserData();
    }
    if (index > 0) {
      liveToken = liveAstrologer[0].token;
      liveChannel = liveAstrologer[0].channelName;
      astrologerName = liveAstrologer[0].name;
      astrologerProfile = liveAstrologer[0].profileImage ?? "";
      astrologerId = liveAstrologer[0].astrologerId;
      chatToken = liveAstrologer[0].chatToken;
      charge = liveAstrologer[0].charge;
      isFollow = liveAstrologer[0].isFollow!;
      videoCallCharge = liveAstrologer[0].videoCallRate;
      anotherLiveAstrologers = liveAstrologer.where((element) => element.astrologerId != liveAstrologer[0].astrologerId).toList();
      update();
    }

    update();
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    log('FcmToken : - $fcmToken');
  }

  getFristLiveAstrologer(int index) {
    if (liveAstrologer.isNotEmpty) {
      if (index > 0) {
        liveToken = liveAstrologer[0].token;
        liveChannel = liveAstrologer[0].channelName;
        astrologerName = liveAstrologer[0].name;
        astrologerProfile = liveAstrologer[0].profileImage ?? "";
        astrologerId = liveAstrologer[0].astrologerId;
        chatToken = liveAstrologer[0].chatToken;
        charge = liveAstrologer[0].charge;
        videoCallCharge = liveAstrologer[0].videoCallRate;
        anotherLiveAstrologers = liveAstrologer.where((element) => element.astrologerId != liveAstrologer[0].astrologerId).toList();
        update();
      }
    }
  }

  Future setBottomIndex(int index, int histIndex) async {
    try {
      bottomNavIndex = index;
      if (histIndex != 0) {
        historyIndex = histIndex;
      }
      if (index == 2) {
        if (liveAstrologer.isNotEmpty) {
          anotherLiveAstrologers = liveAstrologer.where((element) => element.astrologerId != liveAstrologer[index].astrologerId).toList();
          update();
        }
      }

      update();
    } catch (e) {
      print("Exception - BottomNavigationController.dart - setBottomIndex():" + e.toString());
    }
  }

  Future<dynamic> getAstrologerList({List<int>? skills, List<int>? language, List<String>? gender, String? sortBy, bool isLazyLoading = false}) async {
    try {
      startIndex = 0;
      if (astrologerList.isNotEmpty) {
        startIndex = astrologerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstrologer(sortingKey: sortBy, skills: skills, language: language, gender: gender, startIndex: startIndex, fetchRecords: fetchRecord).then((result) {
            if (result.status == "200") {
              astrologerList.addAll(result.recordList);
              log('astrologer list length ${astrologerList.length} ');
              if (result.recordList.length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerList :-" + e.toString());
    }
  }

  Future<dynamic> checkAlreadyInReq(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.checkUserAlreadyInChatReq(astorlogerId: astrologerId).then((result) {
            if (result.status == "200") {
              isUserAlreadyInChatReq = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerList :-" + e.toString());
    }
  }

  Future<dynamic> checkAlreadyInReqForCall(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.checkUserAlreadyInCallReq(astorlogerId: astrologerId).then((result) {
            if (result.status == "200") {
              isUserAlreadyInCallReq = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerList :-" + e.toString());
    }
  }


    Future<dynamic> checkAlreadyInReqForVideoCall(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.checkUserVideoAlreadyInCallReq(astorlogerId: astrologerId).then((result) {
            if (result.status == "200") {
              isUserAlreadyInVideoCallReq = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerList :-" + e.toString());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<String?> getTokenFromChannelName(String channelName) async {
    try {
      String token = "";
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getTokenFromChannel(channelName: channelName).then((result) {
            if (result.status == "200") {
              token = result.recordList;
              update();
            } else {
              token = "";
            }
          });
        }
      });
      return token;
    } catch (e) {
      print("Exception in getAstrologerList :-" + e.toString());
    }
  }

  astroCat({int? id, List<int>? skills, List<int>? language, List<String>? gender, String? sortBy, bool isLazyLoading = false}) async {
    try {
      startIndex = 0;
      if (astrologerList.isNotEmpty) {
        startIndex = astrologerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstrologer(sortingKey: sortBy, skills: skills, language: language, gender: gender, catId: id, startIndex: startIndex, fetchRecords: fetchRecord).then((result) {
            if (result.status == "200") {
              astrologerList.addAll(result.recordList);
              print('cat astrologer length :- ${astrologerList.length}');
              if (result.recordList.length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              if (result.recordList.length < 30) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }

              update();
            } else {
              global.showToast(
                message: 'Failed to get Category',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAstrocat():' + e.toString());
    }
  }

  getLiveAstrologerList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLiveAstrologer().then((result) {
            if (result.status == "200") {
              liveAstrologer = result.recordList;
            } else {}
            update();
          });
        }
      });
      // return liveAstrologer;
    } catch (e) {
      print("Exception in  getLiveAstrologerList:-" + e.toString());
    }
  }

  getAstrologerAvailibility(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAvailability(astrologerId).then((result) {
            if (result.status == "200") {
              astrologerAvailavility = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrologer available time',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
      return liveAstrologer;
    } catch (e) {
      print("Exception in  getLiveAstrologerList:-" + e.toString());
    }
  }

  Future<dynamic> getAstrologerbyId(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstrologerById(astrologerId, global.currentUserId).then((result) {
            log("astrologer=================================================>${result.recordList}");
            if (result.status == "200") {
              astrologerbyId = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Fail to get profile',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerbyId :-" + e.toString());
    }
  }

  Future<dynamic> astrologerReportAndBlock(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.reportAndBlockAstrologer(astrologerId, blockAstrologerController.text).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Astrologer Block Successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await getAstrologerbyId(astrologerId);
            } else {
              global.showToast(
                message: 'Fail block astrologer',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerbyId :-" + e.toString());
    }
  }

  Future<dynamic> changeOfflineStatus(int? astrologerId, String status) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.changeStatus(astrologerId: astrologerId, status: status).then((result) async {
            if (result.status == "200") {
            } else {
              global.showToast(
                message: 'Fail to get online offline astrologer status',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerbyId :-" + e.toString());
    }
  }

  Future<dynamic> changeOfflineCallStatus(int? astrologerId, String status) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.changeCallStatus(astrologerId: astrologerId, status: status).then((result) async {
            if (result.status == "200") {
            } else {
              global.showToast(
                message: 'Fail to get online offline astrologer status',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerbyId :-" + e.toString());
    }
  }
}
