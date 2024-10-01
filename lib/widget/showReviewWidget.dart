// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/utils/date_converter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../utils/images.dart';

class ShowReviewWidget extends StatelessWidget {
  int index;
  final String astologername;
  ShowReviewWidget({
    Key? key,
    required this.astologername,
    required this.index,
  }) : super(key: key);
  ReviewController reviewController = Get.find<ReviewController>();
  BottomNavigationController bottomController = Get.find<BottomNavigationController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      builder: (reviewController) {
        return reviewController.reviewList.isEmpty
            ? const SizedBox()
            : Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                child: reviewController.reviewList[index].profile == ""
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(Images.deafultUser),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: '${global.imgBaseurl}${reviewController.reviewList[index].profile}',
                                        imageBuilder: (context, imageProvider) {
                                          return CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: imageProvider,
                                          );
                                        },
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) {
                                          return CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Image.asset(
                                                Images.deafultUser,
                                                fit: BoxFit.fill,
                                                height: 50,
                                              ));
                                        },
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(reviewController.reviewList[index].name != '' &&
                                          // ignore: unnecessary_null_comparison
                                          reviewController.reviewList[index].name != null
                                      ? reviewController.reviewList[index].name
                                      : 'Unknown')
                                  
                            ],
                          ),
                          PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                              onSelected: (value) async {
                                bool isLogin = await global.isLogin();
                                if (isLogin) {
                                  if (value == 'block') {
                                    global.showOnlyLoaderDialog(context);
                                    reviewController.blockAstrologerReview(reviewController.reviewList[index].id!, 1, null);
                                    global.hideLoader();
                                  } else {
                                    global.showOnlyLoaderDialog(context);
                                    reviewController.blockAstrologerReview(reviewController.reviewList[index].id!, null, 1);
                                    global.hideLoader();
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Text('Report review'),
                                      value: 'report',
                                    ),
                                    PopupMenuItem(
                                        child: Text(
                                          'Block review',
                                          style: Get.textTheme.subtitle1!.copyWith(
                                            color: Colors.red,
                                          ),
                                        ),
                                        value: 'block'),
                                  ])
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RatingBar(
                            initialRating: reviewController.reviewList[index].rating,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemSize: 15,
                            ignoreGestures: true,
                            ratingWidget: RatingWidget(
                              full: const Icon(Icons.grade, color: Colors.yellow),
                              half: const Icon(Icons.star_half, color: Colors.yellow),
                              empty: const Icon(Icons.grade, color: Colors.grey),
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(DateConverter.isoStringToLocalDateOnly(reviewController.reviewList[index].updatedAt.toIso8601String()), style: Get.textTheme.subtitle1!.copyWith(color: Colors.grey, fontSize: 10))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(reviewController.reviewList[index].review, style: Get.textTheme.subtitle1!.copyWith(fontSize: 13)),
                      reviewController.reviewList[index].reply == ""
                          ? const SizedBox()
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 245, 239, 239),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(astologername, style: Get.textTheme.subtitle1!.copyWith(fontSize: 16)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(reviewController.reviewList[index].reply, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12))
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
