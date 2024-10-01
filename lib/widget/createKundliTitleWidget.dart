import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class CreateKundliTitleWidget extends StatelessWidget {
  final String title;
  const CreateKundliTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Get.textTheme.headline5);
  }
}
