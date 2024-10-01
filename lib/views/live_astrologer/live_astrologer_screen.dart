import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/follow_astrologer_controller.dart';
import 'package:BharatiyAstro/controllers/gift_controller.dart';
import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:BharatiyAstro/controllers/walletController.dart';
import 'package:BharatiyAstro/model/messsage_model_live.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/callController.dart';
import '../../controllers/razorPayController.dart';
import '../../controllers/splashController.dart';
import '../../model/message_model.dart';
import '../../utils/services/api_helper.dart';
import '../paymentInformationScreen.dart';

class LiveAstrologerScreen extends StatefulWidget {
  final String token;
  final String channel;
  final String astrologerName;
  final String? astrologerProfile;
  final String? chatToken;
  final int astrologerId;
  final bool isFromHome;
  final bool isForLiveCallAcceptDecline;
  final double charge;
  final String? requesType;
  final bool? isFromNotJoined;
  final double videoCallCharge;
  final bool isFollow;

  LiveAstrologerScreen({super.key, required this.token, required this.isForLiveCallAcceptDecline, required this.charge, required this.channel, required this.astrologerName, this.requesType, this.chatToken, this.astrologerProfile, required this.astrologerId, required this.isFromHome, this.isFromNotJoined = false, required this.videoCallCharge, required this.isFollow});

  @override
  State<LiveAstrologerScreen> createState() => _LiveAstrologerScreenState();
}

class _LiveAstrologerScreenState extends State<LiveAstrologerScreen> {
  CallController callController = Get.find<CallController>();
  int uid = 0; // current user id
  int? remoteUid;
  late RtcEngine agoraEngine; // Agora engine instance
  int? conneId;
  bool isJoined = false;
  APIHelper apiHelper = APIHelper();
  bool isImHost = false;
  String? token2;
  String? channel2;
  String? astrologerName2;
  String? astrologerProfile2;
  Timer? timer;
  Timer? timer2;
  bool isStartRecordingForAudio = false;
  bool isFollowLocal = false;

  String? chatToken2;
  int? astrologerId2;
  double? charge2;
  double? videoCallCharge2;

  bool isHostJoin = false;
  bool isHostJoinAsAudio = false;
  bool isSetConn = false;
  final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  final FollowAstrologerController followAstrologerController = Get.find<FollowAstrologerController>();
  final WalletController walletController = Get.find<WalletController>();
  final LiveController liveController = Get.find<LiveController>();
  final TextEditingController messageController = TextEditingController();

  late AgoraRtmClient client;
  late AgoraRtmChannel channel;
  int viewer = 0;
  String chatuid = "";
  String channelId = "";
  String peerUserId = "";
  SplashController splashController = Get.find<SplashController>();
  String currentUserName = "";
  String currentUserProfile = "";

  int count = 0;
  int? remoteIdOfConnectedCustomer;

  final List<MessageModel> messageList = [];
  Future<void> sendMessage(int astrologerId) async {
    print('live chat send message');
    MessageModelLive messageModel = MessageModelLive();
    print('live chat send message');
    if (messageController.text.trim() != '') {
      messageModel.message = messageController.text.trim();
      messageModel.isActive = true;
      messageModel.isDelete = false;
      messageModel.createdAt = DateTime.now();
      messageModel.updatedAt = DateTime.now();
      messageModel.isRead = true;
      messageModel.userId1 = global.user.id;
      messageModel.userId2 = astrologerId;
      messageModel.orderId = null;
      messageController.text = '';
      print('live chat send message1');
      await liveController.uploadMessage(liveController.chatId!, astrologerId, messageModel);
    } else {
      print('messagecontroller');
    }
  }

  void openBottomSheetRechrage(BuildContext context, double totalCharge, bool isForGift) {
    Get.bottomSheet(
      Wrap(
        children: [
              Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isForGift == true
                                ? SizedBox()
                                : Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: Get.width - 70,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                                          child: Text(
                                            'Minimum balance of 5 minutes (${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $totalCharge) is required to start call',
                                            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red),
                                            softWrap: true,
                                          ),
                                        ),
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
                                Text('Tip:90% users recharge for 10 mins or more.', style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        SingleChildScrollView(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

  Future<void> wailtListDialog() {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
              height: 300,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: Get.width,
                    child: Stack(children: [
                      Center(
                        child: Text(
                          "Waitlist",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                          right: 10,
                          child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.close)))
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Customers who missed the call & were marked offline will get priority as per the list, if they come online.",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: 150,
                    child: liveController.waitList.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: liveController.waitList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        liveController.waitList[index].userProfile != ""
                                            ? CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Get.theme.primaryColor,
                                                child: Image.network(
                                                  "${global.imgBaseurl}${liveController.waitList[index].userProfile}",
                                                  height: 18,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Get.theme.primaryColor,
                                                child: Image.asset(
                                                  "assets/images/no_customer_image.png",
                                                  height: 18,
                                                ),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                "${liveController.waitList[index].userName}",
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                liveController.waitList[index].isOnline ? "Online" : "Offine",
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Get.theme.primaryColor,
                                          child: Icon(
                                            liveController.waitList[index].requestType == "Video"
                                                ? Icons.video_call
                                                : liveController.waitList[index].requestType == "Audio"
                                                    ? Icons.call
                                                    : Icons.chat,
                                            color: Colors.black,
                                            size: 13,
                                          ),
                                        ),
                                        liveController.waitList[index].status == "Pending"
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "${liveController.waitList[index].time} sec",
                                                  style: TextStyle(fontWeight: FontWeight.w500),
                                                ),
                                              )
                                            : CountdownTimer(
                                                endTime: liveController.endTime,
                                                widgetBuilder: (_, CurrentRemainingTime? time) {
                                                  if (time == null) {
                                                    return Text('00 min 00 sec1');
                                                  }
                                                  return Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: time.min != null
                                                        ? Text('${time.min} min ${time.sec} sec', style: TextStyle(fontWeight: FontWeight.w500))
                                                        : Text(
                                                            '${time.sec} sec',
                                                            style: TextStyle(fontWeight: FontWeight.w500),
                                                          ),
                                                  );
                                                },
                                                onEnd: () {
                                                  //from here
                                                  //call the disconnect method from requested customer
                                                },
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })
                        : Center(
                            child: Text("No member found"),
                          ),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  FutureBuilder(
                      future: global.translatedText("Wait Time - "),
                      builder: (context, snapShot) {
                        return Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Center(
                            child: RichText(
                              text: TextSpan(text: snapShot.data ?? "Wait Time - ", style: TextStyle(color: Colors.black), children: []),
                            ),
                          ),
                        );
                      }),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                    width: Get.width,
                    height: 37,
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15,
                        ),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (liveController.isImInWaitList == false) {
                          joinRequestDialog();
                        }
                      },
                      child: Text(
                        liveController.isImInWaitList ? "Joined" : "Join Waitlist",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  removeFromCallConfirmationDialog() {
    BuildContext context = Get.context!;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Container(
              height: 280,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(MdiIcons.alarm, size: 75, color: Get.theme.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "You are currently in the waitlist",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Are you sure you want to exit?",
                      style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
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
                                "Cancel",
                                style: TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Get.back();
                            int index = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
                            if (index != -1) {
                              await liveController.deleteFromWaitList(liveController.waitList[index].id);
                              liveController.isImInWaitList = false;
                              liveController.update();
                            }
                            if (widget.isForLiveCallAcceptDecline == true) {
                              //need to leave that perticular user from live streaming
                              leave();
                              print('exit dialog ${widget.isFromHome}');
                              if (!widget.isFromHome) {
                                bottomNavigationController.setBottomIndex(0, 0);
                              } else {
                                Get.back();
                              }
                            }
                            if (liveController.isJoinAsChat == true) {
                              //need to leave that perticular user from live streaming
                              leave();
                              print('exit dialog ${widget.isFromHome}');
                              if (!widget.isFromHome) {
                                bottomNavigationController.setBottomIndex(0, 0);
                              } else {
                                Get.back();
                              }
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Exit Call",
                                style: TextStyle(color: Colors.white, fontSize: 13),
                                textAlign: TextAlign.center,
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

  Future<void> joinRequestDialog() {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Get.back();
                            double totalCharge = videoCallCharge2! * 5;
                            if (totalCharge <= global.user.walletAmount!) {
                              await liveController.addToWaitList(channel2!, "Video", astrologerId2!);

                              global.showToast(
                                message: 'you have joined in waitlist',
                                textColor: global.textColor,
                                bgColor: global.toastBackGoundColor,
                              );
                              liveController.isImInWaitList = true;
                              liveController.update();
                            } else {
                              global.showOnlyLoaderDialog(context);
                              await walletController.getAmount();
                              global.hideLoader();
                              openBottomSheetRechrage(context, totalCharge, false);
                            }
                          },
                          child: Column(
                            children: [
                              Text(astrologerName2!),
                              callWidget(
                                Icons.video_call,
                                'Video call @${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $videoCallCharge2/min',
                                'Both consultant and you on video call.',
                                () {},
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Get.back();
                            double totalCharge = charge2! * 5;
                            if (totalCharge <= global.user.walletAmount!) {
                              await liveController.addToWaitList(channel2!, "Audio", astrologerId2!);

                              global.showToast(
                                message: 'you have joined in waitlist',
                                textColor: global.textColor,
                                bgColor: global.toastBackGoundColor,
                              );
                              liveController.isImInWaitList = true;
                              liveController.update();
                            } else {
                              global.showOnlyLoaderDialog(context);
                              await walletController.getAmount();
                              global.hideLoader();
                              openBottomSheetRechrage(context, totalCharge, false);
                            }
                          },
                          child: Column(
                            children: [
                              callWidget(
                                Icons.phone,
                                'Audio call @${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $charge2/min',
                                'consultant on video, you on audio',
                                () {},
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Get.back();
                            double totalCharge = charge2! * 5;
                            if (totalCharge <= global.user.walletAmount!) {
                              await liveController.addToWaitList(channel2!, "Chat", astrologerId2!);

                              global.showToast(
                                message: 'you have joined in waitlist',
                                textColor: global.textColor,
                                bgColor: global.toastBackGoundColor,
                              );
                              liveController.isImInWaitList = true;
                              liveController.update();
                            } else {
                              global.showOnlyLoaderDialog(context);
                              await walletController.getAmount();
                              global.hideLoader();
                              openBottomSheetRechrage(context, totalCharge, false);
                            }
                          },
                          child: Column(
                            children: [
                              callWidget(
                                Icons.chat,
                                'Chat @${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $charge2/min',
                                'consultant on video, you on chat. you may chat anonymously.',
                                () {},
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 2,
                    right: 2,
                    top: -50,
                    child: astrologerProfile2 == ""
                        ? CircleAvatar(
                            child: Image.asset(
                              Images.deafultUser,
                              fit: BoxFit.contain,
                              height: 40,
                              width: 40,
                            ),
                            radius: 40,
                          )
                        : CachedNetworkImage(
                            imageUrl: "${global.imgBaseurl}$astrologerProfile2",
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                radius: 40,
                                child: Image.network(
                                  "${global.imgBaseurl}$astrologerProfile2",
                                  fit: BoxFit.contain,
                                  height: 40,
                                  width: 40,
                                ),
                              );
                            },
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) {
                              return CircleAvatar(
                                  radius: 40,
                                  child: Image.asset(
                                    Images.deafultUser,
                                    fit: BoxFit.contain,
                                    height: 40,
                                    width: 40,
                                  ));
                            },
                          ),
                  )
                ],
              ));
        });
  }

  void toChangeRole() {
    liveController.isImSplitted = true;
    liveController.update();
    agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  }

  void toChangeRoleForAudio() async {
    liveController.isImSplitted = true;
    liveController.update();
    agoraEngine.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );
    agoraEngine.muteLocalVideoStream(true);
    setState(() {
      isHostJoinAsAudio = true;
    });
  }

  List<MessageModel> reverseList = [];
  Future<void> setRemoteId2(int astroId, int rmeoteId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.setRemoteId(astroId, rmeoteId).then((result) {
            if (result.status == "200") {
            } else {}
          });
        }
      });
    } catch (e) {
      print("Exception in getFollowedAstrologerList :-" + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token2 = widget.token;
      channel2 = widget.channel;
      astrologerId2 = widget.astrologerId;
      astrologerName2 = widget.astrologerName;
      astrologerProfile2 = widget.astrologerProfile;
      chatToken2 = widget.chatToken;
      charge2 = widget.charge;
      videoCallCharge2 = widget.videoCallCharge;
      isFollowLocal = widget.isFollow;
      print('Astrologer profile in init :- $astrologerProfile2');
    });

    _init();
  }

  Future<void> _init() async {
    if (widget.isForLiveCallAcceptDecline == true) {
      leave();
    }
    await setupVideoSDKEngine();
    isJoined = false;
    log('live astrologer init');
    await createClient();
    print('live joined user name ${global.user.name}');
    if (widget.isForLiveCallAcceptDecline == true) {
      print("widget.requesTyp:" + widget.requesType.toString());
      if (widget.requesType != null && widget.requesType != "") {
        if (widget.requesType == "Video") {
          toChangeRole();
        } else {
          toChangeRoleForAudio();
        }
      }
      liveController.totalCompletedTime = 0;
      liveController.joinUserName = global.user.name ?? "User";
      liveController.joinUserProfile = global.user.profile ?? "";
      print('live joined user name ${liveController.joinUserName}');
      print("liveController.totalCompletedTime: " + liveController.totalCompletedTime.toString());
      liveController.update();
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        liveController.totalCompletedTime = liveController.totalCompletedTime + 1;
        print("updated totalCompletedTime :  " + liveController.totalCompletedTime.toString());
      });

      timer2 = Timer.periodic(Duration(seconds: 5), (timer) async {
        log('you joined2 ${DateTime.now()}');
        print('changed role lid ${global.localLiveUid}');
        if (global.localLiveUid != null && !isStartRecordingForAudio) {
          print('start recording in timer');

          setState(() {
            isStartRecordingForAudio = true;
            print('isStartRecordingForAudio $isStartRecordingForAudio');
          });
          await callController.getAgoraResourceId(widget.channel, global.localLiveUid!);
          await callController.getAgoraResourceId2(widget.channel, global.localLiveUid2!);
          await startRecord();
          await startRecord2();
        }
      });
    }
    await liveController.addJoinUsersData(widget.channel);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        global.showOnlyLoaderDialog(context);
        await bottomNavigationController.getLiveAstrologerList();
        global.hideLoader();
        bottomNavigationController.anotherLiveAstrologers = bottomNavigationController.liveAstrologer.where((element) => element.astrologerId != astrologerId2).toList();
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 3,
                      width: 40,
                      color: Colors.grey,
                    ),
                    Text("Check other live sessions"),
                    Divider(),
                    bottomNavigationController.anotherLiveAstrologers.isEmpty
                        ? Expanded(
                            flex: 3,
                            child: Container(
                              child: Center(
                                child: Text("No Astrologer available"),
                              ),
                            ),
                          )
                        : Expanded(
                            flex: 3,
                            child: ListView(children: [
                              Center(
                                child: Wrap(
                                  children: [
                                    for (int index = 0; index < bottomNavigationController.anotherLiveAstrologers.length; index++)
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          leave();
                                          Get.back();
                                          Future.delayed(Duration(milliseconds: 50)).then((value) {
                                            Get.to(() => LiveAstrologerScreen(
                                                  token: bottomNavigationController.anotherLiveAstrologers[index].token,
                                                  channel: bottomNavigationController.anotherLiveAstrologers[index].channelName,
                                                  astrologerName: bottomNavigationController.anotherLiveAstrologers[index].name,
                                                  astrologerId: bottomNavigationController.anotherLiveAstrologers[index].astrologerId,
                                                  isFromHome: true,
                                                  charge: bottomNavigationController.anotherLiveAstrologers[index].charge,
                                                  isForLiveCallAcceptDecline: false,
                                                  isFollow: bottomNavigationController.anotherLiveAstrologers[index].isFollow!,
                                                  videoCallCharge: bottomNavigationController.anotherLiveAstrologers[index].videoCallRate,
                                                ));
                                          });
                                        },
                                        child: Container(
                                          height: 100,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              bottomNavigationController.anotherLiveAstrologers[index].profileImage == ""
                                                  ? CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: Get.theme.primaryColor,
                                                      child: Image.asset(
                                                        Images.deafultUser,
                                                        fit: BoxFit.fill,
                                                        height: 40,
                                                      ))
                                                  : CachedNetworkImage(
                                                      imageUrl: "${global.imgBaseurl}${bottomNavigationController.anotherLiveAstrologers[index].profileImage}",
                                                      imageBuilder: (context, imageProvider) {
                                                        return CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: Colors.white,
                                                          backgroundImage: imageProvider,
                                                        );
                                                      },
                                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                      errorWidget: (context, url, error) {
                                                        return CircleAvatar(
                                                            radius: 30,
                                                            backgroundColor: Colors.white,
                                                            child: Image.asset(
                                                              Images.deafultUser,
                                                              fit: BoxFit.fill,
                                                              height: 40,
                                                            ));
                                                      },
                                                    ),
                                              Text(
                                                bottomNavigationController.anotherLiveAstrologers[index].name,
                                                style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: isFollowLocal ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                leave();
                                if (!widget.isFromHome) {
                                  print('Leave proccess start after leave method from else part !widget.isFromHome');
                                  bottomNavigationController.setBottomIndex(0, 0);
                                  Get.back();
                                } else {
                                  print('Leave proccess start after leave method from else part');
                                  Get.back();
                                  Get.back();
                                }
                              },
                              child: Text(
                                'Leave',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width * 0.4)),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                                backgroundColor: MaterialStateProperty.all(Colors.grey),
                                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                              ),
                            ),
                            isFollowLocal
                                ? const SizedBox()
                                : ElevatedButton(
                                    onPressed: () async {
                                      leave();
                                      if (!widget.isFromHome) {
                                        print('Leave proccess start from follow and live after leave method from else part !widget.isFromHome');
                                        bottomNavigationController.setBottomIndex(0, 0);
                                        Get.back();
                                      } else {
                                        print('Leave proccess start follow and live after after leave method from else part');
                                        Get.back();
                                        Get.back();
                                      }
                                      global.showOnlyLoaderDialog(context);
                                      await followAstrologerController.addFollowers(astrologerId2!);
                                      global.hideLoader();
                                      //Get.back();
                                    },
                                    child: Text(
                                      'Follow & Leave',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width * 0.4)),
                                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                                      backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
        return false;
      },
      child: SafeArea(
          child: Scaffold(
              body: isHostJoin
                  ? ListView(
                      children: [
                        Stack(children: [
                          Container(
                            height: Get.height * 0.96,
                            child: Stack(children: [
                              Container(
                                height: widget.isFromHome
                                    ? isImHost
                                        ? Get.height * 0.46
                                        : Get.height * 0.96
                                    : isImHost
                                        ? Get.height * 0.46
                                        : Get.height * 0.96,
                                width: Get.width,
                                child: _videoPanel(),
                              ),
                              isImHost
                                  ? Container(
                                      margin: EdgeInsets.only(
                                        top: widget.isFromHome ? Get.height * 0.46 : Get.height * 0.46,
                                      ),
                                      height: widget.isFromHome ? Get.height * 0.46 : Get.height * 0.46,
                                      width: Get.width,
                                      child: _videoPanelForLocal(),
                                    )
                                  : SizedBox(),
                            ]),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      reverseList.isEmpty
                                          ? const SizedBox()
                                          : SizedBox(
                                              height: Get.height * 0.4,
                                              width: Get.width * 0.74,
                                              child: ListView.builder(
                                                  itemCount: reverseList.length,
                                                  reverse: true,
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  itemBuilder: (context, index) {
                                                    return Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: CircleAvatar(
                                                            backgroundColor: Get.theme.primaryColor,
                                                            child: reverseList[index].profile == ""
                                                                ? Image.asset(
                                                                    Images.deafultUser,
                                                                    height: 40,
                                                                    width: 30,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    imageUrl: '${reverseList[index].profile}',
                                                                    imageBuilder: (context, imageProvider) => CircleAvatar(
                                                                      backgroundImage: NetworkImage('${reverseList[index].profile}'),
                                                                    ),
                                                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                    errorWidget: (context, url, error) => Image.asset(
                                                                      Images.deafultUser,
                                                                      height: 40,
                                                                      width: 30,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          width: Get.width * 0.55,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                reverseList[index].userName ?? 'User',
                                                                style: Get.textTheme.bodyMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                                              ),
                                                              Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Text(
                                                                    reverseList.isEmpty ? '' : reverseList[index].message!,
                                                                    style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                                                  ),
                                                                  reverseList[index].gift != null && reverseList[index].gift != 'null'
                                                                      ? CachedNetworkImage(
                                                                          height: 30,
                                                                          width: 30,
                                                                          imageUrl: '${global.imgBaseurl}${reverseList[index].gift}',
                                                                        )
                                                                      : const SizedBox()
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  }),
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          FutureBuilder(
                                              future: global.translatedText('say hi..'),
                                              builder: (context, snapshot) {
                                                return SizedBox(
                                                  height: 40,
                                                  width: Get.width * 0.4,
                                                  child: TextFormField(
                                                    style: const TextStyle(fontSize: 12, color: Colors.white),
                                                    controller: messageController,
                                                    keyboardType: TextInputType.text,
                                                    cursorColor: Colors.white,
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.black38,
                                                        filled: true,
                                                        hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
                                                        helperStyle: TextStyle(color: Get.theme.primaryColor),
                                                        contentPadding: EdgeInsets.all(10.0),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.transparent),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        focusedErrorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.transparent),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.transparent),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.transparent),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        hintText: snapshot.data ?? 'say hi..',
                                                        prefixIcon: Icon(
                                                          Icons.chat,
                                                          color: Colors.white,
                                                          size: 15,
                                                        )),
                                                  ),
                                                );
                                              }),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (messageController.text != "") {
                                                sendChannelMessage(messageController.text, null);
                                                if (liveController.isJoinAsChat) {
                                                } else {
                                                  messageController.clear();
                                                }
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.only(top: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                              child: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      liveController.createLiveAstrologerShareLink(astrologerName2!, astrologerId2!, token2!, channel2!, charge2!, videoCallCharge2!);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.only(top: 8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  GetBuilder<GiftController>(builder: (giftController) {
                                    return GestureDetector(
                                      onTap: () async {
                                        print('gift sent');
                                        global.showOnlyLoaderDialog(context);
                                        await giftController.getGiftData();
                                        global.hideLoader();
                                        showModalBottomSheet(
                                          backgroundColor: Colors.black26,
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) {
                                            return Container(
                                              height: 280,
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
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
                                                                          giftController.updateOntap(index);
                                                                        },
                                                                        child: Container(
                                                                          height: 60,
                                                                          width: 60,
                                                                          padding: const EdgeInsets.all(5),
                                                                          decoration: BoxDecoration(
                                                                            color: giftController.giftList[index].isSelected ?? false ? Color.fromARGB(255, 196, 192, 192) : Colors.transparent,
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
                                                                          style: Get.textTheme.bodyText2!.copyWith(
                                                                            fontSize: 12,
                                                                            color: Colors.white,
                                                                          )),
                                                                      Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${giftController.giftList[index].amount}',
                                                                          style: Get.textTheme.bodyText2!.copyWith(
                                                                            fontSize: 10,
                                                                            color: Get.theme.primaryColor,
                                                                          ))
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
                                                        TextButton(
                                                            child: Text('Recharge',
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                )),
                                                            style: ButtonStyle(
                                                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(6)),
                                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  side: BorderSide(color: Colors.orange.shade200),
                                                                ))),
                                                            onPressed: () async {
                                                              Get.back();
                                                              global.showOnlyLoaderDialog(context);
                                                              await walletController.getAmount();
                                                              global.hideLoader();
                                                              openBottomSheetRechrage(context, 0, true);
                                                            }),
                                                        Text('Current Balance: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}',
                                                            style: Get.textTheme.bodyText2!.copyWith(
                                                              fontSize: 12,
                                                              color: Get.theme.primaryColor,
                                                            )),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.dialog(
                                                              AlertDialog(
                                                                titlePadding: const EdgeInsets.all(0),
                                                                contentPadding: const EdgeInsets.all(4),
                                                                title: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.back();
                                                                      },
                                                                      child: Align(
                                                                        alignment: Alignment.topRight,
                                                                        child: Icon(Icons.close),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'How Donation works?',
                                                                      style: TextStyle(fontSize: 18),
                                                                    )
                                                                  ],
                                                                ),
                                                                content: ListView(
                                                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  children: [
                                                                    Text('1. Donation is a virtual gift.'),
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Text('2. Donation is a valuntary & non-refundable.'),
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Text('3. Company doesn\'t guarantee any service in exchage of donation.'),
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Text('4. Donation can be encashed by the astrologer in monetary terms as per company policies.'),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.info,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        TextButton(
                                                            child: Text('Send Gift',
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                )),
                                                            style: ButtonStyle(
                                                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(6)),
                                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  side: BorderSide(color: Colors.black12),
                                                                ))),
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
                                                                  Get.back(); //back from send gift bottom sheet
                                                                  global.showOnlyLoaderDialog(context);
                                                                  await giftController.sendGift(giftController.giftList[giftController.giftSelectIndex!].id, widget.astrologerId, double.parse(giftController.giftList[giftController.giftSelectIndex!].amount.toString()));
                                                                  global.hideLoader();
                                                                  if (giftController.isGiftSend) {
                                                                    sendChannelMessage('Send Gift ', giftController.giftList[giftController.giftSelectIndex!].image);
                                                                    giftController.isGiftSend = false;
                                                                    giftController.update();
                                                                  }
                                                                }
                                                              } else {
                                                                global.showToast(
                                                                  message: 'Please select gift',
                                                                  textColor: global.textColor,
                                                                  bgColor: global.toastBackGoundColor,
                                                                );
                                                              }
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                        child: Icon(
                                          CupertinoIcons.gift,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    );
                                  }),
                                  GestureDetector(
                                    onTap: () async {
                                      await liveController.getWaitList(channel2!);
                                      await liveController.getLiveuserData(channel2!);
                                      await liveController.onlineOfflineUser();
                                      wailtListDialog();
                                    },
                                    child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.black.withOpacity(0.35),
                                        child: Icon(
                                          FontAwesomeIcons.hourglassEnd,
                                          size: 15,
                                          color: Colors.white,
                                        )),
                                  ),
                                  GetBuilder<LiveController>(builder: (c) {
                                    return liveController.isImInWaitList == false
                                        ? InkWell(
                                            onTap: () {
                                              // Get.to(() => AgoraDemo2());
                                              joinRequestDialog();
                                              // liveController.createLiveAstrologerShareLink();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.only(top: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                              child: Icon(
                                                Icons.phone,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              removeFromCallConfirmationDialog();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 08),
                                              child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.black.withOpacity(0.35),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 18,
                                                    color: Colors.red,
                                                  )),
                                            ),
                                          );
                                  }),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                    child: Text(
                                      "${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}$charge2/m",
                                      style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              FutureBuilder(
                                  future: global.translatedText("Warning - Don't close the app without leaving running session."),
                                  builder: (context, snapshot) {
                                    return Container(
                                        margin: EdgeInsets.only(bottom: 5, left: 5),
                                        padding: EdgeInsets.only(top: 3, left: 3, right: 3),
                                        height: 20,
                                        color: Colors.black.withOpacity(0.9),
                                        child: Marquee(
                                          text: snapshot.data ?? "Warning - Don't close the app without leaving running session.",
                                          style: TextStyle(color: Colors.red, fontSize: 10),
                                          scrollAxis: Axis.horizontal,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          blankSpace: 20.0,
                                          velocity: 80.0,
                                          pauseAfterRound: Duration(milliseconds: 500),
                                          startPadding: 10.0,
                                          accelerationDuration: Duration(milliseconds: 500),
                                          accelerationCurve: Curves.linear,
                                          decelerationDuration: Duration(milliseconds: 500),
                                          decelerationCurve: Curves.easeOut,
                                        ));
                                  }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Platform.isIOS
                                          ? Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  global.showOnlyLoaderDialog(context);
                                                  await bottomNavigationController.getLiveAstrologerList();
                                                  global.hideLoader();
                                                  bottomNavigationController.anotherLiveAstrologers = bottomNavigationController.liveAstrologer.where((element) => element.astrologerId != astrologerId2).toList();

                                                  showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(10),
                                                        ),
                                                      ),
                                                      backgroundColor: Colors.white,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                height: 3,
                                                                width: 40,
                                                                color: Colors.grey,
                                                              ),
                                                              Text("Check other live sessions"),
                                                              Divider(),
                                                              bottomNavigationController.anotherLiveAstrologers.isEmpty
                                                                  ? Expanded(
                                                                      flex: 3,
                                                                      child: Container(
                                                                        child: Center(
                                                                          child: Text("No Astrologer available"),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Expanded(
                                                                      flex: 3,
                                                                      child: ListView(children: [
                                                                        Center(
                                                                          child: Wrap(
                                                                            children: [
                                                                              for (int index = 0; index < bottomNavigationController.anotherLiveAstrologers.length; index++)
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Get.back();
                                                                                    leave();
                                                                                    Get.back();

                                                                                    Future.delayed(Duration(milliseconds: 50)).then((value) {
                                                                                      Get.to(() => LiveAstrologerScreen(
                                                                                            token: bottomNavigationController.anotherLiveAstrologers[index].token,
                                                                                            channel: bottomNavigationController.anotherLiveAstrologers[index].channelName,
                                                                                            astrologerName: bottomNavigationController.anotherLiveAstrologers[index].name,
                                                                                            astrologerId: bottomNavigationController.anotherLiveAstrologers[index].astrologerId,
                                                                                            isFromHome: true,
                                                                                            charge: bottomNavigationController.anotherLiveAstrologers[index].charge,
                                                                                            isFollow: bottomNavigationController.anotherLiveAstrologers[index].isFollow!,
                                                                                            isForLiveCallAcceptDecline: false,
                                                                                            videoCallCharge: bottomNavigationController.anotherLiveAstrologers[index].videoCallRate,
                                                                                          ));
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 100,
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        bottomNavigationController.anotherLiveAstrologers[index].profileImage == ""
                                                                                            ? CircleAvatar(
                                                                                                radius: 30,
                                                                                                backgroundColor: Get.theme.primaryColor,
                                                                                                child: Image.asset(
                                                                                                  Images.deafultUser,
                                                                                                  fit: BoxFit.fill,
                                                                                                  height: 40,
                                                                                                ))
                                                                                            : CachedNetworkImage(
                                                                                                imageUrl: "${global.imgBaseurl}${bottomNavigationController.anotherLiveAstrologers[index].profileImage}",
                                                                                                imageBuilder: (context, imageProvider) {
                                                                                                  return CircleAvatar(
                                                                                                    radius: 30,
                                                                                                    backgroundColor: Colors.white,
                                                                                                    backgroundImage: imageProvider,
                                                                                                  );
                                                                                                },
                                                                                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                                errorWidget: (context, url, error) {
                                                                                                  return CircleAvatar(
                                                                                                      radius: 30,
                                                                                                      backgroundColor: Colors.white,
                                                                                                      child: Image.asset(
                                                                                                        Images.deafultUser,
                                                                                                        fit: BoxFit.fill,
                                                                                                        height: 40,
                                                                                                      ));
                                                                                                },
                                                                                              ),
                                                                                        Text(
                                                                                          bottomNavigationController.anotherLiveAstrologers[index].name,
                                                                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                    ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: SizedBox(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        onPressed: () {
                                                                          leave();
                                                                          if (!widget.isFromHome) {
                                                                            bottomNavigationController.setBottomIndex(0, 0);
                                                                            Get.back();
                                                                          } else {
                                                                            Get.back();
                                                                            Get.back();
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                          'Leave',
                                                                          style: TextStyle(color: Colors.black),
                                                                        ),
                                                                        style: ButtonStyle(
                                                                          shape: MaterialStateProperty.all(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                          ),
                                                                          fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width * 0.4)),
                                                                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                                                                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                                                                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed: () async {
                                                                          leave();
                                                                          global.showOnlyLoaderDialog(context);
                                                                          await followAstrologerController.addFollowers(astrologerId2!);
                                                                          global.hideLoader();
                                                                        },
                                                                        child: Text(
                                                                          'Follow & Leave',
                                                                          style: TextStyle(color: Colors.black),
                                                                        ),
                                                                        style: ButtonStyle(
                                                                          shape: MaterialStateProperty.all(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                          ),
                                                                          fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width * 0.4)),
                                                                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                                                                          backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          : widget.isFromHome
                                              ? const SizedBox()
                                              : Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      global.showOnlyLoaderDialog(context);
                                                      await bottomNavigationController.getLiveAstrologerList();
                                                      global.hideLoader();
                                                      bottomNavigationController.anotherLiveAstrologers = bottomNavigationController.liveAstrologer.where((element) => element.astrologerId != astrologerId2).toList();

                                                      showModalBottomSheet(
                                                          context: context,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.vertical(
                                                              top: Radius.circular(10),
                                                            ),
                                                          ),
                                                          backgroundColor: Colors.white,
                                                          builder: (context) {
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Container(
                                                                    height: 3,
                                                                    width: 40,
                                                                    color: Colors.grey,
                                                                  ),
                                                                  Text("Check other live sessions"),
                                                                  Divider(),
                                                                  bottomNavigationController.anotherLiveAstrologers.isEmpty
                                                                      ? Expanded(
                                                                          flex: 3,
                                                                          child: Container(
                                                                            child: Center(
                                                                              child: Text("No Astrologer available"),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          flex: 3,
                                                                          child: ListView(children: [
                                                                            Center(
                                                                              child: Wrap(
                                                                                children: [
                                                                                  for (int index = 0; index < bottomNavigationController.anotherLiveAstrologers.length; index++)
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        Get.back();
                                                                                        leave();
                                                                                        Get.back();

                                                                                        Future.delayed(Duration(milliseconds: 50)).then((value) {
                                                                                          Get.to(() => LiveAstrologerScreen(
                                                                                                token: bottomNavigationController.anotherLiveAstrologers[index].token,
                                                                                                channel: bottomNavigationController.anotherLiveAstrologers[index].channelName,
                                                                                                astrologerName: bottomNavigationController.anotherLiveAstrologers[index].name,
                                                                                                astrologerId: bottomNavigationController.anotherLiveAstrologers[index].astrologerId,
                                                                                                isFromHome: true,
                                                                                                charge: bottomNavigationController.anotherLiveAstrologers[index].charge,
                                                                                                isForLiveCallAcceptDecline: false,
                                                                                                videoCallCharge: bottomNavigationController.anotherLiveAstrologers[index].videoCallRate,
                                                                                                isFollow: bottomNavigationController.anotherLiveAstrologers[index].isFollow!,
                                                                                              ));
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        height: 100,
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            bottomNavigationController.anotherLiveAstrologers[index].profileImage == ""
                                                                                                ? CircleAvatar(
                                                                                                    radius: 30,
                                                                                                    backgroundColor: Get.theme.primaryColor,
                                                                                                    child: Image.asset(
                                                                                                      Images.deafultUser,
                                                                                                      fit: BoxFit.fill,
                                                                                                      height: 40,
                                                                                                    ))
                                                                                                : CachedNetworkImage(
                                                                                                    imageUrl: "${global.imgBaseurl}${bottomNavigationController.anotherLiveAstrologers[index].profileImage}",
                                                                                                    imageBuilder: (context, imageProvider) {
                                                                                                      return CircleAvatar(
                                                                                                        radius: 30,
                                                                                                        backgroundColor: Colors.white,
                                                                                                        backgroundImage: imageProvider,
                                                                                                      );
                                                                                                    },
                                                                                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                                    errorWidget: (context, url, error) {
                                                                                                      return CircleAvatar(
                                                                                                          radius: 30,
                                                                                                          backgroundColor: Colors.white,
                                                                                                          child: Image.asset(
                                                                                                            Images.deafultUser,
                                                                                                            fit: BoxFit.fill,
                                                                                                            height: 40,
                                                                                                          ));
                                                                                                    },
                                                                                                  ),
                                                                                            Text(
                                                                                              bottomNavigationController.anotherLiveAstrologers[index].name,
                                                                                              style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                        ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: SizedBox(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          ElevatedButton(
                                                                            onPressed: () {
                                                                              leave();
                                                                              if (!widget.isFromHome) {
                                                                                bottomNavigationController.setBottomIndex(0, 0);
                                                                                Get.back();
                                                                              } else {
                                                                                Get.back();
                                                                                Get.back();
                                                                              }
                                                                            },
                                                                            child: Text(
                                                                              'Leave',
                                                                              style: TextStyle(color: Colors.black),
                                                                            ),
                                                                            style: ButtonStyle(
                                                                              shape: MaterialStateProperty.all(
                                                                                RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                              ),
                                                                              fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width * 0.4)),
                                                                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                                                                              backgroundColor: MaterialStateProperty.all(Colors.grey),
                                                                              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed: () async {
                                                                              leave();
                                                                              global.showOnlyLoaderDialog(context);
                                                                              await followAstrologerController.addFollowers(astrologerId2!);
                                                                              global.hideLoader();
                                                                              //Get.back();
                                                                            },
                                                                            child: Text(
                                                                              'Follow & Leave',
                                                                              style: TextStyle(color: Colors.black),
                                                                            ),
                                                                            style: ButtonStyle(
                                                                              shape: MaterialStateProperty.all(
                                                                                RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                              ),
                                                                              fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width * 0.4)),
                                                                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
                                                                              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                                              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: isImHost
                                                ? 10
                                                : remoteIdOfConnectedCustomer != null
                                                    ? 10
                                                    : isHostJoinAsAudio
                                                        ? 10
                                                        : 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Row(
                                          children: [
                                            isImHost
                                                ? Stack(clipBehavior: Clip.none, children: [
                                                    CircleAvatar(
                                                        backgroundColor: Colors.white,
                                                        radius: 13.0,
                                                        child: astrologerProfile2 == "" || astrologerId2 == null
                                                            ? CircleAvatar(
                                                                backgroundColor: Get.theme.primaryColor,
                                                                backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                                radius: 10.0,
                                                              )
                                                            : CircleAvatar(
                                                                backgroundImage: NetworkImage("${global.imgBaseurl}$astrologerProfile2"),
                                                                radius: 10.0,
                                                              )),
                                                    Positioned(
                                                      top: 10,
                                                      left: 10,
                                                      child: CircleAvatar(
                                                          backgroundColor: Colors.white,
                                                          radius: 13.0,
                                                          child: liveController.joinUserProfile == ""
                                                              ? CircleAvatar(
                                                                  backgroundColor: Get.theme.primaryColor,
                                                                  backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                                  radius: 10.0,
                                                                )
                                                              : CircleAvatar(
                                                                  backgroundImage: NetworkImage("${global.imgBaseurl}${liveController.joinUserProfile}"),
                                                                  radius: 10.0,
                                                                )),
                                                    ),
                                                  ])
                                                : remoteIdOfConnectedCustomer != null
                                                    ? Stack(clipBehavior: Clip.none, children: [
                                                        CircleAvatar(
                                                            backgroundColor: Colors.white,
                                                            radius: 13.0,
                                                            child: astrologerProfile2 == "" || astrologerId2 == null
                                                                ? CircleAvatar(
                                                                    backgroundColor: Get.theme.primaryColor,
                                                                    backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                                    radius: 10.0,
                                                                  )
                                                                : CircleAvatar(
                                                                    backgroundImage: NetworkImage("${global.imgBaseurl}$astrologerProfile2"),
                                                                    radius: 10.0,
                                                                  )),
                                                        Positioned(
                                                          top: 10,
                                                          left: 10,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.white,
                                                              radius: 13.0,
                                                              child: liveController.joinUserProfile == ""
                                                                  ? CircleAvatar(
                                                                      backgroundColor: Get.theme.primaryColor,
                                                                      backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                                      radius: 10.0,
                                                                    )
                                                                  : CircleAvatar(
                                                                      backgroundImage: NetworkImage("${global.imgBaseurl}${liveController.joinUserProfile}"),
                                                                      radius: 10.0,
                                                                    )),
                                                        ),
                                                      ])
                                                    : isHostJoinAsAudio
                                                        ? Stack(clipBehavior: Clip.none, children: [
                                                            CircleAvatar(
                                                                backgroundColor: Colors.white,
                                                                radius: 13.0,
                                                                child: astrologerProfile2 == "" || astrologerId2 == null
                                                                    ? CircleAvatar(
                                                                        backgroundColor: Get.theme.primaryColor,
                                                                        backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                                        radius: 10.0,
                                                                      )
                                                                    : CircleAvatar(
                                                                        backgroundImage: NetworkImage("${global.imgBaseurl}$astrologerProfile2"),
                                                                        radius: 10.0,
                                                                      )),
                                                            Positioned(
                                                              top: 10,
                                                              left: 10,
                                                              child: CircleAvatar(
                                                                  backgroundColor: Colors.white,
                                                                  radius: 13.0,
                                                                  child: liveController.joinUserProfile == ""
                                                                      ? CircleAvatar(
                                                                          backgroundColor: Get.theme.primaryColor,
                                                                          backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                                          radius: 10.0,
                                                                        )
                                                                      : CircleAvatar(
                                                                          backgroundImage: NetworkImage("${global.imgBaseurl}${liveController.joinUserProfile}"),
                                                                          radius: 10.0,
                                                                        )),
                                                            ),
                                                          ])
                                                        : CircleAvatar(
                                                            backgroundColor: Colors.white,
                                                            radius: 18.0,
                                                            child: astrologerProfile2 == "" || astrologerId2 == null
                                                                ? CircleAvatar(
                                                                    backgroundImage: AssetImage(Images.deafultUser),
                                                                    radius: 15.0,
                                                                  )
                                                                : CircleAvatar(
                                                                    backgroundImage: NetworkImage("${global.imgBaseurl}$astrologerProfile2"),
                                                                    radius: 15.0,
                                                                  )),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  astrologerName2!,
                                                  style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                                ),
                                                liveController.isJoinAsChat == false
                                                    ? isImHost
                                                        ? Text(
                                                            liveController.joinUserName,
                                                            style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                                          )
                                                        : remoteIdOfConnectedCustomer != null
                                                            ? Text(
                                                                liveController.joinUserName,
                                                                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                                              )
                                                            : isHostJoinAsAudio
                                                                ? Text(
                                                                    liveController.joinUserName,
                                                                    style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                                                  )
                                                                : const SizedBox()
                                                    : Text(
                                                        liveController.joinUserName,
                                                        style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                                      ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GetBuilder<LiveController>(builder: (c) {
                                              return liveController.isJoinAsChat == false
                                                  ? isImHost
                                                      ? Image.asset(
                                                          'assets/images/voice.gif',
                                                          height: 30,
                                                          width: 30,
                                                        )
                                                      : remoteIdOfConnectedCustomer != null
                                                          ? Image.asset(
                                                              'assets/images/voice.gif',
                                                              height: 30,
                                                              width: 30,
                                                            )
                                                          : isHostJoinAsAudio
                                                              ? Image.asset(
                                                                  'assets/images/voice.gif',
                                                                  height: 30,
                                                                  width: 30,
                                                                )
                                                              : const SizedBox()
                                                  : Image.asset(
                                                      'assets/images/voice.gif',
                                                      height: 30,
                                                      width: 30,
                                                    );
                                            })
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  GetBuilder<LiveController>(builder: (c) {
                                    return liveController.isJoinAsChat == false
                                        ? isImHost
                                            ? GetBuilder<LiveController>(
                                                builder: (c) {
                                                  return CountdownTimer(
                                                    endTime: liveController.endTime,
                                                    widgetBuilder: (_, CurrentRemainingTime? time) {
                                                      if (time == null) {
                                                        return Text(
                                                          '00 min 00 sec',
                                                          style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                        );
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: time.min != null
                                                            ? Container(padding: const EdgeInsets.all(8), alignment: Alignment.center, decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)), child: Text('${time.min} min ${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)))
                                                            : Container(
                                                                padding: const EdgeInsets.all(8),
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                                child: Text(
                                                                  '${time.sec} sec',
                                                                  style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                                ),
                                                              ),
                                                      );
                                                    },
                                                    onEnd: () {
                                                      if (liveController.isImSplitted) {
                                                        print("OnEnd called");
                                                        leave();
                                                        Get.back();
                                                      }
                                                      //call the disconnect method from requested customer
                                                    },
                                                  );
                                                },
                                              )
                                            : remoteIdOfConnectedCustomer != null
                                                ? GetBuilder<LiveController>(
                                                    builder: (s) {
                                                      return CountdownTimer(
                                                        endTime: liveController.endTime,
                                                        widgetBuilder: (_, CurrentRemainingTime? time) {
                                                          if (time == null) {
                                                            return Container(
                                                              padding: const EdgeInsets.all(8),
                                                              // margin: const EdgeInsets.only(right: 8),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                              child: Text(
                                                                '00 min 00 sec3',
                                                                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                              ),
                                                            );
                                                          }
                                                          return Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: time.min != null
                                                                ? Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    // margin: const EdgeInsets.only(right: 8),
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                                    child: Text('${time.min} min ${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)))
                                                                : Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    // margin: const EdgeInsets.only(right: 8),
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                                    child: Text(
                                                                      '${time.sec} sec',
                                                                      style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                                    ),
                                                                  ),
                                                          );
                                                        },
                                                        onEnd: () {
                                                          if (liveController.isImSplitted) {
                                                            print("OnEnd called");
                                                            leave();
                                                            Get.back();
                                                          }
                                                          //call the disconnect method from requested customer
                                                        },
                                                      );
                                                    },
                                                  )
                                                : isHostJoinAsAudio
                                                    ? GetBuilder<LiveController>(
                                                        builder: (c) {
                                                          return CountdownTimer(
                                                            endTime: liveController.endTime,
                                                            widgetBuilder: (_, CurrentRemainingTime? time) {
                                                              if (time == null) {
                                                                return Container(
                                                                  padding: const EdgeInsets.all(8),
                                                                  // margin: const EdgeInsets.only(right: 8),
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                                  child: Text(
                                                                    '00 min 00 sec4',
                                                                    style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                                  ),
                                                                );
                                                              }
                                                              return Padding(
                                                                padding: const EdgeInsets.only(left: 10),
                                                                child: time.min != null
                                                                    ? Container(padding: const EdgeInsets.all(8), alignment: Alignment.center, decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)), child: Text('${time.min} min ${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)))
                                                                    : Container(
                                                                        padding: const EdgeInsets.all(8),
                                                                        alignment: Alignment.center,
                                                                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                                        child: Text(
                                                                          '${time.sec} sec',
                                                                          style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                                        ),
                                                                      ),
                                                              );
                                                            },
                                                            onEnd: () {
                                                              if (liveController.isImSplitted) {
                                                                print("OnEnd called");
                                                                leave();
                                                                Get.back();
                                                              }

                                                              //call the disconnect method from requested customer
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : SizedBox()
                                        : CountdownTimer(
                                            endTime: liveController.endTime,
                                            widgetBuilder: (_, CurrentRemainingTime? time) {
                                              if (time == null) {
                                                return Container(
                                                  padding: const EdgeInsets.all(8),
                                                  // margin: const EdgeInsets.only(right: 8),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                  child: Text(
                                                    '00min 00sec',
                                                    style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                  ),
                                                );
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: time.min != null
                                                    ? Container(
                                                        padding: const EdgeInsets.all(8),
                                                        // margin: const EdgeInsets.only(right: 8),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                        child: Text('${time.min} min ${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)))
                                                    : Container(
                                                        padding: const EdgeInsets.all(8),
                                                        // margin: const EdgeInsets.only(right: 8),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                        child: Text(
                                                          '${time.sec} sec',
                                                          style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                        ),
                                                      ),
                                              );
                                            },
                                            onEnd: () {
                                              print("OnEnd called");
                                              leave();
                                              Get.back();
                                              //call the disconnect method from requested customer
                                            },
                                          );
                                  }),
                                  Row(
                                    children: [
                                      isFollowLocal
                                          ? Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.only(right: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                              child: Text(
                                                'Following',
                                                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                global.showOnlyLoaderDialog(context);
                                                await followAstrologerController.addFollowers(astrologerId2!);
                                                global.hideLoader();
                                                if (followAstrologerController.isFollowed) {
                                                  setState(() {
                                                    isFollowLocal = true;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                margin: const EdgeInsets.only(right: 8),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  'Follow',
                                                  style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                                ),
                                              ),
                                            ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        margin: const EdgeInsets.only(right: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                        child: Text(
                                          '$viewer',
                                          style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                          )
                        ]),
                      ],
                    )
                  : Center(
                      child: Text('Astrologer is not live yet!'),
                    ))),
    );
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)));

    await agoraEngine.enableVideo();
    await agoraEngine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
          onRejoinChannelSuccess: (RtcConnection connection, int remoteUId) {
            print(remoteUId);
          },
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            setState(() {
              isJoined = true;
              isHostJoin = true;

              global.localLiveUid = connection.localUid;
            });
            print('you joined ${DateTime.now()}');
            print("local Id: " + connection.localUid.toString());
            print('global liveuser id :- ${global.localLiveUid}');
          },
          onUserJoined: (RtcConnection connection, int remoteUId, int elapsed) {
            print('onUserJoined call');
            if (count == 0) {
              setState(() {
                remoteUid = remoteUId;
                global.localLiveUid2 = remoteUId;
                isHostJoin = true;
                conneId = remoteUId;
                count = 1;
              });

              print('host is joined : ' + remoteUId.toString());
            } else if (remoteUid != null && count == 1) {
              setState(() {
                remoteIdOfConnectedCustomer = remoteUId;
                isImHost = true;
              });
              print('cohost is joined : ' + remoteIdOfConnectedCustomer.toString());
            }

            print('remote call');
          },
          onUserMuteVideo: (RtcConnection conn, int remoteId3, bool muted) {
            print("Muted remoteId:" + remoteId3.toString());
            print("remoteIdOfConnectedCustomer:" + remoteIdOfConnectedCustomer.toString());
            print("match for remoteId3 : ");
            print("Muted or not: " + muted.toString());
            if (muted) {
              if (remoteIdOfConnectedCustomer != remoteId3) {
                //means host and cohost become alternate
                remoteUid = remoteIdOfConnectedCustomer;
                print("RemoteId 85: " + remoteUid.toString());
                setState(() {});
              }
              setState(() {
                isImHost = false;
              });
            } else {
              if (remoteIdOfConnectedCustomer != null) {
                setState(() {
                  isImHost = true;
                });
              }
            }
          },
          onUserOffline: (RtcConnection connection, int remoteUId, UserOfflineReasonType reason) async {
            if (remoteUid == remoteUId) {
              await liveController.deleteLiveAstrologer(astrologerId2!);
              setState(() {
                remoteUid = null;
                isHostJoin = false;
              });
              print('host left');
              leave();
              if (!widget.isFromHome) {
                print('Leave proccess start after leave method from else part !widget.isFromHome');
                bottomNavigationController.setBottomIndex(0, 0);
              } else {
                print('Leave proccess start after leave method from else part');
                Get.back();
              }
            } else {
              setState(() {
                remoteIdOfConnectedCustomer = null;
                isImHost = false;
              });
              log('cohost left - isImHost' + isImHost.toString());
              print("Offline remoteId " + remoteUId.toString());
              print("Reason for offline:" + reason.name);
            }
          },
          onStreamMessage: (connection, remoteUid, streamId, data, length, sentTs) {},
          onRemoteVideoStateChanged: (RtcConnection con, int remoteId, RemoteVideoState st, RemoteVideoStateReason reason, int ok) {
            print(remoteId);
          },
          onClientRoleChanged: (RtcConnection constate, ClientRoleType oldRoleType, ClientRoleType newRoleType, option) {
            print("onClientRoleChanged");

            if (isHostJoinAsAudio == false) {
              setState(() {
                isImHost = true;
              });
            }
          }),
    );

    currentUserName = splashController.currentUser!.name! != "" ? splashController.currentUser!.name ?? "" : "User";
    currentUserProfile = splashController.currentUser!.profile! != "" ? "${global.imgBaseurl}${splashController.currentUser!.profile}" : "";

    join();
    ConnectionStateType callId = await agoraEngine.getConnectionState();
    print("Call Id:" + callId.name);
  }

  agoraEnableAudio() async {
    await agoraEngine.enableAudio();
  }

  Widget _videoPanel() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: channel2),
        ),
      );
    } else {
      log("Astrologer else part while not join");
      return const Text(
        'Astrologer not  join..',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _videoPanelForLocal() {
    if (remoteIdOfConnectedCustomer == null) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: remoteIdOfConnectedCustomer),
          connection: RtcConnection(channelId: channel2),
        ),
      );
    }
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;

    // Set channel profile and client role

    options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleAudience,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    );

    if (token2 != "" || channel2 != "") {
      await agoraEngine.joinChannel(
        token: token2!,
        channelId: channel2!,
        options: options,
        uid: uid,
      );

      setState(() {
        isJoined = true;
      });
    }

    log('customer join method');
  }

  Future leave() async {
    print("Leave proccess start11");

    print("Leave proccess start");
    setState(() {
      isJoined = false;
    });
    liveController.isImSplitted = false;
    liveController.update();
    client.logout();

    liveController.isImInLive = false;
    liveController.update();
    if (widget.isForLiveCallAcceptDecline == true) {
      Get.back();
      print("Get back from leave()");
      int index5 = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
      if (index5 != -1) {
        await liveController.deleteFromWaitList(liveController.waitList[index5].id);
      }
      if (global.user.walletAmount! > 0) {
        await liveController.cutPaymentForLive(global.user.id!, liveController.totalCompletedTime, astrologerId2!, widget.requesType!, "", sId1: global.agoraSid1, sId2: global.agoraSid2, channelName: channel2);
        print("Going to call stopRecording");
        if (liveController.callId != null) {
          int? callId;
          print('in if stop recording condition');

          callId = liveController.callId;
          print('second call id:- $callId');

          await stopRecord(callId!);
          await stopRecord2(callId);
        }
        print("After call recording started");
      }
      timer!.cancel();
      timer2!.cancel();
    }
    print("notification sended to the partner");
    if (liveController.isJoinAsChat) {
      global.callOnFcmApiSendPushNotifications(
          fcmTokem: ["${liveController.astrologerFcmToken}"],
          title: "For Live Streaming Chat",
          subTitle: "For Live Streaming Chat",
          sendData: {
            "sessionType": "end",
            "chatId": "5_10",
          });
      //here we need to call methods to all other users for stop timer.
      int index5 = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
      if (index5 != -1) {
        await liveController.deleteFromWaitList(liveController.waitList[index5].id);
      }
      liveController.timer2!.cancel();
      if (global.user.walletAmount! > 0) {
        await liveController.cutPaymentForLive(global.user.id!, liveController.totalCompletedTimeForChat, astrologerId2!, "Chat", liveController.chatId!, sId1: global.agoraSid1, sId2: global.agoraSid2, channelName: channel2);
      }
      print('chat caiiId ${liveController.callId}');
      if (liveController.callId != null) {
        int? callId;

        callId = liveController.callId;

        await stopRecord(liveController.callId!);
        await stopRecord2(callId!);
      }
    }
    if (isHostJoinAsAudio == false) {
      if (isImHost == true) {
        agoraEngine.leaveChannel();
        agoraEngine.release(sync: true);
      } else {
        //agoraEngine.leaveChannel();
        agoraEngine.release(sync: true);
        // agoraEngine.leaveChannel(sync: true);
      }
    } else {
      agoraEngine.leaveChannel();
      agoraEngine.release(sync: true);
    }

    log('customer left');
    liveController.isLeaveCalled = true;
    liveController.update();
    await liveController.removeLiveuserData();
    if (widget.isFromNotJoined ?? false) {
      print('in isfromjoned');
      print('get.back when join with chat');
      Get.back();
    }
    print('after if');
    // }
  }

  @override
  void dispose() async {
    print("dispose called with isLeaveCalled" + liveController.isLeaveCalled.toString());

    // ignore: unnecessary_null_comparison
    if (agoraEngine != null) {
      client.logout();
      liveController.isImSplitted = false;
      liveController.update();

      liveController.isImInLive = false;
      liveController.update();

      log('customer left on dispose');

      if (widget.isForLiveCallAcceptDecline == true) {
        int index5 = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
        if (index5 != -1) {
          await liveController.deleteFromWaitList(liveController.waitList[index5].id);
        }
        if (global.user.walletAmount! > 0) {
          await liveController.cutPaymentForLive(global.user.id!, liveController.totalCompletedTime, astrologerId2!, widget.requesType!, "", sId1: global.agoraSid1, sId2: global.agoraSid2, channelName: channel2);
          if (liveController.callId != null) {
            int? callId;

            callId = liveController.callId;

            await stopRecord(liveController.callId!);
            await stopRecord2(callId!);
          }
        }
        timer!.cancel();
        timer2!.cancel();
      }
      if (liveController.isJoinAsChat) {
        global.callOnFcmApiSendPushNotifications(
            fcmTokem: ["${liveController.astrologerFcmToken}"],
            title: "For Live Streaming Chat",
            subTitle: "For Live Streaming Chat",
            sendData: {
              "sessionType": "end",
              "chatId": "5_10",
            });
        int index5 = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
        if (index5 != -1) {
          await liveController.deleteFromWaitList(liveController.waitList[index5].id);
        }
        liveController.timer2!.cancel();
        if (global.user.walletAmount! > 0) {
          await liveController.cutPaymentForLive(global.user.id!, liveController.totalCompletedTimeForChat, astrologerId2!, "Chat", liveController.chatId!, sId1: global.agoraSid1, channelName: channel2, sId2: global.agoraSid2);
        }
        if (liveController.callId != null) {
          int? callId;

          callId = liveController.callId;

          await stopRecord(liveController.callId!);
          await stopRecord2(callId!);
        }
      }
      if (isHostJoinAsAudio == false) {
        if (isImHost == true) {
          agoraEngine.leaveChannel();
          agoraEngine.release(sync: true);
        } else {
          //agoraEngine.leaveChannel();
          agoraEngine.release(sync: true);
          // agoraEngine.leaveChannel(sync: true);
        }
      } else {
        agoraEngine.leaveChannel();
        agoraEngine.release(sync: true);
      }
    }
    await liveController.removeLiveuserData();

    super.dispose();
  }

  Future generateToken() async {
    try {
      int? id = global.sp!.getInt('currentUserId');
      currentUserName = splashController.currentUser!.name! != "" ? splashController.currentUser!.name ?? "" : "User";
      currentUserProfile = splashController.currentUser!.profile! != "" ? "${global.imgBaseurl}${splashController.currentUser!.profile}" : "";
      chatuid = "AgoraLiveUser_$id&&$currentUserName";
      channelId = "liveAstrologer_$astrologerId2";
      global.showOnlyLoaderDialog(context);
      await liveController.getRtmToken(global.getSystemFlagValue(global.systemFlagNameList.agoraAppId), global.getSystemFlagValue(global.systemFlagNameList.agoraAppCertificate), chatuid, channelId);
      global.hideLoader();

      log("chat token:-${global.agoraChatToken}");
      log("object");
    } catch (e) {
      print("Exception in gettting token: ${e.toString()}");
    }
  }

  Future<void> createClient() async {
    client = await AgoraRtmClient.createInstance(global.getSystemFlagValue(global.systemFlagNameList.agoraAppId));
    client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      log('message sent ...... ${message.text}');
      setState(() {
        messageList.add(MessageModel(
          message: message.text,
          userName: message.text,
          profile: currentUserProfile,
          isMe: true,
        ));
        reverseList = messageList.reversed.toList();
      });
    };

    await generateToken();
    login();
  }

  void login() async {
    if (chatuid.isEmpty) {
      log('Enter userId');
    }
    try {
      log('client $client');
      await generateToken();
      print('chat uid :- $chatuid');
      await client.login(global.agoraChatToken, chatuid);
      joinChannel();
      log("login success:");
    } catch (e) {
      log("Exception in login:- $e");
    }
  }

  void joinChannel() async {
    if (channelId.isEmpty) {
      log("Please input channel id to join.");
      return;
    }
    try {
      channel = await createChannel(channelId);
      await channel.join();
      channel.getMembers().then((value) {
        print("Members count: " + value.toString());
        viewer = value.length;
        setState(() {});
      });
    } catch (e) {
      log("Exception in joinChannel:- $e");
    }
  }

  Future<AgoraRtmChannel> createChannel(String name) async {
    AgoraRtmChannel? channel = await client.createChannel(name);
    channel!.onMemberJoined = (member) async {
      log("member joined: ${member.userId},channel:${member.channelId}");
      setState(() {
        messageList.add(MessageModel(
          message: 'joined',
          userName: member.userId.split("&&")[1],
          profile: "",
          isMe: true,
        ));
        reverseList = messageList.reversed.toList();
      });
      channel.getMembers().then((value) {
        print("Members count: " + value.toString());
        viewer = value.length;
        setState(() {});
      });
      if (liveController.isImSplitted == true) {
        liveController.getLiveuserData(channel2!).then((value) async {
          print("Live users :" + liveController.liveUsers[0].fcmToken!);
          List<String> otherJoinUsersFcmTokens = [];
          if (liveController.liveUsers.isNotEmpty) {
            for (var i = 0; i < liveController.liveUsers.length; i++) {
              if (liveController.liveUsers[i].fcmToken != null) {
                otherJoinUsersFcmTokens.add(liveController.liveUsers[i].fcmToken!);
              }
            }
          }
          String myToken = liveController.liveUsers.where((element) => element.userId == global.user.id).first.fcmToken!;
          otherJoinUsersFcmTokens.removeWhere((element) => element == myToken);
          String time = liveController.waitList.where((element) => element.userId == global.user.id).first.time;
          int timeIn = int.parse(time.toString());
          timeIn = timeIn - liveController.totalCompletedTime;
          print("otherJoinUsersFcmTokens" + otherJoinUsersFcmTokens.toString());
          await global.callOnFcmApiSendPushNotifications(fcmTokem: otherJoinUsersFcmTokens, title: "For accepting time while user already splitted", subTitle: "For accepting time while user already splitted", sendData: {
            "timeInInt": timeIn,
            "joinUserName": global.user.name,
            "joinUserProfile": global.user.profile,
          });
        });
      }
    };
    channel.onMemberLeft = (member) {
      log("member left: ${member.userId},channel:${member.channelId}");
      channel.getMembers().then((value) {
        print("Left Members count: " + value.toString());
        viewer = value.length;
        setState(() {});
      });
    };
    channel.onMessageReceived = (message, fromMember) {
      log("Public Message from  ${fromMember.userId} :  ${message.text}");
      setState(() {
        messageList.add(MessageModel(
          message: message.text.split("&&")[1],
          userName: message.text.split("&&")[0],
          profile: message.text.split("&&")[2],
          isMe: true,
          gift: message.text.split("&&")[3],
        ));

        reverseList = messageList.reversed.toList();
        print("Public Message from ${reverseList.length} ");
      });
    };
    channel.onAttributesUpdated = (List<AgoraRtmChannelAttribute> attributes) {
      print("Channel attributes are updated");
    };
    return channel;
  }

  void sendChannelMessage(String channelMessage, String? gift) async {
    try {
      await channel.sendMessage(AgoraRtmMessage.fromText('$currentUserName&&$channelMessage&&$currentUserProfile&&$gift'));
      log('channelId -------->$channelId');
      setState(() {
        messageList.add(MessageModel(
          message: channelMessage,
          userName: currentUserName,
          profile: currentUserProfile,
          isMe: true,
          gift: gift,
        ));
        reverseList = messageList.reversed.toList();
      });
      if (liveController.isJoinAsChat) {
        print('live chat sendchannelmessage $astrologerId2');
        await sendMessage(astrologerId2!);
      }

      print('channel message sent :-');
    } catch (e) {
      // ignore: avoid_print
      print("Exception in sendChannelMessage: -${e.toString()}");
    }
  }

  Widget callWidget(IconData icon, String title, String description, Function onJoin) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
              child: Icon(icon),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Get.textTheme.bodySmall!),
                  SizedBox(
                    child: Text(
                      description,
                      style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: onJoin(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Get.theme.primaryColor),
                  child: Text(
                    "join",
                    style: Get.textTheme.bodyText1!.copyWith(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future startRecord() async {
    CallController callController = Get.find<CallController>();
    await callController.agoraStartRecording(widget.channel, global.localLiveUid!, widget.token);
  }

  Future startRecord2() async {
    CallController callController = Get.find<CallController>();
    await callController.agoraStartRecording2(widget.channel, global.localLiveUid2!, widget.token);
  }

  Future stopRecord(int callId) async {
    CallController callController = Get.find<CallController>();
    print('stop1 audio recording in live astrologer');
    await callController.agoraStopRecording(callId, widget.channel, global.localLiveUid!);
  }

  Future stopRecord2(int callId) async {
    CallController callController = Get.find<CallController>();
    print('stop2 audio recording in live astrologer');
    await callController.agoraStopRecording2(callId, widget.channel, global.localLiveUid2!);
  }
}
