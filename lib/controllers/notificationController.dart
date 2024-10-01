import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class NoticationController extends GetxController {

  showChatNotification(String profileImage, String name, Function accept) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 500),
     
      snackPosition: SnackPosition.TOP,
      messageText: SizedBox(
        height: 120,
        child: Container(
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(loadingBuilder: (context, child, loadingProgress) {
                        return CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }, errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person_pin,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      }, fit: BoxFit.cover, '${global.baseUrl}$profileImage')),
                ),
                // SizedBox(
                //   width: 18,
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$name',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Incomming Chat ',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Set the border radius here
                              ),
                            ),
                            onPressed: () {
                              FlutterRingtonePlayer.stop();
                              Get.back();
                              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                            child: Text("Reject")),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Set the border radius here
                              ),
                            ),
                            onPressed: () {
                                    accept();
                              Get.back();
                        
                              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                            child: Text("Accept"))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }


    showCallNotification(String profileImage, String name, Function accept) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.TOP,
      animationDuration: Duration(milliseconds: 500),
      messageText: SizedBox(
        height: 120,
        child: Container(
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(loadingBuilder: (context, child, loadingProgress) {
                        return CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }, errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person_pin,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      }, fit: BoxFit.cover, '${global.baseUrl}$profileImage')),
                ),
                // SizedBox(
                //   width: 18,
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$name',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Incomming Chat ',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Set the border radius here
                              ),
                            ),
                            onPressed: () {
                              FlutterRingtonePlayer.stop();
                              Get.back();
                              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                            child: Text("Reject")),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Set the border radius here
                              ),
                            ),
                            onPressed: () {
                                    accept();
                              Get.back();
                        
                              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                            child: Text("Accept"))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }


}
