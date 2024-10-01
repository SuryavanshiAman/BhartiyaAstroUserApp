import 'package:get/get.dart';

import '../model/language.dart';

class FreeServiceController extends GetxController {
  List<TabModel> freeServiceChart = [
    TabModel(title: 'Lagna Chart', isSelected: true),
    TabModel(title: 'Planetary Position', isSelected: false),
  ];

  final List<Map<String, String>> listOfPlanetPosition = [
    {"planet": "Ascendant", "rashi": "Aries", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "1"},
    {"planet": "Venus", "rashi": "Aries", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "11"},
    {"planet": "Ascendant", "rashi": "Capricorn", "degree": "22 \u00b0", "nakshatra": "Shrvana", "pada": "9"},
    {"planet": "Moon", "rashi": "Capricorn", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "10"},
    {"planet": "Ascendant", "rashi": "Capricorn", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "1"},
    {"planet": "Venus", "rashi": "Aries", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "8"},
    {"planet": "Rahu", "rashi": "Capricorn", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "1"},
    {"planet": "Rahu", "rashi": "Aries", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "1"},
    {"planet": "Ketu", "rashi": "Capricorn", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "1"},
    {"planet": "Ascendant", "rashi": "Aries", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "7"},
    {"planet": "Ascendant", "rashi": "Aries", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "1"},
    {"planet": "pluto", "rashi": "Scorpio", "degree": "22 \u00b0", "nakshatra": "Swati", "pada": "10"},
  ];
  selectChartTab(int index) {
    freeServiceChart[index].isSelected = true;
    for (int i = 0; i < freeServiceChart.length; i++) {
      if (i == index) {
        continue;
      } else {
        freeServiceChart[i].isSelected = false;
        update();
      }
    }
    update();
  }
}
