// ignore_for_file: unused_local_variable

import 'package:BharatiyAstro/model/kundliMatchingDetailsModel.dart';
import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

class KundliMatchingController extends GetxController with GetTickerProviderStateMixin {
//Tab Manage
  int currentIndex = 0;
  RxInt homeTabIndex = 0.obs;
  TabController? kundliMatchingTabController;
  APIHelper apiHelper = new APIHelper();
  int? boykundliId;
  int? girlKundliId;
  int? minGirls;
  int? minBoy;
  double? lat;
  double? long;
  double? tzone;
  int? hourGirl;
  int? hourBoy;
  var varnaList = <KundliMatchingDetailModel>[];
  var vashyaList = <KundliMatchingDetailModel>[];
  var taraList = <KundliMatchingDetailModel>[];
  var yoniList = <KundliMatchingDetailModel>[];
  var maitriList = <KundliMatchingDetailModel>[];
  var ganList = <KundliMatchingDetailModel>[];
  var bhakutList = <KundliMatchingDetailModel>[];
  var nadiList = <KundliMatchingDetailModel>[];
  var totalList = <TotalMatchModel>[];
  var conclusionList = <ConclusionModel>[];
  KundliMatchingTitleModel? kundliMatchDetailList;
  bool? isFemaleManglik;
  bool? isMaleManglik;

  @override
  onInit() {
    _init();
    super.onInit();
  }

  _init() {
    onBoyDateSelected(DateTime.now());
    onGirlDateSelected(DateTime.now());
    cBoysBirthTime.text = DateFormat.jm().format(DateTime.now());
    cGirlBirthTime.text = DateFormat.jm().format(DateTime.now());
    cBoysBirthPlace.text = "New Delhi,Delhi,India";
    cGirlBirthPlace.text = "New Delhi,Delhi,India";
  }

  onHomeTabBarIndexChanged(value) {
    homeTabIndex.value = value;
    update();
  }

//Boys Name
  final TextEditingController cBoysName = TextEditingController();
//Boys Birth Date
  final TextEditingController cBoysBirthDate = TextEditingController();
  DateTime? boySelectedDate;
  onBoyDateSelected(DateTime picked) {
    if (picked != boySelectedDate) {
      boySelectedDate = picked;

      cBoysBirthDate.text = boySelectedDate.toString();
      cBoysBirthDate.text = formatDate(boySelectedDate!, [dd, '-', mm, '-', yyyy]);
    }
    update();
  }

//Boys Birthdate Time
  final TextEditingController cBoysBirthTime = TextEditingController();
//Boys Birth Place
  final TextEditingController cBoysBirthPlace = TextEditingController();

//Girls Name
  final TextEditingController cGirlName = TextEditingController();
//Girls Birth Date
  final TextEditingController cGirlBirthDate = TextEditingController();
  DateTime? girlSelectedDate;
  onGirlDateSelected(DateTime picked) {
    if (picked != girlSelectedDate) {
      girlSelectedDate = picked;

      cGirlBirthDate.text = girlSelectedDate.toString();
      cGirlBirthDate.text = formatDate(girlSelectedDate!, [dd, '-', mm, '-', yyyy]);
    }
    update();
  }

//Girls Birthdate Time
  final TextEditingController cGirlBirthTime = TextEditingController();
//Girls Birth Place
  final TextEditingController cGirlBirthPlace = TextEditingController();
  String? errorMessage;

  openKundliData(var kundliList, int index) {
    if (kundliList[index].gender == "Male") {
      boykundliId = kundliList[index].id;
      cBoysName.text = kundliList[index].name;
      cBoysBirthDate.text = formatDate(kundliList[index].birthDate, [dd, '-', mm, '-', yyyy]);
      cBoysBirthTime.text = kundliList[index].birthTime.toString();
      cBoysBirthPlace.text = kundliList[index].birthPlace.toString();
      update();
    } else if (kundliList[index].gender == "Female") {
      girlKundliId = kundliList[index].id;
      cGirlName.text = kundliList[index].name;
      cGirlBirthDate.text = formatDate(kundliList[index].birthDate, [dd, '-', mm, '-', yyyy]);
      cGirlBirthTime.text = kundliList[index].birthTime.toString();
      cGirlBirthPlace.text = kundliList[index].birthPlace.toString();
      update();
    }
  }

  bool isValidData() {
    if (cBoysName.text == "") {
      errorMessage = "Please Input boy\'s detail";
      update();
      return false;
    } else if (cGirlName.text == "") {
      errorMessage = "Please Input Girl\'s detail";
      update();
      return false;
    } else {
      return true;
    }
  }

  addKundliMatchData() async {
    global.showOnlyLoaderDialog(Get.context);
    KundliModel sendKundli;
    List<KundliModel> kundliModel = [
      KundliModel(id: boykundliId, name: cBoysName.text, gender: 'Male', birthDate: boySelectedDate!, birthTime: cBoysBirthTime.text, birthPlace: cBoysBirthPlace.text, latitude: lat, longitude: long),
      KundliModel(id: girlKundliId, name: cGirlName.text, gender: 'Female', birthDate: girlSelectedDate!, birthTime: cGirlBirthTime.text, birthPlace: cGirlBirthPlace.text, latitude: lat, longitude: long),
    ];
    int ind = cBoysBirthTime.text.indexOf(":");
    int ind2 = cGirlBirthTime.text.indexOf(":");
    hourBoy = int.parse(cBoysBirthTime.text.substring(0, ind));
    hourGirl = int.parse(cGirlBirthTime.text.substring(0, ind2));
    //print('done ' + cBoysBirthTime.text.substring(ind + 1, ind + 3));
    minBoy = int.parse(cBoysBirthTime.text.substring(ind + 1, ind + 3));
    minGirls = int.parse(cGirlBirthTime.text.substring(ind2 + 1, ind2 + 3));
    update();
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.addKundli(kundliModel).then((result) async {
          if (result.status == "200") {
            print('success');
            getKundlMatchingiList(boySelectedDate!, girlSelectedDate!);
            getKundlMagllicList(boySelectedDate!, girlSelectedDate!);
            global.hideLoader();
          } else {
            global.sp = await SharedPreferences.getInstance();
            if (global.sp!.getString("currentUser") == null) {
              getKundlMatchingiList(boySelectedDate!, girlSelectedDate!);
              getKundlMagllicList(boySelectedDate!, girlSelectedDate!);
            } else {
              getKundlMatchingiList(boySelectedDate!, girlSelectedDate!);
              getKundlMagllicList(boySelectedDate!, girlSelectedDate!);
              global.showToast(
                message: 'Failed to add kundli please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            global.hideLoader();
          }
        });
      }
    });
  }

  getKundlMatchingiList(DateTime kundliBoys, DateTime kundliGirls) async {
    try {
      kundliMatchDetailList = null;
      DateTime datePanchang = kundliBoys;
      int formattedYear = int.parse(DateFormat('yyyy').format(datePanchang));
      int formattedDay = int.parse(DateFormat('dd').format(datePanchang));
      int formattedMonth = int.parse(DateFormat('MM').format(datePanchang));
      DateTime dateForGirl = kundliGirls;
      int yearGirl = int.parse(DateFormat('yyyy').format(dateForGirl));
      int dayGirl = int.parse(DateFormat('dd').format(dateForGirl));
      int monthGirl = int.parse(DateFormat('MM').format(dateForGirl));
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getMatching(formattedDay, formattedMonth, formattedYear, hourBoy, minBoy, dayGirl, monthGirl, yearGirl, hourGirl, minGirls).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliMatchDetailList = KundliMatchingTitleModel.fromJson(map);
              update();
              print(kundliMatchDetailList);
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  getKundlMagllicList(DateTime kundliBoys, DateTime kundliGirls) async {
    try {
      kundliMatchDetailList = null;
      DateTime datePanchang = kundliBoys;
      int formattedYear = int.parse(DateFormat('yyyy').format(datePanchang));
      int formattedDay = int.parse(DateFormat('dd').format(datePanchang));
      int formattedMonth = int.parse(DateFormat('MM').format(datePanchang));
      DateTime dateForGirl = kundliGirls;
      int yearGirl = int.parse(DateFormat('yyyy').format(dateForGirl));
      int dayGirl = int.parse(DateFormat('dd').format(dateForGirl));
      int monthGirl = int.parse(DateFormat('MM').format(dateForGirl));
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getManglic(formattedDay, formattedMonth, formattedYear, hourBoy, minBoy, dayGirl, monthGirl, yearGirl, hourGirl, minGirls).then((result) {
            if (result != null) {
              isFemaleManglik = result['female']['is_present'];
              isMaleManglik = result['male']['is_present'];
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }
}
