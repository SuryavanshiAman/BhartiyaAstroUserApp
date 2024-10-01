import 'package:BharatiyAstro/model/filterModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportFilterTabController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? reportFilterTab;
  String? selectedString;
  bool isSelect = false;

  List reportFilter = [
    'Skill',
    'Language',
    'Gender',
    // 'Country',
  ];

  List<FilterModel> gender = [FilterModel(name: 'Female', isCheck: true), FilterModel(name: 'Male', isCheck: true)];
  List<String> genderFilterList = [];
  var selectedFilterIndex = 0.obs;
  var active;
  @override
  void onInit() async {
    reportFilterTab = TabController(vsync: this, length: reportFilter.length);
    super.onInit();
  }

  @override
  void dispose() {
    reportFilterTab?.dispose();
    // filterPage.dispose();
    super.dispose();
  }
}
