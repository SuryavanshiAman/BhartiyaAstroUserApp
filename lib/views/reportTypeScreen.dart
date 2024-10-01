// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:BharatiyAstro/controllers/reportController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/reportInTakeFormScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class ReportTypeScreen extends StatelessWidget {
  final String astrologerName;
  final int astrologerId;
  ReportTypeScreen({
    Key? key,
    required this.astrologerId,
    required this.astrologerName,
  }) : super(key: key);

  ReportController reportController = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        reportController.searchReportController.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'Select Report type',
            style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
          ),
          leading: IconButton(
            onPressed: () {
              reportController.searchReportController.clear();
              Get.back();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
          actions: [
            GetBuilder<ReportController>(builder: (c) {
              return IconButton(
                  onPressed: () {
                    reportController.isSearch = true;
                    reportController.update();
                  },
                  icon: Icon(
                    Icons.search,
                    color: Get.theme.iconTheme.color,
                  ));
            }),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: Get.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.bgImage),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            controller: reportController.reportTypeScrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GetBuilder<ReportController>(builder: (c) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (reportController.isSearch)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                    child: FutureBuilder(
                                        future: global.translatedText('Search report..'),
                                        builder: (context, snapshot) {
                                          return TextField(
                                            controller: reportController.searchReportController,
                                            keyboardType: TextInputType.text,
                                            cursorColor: global.coursorColor,
                                            onChanged: (value) async {
                                              reportController.searchString = value;
                                              reportController.reportTypeList = [];
                                              reportController.reportTypeList.clear();
                                              reportController.isAllDataLoaded = false;
                                              reportController.update();
                                              await reportController.getReportTypes(value, false);
                                            },
                                            decoration: InputDecoration(
                                              hintText: snapshot.data,
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                                              isDense: true,
                                              border: new UnderlineInputBorder(
                                                borderSide: new BorderSide(color: Get.theme.primaryColor),
                                              ),
                                              enabledBorder: new UnderlineInputBorder(
                                                borderSide: new BorderSide(color: Get.theme.primaryColor),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Get.theme.primaryColor),
                                              ),
                                            ),
                                          );
                                        })),
                                const SizedBox(width: 15),
                                GestureDetector(
                                    onTap: () async {
                                      reportController.isSearch = false;
                                      reportController.searchReportController.clear();
                                      global.showOnlyLoaderDialog(context);
                                      reportController.searchString = null;
                                      reportController.reportTypeList = [];
                                      reportController.reportTypeList.clear();
                                      reportController.isAllDataLoaded = false;
                                      reportController.update();
                                      await reportController.getReportTypes(null, false);
                                      global.hideLoader();
                                      reportController.update();
                                    },
                                    child: Image.asset(
                                      Images.closeRound,
                                      height: 25,
                                      width: 25,
                                    ))
                              ],
                            ),
                          ),
                        reportController.reportTypeList.isEmpty
                            ? SizedBox(
                                height: Get.height * 0.8,
                                child: Center(
                                  child: Text('Result Not Found'),
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: reportController.reportTypeList.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomContainer(
                                      reportId: reportController.reportTypeList[i].id,
                                      title: reportController.reportTypeList[i].title,
                                      image: "${reportController.reportTypeList[i].reportImage}",
                                      desc: reportController.reportTypeList[i].description,
                                      astrologerId: astrologerId,
                                      astrologerName: astrologerName,
                                    ),
                                  );
                                })
                      ],
                    );
                  }),
                ),
                reportController.isMoreDataAvailable == true && !reportController.isAllDataLoaded ? const CircularProgressIndicator() : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.title,
    required this.image,
    required this.desc,
    required this.astrologerId,
    required this.astrologerName,
    required this.reportId,
  }) : super(key: key);
  final String title;
  final String image;
  final String desc;
  final int astrologerId;
  final int reportId;
  final String astrologerName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ReportInTakeForm(
              reportId: reportId,
              reportType: title,
              astrologerId: astrologerId,
              astrologerName: astrologerName,
            ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 236, 235),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            image == ""
                ? Image.asset(
                    Images.yearlyImage,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  )
                : CachedNetworkImage(
                    imageUrl: '${global.imgBaseurl}$image',
                    imageBuilder: (context, imageProvider) => Image.network(
                      '${global.imgBaseurl}$image',
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      Images.yearlyImage,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 6, left: 8.0),
              child: Text(
                title,
                style: Get.textTheme.subtitle1!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: global.showHtml(html: desc),
              builder: (context, snapshot) {
                return snapshot.data ?? Html(data: desc);
              },
            )
          ],
        ),
      ),
    );
  }
}
