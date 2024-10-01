// ignore_for_file: unused_local_variable, unrelated_type_equality_checks

import 'dart:convert';

import 'package:BharatiyAstro/controllers/search_controller.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';

import 'package:BharatiyAstro/controllers/userProfileController.dart';
import 'package:BharatiyAstro/views/placeOfBrithSearchScreen.dart';
import 'package:BharatiyAstro/widget/customBottomButton.dart';
import 'package:BharatiyAstro/widget/textFieldLabelWidget.dart';
import 'package:BharatiyAstro/widget/textFieldWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/images.dart';
import '../../widget/commonAppbar.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

// ignore: must_be_immutable
class EditUserProfile extends StatelessWidget {
  EditUserProfile({Key? key}) : super(key: key);
  final UserProfileController userProfileController = Get.find<UserProfileController>();
  SearchController searchController = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Profile',
          )),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: GetBuilder<UserProfileController>(builder: (userProfile) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Stack(
                  children: [
                    userProfileController.userFile != null && userProfileController.userFile != ''
                        ? Container(
                            height: 140,
                            width: 140,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Get.theme.primaryColor,
                                image: DecorationImage(
                                  image: FileImage(userProfileController.userFile!),
                                  fit: BoxFit.cover,
                                )),
                          )
                        : GetBuilder<SplashController>(builder: (splashController) {
                            return Container(
                                height: 140,
                                width: 140,
                                alignment: Alignment.center,
                                child: userProfileController.splashController.currentUser?.profile == "" ||
                                        userProfileController.splashController.currentUser?.profile == null
                                    ? CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          Images.deafultUser,
                                          fit: BoxFit.fill,
                                          height: 50,
                                        ))
                                    : Container(
                                        height: 140,
                                        width: 140,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            color: Get.theme.primaryColor,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "${global.imgBaseurl}${userProfileController.splashController.currentUser?.profile}"),
                                              fit: BoxFit.cover,
                                            )),
                                      ));
                          }),
                    Positioned(
                        bottom: -5,
                        right: -8,
                        child: GestureDetector(
                          onTap: () async {
                            await userProfileController.getZodicImg();
                            Get.defaultDialog(
                                titlePadding: EdgeInsets.all(0),
                                contentPadding: EdgeInsets.all(0),
                                title: "",
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                        child: Text(
                                      'Change Profile Pic',
                                      style: Get.textTheme.headline6!.copyWith(color: Colors.grey, fontSize: 16),
                                    )),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                                      child: Text(
                                        'Select from Library',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.4,
                                      width: Get.width,
                                      child: ListView(
                                        primary: true,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        children: [
                                          Center(
                                            child: Wrap(
                                              spacing: 15.0,
                                              runSpacing: 16.0,
                                              children: [
                                                for (int i = 0; i < userProfileController.zodicData.length; i++)
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          Get.dialog(AlertDialog(
                                                            title: GestureDetector(
                                                              onTap: () {
                                                                Get.back();
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.all(8),
                                                                child: Align(
                                                                  alignment: Alignment.topRight,
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: 18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            titlePadding: const EdgeInsets.all(0),
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text('Update Profile Photo'),
                                                                Container(
                                                                  height: 150,
                                                                  width: 150,
                                                                  margin: const EdgeInsets.all(8),
                                                                  padding: const EdgeInsets.all(8),
                                                                  decoration: BoxDecoration(
                                                                      color: Get.theme.primaryColor,
                                                                      borderRadius: BorderRadius.circular(7)),
                                                                  child: CachedNetworkImage(
                                                                    height: 20,
                                                                    width: 20,
                                                                    imageUrl:
                                                                        '${global.imgBaseurl}${userProfileController.zodicData[i].image}',
                                                                    placeholder: (context, url) =>
                                                                        const Center(child: CircularProgressIndicator()),
                                                                    errorWidget: (context, url, error) =>
                                                                        Icon(Icons.grid_view_rounded, size: 20),
                                                                  ),
                                                                ),
                                                                FittedBox(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        onPressed: () async {
                                                                          String imgPath =
                                                                              "${global.imgBaseurl}${userProfileController.zodicData[i].image}";
                                                                          print('ontappp');

                                                                          GallerySaver.saveImage(imgPath).then((path) {
                                                                            global.showToast(
                                                                              message: 'Image has been downloaded.',
                                                                              textColor: global.textColor,
                                                                              bgColor: global.toastBackGoundColor,
                                                                            );
                                                                          });
                                                                          Get.back();
                                                                        },
                                                                        child: Text('Download'),
                                                                        style: ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(Get.theme.primaryColor),
                                                                          foregroundColor:
                                                                              MaterialStateProperty.all(Colors.black),
                                                                          textStyle:
                                                                              MaterialStateProperty.all(TextStyle(fontSize: 12)),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 4,
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed: () async {
                                                                          userProfileController.profile =
                                                                              userProfileController.zodicData[i].image;
                                                                          userProfileController.isImgSelectFromList = true;
                                                                          userProfileController.update();
                                                                          await userProfileController.updateCurrentUserProfilepic(
                                                                              userProfileController.profile);
                                                                          Get.back();
                                                                        },
                                                                        child: Text('Set profile pic'),
                                                                        style: ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(Get.theme.primaryColor),
                                                                          foregroundColor:
                                                                              MaterialStateProperty.all(Colors.black),
                                                                          textStyle:
                                                                              MaterialStateProperty.all(TextStyle(fontSize: 12)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ));
                                                        },
                                                        child: Container(
                                                          height: 50,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                            color: Get.theme.primaryColor,
                                                            borderRadius: BorderRadius.circular(7),
                                                          ),
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                '${global.imgBaseurl}${userProfileController.zodicData[i].image}',
                                                            placeholder: (context, url) =>
                                                                const Center(child: CircularProgressIndicator()),
                                                            errorWidget: (context, url, error) =>
                                                                Icon(Icons.grid_view_rounded, size: 20),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(userProfileController.zodicData[i].title,
                                                          style: Get.textTheme.bodySmall)
                                                    ],
                                                  )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                                      child: Text(
                                        'Upload from Phone',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  userProfileController.imageFile =
                                                      await userProfileController.imageService(ImageSource.camera);
                                                  userProfileController.userFile = userProfileController.imageFile;
                                                  userProfileController.profile =
                                                      base64.encode(userProfileController.imageFile!.readAsBytesSync());
                                                  userProfileController.update();
                                                  Get.back();
                                                },
                                                icon: Icon(
                                                  Icons.camera,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text('Camera', style: Get.textTheme.bodySmall)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  userProfileController.imageFile =
                                                      await userProfileController.imageService(ImageSource.gallery);
                                                  userProfileController.userFile = userProfileController.imageFile;
                                                  userProfileController.profile =
                                                      base64.encode(userProfileController.imageFile!.readAsBytesSync());
                                                  userProfileController.update();
                                                  Get.back();
                                                },
                                                icon: Icon(
                                                  Icons.picture_in_picture,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                ' Gallery',
                                                style: Get.textTheme.bodySmall,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: Icon(
                                Icons.cloud_upload,
                                color: Get.theme.primaryColor,
                              )),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                  child: Text(
                      '${userProfileController.splashController.currentUser!.countryCode}-${userProfileController.splashController.currentUser!.contactNo}')),
              SizedBox(height: 10),
              TextFieldWidget(
                controller: userProfileController.nameController,
                focusNode: userProfileController.nameFocus,
                labelText: 'Name',
                keyboardType: TextInputType.name,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
              ),
              TextFieldWidget(
                controller: userProfileController.email,
                focusNode: userProfileController.emailFoucus,
                labelText: 'Email',
                keyboardType: TextInputType.name,
                inputFormatter: [
                  // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextFieldLabelWidget(
                  label: 'Gender',
                ),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                    title: Text(
                      "Male",
                      style: TextStyle(fontSize: 13),
                    ),
                    value: "Male",
                    groupValue: userProfileController.gender,
                    dense: true,
                    activeColor: Get.theme.primaryColor,
                    contentPadding: EdgeInsets.all(0.0),
                    onChanged: (value) {
                      userProfileController.updateGeneder(value);
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: RadioListTile(
                    title: Text("Female", style: TextStyle(fontSize: 13)),
                    value: "Female",
                    groupValue: userProfileController.gender,
                    activeColor: Get.theme.primaryColor,
                    contentPadding: EdgeInsets.all(0.0),
                    onChanged: (value) {
                      userProfileController.updateGeneder(value);
                    },
                  ),
                ),
                SizedBox(width: 78)
              ]),
              InkWell(
                onTap: () async {
                  userProfileController.nameFocus.unfocus();
                  var datePicked = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: DateTime(1994),
                    firstDate: DateTime(1960),
                    lastDate: DateTime.now(),
                    dateFormat: "dd-MM-yyyy",
                    itemTextStyle: Get.theme.textTheme.subtitle1!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0, color: Colors.black),
                    titleText: 'Select Birth Date',
                    textColor: Get.theme.primaryColor,
                  );
                  if (datePicked != null) {
                    userProfileController.dateController.text = formatDate(datePicked, [dd, '-', mm, '-', yyyy]);
                    userProfileController.pickedDate = datePicked;
                    userProfileController.update();
                  } else {
                    userProfileController.dateController.text = formatDate(DateTime(1994), [dd, '-', mm, '-', yyyy]);
                    userProfileController.pickedDate = DateTime(1994);
                    userProfileController.update();
                  }
                },
                child: IgnorePointer(
                  child: TextFieldWidget(
                    controller: userProfileController.dateController,
                    labelText: 'Date of Birth',
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  userProfileController.nameFocus.unfocus();
                  final format = DateFormat("hh:mm a");
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
                    userProfileController.timeController.text = formatTimeOfDay(time);
                  } else {
                    userProfileController.timeController.text = formatTimeOfDay(TimeOfDay(hour: 12, minute: 30));
                  }
                },
                child: IgnorePointer(
                  child: TextFieldWidget(
                    controller: userProfileController.timeController,
                    labelText: 'Time of Birth',
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  userProfileController.nameFocus.unfocus();
                  Get.to(() => PlaceOfBirthSearchScreen(
                        flagId: 3,
                      ));
                },
                child: IgnorePointer(
                  child: TextFieldWidget(
                    controller: userProfileController.placeBirthController,
                    labelText: 'Place of Birth',
                  ),
                ),
              ),
              TextFieldWidget(
                controller: userProfileController.currentAddressController,
                labelText: 'Current Address',
                focusNode: userProfileController.currentAddFocus,
              ),
              InkWell(
                onTap: () {
                  userProfileController.nameFocus.unfocus();
                  userProfileController.currentAddFocus.unfocus();
                  Get.to(() => PlaceOfBirthSearchScreen(
                        flagId: 4,
                      ));
                },
                child: IgnorePointer(
                  child: TextFieldWidget(
                    controller: userProfileController.addressController,
                    labelText: 'City,State,Country',
                  ),
                ),
              ),
              TextFieldWidget(
                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                controller: userProfileController.pinController,
                labelText: 'Pincode',
                hintText: '',
                maxlen: 6,
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: true),
              ),
              SizedBox(
                height: 70,
              )
            ],
          );
        }),
      )),
      bottomSheet: GetBuilder<UserProfileController>(builder: (userProfileController) {
        return CustomBottomButton(
          title: 'Submit',
          onTap: () async {
            bool isvalid = userProfileController.isValidData();
            if (!isvalid) {
              global.showToast(
                message: userProfileController.toastMessage,
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showOnlyLoaderDialog(context);
              searchController.update();
              await userProfileController.updateCurrentUser(global.sp!.getInt("currentUserId") ?? 0);
              global.hideLoader();
            }
          },
        );
      }),
    );
  }
}
