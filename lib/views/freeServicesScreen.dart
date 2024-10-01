import 'dart:io';

import 'package:BharatiyAstro/controllers/astrologyBlogController.dart';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/dailyHoroscopeController.dart';
import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:BharatiyAstro/controllers/kundliMatchingController.dart';
import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:BharatiyAstro/views/astroBlog/astrologyBlogListScreen.dart';
import 'package:BharatiyAstro/views/astroBlog/astrologyDetailScreen.dart';
import 'package:BharatiyAstro/views/astrologerVideo.dart';
import 'package:BharatiyAstro/views/blog_screen.dart';
import 'package:BharatiyAstro/views/daily_horoscope/dailyHoroScopeDetailScreen.dart';
import 'package:BharatiyAstro/views/kudali/kundliScreen.dart';
import 'package:BharatiyAstro/views/kundliMatching/kundliMatchingScreen.dart';
import 'package:BharatiyAstro/views/liveAstrologerList.dart';
import 'package:BharatiyAstro/views/live_astrologer/live_astrologer_screen.dart';
import 'package:BharatiyAstro/views/panchangScreen.dart';

import 'package:BharatiyAstro/widget/contactAstrologerBottomButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../utils/images.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

// ignore: must_be_immutable
class FreeServiceScreen extends StatelessWidget {
  FreeServiceScreen({Key? key}) : super(key: key);
  DailyHoroscopeController dailyHoroscopeController = Get.find<DailyHoroscopeController>();
  BottomNavigationController bottomController = Get.find<BottomNavigationController>();
  LiveController liveController = Get.find<LiveController>();
  KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
            title: Text(
              'Free Services',
              style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
            actions: []),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<DailyHoroscopeController>(builder: (dailyController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  (dailyHoroscopeController.dailyList != null)
                      ? DailyHoroscopeContainer(
                          isFreeServices: true,
                          date: dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                              ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].horoscopeDate != null
                                  ? DateFormat('dd-MM-yyyy').format(dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].horoscopeDate!)
                                  : DateFormat('dd-MM-yyyy').format(DateTime.now())
                              : DateFormat('dd-MM-yyyy').format(DateTime.now()),
                          luckyNumber: dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                              ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyNumber != null
                                  ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyNumber
                                  : ""
                              : "",
                          luckyTime: dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                              ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyTime != null
                                  ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyTime
                                  : ""
                              : "",
                          moodOfDay: dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].moodday ?? "" : "",
                          colorCode: dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                              ? (dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor != null && dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor != "")
                                  ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor!.split("#")[1]
                                  : ""
                              : "")
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customContainer('${global.imgBaseurl}${global.getSystemFlagValue(global.systemFlagNameList.freeKundli)}'),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: detailText('Free Kundli', 'Enter your birth details & get a personalised kundli report with detailed analysis.', 'Get report', () async {
                        bool isLogin = await global.isLogin();
                        if (isLogin) {
                          Get.to(() => KundaliScreen());
                        }
                      }))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: detailText('Kundli-Matching', 'Check marriage compatibility & the strength of your love life by matching your kundli.', 'Get report', () {
                        Get.find<KundliMatchingController>().homeTabIndex.value = 1;
                        Get.to(() => KundliMatchingScreen());
                      })),
                      SizedBox(
                        width: 10,
                      ),
                      customContainer('${global.imgBaseurl}${global.getSystemFlagValue(global.systemFlagNameList.kundliMatching)}'),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 20),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Today\'s Panchang', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                                  Text('New Delhi,Delhi,India', style: Get.textTheme.bodySmall),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [panchangTime('Sunrise-sunset', Colors.orange, Color.fromARGB(255, 236, 209, 168), Icons.sunny, '06:32-17:36'), panchangTime('Moonrise-Moonset', Colors.blue, Color.fromARGB(255, 211, 232, 250), Icons.wb_sunny, '13:32-00:06')],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              kundliController.kundliBasicPanchangDetail == null
                                  ? SizedBox()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text('Tithi'),
                                        ),
                                        Text('${kundliController.kundliBasicPanchangDetail!.tithi}', style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey))
                                      ],
                                    ),
                              kundliController.kundliBasicPanchangDetail == null
                                  ? SizedBox()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text('Yoga'),
                                        ),
                                        Text(
                                          '${kundliController.kundliBasicPanchangDetail!.yog != null ? kundliController.kundliBasicPanchangDetail!.yog : '--'}',
                                          style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey),
                                        )
                                      ],
                                    ),
                              kundliController.kundliBasicPanchangDetail == null
                                  ? SizedBox()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text('Nakshatra'),
                                        ),
                                        Text('${kundliController.kundliBasicPanchangDetail!.nakshatra}', style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey))
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime dateBasic = DateTime.now();
                            int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                            int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                            int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                            int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                            int formattedMint = int.parse(DateFormat('mm').format(dateBasic));

                            global.showOnlyLoaderDialog(context);
                            await Get.find<KundliController>().getBasicPanchangDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: 21.1255, lon: 73.1122, tzone: 5);
                            global.hideLoader();
                            Get.to(() => PanchangScreen());
                          },
                          child: Container(
                            width: double.infinity,
                            color: Get.theme.primaryColor,
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('View More'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                    return bottomNavigationController.liveAstrologer.length == 0
                        ? const SizedBox()
                        : SizedBox(
                            height: 200,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.only(top: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Live Astrologers',
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 5),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    global.showOnlyLoaderDialog(context);
                                                    await bottomNavigationController.getLiveAstrologerList();
                                                    global.hideLoader();
                                                  },
                                                  child: Icon(
                                                    Icons.refresh,
                                                    size: 20,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              bool isLogin = await global.isLogin();
                                              if (isLogin) {
                                                Get.to(() => LiveAstrologerListScreen());
                                              }
                                            },
                                            child: Text(
                                              'View All',
                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GetBuilder<BottomNavigationController>(
                                      builder: (c) {
                                        return Expanded(
                                          child: ListView.builder(
                                            itemCount: bottomNavigationController.liveAstrologer.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.only(top: 10, left: 10),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  onTap: () async {
                                                    bottomController.anotherLiveAstrologers = bottomNavigationController.liveAstrologer.where((element) => element.astrologerId != bottomNavigationController.liveAstrologer[index].astrologerId).toList();
                                                    bottomController.update();
                                                    await liveController.getWaitList(bottomNavigationController.liveAstrologer[index].channelName);
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
                                                    Get.to(
                                                      () => LiveAstrologerScreen(
                                                        token: bottomNavigationController.liveAstrologer[index].token,
                                                        channel: bottomNavigationController.liveAstrologer[index].channelName,
                                                        astrologerName: bottomNavigationController.liveAstrologer[index].name,
                                                        astrologerProfile: bottomNavigationController.liveAstrologer[index].profileImage,
                                                        astrologerId: bottomNavigationController.liveAstrologer[index].astrologerId,
                                                        isFromHome: true,
                                                        charge: bottomNavigationController.liveAstrologer[index].charge,
                                                        isForLiveCallAcceptDecline: false,
                                                        isFromNotJoined: false,
                                                        isFollow: bottomNavigationController.liveAstrologer[index].isFollow!,
                                                        videoCallCharge: bottomNavigationController.liveAstrologer[index].videoCallRate,
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox(
                                                      child: Stack(alignment: Alignment.bottomCenter, children: [
                                                    bottomNavigationController.liveAstrologer[index].profileImage != ""
                                                        ? Container(
                                                            width: 95,
                                                            height: 200,
                                                            margin: EdgeInsets.only(right: 4),
                                                            decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(0.3),
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(
                                                                  color: Color.fromARGB(255, 214, 214, 214),
                                                                ),
                                                                image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: NetworkImage(
                                                                      '${global.imgBaseurl}${bottomNavigationController.liveAstrologer[index].profileImage}',
                                                                    ),
                                                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))),
                                                          )
                                                        : Container(
                                                            width: 95,
                                                            height: 200,
                                                            margin: EdgeInsets.only(right: 4),
                                                            decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(0.3),
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(
                                                                  color: Color.fromARGB(255, 214, 214, 214),
                                                                ),
                                                                image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: AssetImage(
                                                                      Images.deafultUser,
                                                                    ),
                                                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))),
                                                          ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                              decoration: BoxDecoration(
                                                            color: Get.theme.primaryColor,
                                                            borderRadius: BorderRadius.circular(5),
                                                          )),
                                                          Padding(
                                                            padding: const EdgeInsets.only(bottom: 20),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
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
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ])));
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                  }),
                  GetBuilder<HomeController>(builder: (homeController) {
                    return homeController.blogList.length == 0
                        ? SizedBox()
                        : SizedBox(
                            height: 250,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.only(top: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: GetBuilder<BlogController>(builder: (blog) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Astrology blog',
                                              style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                BlogController blogController = Get.find<BlogController>();
                                                global.showOnlyLoaderDialog(context);
                                                blogController.astrologyBlogs = [];
                                                blogController.astrologyBlogs.clear();
                                                blogController.isAllDataLoaded = false;
                                                blogController.update();
                                                await blogController.getAstrologyBlog("", false);
                                                global.hideLoader();
                                                Get.to(() => AstrologyBlogScreen());
                                              },
                                              child: Text(
                                                'View All',
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: homeController.blogList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              global.showOnlyLoaderDialog(context);
                                              await homeController.incrementBlogViewer(homeController.blogList[index].id);
                                              homeController.homeBlogVideo(homeController.blogList[index].blogImage);
                                              global.hideLoader();
                                              Get.to(() => AstrologyBlogDetailScreen(
                                                    image: "${homeController.blogList[index].blogImage}",
                                                    title: homeController.blogList[index].title,
                                                    description: homeController.blogList[index].description!,
                                                    extension: homeController.blogList[index].extension!,
                                                    controller: homeController.homeVideoPlayerController,
                                                  ));
                                            },
                                            child: Card(
                                              elevation: 2,
                                              margin: EdgeInsets.only(right: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        homeController.blogList[index].extension == 'mp4' || homeController.blogList[index].extension == 'gif'
                                                            ? Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl: '${global.imgBaseurl}${homeController.blogList[index].previewImage}',
                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                      height: 110,
                                                                      width: Get.width,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        image: DecorationImage(
                                                                          fit: BoxFit.fill,
                                                                          image: imageProvider,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                    errorWidget: (context, url, error) => Image.asset(
                                                                      Images.blog,
                                                                      height: Get.height * 0.15,
                                                                      width: Get.width,
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons.play_arrow,
                                                                    size: 40,
                                                                    color: Colors.white,
                                                                  ),
                                                                ],
                                                              )
                                                            : ClipRRect(
                                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                                                child: CachedNetworkImage(
                                                                  imageUrl: '${global.imgBaseurl}${homeController.blogList[index].blogImage}',
                                                                  imageBuilder: (context, imageProvider) => Container(
                                                                    height: 110,
                                                                    width: Get.width,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      image: DecorationImage(
                                                                        fit: BoxFit.fill,
                                                                        image: imageProvider,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                    Images.blog,
                                                                    height: Get.height * 0.15,
                                                                    width: Get.width,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                        Positioned(
                                                          right: 8,
                                                          child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                padding: EdgeInsets.zero,
                                                                backgroundColor: Colors.white.withOpacity(0.5),
                                                                elevation: 0,
                                                                minimumSize: const Size(50, 30), //height
                                                                maximumSize: const Size(60, 30), //width
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                                              ),
                                                              onPressed: () {},
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.visibility,
                                                                    size: 20,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 5.0),
                                                                    child: Text(
                                                                      "${homeController.blogList[index].viewer}",
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "${homeController.blogList[index].title}",
                                                            textAlign: TextAlign.start,
                                                            style: Get.theme.textTheme.subtitle1!.copyWith(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w400,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${homeController.blogList[index].author}',
                                                                textAlign: TextAlign.center,
                                                                style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.grey[350],
                                                                  letterSpacing: 0,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.blogList[index].createdAt))}",
                                                                textAlign: TextAlign.center,
                                                                style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.grey[350],
                                                                  letterSpacing: 0,
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
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                  }),
                  GetBuilder<HomeController>(builder: (homeController) {
                    return homeController.astrologyVideo.length == 0
                        ? SizedBox()
                        : SizedBox(
                            height: 250,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.only(top: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Watch Astrology Videos',
                                            style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => AstrologerVideoScreen());
                                            },
                                            child: Text(
                                              'View All',
                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: homeController.astrologyVideo.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              global.showOnlyLoaderDialog(context);
                                              await homeController.youtubPlay(homeController.astrologyVideo[index].youtubeLink);
                                              global.hideLoader();
                                              Get.to(() => BlogScreen(
                                                    link: homeController.astrologyVideo[index].youtubeLink,
                                                    title: 'Video',
                                                    controller: homeController.youtubePlayerController,
                                                    date: '${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}',
                                                    videoTitle: homeController.astrologyVideo[index].videoTitle,
                                                  ));
                                            },
                                            child: Card(
                                              elevation: 4,
                                              margin: EdgeInsets.only(right: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                width: 230,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(10),
                                                            topRight: Radius.circular(10),
                                                          ),
                                                          child: CachedNetworkImage(
                                                            imageUrl: '${global.imgBaseurl}${homeController.astrologyVideo[index].coverImage}',
                                                            imageBuilder: (context, imageProvider) => Container(
                                                              height: 110,
                                                              width: Get.width,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                image: DecorationImage(
                                                                  fit: BoxFit.fill,
                                                                  image: imageProvider,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                            errorWidget: (context, url, error) => Image.asset(
                                                              Images.blog,
                                                              height: Get.height * 0.15,
                                                              width: Get.width,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          left: 60,
                                                          child: Image.asset(
                                                            Images.youtube,
                                                            height: 120,
                                                            width: 120,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            homeController.astrologyVideo[index].videoTitle,
                                                            textAlign: TextAlign.start,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Get.theme.textTheme.subtitle1!.copyWith(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w400,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}",
                                                                textAlign: TextAlign.center,
                                                                style: Get.theme.textTheme.subtitle1!.copyWith(
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.grey[350],
                                                                  letterSpacing: 0,
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
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                  }),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            }),
          ),
        ),
        bottomSheet: ContactAstrologerCottomButton());
  }

  Widget customContainer(String img) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Get.theme.primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: CachedNetworkImage(
        imageUrl: img,
        imageBuilder: (context, imageProvider) => Image.network(
          img,
          height: 100,
          width: 100,
        ),
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.no_accounts, size: 20),
      ),
    );
  }

  Widget detailText(String title, String subtitle, String btnText, VoidCallback btnTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text(subtitle, style: Get.textTheme.bodyText2!.copyWith(fontSize: 12)),
        TextButton(
          onPressed: btnTap,
          child: Text(btnText),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        )
      ],
    );
  }

  Widget panchangTime(String title, Color borderColors, Color containerColor, IconData icon, String timeText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          textAlign: TextAlign.left,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: containerColor,
            border: Border.all(color: borderColors),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: borderColors,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(timeText)
            ],
          ),
        )
      ],
    );
  }
}
