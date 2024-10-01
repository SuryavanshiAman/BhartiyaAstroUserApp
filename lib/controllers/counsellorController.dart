import 'package:BharatiyAstro/model/counsellor_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class CounsellorController extends GetxController {
  bool isCall = false;
  bool isChat = true;
  APIHelper apiHelper = APIHelper();
  var counsellorList = <CounsellorModel>[];
  ScrollController scrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  @override
  void onInit() async {
    super.onInit();
    paginateTask();
  }

  void paginateTask() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        update();
        await getCounsellorsData(true);
      }
    });
  }

  setBottomTab({required bool call, required bool chat}) {
    isCall = call;
    isChat = chat;
    update();
  }

  getCounsellorsData(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (counsellorList.isNotEmpty) {
        startIndex = counsellorList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getCounsellors(startIndex, fetchRecord).then((result) {
            if (result.status == "200") {
              counsellorList.addAll(result.recordList);
              print('counsellor list length ${counsellorList.length} ');
              if (result.recordList.length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
              print('counsellor list length ${counsellorList.length} ');
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getCounsellorsData():' + e.toString());
    }
  }
}
