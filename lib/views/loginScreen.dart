import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/controllers/loginController.dart';
import 'package:BharatiyAstro/controllers/search_controller.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:BharatiyAstro/views/settings/privacyPolicyScreen.dart';
import 'package:BharatiyAstro/views/settings/termsAndConditionScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.find<LoginController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.back();
        Get.back();
        print('call on will pop');
        SystemNavigator.pop();
        //exit(0);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Get.theme.primaryColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: Get.height * 0.45,
                      child: Container(
                        decoration:
                            BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage(Images.loginBg))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.find<SearchController>().serachTextController.clear();
                                    Get.find<SearchController>().searchText = '';
                                    homeController.myOrders.clear();
                                    BottomNavigationController bottomNavigationController =
                                        Get.find<BottomNavigationController>();
                                    bottomNavigationController.setIndex(0, 0);
                                    Get.off(() => BottomNavigationBarScreen(index: 0));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      "Skip",
                                      textAlign: TextAlign.end,
                                      style: Get.textTheme.subtitle1!
                                          .copyWith(color: Colors.white, decoration: TextDecoration.underline),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.16,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                width: Get.width,
                                height: 60,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                child: Image.asset(
                                  'assets/images/splash.png',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              border: Border.all(width: 0, color: Get.theme.primaryColor),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -20,
                                left: 0,
                                right: 0,
                                child: Card(
                                  elevation: 0,
                                  margin: const EdgeInsets.symmetric(horizontal: 35),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(stops: [
                                          0.6,
                                          1.0
                                        ], colors: [
                                          Color.fromARGB(255, 3, 5, 40),
                                          Color.fromARGB(255, 144, 188, 238)
                                        ])), 
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                                      child: Text(' Call And Chat With Astrologer!',
                                          style: Get.textTheme.subtitle1!
                                              .copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                Container(
                  width: Get.width,
                  height: Get.height * 0.35,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi Welcome!',
                          style: Get.textTheme.headlineMedium!.copyWith(fontSize: 24, color: Colors.white),
                        ),
                        //  SizedBox(
                        //   height: 10,
                        //  ),
                        Text(
                          'Submit your Mobile number',
                          style: Get.textTheme.titleMedium!.copyWith(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'Log in or Sign up',
                                style: Get.textTheme.titleMedium!.copyWith(fontSize: 12, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        GetBuilder<LoginController>(builder: (loginController) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        child: FutureBuilder(
                                            future: global.translatedText("Phone Number"),
                                            builder: (context, snapshot) {
                                              return IntlPhoneField(
                                                autovalidateMode: null,
                                                showDropdownIcon: false,
                                                controller: loginController.phoneController,
                                                decoration: InputDecoration(
                                                    //labelText: 'Phone Number',
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                    hintText: snapshot.data ?? 'Phone Number',
                                                    border: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    disabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    errorBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    errorText: null,
                                                    counterText: ''),
                                                initialCountryCode: 'IN',
                                                onChanged: (phone) {
                                                  //print(phone.completeNumber);
                                                  loginController.updateCountryCode(phone.countryCode);
                                                },
                                              );
                                            })),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool isValid = loginController.validedPhone();
                                  if (isValid) {
                                    global.showOnlyLoaderDialog(context);
                                    await loginController.verifyOTP();
                                  } else {
                                    global.showToast(
                                      message: loginController.errorText!,
                                      textColor: global.textColor,
                                      bgColor: global.toastBackGoundColor,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: Container(
                                    height: 45,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 185, 0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'SEND OTP',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                        // Image.asset(
                                        //   'assets/images/arrow_left.png',
                                        //   color: Colors.black,
                                        //   width: 20,
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: Get.height * 0.11,
            child: Container(
              decoration: BoxDecoration(color: Get.theme.primaryColor),
              width: Get.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 15,                    ),
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
                        style: Get.textTheme.labelLarge!.copyWith(fontSize: 17, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          // onTap: () {
                          //   _launchURL();
                          // },
                          child: Text(
                        'Developed by:Kriscent Techo Hub',
                        style: Get.textTheme.labelLarge!.copyWith(color: Colors.black),
                      ))
                    ],
                  ),

                  //    Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //       InkWell(
                  //         onTap: () {
                  //           _launchURL();
                  //         },
                  //         child:Text("\u00a9 Yassh Consultancy Services",
                  //         style: Get.textTheme.labelLarge!.copyWith(
                  //           color: Colors.white
                  //         ),
                  //         ))
                  //   ],
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'By signing up, you agree to our',
                        style: Get.theme.textTheme.titleSmall!.copyWith(color: Colors.white, fontSize: 11),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => TermsAndConditionScreen());
                        },
                        child: Text(
                          'Terms of Use ',
                          style: Get.theme.textTheme.titleSmall!.copyWith(color: Colors.black, fontSize: 11),
                        ),
                      ),
                      Text(
                        'and ',
                        style: Get.theme.textTheme.titleSmall!.copyWith(color: Colors.white, fontSize: 11),
                      ),
                      InkWell(
                        onTap: () => {Get.to(() => PrivacyPolicyScreen())},
                        child: Text(
                          'Privacy Policy',
                          style: Get.theme.textTheme.titleSmall!.copyWith(color: Colors.black, fontSize: 11),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://www.kriscent.in/'; // URL you want to launch
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
