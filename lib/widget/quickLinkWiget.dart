import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class QuickLinnkWidget extends StatelessWidget {
  final String image;
  final String text;
  final void Function() onTap;
  const QuickLinnkWidget({Key? key, required this.image, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 25,
              width: 25,
            ),
            SizedBox(
              height: 5,
            ),
            Center(
                child: Text(
              text,
              style: Get.textTheme.subtitle1!.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ))
          ],
        ),
      ),
    );
  }
}
