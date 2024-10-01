// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/views/astromall/addressScreen.dart';
import 'package:BharatiyAstro/views/imagePreview.dart';
import 'package:BharatiyAstro/widget/customBottomButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../controllers/astromallController.dart';
import '../../utils/date_converter.dart';
import '../../utils/images.dart';
import '../../widget/commonAppbar.dart';

class ProductDetailScreen extends StatelessWidget {
  final int index;
  ProductDetailScreen({Key? key, required this.index}) : super(key: key);

  final AstromallController astromallController =
      Get.find<AstromallController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AstromallController>(
      builder: (astromallController) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: CommonAppBar(
                title: 'Product details',
              )),
          bottomSheet: astromallController.isScrollable
              ? CustomBottomButton(
                  title: 'Book Now',
                  onTap: () async {
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      global.showOnlyLoaderDialog(context);
                      await astromallController.getUserAddressData(
                          global.sp!.getInt("currentUserId") ?? 0);
                      global.hideLoader();
                      Get.to(() => AddressScreen());
                      astromallController.update();
                    }
                  })
              : null,
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                astromallController.updateScroll(true);
                return true;
              } else if (scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.minScrollExtent) {
                astromallController.updateScroll(false);
                return false;
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ImagePreview(
                                  image:
                                      "${global.imgBaseurl}${astromallController.astroProductbyId[0].productImage}",
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              "${global.imgBaseurl}${astromallController.astroProductbyId[0].productImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    astromallController.images == ""
                        ? const SizedBox()
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: astromallController.images
                                  .split(',')
                                  .map((e) => InkWell(
                                        onTap: () {
                                          Get.to(() => ImagePreview(
                                                image: "${global.imgBaseurl}$e",
                                              ));
                                        },
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          margin: EdgeInsets.all(10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Image.network(
                                                  '${global.imgBaseurl}$e'),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(astromallController.astroProductbyId[0].name,
                        style: Get.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      astromallController.astroProductbyId[0].features,
                      style: Get.textTheme.subtitle1!
                          .copyWith(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Starting from:${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astromallController.astroProductbyId[0].amount}/-',
                      style: Get.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () async {
                          bool isLogin = await global.isLogin();
                          if (isLogin) {
                            global.showOnlyLoaderDialog(context);
                            await astromallController.getUserAddressData(
                                global.sp!.getInt("currentUserId") ?? 0);
                            global.hideLoader();
                            Get.to(() => AddressScreen());
                          }
                        },
                        child: Text(
                          'Book Now',
                          style: Get.textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 15),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    astromallController
                            .astroProductbyId[0].questionAnswer.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            itemCount: astromallController
                                .astroProductbyId[0].questionAnswer.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      astromallController.astroProductbyId[0]
                                          .questionAnswer[index].question,
                                      style: Get.textTheme.subtitle1!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      astromallController.astroProductbyId[0]
                                          .questionAnswer[index].answer,
                                      style: Get.textTheme.subtitle1!.copyWith(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                    SizedBox(
                      height: 10,
                    ),
                    astromallController
                            .astroProductbyId[0].productReview.isEmpty
                        ? const SizedBox()
                        : Center(
                            child: Text('Customer Testimonials'.toUpperCase(),
                                style: Get.textTheme.subtitle1!
                                    .copyWith(fontWeight: FontWeight.bold))),
                    astromallController
                            .astroProductbyId[0].productReview.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            itemCount: astromallController
                                .astroProductbyId[0].productReview.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                astromallController
                                                            .astroProductbyId[0]
                                                            .productReview[
                                                                index]
                                                            .profile ==
                                                        ""
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            AssetImage(Images
                                                                .deafultUser),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            '${global.imgBaseurl}${astromallController.astroProductbyId[0].productReview[index].profile}',
                                                        imageBuilder: (context,
                                                            imageProvider) {
                                                          return CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            backgroundImage:
                                                                imageProvider,
                                                          );
                                                        },
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child:
                                                                  Image.asset(
                                                                Images
                                                                    .deafultUser,
                                                                fit:
                                                                    BoxFit.fill,
                                                                height: 50,
                                                              ));
                                                        },
                                                      ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(astromallController
                                                        .astroProductbyId[0]
                                                        .productReview[index]
                                                        .userName ??
                                                    "Unkown")
                                              ],
                                            ),
                                            PopupMenuButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: Color.fromRGBO(
                                                      158, 158, 158, 1),
                                                ),
                                                onSelected: (value) async {
                                                  bool isLogin =
                                                      await global.isLogin();
                                                  if (isLogin) {
                                                    ReviewController
                                                        reviewController =
                                                        Get.find<
                                                            ReviewController>();
                                                    if (value == 'block') {
                                                      global
                                                          .showOnlyLoaderDialog(
                                                              context);
                                                      reviewController
                                                          .blockAstrologerReview(
                                                              astromallController
                                                                  .astroProductbyId[
                                                                      0]
                                                                  .productReview[
                                                                      index]
                                                                  .id!,
                                                              1,
                                                              null);
                                                      global.hideLoader();
                                                    } else {
                                                      global
                                                          .showOnlyLoaderDialog(
                                                              context);
                                                      reviewController
                                                          .blockAstrologerReview(
                                                              astromallController
                                                                  .astroProductbyId[
                                                                      0]
                                                                  .productReview[
                                                                      index]
                                                                  .id,
                                                              null,
                                                              1);
                                                      global.hideLoader();
                                                    }
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        value: 'report',
                                                        child: Text(
                                                            'Report review'),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 'block',
                                                        child: Text(
                                                            'Block review',
                                                            style: Get.textTheme
                                                                .subtitle1!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .red)),
                                                      )
                                                    ])
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: astromallController
                                                  .astroProductbyId[0]
                                                  .productReview[index]
                                                  .rating,
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
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                DateConverter
                                                    .isoStringToLocalDateOnly(
                                                        astromallController
                                                            .astroProductbyId[0]
                                                            .productReview[
                                                                index]
                                                            .updatedAt
                                                            .toIso8601String()),
                                                style: Get.textTheme.subtitle1!
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 10))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            '${astromallController.astroProductbyId[0].productReview[index].review}',
                                            style: Get.textTheme.subtitle1!
                                                .copyWith(fontSize: 13)),
                                        astromallController
                                                    .astroProductbyId[0]
                                                    .productReview[index]
                                                    .reply ==
                                                ""
                                            ? const SizedBox()
                                            : Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 245, 239, 239),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('Unknowen',
                                                            style: Get.textTheme
                                                                .subtitle1!
                                                                .copyWith(
                                                                    fontSize:
                                                                        15)),
                                                        Text(
                                                            DateConverter.isoStringToLocalDateOnly(
                                                                astromallController
                                                                    .astroProductbyId[
                                                                        0]
                                                                    .productReview[
                                                                        index]
                                                                    .updatedAt
                                                                    .toIso8601String()),
                                                            style: Get.textTheme
                                                                .subtitle1!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        '${astromallController.astroProductbyId[0].productReview[index].reply}',
                                                        style: Get.textTheme
                                                            .subtitle1!
                                                            .copyWith(
                                                                fontSize: 13))
                                                  ],
                                                ),
                                              )
                                      ]),
                                ),
                              );
                            }),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
