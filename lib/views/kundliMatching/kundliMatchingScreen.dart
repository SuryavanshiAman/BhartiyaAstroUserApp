import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/kundliMatching/kudliMatchingResultScreen.dart';
import 'package:BharatiyAstro/views/kundliMatching/newMatchingScreen.dart';
import 'package:BharatiyAstro/views/kundliMatching/openKundliScreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../controllers/kundliMatchingController.dart';
import '../../widget/commonAppbar.dart';

class KundliMatchingScreen extends StatelessWidget {
  KundliMatchingScreen({Key? key}) : super(key: key);
  final KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();
  final KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<KundliMatchingController>(
          init: kundliMatchingController,
          builder: (controller) {
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: CommonAppBar(
                    title: 'Kundli Matching',
                  )),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(Images.bgImage),
                  ),
                ),
                child: DefaultTabController(
                    length: 2,
                    initialIndex: kundliMatchingController.currentIndex,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: TabBar(
                                unselectedLabelColor: Colors.black,
                                labelColor: Colors.black,
                                indicatorWeight: 0.1,
                                indicatorColor: Colors.blue,
                                labelPadding: EdgeInsets.zero,
                                tabs: [
                                  Obx(
                                    () => kundliMatchingController.homeTabIndex.value == 0
                                        ? Container(
                                            height: Get.height,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor,
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                              border: Border.all(color: Colors.grey),
                                            ),
                                            child: Center(child: Text('Open Kundli')),
                                          )
                                        : Center(
                                            child: Text('Open Kundli'),
                                          ),
                                  ),
                                  Obx(
                                    () => kundliMatchingController.homeTabIndex.value == 1
                                        ? Container(
                                            height: Get.height,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor,
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                topLeft: Radius.circular(12),
                                                bottomRight: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              border: Border.all(color: Colors.grey),
                                            ),
                                            child: Center(child: Text('New Matching')),
                                          )
                                        : Center(
                                            child: Text('New Matching'),
                                          ),
                                  ),
                                ],
                                onTap: (index) {
                                  global.showOnlyLoaderDialog(Get.context);
                                  kundliMatchingController.onHomeTabBarIndexChanged(index);
                                  global.hideLoader();
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: kundliMatchingController.homeTabIndex.value == 1
                              ?
//First Tabbar
                              NewMatchingScreen()
                              :
//Second Tabbar
                              OpenKundliScreen(),
                        )
                      ],
                    )),
              ),
              bottomNavigationBar: kundliMatchingController.homeTabIndex.value == 1
                  ? Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Images.bgImage),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Get.theme.primaryColor,
                            maximumSize: Size(MediaQuery.of(context).size.width, 100),
                            minimumSize: Size(MediaQuery.of(context).size.width, 48),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            bool isvalid = kundliMatchingController.isValidData();
                            if (!isvalid) {
                              global.showToast(
                                message: kundliMatchingController.errorMessage ?? "",
                                textColor: global.textColor,
                                bgColor: global.toastBackGoundColor,
                              );
                            } else {
                              await kundliMatchingController.addKundliMatchData();
                              kundliMatchingController.update();
                              Get.to(() => KudliMatchingResultScreen());
                            }
                          },
                          child: const Text(
                            "Match Horoscope",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            );
          }),
    );
  }
}
