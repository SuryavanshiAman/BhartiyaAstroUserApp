import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

class SearchPlaceController extends GetxController {
  GooglePlace? googlePlace;
  double? latitude;
  double? longitude;
  List<AutocompletePrediction> predictions = [];
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    // AIzaSyAvoGGL9-qF0nxv9WBU1p6dpIW01FcRWsU

    //back up AIzaSyDHP77oq5jt_MVCM_zSMO25a5ix0oMkT-0     old key
    String apiKey = "AIzaSyAvoGGL9-qF0nxv9WBU1p6dpIW01FcRWsU";
    googlePlace = GooglePlace(apiKey);

    super.onInit();
  }

  autoCompleteSearch(String? value) async {
    if (value!.isNotEmpty) {
      var result = await googlePlace!.autocomplete.get(value);
      print(result);
      if (result != null && result.predictions != null) {
        print('place : ${result.predictions}');
        predictions = result.predictions!;

        update();
      }
    } else {
      predictions = [];
      update();
    }
  }
}
