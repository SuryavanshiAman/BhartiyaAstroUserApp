import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/call/accept_call_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../controllers/bottomNavigationController.dart';
import '../bottomNavigationBarScreen.dart';

// ignore: must_be_immutable
class IncomingCallRequest extends StatelessWidget {
  final String? astrologerName;
  final String? astrologerProfile;
  final int astrologerId;
  final int callId;
  final String token;
  final String channel;
  final String fcmToken;

  IncomingCallRequest(
      {super.key,
      this.astrologerName,
      required this.fcmToken,
      required this.callId,
      this.astrologerProfile,
      required this.astrologerId,
      required this.token,
      required this.channel});
  CallController callController = Get.find<CallController>();

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
                          child: astrologerProfile == ""
                              ? Image.asset(
                                  Images.deafultUser,
                                  fit: BoxFit.fill,
                                  height: 50,
                                  width: 40,
                                )
                              : CachedNetworkImage(
                                  imageUrl: '${global.imgBaseurl}$astrologerProfile',
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
                          astrologerName == null || astrologerName == "" ? "Astrologer" : astrologerName ?? "Astrologer",
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
                            global.showOnlyLoaderDialog(context);
                                          FlutterRingtonePlayer.stop();
                            await callController.rejectedCall(callId);
              
                            global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'Reject call request from astrologer');
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
                        InkWell(
                          onTap: () async {
                            global.showOnlyLoaderDialog(context);
                             FlutterRingtonePlayer.stop();
                            await callController.acceptedCall(callId);
                            global.hideLoader();
                           
                            Get.to(() => AcceptCallScreen(
                                  astrologerId: astrologerId,
                                  astrologerName: astrologerName == null || astrologerName == "" ? "Astrologer" : astrologerName ?? "Astrologer",
                                  astrologerProfile: astrologerProfile,
                                  token: token,
                                  callChannel: channel,
                                  callId: callId,
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
