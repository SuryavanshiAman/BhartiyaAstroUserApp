import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:timelines/timelines.dart';

import '../../widget/commonAppbar.dart';

class AvailabilityScreen extends StatelessWidget {
  final String astrologerName;
  final String astrologerProfile;
  const AvailabilityScreen({Key? key, required this.astrologerName, required this.astrologerProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: CommonAppBar(
              title: astrologerName,
              isProfilePic: true,
              profileImg: astrologerProfile,
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<BottomNavigationController>(builder: (bottombarController) {
            return bottombarController.astrologerAvailavility.isEmpty
                ? Center(
                    child: Text('$astrologerName Not Set Available Time'),
                  )
                : ListView.builder(
                    itemCount: bottombarController.astrologerAvailavility.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: Get.width * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(bottombarController.astrologerAvailavility[index].day ?? "day"),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              DotIndicator(color: Colors.black),
                              SizedBox(
                                height: bottombarController.astrologerAvailavility[index].time!.isNotEmpty
                                    ? bottombarController.astrologerAvailavility[index].time!.length > 2
                                        ? 200.0
                                        : 100
                                    : 100,
                                child: SolidLineConnector(color: Colors.black),
                              )
                            ],
                          ),
                          bottombarController.astrologerAvailavility[index].time!.isEmpty
                              ? Container(
                                  width: Get.width * 0.45,
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Not Available',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : SizedBox(
                                  width: Get.width * 0.45,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: bottombarController.astrologerAvailavility[index].time!.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          padding: EdgeInsets.all(8),
                                          margin: const EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: (bottombarController.astrologerAvailavility[index].time![i].fromTime == null || bottombarController.astrologerAvailavility[index].time![i].toTime == null)
                                              ? Text(
                                                  'Not Available',
                                                  textAlign: TextAlign.center,
                                                )
                                              : Text(
                                                  '${bottombarController.astrologerAvailavility[index].time![i].fromTime} - ${bottombarController.astrologerAvailavility[index].time![i].toTime}',
                                                  textAlign: TextAlign.center,
                                                ),
                                        );
                                      }),
                                )
                        ],
                      );
                    });
          }),
        ));
  }
}
