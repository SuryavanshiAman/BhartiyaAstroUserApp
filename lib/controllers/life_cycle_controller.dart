// ignore_for_file: avoid_log

import 'dart:developer';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/customer_support_controller.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

class HomeCheckController extends FullLifeCycleController with FullLifeCycleMixin {
  // Mandatory

  @override
  void onDetached() {
    log('HomeController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() async {
    log('Hello');
    log('HomeController - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    log('HomeController - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() async {
    BottomNavigationController bottomController = Get.find<BottomNavigationController>();
    await bottomController.getLiveAstrologerList();
    global.sp = await SharedPreferences.getInstance();
    CustomerSupportController customerSupportController = Get.find<CustomerSupportController>();
    if (customerSupportController.tickitIndex != null) {
      global.showOnlyLoaderDialog(Get.context);
      await customerSupportController.getCustomerTickets();
      await customerSupportController.getCustomerReview(customerSupportController.ticketList[customerSupportController.tickitIndex!].id!);
      customerSupportController.status = customerSupportController.ticketList[customerSupportController.tickitIndex!].ticketStatus!;
      customerSupportController.update();
      global.hideLoader();
    }
    log("App Is Release");
  }

  @override
  Future<bool> didPushRoute(String route) {
    log('HomeController - the route $route will be open');
    return super.didPushRoute(route);
  }

  // Optional
  @override
  Future<bool> didPopRoute() {
    log('HomeController - the current route will be closed');
    return super.didPopRoute();
  }

  // Optional
  @override
  void didChangeMetrics() {
    log('HomeController - the window size did change');
    super.didChangeMetrics();
  }

  // Optional
  @override
  void didChangePlatformBrightness() {
    log('HomeController - platform change ThemeMode');
    super.didChangePlatformBrightness();
  }
}
