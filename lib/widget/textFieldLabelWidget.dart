import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class TextFieldLabelWidget extends StatelessWidget {
  final label;
  const TextFieldLabelWidget({Key? key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
      child: Text(
        label,
        style: Get.theme.textTheme.subtitle1!.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
