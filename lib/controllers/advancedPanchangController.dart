import 'package:BharatiyAstro/model/advancedPanchangModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:intl/intl.dart';

class PanchangController extends GetxController {
  APIHelper apiHelper = APIHelper();
  PanchangModel? panchangList;

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  DateTime now = DateTime.now();
  late String formattedDate = DateFormat('MMM d, EEEE').format(now);

  _inIt() async {}

  getPanchangDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAdvancedPanchang(day: day, month: month, year: year, hour: hour, min: min, lat: lat, lon: lon, tzone: tzone).then((result) {
            if (result.status == "200") {
              Map<String, dynamic> map = result;
              panchangList = PanchangModel.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Failed to get Panchang',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getPanchangDetail():' + e.toString());
    }
  }
}
