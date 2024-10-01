import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../controllers/allReportController.dart';
import '../../controllers/contact_us_controller.dart';
import '../../model/body/PalmRequetbody.dart';
import '../../model/body/vastuBody.dart';
import '../../utils/date_converter.dart';
import '../../widget/textFieldLabelWidget.dart';
import '../../widget/textFieldWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

import '../placeOfBrithSearchScreen.dart';
import 'camera_widget.dart';

class ReportForm extends StatefulWidget {
  final String? type;
  final int? astrlogerId;
  const ReportForm({Key? key, this.type, this.astrlogerId}) : super(key: key);

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController message = TextEditingController();
  final TextEditingController birthTime = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController address = TextEditingController();
  final AllReportController allReportController =
      Get.put(AllReportController());

  disposeValue() {
    name.text = '';
    phoneNumber.text = '';
    email.text = '';
    message.text = '';
    birthTime.text = '';
    dateOfBirth.text = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeValue();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        title: Text(
          '${widget.type}',
          style: Get.textTheme.labelMedium!
              .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Customer Name',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: name,
                  // focusNode: callIntakeController.namefocus,
                  validation: (value) {
                    if (value == "") {
                      return "Enter valid name";
                    } else {
                      return null;
                    }
                  },
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                  ],
                  labelText: 'Customer Name',
                ),
                //  SizedBox(
                //          height: 10,
                //  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Place Of Birth',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => PlaceOfBirthSearchScreen(
                          flagId: 9,
                        ));
                  },
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.all(10),
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Text(
                              allReportController.birthPlace.value == ""
                                  ? ''
                                  : allReportController.birthPlace.value,
                              style: Get.textTheme.titleLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Time Of Birth',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
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
                      final dt = DateTime(
                          now.year, now.month, now.day, tod.hour, tod.minute);
                      final format = DateFormat.jm(); //"6:00 AM"
                      return format.format(dt);
                    }

                    if (time != null) {
                      birthTime.text = formatTimeOfDay(time);
                    }
                  },
                  child: IgnorePointer(
                    child: TextFieldWidget(
                      controller: birthTime,
                      labelText: 'Time of Birth',
                      validation: (value) {
                        if (value == "") {
                          return "Enter valid time";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Phone number',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: phoneNumber,
                  keyboardType: TextInputType.number,
                  // focusNode: callIntakeController.namefocus,if
                  validation: (value) {
                    if (value == "" || !RegExp(r"[0-9 ]").hasMatch(value)) {
                      return "enter valid number";
                    } else {
                      return null;
                    }
                  },
                  maxlen: 10,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9 ]"))
                  ],
                  labelText: 'Enter Your 10 digit phone number',
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Email',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                TextFieldWidget(
                  controller: email,
                  // focusNode: callIntakeController.namefocus,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z0-9_\.\-@]"))
                  ],
                  labelText: 'Enter Your email id',
                  validation: (value) {
                    if (value == "" ||
                        !RegExp(r"[a-zA-Z0-9_\.\-@]").hasMatch(value)) {
                      return "Enter Your email id";
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Date Of Birth',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
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
                      dateOfBirth.text = DateConverter.isoStringToLocalDateOnly(
                          datePicked.toIso8601String());
                      // callIntakeController.selctedDate = datePicked;
                      allReportController.picketDate = datePicked;
                      allReportController.update();
                    } else {
                      dateOfBirth.text = DateConverter.isoStringToLocalDateOnly(
                          DateTime(1994).toIso8601String());
                      allReportController.picketDate = DateTime(1994);
                      allReportController.update();
                    }
                  },
                  child: IgnorePointer(
                    child: TextFieldWidget(
                        controller: dateOfBirth,
                        labelText: 'Date of Birth',
                        validation: (value) {
                          if (value == "") {
                            return "Enter Your Date of Birth";
                          } else {
                            return null;
                          }
                        }),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 7,
                  maxLines: 7,
                  maxLength: 50,
                  controller: address,
                  // validator: (value){
                  //   print('$value');
                  //      if (value=="") {
                  //          return "enter valid address";
                  //      } else {
                  //                return "";
                  //      }
                  // },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Address',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ),

                widget.type == "Palm request"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // allReportController.takePhoto();
                                Get.bottomSheet(selectRightHand(context));
                                // Get.to(() => CameraWidget(
                                //       type: 'LeftHand',
                                //     ));
                              },
                              child: Text('Left Hand')),
                          ElevatedButton(
                              onPressed: () {
                                // allReportController.takePhoto();
                                Get.bottomSheet(selectLeftHand(context));
                                // Get.to(() => CameraWidget(
                                //       type: 'RightHand',
                                //     ));
                              },
                              child: Text('Right Hand'))
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // allReportController.takePhoto();
                                Get.bottomSheet(selectimageImage(context));
                              },
                              child: Text('upload Image'))
                        ],
                      ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: Get.width * 0.80,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  height: 50,
                  child: widget.type == "Palm request"
                      ? ElevatedButton(
                          onPressed: () async {
                            if (allReportController.isPost.value) {
                              if (_formKey.currentState!.validate()) {
                                if (allReportController.leftHandImageimagePath.value != "" ||
                                    allReportController.rightHandImageimagePath.value != "") {
                                  await allReportController.postpalmRequest(
                                      PalmRequets(
                                          astrologerID: widget.astrlogerId,
                                          address: address.text,
                                          birthPlace: allReportController
                                              .birthPlace.value,
                                          birthTime: birthTime.text,
                                          dateOfBirth: dateOfBirth.text,
                                          name: name.text,
                                          phone: phoneNumber.text,
                                          leftHand: allReportController.leftHandImageimagePath.value,
                                          rightHand: allReportController.rightHandImageimagePath.value
                                                  ));
                                  disposeValue();
                                } else {
                                  Get.snackbar('no data ', 'no data found');
                                }
                              }
                            } else {
                              Get.snackbar('Wait', 'Let it be Finished');
                            }
                          },
                          child: Obx(() => allReportController.isPost.value
                              ? Text('Send')
                              : CircularProgressIndicator()))
                      : ElevatedButton(
                          onPressed: () async {
                            if (allReportController.isdataPost.value) {
                              if (_formKey.currentState!.validate()) {
                                if (allReportController.selectedImage?.path !=
                                    "") {
                                  await allReportController.vastuRequets(
                                      VastuBody(
                                          astrologerID: widget.astrlogerId,
                                          address: address.text,
                                          // birthPlace: 'Ranchi',
                                          birthPlace: allReportController
                                              .birthPlace.value,
                                          birthTime: birthTime.text,
                                          dateOfBirth: dateOfBirth.text,
                                          name: name.text,
                                          phone: phoneNumber.text,
                                          location: address.text,
                                          attachment: allReportController
                                              .selectedImagePath.value));
                                  disposeValue();
                                } else {
                                  Get.snackbar('no data ', 'no data found');
                                }
                              }
                            } else {
                              Get.snackbar('Wait', 'Let it be Finished');
                            }
                          },
                          child: Obx(() => allReportController.isdataPost.value
                              ? Text('Send')
                              : CircularProgressIndicator())),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> requestCameraPermission() async {
    if (await Permission.camera.request() == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Widget selectimageImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                title: Text(
                  "Camera",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () async {
                  allReportController.openCamera(Get.theme.primaryColor);
                  // signupController.openBackkycCamera();
                  Get.back();
                  // editProfileController.onOpenCamera();

                  // _tImage = await br.openCamera(Theme.of(context).primaryColor, isProfile: true);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.blue,
                ),
                title: Text(
                  "Gallery",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () async {
                  allReportController.openGallery(Get.theme.primaryColor);

                  Get.back();
                  // editProfileController.onOpenGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.black),
                title: Text(
                  "Cancel",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget selectLeftHand(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                title: Text(
                  "Camera",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () async {
                  allReportController.openLeftCamera(Get.theme.primaryColor);
                  // signupController.openBackkycCamera();
                  Get.back();
                  // editProfileController.onOpenCamera();

                  // _tImage = await br.openCamera(Theme.of(context).primaryColor, isProfile: true);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.blue,
                ),
                title: Text(
                  "Gallery",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () async {
                  allReportController.openRightGallery(Get.theme.primaryColor);

                  Get.back();
                  // editProfileController.onOpenGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.black),
                title: Text(
                  "Cancel",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

    Widget selectRightHand(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
                title: Text(
                  "Camera",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () async {
                  allReportController.openRightCamera(Get.theme.primaryColor);
                  // signupController.openBackkycCamera();
                  Get.back();
                  // editProfileController.onOpenCamera();

                  // _tImage = await br.openCamera(Theme.of(context).primaryColor, isProfile: true);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.blue,
                ),
                title: Text(
                  "Gallery",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () async {
                  allReportController.openRightGallery(Get.theme.primaryColor);

                  Get.back();
                  // editProfileController.onOpenGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.black),
                title: Text(
                  "Cancel",
                  style: Get.theme.primaryTextTheme.subtitle1,
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
