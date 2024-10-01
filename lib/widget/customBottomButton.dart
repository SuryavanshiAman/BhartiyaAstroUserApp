import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class CustomBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomBottomButton({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Get.theme.primaryColor,
        height: 50,
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          title,
          style: Get.theme.textTheme.subtitle1!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
