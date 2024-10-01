import 'package:BharatiyAstro/views/kudali/kalsarpaDosha.dart';
import 'package:BharatiyAstro/views/kudali/manglikDosh.dart';
import 'package:BharatiyAstro/views/kudali/sadesatiDosha.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../../controllers/kundliController.dart';

class DoshaReport extends StatelessWidget {
  DoshaReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliController>(builder: (kundliController) {
      return SizedBox(
        height: 500,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: kundliController.doshaTab.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      kundliController.selectDoshaTab(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: kundliController.doshaTab[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                            border: Border.all(color: kundliController.doshaTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(kundliController.doshaTab[index].title, style: TextStyle(fontSize: 13))),
                    ),
                  );
                }),
          ),
          kundliController.doshaTab[0].isSelected
              ? const ManglikDosh()
              : kundliController.doshaTab[1].isSelected
                  ? KalsarpaDosha()
                  : SadesatiDosha()
        ]),
      );
    });
  }
}
