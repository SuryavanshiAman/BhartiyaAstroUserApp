import 'package:BharatiyAstro/model/astrologer_model.dart';
import 'package:BharatiyAstro/model/availableTimes_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:intl/intl.dart';

class UpcomingController extends GetxController {
  APIHelper apiHelper = APIHelper();

  var upComingList = <AstrologerModel>[];
  var searchUpComing = <AstrologerModel>[];

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {}

  getUpcomingAstrologerList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getUpcomingList().then((result) {
            if (result.status == "200") {
              upComingList = result.recordList;
              update();
              if (upComingList.isNotEmpty) {
                String todayDay = DateFormat("EEEE").format(DateTime.now());
                for (var i = 0; i < upComingList.length; i++) {
                  if (upComingList[i].availability!.isNotEmpty) {
                    List<AvailableTimes>? times = [];
                    times = upComingList[i].availability!.firstWhere((element) => element.day == todayDay).time;
                    if (times!.isNotEmpty) {
                      upComingList[i].isTimeSlotAvailable = true;
                      upComingList[i].availableTimes = times;
                    } else {
                      upComingList[i].isTimeSlotAvailable = false;
                    }
                  } else {
                    upComingList[i].isTimeSlotAvailable = false;
                  }
                }
                update();
              }
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get Live Event',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getUpcomingAstrologerList():' + e.toString());
    }
  }

  getSearchResult(String searchString) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.liveEventSearch(searchString).then((result) {
            if (result.status == "200") {
              searchUpComing = result.recordList;
              update();
              if (searchUpComing.isNotEmpty) {
                String todayDay = DateFormat("EEEE").format(DateTime.now());
                for (var i = 0; i < searchUpComing.length; i++) {
                  if (searchUpComing[i].availability!.isNotEmpty) {
                    List<AvailableTimes>? times = [];
                    times = searchUpComing[i].availability!.firstWhere((element) => element.day == todayDay).time;
                    if (times!.isNotEmpty) {
                      searchUpComing[i].isTimeSlotAvailable = true;
                      searchUpComing[i].availableTimes = times;
                    } else {
                      searchUpComing[i].isTimeSlotAvailable = false;
                    }
                  } else {
                    searchUpComing[i].isTimeSlotAvailable = false;
                  }
                }
                update();
              }
            } else {
              global.showToast(
                message: 'failed to search event',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getSearchResult() upcoming: $e' + e.toString());
    }
  }
}
