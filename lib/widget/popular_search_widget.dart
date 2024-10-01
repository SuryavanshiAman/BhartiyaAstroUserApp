import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class PopularSearchWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final void Function() onTap;
  const PopularSearchWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

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
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
              ),
              const SizedBox(width: 10),
              FittedBox(
                  child: Text(
                text,
                style: Get.textTheme.subtitle1,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
