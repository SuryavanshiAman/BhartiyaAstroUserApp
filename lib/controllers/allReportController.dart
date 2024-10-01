import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:http/http.dart' as https;
import 'package:camera/camera.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/body/PalmRequetbody.dart';
import '../model/body/vastuBody.dart';
import '../model/success_on_enquery.dart';
import 'package:http_parser/http_parser.dart';

class AllReportController extends GetxController {
  DateTime? picketDate;
  late File imageFile;

  late File leftHand;
  late File rightHand;
  late File vastu;
  XFile? picture;
  RxBool isCameraInitilized = false.obs;
  RxString imagePath = "".obs;
  RxString birthPlace = "".obs;
  RxBool isPost = true.obs;
  RxBool isdataPost = true.obs;
  List<CameraDescription> cameras = [];

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
  }

  SuccessModel suceesModel = SuccessModel();

  Future<String> takePhoto() async {
    final CameraController controller = CameraController(
      cameras[0], // Use the first available camera
      ResolutionPreset.medium,
    );

    await controller.initialize();

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String path = '${appDir.path}/image.jpg';

    picture = await controller.takePicture();
    imageFile = File(picture!.path);

    return path;
  }

  SharedPreferences? sp;

  postpalmRequest(PalmRequets contactUs) async {
    sp = await SharedPreferences.getInstance();
    String tokenType = sp!.getString("tokenType") ?? "Bearer";
    String token = sp!.getString("token") ?? "invalid token";
    print(contactUs.toJson());
    try {
      isPost.value = false;
      var response = await https.post(
          Uri.parse('https://bharatiyastro.com/api/palmRequest'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "$tokenType $token"
          },
          body: jsonEncode(contactUs.toJson()));
      print('${response.body}');
      if (response.statusCode == 200) {
        // isDataPost.value = true;
        isPost.value = true;
        Get.back();
        suceesModel = SuccessModel.fromJson(jsonDecode(response.body));
        Get.snackbar('Success', 'Message Send SuceessFully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Get error On sending Message');
    }
  }

  vastuRequets(VastuBody contactUs) async {
    sp = await SharedPreferences.getInstance();
    String tokenType = sp!.getString("tokenType") ?? "Bearer";
    String token = sp!.getString("token") ?? "invalid token";
    print(contactUs.toJson());
    try {
      isdataPost.value = false;
      var response = await https.post(
          Uri.parse('https://bharatiyastro.com/api/vastuRequest'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "$tokenType $token"
          },
          body: jsonEncode(contactUs.toJson()));
      print('${response.body}');
      if (response.statusCode == 200) {
        // isDataPost.value = true;
        isdataPost.value = true;
        Get.back();
        suceesModel = SuccessModel.fromJson(jsonDecode(response.body));
        Get.snackbar('Success', 'Message Send SuceessFully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Get error On sending Message');
    }
  }

//improved version of vastu and handreader
  Uint8List? tImage;
  File? selectedImage;
  var selectedImagePath = ''.obs;

//kyc front Image
  Uint8List? leftHandImage;
  File? leftHandselectedImage;
  var leftHandImageimagePath = ''.obs;

//kyc back Image
  Uint8List? rightHandImage;
  File? rightHandselectedImage;
  var rightHandImageimagePath = ''.obs;

  //open camera Only
  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenGallery() async {
    selectedImage = await openGallery(Get.theme.primaryColor).obs();
    update();
  }

 //open left hand camera Only
  onOpenleftHandCamera() async {
    selectedImage = await openLeftCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenRightGallery() async {
    selectedImage = await openLeftGallery(Get.theme.primaryColor).obs();
    update();
  }

 //open Right hand camera Only
  onOpenRightHandCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenRightHandGallery() async {
    selectedImage = await openGallery(Get.theme.primaryColor).obs();
    update();
  }




  Future<File?> openGallery(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.gallery);

      if (_selectedImage != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );

        if (croppedFile != null) {
          selectedImage = File(croppedFile.path);
          List<int> imageBytes = selectedImage!.readAsBytesSync();
          print(imageBytes);

          selectedImagePath.value = base64Encode(imageBytes);
          List<int> decodedbytes = base64.decode(selectedImagePath.value);
          // global.showToast(message: "File selected successfully");
          return File(decodedbytes.toString());
        }
      }
    } catch (e) {
      print("Exception -  - openGallery()" + e.toString());
    }
    return null;
  }


  Future<File?> openCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        CroppedFile? _croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );
        if (_croppedFile != null) {
          selectedImage = File(_croppedFile.path);
          List<int> imageBytes = selectedImage!.readAsBytesSync();
          print(imageBytes);

          selectedImagePath.value = base64Encode(imageBytes);
          List<int> decodedbytes = base64.decode(selectedImagePath.value);
          // global.showToast(message: "File selected successfully");
          return File(decodedbytes.toString());
        }
        // if (_croppedFile != null) {
        //  global.showToast(message: "File selected successfully");
        //   return File(_croppedFile.path);
        // }
      }
    } catch (e) {
      print("Exception -- openCamera():" + e.toString());
    }
    return null;
  }

   Future<File?> openLeftGallery(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.gallery);

      if (_selectedImage != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );

        if (croppedFile != null) {
          leftHandselectedImage = File(croppedFile.path);
          List<int> imageBytes = leftHandselectedImage!.readAsBytesSync();
          print(imageBytes);

          leftHandImageimagePath.value = base64Encode(imageBytes);
          List<int> decodedbytes = base64.decode(leftHandImageimagePath.value);
          // global.showToast(message: "File selected successfully");
          return File(decodedbytes.toString());
        }
      }
    } catch (e) {
      print("Exception -  - openGallery()" + e.toString());
    }
    return null;
  }


  Future<File?> openLeftCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        CroppedFile? _croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );
        if (_croppedFile != null) {
          leftHandselectedImage = File(_croppedFile.path);
          List<int> imageBytes = leftHandselectedImage!.readAsBytesSync();
          print(imageBytes);

          leftHandImageimagePath.value = base64Encode(imageBytes);
          List<int> decodedbytes = base64.decode(leftHandImageimagePath.value);
          // global.showToast(message: "File selected successfully");
          return File(decodedbytes.toString());
        }
        // if (_croppedFile != null) {
        //  global.showToast(message: "File selected successfully");
        //   return File(_croppedFile.path);
        // }
      }
    } catch (e) {
      print("Exception -- openCamera():" + e.toString());
    }
    return null;
  }

  
   Future<File?> openRightGallery(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.gallery);

      if (_selectedImage != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );

        if (croppedFile != null) {
          rightHandselectedImage = File(croppedFile.path);
          List<int> imageBytes = rightHandselectedImage!.readAsBytesSync();
          print(imageBytes);

          rightHandImageimagePath.value = base64Encode(imageBytes);
          List<int> decodedbytes = base64.decode(rightHandImageimagePath.value);
          // global.showToast(message: "File selected successfully");
          return File(decodedbytes.toString());
        }
      }
    } catch (e) {
      print("Exception -  - openGallery()" + e.toString());
    }
    return null;
  }


  Future<File?> openRightCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        CroppedFile? _croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio:
              isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );
        if (_croppedFile != null) {
          rightHandselectedImage = File(_croppedFile.path);
          List<int> imageBytes = rightHandselectedImage!.readAsBytesSync();
          print(imageBytes);

          rightHandImageimagePath.value = base64Encode(imageBytes);
          List<int> decodedbytes = base64.decode(rightHandImageimagePath.value);
          // global.showToast(message: "File selected successfully");
          return File(decodedbytes.toString());
        }
        // if (_croppedFile != null) {
        //  global.showToast(message: "File selected successfully");
        //   return File(_croppedFile.path);
        // }
      }
    } catch (e) {
      print("Exception -- openCamera():" + e.toString());
    }
    return null;
  }
}
// }
