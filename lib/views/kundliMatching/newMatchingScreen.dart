// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:BharatiyAstro/views/placeOfBrithSearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../controllers/kundliMatchingController.dart';
import '../../widget/commonSmallTextFieldWidget.dart';

class NewMatchingScreen extends StatelessWidget {
  NewMatchingScreen({Key? key}) : super(key: key);
  final KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<KundliMatchingController>(
          init: kundliMatchingController,
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//-------------------------------------------Boys Details -----------------------------------------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Boy's Details",
                              style: Get.theme.primaryTextTheme.subtitle1,
                            ),
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cBoysName,
                            titleText: "Name",
                            hintText: "Enter Name",
                            keyboardType: TextInputType.text,
                            preFixIcon: Icons.person_outline,
                            maxLines: 1,
                            onFieldSubmitted: (p0) {},
                            onTap: () {},
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                            ],
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cBoysBirthDate,
                            titleText: "Birth Date",
                            hintText: "Select Your Birth Date",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: Icons.calendar_month,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _boySelectDate(context);
                            },
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cBoysBirthTime,
                            titleText: "Birth Time",
                            hintText: "Select Your Birth Time",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: Icons.schedule,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _boySelectBirthDateTime(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CommonSmallTextFieldWidget(
                              controller: kundliMatchingController.cBoysBirthPlace,
                              titleText: "Birth Place",
                              hintText: "Select Your Birth Place",
                              readOnly: true,
                              maxLines: 1,
                              preFixIcon: Icons.place,
                              onFieldSubmitted: (p0) {},
                              onTap: () {
                                Get.to(() => PlaceOfBirthSearchScreen(
                                      flagId: 1,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
//---------------------------------Girls Details--------------------------------------------------------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Girl's Details",
                              style: Get.theme.primaryTextTheme.subtitle1,
                            ),
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cGirlName,
                            titleText: "Name",
                            hintText: "Enter Name",
                            keyboardType: TextInputType.text,
                            preFixIcon: Icons.person_outline,
                            maxLines: 1,
                            onFieldSubmitted: (p0) {},
                            onTap: () {},
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                            ],
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cGirlBirthDate,
                            titleText: "Birth Date",
                            hintText: "Select Your Birth Date",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: Icons.calendar_month,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _girlSelectDate(context);
                            },
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cGirlBirthTime,
                            titleText: "Birth Time",
                            hintText: "Select Your Birth Time",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: Icons.schedule,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _girlSelectBirthDateTime(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CommonSmallTextFieldWidget(
                              controller: kundliMatchingController.cGirlBirthPlace,
                              titleText: "Birth Place",
                              hintText: "Select Your Birth Place",
                              readOnly: true,
                              maxLines: 1,
                              preFixIcon: Icons.place,
                              onFieldSubmitted: (p0) {},
                              onTap: () {
                                Get.to(() => PlaceOfBirthSearchScreen(
                                      flagId: 2,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Future _boySelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      kundliMatchingController.onBoyDateSelected(picked);
    }
  }

//Boy Select Birthdate Time
  Future _boySelectBirthDateTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onBackground: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      print(pickedTime.format(context)); //output 10:51 PM
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
      //converting to DateTime so that we can further format on different pattern.
      print(parsedTime); //output 1970-01-01 22:53:00.000
      String formattedTime = DateFormat('HH:mm aa').format(parsedTime);
      print(formattedTime); //output 14:59:00
      //DateFormat() is from intl package, you can format the time on any pattern you need.
      kundliMatchingController.cBoysBirthTime.text = formattedTime; //set the value of text field.
      kundliMatchingController.update();
    } else {
      print("Time is not selected");
    }
  }

  //Girl Date of Birth
  Future _girlSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      kundliMatchingController.onGirlDateSelected(picked);
    }
  }

//Girl Select Birthdate Time
  Future _girlSelectBirthDateTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onBackground: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      print(pickedTime.format(context)); //output 10:51 PM
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
      //converting to DateTime so that we can further format on different pattern.
      print(parsedTime); //output 1970-01-01 22:53:00.000
      String formattedTime = DateFormat('HH:mm:aa').format(parsedTime);
      print(formattedTime); //output 14:59:00
      //DateFormat() is from intl package, you can format the time on any pattern you need.
      kundliMatchingController.cGirlBirthTime.text = formattedTime; //set the value of text field.
      kundliMatchingController.update();
    } else {
      print("Time is not selected");
    }
  }
}
