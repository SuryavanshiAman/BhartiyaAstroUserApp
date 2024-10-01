import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/follow_astrologer_controller.dart';
import 'package:BharatiyAstro/widget/commonAppbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../controllers/reviewController.dart';
import '../utils/images.dart';
import 'astrologerProfile/astrologerProfile.dart';

class MyFollowingScreen extends StatelessWidget {
  const MyFollowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: CommonAppBar(
              title: 'Following',
            )),
        body: RefreshIndicator(
          onRefresh: () async {
            FollowAstrologerController followAstrologerController = Get.find<FollowAstrologerController>();
            followAstrologerController.followedAstrologer.clear();
            followAstrologerController.isAllDataLoaded = false;
            followAstrologerController.update();
            await followAstrologerController.getFollowedAstrologerList(false);
          },
          child: GetBuilder<FollowAstrologerController>(builder: (followAstrologerController) {
            return followAstrologerController.followedAstrologer.length == 0
                ? Center(
                    child: Text("You have not followed any astrologer yet!"),
                  )
                : ListView.builder(
                    itemCount: followAstrologerController.followedAstrologer.length,
                    controller: followAstrologerController.scrollController,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          Get.find<ReviewController>().getReviewData(followAstrologerController.followedAstrologer[index].id!);
                          global.showOnlyLoaderDialog(context);
                          BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                          await bottomNavigationController.getAstrologerbyId(followAstrologerController.followedAstrologer[index].id!);
                          global.hideLoader();
                          Get.to(() => AstrologerProfile(
                                index: index,
                              ));
                        },
                        child: Column(
                          children: [
                            Card(
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
                                                imageUrl: '${global.imgBaseurl}${followAstrologerController.followedAstrologer[index].profileImage}',
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
                                        followAstrologerController.followedAstrologer[index].totalOrder == 0 || followAstrologerController.followedAstrologer[index].totalOrder == null
                                            ? SizedBox()
                                            : Text(
                                                '${followAstrologerController.followedAstrologer[index].totalOrder} orders',
                                                style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 9,
                                                ),
                                              )
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${followAstrologerController.followedAstrologer[index].name}',
                                            ),
                                            Text(
                                              '${followAstrologerController.followedAstrologer[index].allSkill}',
                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '${followAstrologerController.followedAstrologer[index].languageKnown}',
                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              'Experience : ${followAstrologerController.followedAstrologer[index].experienceInYears} Years',
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
                                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 241, 234, 202)),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: BorderSide(
                                                  color: Get.theme.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            Get.dialog(
                                              AlertDialog(
                                                title: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Unfollow',
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                    ),
                                                    Text(
                                                      "Are you sure you want to unfollow ${followAstrologerController.followedAstrologer[index].name} ?",
                                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                                                    ),
                                                  ],
                                                ),
                                                content: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text('No')),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      flex: 4,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          global.showOnlyLoaderDialog(context);
                                                          await followAstrologerController.unFollowAstrologer(followAstrologerController.followedAstrologer[index].id!);
                                                          Get.back();
                                                          global.hideLoader();
                                                        },
                                                        child: Text('Yes'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Unfollow',
                                            style: Get.theme.primaryTextTheme.bodySmall,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            followAstrologerController.isMoreDataAvailable == true && !followAstrologerController.isAllDataLoaded && followAstrologerController.followedAstrologer.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                          ],
                        ),
                      );
                    },
                  );
          }),
        ));
  }
}
