// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/dailyHoroscopeController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/daily_horoscope/dailyHoroscopeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class DailyHoroscopeContainer extends StatelessWidget {
  final isFreeServices;
  final String? date;
  final String moodOfDay;
  final String? colorCode;
  final String? colorCode2;
  final String? luckyNumber;
  final String? luckyTime;
  // final zodiacImage;
  DailyHoroscopeContainer({Key? key, this.isFreeServices = false, this.date, this.luckyNumber, this.luckyTime, required this.moodOfDay, this.colorCode, this.colorCode2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //va = 0xFFF + v1.toInt();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage(Images.sky), fit: BoxFit.cover)),
        child: Column(children: [
          isFreeServices
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Divider(
                            thickness: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text('$date', style: Get.textTheme.subtitle1!.copyWith(color: Colors.white)),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Divider(
                            thickness: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Daily horoscope is ready!', style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      colorCode == null || colorCode == "" ? const SizedBox() : Text('Lucky Colour', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)),
                      SizedBox(
                        width: 25,
                      ),
                      moodOfDay == "" ? const SizedBox() : Text('Mood of day', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: colorCode != null ? Color(int.parse("FF$colorCode", radix: 16)) : Colors.transparent,
                        radius: 7,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text('$moodOfDay', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.red))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      luckyNumber == "" ? const SizedBox() : Text('Lucky Number', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)),
                      SizedBox(
                        width: 25,
                      ),
                      luckyTime == "" ? const SizedBox() : Text('Lucky Time', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(luckyNumber ?? '8', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)),
                      SizedBox(
                        width: 88,
                      ),
                      Text(luckyTime ?? '10AM', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white))
                    ],
                  )
                ],
              ),
              CachedNetworkImage(
                height: 80,
                width: 80,
                imageUrl: '${global.imgBaseurl}${global.hororscopeSignList.firstWhere((e) => e.isSelected).image}',
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.grid_view_rounded, size: 20),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          isFreeServices
              ? InkWell(
                  onTap: () async {
                    Get.find<DailyHoroscopeController>().selectZodic(0);
                    await Get.find<DailyHoroscopeController>().getHoroscopeList(horoscopeId: Get.find<DailyHoroscopeController>().signId);
                    Get.to(() => DailyHoroscopeScreen());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      Text('View Your Detailed Horoscope'),
                      CircleAvatar(
                          radius: 14,
                          backgroundColor: Color.fromARGB(255, 241, 239, 221),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.black,
                          ))
                    ]),
                  ),
                )
              : SizedBox()
        ]),
      ),
    );
  }
}
