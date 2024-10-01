import 'dart:async';

import 'package:BharatiyAstro/views/live_astrologer/live_astrologer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveAstrologerFirstScreen extends StatefulWidget {
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
  final bool isFromNotJoined;
  final double videoCallCharge;
  final bool isFollow;
  const LiveAstrologerFirstScreen({
    super.key,
    required this.token,
    required this.isForLiveCallAcceptDecline,
    required this.charge,
    required this.channel,
    required this.astrologerName,
    this.requesType,
    this.chatToken,
    this.astrologerProfile,
    required this.astrologerId,
    required this.isFromHome,
    required this.isFromNotJoined,
    required this.videoCallCharge,
    required this.isFollow,
  });

  @override
  State<LiveAstrologerFirstScreen> createState() => _LiveAstrologerFirstScreenState();
}

class _LiveAstrologerFirstScreenState extends State<LiveAstrologerFirstScreen> {
  bool isTimeDone = false;
  Timer? timer;
  bool isLive = false;
  @override
  void initState() {
    isTimeDone = false;
    setState(() {});
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      isTimeDone = true;
      setState(() {});
      if (!isLive) {
        setState(() {
          isLive = true;
        });

        Get.to(() => LiveAstrologerScreen(
              token: widget.token,
              isForLiveCallAcceptDecline: widget.isForLiveCallAcceptDecline,
              charge: widget.charge,
              channel: widget.channel,
              astrologerName: widget.astrologerName,
              astrologerId: widget.astrologerId,
              isFromHome: widget.isFromHome,
              isFromNotJoined: widget.isFromNotJoined,
              videoCallCharge: widget.videoCallCharge,
              isFollow: widget.isFollow,
              astrologerProfile: widget.astrologerProfile,
            ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(body: Container()));
  }
}
