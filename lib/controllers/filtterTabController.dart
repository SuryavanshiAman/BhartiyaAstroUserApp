import 'package:BharatiyAstro/model/filterModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FiltterTabController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? filterTab;
  String? selectedString;
  bool isSelect = false;

  List filtterList = [
    'Sort By',
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
    filterTab = TabController(vsync: this, length: filtterList.length);
    super.onInit();
  }

  @override
  void dispose() {
    filterTab?.dispose();
    super.dispose();
  }
}
