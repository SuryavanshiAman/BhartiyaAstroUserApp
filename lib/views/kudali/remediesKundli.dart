import 'package:BharatiyAstro/views/kudali/gemstonesDetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../../controllers/kundliController.dart';

class RemediesKundli extends StatelessWidget {
  RemediesKundli({Key? key}) : super(key: key);
  final KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliController>(builder: (c) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: kundliController.remediesTab.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      kundliController.selectRemediesTab(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: kundliController.remediesTab[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                            border: Border.all(color: kundliController.remediesTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(kundliController.remediesTab[index].title, style: TextStyle(fontSize: 13))),
                    ),
                  );
                }),
          ),
          GemstonesDetail()
        ],
      );
    });
  }
}
