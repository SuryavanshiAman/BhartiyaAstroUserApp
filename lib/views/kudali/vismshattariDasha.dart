import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

class VismshattariDasha extends StatelessWidget {
  VismshattariDasha({Key? key, this.userDetails}) : super(key: key);
  final KundliModel? userDetails;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<KundliController>(builder: (kundliController) {
        return ListView(
          shrinkWrap: true,
          children: [
            (kundliController.vimshattariList!.isNotEmpty)
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        (kundliController.vimshattariList!.length >= 1) ? stapper(controller: kundliController, index: 0) : SizedBox(),
                        (kundliController.vimshattariList!.length >= 2) ? stapper(controller: kundliController, index: 1) : SizedBox(),
                        (kundliController.vimshattariList!.length >= 3) ? stapper(controller: kundliController, index: 2) : SizedBox(),
                        (kundliController.vimshattariList!.length >= 4) ? stapper(controller: kundliController, index: 3) : SizedBox(),
                        (kundliController.vimshattariList!.length >= 5) ? stapper(controller: kundliController, index: 4) : SizedBox(),
                        (kundliController.vimshattariList!.length >= 6) ? stapper(controller: kundliController, index: 5) : SizedBox(),
                      ],
                    ),
                  )
                : SizedBox(),
            kundliController.vimshattariList!.isEmpty
                ? const SizedBox()
                : Container(
                    width: Get.width,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 122,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 248, 242, 205),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                              ),
                              child: SizedBox(height: 50, width: 100, child: Center(child: Text('Planet', textAlign: TextAlign.center))),
                            ),
                            Container(
                              width: 122,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 242, 205),
                                  border: Border(
                                    top: BorderSide(color: Colors.grey),
                                  )),
                              child: SizedBox(height: 50, width: 100, child: Center(child: Text('Start Date', textAlign: TextAlign.center))),
                            ),
                            Expanded(
                              child: Container(
                                width: 123,
                                decoration: BoxDecoration(color: Color.fromARGB(255, 248, 242, 205), border: Border.all(color: Colors.grey), borderRadius: BorderRadius.only(topRight: Radius.circular(10))),
                                child: SizedBox(height: 50, width: 100, child: Center(child: Text('End Date', textAlign: TextAlign.center))),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: kundliController.vimshattariList!.last.length,
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (kundliController.vimshattariList!.length < 6) {
                                    DateTime dateBasic = userDetails!.birthDate;
                                    int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                                    int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                                    int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                                    int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                                    int formattedMint = int.parse(DateFormat('mm').format(dateBasic));
                                    global.showOnlyLoaderDialog(context);
                                    kundliController.prefix = "${kundliController.prefix}${kundliController.vimshattariList!.last[index].planet!.substring(0, 2).toUpperCase()}-";
                                    if (kundliController.vimshattariList!.length == 1) {
                                      await kundliController.getAntardashaDetail(antarName: kundliController.vimshattariList![index].last.planet, day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                                      kundliController.update();
                                    } else if (kundliController.vimshattariList!.length == 2) {
                                      await kundliController.getPatyantarDashaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                                      kundliController.update();
                                    } else if (kundliController.vimshattariList!.length == 3) {
                                      await kundliController.getSookshmaDashaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                                      kundliController.update();
                                    } else if (kundliController.vimshattariList!.length == 4) {
                                      await kundliController.getPranaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: userDetails!.latitude, lon: userDetails!.longitude, tzone: userDetails!.timezone);
                                      kundliController.update();
                                    }
                                    global.hideLoader();
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 122,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: SizedBox(height: 50, width: 100, child: Center(child: Text("${kundliController.prefix}${kundliController.vimshattariList!.last[index].planet!.substring(0, 2).toUpperCase()}", textAlign: TextAlign.center))),
                                    ),
                                    Container(
                                      width: 122,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: SizedBox(height: 50, width: 100, child: Center(child: Text(kundliController.vimshattariList!.last[index].start!.split(' ')[0], textAlign: TextAlign.center))),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 123,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: Colors.grey),
                                            top: BorderSide(color: Colors.grey),
                                            right: BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                        child: SizedBox(
                                            height: 50,
                                            width: 100,
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(kundliController.vimshattariList!.last[index].end!.split(' ')[0], textAlign: TextAlign.center),
                                                Icon(
                                                  Icons.arrow_forward_ios_rounded,
                                                  size: 10,
                                                )
                                              ],
                                            ))),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }))
                      ],
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      }),
    );
  }

  Widget stapper({required int index, required KundliController controller}) {
    try {
      String text = '';

      if (index == 0) {
        text = 'Mahadasha';
      } else if (index == 1) {
        text = ' > AntarDasha';
      } else if (index == 2) {
        text = ' > PatyantarDsha';
      } else if (index == 3) {
        text = ' > SookshmaDasha';
      } else if (index == 4) {
        text = ' > Prana';
      } else if (index == 5) {
        text = ' > Deha';
      }
      return GestureDetector(
          onTap: () {
            try {
              for (int i = index; i < controller.vimshattariList!.length; i++) {
                controller.vimshattariList!.removeLast();
              }
              controller.update();
            } catch (ex) {
              print("Exception in onTap: ${ex.toString()}");
            }
          },
          child: Text(text));
    } catch (e) {
      print("Exception in stapper: ${e.toString()}");
      return SizedBox();
    }
  }
}
