import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class TopServicesWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final void Function() onTap;
  const TopServicesWidget({Key? key, required this.icon, required this.text, required this.color, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(6),
          child: Row(
            children: [
              Icon(
                icon,
                size: 15,
              ),
              const SizedBox(width: 10),
              FittedBox(child: Text(text, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)))
            ],
          ),
        ),
      ),
    );
  }
}
