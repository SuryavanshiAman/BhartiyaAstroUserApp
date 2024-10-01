import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:BharatiyAstro/views/placeOfBrithSearchScreen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../widget/commonSmallTextFieldWidget.dart';

// ignore: must_be_immutable
class EditKundliScreen extends StatelessWidget {
  final int id;
  KundliModel? userDetails;
  EditKundliScreen({Key? key, required this.id, this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topLeft,
              colors: [Get.theme.primaryColor, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: GetBuilder<KundliController>(builder: (kundliController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back_ios,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Edit Kundli', style: Get.textTheme.subtitle1)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        CommonSmallTextFieldWidget(
                          controller: kundliController.editNameController,
                          titleText: "",
                          hintText: "Enter Name",
                          keyboardType: TextInputType.text,
                          preFixIcon: Icons.person_outline,
                          maxLines: 1,
                          onFieldSubmitted: (p0) {},
                          onTap: () {},
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.transgender,
                                color: Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: DropdownButton(
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    icon: SizedBox(),
                                    alignment: Alignment.bottomLeft,
                                    value: kundliController.innitialValue(1, ['Male', 'Female', 'Other']),
                                    hint: Text('hint'),
                                    items: ['Male', 'Female', 'Other'].map<DropdownMenuItem<String>>((String value) {
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
                                      kundliController.genderChoose(value!);
                                    }),
                              ),
                            ],
                          ),
                        ),
                        CommonSmallTextFieldWidget(
                          controller: kundliController.editBirthDateController,
                          titleText: "",
                          hintText: "Select Your Birth Date",
                          readOnly: true,
                          maxLines: 1,
                          preFixIcon: Icons.calendar_month,
                          onFieldSubmitted: (p0) {},
                          onTap: () {
                            _selectDate(context, kundliController);
                          },
                        ),
                        CommonSmallTextFieldWidget(
                          controller: kundliController.editBirthTimeController,
                          titleText: "",
                          hintText: "Select Your Birth Time",
                          readOnly: true,
                          maxLines: 1,
                          preFixIcon: Icons.schedule,
                          onFieldSubmitted: (p0) {},
                          onTap: () {
                            _boySelectBirthDateTime(context, kundliController);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CommonSmallTextFieldWidget(
                            controller: kundliController.editBirthPlaceController,
                            titleText: "",
                            hintText: "Select Your Birth Place",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: Icons.place,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              Get.to(() => PlaceOfBirthSearchScreen());
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
                            onPressed: () async {
                              global.showOnlyLoaderDialog(context);
                              await kundliController.updateKundliData(id);
                              global.hideLoader();
                              await kundliController.getKundliList();
                              Get.back();
                            },
                            child: Text(
                              'Update',
                              textAlign: TextAlign.center,
                              style: Get.theme.primaryTextTheme.subtitle1!.copyWith(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context, KundliController kundliController) async {
    // ignore: unused_local_variable
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(1994),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      dateFormat: "dd-MM-yyyy",
      itemTextStyle: Get.theme.textTheme.subtitle1!.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        wordSpacing: 2,
      ),
      titleText: 'Select Birth Date',
    );
    if (datePicked != null) {
      kundliController.editBirthDateController.text = formatDate(datePicked, [dd, '-', mm, '-', yyyy]);
      kundliController.pickedDate = datePicked;
      kundliController.update();
    }
  }

  Future _boySelectBirthDateTime(BuildContext context, KundliController kundliController) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.black),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onBackground: Colors.white,
            ),
          ),
          child: child ?? SizedBox(),
        );
      },
    );
    if (pickedTime != null) {
      print(pickedTime.format(context)); //output 10:51 PM
      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
      //converting to DateTime so that we can further format on different pattern.
      print(parsedTime); //output 1970-01-01 22:53:00.000
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      print(formattedTime); //output 14:59:00
      //DateFormat() is from intl package, you can format the time on any pattern you need.
      // kundliMatchingController.cBoysBirthTime.text = formattedTime; //set the value of text field.
      // kundliMatchingController.update();
      kundliController.editBirthTimeController.text = pickedTime.format(context);
    } else {
      print("Time is not selected");
    }
  }
}
