// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:BharatiyAstro/controllers/advancedPanchangController.dart';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/controllers/counsellorController.dart';
import 'package:BharatiyAstro/controllers/follow_astrologer_controller.dart';
import 'package:BharatiyAstro/controllers/history_controller.dart';
import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/controllers/themeController.dart';
import 'package:BharatiyAstro/views/freeServicesScreen.dart';
import 'package:BharatiyAstro/views/getReportScreen.dart';
import 'package:BharatiyAstro/views/loginScreen.dart';
import 'package:BharatiyAstro/views/myFollowingScreen.dart';
import 'package:BharatiyAstro/views/profile/editUserProfileScreen.dart';
import 'package:BharatiyAstro/views/settings/colorPicker.dart';
import 'package:BharatiyAstro/views/settings/settingsScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
// import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/chatController.dart';
import '../controllers/settings_controller.dart';
import '../utils/images.dart';
import '../views/contact us/contact_us.dart';
import '../views/counsellor/counsellorScreen.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);
  final SplashController splashController = Get.find<SplashController>();
  CallController callController = Get.put(CallController());
  PanchangController panchangController = Get.find<PanchangController>();
  HistoryController historyController = Get.find<HistoryController>();
  final BottomNavigationController bottomNavigationController =
      Get.find<BottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: GetBuilder<SplashController>(builder: (splashController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 38.0, left: 20, bottom: 10),
                child: GestureDetector(
                  onTap: () async {
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      global.showOnlyLoaderDialog(context);
                      await splashController.getCurrentUserData();
                      global.hideLoader();
                      Get.to(() => EditUserProfile());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white),
                        child: Container(
                          height: 140,
                          width: 140,
                          alignment: Alignment.center,
                          child: splashController.currentUser?.profile == ""
                              ? CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    Images.deafultUser,
                                    fit: BoxFit.fill,
                                    height: 50,
                                  ))
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${global.imgBaseurl}${splashController.currentUser?.profile}",
                                  imageBuilder: (context, imageProvider) {
                                    return CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          "${global.imgBaseurl}${splashController.currentUser?.profile}"),
                                    );
                                  },
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) {
                                    return CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          Images.deafultUser,
                                          fit: BoxFit.fill,
                                          height: 50,
                                        ));
                                  },
                                ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                splashController.currentUser == null
                                    ? "user"
                                    : splashController.currentUser!.name == ""
                                        ? "User"
                                        : "${splashController.currentUser!.name}",
                                style: Get.textTheme.bodyLarge!
                                    .copyWith(fontSize: 18),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.edit,
                                size: 15,
                              )
                            ],
                          ),
                          splashController.currentUser == null
                              ? const SizedBox()
                              : Text(
                                  '${splashController.currentUser!.countryCode}-${splashController.currentUser!.contactNo}')
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                ),
              ),

              GetBuilder<BottomNavigationController>(builder: (navController) {
                return GestureDetector(
                    onTap: () async {
                      global.showOnlyLoaderDialog(context);
                      navController.astrologerList = [];
                      navController.astrologerList.clear();
                      navController.isAllDataLoaded = false;
                      navController.update();
                      await navController.getAstrologerList(
                          isLazyLoading: false);
                      global.hideLoader();
                      navController.setBottomIndex(1, 0);
                    },
                    child: _drawerItem(
                        icon: Icons.chat, title: 'Chat With Astrologers'));
              }),
              GetBuilder<BottomNavigationController>(builder: (navController) {
                return GestureDetector(
                    onTap: () async {
                      global.showOnlyLoaderDialog(context);
                      navController.astrologerList = [];
                      navController.astrologerList.clear();
                      navController.isAllDataLoaded = false;
                      navController.update();
                      await navController.getAstrologerList(
                          isLazyLoading: false);
                      global.hideLoader();
                      navController.setBottomIndex(3, 0);
                    },
                    child: _drawerItem(
                        icon: Icons.call, title: 'Call Astrologers'));
              }),
              GestureDetector(
                  onTap: () async {
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      final FollowAstrologerController
                          followAstrologerController =
                          Get.find<FollowAstrologerController>();
                      followAstrologerController.followedAstrologer.clear();
                      followAstrologerController.isAllDataLoaded = false;
                      global.showOnlyLoaderDialog(context);
                      await followAstrologerController
                          .getFollowedAstrologerList(false);
                      global.hideLoader();
                      Get.to(() => MyFollowingScreen());
                    }
                  },
                  child: _drawerItem(
                      icon: Icons.verified_user, title: 'My Following')),
              GetBuilder<HomeController>(builder: (homeController) {
                return GestureDetector(
                    onTap: () async {
                      DateTime datePanchang = DateTime.now();
                      int formattedYear =
                          int.parse(DateFormat('yyyy').format(datePanchang));
                      int formattedDay =
                          int.parse(DateFormat('dd').format(datePanchang));
                      int formattedMonth =
                          int.parse(DateFormat('MM').format(datePanchang));
                      int formattedHour =
                          int.parse(DateFormat('HH').format(datePanchang));
                      int formattedMint =
                          int.parse(DateFormat('mm').format(datePanchang));
                      global.showOnlyLoaderDialog(context);
                      await homeController.getBlog();
                      await homeController.getAstrologyVideos();
                      await panchangController.getPanchangDetail(
                          day: formattedDay,
                          hour: formattedHour,
                          min: formattedMint,
                          month: formattedMonth,
                          year: formattedYear);
                      global.hideLoader();
                      Get.to(() => FreeServiceScreen());
                    },
                    child: _drawerItem(
                        icon: Icons.usb_rounded, title: 'Free Services'));
              }),
              // GetBuilder<ThemeController>(builder: (themeController) {
              //   return GestureDetector(
              //       onTap: () async {
              //         Get.to(() => ColorPickerPage());
              //       },
              //       child: _drawerItem(icon: Icons.brightness_2, title: 'Theme'));
              // }),
              // GestureDetector(
              //     onTap: () async {
              //       if (Platform.isAndroid) {
              //         StoreRedirect.redirect(
              //           androidAppId: "com.example.astrologer_app",
              //         );
              //       }
              //     },
              //     child: _drawerItem(
              //         icon: Icons.person, title: 'Sign Up as Astrologer')),
              // global.currentUserId != null
              //     ? GestureDetector(
              //         onTap: () async {
              //           SettingsController settingsController =
              //               Get.find<SettingsController>();
              //           global.showOnlyLoaderDialog(context);
              //           await settingsController.getBlockAstrologerList();
              //           global.hideLoader();
              //           Get.to(() => SettingListScreen());
              //         },
              //         child:
              //             _drawerItem(icon: Icons.settings, title: 'Settings'))
              //     : GestureDetector(
              //         onTap: () {
              //           Get.off(() => LoginScreen());
              //         },
              //         child: _drawerItem(
              //             icon: Icons.arrow_circle_right_outlined,
              //             title: 'Login')),
              GestureDetector(
                  onTap: () async {
                    final BottomNavigationController
                        bottomNavigationController =
                        Get.find<BottomNavigationController>();
                    bottomNavigationController.astrologerList = [];
                    bottomNavigationController.astrologerList.clear();
                    bottomNavigationController.isAllDataLoaded = false;
                    bottomNavigationController.update();
                    global.showOnlyLoaderDialog(context);
                    await bottomNavigationController.getAstrologerList(
                        isLazyLoading: false);
                    global.hideLoader();
                    Get.to(() => GetReportScreen());
                  },
                  child:
                      _drawerItem(icon: Icons.note_alt, title: 'Get Report')),
              // SizedBox(
              //   height: 15,
              // ),

              InkWell(
                onTap: () => Get.to(() => ContactUs(
                      subject: 'Naturopathy',
                    )),
                child: _drawerItem(
                    icon: Icons.queue_play_next, title: 'Naturopathy'),
              ),
              InkWell(
                onTap: () => Get.to(() => ContactUs(
                      subject: 'Legal',
                    )),
                child: _drawerItem(icon: Icons.leaderboard, title: 'Legal'),
              ),
              InkWell(
                onTap: () => Get.to(() => ContactUs(
                      subject: 'Contact Us',
                    )),
                child:
                    _drawerItem(icon: Icons.contact_mail, title: 'Contact Us'),
              ),

              global.currentUserId != null
                  ? GestureDetector(
                      onTap: () async {
                        SettingsController settingsController =
                            Get.find<SettingsController>();
                        global.showOnlyLoaderDialog(context);
                        await settingsController.getBlockAstrologerList();
                        global.hideLoader();
                        Get.to(() => SettingListScreen());
                      },
                      child:
                          _drawerItem(icon: Icons.settings, title: 'Settings'))
                  : GestureDetector(
                      onTap: () {
                        Get.off(() => LoginScreen());
                      },
                      child: _drawerItem(
                          icon: Icons.arrow_circle_right_outlined,
                          title: 'Login')),
              GestureDetector(
                  onTap: () async {
                    if (Platform.isAndroid) {
                      // StoreRedirect.redirect(
                      //   androidAppId: "com.bharatiyastro.astrologer",
                      // );
                    }
                  },
                  child: _drawerItem(
                      icon: Icons.person, title: 'Sign Up as Astrologer')),
              GetBuilder<HomeController>(builder: (homeController) {
                return GestureDetector(
                    onTap: () async {
                      await FlutterShare.share(
                              title:
                                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}',
                              text:
                                  "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to Astrology.You should also try and see your future  https://play.google.com/store/apps/details?id=com.bharatiyastro.userapp")
                          .then((value) {})
                          .catchError((e) {
                        print(e);
                      });
                    },
                    child: _drawerItem(icon: Icons.share, title: 'Share'));
              }),
                  _drawerItem(icon: Icons.info, title: 'Version ${splashController.version}'),
              // _drawerItem(icon: Icons.info, title: 'Version ${}'),
              // Padding(
              //   padding: const EdgeInsets.all(13.0),
              //   child: Row(children: [
              //     Icon(
              //       Icons.info,
              //       color: Get.theme.primaryColor,
              //       size: 25,
              //     ),
              //     SizedBox(
              //       width: 15,
              //     ),
              //     Text(
              //       bottomNavigationController.getAppVersion(),
              //       style: Get.textTheme.bodyText1!
              //           .copyWith(fontWeight: FontWeight.normal, fontSize: 13),
              //     ),
              //   ]),
              // ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Made in 🇮🇳 with ❤'),
                ],
              ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\u00a9 Yassh Consultancy Services",
                    style: Get.textTheme.labelLarge!
                        .copyWith(
                          fontSize: 15,
                          color: Colors.black),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        _launchURL();
                      },
                      child: Text(
                        'Developed by:Kriscent Techo Hub',
                        style: Get.textTheme.labelLarge!
                            .copyWith(color: Colors.black),
                      ))
                ],
              ),
          
              Divider(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        //  global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId);
                        // print(global.getSystemFlagValueForLogin(global.systemFlagNameList.appVersion));
                        _launchSocialMediaAppIfInstalled(
                            global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.facebook));
                      },
                      icon: Icon(
                        FontAwesomeIcons.facebook,
                        size: 22,
                      )),
                  // Spacer(
                  SizedBox(
                    width: 8,
                  ),
                  // ),
                  IconButton(
                      onPressed: () {
                        _launchSocialMediaAppIfInstalled(
                            global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.linkedin));
                      },
                      icon: Icon(
                        FontAwesomeIcons.linkedin,
                        size: 22,
                      )),
                  // Spacer(),
                  IconButton(
                      onPressed: () {
                        _launchSocialMediaAppIfInstalled(
                            global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.instra));
                      },
                      icon: Icon(
                        FontAwesomeIcons.instagram,
                        size: 22,
                      )),
                  // Spacer(),
                  SizedBox(
                    width: 8,
                  ),
                  //   IconButton(onPressed: () {}, icon: Icon(Icons.web)),
                  //   Spacer(),
                  //     IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.pinterest)),
                  // Spacer(),
                  IconButton(
                      onPressed: () {
                        _launchSocialMediaAppIfInstalled(
                            global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.youtube));
                      },
                      icon: Icon(
                        FontAwesomeIcons.youtube,
                        size: 22,
                      )),
                  // Spacer(),
                  SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      onPressed: () {
                        _launchSocialMediaAppIfInstalled(
                            global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.apple));
                      },
                      icon: Icon(
                        FontAwesomeIcons.appStore,
                        size: 22,
                      )),
                  // Spacer(),
                ],
              )
            ],
          );
        }),
      ),
    );
  }

  Future<void> _launchSocialMediaAppIfInstalled(
    String url,
  ) async {
    try {
      bool launched = await launch(url,
          forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url); // Launch web view if app is not installed!
    }
  }

  _launchURL() async {
    const url = 'https://www.kriscent.in/'; // URL you want to launch
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _drawerItem({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Row(children: [
        Icon(
          icon,
          color: Get.theme.primaryColor,
          size: 25,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          title,
          style: Get.textTheme.bodyText1!
              .copyWith(fontWeight: FontWeight.normal, fontSize: 13),
        ),
      ]),
    );
  }
}
