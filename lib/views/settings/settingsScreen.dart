import 'package:BharatiyAstro/controllers/history_controller.dart';
import 'package:BharatiyAstro/controllers/settings_controller.dart';
import 'package:BharatiyAstro/views/astrologerProfile/block_astrologer_screen.dart';
import 'package:BharatiyAstro/views/settings/notificationScreen.dart';
import 'package:BharatiyAstro/views/settings/privacyPolicyScreen.dart';
import 'package:BharatiyAstro/views/settings/termsAndConditionScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../../widget/commonAppbar.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class SettingListScreen extends StatelessWidget {
  const SettingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: CommonAppBar(
              title: 'Settings',
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<SettingsController>(builder: (settingsController) {
                return settingsController.blockedAstroloer.isEmpty
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () async {
                          global.showOnlyLoaderDialog(context);
                          await settingsController.getBlockAstrologerList();
                          global.hideLoader();
                          Get.to(() => BlockAstrologerScreen());
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "Block Astrologer",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              }),
              GetBuilder<SettingsController>(builder: (settingsController) {
                return GestureDetector(
                  onTap: () async {
                    global.showOnlyLoaderDialog(context);
                    await settingsController.getNotification();
                    global.hideLoader();
                    Get.to(() => const NotificationScreen());
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Notifications",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: () {
                  Get.to(() => TermsAndConditionScreen());
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Terms and Condition",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const PrivacyPolicyScreen());
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text(
                        "Are you sure you want to logout?",
                        style: Get.textTheme.subtitle1,
                      ),
                      content: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('No'),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              onPressed: () {
                                HistoryController historyController = Get.find<HistoryController>();
                                historyController.chatHistoryList.clear();
                                historyController.astroMallHistoryList.clear();
                                historyController.reportHistoryList.clear();
                                historyController.callHistoryList.clear();
                                historyController.paymentLogsList.clear();
                                historyController.walletTransactionList.clear();
                                global.logoutUser();
                              },
                              child: Text('YES'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              "Logout my account",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GetBuilder<SettingsController>(builder: (settingsController) {
                return GestureDetector(
                  onTap: () async {
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      Get.dialog(
                        AlertDialog(
                          title: Text(
                            "Are you sure you want to delete this Account?",
                            style: Get.textTheme.subtitle1,
                          ),
                          content: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('No'),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    global.showOnlyLoaderDialog(context);
                                    settingsController.deleteAccount(global.sp!.getInt("currentUserId") ?? 0);
                                    global.logoutUser();
                                    global.hideLoader();
                                  },
                                  child: Text('YES'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "Delete my account",
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
