// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/liveAstrologerController.dart';
import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/controllers/upcoming_controller.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/astrologerProfile/astrologerProfile.dart';
import 'package:BharatiyAstro/views/live_astrologer/astrologer_event_search_screen.dart';
import 'package:BharatiyAstro/views/live_astrologer/live_astrologer_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_translator/google_translator.dart';
import '../controllers/reviewController.dart';

class LiveAstrologerListScreen extends StatelessWidget {
  bool? isFromBottom;
  LiveAstrologerListScreen({super.key, this.isFromBottom = false});

  LiveAstrologerController liveAstrologerController = Get.find<LiveAstrologerController>();

  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  LiveController liveController = Get.find<LiveController>();
  UpcomingController upcomingController = Get.find<UpcomingController>();
  SplashController splashController = Get.find<SplashController>();
  ScreenshotController screenshotController = ScreenshotController();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isFromBottom == true) {
          bottomNavigationController.setBottomIndex(0, 0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'Live Astrologers',
            style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
          ),
          leading: isFromBottom == true
              ? const SizedBox()
              : IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Get.theme.iconTheme.color,
                  ),
                ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => SearchLiveAstrologer());
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: Column(
          children: [
            Container(
              width: Get.width,
              child: TabBar(
                controller: liveAstrologerController.tabController,
                indicatorColor: Get.theme.primaryColor.withOpacity(0.9),
                unselectedLabelColor: Colors.black.withOpacity(0.5),
                labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                labelColor: Colors.black,
                onTap: (index) async {
                  global.showOnlyLoaderDialog(context);
                  upcomingController.getUpcomingAstrologerList();
                  upcomingController.update();
                  global.hideLoader();
                },
                tabs: [
                  Tab(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text('Ongoing'),
                      ],
                    ),
                  ),
                  Tab(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text('Upcoming'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: liveAstrologerController.tabController,
              children: [
                bottomNavigationController.liveAstrologer.isEmpty
                    ? Center(
                        child: Text('No astrologers live yet!'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3.5 / 5,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                          ),
                          itemCount: bottomNavigationController.liveAstrologer.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                bottomNavigationController.anotherLiveAstrologers = bottomNavigationController.liveAstrologer.where((element) => element.astrologerId != bottomNavigationController.liveAstrologer[index].astrologerId).toList();
                                bottomNavigationController.update();
                                liveController.getWaitList(bottomNavigationController.liveAstrologer[index].channelName);
                                liveController.isImInLive = true;
                                liveController.isJoinAsChat = false;
                                liveController.isLeaveCalled = false;
                                liveController.update();
                                Get.to(() => LiveAstrologerScreen(
                                      token: bottomNavigationController.liveAstrologer[index].token,
                                      channel: bottomNavigationController.liveAstrologer[index].channelName,
                                      astrologerName: bottomNavigationController.liveAstrologer[index].name,
                                      astrologerId: bottomNavigationController.liveAstrologer[index].astrologerId,
                                      isFromHome: true,
                                      charge: bottomNavigationController.liveAstrologer[index].charge,
                                      isForLiveCallAcceptDecline: false,
                                      videoCallCharge: bottomNavigationController.liveAstrologer[index].videoCallRate,
                                      isFollow: bottomNavigationController.liveAstrologer[index].isFollow!,
                                    ));
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                  ),
                                  image: bottomNavigationController.liveAstrologer[index].profileImage == ""
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            Images.deafultUser,
                                          ),
                                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            '${global.imgBaseurl}${bottomNavigationController.liveAstrologer[index].profileImage}',
                                          ),
                                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)),
                                ),
                                padding: EdgeInsets.only(bottom: 20),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Get.theme.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 3),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 3,
                                            backgroundColor: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            'LIVE',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${bottomNavigationController.liveAstrologer[index].name}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GetBuilder<UpcomingController>(builder: (upcomingList) {
                      return ListView.builder(
                        itemCount: upcomingController.upComingList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Get.find<ReviewController>().getReviewData(upcomingController.upComingList[index].id!);
                                    global.showOnlyLoaderDialog(context);
                                    await bottomNavigationController.getAstrologerbyId(upcomingController.upComingList[index].id!);
                                    global.hideLoader();
                                    Get.to(() => AstrologerProfile(index: index));
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                child: Container(
                                                  height: 65,
                                                  width: 65,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Get.theme.primaryColor),
                                                    borderRadius: BorderRadius.circular(7),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor: Colors.white,
                                                    child: CachedNetworkImage(
                                                      imageUrl: '${global.imgBaseurl}${upcomingController.upComingList[index].profileImage}',
                                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                      errorWidget: (context, url, error) => Image.asset(
                                                        Images.deafultUser,
                                                        fit: BoxFit.cover,
                                                        height: 50,
                                                        width: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${upcomingController.upComingList[index].name}',
                                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
                                                  ),
                                                  Text(
                                                    "${DateFormat("dd MMM,EEEE").format(DateTime.now())}",
                                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  upcomingController.upComingList[index].isTimeSlotAvailable == true
                                                      ? Container(
                                                          height: 20,
                                                          width: 110,
                                                          child: ListView.builder(
                                                              scrollDirection: Axis.horizontal,
                                                              shrinkWrap: true,
                                                              itemCount: upcomingController.upComingList[index].availableTimes!.length,
                                                              itemBuilder: (BuildContext context, int index2) {
                                                                return (upcomingController.upComingList[index].availableTimes![index2].fromTime != null && upcomingController.upComingList[index].availableTimes![index2].toTime != null)
                                                                    ? Container(
                                                                        margin: EdgeInsets.only(left: 2),
                                                                        padding: EdgeInsets.all(2),
                                                                        decoration: BoxDecoration(color: Colors.grey[300], border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                        child: Text(
                                                                          "${upcomingController.upComingList[index].availableTimes![index2].fromTime} - ${upcomingController.upComingList[index].availableTimes![index2].toTime}",
                                                                          style: TextStyle(fontSize: 9.5),
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        "No Time set yet!",
                                                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                          fontWeight: FontWeight.w300,
                                                                          color: Colors.red,
                                                                        ),
                                                                      );
                                                              }),
                                                        )
                                                      : Text(
                                                          "No Time set yet!",
                                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                            fontWeight: FontWeight.w300,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  global.showOnlyLoaderDialog(Get.context);
                                                  String appShareLink;
                                                  String applink;
                                                  final DynamicLinkParameters parameters = DynamicLinkParameters(
                                                    uriPrefix: 'https://BharatiyAstroupdated.page.link',
                                                    link: Uri.parse("https://BharatiyAstroupdated.page.link/userProfile?screen=astroProfile"),
                                                    androidParameters: AndroidParameters(
                                                      packageName: 'com.BharatiyAstro.app',
                                                      minimumVersion: 1,
                                                    ),
                                                  );
                                                  Uri url;
                                                  final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
                                                  url = shortLink.shortUrl;
                                                  appShareLink = url.toString();
                                                  applink = appShareLink;
                                                  global.hideLoader();

                                                  await FlutterShare.share(
                                                    title: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
                                                    text: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
                                                    linkUrl: '$applink',
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.share_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    })),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
