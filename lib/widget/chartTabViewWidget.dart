import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/images.dart';

class ChartTabViewWidget extends StatelessWidget {
  final String text;
  final bool isDivional;
  const ChartTabViewWidget({Key? key, required this.text, this.isDivional = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliController>(builder: (kundliController) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: Get.textTheme.subtitle1,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    kundliController.northSouthUpdate(isNorth: true, isSouth: false);
                  },
                  child: Text(
                    'North Indian',
                    style: Get.textTheme.bodyText2,
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(6)),
                    backgroundColor: MaterialStateProperty.all(kundliController.isNorthIn ? Get.theme.primaryColor : Colors.grey),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {
                    kundliController.northSouthUpdate(isNorth: false, isSouth: true);
                  },
                  child: Text(
                    'South Indian',
                    style: Get.textTheme.bodyText2,
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(6)),
                    backgroundColor: MaterialStateProperty.all(kundliController.isSouthIn ? Get.theme.primaryColor : Colors.grey),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          isDivional
              ? SizedBox(
                  height: 30,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: kundliController.divisionalTab.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            kundliController.selectDivisionTab(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: kundliController.divisionalTab[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                                  border: Border.all(color: kundliController.divisionalTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(kundliController.divisionalTab[index].title, style: TextStyle(fontSize: 13))),
                          ),
                        );
                      }),
                )
              : SizedBox(),
          Container(
              height: 300,
              margin: EdgeInsets.all(17),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(kundliController.isNorthIn ? Images.southAstroChart : Images.southAstroChart), fit: BoxFit.cover),
                border: Border.all(color: Colors.black),
                //borderRadius: BorderRadius.circular(5),
              )),
          const Divider(
            color: Colors.grey,
          )
        ],
      );
    });
  }
}
