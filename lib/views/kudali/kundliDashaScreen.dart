import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:BharatiyAstro/views/kudali/vismshattariDasha.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../../controllers/kundliController.dart';

class KundliDashaScreen extends StatelessWidget {
  final KundliModel? userModel;
  KundliDashaScreen({
    this.userModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliController>(builder: (kundliController) {
      return Expanded(
        child: Column(
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
                  itemCount: kundliController.dashaTab.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        kundliController.selectDashaTab(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: kundliController.dashaTab[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                              border: Border.all(color: kundliController.dashaTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(kundliController.dashaTab[index].title, style: TextStyle(fontSize: 13))),
                      ),
                    );
                  }),
            ),
            VismshattariDasha(
              userDetails: userModel,
            )
          ],
        ),
      );
    });
  }
}
