import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/settings_controller.dart';
import 'package:BharatiyAstro/views/astrologerProfile/astrologerProfile.dart';
import 'package:BharatiyAstro/widget/commonAppbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../controllers/reviewController.dart';
import '../../utils/images.dart';

class BlockAstrologerScreen extends StatelessWidget {
  const BlockAstrologerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: CommonAppBar(
              title: 'Blocked Astrologer',
            )),
        body: RefreshIndicator(
          onRefresh: () async {
            SettingsController settingsController = Get.find<SettingsController>();
            await settingsController.getBlockAstrologerList();
          },
          child: GetBuilder<SettingsController>(builder: (settingsController) {
            return settingsController.blockedAstroloer.isEmpty
                ? Center(
                    child: Text("You have not Blocked any astrologer yet!"),
                  )
                : ListView.builder(
                    itemCount: settingsController.blockedAstroloer.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          Get.find<ReviewController>().getReviewData(settingsController.blockedAstroloer[index].id!);
                          global.showOnlyLoaderDialog(context);
                          BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                          print('block astrologer id ${settingsController.blockedAstroloer[index].astrologerId!}');
                          await bottomNavigationController.getAstrologerbyId(settingsController.blockedAstroloer[index].astrologerId!);
                          global.hideLoader();
                          Get.to(() => AstrologerProfile(
                                index: index,
                              ));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        height: 65,
                                        width: 65,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Get.theme.primaryColor)),
                                        child: CircleAvatar(
                                          radius: 35,
                                          backgroundColor: Colors.white,
                                          child: CachedNetworkImage(
                                            height: 55,
                                            width: 55,
                                            imageUrl: '${global.imgBaseurl}${settingsController.blockedAstroloer[index].profile}',
                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) => Image.asset(
                                              Images.deafultUser,
                                              fit: BoxFit.cover,
                                              height: 50,
                                              width: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    RatingBar.builder(
                                      initialRating: 0,
                                      itemCount: 5,
                                      allowHalfRating: false,
                                      itemSize: 15,
                                      ignoreGestures: true,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Get.theme.primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${settingsController.blockedAstroloer[index].astrologerName}',
                                        ),
                                        Text(
                                          '${settingsController.blockedAstroloer[index].allSkill}',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          '${settingsController.blockedAstroloer[index].languageKnown}',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'Experience : ${settingsController.blockedAstroloer[index].experienceInYears} Years',
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                        fixedSize: MaterialStateProperty.all(Size.fromWidth(90)),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Get.dialog(AlertDialog(
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Unblock",
                                                style: Get.textTheme.subtitle1,
                                              ),
                                              Text(
                                                "Are you sure you want to Unblock ${settingsController.blockedAstroloer[index].astrologerName} ?",
                                                style: Get.textTheme.bodyText2,
                                              ),
                                            ],
                                          ),
                                          contentPadding: const EdgeInsets.all(8),
                                          content: Row(
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text('No'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    global.showOnlyLoaderDialog(context);
                                                    await settingsController.unblockAstrologer(settingsController.blockedAstroloer[index].astrologerId!);
                                                    Get.back();
                                                    global.hideLoader();
                                                  },
                                                  child: Text('YES'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                      },
                                      child: Text(
                                        'Unblock',
                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }),
        ));
  }
}
