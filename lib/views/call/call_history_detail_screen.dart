import 'dart:io';

import 'package:BharatiyAstro/controllers/history_controller.dart';
import 'package:BharatiyAstro/model/businessLayer/baseRoute.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../controllers/bottomNavigationController.dart';
import '../../controllers/reviewController.dart';
import '../../utils/images.dart';
import '../astrologerProfile/astrologerProfile.dart';

class CallHistoryDetailScreen extends BaseRoute {
  final int astrologerId;
  final String astrologerProfile;
  final int index;
  CallHistoryDetailScreen({a, o, required this.astrologerId, required this.astrologerProfile, required this.index}) : super(a: a, o: o, r: 'callHistoryDetailScreen');
  final HistoryController historyController = Get.find<HistoryController>();
  final BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await historyController.disposeAudioPlayer();
        // await historyController.disposeAudioPlayer2();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: GestureDetector(
            onTap: () async {
              Get.find<ReviewController>().getReviewData(astrologerId);
              global.showOnlyLoaderDialog(context);
              await bottomNavigationController.getAstrologerbyId(astrologerId);
              global.hideLoader();
              Get.to(() => AstrologerProfile(
                    index: 0,
                  ));
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                  child: astrologerProfile == "" || historyController.callHistoryListById.isEmpty
                      ? Image.asset(
                          Images.deafultUser,
                          height: 40,
                          width: 30,
                        )
                      : CachedNetworkImage(
                          imageUrl: '${global.imgBaseurl}$astrologerProfile',
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            Images.deafultUser,
                            height: 40,
                            width: 30,
                          ),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  historyController.callHistoryListById.isEmpty ? "" : historyController.callHistoryListById[0].astrologerName!,
                  style: Get.theme.primaryTextTheme.headline6!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              // await historyController.disposeAudioPlayer();
              // await historyController.disposeAudioPlayer2();
              Get.back();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
        ),
        body: historyController.callHistoryListById.isEmpty
            ? Center(
                child: Text('No Details Found'),
              )
            : Container(
                width: Get.width,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(Images.bgImage),
                  ),
                ),
                child: ListView(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appoinment Schedule:',
                              style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text('Expert Name: ${historyController.callHistoryListById[0].astrologerName}'),
                            Text(
                              "${DateFormat("dd MMM yy, hh:mm a").format(DateTime.parse(historyController.callHistoryListById[0].createdAt.toString()))}",
                            ),
                            Text('Duration: ${historyController.callHistoryListById[0].totalMin ?? 0} Minutes'),
                            Text('Price: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.callHistoryListById[0].callRate}'),
                            Text('Deduction: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.callHistoryListById[0].deduction}')
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GetBuilder<HistoryController>(builder: (historyController) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                child: IconButton(
                                  onPressed: () async {
                                    // try {
                                    //   if (historyController.isPlay) {
                                    //     await historyController.audioPlayer.pause();
                                    //     await historyController.audioPlayer2.pause();
                                    //   } else {
                                    //     print('startPlay');

                                    //     await historyController.audioPlayer.play(UrlSource("https://storage.googleapis.com/BharatiyAstro_bucket/${historyController.callHistoryListById[0].sId}_${historyController.callHistoryListById[0].channelName}.m3u8"));
                                    //     if (historyController.callHistoryListById[index].sId1 != null && historyController.callHistoryListById[index].sId1 != "") {
                                    //       await historyController.audioPlayer2.play(UrlSource("https://storage.googleapis.com/BharatiyAstro_bucket/${historyController.callHistoryListById[0].sId1}_${historyController.callHistoryListById[0].channelName}.m3u8"));
                                    //     }
                                    //   }
                                    //   historyController.isPlay = !historyController.isPlay;
                                    //   historyController.update();
                                    // } catch (e) {
                                    //   print('audio Exception :- $e');
                                    // }
                                  },
                                  icon: Icon(
                                    historyController.isPlay ? Icons.pause : Icons.play_arrow,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Slider(
                                    value: historyController.position.inSeconds.toDouble(),
                                    max: historyController.duration.inSeconds.toDouble(),
                                    min: 0,
                                    onChanged: (_) {},
                                  ),
                                  Container(
                                    width: Get.width - 180,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${Duration(
                                            seconds: historyController.position.inSeconds.toInt(),
                                          ).toString().split(".")[0]}',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          '${Duration(seconds: historyController.duration.inSeconds.toInt()).toString().split(".")[0]}',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  global.createAndShareLinkForHistoryChatCall();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(Icons.share),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
