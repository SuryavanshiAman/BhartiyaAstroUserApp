import 'dart:developer';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/notificationController.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';


import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../views/call/incoming_call_request.dart';

class CallController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  final BottomNavigationController bottomNavigationController = Get.put<BottomNavigationController>(BottomNavigationController());
  int currentIndex = 0;
  int totalSeconds = 0;
  bool showBottomAcceptCall = false;
  int? bottomAstrologerId;
  String bottomAstrologerName = "Astrologer";
  String? bottomAstrologerProfile;
  String? bottomToken;
  int? bottomCallId;
  String? bottomChannel;
  String? bottomFcmToken;
  bool callBottom = false;
  APIHelper apiHelper = APIHelper();
  bool isLeaveCall = false;
  RxBool showCounter = false.obs;
  var resourceId;

  @override
  void onInit() async {
    tabController = TabController(length: 5, vsync: this, initialIndex: currentIndex);

    super.onInit();
  }

  showBottomAcceptCallRequest({
    required int astrologerId,
    required String channelName,
    required int callId,
    required String astroName,
    required String fcmToken,
    required String astroProfile,
    required String token,
    bool isBackGround = true,
  }) async {
    print('in callcontroller showBottomAcceptCallRequest');
    showBottomAcceptCall = true;
    bottomAstrologerId = astrologerId;
    bottomAstrologerName = astroName;
    bottomAstrologerProfile = astroProfile;
    bottomToken = token;
    bottomCallId = callId;
    bottomFcmToken = fcmToken;
    bottomChannel = channelName;
    await global.sp!.setInt('callBottom', 1);
    await global.sp!.setInt('bottomCallAstrologerId', astrologerId);
    await global.sp!.setString('bottomCallAstrologerName', astroName);
    await global.sp!.setString('bottomCallAstrologerProfile', astroProfile);
    await global.sp!.setString('bottomCallToken', token);
    await global.sp!.setInt('bottomCallId', callId);
    await global.sp!.setString('bottomCallFcmToken', fcmToken);
    await global.sp!.setString('bottomCallChannel', channelName);
    FlutterRingtonePlayer.play(fromAsset: "assets/sound/music.mp3");
    FlutterRingtonePlayer.playRingtone(asAlarm: false);

    NoticationController notificationController = Get.put(NoticationController());
    // log("Availibilty=============================================================${bottomNavigationController.astrologerbyId[0].name}");
    update();
    if (!isBackGround) {
      Get.to(() => IncomingCallRequest(
            astrologerId: bottomAstrologerId ?? 0,
            callId: bottomCallId ?? 0,
            channel: bottomChannel ?? "",
            fcmToken: bottomFcmToken ?? "",
            token: bottomToken ?? "",
            astrologerName: bottomAstrologerName,
            astrologerProfile: bottomAstrologerProfile,
          ));
    } else {
      notificationController.showCallNotification(
          astroProfile,
          astroName,
          () => {
                Get.to(() => IncomingCallRequest(
                      astrologerId: bottomAstrologerId ?? 0,
                      callId: bottomCallId ?? 0,
                      channel: bottomChannel ?? "",
                      fcmToken: bottomFcmToken ?? "",
                      token: bottomToken ?? "",
                      astrologerName: bottomAstrologerName,
                      astrologerProfile: bottomAstrologerProfile,
                    ))
              });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  setTabIndex(int index) {
    tabController!.index = index;
    currentIndex = index;
    print('ontapp tab index:- $currentIndex');
    update();
  }

  sendCallRequest(int astrologerId, bool isFreeSession) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.sendAstrologerCallRequest(astrologerId, isFreeSession).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'Sending call request..',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Failed to send call request',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in sendCallRequest : - ${e.toString()}');
    }
  }

  void openBottomPopup() {
    Get.bottomSheet(
      Container(
        height: 130,
        padding: EdgeInsets.all(8),
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: 15,
            // ),
            SizedBox(
              width: Get.width * 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Congratulation,Your Call Accepted  by \nAstrologer',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),

            //        showBottomAcceptCall = true;
            // bottomAstrologerId = astrologerId;
            // bottomAstrologerName = astroName;
            // bottomAstrologerProfile = astroProfile;
            // bottomToken = token;
            // bottomCallId = callId;
            // bottomFcmToken = fcmToken;
            // bottomChannel = channelName;
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // InkWell(
                //   onTap: () async {
                //    Get.back();
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(10),
                //     margin: const EdgeInsets.only(right: 20),
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Icon(
                //       Icons.chat,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap: () async {
                    Get.to(() => IncomingCallRequest(
                          astrologerId: bottomAstrologerId ?? 0,
                          callId: bottomCallId ?? 0,
                          channel: bottomChannel ?? "",
                          fcmToken: bottomFcmToken ?? "",
                          token: bottomToken ?? "",
                          astrologerName: bottomAstrologerName,
                          astrologerProfile: bottomAstrologerProfile,
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Accept Call',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        // Your bottom popup content goes here
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      ),
    );
  }

  sendVideoRequest(int astrologerId, bool isFreeSession) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.sendAstrologerVideoCallRequest(astrologerId, isFreeSession).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'Sending call request..',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Failed to send call request',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in sendCallRequest : - ${e.toString()}');
    }
  }

  acceptedCall(int callId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.acceptCall(callId).then((result) {
            if (result.status == "200") {
            } else {
              global.showToast(
                message: 'Call Accepet fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception acceptedCall:-" + e.toString());
    }
  }

  rejectedCall(int callId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.rejectCall(callId).then((result) {
            if (result.status == "200") {
              print("CalCutgya2");
              FlutterRingtonePlayer.stop();
              global.showToast(
                message: 'Call Rejected',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              FlutterRingtonePlayer.stop();
              print("CalCutgya3");
              global.showToast(
                message: 'Call Reject fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception rejectedCall:-" + e.toString());
    }
  }

  endCall(int callId, int seconds, String sId, String sId1) async {
    print('inEnd call');
    try {
      print("CallId" + callId.toString());
      print("seconds" + seconds.toString());
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.endCall(callId, seconds, sId, sId1).then((result) {
            if (result.status == "200") {
              print("end api call with : " + result);

              global.showToast(
                message: 'Call Ended',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Call Ended fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception endCall:-" + e.toString());
    }
  }

  getAgoraResourceId(String cname, int uid) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getResourceId(cname, uid).then((result) {
            resourceId = result.recordList;
            log('resourceId response:- $result');
            log('record ${resourceId["resourceId"]}');
            global.agoraResourceId = resourceId["resourceId"];
            log('global agoraResourceId ${global.agoraResourceId}');
          });
        }
      });
    } catch (e) {
      print("Exception getAgoraResourceId:-" + e.toString());
    }
  }

  getAgoraResourceId2(String cname, int uid) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getResourceId(cname, uid).then((result) {
            resourceId = result.recordList;
            log('resourceId response:- $result');
            log('record ${resourceId["resourceId"]}');
            global.agoraResourceId2 = resourceId["resourceId"];
            log('global agoraResourceId ${global.agoraResourceId}');
          });
        }
      });
    } catch (e) {
      print("Exception getAgoraResourceId:-" + e.toString());
    }
  }

  agoraStartRecording(String cname, int uid, String token) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.agoraStartCloudRecording(cname, uid, token).then((result) {
            log('start recording response:- ${result.recordList}');
            global.agoraSid1 = result.recordList["sid"];
            log('global agoraSId ${global.agoraSid1}');

            global.showToast(
              message: 'Start recording success',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          });
        }
      });
    } catch (e) {
      print("Exception getAgoraResourceId:-" + e.toString());
    }
  }

  agoraStartRecording2(String cname, int uid, String token) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.agoraStartCloudRecording2(cname, uid, token).then((result) {
            log('start recording response:- ${result.recordList}');
            global.agoraSid2 = result.recordList["sid"];
            log('global agoraSId ${global.agoraSid1}');
            print('start recording response2:- ${result.recordList}');
          });
        }
      });
    } catch (e) {
      print("Exception getAgoraResourceId:-" + e.toString());
    }
  }

  agoraStopRecording(int callId, String cname, int uid) async {
    print('controller stop1');
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.agoraStopCloudRecording(cname, uid).then((result) async {
            log('stop recording response:- ${result.recordList}');

            global.showToast(
              message: 'Stop recording success',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          });
        }
      });
    } catch (e) {
      print("Exception agoraStopRecording:-" + e.toString());
    }
  }

  agoraStopRecording2(int callId, String cname, int uid) async {
    print('controller stop2');
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.agoraStopCloudRecording2(cname, uid).then((result) async {
            log('stop recording response:- ${result.recordList}');
            print('stop recording response2:- ${result.recordList}');
          });
        }
      });
    } catch (e) {
      print("Exception agoraStopRecording2:-" + e.toString());
    }
  }

  stopRecordingStoreData(int callId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.stopRecoedingStoreData(callId, channelName, global.agoraSid1).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'store sid successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Failed store sid',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception stopRecordingStoreData:-" + e.toString());
    }
  }
}
