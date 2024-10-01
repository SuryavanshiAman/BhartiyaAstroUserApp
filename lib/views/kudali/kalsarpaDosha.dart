import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../../widget/containerListTIleWidgte.dart';

// ignore: must_be_immutable
class KalsarpaDosha extends StatelessWidget {
  KalsarpaDosha({Key? key}) : super(key: key);
  KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 10,
        ),
        Text('Kalsarpa Analysis', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        kundliController.isKalsarpa == null
            ? Center(
                child: Text('Kulsarpa dosha not available'),
              )
            : ContainerListTileWidget(
                title: 'Kalsarpa',
                subTitle: kundliController.isKalsarpa! ? 'Kundli is not free from kalsarpa dosha' : 'Kundli is  free from kalsarpa dosha',
                doshText: kundliController.isKalsarpa! ? 'Yes' : 'No',
                color: kundliController.isKalsarpa! ? Colors.red : Colors.green,
              ),
      ]),
    );
  }
}
