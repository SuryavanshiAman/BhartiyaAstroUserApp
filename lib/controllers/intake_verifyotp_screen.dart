import 'dart:io';

import 'package:BharatiyAstro/controllers/IntakeController.dart';
import 'package:BharatiyAstro/controllers/loginController.dart';
import 'package:BharatiyAstro/widget/textFieldWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class IntakeVerifyOTPScreen extends StatelessWidget {
  final String phoneNumber;
  final String verificationId;
  IntakeVerifyOTPScreen({Key? key, required this.phoneNumber, required this.verificationId}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
        title: Text(
          'Verify Phone',
          style: Get.textTheme.subtitle1,
        ),
        leading: IconButton(
            onPressed: () {
              Get.delete<LoginController>(force: true);
              Get.back();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      backgroundColor: Color.fromARGB(255, 245, 235, 235),
      body: GetBuilder<IntakeController>(builder: (intakeController) {
        return Center(
          child: SizedBox(
            width: Get.width - Get.width * 0.1,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  Text(
                    'OTP Send to 91-$phoneNumber',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFieldWidget(
                    controller: intakeController.verifyPhoneController,
                    hintText: 'Enter the 6 digit OTP here',
                    maxlen: 6,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: Get.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (intakeController.verifyPhoneController.text.length != 6) {
                            global.showToast(
                              message: 'Please Enter valid OTP',
                              textColor: global.textColor,
                              bgColor: global.toastBackGoundColor,
                            );
                          } else {
                            print('valid OTP');
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: intakeController.verifyPhoneController.text,
                            );
                            print('validation id$verificationId');
                            print('smscode ${intakeController.verifyPhoneController.text}');
                            global.showOnlyLoaderDialog(context);
                            await auth.signInWithCredential(credential);
                            global.hideLoader();
                            intakeController.isVarified = true;
                            intakeController.update();
                            Get.back();
                          }
                        } catch (e) {
                          global.hideLoader();

                          global.showToast(
                            message: 'OTP INVALID',
                            textColor: Colors.white,
                            bgColor: Colors.red,
                          );
                          print("Exception " + e.toString());
                        }
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<LoginController>(builder: (c) {
                    return SizedBox(
                        child: intakeController.maxSecond != 0
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Resend OTP Available in ${intakeController.maxSecond} s',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                  )
                                ],
                              )
                            : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  'Resend OTP Available',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        intakeController.maxSecond = 60;
                                        intakeController.second = 0;
                                        intakeController.update();
                                        intakeController.timer();
                                        intakeController.phoneController.text = phoneNumber;
                                        intakeController.verifyOTP();
                                      },
                                      child: Text(
                                        'Resend OTP on SMS',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(EdgeInsets.only(left: 25, right: 25)),
                                        backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                )
                              ]));
                  })
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
