// ignore_for_file: non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe

import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class KundliBirthTimeWidget extends StatelessWidget {
  final KundliController kundliController;
  final VoidCallback? onPressed;
  KundliBirthTimeWidget({Key? key, required this.kundliController, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimePickerSpinner(
          is24HourMode: false,
          normalTextStyle: TextStyle(fontSize: 15),
          highlightedTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          onTimeChange: (date) {
            kundliController.getSelectedTime(date);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                value: kundliController.isTimeOfBirthKnow,
                activeColor: Colors.black,
                onChanged: (bool? value) {
                  kundliController.updateCheck(value);
                }),
            Text('Dont\'t know my exact time of birth', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Text('Note:Without time of birth,we can still achive upto 80% accurate predictions', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, color: Colors.grey)),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey)),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Next',
              textAlign: TextAlign.center,
              style: Get.theme.primaryTextTheme.subtitle1,
            ),
          ),
        ),
      ],
    );
  }
}
