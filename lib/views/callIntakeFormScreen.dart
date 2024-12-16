// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/controllers/IntakeController.dart';
import 'package:BharatiyAstro/controllers/chatController.dart';
import 'package:BharatiyAstro/controllers/razorPayController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:BharatiyAstro/views/placeOfBrithSearchScreen.dart';
import 'package:BharatiyAstro/widget/customBottomButton.dart';
import 'package:BharatiyAstro/widget/textFieldLabelWidget.dart';
import 'package:BharatiyAstro/widget/textFieldWidget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/dropDownController.dart';
import '../utils/date_converter.dart';
import '../widget/drodownWidget.dart';
import 'dart:developer';

class CallIntakeFormScreen extends StatelessWidget {
  final reportType;
  final String astrologerName;
  final int astrologerId;
  final String type;
  final String astrologerProfile;
  final bool? isFreeAvailable;

  CallIntakeFormScreen(
      {Key? key,
      this.reportType,
      this.isFreeAvailable = false,
      required this.astrologerName,
      required this.astrologerId,
      required this.type,
      required this.astrologerProfile})
      : super(key: key);

  RazorPayController razorPay = Get.find<RazorPayController>();
  SplashController splashController = Get.find<SplashController>();
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
  IntakeController callIntakeController = Get.find<IntakeController>();
  CallController callController = Get.find<CallController>();
  ChatController chatController = Get.find<ChatController>();
  // final String text =
  //     "Welcome to Bhartiya Astrologer..One of the most trusted astrology platform, Aapki call connect ki jaa rahi hai, Please be ready with your personal details and queries, Bhartiya Astrologer Aap ka Din sobh hone ki kamna karta hai.";
  //
  // Future<void> convertTextToAudio() async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   String filePath = '${tempDir.path}/text_audio.mp3';
  //
  //   FlutterTts flutterTts = FlutterTts();
  //   await flutterTts.setLanguage("hi-IN");
  //   await flutterTts.setSpeechRate(0.5);
  //
  //   var result = await flutterTts.synthesizeToFile(text, filePath);
  //   if (result == 1) {
  //     Get.find<CallController>().setAudioPath(filePath);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    // convertTextToAudio();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
        title: Text(
          '$type Intake Form',
          style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Get.theme.iconTheme.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<IntakeController>(builder: (c) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                TextFieldWidget(
                  controller: callIntakeController.nameController,
                  focusNode: callIntakeController.namefocus,
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                  labelText: 'Name',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            child: FutureBuilder(
                                future: global.translatedText('Phone Number'),
                                builder: (context, snapshot) {
                                  return IntlPhoneField(
                                    autovalidateMode: null,
                                    showDropdownIcon: false,
                                    onCountryChanged: (value) {
                                      callIntakeController.namefocus.unfocus();
                                      callIntakeController.phonefocus.unfocus();
                                      callIntakeController.updateCountryCode(value.code);
                                    },
                                    focusNode: callIntakeController.phonefocus,
                                    controller: callIntakeController.phoneController,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    keyboardType: TextInputType.phone,
                                    cursorColor: global.coursorColor,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      hintText: snapshot.data,
                                      errorText: null,
                                      counterText: '',
                                    ),
                                    initialCountryCode: callIntakeController.countryCode ?? 'IN',
                                    onChanged: (phone) {
                                      log('length ${phone.number}');

                                      callIntakeController.checkContact(phone.number);
                                    },
                                  );
                                })),
                      ),
                    ),
                    GetBuilder<IntakeController>(builder: (c) {
                      return !c.isVarified
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 30,
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.all(4)),
                                    fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                    backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Color.fromARGB(255, 189, 189, 189),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (callIntakeController.intakeContact!.length == 10) {
                                      global.showOnlyLoaderDialog(context);
                                      await callIntakeController.verifyOTP();
                                    }
                                  },
                                  child: Text(
                                    'Verify',
                                    style: Get.theme.primaryTextTheme.subtitle2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox();
                    }),
                  ],
                ),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextFieldLabelWidget(
                    label: 'Gender',
                  ),
                  Flexible(
                    flex: 1,
                    child: RadioListTile(
                      title: Text("Male"),
                      value: "male",
                      groupValue: callIntakeController.gender,
                      dense: true,
                      activeColor: Get.theme.primaryColor,
                      contentPadding: EdgeInsets.all(0.0),
                      onChanged: (value) {
                        callIntakeController.updateGeneder(value);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: RadioListTile(
                      title: Text("Female"),
                      value: "female",
                      groupValue: callIntakeController.gender,
                      activeColor: Get.theme.primaryColor,
                      contentPadding: EdgeInsets.all(0.0),
                      dense: true,
                      onChanged: (value) {
                        callIntakeController.updateGeneder(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 78,
                  )
                ]),
                InkWell(
                  onTap: () async {
                    callIntakeController.namefocus.unfocus();
                    callIntakeController.phonefocus.unfocus();
                    var datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime(1994),
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now(),
                      dateFormat: "dd-MM-yyyy",
                      itemTextStyle: Get.theme.textTheme.subtitle1!.copyWith(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                      ),
                      titleText: 'Select Birth Date',
                      textColor: Get.theme.primaryColor,
                    );
                    if (datePicked != null) {
                      callIntakeController.dobController.text = DateConverter.isoStringToLocalDateOnly(datePicked.toIso8601String());
                      callIntakeController.selctedDate = datePicked;
                      callIntakeController.update();
                    } else {
                      callIntakeController.dobController.text = DateConverter.isoStringToLocalDateOnly(DateTime(1994).toIso8601String());
                      callIntakeController.selctedDate = DateTime(1994);
                      callIntakeController.update();
                    }
                  },
                  child: IgnorePointer(
                    child: TextFieldWidget(
                      controller: callIntakeController.dobController,
                      labelText: 'Date of Birth',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    callIntakeController.namefocus.unfocus();
                    callIntakeController.phonefocus.unfocus();
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 12, minute: 30),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData(
                              colorScheme: ColorScheme.light(
                                primary: Get.theme.primaryColor,
                                onBackground: Colors.white,
                              ),
                            ),
                            child: child ?? SizedBox(),
                          );
                        });
                    String formatTimeOfDay(TimeOfDay tod) {
                      final now = new DateTime.now();
                      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
                      final format = DateFormat.jm(); //"6:00 AM"
                      return format.format(dt);
                    }

                    if (time != null) {
                      callIntakeController.birthTimeController.text = formatTimeOfDay(time);
                    }
                  },
                  child: IgnorePointer(
                    child: TextFieldWidget(
                      controller: callIntakeController.birthTimeController,
                      labelText: 'Time of Birth',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    callIntakeController.namefocus.unfocus();
                    callIntakeController.phonefocus.unfocus();
                    Get.to(() => PlaceOfBirthSearchScreen(
                          flagId: 5,
                        ));
                  },
                  child: IgnorePointer(
                    child: TextFieldWidget(
                      controller: callIntakeController.placeController,
                      labelText: 'Place of Birth',
                    ),
                  ),
                ),
                TextFieldLabelWidget(
                  label: 'Marital Status',
                ),
                DropDownWidget(
                  item: ['single', 'Married', 'Divorced', 'Separated', 'Widowed'],
                  hint: 'Select Marital Status',
                  callId: 1,
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFieldWidget(
                  controller: callIntakeController.ocupationController,
                  focusNode: callIntakeController.occupationfocus,
                  labelText: 'Occupation',
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                ),
                TextFieldLabelWidget(
                  label: 'Topic of Concern',
                ),
                DropDownWidget(
                  item: ['Study', 'Future', 'Past'],
                  hint: 'Select Topic of Concern',
                  callId: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: callIntakeController.isEnterPartnerDetails,
                        activeColor: Get.theme.primaryColor,
                        onChanged: (bool? value) {
                          callIntakeController.partnerDetails(value!);
                        }),
                    Text("Enter Partner's Details",
                        style: Get.textTheme.subtitle1!.copyWith(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ))
                  ],
                ),
                if (callIntakeController.isEnterPartnerDetails)
                  if (callIntakeController.isEnterPartnerDetails)
                    TextFieldWidget(
                      controller: callIntakeController.partnerNameController,
                      labelText: "Partner's Name",
                      focusNode: callIntakeController.partnerNamefocus,
                      inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                    ),
                if (callIntakeController.isEnterPartnerDetails)
                  if (callIntakeController.isEnterPartnerDetails)
                    InkWell(
                      onTap: () async {
                        callIntakeController.occupationfocus.unfocus();
                        callIntakeController.partnerNamefocus.unfocus();
                        var datePicked = await DatePicker.showSimpleDatePicker(
                          context,
                          initialDate: DateTime(1994),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now(),
                          dateFormat: "dd-MM-yyyy",
                          itemTextStyle: Get.theme.textTheme.subtitle1!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                          ),
                          titleText: "Select Partner's Birth Date",
                        );
                        if (datePicked != null) {
                          callIntakeController.partnerDobController.text = DateConverter.isoStringToLocalDateOnly(datePicked.toIso8601String());
                          callIntakeController.selctedPartnerDate = datePicked;
                          callIntakeController.update();
                        } else {
                          callIntakeController.partnerDobController.text = DateConverter.isoStringToLocalDateOnly(DateTime(1994).toIso8601String());
                          callIntakeController.selctedPartnerDate = DateTime(1994);
                          callIntakeController.update();
                        }
                      },
                      child: IgnorePointer(
                        child: TextFieldWidget(
                          controller: callIntakeController.partnerDobController,
                          labelText: "Partner's DOB",
                        ),
                      ),
                    ),
                if (callIntakeController.isEnterPartnerDetails)
                  if (callIntakeController.isEnterPartnerDetails)
                    InkWell(
                      onTap: () async {
                        callIntakeController.occupationfocus.unfocus();
                        callIntakeController.partnerNamefocus.unfocus();

                        final time = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 12, minute: 30));
                        String formatTimeOfDay(TimeOfDay tod) {
                          final now = new DateTime.now();
                          final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
                          final format = DateFormat.jm(); //"6:00 AM"
                          return format.format(dt);
                        }

                        if (time != null) {
                          callIntakeController.partnerBirthController.text = formatTimeOfDay(time);
                        }
                      },
                      child: IgnorePointer(
                        child: TextFieldWidget(
                          controller: callIntakeController.partnerBirthController,
                          labelText: "Partner's Time of Birth",
                        ),
                      ),
                    ),
                if (callIntakeController.isEnterPartnerDetails)
                  if (callIntakeController.isEnterPartnerDetails)
                    InkWell(
                      onTap: () {
                        callIntakeController.occupationfocus.unfocus();
                        callIntakeController.partnerNamefocus.unfocus();
                        Get.to(() => PlaceOfBirthSearchScreen(
                              flagId: 6,
                            ));
                      },
                      child: IgnorePointer(
                        child: TextFieldWidget(
                          controller: callIntakeController.partnerPlaceController,
                          labelText: 'Place of Birth',
                        ),
                      ),
                    ),
                const SizedBox(
                  height: 60,
                ),
              ],
            );
          }),
        ),
      ),
      bottomSheet: GetBuilder<IntakeController>(builder: (intakeController) {
        return CustomBottomButton(
          onTap: () async {
            bool isvalid = intakeController.isValidData();
            print(isvalid);
            if (!isvalid) {
              global.showToast(
                message: intakeController.errorText,
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              if (intakeController.isVarified) {
                global.showOnlyLoaderDialog(context);
                await callIntakeController.addCallIntakeFormData();
                print('firebase ${astrologerId}_${global.user.id}');
                // if (isFreeAvailable == true)
                if (isFreeAvailable == true)
                {
                  await intakeController.checkFreeSessionAvailable();
                  if (intakeController.isAddNewRequestByFreeuser == true) {
                    if (type == "VideoCall") {
                      print('sending video request........................');
                      await callController.sendVideoRequest(astrologerId, true);
                    }
                    if (type == "Call") {
                      await callController.sendCallRequest(astrologerId, true);
                    }
                    else if (type == "Chat") {
                      ChatController chatController = Get.find<ChatController>();
                      DropDownController dropDownController = Get.find<DropDownController>();
                      await chatController.sendMessage('hi $astrologerName ', '${astrologerId}_${global.user.id}', astrologerId, false);
                      await chatController.sendMessage('Below are my details:', '${astrologerId}_${global.user.id}', astrologerId, false);
                      await chatController.sendMessage(
                          'Name: ${intakeController.nameController.text},Gender: ${intakeController.gender},DOB: ${intakeController.dobController.text},TOB: ${intakeController.birthTimeController.text},POB: ${intakeController.placeController.text},Marital status: ${dropDownController.maritalStatus ?? "Single"},TOPIC: ${dropDownController.topic ?? 'Study'}',
                          '${astrologerId}_${global.user.id}',
                          astrologerId,
                          false);

                      if (callIntakeController.isEnterPartnerDetails) {
                        await chatController.sendMessage('Below are my partner details:', '${astrologerId}_${global.user.id}', astrologerId, false);
                        await chatController.sendMessage(
                            'Name: ${intakeController.partnerNameController.text},DOB: ${intakeController.partnerDobController.text},TOB: ${intakeController.partnerBirthController.text},POB: ${intakeController.partnerPlaceController.text}',
                            '${astrologerId}_${global.user.id}',
                            astrologerId,
                            false);
                        await chatController.sendMessage(
                            'This is automated message to confirm that chat has started.', '${astrologerId}_${global.user.id}', astrologerId, false);
                      } else {
                        await chatController.sendMessage(
                            'This is automated message to confirm that chat has started.', '${astrologerId}_${global.user.id}', astrologerId, false);
                      }
                      await chatController.sendChatRequest(astrologerId, true);
                    }
                  }
                  else {
                    global.showToast(
                        message: 'You can not join multiple offers at same time', textColor: global.textColor, bgColor: global.toastBackGoundColor);
                  }
                }
                else {
                  if (type == "VideoCall") {
                    print('sending video request........................');
                    await callController.sendVideoRequest(astrologerId, true);
                  }
                  if (type == "Call") {
                    await callController.sendCallRequest(astrologerId, false);
                  } else if (type == "Chat") {
                    ChatController chatController = Get.find<ChatController>();
                    DropDownController dropDownController = Get.find<DropDownController>();
                    await chatController.sendMessage('hi $astrologerName ', '${astrologerId}_${global.user.id}', astrologerId, false);
                    await chatController.sendMessage('Below are my details:', '${astrologerId}_${global.user.id}', astrologerId, false);
                    await chatController.sendMessage(
                        'Name: ${intakeController.nameController.text},Gender: ${intakeController.gender},DOB: ${intakeController.dobController.text},TOB: ${intakeController.birthTimeController.text},POB: ${intakeController.placeController.text},Marital status: ${dropDownController.maritalStatus ?? "Single"},TOPIC: ${dropDownController.topic ?? 'Study'}',
                        '${astrologerId}_${global.user.id}',
                        astrologerId,
                        false);

                    if (callIntakeController.isEnterPartnerDetails) {
                      await chatController.sendMessage('Below are my partner details:', '${astrologerId}_${global.user.id}', astrologerId, false);
                      await chatController.sendMessage(
                          'Name: ${intakeController.partnerNameController.text},DOB: ${intakeController.partnerDobController.text},TOB: ${intakeController.partnerBirthController.text},POB: ${intakeController.partnerPlaceController.text}',
                          '${astrologerId}_${global.user.id}',
                          astrologerId,
                          false);
                      await chatController.sendMessage(
                          'This is automated message to confirm that chat has started.', '${astrologerId}_${global.user.id}', astrologerId, false);
                    } else {
                      await chatController.sendMessage(
                          'This is automated message to confirm that chat has started.', '${astrologerId}_${global.user.id}', astrologerId, false);
                    }
                    await chatController.sendChatRequest(astrologerId, false);
                  }
                }
                global.hideLoader();
                // Get.back();
                // Get.back();
                dialogForchat();
                // Get.find<CallController>().playAudio();
                // convertTextToAudio();
                // playAudio(context);

              } else {
                global.showToast(
                  message: 'Please verify your phone number',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          },
          title: 'Start $type with $astrologerName',
        );
      }),
    );
  }



String addEllipsis(String str) {
  if (str.length > 6) {
    return str.substring(0, 6) + "...";  
  } else {
    return str;
  }
}

  dialogForchat() {
    BuildContext context = Get.context!;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Column(children: [
              Center(
                child: Text(
                  "You're all set!",
                  style: Get.theme.textTheme.headline1!
                      .copyWith(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Get.theme.primaryColor,
                        child: CachedNetworkImage(
                            imageUrl: '${global.imgBaseurl}${splashController.currentUser!.profile}',
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                  radius: 28,
                                  backgroundImage: imageProvider,
                                ),
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 28,
                                  backgroundImage: AssetImage(Images.deafultUser),
                                )),
                      ),
                      Center(
                        child: Text(
                          "•••••••••••",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Get.theme.primaryColor,
                        child: CachedNetworkImage(
                            imageUrl: '${global.imgBaseurl}$astrologerProfile',
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                                  radius: 28,
                                  backgroundImage: imageProvider,
                                ),
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 28,
                                  backgroundImage: AssetImage(Images.deafultUser),
                                )),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${addEllipsis(splashController.currentUser!.name??"")}",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(width: 13),
                  ),
                  Text(
                    "${addEllipsis(astrologerName)}",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'You will be connecting with $astrologerName after astrologer accept your request',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ),
              // Text(
              //   'BharatiyAstro will try to answer atleast one question in this 5 mins session',
              //   style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.off(() => BottomNavigationBarScreen(index: 0));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey)),
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ]),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          );
        });
  }
}
