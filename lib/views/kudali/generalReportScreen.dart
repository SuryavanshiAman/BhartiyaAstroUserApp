import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class GeneralReport extends StatelessWidget {
  GeneralReport({
    Key? key,
  }) : super(key: key);
  final KundliController kundliController = Get.find<KundliController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 40,
          child: GetBuilder<KundliController>(builder: (c) {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: kundliController.reportTab.length,
                itemBuilder: (context, index) {
                  return GetBuilder<KundliController>(builder: (kundli) {
                    return InkWell(
                      onTap: () {
                        kundliController.selectTab(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: kundliController.reportTab[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                              border: Border.all(color: kundliController.reportTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(kundliController.reportTab[index].title, style: TextStyle(fontSize: 13))),
                      ),
                    );
                  });
                });
          }),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('${kundliController.generalDesc}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 14))
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
