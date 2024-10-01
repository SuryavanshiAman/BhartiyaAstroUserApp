import 'dart:developer';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/model/skillModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class SkillController extends GetxController {
  APIHelper apiHelper = APIHelper();
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();

  var skillList = <SkillModel>[];
  List<int> skillFilterList = [];

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {}

  getSkills() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getSkill().then((result) {
            if (result.status == "200") {
              skillList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get skill',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            if (skillFilterList.isNotEmpty) {
              for (var i = 0; i < skillList.length; i++) {
                skillList[i].isSelected = false;
                for (var j = 0; j < skillFilterList.length; j++) {
                  if (skillFilterList[j] == skillList[i].id) {
                    skillList[i].isSelected = true;
                  } else {}
                }
              }
            } else {
              for (var i = 0; i < skillList.length; i++) {
                skillList[i].isSelected = true;
              }
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getSkill():' + e.toString());
    }
  }

  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  addFilter({List<int>? skills, List<int>? language, List<String>? gender, String? sortBy, bool isLazyLoading = false, int? catId}) async {
    try {
      bottomNavigationController.startIndex = 0;
      bottomNavigationController.astrologerList.clear();

      if (bottomNavigationController.astrologerList.isNotEmpty) {
        bottomNavigationController.startIndex = bottomNavigationController.astrologerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      global.showOnlyLoaderDialog(Get.context);
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstrologer(sortingKey: sortBy, skills: skills, language: language, gender: gender, startIndex: startIndex, fetchRecords: fetchRecord, catId: catId).then((result) {
            if (result.status == "200") {
              bottomNavigationController.astrologerList.addAll(result.recordList);
              log('astrologer list length ${bottomNavigationController.astrologerList.length} ');
              bottomNavigationController.update();
              print('filter length ${bottomNavigationController.astrologerList.length}');
              global.hideLoader();
            } else {
              global.hideLoader();

              global.showToast(
                message: 'Failed to add filter',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getSkill():' + e.toString());
    }
  }
}
