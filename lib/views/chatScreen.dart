// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/chatController.dart';
import 'package:BharatiyAstro/controllers/filtterTabController.dart';
import 'package:BharatiyAstro/controllers/languageController.dart';
import 'package:BharatiyAstro/controllers/reportController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/skillController.dart';
import 'package:BharatiyAstro/controllers/walletController.dart';
import 'package:BharatiyAstro/main.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/VideoCall/VideoCallScreen.dart';
import 'package:BharatiyAstro/views/addMoneyToWallet.dart';
import 'package:BharatiyAstro/views/astrologerProfile/astrologerProfile.dart';
import 'package:BharatiyAstro/views/callIntakeFormScreen.dart';
import 'package:BharatiyAstro/views/chat/incoming_chat_request.dart';
import 'package:BharatiyAstro/views/paymentInformationScreen.dart';
import 'package:BharatiyAstro/views/searchAstrologerScreen.dart';
import 'package:BharatiyAstro/widget/customAppbarWidget.dart';
import 'package:BharatiyAstro/widget/drawerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/VedioCallController.dart';
import '../controllers/razorPayController.dart';
import '../controllers/splashController.dart';
// import '../utils/global.dart';
import 'free_chat_screen.dart';
import 'profile/editUserProfileScreen.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final drawerKey = new GlobalKey<ScaffoldState>();

  FiltterTabController filtterTabController = Get.find<FiltterTabController>();

  SkillController skillController = Get.find<SkillController>();

  LanguageController languageController = Get.find<LanguageController>();

  ReportController reportController = Get.find<ReportController>();

  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();

  WalletController walletController = Get.find<WalletController>();
  //  final SplashController splashcontroller = Get.put(SplashController());
  ChatController cController = Get.find<ChatController>();
  VedioController vedioController = Get.put(VedioController());
  @override
  void initState() {
    init();
    super.initState();
  }

  getPermissions() async {
    await [Permission.microphone, Permission.camera].request();
    vedioController.isPersmission.value = true;
  }

  init() async {
    global.sp = await SharedPreferences.getInstance();
    await global.sp!.reload();
    global.sp = global.sp;
    if (global.sp!.getInt('chatBottom') == 1) {
      chatController.chatBottom = true;
      chatController.update();
    } else {
      chatController.chatBottom = false;
      chatController.update();
    }
    print(global.sp);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bottomNavigationController.setBottomIndex(0, 1);
        return false;
      },
      child: Scaffold(
        drawer: DrawerWidget(),
        appBar: CustomAppBar(
          flagId: 1,
          onBackPressed: () {},
          scaffoldKey: GlobalKey<ScaffoldState>(),
          title: 'Astrologers list',
          titleStyle: Get.theme.primaryTextTheme.subtitle2!.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          bgColor: Get.theme.primaryColor,
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => AddmoneyToWallet());
              },
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  global.splashController.currentUser?.walletAmount != null
                      ? Container(
                          padding: EdgeInsets.all(2),
                          margin: EdgeInsets.symmetric(vertical: 17),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}',
                            style: Get.theme.primaryTextTheme.bodySmall,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SearchAstrologerScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: Get.theme.iconTheme.color,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                openBottomSheetFilter(context);
                skillController.getSkills();
                languageController.getLanguages();
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      FontAwesomeIcons.filter,
                      size: 20,
                      color: Get.theme.iconTheme.color,
                    ),
                  ),
                  bottomNavigationController.applyFilter
                      ? Positioned(
                          right: 4,
                          top: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 4,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ),
        body: GetBuilder<ChatController>(
          builder: (chatController) {
            return DefaultTabController(
              length: chatController.categoryList.length,
              child: Column(
                children: [
                  TabBar(
                    padding: EdgeInsets.only(top: 10),
                    controller: chatController.categoryTab,
                    isScrollable: true,
                    onTap: (value) async {
                      chatController.isSelected = value;
                      if (value == 0) {
                        global.showOnlyLoaderDialog(context);
                        bottomNavigationController.astrologerList = [];
                        bottomNavigationController.astrologerList.clear();
                        bottomNavigationController.isAllDataLoaded = false;
                        bottomNavigationController.update();
                        await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                        global.hideLoader();
                      } else {
                        for (var i = 0; i < chatController.categoryList.length; i++) {
                          if (value == i) {
                            bottomNavigationController.astrologerList = [];
                            bottomNavigationController.astrologerList.clear();
                            bottomNavigationController.isAllDataLoaded = false;
                            bottomNavigationController.update();
                            global.showOnlyLoaderDialog(context);
                            await bottomNavigationController.astroCat(
                                id: chatController.categoryList[i].id!, isLazyLoading: false);
                            global.hideLoader();
                          }
                        }
                      }
                      chatController.update();
                    },
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    tabs: List.generate(chatController.categoryList.length, (index) {
                      return GetBuilder<ChatController>(builder: (chatco) {
                        return SizedBox(
                          height: 30,
                          child: Chip(
                            padding: EdgeInsets.only(bottom: 5),
                            backgroundColor: chatController.isSelected == index ? Colors.transparent : Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:
                                      chatController.isSelected == index ? Get.theme.primaryColor : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(7)),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    height: 20,
                                    width: 20,
                                    imageUrl: '${global.imgBaseurl}${chatController.categoryList[index].image}',
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.grid_view_rounded, color: Get.theme.primaryColor, size: 20),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    chatController.categoryList[index].name,
                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    }),
                  ),
                  GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
                    return bottomNavigationController.astrologerList.length == 0
                        ? Container(
                            height: Get.height * 0.63,
                            child: Center(
                              child: Text(
                                'Astrologer not available',
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                            ),
                          )
                        : Expanded(
                            child: TabBarView(
                            controller: chatController.categoryTab,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(chatController.categoryList.length, (index) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  bottomNavigationController.astrologerList = [];
                                  bottomNavigationController.astrologerList.clear();
                                  bottomNavigationController.isAllDataLoaded = false;
                                  if (bottomNavigationController.genderFilterList != null) {
                                    bottomNavigationController.genderFilterList!.clear();
                                  }
                                  if (bottomNavigationController.languageFilter != null) {
                                    bottomNavigationController.languageFilter!.clear();
                                  }
                                  if (bottomNavigationController.skillFilterList != null) {
                                    bottomNavigationController.skillFilterList!.clear();
                                  }
                                  bottomNavigationController.applyFilter = false;
                                  bottomNavigationController.update();
                                  await bottomNavigationController.getAstrologerList(isLazyLoading: false);
                                },
                                child: TabViewWidget(
                                  astrologerList: bottomNavigationController.astrologerList,
                                ),
                              );
                            }),
                          ));
                  }),
                ],
              ),
            );
          },
        ),
        // bottomSheet: GetBuilder<ChatController>(builder: (C) {
        //   return chatController.chatBottom == true
        //       ? Container(
        //           color: Get.theme.primaryColor,
        //           height: 40,
        //           width: Get.width,
        //           padding: const EdgeInsets.all(8),
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 child: Text('Start chat with ${cController.bottomAstrologerName}'),
        //               ),
        //               TextButton(
        //                 style: ButtonStyle(
        //                   padding: MaterialStateProperty.all(EdgeInsets.all(0)),
        //                   backgroundColor: MaterialStateProperty.all(Colors.green),
        //                   shape: MaterialStateProperty.all(
        //                     RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(10),
        //                     ),
        //                   ),
        //                 ),
        //                 onPressed: () async {
        //                   cController.bottomAstrologerName = global.sp!.getString('bottomAstrologerName') ?? '';
        //                   cController.bottomAstrologerProfile = global.sp!.getString('bottomAstrologerProfile') ?? '';
        //                   cController.bottomFirebaseChatId = global.sp!.getString('bottomFirebaseChatId') ?? '';
        //                   cController.bottomChatId = global.sp!.getInt('bottomChatId');
        //                   cController.bottomAstrologerId = global.sp!.getInt('bottomAstrologerId');
        //                   cController.bottomFcmToken = global.sp!.getString('bottomFcmToken');
        //                      await bottomNavigationController.getAstrologerbyId(cController.bottomAstrologerId!);
        //                   cController.update();
        //                   Get.to(() => IncomingChatRequest(
        //                         astrologerName: cController.bottomAstrologerName,
        //                         profile: cController.bottomAstrologerProfile,
        //                         fireBasechatId: cController.bottomFirebaseChatId ?? "",
        //                         chatId: cController.bottomChatId!,
        //                         astrologerId: cController.bottomAstrologerId!,
        //                         fcmToken: cController.bottomFcmToken,
        //                       ));
        //                 },
        //                 child: Text(
        //                   'Start',
        //                   style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         )
        //       : const SizedBox();
        // }),
      ),
    );
  }

  void openBottomSheetFilter(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sort & Filter'),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Obx(
                    () => RotatedBox(
                      quarterTurns: 1,
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: filtterTabController.filterTab,
                        indicatorColor: Colors.pink,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.grey[50],
                        onTap: (index) {
                          filtterTabController.selectedFilterIndex.value = index;
                          filtterTabController.update();
                        },
                        tabs: List.generate(
                          filtterTabController.filtterList.length,
                          (ind) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                color: filtterTabController.selectedFilterIndex.value == ind
                                    ? Colors.white
                                    : Colors.grey[50],
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: filtterTabController.selectedFilterIndex.value == ind
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        filtterTabController.filtterList[ind],
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBarView(
                      controller: filtterTabController.filterTab,
                      children: [
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<ReportController>(
                            builder: (rpcont) {
                              return GetBuilder<SkillController>(
                                builder: (c) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: ListView.builder(
                                          itemCount: reportController.sorting.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return RadioListTile(
                                              groupValue: reportController.groupValue,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              contentPadding: EdgeInsets.zero,
                                              activeColor: Colors.black,
                                              value: reportController.sorting[index].id,
                                              onChanged: (val) {
                                                reportController.groupValue = val!;

                                                reportController.update();
                                              },
                                              title: Text(reportController.sorting[index].name!),
                                            );
                                          }));
                                },
                              );
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<SkillController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                    itemCount: skillController.skillList.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: Colors.black,
                                        value: skillController.skillList[index].isSelected,
                                        onChanged: (value) {
                                          skillController.skillList[index].isSelected = value!;
                                          skillController.update();
                                        },
                                        title: Text(skillController.skillList[index].name),
                                      );
                                    },
                                  ));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<LanguageController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: languageController.languageList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: languageController.languageList[index].isSelected,
                                          onChanged: (value) {
                                            languageController.languageList[index].isSelected = value!;
                                            languageController.update();
                                          },
                                          title: Text(languageController.languageList[index].languageName),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<FiltterTabController>(builder: (c) {
                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: ListView.builder(
                                    itemCount: filtterTabController.gender.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        controlAffinity: ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: Colors.black,
                                        value: filtterTabController.gender[index].isCheck,
                                        onChanged: (value) {
                                          filtterTabController.gender[index].isCheck = value!;
                                          filtterTabController.update();
                                        },
                                        title: Text(filtterTabController.gender[index].name),
                                      );
                                    }));
                          }),
                        )),
                        SizedBox()
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: 0,
                          child: TextButton(
                            onPressed: () async {
                              skillController.skillFilterList = [];
                              filtterTabController.genderFilterList = [];
                              languageController.languageFilterList = [];
                              reportController.sortingFilter = null;
                              for (var i = 0; i < skillController.skillList.length; i++) {
                                skillController.skillList[i].isSelected = false;

                                skillController.update();
                              }
                              for (var i = 0; i < languageController.languageList.length; i++) {
                                languageController.languageList[i].isSelected = false;

                                languageController.update();
                              }
                              for (var i = 0; i < filtterTabController.gender.length; i++) {
                                filtterTabController.gender[i].isCheck = false;

                                filtterTabController.update();
                              }
                              bottomNavigationController.astrologerList = [];
                              bottomNavigationController.astrologerList.clear();
                              bottomNavigationController.isAllDataLoaded = false;
                              bottomNavigationController.skillFilterList = skillController.skillFilterList;
                              bottomNavigationController.genderFilterList = filtterTabController.genderFilterList;
                              bottomNavigationController.languageFilter = languageController.languageFilterList;
                              bottomNavigationController.applyFilter = false;
                              bottomNavigationController.update();
                              Get.back();
                              global.showOnlyLoaderDialog(context);
                              await bottomNavigationController.getAstrologerList(
                                  skills: skillController.skillFilterList,
                                  gender: filtterTabController.genderFilterList,
                                  language: languageController.languageFilterList,
                                  isLazyLoading: false);
                              global.hideLoader();

                              reportController.groupValue = 0;
                              print('done');
                              reportController.update();
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )),
                        Expanded(child: GetBuilder<SkillController>(
                          builder: (controller) {
                            return SizedBox(
                              width: 80,
                              height: 55,
                              child: TextButton(
                                onPressed: () async {
                                  skillController.skillFilterList = [];
                                  filtterTabController.genderFilterList = [];
                                  languageController.languageFilterList = [];
                                  reportController.sortingFilter = null;
                                  for (var i = 0; i < skillController.skillList.length; i++) {
                                    if (skillController.skillList[i].isSelected == true) {
                                      skillController.skillFilterList.add(skillController.skillList[i].id!);
                                      skillController.update();
                                    }
                                  }
                                  for (var i = 0; i < filtterTabController.gender.length; i++) {
                                    if (filtterTabController.gender[i].isCheck == true) {
                                      filtterTabController.genderFilterList.add(filtterTabController.gender[i].name);
                                      filtterTabController.update();
                                    }
                                  }
                                  for (var i = 0; i < languageController.languageList.length; i++) {
                                    if (languageController.languageList[i].isSelected == true) {
                                      languageController.languageFilterList.add(languageController.languageList[i].id!);
                                      languageController.update();
                                    }
                                  }
                                  for (var i = 0; i < reportController.sorting.length; i++) {
                                    if (reportController.groupValue == reportController.sorting[i].id) {
                                      reportController.sortingFilter = reportController.sorting[i].value;
                                      reportController.update();
                                    }
                                  }
                                  Get.back();
                                  bottomNavigationController.astrologerList = [];
                                  bottomNavigationController.astrologerList.clear();
                                  bottomNavigationController.isAllDataLoaded = false;
                                  bottomNavigationController.applyFilter = true;
                                  bottomNavigationController.skillFilterList = skillController.skillFilterList;
                                  bottomNavigationController.genderFilterList = filtterTabController.genderFilterList;
                                  bottomNavigationController.languageFilter = languageController.languageFilterList;
                                  bottomNavigationController.sortingFilter = reportController.sortingFilter;
                                  bottomNavigationController.update();
                                  global.showOnlyLoaderDialog(context);
                                  await bottomNavigationController.getAstrologerList(
                                      skills: skillController.skillFilterList,
                                      gender: filtterTabController.genderFilterList,
                                      language: languageController.languageFilterList,
                                      sortBy: reportController.sortingFilter,
                                      isLazyLoading: false);
                                  global.hideLoader();

                                  skillController.addFilter(
                                      catId: cController.categoryList[cController.isSelected].id,
                                      skills: skillController.skillFilterList,
                                      language: languageController.languageFilterList,
                                      gender: filtterTabController.genderFilterList,
                                      sortBy: reportController.sortingFilter);
                                },
                                child: Text('Apply'),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                                  backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }
}

class TabViewWidget extends StatelessWidget {
  final List astrologerList;
  final ChatController chatController = ChatController();
  WalletController walletController = Get.find<WalletController>();
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  TabViewWidget({
    required this.astrologerList,
    Key? key,
  }) : super(key: key);

  ScrollController chatScrollController = ScrollController();

  void paginateTask() {
    chatScrollController.addListener(() async {
      if (chatScrollController.position.pixels == chatScrollController.position.maxScrollExtent &&
          !bottomNavigationController.isAllDataLoaded) {
        bottomNavigationController.isMoreDataAvailable = true;
        bottomNavigationController.update();
        if (bottomNavigationController.selectedCatId == null || bottomNavigationController.selectedCatId! == 0) {
          if (bottomNavigationController.isChatAstroDataLoadedOnce == false) {
            bottomNavigationController.isChatAstroDataLoadedOnce = true;
            bottomNavigationController.update();
            await bottomNavigationController.getAstrologerList(
                skills: bottomNavigationController.skillFilterList,
                gender: bottomNavigationController.genderFilterList,
                language: bottomNavigationController.languageFilter,
                sortBy: bottomNavigationController.sortingFilter,
                isLazyLoading: true);
            bottomNavigationController.isChatAstroDataLoadedOnce = false;
            bottomNavigationController.update();
          }
        } else {
          bottomNavigationController.astrologerList = [];
          bottomNavigationController.astrologerList.clear();
          bottomNavigationController.isAllDataLoaded = false;
          bottomNavigationController.update();
          await bottomNavigationController.astroCat(id: bottomNavigationController.selectedCatId!, isLazyLoading: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    paginateTask();
    return ListView.builder(
      itemCount:astrologerList.length,
      controller: chatScrollController,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        print(astrologerList[index].isFreeAvailable);
        print("💕💕💕");
        return InkWell(
          onTap: () async {
            Get.find<ReviewController>().getReviewData(astrologerList[index].id);
            global.showOnlyLoaderDialog(context);
            await bottomNavigationController.getAstrologerbyId(astrologerList[index].id);
            global.hideLoader();
            Get.to(() => AstrologerProfile(
                  index: index,
                ));
          },
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      height: 75,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        // border: Border.all(
                                        //     color: Get.theme.primaryColor),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            height: 75,
                                            width: 85,
                                            fit: BoxFit.cover,
                                            imageUrl: '${global.imgBaseurl}${astrologerList[index].profileImage}',
                                            placeholder: (context, url) =>
                                                const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) => Image.asset(
                                              Images.deafultUser,
                                              fit: BoxFit.cover,
                                              height: 50,
                                              width: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //     right: 0,
                                  //     top: 2,
                                  //     child:)
                                ],
                              ),
                              RatingBar.builder(
                                initialRating: 0,
                                itemCount: 5,
                                allowHalfRating: false,
                                itemSize: 15,
                                ignoreGestures: true,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Get.theme.primaryColor,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              astrologerList[index].totalOrder == 0 || astrologerList[index].totalOrder == null
                                  ? SizedBox()
                                  : Text(
                                      '${astrologerList[index].totalOrder} orders',
                                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 9,
                                      ),
                                    )
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    astrologerList[index].name,
                                  ),
                                  astrologerList[index].allSkill == ""
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.skateboarding_outlined,
                                              color: Colors.grey[600],
                                              size: 15,
                                            ),
                                            Container(
                                              width: Get.width * 0.58,
                                              child: Text(
                                                astrologerList[index].allSkill,
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  astrologerList[index].languageKnown == ""
                                      ? const SizedBox()
                                      : Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.language,
                                              color: Colors.grey[600],
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.58,
                                              child: Text(
                                                astrologerList[index].languageKnown,
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.perm_contact_cal_outlined,
                                        color: Colors.grey[600],
                                        size: 15,
                                      ),
                                      Text(
                                        'Experience : ${astrologerList[index].experienceInYears} Years',
                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      // astrologerList[index].isFreeAvailable == true
                                      //     ? Text(
                                      //         'first call is free',
                                      //         style: Get.theme.textTheme.subtitle1!.copyWith(
                                      //           fontSize: 12,
                                      //           fontWeight: FontWeight.w500,
                                      //           letterSpacing: 0,
                                      //           color: Color.fromARGB(255, 167, 1, 1),
                                      //         ),
                                      //       )
                                      //     : const SizedBox(),
                                      // SizedBox(
                                      //   width: astrologerList[index].isFreeAvailable == true ? 10 : 0,
                                      // ),
                                      Text(
                                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astrologerList[index].charge}/min',
                                        style: Get.theme.textTheme.subtitle1!.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0,
                                          // decoration: astrologerList[index].isFreeAvailable == true
                                          //     ? TextDecoration.lineThrough
                                          //     : null,
                                          color:Color.fromARGB(255, 167, 1, 1),
                                        ),
                                      ),
                                      astrologerList[index].chatStatus == "Online"
                                          ? Icon(
                                              Icons.circle,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          : Icon(
                                              Icons.circle,
                                              color: Colors.red,
                                              size: 20,
                                            )
                                      // astrologerList[index].chatStatus ==
                                      //         "Wait Time"
                                      //     ? Text(
                                      //         astrologerList[index]
                                      //                     .chatWaitTime!
                                      //                     .difference(
                                      //                         DateTime
                                      //                             .now())
                                      //                     .inMinutes >
                                      //                 0
                                      //             ? "Wait till - ${astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes} min"
                                      //             : "Wait till",
                                      //         style: TextStyle(
                                      //             color: Colors.red,
                                      //             fontSize: 09),
                                      //       )
                                      //     : SizedBox()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.verified,
                            color: Color.fromARGB(255, 21, 123, 17),
                          )
                          //     Column(
                          //       children: [
                          //  ,

                          //       ],
                          //     )
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          buttonWidget('Cat', Images.chatSmall, () async {
                            bool isLogin = await global.isLogin();
                            if (isLogin) {

                              log("=====================>available bilance${ astrologerList[index].charge * 5 <=
                                    global.splashController.currentUser!.walletAmount}");
                              if (global.user.name == "") {
                                global.showOnlyLoaderDialog(context);
                                await global.splashController.getCurrentUserData();
                                global.hideLoader();
                                Get.to(() => EditUserProfile());
                              }
                              else {
                                if (astrologerList[index].charge * 5 <= global.splashController.currentUser!.walletAmount)
                                {

                                  await bottomNavigationController.checkAlreadyInReq(astrologerList[index].id);
                                  if (bottomNavigationController.isUserAlreadyInChatReq == false) {
                                    if (astrologerList[index].chatStatus == "Online" ||
                                        astrologerList[index].chatStatus == "Wait Time") {
                                      global.showOnlyLoaderDialog(context);

                                      if (astrologerList[index].chatWaitTime != null) {
                                        if (astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes <
                                            0) {
                                          await bottomNavigationController.changeOfflineStatus(
                                              astrologerList[index].id, "Online");
                                        }
                                      }
                                      log("   id =====================>${astrologerList[index].id}  name==============>  ${astrologerList[index].name}");
                                      // astrologerList[index].isFreeAvailable == true? await Get.to(() =>FreeChatScreen(
                                      astrologerList[index].isFreeAvailable == true? await Get.to(() =>FreeChatScreen(
                                        astrologerId: astrologerList[index].id,
                                        chatId: 1,
                                        astrologerName: astrologerList[index].name,
                                        fireBasechatId: "1",
                                        flagId: 1,
                                        profileImage: astrologerList[index].profileImage,
                                        fcmToken: "1",
                                        balance:(astrologerList[index].charge * 5).toString(),
                                      )):
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>FreeChatScreen())):
                                      await Get.to(() => CallIntakeFormScreen(
                                            type: "Chat",
                                            astrologerId: astrologerList[index].id,
                                            astrologerName: astrologerList[index].name,
                                            astrologerProfile: astrologerList[index].profileImage,
                                            isFreeAvailable: astrologerList[index].isFreeAvailable,
                                          )
                                      );
                                      global.hideLoader();
                                    } else if (astrologerList[index].chatStatus == "Offline") {
                                      bottomNavigationController.dialogForJoinInWaitListForListPageOnly(
                                        context,
                                        astrologerList[index].name,
                                        true,
                                        astrologerList[index].id,
                                        astrologerList[index].profileImage,
                                        astrologerList[index].charge,
                                        astrologerList[index].isFreeAvailable,
                                      );
                                    }
                                  } else {
                                    bottomNavigationController.dialogForNotCreatingSession(context);
                                  }
                                } else {
                                  global.showOnlyLoaderDialog(context);
                                  await walletController.getAmount();
                                  global.hideLoader();
                                  openBottomSheetRechrage(context, (astrologerList[index].charge * 5).toString(),
                                      astrologerList[index].name);
                                }
                              }
                            }
                          }, false),
                          buttonWidget('Call', Images.callSmall, () async {
                            bool isLogin = await global.isLogin();
                            if (isLogin) {
                              print('charge${global.splashController.currentUser!.walletAmount! * 5}');
                              if (astrologerList[index].charge * 5 <=
                                      global.splashController.currentUser!.walletAmount!
                                  //      ||
                                  // astrologerList[index].isFreeAvailable == true
                                  ) {
                                await bottomNavigationController.checkAlreadyInReqForCall(astrologerList[index].id);
                                if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                                  if (astrologerList[index].callStatus == "Online" ||
                                      astrologerList[index].callStatus == "Wait Time") {
                                    global.showOnlyLoaderDialog(context);
                                    if (astrologerList[index].callWaitTime != null) {
                                      if (astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes <
                                          0) {
                                        await bottomNavigationController.changeOfflineCallStatus(
                                            astrologerList[index].id, "Online");
                                      }
                                    }

                                    await Get.to(() => CallIntakeFormScreen(
                                          astrologerProfile: astrologerList[index].profileImage,
                                          type: "Call",
                                          astrologerId: astrologerList[index].id,
                                          astrologerName: astrologerList[index].name,
                                          isFreeAvailable: astrologerList[index].isFreeAvailable,
                                        ));

                                    global.hideLoader();
                                  } else if (astrologerList[index].callStatus == "Offline") {
                                    bottomNavigationController.dialogForJoinInWaitListForListPageOnly(
                                      context,
                                      astrologerList[index].name,
                                      false,
                                      astrologerList[index].id,
                                      astrologerList[index].profileImage,
                                      astrologerList[index].charge,
                                      astrologerList[index].isFreeAvailable,
                                    );
                                  }
                                } else {
                                  bottomNavigationController.dialogForNotCreatingSession(context);
                                }
                              } else {
                                global.showOnlyLoaderDialog(context);
                                await walletController.getAmount();
                                global.hideLoader();
                                openBottomSheetRechrage(context, (astrologerList[index].charge * 5).toString(),
                                    '${astrologerList[index].name}');
                              }
                            }
                          }, false),
                          // buttonWidget('VideoCall', Images.videoCall, () async {
                          //       await [Permission.microphone, Permission.camera].request();
                          //   Get.to(()=>VideoCallScreen());
                          //
                          //   //               bool isLogin = await global.isLogin();
                          //   // if (isLogin) {
                          //   //      if (astrologerList[index].charge * 5 <=
                          //   //         global.splashController.currentUser!
                          //   //             .walletAmount! ||
                          //   //     astrologerList[index].isFreeAvailable == true) {
                          //   //          await bottomNavigationController
                          //   //         .checkAlreadyInReqForVideoCall(
                          //   //             astrologerList[index].id);
                          //   //      if (bottomNavigationController.isUserAlreadyInVideoCallReq==false) {
                          //   //             await Get.to(() => CallIntakeFormScreen(
                          //   //         astrologerProfile:
                          //   //             astrologerList[index].profileImage,
                          //   //         type: "VideoCall",
                          //   //         astrologerId: astrologerList[index].id,
                          //   //         astrologerName: astrologerList[index].name,
                          //   //         isFreeAvailable:
                          //   //             astrologerList[index].isFreeAvailable,
                          //   //       ));
                          //   //      } else {
                          //   //       bottomNavigationController
                          //   //           .dialogForNotCreatingSession(context);}
                          //
                          //   // } else {
                          //   //   global.showOnlyLoaderDialog(context);
                          //   //   await walletController.getAmount();
                          //   //   global.hideLoader();
                          //   //   openBottomSheetRechrage(
                          //   //       context,
                          //   //       (astrologerList[index].charge * 5).toString(),
                          //   //       '${astrologerList[index].name}');
                          //   // }
                          //   // }
                          //
                          //   // bool isLogin = await global.isLogin();
                          //   // if (isLogin) {
                          //   //   print('charge${global.splashController.currentUser!.walletAmount! * 5}');
                          //   //   if (astrologerList[index].charge * 5 <= global.splashController.currentUser!.walletAmount! || astrologerList[index].isFreeAvailable == true) {
                          //   //     await bottomNavigationController.checkAlreadyInReqForCall(astrologerList[index].id);
                          //   //     if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                          //   //       if (astrologerList[index].callStatus == "Online" || astrologerList[index].callStatus == "Wait Time") {
                          //   //         global.showOnlyLoaderDialog(context);
                          //   //         if (astrologerList[index].callWaitTime != null) {
                          //   //           if (astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes < 0) {
                          //   //             await bottomNavigationController.changeOfflineCallStatus(astrologerList[index].id, "Online");
                          //   //           }
                          //   //         }
                          //   //         await Get.to(() => CallIntakeFormScreen(
                          //   //               astrologerProfile: astrologerList[index].profileImage,
                          //   //               type: "Video Call",
                          //   //               astrologerId: astrologerList[index].id,
                          //   //               astrologerName: astrologerList[index].name,
                          //   //               isFreeAvailable: astrologerList[index].isFreeAvailable,
                          //   //             ));
                          //
                          //   //         global.hideLoader();
                          //   //       } else if (astrologerList[index].callStatus == "Offline") {
                          //   //         bottomNavigationController.dialogForJoinInWaitListForListPageOnly(
                          //   //           context,
                          //   //           astrologerList[index].name,
                          //   //           false,
                          //   //           astrologerList[index].id,
                          //   //           astrologerList[index].profileImage,
                          //   //           astrologerList[index].charge,
                          //   //           astrologerList[index].isFreeAvailable,
                          //   //         );
                          //   //       }
                          //   //     } else {
                          //   //       bottomNavigationController.dialogForNotCreatingSession(context);
                          //   //     }
                          //   //   } else {
                          //   //     global.showOnlyLoaderDialog(context);
                          //   //     await walletController.getAmount();
                          //   //     global.hideLoader();
                          //   //     openBottomSheetRechrage(context, (astrologerList[index].charge * 5).toString(), '${astrologerList[index].name}');
                          //   //   }
                          //   // }
                          // }, true)
                        ],
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationController.isMoreDataAvailable == true &&
                      !bottomNavigationController.isAllDataLoaded &&
                      astrologerList.length - 1 == index
                  ? Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : const SizedBox(),
              if (index == astrologerList.length - 1)
                const SizedBox(
                  height: 30,
                )
            ],
          ),
        );
      },
    );
  }

  Widget buttonWidget(String name, String image, callBack, bool isVideo) {
    return InkWell(
      onTap: callBack,
      child: Container(
        height: !isVideo ? 38 : 38,
        width: !isVideo ? 100 : 120,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [
          BoxShadow(offset: Offset(1, 1), color: Colors.black.withOpacity(0.15), blurRadius: 8, spreadRadius: 0)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                image,
                height: 25,
                width: 20,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$name',
              style: Get.theme.primaryTextTheme.labelMedium!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 21, 123, 17)),
            )
          ],
        ),
      ),
    );
  }

  void openBottomSheetRechrage(BuildContext context, String minBalance, String astrologer) {
          Get.bottomSheet(
      Wrap(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.85,
                                  child: minBalance != ''
                                      ? Text(
                                          'Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start conversation with $astrologer ',
                                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red))
                                      : const SizedBox(),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: minBalance == ''
                                        ? const EdgeInsets.only(top: 8)
                                        : const EdgeInsets.only(top: 0),
                                    child: Icon(Icons.close, size: 18),
                                  ),
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                              child: Text('Recharge Now', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(Icons.lightbulb_rounded, color: Get.theme.primaryColor, size: 13),
                                ),
                                Expanded(
                                    child: Text(
                                        'Minimum balance required ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance',
                                        style: TextStyle(fontSize: 12)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              child: GridView.builder(
                  gridDelegate: 
               SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:MediaQuery.of(context).size.width<300?2:3,
                        childAspectRatio: 3 / 3.5,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                  // physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: walletController.rechrage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.delete<RazorPayController>();
                        Get.to(() => PaymentInformationScreen(
                              amount: double.parse(walletController.paymentAmount[index].amount.toString()),
                              extraAmount: walletController.paymentAmount[index].amount! *
                                  (walletController.paymentAmount[index].offer! / 100),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Container(
                          // padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 2, color: Colors.black38)],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  gradient: LinearGradient(
                                      transform: GradientRotation(180), colors: [Colors.white, Get.theme.primaryColor]),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                                height: 25,
                                child: Center(
                                  child: Text(
                                    '${walletController.paymentAmount[index].offer}% Extra',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.paymentAmount[index].amount}',
                                    style: Get.textTheme.titleSmall!.copyWith(color: Colors.black, fontSize: 16),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Text(
                                    'Get',
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}  ${walletController.paymentAmount[index].amount! + (walletController.paymentAmount[index].offer! / 100) * int.parse("${walletController.paymentAmount[index].amount}")}',
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }
}
