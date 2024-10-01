import 'dart:io';

import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/blog_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class AstrologerNewsScreen extends StatelessWidget {
  const AstrologerNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'BharatiyAstro in News',
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
                itemCount: homeController.astroNews.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () async {
                      Get.to(() => BlogScreen(
                            link: homeController.astroNews[index].link,
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              child: homeController.astroNews[index].bannerImage == ''
                                  ? Image.asset(
                                      Images.blog,
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: '${global.imgBaseurl}${homeController.astroNews[index].bannerImage}',
                                      imageBuilder: (context, imageProvider) => Image.network(
                                        "${global.imgBaseurl}${homeController.astroNews[index].bannerImage}",
                                        height: 180,
                                        width: MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill,
                                      ),
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Image.asset(
                                        Images.blog,
                                        height: 180,
                                        width: MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    homeController.astroNews[index].description,
                                    style: Theme.of(context).primaryTextTheme.bodyText1,
                                    textAlign: TextAlign.start,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(homeController.astroNews[index].channel, style: Theme.of(context).primaryTextTheme.subtitle2!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal)),
                                          Text(
                                            "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astroNews[index].newsDate.toString()))}",
                                            style: Theme.of(context).primaryTextTheme.subtitle2!.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        }),
      ),
    );
  }
}
