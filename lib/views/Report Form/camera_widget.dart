import 'dart:io';

import 'package:BharatiyAstro/controllers/allReportController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {

 final String?type;
  const CameraWidget({ Key? key, this.type }) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {


  List<CameraDescription> cameras = [];

 late CameraController controller;


bool cameraInitialized = false;

AllReportController allReportController = Get.put(AllReportController());


Future<void> initializeCamera() async {
  cameras = await availableCameras();
  controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
  
    await controller.initialize().then((value) =>  allReportController.isCameraInitilized.value = true);
   
}


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();
  }
  
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    allReportController.isCameraInitilized.value = false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => allReportController.isCameraInitilized.value?Container(
        height: Get.height,
        width: Get.width,
       child: 
       allReportController.imagePath.value==""?CameraPreview(controller,
       child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
              InkWell(
                onTap: ()async{
             XFile    picture = await controller.takePicture();
             allReportController.picture = picture;
             allReportController.imagePath.value = picture.path;
             allReportController.imageFile = File(picture.path);
             if (widget.type == "LeftHand") {
               allReportController.leftHand = File(picture.path);
             }else if (widget.type == "RightHand"){
                     allReportController.rightHand = File(picture.path);
             }else if(widget.type =='Vastu'){
                 allReportController.vastu = File(picture.path);
             }
             allReportController.update();
               print(allReportController.picture!.path);
                },
                child: CircleAvatar(
                  radius: 40,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ), 
                  ),
                ),
              ),
           
            ],
          ),
          SizedBox(
            height: 15,
          )
        ],
       ),
       ):Stack(
        clipBehavior: Clip.none,
        children: [
          
          SizedBox(
               height: Get.height,
        width: Get.width,
            child: Image.file(allReportController.imageFile,fit: BoxFit.cover,)),
       Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child:        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    IconButton(onPressed: (){
                   allReportController.imagePath.value = "";
                   allReportController.update();
                }, icon: Icon(Icons.arrow_back,color:Colors.white,
                  size: 35,
                )),
                   TextButton(onPressed: (){
                       allReportController.imagePath.value = "";
                  Get.back();
                }, child: Text('OK',
                style: Get.textTheme.labelLarge!.copyWith(
                  fontSize: 20,
                  color: Colors.white
                ),
                ))
              ],
            ),
          ))
        ],
       ),  
      ):Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}