import 'dart:convert';

import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/call/accept_call_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import '../../controllers/bottomNavigationController.dart';
import '../bottomNavigationBarScreen.dart';

// ignore: must_be_immutable
class IncomingCallRequest extends StatefulWidget {
  final String? astrologerName;
  final String? astrologerProfile;
  final int astrologerId;
  final int callId;
  final String token;
  final String channel;
  final String fcmToken;
  final bool? isSoundOn;

  IncomingCallRequest(
      {super.key,
      this.astrologerName,
      required this.fcmToken,
      required this.callId,
      this.astrologerProfile,
      required this.astrologerId,
      required this.token,
      required this.channel,
       this.isSoundOn,
      });

  @override
  State<IncomingCallRequest> createState() => _IncomingCallRequestState();
}

class _IncomingCallRequestState extends State<IncomingCallRequest> with WidgetsBindingObserver{
  CallController callController = Get.find<CallController>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
   widget.isSoundOn==true? FlutterRingtonePlayer.play(fromAsset: "assets/sound/music.mp3"):null;
   // widget.isSoundOn==true? FlutterRingtonePlayer.stop():null;
    _firebaseMessaging.getToken().then((String? token) {
      print("FCM Token: $token");
    });

    // Handle notifications when the app is in the background or terminated
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FlutterRingtonePlayer.stop();
      // Handle incoming message when the app is in the foreground
      print("Received a message while the app is in the foreground");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      FlutterRingtonePlayer.stop();
      // Handle the notification click event when the app is in the background or terminated
      print("Notification clicked");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer when disposing
    super.dispose();
  }
  @override


  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App goes to background
      print("App is in the background");
      FlutterRingtonePlayer.stop();
    } else if (state == AppLifecycleState.resumed) {
      print("App is in the foreground");
      FlutterRingtonePlayer.stop();
      print("App is in the foreground");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
        bottomNavigationController.setIndex(1, 0);
        Get.to(() => BottomNavigationBarScreen(index: 1));
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Get.theme.primaryColor,
                          radius: 50,
                          child: widget.astrologerProfile == ""
                              ? Image.asset(
                                  Images.deafultUser,
                                  fit: BoxFit.fill,
                                  height: 50,
                                  width: 40,
                                )
                              : CachedNetworkImage(
                                  imageUrl: '${global.imgBaseurl}${widget.astrologerProfile}',
                                  imageBuilder: (context, imageProvider) => CircleAvatar(
                                    radius: 48,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Image.asset(
                                    Images.deafultUser,
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 40,
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.astrologerName == null || widget.astrologerName == "" ? "Astrologer" : widget.astrologerName ?? "Astrologer",
                          style: Get.textTheme.headline5,
                        ),
                      ],
                    ),
                    Text(
                      "Please accept call request",
                      style: Get.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CircleAvatar(
                    //   backgroundColor: Get.theme.primaryColor,
                    //   backgroundImage: AssetImage("assets/images/splash.png"),
                    // ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      '${global.getSystemFlagValue(global.systemFlagNameList.appName)}',
                      style: Get.textTheme.headline5,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            print("CalCutgya");
                            global.showOnlyLoaderDialog(context);
                            try{
                              setState(() {
                                FlutterRingtonePlayer.stop();
                              });

                              print("CalCutgya1");
                            }catch(e){
                              print("WWwW$e");
                            }
                            await callController.rejectedCall(widget.callId);

                            global.callOnFcmApiSendPushNotifications(fcmTokem: [widget.fcmToken], title: 'Reject call request from astrologer');
                            global.hideLoader();
                            BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                            bottomNavigationController.setIndex(0, 0);
                            Get.to(() => BottomNavigationBarScreen(
                                  index: 0,
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () async {
                        //     try {
                        //       retryStopRingtone();
                        //     } catch (e) {
                        //       print("Initial stop failed, retrying after delay: $e");
                        //     }
                        //
                        //     await Future.delayed(Duration(milliseconds: 200));
                        //     try {
                        //       retryStopRingtone();
                        //     } catch (e) {
                        //       print("Delayed stop attempt failed: $e");
                        //     }
                        //
                        //     global.showOnlyLoaderDialog(context);
                        //     try {
                        //       await callController.rejectedCall(callId);
                        //       global.callOnFcmApiSendPushNotifications(
                        //         fcmTokem: [fcmToken],
                        //         title: 'Reject call request from astrologer',
                        //       );
                        //     } catch (e) {
                        //       print("Error rejecting call: $e");
                        //     } finally {
                        //       global.hideLoader();
                        //       BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                        //       bottomNavigationController.setIndex(0, 0);
                        //       Get.to(() => BottomNavigationBarScreen(index: 0));
                        //     }
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(10),
                        //     margin: const EdgeInsets.only(right: 20),
                        //     decoration: BoxDecoration(
                        //       color: Colors.red,
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: Icon(
                        //       Icons.phone,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),

                        InkWell(
                          onTap: () async {
                            global.showOnlyLoaderDialog(context);
                            setState(() {
                              FlutterRingtonePlayer.stop();
                            });

                            await callController.acceptedCall(widget.callId);
                            global.hideLoader();

                            Get.to(() => AcceptCallScreen(
                                  astrologerId: widget.astrologerId,
                                  astrologerName: widget.astrologerName == null || widget.astrologerName == "" ? "Astrologer" : widget.astrologerName ?? "Astrologer",
                                  astrologerProfile: widget.astrologerProfile,
                                  token: widget.token,
                                  callChannel: widget.channel,
                                  callId: widget.callId,
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.ring_volume,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
