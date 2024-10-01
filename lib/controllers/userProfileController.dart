// ignore_for_file: unnecessary_null_comparison, unnecessary_statements

import 'dart:io';

import 'package:BharatiyAstro/controllers/splashController.dart';

import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../model/dailyHoroscope_model.dart';

class UserProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController email = TextEditingController();
  SplashController splashController = Get.find<SplashController>();
  FocusNode fSearch = new FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFoucus = FocusNode();
  FocusNode currentAddFocus = FocusNode();
  String toastMessage = "";
  String gender = 'Male';
  bool isShowMore = false;
  String profile = "";
  APIHelper apiHelper = APIHelper();
  DateTime? pickedDate;
  Uint8List? tImage;
  XFile? selectedImage;
  File? imageFile;
  File? userFile;
  var zodicData = <Zodic>[];
  bool isImgSelectFromList = false;
  String selectedListImg = "";

  @override
  void onInit() async {
    _inIt();
    super.onInit();
  }

  _inIt() async {
    await splashController.getCurrentUserData();
    await getValue();
  }

  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file =
        await File('${(await getApplicationDocumentsDirectory()).path}/$path')
            .create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  getValue() async {
    if (splashController.currentUser != null) {
      nameController.text = splashController.currentUser!.name!;
      profile = splashController.currentUser!.profile ?? "";
      updateGeneder(splashController.currentUser!.gender!);
      dateController.text = formatDate(
          splashController.currentUser!.birthDate!, [dd, '-', mm, '-', yyyy]);
      timeController.text = splashController.currentUser!.birthTime!;
      placeBirthController.text = splashController.currentUser!.birthPlace!;
      currentAddressController.text =
          splashController.currentUser!.addressLine1!;
      addressController.text = splashController.currentUser!.location!;
      email.text = splashController.currentUser!.email ?? "";
      pinController.text =
          splashController.currentUser!.pincode.toString() == "null"
              ? ""
              : splashController.currentUser!.pincode.toString();
      imageFile = null;
      userFile = null;
      update();
    }
  }

  updateGeneder(value) {
    gender = value;
    update();
  }

  Future<File> imageService(ImageSource imageSource) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? selectedImage = await picker.pickImage(source: imageSource);
      imageFile = File(selectedImage!.path);

      if (selectedImage != null) {
        imageFile;
      }
    } catch (e) {
      print("Exception - businessRule.dart - _openGallery() ${e.toString()}");
    }
    return imageFile!;
  }

  showMoreText() {
    isShowMore = !isShowMore;
    update();
  }

  RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

  bool isValidData() {
    if (nameController.text == "") {
      toastMessage = "Please Enter your first name";
      update();
      return false;
    } else if (email.text == "" || !emailRegExp.hasMatch(email.text)) {
      toastMessage = "Please Enter correct Email";
      update();
      return false;
    }
    return true;
  }

  Future<XFile?> openCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        print("cropped file :- $_selectedImage");
        return _selectedImage;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Exception - user_profile_controller.dart - openCamera():" +
          e.toString());
    }
    return null;
  }

  updateCurrentUser(int id) async {
    var basicDetails = {
      "name": nameController.text,
      "contactNo": splashController.currentUser!.contactNo,
      "gender": gender,
      "birthTime": timeController.text == "" ? null : timeController.text,
      "birthDate": pickedDate == null ? null : pickedDate!.toIso8601String(),
      "birthPlace":
          placeBirthController.text == "" ? null : placeBirthController.text,
      "addressLine1": currentAddressController.text == ""
          ? null
          : currentAddressController.text,
      "addressLine2": null,
      "email": email.text,
      "location": addressController.text == "" ? null : addressController.text,
      "pincode":
          pinController.text == "" ? null : int.parse(pinController.text),
      "profile": profile == "" ? null : profile,
    };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .updateUserProfile(id, basicDetails)
              .then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your Profile has been updated',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await splashController.getCurrentUserData();
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to update profile please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in updateUserProfile:-" + e.toString());
    }
  }

  updateCurrentUserProfilepic(String profile) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.updetUserProfilePic(profile).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your Profile pic has been updated',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await splashController.getCurrentUserData();
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to update profile please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in updateUserProfile:-" + e.toString());
    }
  }

  getZodicImg() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.getZodiacProfileImg().then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              zodicData = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Fail to Get defualt img!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getZodicImg:-" + e.toString());
    }
  }
}
