import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

// ignore: must_be_immutable
class SadesatiDosha extends StatelessWidget {
  SadesatiDosha({Key? key}) : super(key: key);
  KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
        SizedBox(
          height: 10,
        ),
        Text('Sadesati Analysis', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              kundliController.isSadesati == null
                  ? Center(
                      child: Text('Sadesati Data Not Found'),
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: kundliController.isSadesati! ? Colors.red : Colors.green,
                          child: Text(
                            kundliController.isSadesati! ? 'Yes' : 'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Current Sadesati Status',
                          style: Get.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ]),
    );
  }
}
