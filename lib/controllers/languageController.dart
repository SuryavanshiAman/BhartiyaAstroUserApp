import 'package:BharatiyAstro/model/languageModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class LanguageController extends GetxController {
  APIHelper apiHelper = APIHelper();

  var languageList = <LanguageModel>[];
  List<int> languageFilterList = [];
  bool value = true;

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {}

  getLanguages() async {
    try {
      languageList = [];
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLanguage().then((result) {
            if (result.status == "200") {
              languageList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Get language failed',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            if (languageFilterList.isNotEmpty) {
              for (var i = 0; i < languageList.length; i++) {
                languageList[i].isSelected = false;
                for (var j = 0; j < languageFilterList.length; j++) {
                  if (languageFilterList[j] == languageList[i].id) {
                    languageList[i].isSelected = true;
                  } else {}
                }
              }
            } else {
              for (var i = 0; i < languageList.length; i++) {
                languageList[i].isSelected = true;
              }
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getLanguages():' + e.toString());
    }
  }
}
