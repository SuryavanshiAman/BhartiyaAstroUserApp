import 'dart:async';
import 'dart:developer';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/main.dart';
import 'package:BharatiyAstro/model/messsage_model_live.dart';
import 'package:BharatiyAstro/model/live_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../model/wait_list_model.dart';
import '../utils/services/api_helper.dart';
import '../views/live_astrologer/live_astrologer_screen.dart';

class LiveController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  bool isImInLive = false;
  Timer? timer2;
  bool isImInWaitList = false;
  SplashController splashController = Get.put(SplashController());
  String? astrologerFcmToken;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  int historyIndex = 0;
  CollectionReference userChatCollectionRef = FirebaseFirestore.instance.collection("chats2");
  APIHelper apiHelper = APIHelper();
  String? appShareLinkForLiveSreaming;
  int totalCompletedTime = 0;
  bool isLeaveCalled = false;
  String? chatId;

  int totalCompletedTimeForChat = 0;
  bool isImSplitted = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
  bool isJoinAsChat = false;
  int? callId;
  String joinUserName = global.user.name ?? "User";
  String joinUserProfile = global.user.profile ?? "";

  Future uploadMessage(String idUser, int astrologerId, MessageModelLive anonymous) async {
    try {
      final int globalId = global.user.id!;
      log('live chat ID');
      final refMessages = userChatCollectionRef.doc(idUser).collection('userschat').doc(globalId.toString()).collection('messages');
      final refMessages1 = userChatCollectionRef.doc(idUser).collection('userschat').doc(astrologerId.toString()).collection('messages');
      final newMessage1 = anonymous;
      final newMessage2 = anonymous;
      var messageResult = await refMessages.add(newMessage1.toJson()).catchError((e) {
        print('send mess exception $e');
      });
      newMessage2.isRead = false;
      var message1Result = await refMessages1.add(newMessage2.toJson()).catchError((e) {
        print('send mess exception $e');
      });
      return {
        'user1': messageResult.id,
        'user2': message1Result.id,
      };
    } catch (err) {
      print('uploadMessage err $err');
    }
  }

  var liveUsers = <LiveUserModel>[];

  Future<dynamic> getWaitList(String channel) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.getWaitList(channel).then((result) {
            global.hideLoader();
            if (result.status == "200") {
              waitList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Fail to getWaitList',
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

  Future<void> createLiveAstrologerShareLink(String astrologerName, int astrologerId, String token, String channelName, double charge, double videoCallCharge) async {
    try {
      String appShareLink;
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://BharatiyAstroupdated.page.link',
        link: Uri.parse("https://BharatiyAstroupdated.page.link/userProfile?screen=liveStreaming&token='$token'&astrologerName=$astrologerName&astrologerId=$astrologerId&channelName=$channelName&charge=$charge&videoCallCharge=$videoCallCharge"),
        androidParameters: AndroidParameters(
          packageName: 'com.BharatiyAstro.app',
          minimumVersion: 1,
        ),
      );
      Uri url;
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
      url = shortLink.shortUrl;
      appShareLink = url.toString();
      appShareLinkForLiveSreaming = appShareLink;
      update();
      await FlutterShare.share(
        title: 'Watch $astrologerName live on BharatiyAstro app now - ',
        text: 'Watch $astrologerName live on BharatiyAstro app now - ',
        linkUrl: '$appShareLinkForLiveSreaming',
        chooserTitle: 'Watch $astrologerName live on BharatiyAstro app now - ',
      );
    } catch (e) {
      print("Exception - global.dart - referAndEarn():" + e.toString());
    }
  }

  Future<dynamic> updateWaitListStatus(int id, String status) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.updateStatusForWaitList(id: id, status: status).then((result) {
            global.hideLoader();
            if (result.status == "200") {
            } else {
              global.showToast(
                message: 'Fail to updateStatusForWaitList',
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

  Future<dynamic> cutPaymentForLive(int userId, int timeInSecond, int astrologerId, String transactionType, String chatId, {String? sId1, String? sId2, String? channelName}) async {
    try {
      print("SIDCut payment called");
      print('SID1:- $sId1');
      print('SID2:- $sId2');
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.cutPaymentForLiveStream(userId, astrologerId, timeInSecond, transactionType, chatId, sId1: sId1, sId2: sId2, channelName: channelName).then((result) {
            if (result.status == "200") {
              print("cutPaymentForLive +  ${result.recordList}");
              if (result.recordList.length != 0) {
                callId = result.recordList['callId'];
                print('after call');
                double deductedMoney = double.parse(result.recordList['deduction'].toString());
                update();
                print('deducted call Id $callId');
                print('deducted money $deductedMoney');
                double myTotoalWallteAmout = global.user.walletAmount!;
                myTotoalWallteAmout = myTotoalWallteAmout - deductedMoney;
                global.user.walletAmount = myTotoalWallteAmout;
              } else {
                callId = null;
              }
            } else {
              print('cut payment not done');

              global.showToast(
                message: 'Fail to cut payment',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in cutPaymentForLive :-" + e.toString());
    }
  }

  Future<dynamic> deleteFromWaitList(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteFromWishList(id).then((result) {
            if (result.status == "200") {
              waitList.removeWhere((element) => element.id == id);
              update();
            } else {
              global.showToast(
                message: 'Fail to deleteFromWishList',
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

  accpetDeclineContfirmationDialogForLiveStreaming({String? astroName, int? astroId, String? token, String? channel, String? requestType, int? id, double? charge, double? videoCallCharge, String? astrologerFcmToken2, String? astrologerProfile, bool? isFollow}) {
    BuildContext context = Get.context!;
    showDialog(
        context: context,
        // barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Get.theme.primaryColor,
                    child: Center(
                        child: Icon(
                      Icons.phone,
                      color: Colors.black,
                      size: 35,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "$astroName is available for call",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Decline",
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            astrologerFcmToken = astrologerFcmToken2;
                            update();
                            if (requestType != "Chat") {
                              Get.back();
                              Get.back();
                              await updateWaitListStatus(id!, "Running");
                              int index5 = waitList.indexWhere((element) => element.id == id);
                              if (index5 != -1) {
                                endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(waitList[index5].time);
                              }
                              await global.callOnFcmApiSendPushNotifications(
                                  fcmTokem: ["$astrologerFcmToken"],
                                  title: "For timer and session start for live",
                                  subTitle: "For timer and session start for live",
                                  sendData: {
                                    "waitListId": id,
                                    "channelName": channel,
                                    "profile": global.user.profile,
                                    "name": global.user.name ?? "user",
                                  });
                              if (liveController.liveUsers.isEmpty) {
                                await liveController.getLiveuserData(channel!);
                              }
                              List<String> otherJoinUsersFcmTokens = [];
                              print("liveController.liveUsers " + liveController.liveUsers.toString());
                              if (liveController.liveUsers.isNotEmpty) {
                                for (var i = 0; i < liveController.liveUsers.length; i++) {
                                  if (liveController.liveUsers[i].fcmToken != null) {
                                    otherJoinUsersFcmTokens.add(liveController.liveUsers[i].fcmToken!);
                                  }
                                }
                              }
                              print("otherJoinUsersFcmTokens" + otherJoinUsersFcmTokens.toString());
                              await global.callOnFcmApiSendPushNotifications(fcmTokem: otherJoinUsersFcmTokens, title: "For starting the timer in other audions for video and audio", subTitle: "For starting the timer in other audions for video and audio", sendData: {
                                "waitListId": id,
                                "channelName": channel,
                                "profile": global.user.profile,
                                "name": global.user.name ?? "user",
                              });
                              //here we will call the methods for sending all other users notification for timer start.
                              isLeaveCalled = false;
                              update();
                              Get.to(
                                () => LiveAstrologerScreen(
                                  isFollow: isFollow!,
                                  token: token!,
                                  channel: channel!,
                                  astrologerName: astroName!,
                                  astrologerId: astroId!,
                                  isFromHome: false,
                                  charge: charge!,
                                  isForLiveCallAcceptDecline: true,
                                  requesType: requestType,
                                  astrologerProfile: astrologerProfile ?? "",
                                  videoCallCharge: videoCallCharge ?? 0,
                                ),
                              );
                            } else {
                              Get.back();
                              await updateWaitListStatus(id!, "Running");
                              int index5 = waitList.indexWhere((element) => element.id == id);
                              if (index5 != -1) {
                                endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(waitList[index5].time);
                              }
                              isJoinAsChat = true;
                              chatId = "${global.user.id}" + "_" + "$astroId";
                              update();
                              global.callOnFcmApiSendPushNotifications(
                                  fcmTokem: ["$astrologerFcmToken"],
                                  title: "For Live Streaming Chat",
                                  subTitle: "For Live Streaming Chat",
                                  sendData: {
                                    "sessionType": "start",
                                    "chatId": chatId,
                                    "waitListId": id,
                                    "liveChatSUserName": global.user.name,
                                  });
                              timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
                                print("totalCompletedTimeForChat:" + totalCompletedTimeForChat.toString());
                                totalCompletedTimeForChat = totalCompletedTimeForChat + 1;
                                update();
                              });
                              await startRecord(channel!, global.localLiveUid!, token!);
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          );
        });
  }

  Future<dynamic> addToWaitList(String channel, String requestType, int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          print(global.user.name);
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          await apiHelper.addToWaitlist(channel: channel, requestType: requestType, time: "1000", userId: global.currentUserId, userName: "${global.user.name}", userProfile: "${global.user.profile}", userFcmToken: "$fcmToken", astrologerId: astrologerId).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              await getWaitList(channel);
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

  List<WaitList> waitList = [];

  //live user data
  Future<dynamic> addJoinUsersData(String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          print(global.user.name);
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          LiveUserModel liveUserModel = LiveUserModel(
            fcmToken: fcmToken,
            channelName: channelName,
          );
          await apiHelper.saveLiveUsers(liveUserModel).then((result) async {
            if (result.status == "200") {
              print('live user added successfully');
            } else {
              global.showToast(
                message: 'failed to add live user',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addJoinUsersData :-" + e.toString());
    }
  }

  Future<dynamic> getLiveuserData(String channel) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLiveUsers(channel).then((result) {
            if (result.status == "200") {
              liveUsers = result.recordList;
              update();
              print('Live user length ${liveUsers.length}');
            } else {
              global.showToast(
                message: 'failed to get live users',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getLiveuserData :-" + e.toString());
    }
  }

  Future<dynamic> removeLiveuserData() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteLiveUsers().then((result) {
            if (result.status == "200") {
              print('live user left successfullY');
            } else {
              global.showToast(
                message: 'failed to remove live users',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in removeLiveuserData :-" + e.toString());
    }
  }

  Future<void> onlineOfflineUser() async {
    for (int i = 0; i < waitList.length; i++) {
      for (int j = 0; j < liveUsers.length; j++) {
        if (waitList[i].userId == liveUsers[j].userId) {
          waitList[i].isOnline = true;
          update();
        }
      }
    }
  }

  Future startRecord(String channel, int localUserId, String token) async {
    print('start recording in chat');
    CallController callController = Get.find<CallController>();
    await callController.getAgoraResourceId(channel, localUserId);
    await callController.agoraStartRecording(channel, localUserId, token);
  }

  Future<dynamic> getRtmToken(String appId, String appCertificate, String chatId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.generateRtmToken(appId, appCertificate, chatId, channelName).then((result) {
            if (result.status == "200") {
              global.agoraChatToken = result.recordList['rtmToken'];
            } else {
              global.showToast(
                message: 'failed to get live RTM Token',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getRtmToken :-" + e.toString());
    }
  }

  Future<dynamic> deleteLiveAstrologer(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.endLiveSession(astrologerId).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              global.showToast(
                message: 'Live session end',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              print('Live session end length');
              final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
              global.showOnlyLoaderDialog(Get.context);
              await bottomNavigationController.getLiveAstrologerList();
              global.hideLoader();
            } else {
              global.showToast(
                message: 'End live session fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in deleteLiveAstrologer :-" + e.toString());
    }
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
