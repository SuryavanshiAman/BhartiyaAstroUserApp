import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

// ignore: must_be_immutable
class KundliNameWidget extends StatelessWidget {
  final KundliController kundliController;
  final VoidCallback onPressed;
  List<TextInputFormatter>? inputFormatters;
  KundliNameWidget({Key? key, required this.kundliController, required this.onPressed, this.inputFormatters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FutureBuilder(
              future: global.translatedText('User Name'),
              builder: (context, snapshot) {
                return TextField(
                  inputFormatters: inputFormatters,
                  controller: kundliController.userNameController,
                  onChanged: (text) {
                    kundliController.updateIsDisable();
                    kundliController.getName(text);
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintText: snapshot.data ?? '',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                );
              }),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
              backgroundColor: MaterialStateProperty.all(kundliController.isDisable ? Color.fromARGB(255, 209, 204, 204) : Get.theme.primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: kundliController.isDisable ? Colors.transparent : Colors.grey)),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Next',
              textAlign: TextAlign.center,
              style: Get.theme.primaryTextTheme.subtitle1!.copyWith(color: kundliController.isDisable ? Color.fromARGB(255, 100, 98, 98) : null),
            ),
          ),
        ),
      ],
    );
  }
}
