// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/dropDownController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownWidget extends StatelessWidget {
  final List<String> item;
  final String? hint;
  final callId;
  DropDownWidget({Key? key, required this.item, this.hint, this.callId}) : super(key: key);
  DropDownController dropDownController = Get.find<DropDownController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DropDownController>(builder: (c) {
      return DropdownButton(
          isExpanded: true,
          underline: Container(
            height: 1,
            color: Get.theme.primaryColor,
          ),
          alignment: Alignment.bottomLeft,
          value: dropDownController.innitialValue(callId, item),
          hint: Text(hint ?? 'hint'),
          items: item.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      value,
                      style: Get.theme.primaryTextTheme.bodyText1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ));
          }).toList(),
          onChanged: (value) {
            if (callId == 1) {
              dropDownController.maritalStatusChoose(value!);
            }
            if (callId == 2) {
              dropDownController.languagetChoose(value!);
            }
            if (callId == 3) {
              dropDownController.topicChoose(value!);
            }
          });
    });
  }
}
