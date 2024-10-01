import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class KundliBirthDateWidget extends StatelessWidget {
  final KundliController kundliController;
  final VoidCallback onPressed;
  KundliBirthDateWidget({Key? key, required this.kundliController, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 250,
          child: DatePickerWidget(
            looping: false,
            dateFormat: "MMM/dd/yyyy",
            onChange: (dateTime, selectedIndex) {
              kundliController.getselectedDate(dateTime);
            },
            initialDate: DateTime(1996),
            firstDate: DateTime(1960),
            lastDate: DateTime.now().subtract(Duration(days: 1)),
            pickerTheme: DateTimePickerTheme(
              backgroundColor: Colors.transparent,
            ),
            onConfirm: (dateTime, selectedIndex) {},
          ),
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
