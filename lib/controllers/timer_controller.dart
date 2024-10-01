import 'dart:async';

import 'package:BharatiyAstro/controllers/chatController.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class TimerController extends GetxController {
  Timer? secTimer;
  int min = 0;
  int sec = 0;
  String minText = "00";
  String secText = "00";
  int totalSeconds = 0;
  APIHelper apiHelper = APIHelper();
  int chatId = 0;
  bool endChat = false;
  RxBool isLowbalance = false.obs;
  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    startTimer();
  }

 @override
  void dispose() {
    // Dispose of resources here
    super.dispose();
     secTimer!.cancel();
  }


  startTime(astrologerId, isFreeSession, fireBasechatId) {
    final ChatController chatController = Get.find<ChatController>();
    secTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
      chatController.sendMessage(
          '${global.user.name == '' ? 'user' : global.user.name} -> ended chat',
          fireBasechatId,
          astrologerId,
          true);
    });
  }

  startTimer() {
    totalSeconds = 0;
    secTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      totalSeconds += 1;
      update();

      if (sec < 60) {
        sec += 1;
        if (sec < 10) {
          secText = '0$sec';
        } else {
          secText = '$sec';
        }
        update();
      } else {
        sec = 0;
        update();
      }
      if (sec == 60) {
        if (min <= 4) {
          min += 1;
          if (min < 10) {
            minText = '0$min';
          } else {
            minText = '$min';
          }
          update();
        } else {
          min = 0;
          sec = 0;
          minText = "";
          secText = "";
          update();
          timer.cancel();
          secTimer!.cancel();
          print('total Seconds :- $totalSeconds');
          // await endChatTime(totalSeconds, chatId);
          // Get.back();
          // Get.back();
        }
      }
    });

    update();
  }

  endChatTime(int seconds, int chatIdd) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.saveChattingTime(seconds, chatIdd).then((result) {
            if (result.status == "200") {
              global.splashController.currentUser?.walletAmount =
                  result.recordList;
              global.showToast(
                message: 'Chat ended..',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'chat not ended',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in sendCallRequest : - ${e.toString()}');
    }
  }
}
