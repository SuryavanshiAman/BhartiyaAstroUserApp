// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../model/dailyHoroscopeModel.dart';

class TimeWiseHoroscopeWidget extends StatelessWidget {
  final DailyscopeModel dailyHoroscopeModel;
  TimeWiseHoroscopeWidget({Key? key, required this.dailyHoroscopeModel}) : super(key: key);
  List title = ['Love and Relationship', 'Money and Finance', 'Career,Education,and Cuisiness', 'Health and Wllness', 'important dates', 'Tip of the month'];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Yearly Horoscope', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 3,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Divider(
                  color: Colors.black,
                  height: 10,
                  indent: 200,
                  endIndent: 10,
                ),
              ),
              Text(DateFormat('yyy').format(DateTime.now()), style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.grey)),
              const Expanded(
                child: Divider(
                  color: Colors.black,
                  height: 10,
                  indent: 200,
                  endIndent: 10,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          dailyHoroscopeModel.yearlyHoroScope == null
              ? const SizedBox()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dailyHoroscopeModel.yearlyHoroScope!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${dailyHoroscopeModel.yearlyHoroScope![index].title!}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                          future: global.showHtml(
                            html: dailyHoroscopeModel.yearlyHoroScope![index].description ?? '',
                          ),
                          builder: (context, snapshot) {
                            return snapshot.data ?? const SizedBox();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  })
        ],
      ),
    );
  }
}
