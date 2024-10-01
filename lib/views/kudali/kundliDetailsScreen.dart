import 'dart:io';

import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:BharatiyAstro/views/kudali/ashtakvargaScreen.dart';
import 'package:BharatiyAstro/views/kudali/basicKundliScreen.dart';
import 'package:BharatiyAstro/views/kudali/chartsScreen.dart';
import 'package:BharatiyAstro/views/kudali/kpScreen.dart';
import 'package:BharatiyAstro/views/kudali/kundliDashaScreen.dart';
import 'package:BharatiyAstro/views/kudali/kundliReportScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import '../../model/businessLayer/baseRoute.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import '../../utils/images.dart';

// ignore: must_be_immutable
class KundliDetailsScreen extends BaseRoute {
  final KundliModel? userDetails;
  KundliDetailsScreen({a, o, this.userDetails}) : super(a: a, o: o, r: 'KundliDetailsScreen');
  final KundliController kundliController = Get.find<KundliController>();
  final ReviewController reviewController = Get.find<ReviewController>();
  SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
        title: Text(
          'Kundli',
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
            onTap: () async {
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Share', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<KundliController>(builder: (c) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () async {
                        DateTime dateBasic = userDetails!.birthDate;
                        int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                        int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                        int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                        int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                        int formattedMint = int.parse(DateFormat('mm').format(dateBasic));

                        global.showOnlyLoaderDialog(context);
                        await kundliController.getBasicDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getBasicPanchangDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getBasicAvakhadaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getSadesatiDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getKalsarpaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getGemstoneDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getChartPlanetsDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getVimshattariDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getReportDescDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        kundliController.update();
                        global.hideLoader();
                        kundliController.changeTapIndex(0);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kundliController.kundliTabInitialIndex == 0 ? Get.theme.primaryColor : Colors.transparent,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                        ),
                        child: Text('Basic', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime dateBasic = userDetails!.birthDate;
                        int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                        int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                        int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                        int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                        int formattedMint = int.parse(DateFormat('mm').format(dateBasic));

                        global.showOnlyLoaderDialog(context);
                        await kundliController.getChartPlanetsDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        kundliController.update();
                        global.hideLoader();
                        kundliController.changeTapIndex(1);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kundliController.kundliTabInitialIndex == 1 ? Get.theme.primaryColor : Colors.transparent,
                          border: Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide(color: Colors.grey)),
                        ),
                        child: Text('Charts', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        kundliController.changeTapIndex(2);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kundliController.kundliTabInitialIndex == 2 ? Get.theme.primaryColor : Colors.transparent,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text('KP', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          kundliController.changeTapIndex(3);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: kundliController.kundliTabInitialIndex == 3 ? Get.theme.primaryColor : Colors.transparent,
                            border: Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide(color: Colors.grey)),
                          ),
                          child: Text('Ashtakvarga', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime dateBasic = userDetails!.birthDate;
                        int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                        int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                        int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                        int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                        int formattedMint = int.parse(DateFormat('mm').format(dateBasic));
                        global.showOnlyLoaderDialog(context);
                        await kundliController.getVimshattariDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        kundliController.update();
                        global.hideLoader();
                        kundliController.changeTapIndex(4);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kundliController.kundliTabInitialIndex == 4 ? Get.theme.primaryColor : Colors.transparent,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text('Dasha', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime dateBasic = userDetails!.birthDate;
                        int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                        int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                        int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                        int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                        int formattedMint = int.parse(DateFormat('mm').format(dateBasic));
                        global.showOnlyLoaderDialog(context);
                        await kundliController.getSadesatiDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getKalsarpaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        await kundliController.getGemstoneDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                        kundliController.update();
                        global.hideLoader();
                        kundliController.changeTapIndex(5);
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kundliController.kundliTabInitialIndex == 5 ? Get.theme.primaryColor : Colors.transparent,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                        ),
                        child: Text('Report', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
              kundliController.kundliTabInitialIndex == 0
                  ? BasicKundliScreen(
                      userDetails: userDetails,
                    )
                  : SizedBox(),
              kundliController.kundliTabInitialIndex == 1 ? ChartsScreen() : SizedBox(),
              kundliController.kundliTabInitialIndex == 2 ? KPScreen() : SizedBox(),
              kundliController.kundliTabInitialIndex == 3 ? AshtakvargaScreen() : SizedBox(),
              kundliController.kundliTabInitialIndex == 4 ? KundliDashaScreen(userModel: userDetails) : SizedBox(),
              kundliController.kundliTabInitialIndex == 5 ? KundliReportScreen() : SizedBox(),
            ],
          ),
        );
      }),
    );
  }
}
