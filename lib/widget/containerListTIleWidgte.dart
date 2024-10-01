import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class ContainerListTileWidget extends StatelessWidget {
  final Color color;
  final String doshText;
  final String title;
  final String subTitle;
  const ContainerListTileWidget({Key? key, required this.title, required this.subTitle, required this.doshText, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        leading: CircleAvatar(
          radius: 40,
          backgroundColor: color,
          child: Text(
            doshText,
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(title, style: title == '' ? TextStyle(fontSize: 0) : Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500)),
        subtitle: Text(subTitle, style: Get.textTheme.bodySmall),
      ),
    );
  }
}
