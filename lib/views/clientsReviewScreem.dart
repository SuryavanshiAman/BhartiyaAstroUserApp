import 'dart:io';

import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class ClientsReviewScreen extends StatelessWidget {
  const ClientsReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'Clients Testimonials',
            style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
        ),
        body: GetBuilder<HomeController>(builder: (homeController) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: homeController.clientReviews.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 4, right: 4, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            homeController.clientReviews[index].profile == ""
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Get.theme.primaryColor,
                                      image: DecorationImage(
                                        image: AssetImage(Images.deafultUser),
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: '${global.imgBaseurl}${homeController.clientReviews[index].profile}',
                                    imageBuilder: (context, imageProvider) => Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Get.theme.primaryColor,
                                        image: DecorationImage(
                                          image: NetworkImage("${global.imgBaseurl}${homeController.clientReviews[index].profile}"),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Get.theme.primaryColor,
                                        image: DecorationImage(
                                          image: AssetImage(Images.deafultUser),
                                        ),
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      // ignore: unnecessary_null_comparison
                                      (homeController.clientReviews[index].name != null && homeController.clientReviews[index].name != '') ? "${homeController.clientReviews[index].name}" : 'User',
                                      style: Get.theme.primaryTextTheme.subtitle2!.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${homeController.clientReviews[index].location}',
                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${homeController.clientReviews[index].review}",
                          maxLines: 6,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: Get.theme.primaryTextTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        }),
      ),
    );
  }
}
