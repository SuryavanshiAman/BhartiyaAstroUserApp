import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/model/blocked_astrologe_model.dart';
import 'package:BharatiyAstro/model/notifications_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class SettingsController extends GetxController {
  APIHelper apiHelper = APIHelper();
  var notification = <NotificationsModel>[];
  bool isAstromallNotification = true;
  bool isLiveNotifications = true;
  bool isPrivacy = true;
  var blockedAstroloer = <BlockedAstrologerModel>[];
  deleteAccount(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteUser(id).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'Deleted Successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Deleted fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception ind deleteAccount:-" + e.toString());
    }
  }

  getNotification() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getNotifications().then((result) {
            if (result.status == "200") {
              notification = result.recordList;
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to et Notifications',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  deleteNotifications(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteNotifications(id).then((result) {
            if (result.status == "200") {
              getNotification();

              global.showToast(
                message: 'delete Notification successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail delete Notifications',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  deleteAllNotifications() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteAllNotifications().then((result) {
            if (result.status == "200") {
              getNotification();

              global.showToast(
                message: 'Delete all Notification successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail delete Notifications',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  Future<dynamic> getBlockAstrologerList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getBlockAstrologer().then((result) {
            if (result.status == "200") {
              blockedAstroloer = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'FAil to get block Atrologer',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBlockAstrologerList :-" + e.toString());
    }
  }

  Future<dynamic> unblockAstrologer(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.unblockAstrologer(astrologerId).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Astrologer Unblocked!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await getBlockAstrologerList();
              BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
              await bottomNavigationController.getAstrologerbyId(astrologerId);
              bottomNavigationController.update();
            } else {
              global.showToast(
                message: 'Fail get block Atrologer',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in unblockAstrologer :-" + e.toString());
    }
  }
}
