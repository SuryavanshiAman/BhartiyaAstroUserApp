import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveAstrologerController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
