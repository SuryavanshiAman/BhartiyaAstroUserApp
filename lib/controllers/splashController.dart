import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';

import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/model/current_user_model.dart';
import 'package:BharatiyAstro/model/systemFlagModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:BharatiyAstro/views/loginScreen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:store_redirect/store_redirect.dart';

import '../views/astrologerProfile/astrologerProfile.dart';
import '../views/bottomNavigationBarScreen.dart';
import '../views/call/incoming_call_request.dart';
import '../views/chat/incoming_chat_request.dart';
import 'package:http/http.dart' as http;

class SplashController extends GetxController {
  APIHelper apiHelper = APIHelper();
  CurrentUserModel? currentUser;
  CurrentUserModel? currentUserPayment;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? appShareLinkForLiveSreaming;
  String? version;
  double? totalGst;
  var syatemFlag = <SystemFlag>[];
  String appName = "";
  String currentLanguageCode = 'en';
  RxBool isAppversionChanged = false.obs;

  // void openPopup() {
  //   Get.defaultDialog(
  //     title: "Update App",
  //     content: Text("Your App require update, please update on PlayStore"),
  //     actions: [
  //       ElevatedButton(
  //         onPressed: () {
  //           if (Platform.isAndroid) {
  //             StoreRedirect.redirect(
  //               androidAppId: "com.bharatiyastro.userapp",
  //             );
  //           }
  //           exit(0); // Close the popup
  //         },
  //         child: Text("Close"),
  //       ),
  //     ],
  //   );
  // }

  @override
  void onInit() {
    inIt();

    print("🎶🎶🎶🎶");
    super.onInit();
  }

  inIt() async {
    await getSystemFlag();
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      update();
    });
    appName =
        global.getSystemFlagValueForLogin(global.systemFlagNameList.appName);
    global.sp = await SharedPreferences.getInstance();
    currentLanguageCode = global.sp!.getString('currentLanguage') ?? 'en';
    update();
    global.getAppVersion();
    Timer(const Duration(seconds: 0), () async {
      try {
        bool isLogin = await global.isLogin();
        if (isLogin) {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          await global.checkBody().then((result) async {
            if (result) {
              await apiHelper.validateSession().then((result) async {
                if (result.status == "200") {
                  print("data aya");
                  currentUser = result.recordList;
                  global.saveUser(currentUser!);
                  global.user = currentUser!;
                  await getCurrentUserData();
                  await global.getCurrentUser();
                 
                   BottomNavigationController bottomNavigationController =
                        Get.find<BottomNavigationController>();
                    bottomNavigationController.setIndex(0, 0);

                    Get.off(() => BottomNavigationBarScreen(index: 0));
                } else {
                  print("data nahiaya");
                  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                    version = packageInfo.version;
                    update();
                  });
                  HomeController homeController = Get.find<HomeController>();
                  homeController.myOrders.clear();
                  Get.off(() => LoginScreen());
                }
              });
            }
          });
        } else {
          print("data nahiaya");
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          Get.off(() => LoginScreen());
        }
      } catch (e) {
        print('Exception in _inIt():' + e.toString());
      }
    });
    // if (version !=
    //     global.getSystemFlagValueForLogin(
    //         global.systemFlagNameList.UserAppVersion)) {
    //   isAppversionChanged.value = true;
    //   print(
    //       "$version  ${global.getSystemFlagValueForLogin(global.systemFlagNameList.UserAppVersion)}");
    //   print('app versdion changed');
    //   openPopup();
    // } else {

    // }
  }

  // Future<void> createAstrologerShareLink() async {
  //   try {
  //     global.showOnlyLoaderDialog(Get.context);
  //     String appShareLink;
  //     final DynamicLinkParameters parameters = DynamicLinkParameters(
  //       uriPrefix: 'https://BharatiyAstroupdated.page.link',
  //       link: Uri.parse("https://BharatiyAstroupdated.page.link/userProfile?screen=astrologerShare"),
  //       androidParameters: AndroidParameters(
  //         packageName: 'com.BharatiyAstro.app',
  //         minimumVersion: 1,
  //       ),
  //     );
  //     Uri url;
  //     final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
  //     url = shortLink.shortUrl;
  //     appShareLink = url.toString();
  //     appShareLinkForLiveSreaming = appShareLink;
  //     update();
  //     global.hideLoader();
  //     await FlutterShare.share(
  //       title: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
  //       text: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
  //       linkUrl: '$appShareLinkForLiveSreaming',
  //     );
  //   } catch (e) {
  //     print("Exception - global.dart - referAndEarn():" + e.toString());
  //   }
  // }

  Future<String?> getCurrentUserData() async {
    try {
      bool result = await global.checkBody();
      if (result) {
        var apiResult = await apiHelper.getCurrentUser();
        if (apiResult.status == "200") {
          try {
            currentUser = apiResult.recordList;
            print("freeChat: ${currentUser!.freeChat}");
            global.saveUser(currentUser!);
            global.user = currentUser!;
            update(); // notifies the UI
            return currentUser!.freeChat.toString();
          } catch (e) {
            print("Error parsing user data: $e");
          }
        }
      }
    } catch (e) {
      print('Exception in getCurrentUserData(): $e');
    }

    update(); // still call update even if something goes wrong
    return null; // return null if the function fails
  }


  // Future<String?> getCurrentUserData() async {
  //   try {
  //     await global.checkBody().then((result) async {
  //       if (result) {
  //         // global.sp = await SharedPreferences.getInstance();
  //          apiHelper.getCurrentUser().then((result) {
  //           if (result.status == "200") {
  //             try{
  //               currentUser = result.recordList;
  //               print("dsdsjkdjkdjk: ${currentUser!.freeChat}");
  //               global.saveUser(currentUser!);
  //               global.user = currentUser!;
  //               update();
  //               return currentUser!.freeChat.toString();
  //             }catch(e){
  //               print("err: $e");
  //             }
  //           } else {}
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     print('Exception in getCurrentUserData():' + e.toString());
  //   }
  //   update();
  // }

  getSystemFlag() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.sp = await SharedPreferences.getInstance();
          await apiHelper.getSystemFlag().then((result) {
            if (result.status == "200") {
              syatemFlag = result.recordList;
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getSystemFlag():' + e.toString());
    }
  }
}
