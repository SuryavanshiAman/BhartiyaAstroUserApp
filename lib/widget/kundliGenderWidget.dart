import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class KundliGenderWidget extends StatelessWidget {
  final KundliController kundliController;

  const KundliGenderWidget({Key? key, required this.kundliController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GetBuilder<KundliController>(builder: (c) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                      child: InkWell(
                        onTap: () {
                          kundliController.updateBg(index);
                          kundliController.updateInitialIndex();
                          kundliController.updateIcon(kundliController.initialIndex);
                        },
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: kundliController.gender[index].isSelected ? Get.theme.primaryColor : Colors.white,
                          child: Image.asset(
                            kundliController.gender[index].image,
                            height: 70,
                            width: 70,
                          ),
                        ),
                      ),
                    ),
                    Text(kundliController.gender[index].title)
                  ],
                );
              });
            }),
      ),
    );
  }
}
