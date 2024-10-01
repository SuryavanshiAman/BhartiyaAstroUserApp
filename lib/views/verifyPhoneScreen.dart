import 'dart:io';

import 'package:BharatiyAstro/controllers/loginController.dart';
import 'package:BharatiyAstro/views/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../utils/images.dart';

class VerifyPhoneScreen extends StatelessWidget {
  final String phoneNumber;
  final String verificationId;
  VerifyPhoneScreen(
      {Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);
  final LoginController loginController = Get.find<LoginController>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        loginController.maxSecond != 0?Get.snackbar('Wait', 'wait Till Time out'):Get.off(()=>LoginScreen());
        return false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 1,
        //   backgroundColor: Color.fromARGB(255, 245, 235, 235),
        //   title: Text(
        //     'Verify Phone',
        //     style: Get.textTheme.subtitle1,
        //   ),
        //   leading: IconButton(
        //       onPressed: () {
        //         Get.delete<LoginController>(force: true);
        //         Get.back();
        //       },
        //       icon: Icon(
        //         Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
        //         color: Colors.black,
        //       )),
        // ),
        backgroundColor: Color.fromARGB(255, 245, 235, 235),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: Get.height * 0.45,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFF2626),
                            Color.fromRGBO(220, 217, 255, 0.86),
                            Color.fromRGBO(212, 199, 199, 0.00),
                          ],
                          stops: [0.0, 0.4699, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: Get.width,
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: Image.asset(
                            'assets/images/splash.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            border:
                                Border.all(width: 0, color: Get.theme.primaryColor),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        // child: Stack(
                        //   clipBehavior: Clip.none,
                        //   children: [
                        //     Positioned(
                        //       top: -20,
                        //       left: 0,
                        //       right: 0,
                        //       child: Card(
                        //         elevation: 0,
                        //         margin: const EdgeInsets.symmetric(
                        //             horizontal: 35),
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius:
                        //                 BorderRadius.circular(20.0)),
                        //         child: Container(
                        //           height: 40,
                        //           decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(20),
                        //               gradient: LinearGradient(stops: [
                        //                 0.6,
                        //                 1.0
                        //               ], colors: [
                        //                 Color.fromARGB(255, 3, 5, 40),
                        //                 Color.fromARGB(255, 144, 188, 238)
                        //               ])),
                        //           child: Padding(
                        //             padding:
                        //                 EdgeInsets.fromLTRB(30, 8, 30, 8),
                        //             child: Text(
                        //                 'First Chat With Astrologer is FREE!',
                        //                 style: Get.textTheme.subtitle1!
                        //                     .copyWith(
                        //                         color: Colors.white,
                        //                         fontWeight: FontWeight.w600,
                        //                         fontSize: 13),
                        //                 textAlign: TextAlign.center),
                        //           ),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ))
                ],
              ),
              Container(
                width: Get.width,
                height: Get.height * 0.55,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OTP Verification',
                        style: Get.textTheme.headlineMedium!
                            .copyWith(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        'An 6 digit code has been sent to your number',
                        style: Get.textTheme.titleMedium!
                            .copyWith(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                                      GetBuilder<LoginController>(builder: (c) {
                      return SizedBox(
                          child: loginController.maxSecond != 0
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '00:${loginController.maxSecond} s',
                                      style: TextStyle(color: Colors.white,
                                      fontSize: 20,
                                       fontWeight: FontWeight.w500),
                                    )
                                  ],
                                )
                              :
                              SizedBox()
                           
                                );
        
                    }),
                    SizedBox(
                      height: 15,
                    ),
                      SizedBox(
                        height: 55,
                        child: OtpTextField(
                        numberOfFields: 6,
                        showFieldAsBox: true,
                        onCodeChanged: (value) {},
                        onSubmit: (value) {
                          loginController.smsCode = value;
                          loginController.update();
                          print('smscode from : ${loginController.smsCode}');
                        },
                        filled: true,
                        fillColor: Colors.white,
                        fieldWidth: 48,
                        borderColor: Colors.transparent,
                        enabledBorderColor: Colors.transparent,
                        focusedBorderColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        margin: EdgeInsets.only(right: 4),
                                      ),
                      ),SizedBox(
                        height: 15,
                      ),
                                      SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: loginController.smsCode,
                          );
                          print('validation id${loginController.verificationId}');
                          print('smscode ${loginController.smsCode}');
                          global.showOnlyLoaderDialog(context);
                          await auth.signInWithCredential(credential);
                          await loginController.loginAndSignupUser(int.parse(phoneNumber));
                        } catch (e) {
                          global.hideLoader();
    
                          global.showToast(
                            message: "OTP INVALID",
                            textColor: Colors.white,
                            bgColor: Colors.red,
                          );
                          print("Exception " + e.toString());
                        }
                      },
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 255, 185, 0)
                        ),
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                                          GetBuilder<LoginController>(builder: (c) {
                      return SizedBox(
                          child: loginController.maxSecond != 0
                              ? SizedBox()
                              :
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text(
                                      
                                      
                                    //   'If you did not receive a code!',
                                    // style: Get.theme.textTheme.titleSmall!.copyWith(
                                    //   color: Colors.white
                                    // ),
                                    // ),
                                     InkWell(
                                      onTap: (){
                                        loginController.maxSecond = 60;
                                        loginController.second = 0;
                                        loginController.update();
                                        // loginController.timer();
                                        loginController.phoneController.text = phoneNumber;
                                        loginController.verifyOTP();
                                      },
                                      child: Text(
                                      
                                      
                                      'Resend',
                                    style: Get.theme.textTheme.titleSmall!.copyWith(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight:FontWeight.bold
                                    
                                    ),
                                    ) ,
                                     ),
                                     
                                  ],
                                ),
                              )
                           
                                );
        
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: Colors.white
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_android,color: Colors.white,size: 25,),
                          SizedBox(
                            width: 30,
                          ),
                          Text('Change Mobile Number',
                          style: Get.textTheme.titleMedium!.copyWith(
                            color: Colors.white
                          ),
                          )
                        ],
                      ),
                    ),
                    )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
