

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController{

  var imagePath = ''.obs;
  File? imageFile;

  //reset image filed
  void resetImageValue() {
    imagePath.value = '';
  }

  Future<File?> imageService(ImageSource imageSource)async{
    try{
      final ImagePicker _picker = ImagePicker();
      XFile? _selectImage = await _picker.pickImage(source: imageSource);
      imageFile =  File(_selectImage!.path);
      List<int> imageBytes = imageFile!.readAsBytesSync();
          print(imageBytes);
          imagePath.value = base64Encode(imageBytes);
          update();

          return imageFile; 
    }catch(e){
      print("Exception in imageService :-"+e.toString());
    }
    return null;
  }
}