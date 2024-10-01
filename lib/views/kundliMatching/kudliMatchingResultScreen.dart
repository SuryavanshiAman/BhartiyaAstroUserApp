// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/kundliMatchingController.dart';
import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:BharatiyAstro/views/liveAstrologerList.dart';
import 'package:BharatiyAstro/views/live_astrologer/live_astrologer_screen.dart';
import 'package:BharatiyAstro/widget/contactAstrologerBottomButton.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_translator/google_translator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:percent_indicator/circular_percent_indicator.dart';

class KudliMatchingResultScreen extends StatelessWidget {
  KudliMatchingResultScreen({Key? key}) : super(key: key);
  final KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  LiveController liveController = Get.find<LiveController>();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: ContactAstrologerCottomButton(),
        body: GetBuilder<KundliMatchingController>(builder: (matchingController) {
          return SingleChildScrollView(
            child: kundliMatchingController.kundliMatchDetailList != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.4,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(Images.sky),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    "Compatibility Score",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints == null
                                    ? SizedBox()
                                    : Container(
                                        height: 180,
                                        width: 230,
                                        child: SfRadialGauge(
                                          axes: <RadialAxis>[
                                            RadialAxis(
                                              showLabels: false,
                                              showAxisLine: false,
                                              showTicks: false,
                                              minimum: 0,
                                              maximum: 36,
                                              ranges: <GaugeRange>[
                                                GaugeRange(
                                                  startValue: 0,
                                                  endValue: 12,
                                                  color: Color(0xFFFE2A25),
                                                  label: '',
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                  labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                                                  startWidth: 0.50,
                                                  endWidth: 0.50,
                                                ),
                                                GaugeRange(
                                                  startValue: 12,
                                                  endValue: 24,
                                                  color: Color(0xFFFFBA00),
                                                  label: '',
                                                  startWidth: 0.50,
                                                  endWidth: 0.50,
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                ),
                                                GaugeRange(
                                                  startValue: 24,
                                                  endValue: 36,
                                                  color: Color(0xFF00AB47),
                                                  label: '',
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                  startWidth: 0.50,
                                                  endWidth: 0.50,
                                                ),
                                              ],
                                              pointers: <GaugePointer>[
                                                NeedlePointer(
                                                  value: kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints != null ? double.parse(kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints.toString()) : 0.0,
                                                  needleStartWidth: 0,
                                                  needleEndWidth: 5,
                                                  needleColor: Color(0xFFDADADA),
                                                  enableAnimation: true,
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            title: const Text(
                              "Kundli Matching",
                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(3),
                              width: 100,
                              decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        insetPadding: EdgeInsets.zero,
                                        child: Screenshot(
                                          controller: screenshotController,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(Images.sky),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        Images.splash_image,
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        global.getSystemFlagValueForLogin(global.systemFlagNameList.appName),
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  kundliMatchingController.isFemaleManglik == null
                                                      ? const SizedBox()
                                                      : Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    height: 70,
                                                                    width: 100,
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      border: Border.all(
                                                                        color: Colors.green,
                                                                        width: 3, /*strokeAlign: StrokeAlign.outside*/
                                                                      ),
                                                                      color: Get.theme.primaryColor,
                                                                      image: const DecorationImage(
                                                                        image: AssetImage(
                                                                          "assets/images/no_customer_image.png",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                    child: Text(
                                                                      '${kundliMatchingController.cBoysName.text}',
                                                                      style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(color: Colors.white),
                                                                    ),
                                                                  ),
                                                                  kundliMatchingController.isFemaleManglik == null
                                                                      ? const SizedBox()
                                                                      : Padding(
                                                                          padding: EdgeInsets.only(top: 6.0),
                                                                          child: Text(
                                                                            kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                                                            style: TextStyle(
                                                                              color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                              Image.asset(
                                                                "assets/images/couple_ring_image.png",
                                                                scale: 8,
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    height: 60,
                                                                    width: 110,
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      border: Border.all(
                                                                        color: Colors.green,
                                                                        width: 3, /* strokeAlign: StrokeAlign.outside*/
                                                                      ),
                                                                      color: Get.theme.primaryColor,
                                                                      image: const DecorationImage(
                                                                        image: AssetImage(
                                                                          "assets/images/no_customer_image.png",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                    child: Text(
                                                                      '${kundliMatchingController.cGirlName.text}',
                                                                      style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(color: Colors.white),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 9.0),
                                                                    child: Text(
                                                                      kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                                                      style: TextStyle(
                                                                        color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 10),
                                                    child: Text(
                                                      "Compatibility Score",
                                                      style: TextStyle(
                                                        color: Get.theme.primaryColor,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints == null
                                                      ? SizedBox()
                                                      : Container(
                                                          height: 180,
                                                          width: 230,
                                                          child: SfRadialGauge(
                                                            axes: <RadialAxis>[
                                                              RadialAxis(
                                                                showLabels: false,
                                                                showAxisLine: false,
                                                                showTicks: false,
                                                                minimum: 0,
                                                                maximum: 36,
                                                                ranges: <GaugeRange>[
                                                                  GaugeRange(
                                                                    startValue: 0,
                                                                    endValue: 12,
                                                                    color: Color(0xFFFE2A25),
                                                                    label: '',
                                                                    sizeUnit: GaugeSizeUnit.factor,
                                                                    labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                                                                    startWidth: 0.50,
                                                                    endWidth: 0.50,
                                                                  ),
                                                                  GaugeRange(
                                                                    startValue: 12,
                                                                    endValue: 24,
                                                                    color: Color(0xFFFFBA00),
                                                                    label: '',
                                                                    startWidth: 0.50,
                                                                    endWidth: 0.50,
                                                                    sizeUnit: GaugeSizeUnit.factor,
                                                                  ),
                                                                  GaugeRange(
                                                                    startValue: 24,
                                                                    endValue: 36,
                                                                    color: Color(0xFF00AB47),
                                                                    label: '',
                                                                    sizeUnit: GaugeSizeUnit.factor,
                                                                    startWidth: 0.50,
                                                                    endWidth: 0.50,
                                                                  ),
                                                                ],
                                                                pointers: <GaugePointer>[
                                                                  NeedlePointer(
                                                                    value: kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints != null ? double.parse(kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints.toString()) : 0.0,
                                                                    needleStartWidth: 0,
                                                                    needleEndWidth: 5,
                                                                    needleColor: Color(0xFFDADADA),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                  kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints == null
                                                      ? const SizedBox()
                                                      : Container(
                                                          height: 50,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(color: Colors.greenAccent),
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                          child: Center(
                                                              child: RichText(
                                                            text: TextSpan(
                                                              text: '${kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints!}/',
                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text: '${kundliMatchingController.kundliMatchDetailList!.totalList!.totalPoints!}',
                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                        ),
                                                  kundliMatchingController.kundliMatchDetailList!.conclusionList!.report == null
                                                      ? const SizedBox()
                                                      : Container(
                                                          padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
                                                          margin: const EdgeInsets.symmetric(vertical: 20),
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            border: Border.all(color: Get.theme.primaryColor),
                                                            gradient: LinearGradient(
                                                              begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                              colors: [
                                                                Get.theme.primaryColor,
                                                                Colors.white,
                                                              ],
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "BharatiyAstro Conclusion",
                                                                style: Theme.of(context).primaryTextTheme.subtitle1,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                                                child: Text(
                                                                  'The overall points of this couple ${kundliMatchingController.kundliMatchDetailList!.conclusionList!.report!}',
                                                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
                                  String appShareLink;
                                  // ignore: unused_local_variable
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
                                  Get.back(); //back from dialog
                                  final temp1 = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
                                  screenshotController.capture().then((image) async {
                                    if (image != null) {
                                      try {
                                        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
                                        final imagePath = await File('${temp1!.path}/$fileName.png').create();
                                        // ignore: unnecessary_null_comparison
                                        if (imagePath != null) {
                                          final temp;
                                          if (Platform.isIOS) {
                                            temp = await getApplicationDocumentsDirectory();
                                          } else {
                                            temp = await getExternalStorageDirectory();
                                          }
                                          final path = '${temp!.path}/$fileName.jpg';
                                          File(path).writeAsBytesSync(image);

                                          await FlutterShare.shareFile(filePath: path, title: 'BharatiyAstro', text: "Check out the ${global.getSystemFlagValue(global.systemFlagNameList.appName)} marriage compatibility report for ${kundliMatchingController.cBoysName.text} and ${kundliMatchingController.cGirlName.text}. Get your free Matchnaking report here: $appShareLink").then((value) {}).catchError((e) {
                                            print(e);
                                          });
                                        }
                                      } catch (e) {
                                        print('Exception in match sharing $e');
                                      }
                                    }
                                  }).catchError((onError) {
                                    print('Error --->> $onError');
                                  });
                                },
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          "Share",
                                          style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(fontSize: 12),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 6.0),
                                        child: FittedBox(
                                          child: Icon(
                                            Icons.share,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints == null
                              ? const SizedBox()
                              : Positioned(
                                  bottom: -25,
                                  left: MediaQuery.of(context).size.width / 2.8,
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.greenAccent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                        child: RichText(
                                      text: TextSpan(
                                        text: '${kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints!}/',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${kundliMatchingController.kundliMatchDetailList!.totalList!.totalPoints!}',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                ),
                        ],
                      ),
//----------------------Details-----------------------

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 40.0, bottom: 20),
                              child: Center(
                                child: Text("Details", style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
                              ),
                            ),
//------------------Card-------------------------------

                            kundliMatchingController.kundliMatchDetailList!.varnaList!.received_points == null
                                ? const SizedBox()
                                : Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(color: Color(0xfffff6f1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Compatibility (Varna)",
                                                  style: Theme.of(context).primaryTextTheme.subtitle1,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                  child: Text(
                                                    "Varna refers to the mental compatility of the two persons involed. it holds nominal effect in the matters of marriage",
                                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CircularPercentIndicator(
                                            radius: 35.0,
                                            lineWidth: 5.0,
                                            percent: kundliMatchingController.kundliMatchDetailList!.varnaList!.received_points! / 1,
                                            center: new Text(
                                              "${kundliMatchingController.kundliMatchDetailList!.varnaList!.received_points!.toStringAsFixed(0)}/1",
                                              style: TextStyle(color: Color(0xfffca47c), fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            progressColor: Color(0xfffca47c),
                                          )
                                        ],
                                      ),
                                    )),
                            kundliMatchingController.kundliMatchDetailList!.bhakutList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: Color(0xffeffaf4), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Love (Bhakut)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: Text(
                                                        "Bhaukt is related to the couple's joys and sorrows together and assesses the wealth and health after their wedding.",
                                                        style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.bhakutList!.received_points! / 7,
                                                center: new Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.bhakutList!.received_points!.toStringAsFixed(0)}/7",
                                                  style: TextStyle(color: Color(0xff70ce99), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: Color(0xff70ce99),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.maitriList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: Color(0xfffcf2fd), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Mental Compatibility (Maitri)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: Text(
                                                        "Maitri assesses the mental compatibility and mutual love between the partners to be married.",
                                                        style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.maitriList!.received_points! / 5,
                                                center: new Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.maitriList!.received_points!.toStringAsFixed(0)}/5",
                                                  style: TextStyle(color: Color(0xffba6ad9), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: Color(0xffba6ad9),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.nadiList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: Color(0xffeef7fe), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Health (Nadi)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: Text(
                                                        "Nadi is related to the health compatibility of the couple. Matters of childbirth and progeny are also determinded with this Guna.",
                                                        style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.nadiList!.received_points! / 8,
                                                center: new Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.nadiList!.received_points!.toStringAsFixed(0)}/8",
                                                  style: TextStyle(color: Color(0xff58a4f2), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: Color(0xff58a4f2),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.vashyaList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: Color(0xfffff2f9), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Dominance (Vashya)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: Text(
                                                        "Vashya indicates the bride and the groom's tendency to dominate or infulence each other in marriage.",
                                                        style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.vashyaList!.received_points! / 2,
                                                center: new Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.vashyaList!.received_points!.toStringAsFixed(0)}/2",
                                                  style: TextStyle(color: Color(0xffff84bb), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: Color(0xffff84bb),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.ganList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: Color(0xfffff6f1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Temperament (Gana)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: Text(
                                                        "Gana is the indicator of the behaviour, character and temperament of the potential bride and groom towards each other.",
                                                        style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.ganList!.received_points! / 6,
                                                center: new Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.ganList!.received_points!.toStringAsFixed(0)}/6",
                                                  style: TextStyle(color: Color(0xffffa37a), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: Color(0xffffa37a),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.taraList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: Color(0xffeffaf4), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Destiny (Tara)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: Text(
                                                        "Tara is the indicator of the birth star compatibility of the bride and the groom. It also indicates the fortune of the couple.",
                                                        style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.taraList!.received_points! / 3,
                                                center: new Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.taraList!.received_points!.toStringAsFixed(0)}/3",
                                                  style: TextStyle(color: Color(0xff70ce99), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: Color(0xff70ce99),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.yoniList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: Color(0xfffcf2fd), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Physical compatibility (Yoni)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: Text(
                                                        "Yoni is the indicator of the sexual or physical compatibility between the bride and the groom in question.",
                                                        style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.yoniList!.received_points! / 4,
                                                center: new Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.yoniList!.received_points!.toStringAsFixed(0)}/4",
                                                  style: TextStyle(color: Color(0xffbb6bda), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: Color(0xffbb6bda),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
//----------------------------------Manglik Report-------------------------------------
                            kundliMatchingController.isFemaleManglik == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(
                                      "Manglik Report",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ),
                                  ),
                            kundliMatchingController.isFemaleManglik == null
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 3, /*strokeAlign: StrokeAlign.outside*/
                                              ),
                                              color: Get.theme.primaryColor,
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/no_customer_image.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              '${kundliMatchingController.cBoysName.text}',
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ),
                                          ),
                                          kundliMatchingController.isFemaleManglik == null
                                              ? const SizedBox()
                                              : Padding(
                                                  padding: EdgeInsets.only(top: 9.0),
                                                  child: Text(
                                                    kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                                    style: TextStyle(
                                                      color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Image.asset(
                                        "assets/images/couple_ring_image.png",
                                        scale: 8,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 3, /* strokeAlign: StrokeAlign.outside*/
                                              ),
                                              color: Get.theme.primaryColor,
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/no_customer_image.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              '${kundliMatchingController.cGirlName.text}',
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 9.0),
                                            child: Text(
                                              kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                              style: TextStyle(
                                                color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
//--------------------------Conclusion-------------------------------------
                            kundliMatchingController.kundliMatchDetailList!.conclusionList!.report == null
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
                                    margin: const EdgeInsets.symmetric(vertical: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Get.theme.primaryColor),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Get.theme.primaryColor,
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "BharatiyAstro Conclusion",
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'The overall points of this couple ${kundliMatchingController.kundliMatchDetailList!.conclusionList!.report!}',
                                            style: TextStyle(fontSize: 12, color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 9.0),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.white),
                                              foregroundColor: MaterialStateProperty.all(Colors.black),
                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                            ),
                                            onPressed: () {
                                              BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                                              bottomNavigationController.setIndex(1, 1);
                                              Get.off(() => BottomNavigationBarScreen(index: 0));
                                            },
                                            child: const Text("Chat with Astrologer"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                                          child: Image.asset(
                                            "assets/images/couple_image.png",
                                            scale: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                      bottomNavigationController.liveAstrologer.isEmpty
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
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Have Doubts regarding your match??', style: Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
                                                Text('Connect with recommended astrologers', style: Get.textTheme.bodyText2!.copyWith(color: Colors.grey, fontSize: 10)),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() => LiveAstrologerListScreen());
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
                                      bottomNavigationController.liveAstrologer.isEmpty
                                          ? const SizedBox()
                                          : Expanded(
                                              child: ListView.builder(
                                                itemCount: bottomNavigationController.liveAstrologer.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.only(top: 10, left: 10),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        bottomNavigationController.anotherLiveAstrologers = bottomNavigationController.liveAstrologer.where((element) => element.astrologerId != bottomNavigationController.liveAstrologer[index].astrologerId).toList();
                                                        bottomNavigationController.update();
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
                                                            isFollow: bottomNavigationController.liveAstrologer[index].isFollow!,
                                                            token: bottomNavigationController.liveAstrologer[index].token,
                                                            channel: bottomNavigationController.liveAstrologer[index].channelName,
                                                            astrologerName: bottomNavigationController.liveAstrologer[index].name,
                                                            astrologerId: bottomNavigationController.liveAstrologer[index].astrologerId,
                                                            isFromHome: true,
                                                            charge: bottomNavigationController.liveAstrologer[index].charge,
                                                            isForLiveCallAcceptDecline: false,
                                                            videoCallCharge: bottomNavigationController.liveAstrologer[index].videoCallRate,
                                                          ),
                                                        );
                                                      },
                                                      child: SizedBox(
                                                          child: Stack(alignment: Alignment.bottomCenter, children: [
                                                        bottomNavigationController.liveAstrologer[index].profileImage != "" && bottomNavigationController.liveAstrologer[index].profileImage != null
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
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  )
                : SizedBox(),
          );
        }),
      ),
    );
  }
}
