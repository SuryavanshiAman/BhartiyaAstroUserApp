import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/model/gift_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class GiftController extends GetxController {
  SplashController splashController = Get.find<SplashController>();
  APIHelper apiHelper = APIHelper();
  var giftList = <GiftModel>[];
  int? giftSelectIndex;
  getGiftData() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getGift().then((result) {
            if (result.status == "200") {
              giftList = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getGiftData():' + e.toString());
    }
  }

  updateOntap(int index) {
    giftList[index].isSelected = true;
    giftSelectIndex = index;
    for (int i = 0; i < giftList.length; i++) {
      if (i == index) {
        continue;
      } else {
        giftList[i].isSelected = false;
        update();
      }
    }
    update();
  }

  bool isGiftSend = false;

  sendGift(int giftId, int astrologerId, double cutAmount) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.sendGiftToAstrologer(giftId, astrologerId).then((result) {
            if (result.status == "200") {
              global.user.walletAmount = global.user.walletAmount! - cutAmount;
              isGiftSend = true;
              update();
              splashController.update();

              global.showToast(
                message: 'Thank you!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              isGiftSend = false;
              global.showToast(
                message: 'send gift failed please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in sendGift():' + e.toString());
    }
  }
}
