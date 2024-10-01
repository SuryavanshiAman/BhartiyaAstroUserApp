import 'package:BharatiyAstro/model/dailyHoroscopeModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class DailyHoroscopeController extends GetxController {
  List borderColor = [Colors.red, Colors.orange, Colors.green, Colors.blue, Colors.purple];
  List containerColor = [Color.fromARGB(255, 241, 223, 220), Color.fromARGB(255, 248, 233, 211), Color.fromARGB(255, 226, 248, 227), Color.fromARGB(255, 218, 234, 247), Color.fromARGB(255, 242, 227, 245)];
  int day = 2; // 1 for yesterday, 2 for today and 3 for tomorrow
  bool isMonth = true;
  bool isWeek = false;
  bool isYear = false;
  bool isDaily = false;
  int zodiacindex = 0;
  int? signId;
  APIHelper apiHelper = APIHelper();
  var horoscopeList = <DailyHororscopeModel>[];
  DailyscopeModel? dailyList;
  Map<String, dynamic> dailyHororscopeData = {};
  Map<String, dynamic> horoscopeListData = {};
  TextEditingController feedbackController = TextEditingController();
  FocusNode fFeedback = FocusNode();
  String? feedbackGroupValue;
  updateDaily(int flag) {
    day = flag;
    update();
  }

  updateTimely({required bool month, required bool year, required bool week}) {
    isMonth = month;
    isWeek = week;
    isYear = year;
    update();
  }

  selectZodic(int index) async {
    await getHororScopeSignData();
    global.hororscopeSignList.map((e) => e.isSelected = false).toList();
    global.hororscopeSignList[index].isSelected = true;
    zodiacindex = index;
    signId = global.hororscopeSignList[index].id;
    update();
  }

  @override
  Future onInit() async {
    super.onInit();

    await getHororScopeSignData();
    await getDefaultDailyHororscope();
    if (global.hororscopeSignList.isNotEmpty) {
      await getHoroscopeList(horoscopeId: global.hororscopeSignList[0].id);
    }
  }

  Future getDefaultDailyHororscope() async {
    try {
      if (global.hororscopeSignList.isNotEmpty) {
        global.hororscopeSignList[0].isSelected = true;
        await getHororScopeSignData();
      }
    } catch (e) {
      print('Exception in getDefaultDailyHororscope():' + e.toString());
    }
  }

  Future getHororScopeSignData() async {
    try {
      if (global.hororscopeSignList.isEmpty) {
        await global.checkBody().then((result) async {
          if (result) {
            await apiHelper.getHororscopeSign().then((result) {
              if (result.status == "200") {
                global.hororscopeSignList = result.recordList;
                signId = global.hororscopeSignList[0].id;
                update();
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
      }
    } catch (e) {
      print('Exception in getHororScopeSignData():' + e.toString());
    }
  }

  getHoroscopeList({int? horoscopeId}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHoroscope(horoscopeSignId: horoscopeId).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              dailyList = DailyscopeModel.fromJson(map);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Not show daily horoscope',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getHoroscopeList():' + e.toString());
    }
  }

  addFeedBack() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          var feedbackType = feedbackGroupValue;
          var feedback = feedbackController.text != '' ? feedbackController.text : null;
          await apiHelper.addFeedBack(feedbackType!, feedback).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'Thanks for your feedback!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to add feedback please try again later!',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getHoroscopeList():' + e.toString());
    }
  }
}
