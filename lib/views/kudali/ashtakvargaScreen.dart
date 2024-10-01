import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class AshtakvargaScreen extends StatelessWidget {
  const AshtakvargaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<KundliController>(builder: (kundliController) {
        return ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Ashtakvarga Chart',
              style: Get.textTheme.subtitle1,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'The Ashtakavarga system of prediction works on the Bindu or dots. These are basically a point system where each planet except Rahu and Ketu are allotted a specific number in a specific house of your Kundali or birth chart. The higher number denotes the strength of that house in your Kundali. For example, if you have a higher value in the 11th house, which is the house of income, that would be a good sign as the planets in that house have a strong position and influence your Kundali more than others. For that reason, many believe Ashtakavarga in astrology to be even more precise than the birth chart or Janam Kundali analysis.',
              style: Get.textTheme.bodyText2!.copyWith(fontSize: 12),
            ),
          ],
        );
      }),
    );
  }
}
