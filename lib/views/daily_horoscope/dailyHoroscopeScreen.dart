// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/dailyHoroscopeController.dart';
import 'package:BharatiyAstro/controllers/history_controller.dart';
import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/daily_horoscope/dailyHoroScopeDetailScreen.dart';
import 'package:BharatiyAstro/views/liveAstrologerList.dart';
import 'package:BharatiyAstro/views/live_astrologer/live_astrologer_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/chatController.dart';
import '../../widget/contactAstrologerBottomButton.dart';
import '../../widget/timeWiseHoroscopeWidget.dart';

class DailyHoroscopeScreen extends StatelessWidget {
  DailyHoroscopeScreen({Key? key}) : super(key: key);
  final ReviewController reviewController = Get.find<ReviewController>();
  final DailyHoroscopeController controller = Get.find<DailyHoroscopeController>();
  SplashController splashController = Get.find<SplashController>();
  BottomNavigationController bottomController = Get.find<BottomNavigationController>();
  LiveController liveController = Get.find<LiveController>();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
            title: Text(
              'Daily Horoscope',
              style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () async{
             await FlutterShare.share( title:'${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}', text: "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to Astrology.You should also try and see your future  https://play.google.com/store/apps/details?id=com.bharatiyastro.userapp").then((value) {}).catchError((e) {
        print(e);
      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          Images.whatsapp,
                          height: 40,
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Share', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<DailyHoroscopeController>(builder: (dailyHoroscopeController) {
              return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                (global.hororscopeSignList.isNotEmpty)
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: global.hororscopeSignList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        global.showOnlyLoaderDialog(context);
                                        await dailyHoroscopeController.selectZodic(index);
                                        await dailyHoroscopeController.getHoroscopeList(horoscopeId: dailyHoroscopeController.signId);
                                        global.hideLoader();
                                      },
                                      child: Container(
                                        width: global.hororscopeSignList[index].isSelected ? 68.0 : 54.0,
                                        height: global.hororscopeSignList[index].isSelected ? 68.0 : 54.0,
                                        padding: EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(Radius.circular(7)),
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: '${global.imgBaseurl}${global.hororscopeSignList[index].image}',
                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => Icon(Icons.no_accounts, size: 20),
                                        ),
                                      ),
                                    ),
                                    Text(global.hororscopeSignList[index].name, textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 10))
                                  ],
                                ),
                              );
                            }),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              dailyHoroscopeController.updateDaily(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: dailyHoroscopeController.day == 1 ? Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                border: Border.all(color: dailyHoroscopeController.day == 1 ? Get.theme.primaryColor : Colors.grey),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                              ),
                              child: Text('Yesterday', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              dailyHoroscopeController.updateDaily(2);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: dailyHoroscopeController.day == 2 ? Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                border: Border.all(color: dailyHoroscopeController.day == 2 ? Get.theme.primaryColor : Colors.grey),
                              ),
                              child: Text('Today', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              dailyHoroscopeController.updateDaily(3);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: dailyHoroscopeController.day == 3 ? Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                border: Border.all(color: dailyHoroscopeController.day == 3 ? Get.theme.primaryColor : Colors.grey),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                              ),
                              child: Text('Tomorrow', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (dailyHoroscopeController.dailyList != null)
                            ? DailyHoroscopeContainer(
                                date: dailyHoroscopeController.day == 2
                                    ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].horoscopeDate != null
                                            ? DateFormat('dd-MM-yyyy').format(dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].horoscopeDate!)
                                            : DateFormat('dd-MM-yyyy').format(DateTime.now())
                                        : DateFormat('dd-MM-yyyy').format(DateTime.now())
                                    : dailyHoroscopeController.day == 1
                                        ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].horoscopeDate != null
                                                ? DateFormat('dd-MM-yyyy').format(dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].horoscopeDate!)
                                                : DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(Duration(days: 1)))
                                            : DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(Duration(days: 1)))
                                        : dailyHoroscopeController.day == 3
                                            ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].horoscopeDate != null
                                                    ? DateFormat('dd-MM-yyyy').format(dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].horoscopeDate!)
                                                    : DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: 1)))
                                                : DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: 1)))
                                            : "",
                                luckyNumber: dailyHoroscopeController.day == 2
                                    ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyNumber != null
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyNumber
                                            : ""
                                        : ""
                                    : dailyHoroscopeController.day == 1
                                        ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyNumber != null
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyNumber
                                                : ""
                                            : ""
                                        : dailyHoroscopeController.day == 3
                                            ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyNumber != null
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyNumber
                                                    : ""
                                                : ""
                                            : "",
                                luckyTime: dailyHoroscopeController.day == 2
                                    ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyTime != null
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyTime
                                            : ""
                                        : ""
                                    : dailyHoroscopeController.day == 1
                                        ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyTime != null
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyTime
                                                : ""
                                            : ""
                                        : dailyHoroscopeController.day == 3
                                            ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyTime != null
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyTime
                                                    : ""
                                                : ""
                                            : "",
                                moodOfDay: dailyHoroscopeController.day == 2
                                    ? dailyHoroscopeController.dailyList != null
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].moodday ?? ""
                                            : ""
                                        : dailyHoroscopeController.day == 1
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].moodday ?? ""
                                                : ""
                                            : dailyHoroscopeController.day == 3
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].moodday ?? ""
                                                    : ""
                                                : ""
                                    : dailyHoroscopeController.day == 1
                                        ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].moodday ?? ""
                                            : ""
                                        : dailyHoroscopeController.day == 3
                                            ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].moodday ?? ""
                                                : ""
                                            : "",
                                colorCode: dailyHoroscopeController.day == 2
                                    ? dailyHoroscopeController.dailyList != null
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                            ? (dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor != null && dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor != "")
                                                ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor!.split("#")[1]
                                                : ""
                                            : ""
                                        : null
                                    : dailyHoroscopeController.day == 1
                                        ? dailyHoroscopeController.dailyList != null
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                ? (dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyColor != null && dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyColor != "")
                                                    ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyColor!.split("#")[1]
                                                    : ""
                                                : ""
                                            : null
                                        : dailyHoroscopeController.day == 3
                                            ? dailyHoroscopeController.dailyList != null
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                    ? (dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyColor != null && dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyColor != "")
                                                        ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyColor!.split("#")[1]
                                                        : ""
                                                    : ""
                                                : null
                                            : null,
                              )
                            : SizedBox(),
                        dailyHoroscopeController.dailyList != null
                            ? const SizedBox()
                            : dailyHoroscopeController.dailyList!.todayHoroscope!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Daily Horoscope', style: Get.textTheme.subtitle1),
                                  )
                                : SizedBox(),
                        dailyHoroscopeController.day == 1
                            ? dailyHoroscopeController.dailyList!.yeasterDayHoroscope!.isNotEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      dailyHoroscopeController.dailyList!.yeasterDayHoroscope!.isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Daily Horoscope', style: Get.textTheme.subtitle1),
                                            )
                                          : const SizedBox(),
                                      ListView.builder(
                                          itemCount: dailyHoroscopeController.dailyList!.yeasterDayHoroscope!.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(8),
                                                margin: EdgeInsets.only(bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: dailyHoroscopeController.containerColor[index],
                                                  border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                                dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Career"
                                                                    ? '💼 '
                                                                    : dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Love"
                                                                        ? "❤️ "
                                                                        : dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Money"
                                                                            ? "💵 "
                                                                            : dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Health"
                                                                                ? "🩺 "
                                                                                : "✈️ ",
                                                                style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                            Text('${dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                          ],
                                                        ),
                                                        Text('${dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].percent}%'),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    FutureBuilder(
                                                      future: global.showHtml(
                                                        html: dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].description ?? '',
                                                        style: {
                                                          "html": Style(color: Colors.grey),
                                                        },
                                                      ),
                                                      builder: (context, snapshot) {
                                                        return snapshot.data ?? const SizedBox();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  )
                                : dailyHoroscopeController.day == 2
                                    ? dailyHoroscopeController.dailyList!.todayHoroscope!.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: dailyHoroscopeController.dailyList!.todayHoroscope!.length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(8),
                                                  margin: EdgeInsets.only(bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: dailyHoroscopeController.containerColor[index],
                                                    border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                          Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].percent}%'),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Html(
                                                        data: dailyHoroscopeController.dailyList!.todayHoroscope![index].description,
                                                        style: {
                                                          "html": Style(color: Colors.grey),
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })
                                        : dailyHoroscopeController.day == 3
                                            ? dailyHoroscopeController.dailyList!.tomorrowHoroscope!.isNotEmpty
                                                ? ListView.builder(
                                                    itemCount: dailyHoroscopeController.dailyList!.tomorrowHoroscope!.length,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          width: double.infinity,
                                                          padding: EdgeInsets.all(8),
                                                          margin: EdgeInsets.only(bottom: 10),
                                                          decoration: BoxDecoration(
                                                            color: dailyHoroscopeController.containerColor[index],
                                                            border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)), Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].percent}%')],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].description}', style: Get.textTheme.subtitle1!.copyWith(color: Colors.grey, fontSize: 14))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                : SizedBox()
                                            : SizedBox()
                                    : SizedBox()
                            : dailyHoroscopeController.day == 2
                                ? dailyHoroscopeController.dailyList!.todayHoroscope!.isNotEmpty
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dailyHoroscopeController.dailyList!.todayHoroscope!.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('Daily Horoscope', style: Get.textTheme.subtitle1),
                                                )
                                              : const SizedBox(),
                                          ListView.builder(
                                              itemCount: dailyHoroscopeController.dailyList!.todayHoroscope!.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(8),
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: dailyHoroscopeController.containerColor[index],
                                                      border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Career"
                                                                        ? '💼 '
                                                                        : dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Love"
                                                                            ? "❤️ "
                                                                            : dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Money"
                                                                                ? "💵 "
                                                                                : dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Health"
                                                                                    ? "🩺 "
                                                                                    : "✈️ ",
                                                                    style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                                Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                              ],
                                                            ),
                                                            Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].percent}%'),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        FutureBuilder(
                                                          future: global.showHtml(
                                                            html: dailyHoroscopeController.dailyList!.todayHoroscope![index].description ?? '',
                                                            style: {
                                                              "html": Style(color: Colors.grey),
                                                            },
                                                          ),
                                                          builder: (context, snapshot) {
                                                            return snapshot.data ?? const SizedBox();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      )
                                    : const SizedBox()
                                : dailyHoroscopeController.day == 3
                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscope!.isNotEmpty
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              dailyHoroscopeController.dailyList!.tomorrowHoroscope!.isNotEmpty
                                                  ? Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text('Daily Horoscope', style: Get.textTheme.subtitle1),
                                                    )
                                                  : const SizedBox(),
                                              ListView.builder(
                                                  itemCount: dailyHoroscopeController.dailyList!.tomorrowHoroscope!.length,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(8),
                                                        margin: EdgeInsets.only(bottom: 10),
                                                        decoration: BoxDecoration(
                                                          color: dailyHoroscopeController.containerColor[index],
                                                          border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Career"
                                                                            ? '💼 '
                                                                            : dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Love"
                                                                                ? "❤️ "
                                                                                : dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Money"
                                                                                    ? "💵 "
                                                                                    : dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Health"
                                                                                        ? "🩺 "
                                                                                        : "✈️ ",
                                                                        style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                                    Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                                  ],
                                                                ),
                                                                Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].percent}%'),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            FutureBuilder(
                                                              future: global.showHtml(
                                                                html: dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].description ?? '',
                                                                style: {
                                                                  "html": Style(color: Colors.grey),
                                                                },
                                                              ),
                                                              builder: (context, snapshot) {
                                                                return snapshot.data ?? const SizedBox();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          )
                                        : SizedBox()
                                    : SizedBox()
                      ],
                    ),
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
                dailyHoroscopeController.dailyList!.tomorrowInsight!.isNotEmpty || dailyHoroscopeController.dailyList!.todayInsight!.isNotEmpty || dailyHoroscopeController.dailyList!.yeasterdayInsight!.isNotEmpty ? Text('Daily Horosope Insights', style: Get.textTheme.subtitle1) : SizedBox(),
                dailyHoroscopeController.day == 1
                    ? dailyHoroscopeController.dailyList!.yeasterdayInsight!.isNotEmpty
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dailyHoroscopeController.dailyList!.yeasterdayInsight!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                //margin: EdgeInsets.all(7),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      dailyHoroscopeController.dailyList!.yeasterdayInsight![index].coverImage != ""
                                          ? Container(
                                              height: 150,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(8),
                                              child: Image.network(
                                                '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].coverImage}',
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: RotatedBox(
                                          quarterTurns: 45,
                                          child: ClipPath(
                                            clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                            child: Container(
                                              width: 20,
                                              height: 135,
                                              decoration: BoxDecoration(
                                                  color: Get.theme.primaryColor,
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(10),
                                                  )),
                                              alignment: Alignment.topCenter,
                                              padding: EdgeInsets.only(top: 5),
                                              child: RotatedBox(
                                                quarterTurns: -45,
                                                child: Text(
                                                  "${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].title}",
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "\"${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].title} \"",
                                        style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FutureBuilder(
                                        future: global.showHtml(
                                          html: dailyHoroscopeController.dailyList!.yeasterdayInsight![index].description ?? '',
                                          style: {
                                            "html": Style(color: Colors.grey),
                                          },
                                        ),
                                        builder: (context, snapshot) {
                                          return snapshot.data ?? const SizedBox();
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          String link = dailyHoroscopeController.dailyList!.yeasterdayInsight![index].link.toString();
                                          print(link);
                                          if (link == "") {
                                          } else {
                                            if (await canLaunchUrl(Uri.parse(link))) {
                                              await launchUrl(Uri.parse(link));
                                            }
                                          }
                                        },
                                        child: Text('Watch ${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].title}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                          backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                        : dailyHoroscopeController.day == 2
                            // ignore: unnecessary_null_comparison
                            ? dailyHoroscopeController.dailyList!.todayInsight!.isNotEmpty
                                ? Card(
                                    //margin: EdgeInsets.all(7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 150,
                                            width: double.infinity,
                                            padding: EdgeInsets.all(8),
                                            child: Image.network(
                                              '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.todayInsight![1].coverImage}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: RotatedBox(
                                              quarterTurns: 45,
                                              child: ClipPath(
                                                clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                child: Container(
                                                  width: 20,
                                                  height: 135,
                                                  decoration: BoxDecoration(
                                                      color: Get.theme.primaryColor,
                                                      borderRadius: BorderRadius.only(
                                                        bottomRight: Radius.circular(10),
                                                      )),
                                                  alignment: Alignment.topCenter,
                                                  padding: EdgeInsets.only(top: 5),
                                                  child: RotatedBox(
                                                    quarterTurns: -45,
                                                    child: Text(
                                                      ' ${dailyHoroscopeController.dailyList!.todayInsight![2].name}',
                                                      textAlign: TextAlign.center,
                                                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "\"${dailyHoroscopeController.dailyList!.todayInsight![1].title} \"",
                                            style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder(
                                            future: global.showHtml(
                                              html: dailyHoroscopeController.dailyList!.todayInsight![1].description ?? '',
                                            ),
                                            builder: (context, snapshot) {
                                              return snapshot.data ?? const SizedBox();
                                            },
                                          ),
                                          TextButton(
                                            onPressed: () async {},
                                            child: Text('Watch Movie', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : dailyHoroscopeController.day == 1
                                    // ignore: unnecessary_null_comparison
                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscope![2] != null
                                        ? Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 150,
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(8),
                                                    child: Image.network(
                                                      '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.tomorrowInsight![2].coverImage}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: RotatedBox(
                                                      quarterTurns: 45,
                                                      child: ClipPath(
                                                        clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                        child: Container(
                                                          width: 20,
                                                          height: 135,
                                                          decoration: BoxDecoration(
                                                              color: Get.theme.primaryColor,
                                                              borderRadius: BorderRadius.only(
                                                                bottomRight: Radius.circular(10),
                                                              )),
                                                          alignment: Alignment.topCenter,
                                                          padding: EdgeInsets.only(top: 5),
                                                          child: RotatedBox(
                                                            quarterTurns: -45,
                                                            child: Text(
                                                              '${dailyHoroscopeController.dailyList!.tomorrowInsight![2].name}',
                                                              textAlign: TextAlign.center,
                                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "\"${dailyHoroscopeController.dailyList!.tomorrowInsight![2].title} \"",
                                                    style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Html(
                                                    data: '${dailyHoroscopeController.dailyList!.tomorrowInsight![2].description}',
                                                  ),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: Text('Watch Movie', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                                      backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                      shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                    : SizedBox()
                            : SizedBox()
                    : dailyHoroscopeController.day == 2
                        // ignore: unnecessary_null_comparison
                        ? dailyHoroscopeController.dailyList!.todayInsight!.isNotEmpty
                            ? ListView.builder(
                                itemCount: dailyHoroscopeController.dailyList!.todayInsight!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    //margin: EdgeInsets.all(7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 150,
                                            width: double.infinity,
                                            padding: EdgeInsets.all(8),
                                            child: Image.network(
                                              '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.todayInsight![index].coverImage}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: RotatedBox(
                                              quarterTurns: 45,
                                              child: ClipPath(
                                                clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                child: Container(
                                                  width: 20,
                                                  height: 135,
                                                  decoration: BoxDecoration(
                                                      color: Get.theme.primaryColor,
                                                      borderRadius: BorderRadius.only(
                                                        bottomRight: Radius.circular(10),
                                                      )),
                                                  alignment: Alignment.topCenter,
                                                  padding: EdgeInsets.only(top: 5),
                                                  child: RotatedBox(
                                                    quarterTurns: -45,
                                                    child: Text(
                                                      '${dailyHoroscopeController.dailyList!.todayInsight![index].name}',
                                                      textAlign: TextAlign.center,
                                                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "\"${dailyHoroscopeController.dailyList!.todayInsight![index].title} \"",
                                            style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder(
                                            future: global.showHtml(
                                              html: dailyHoroscopeController.dailyList!.todayInsight![index].description ?? '',
                                            ),
                                            builder: (context, snapshot) {
                                              return snapshot.data ?? const SizedBox();
                                            },
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String link = dailyHoroscopeController.dailyList!.todayInsight![index].link.toString();
                                              print(link);
                                              if (link == "") {
                                              } else {
                                                if (await canLaunchUrl(Uri.parse(link))) {
                                                  await launchUrl(Uri.parse(link));
                                                }
                                              }
                                            },
                                            child: Text('Watch ${dailyHoroscopeController.dailyList!.todayInsight![index].title}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            : const SizedBox()
                        : dailyHoroscopeController.day == 3
                            // ignore: unnecessary_null_comparison
                            ? dailyHoroscopeController.dailyList!.tomorrowInsight!.isNotEmpty
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: dailyHoroscopeController.dailyList!.tomorrowInsight!.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 150,
                                                width: double.infinity,
                                                padding: EdgeInsets.all(8),
                                                child: Image.network(
                                                  '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.tomorrowInsight![index].coverImage}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: RotatedBox(
                                                  quarterTurns: 45,
                                                  child: ClipPath(
                                                    clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                    child: Container(
                                                      width: 20,
                                                      height: 135,
                                                      decoration: BoxDecoration(
                                                          color: Get.theme.primaryColor,
                                                          borderRadius: BorderRadius.only(
                                                            bottomRight: Radius.circular(10),
                                                          )),
                                                      alignment: Alignment.topCenter,
                                                      padding: EdgeInsets.only(top: 5),
                                                      child: RotatedBox(
                                                        quarterTurns: -45,
                                                        child: Text(
                                                          '${dailyHoroscopeController.dailyList!.tomorrowInsight![index].name}',
                                                          textAlign: TextAlign.center,
                                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "\"${dailyHoroscopeController.dailyList!.tomorrowInsight![index].title} \"",
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              FutureBuilder(
                                                future: global.showHtml(
                                                  html: dailyHoroscopeController.dailyList!.tomorrowInsight![index].description ?? '',
                                                ),
                                                builder: (context, snapshot) {
                                                  return snapshot.data ?? const SizedBox();
                                                },
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  String link = dailyHoroscopeController.dailyList!.tomorrowInsight![index].link.toString();
                                                  print(link);
                                                  if (link == "") {
                                                  } else {
                                                    if (await canLaunchUrl(Uri.parse(link))) {
                                                      await launchUrl(Uri.parse(link));
                                                    }
                                                  }
                                                },
                                                child: Text('Watch ${dailyHoroscopeController.dailyList!.tomorrowInsight![index].title}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                                  backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                  shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : SizedBox()
                            : SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          dailyHoroscopeController.updateTimely(month: false, week: true, year: false);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                          decoration: BoxDecoration(
                            color: dailyHoroscopeController.isWeek ? Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                            border: Border.all(color: dailyHoroscopeController.isWeek ? Get.theme.primaryColor : Colors.grey),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          ),
                          child: Text('''Weekly \n Horoscope''', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          dailyHoroscopeController.updateTimely(month: true, week: false, year: false);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                          decoration: BoxDecoration(
                            color: dailyHoroscopeController.isMonth ? Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                            border: Border.all(color: dailyHoroscopeController.isMonth ? Get.theme.primaryColor : Colors.grey),
                          ),
                          child: Text('''Monthly \n Horoscope''', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          dailyHoroscopeController.updateTimely(month: false, week: false, year: true);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                          decoration: BoxDecoration(
                            color: dailyHoroscopeController.isYear ? Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                            border: Border.all(color: dailyHoroscopeController.isYear ? Get.theme.primaryColor : Colors.grey),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                          ),
                          child: Text('''Yearly \n Horoscope''', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: dailyHoroscopeController.isWeek
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text(
                                'Weekly Horoscope',
                                style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                      height: 10,
                                      indent: 200,
                                      endIndent: 10,
                                    ),
                                  ),
                                  Text('${DateFormat('dd MMM yyyy').format(DateTime.now())}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.grey)),
                                  const Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                      height: 10,
                                      indent: 200,
                                      endIndent: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: dailyHoroscopeController.dailyList!.weeklyHoroScope!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${dailyHoroscopeController.dailyList!.weeklyHoroScope![index].title}',
                                          style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FutureBuilder(
                                          future: global.showHtml(
                                            html: dailyHoroscopeController.dailyList!.weeklyHoroScope![index].description ?? '',
                                          ),
                                          builder: (context, snapshot) {
                                            return snapshot.data ?? const SizedBox();
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        )
                      : dailyHoroscopeController.isMonth
                          ? dailyHoroscopeController.dailyList == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('Monthly horoscope', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: Colors.black,
                                              height: 10,
                                              indent: 200,
                                              endIndent: 10,
                                            ),
                                          ),
                                          Text(DateFormat('MMMM yyy').format(DateTime.now()), style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.grey)),
                                          const Expanded(
                                            child: Divider(
                                              color: Colors.black,
                                              height: 10,
                                              indent: 200,
                                              endIndent: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: dailyHoroscopeController.dailyList!.monthlyHoroScope!.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(dailyHoroscopeController.dailyList!.monthlyHoroScope![index].title!, style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                FutureBuilder(
                                                  future: global.showHtml(
                                                    html: dailyHoroscopeController.dailyList!.monthlyHoroScope![index].description ?? '',
                                                  ),
                                                  builder: (context, snapshot) {
                                                    return snapshot.data ?? const SizedBox();
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            );
                                          })
                                    ],
                                  ),
                                )
                          : dailyHoroscopeController.isYear
                              ? dailyHoroscopeController.dailyList != null
                                  ? TimeWiseHoroscopeWidget(
                                      dailyHoroscopeModel: dailyHoroscopeController.dailyList!,
                                    )
                                  : const SizedBox()
                              : SizedBox(),
                ),
                SizedBox(
                  height: 10,
                ),
                global.user.contactNo == null && global.currentUserId == null
                    ? const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Color.fromARGB(255, 247, 243, 214),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            dailyHoroscopeController.feedbackGroupValue = null;
                            dailyHoroscopeController.update();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: SimpleDialog(
                                      insetPadding: const EdgeInsets.all(8),
                                      titlePadding: const EdgeInsets.all(0),
                                      title: null,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                icon: Icon(Icons.close))
                                          ],
                                        ),
                                        GetBuilder<DailyHoroscopeController>(builder: (d) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('How was your overall experience of Daily horoscope? ', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                height: 25,
                                                child: RadioListTile(
                                                  dense: true,
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text("Great"),
                                                  value: "Great",
                                                  activeColor: Get.theme.primaryColor,
                                                  groupValue: dailyHoroscopeController.feedbackGroupValue,
                                                  onChanged: (value) {
                                                    dailyHoroscopeController.feedbackGroupValue = value;
                                                    dailyHoroscopeController.update();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                                child: RadioListTile(
                                                  dense: true,
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text("Average"),
                                                  value: "Average",
                                                  activeColor: Get.theme.primaryColor,
                                                  groupValue: dailyHoroscopeController.feedbackGroupValue,
                                                  onChanged: (value) {
                                                    dailyHoroscopeController.feedbackGroupValue = value;
                                                    dailyHoroscopeController.update();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                                child: RadioListTile(
                                                  dense: true,
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                                  title: Text("Needs improvement"),
                                                  value: "Needs improvement",
                                                  activeColor: Get.theme.primaryColor,
                                                  groupValue: dailyHoroscopeController.feedbackGroupValue,
                                                  onChanged: (value) {
                                                    dailyHoroscopeController.feedbackGroupValue = value;
                                                    dailyHoroscopeController.update();
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        }),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                        GetBuilder<DailyHoroscopeController>(builder: (d) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                dailyHoroscopeController.feedbackGroupValue == null ? const SizedBox() : Text('Share your feedback', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                                                dailyHoroscopeController.feedbackGroupValue == null
                                                    ? const SizedBox()
                                                    : FutureBuilder(
                                                        future: global.translatedText('Type here'),
                                                        builder: (context, snapshot) {
                                                          return TextField(
                                                            controller: dailyHoroscopeController.feedbackController,
                                                            focusNode: dailyHoroscopeController.fFeedback,
                                                            keyboardType: TextInputType.multiline,
                                                            minLines: 3,
                                                            maxLines: 7,
                                                            decoration: InputDecoration(
                                                              isDense: true,
                                                              hintText: snapshot.data ?? 'Type here',
                                                              hintStyle: TextStyle(fontSize: 10),
                                                              border: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey),
                                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey),
                                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey),
                                                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                                      backgroundColor: MaterialStateProperty.all(dailyHoroscopeController.feedbackGroupValue == null ? Colors.grey : Get.theme.primaryColor),
                                                      shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      dailyHoroscopeController.fFeedback.unfocus();
                                                      if (dailyHoroscopeController.feedbackGroupValue != null) {
                                                        global.showOnlyLoaderDialog(context);
                                                        dailyHoroscopeController.addFeedBack();
                                                        global.hideLoader();
                                                        Get.back(); //back from dailog
                                                      }
                                                    },
                                                    child: Text(
                                                      'Submit',
                                                      textAlign: TextAlign.center,
                                                      style: Get.theme.primaryTextTheme.subtitle1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Share Feedback', style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 5,
                              ),
                              CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: 60,
                )
              ]);
            }),
          ),
        ),
        bottomSheet: ContactAstrologerCottomButton());
  }
}
