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

class AstrologerVideoScreen extends StatelessWidget {
  const AstrologerVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'Astrology Video',
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
          return RefreshIndicator(
            onRefresh: () async {
              await homeController.getAstrologyVideos();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: homeController.astrologyVideo.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () async {
                        global.showOnlyLoaderDialog(context);
                        await homeController.youtubPlay(homeController.astrologyVideo[index].youtubeLink);
                        global.hideLoader();
                        Get.to(() => BlogScreen(
                              title: 'Video',
                              link: homeController.astrologyVideo[index].youtubeLink,
                              controller: homeController.youtubePlayerController,
                              date: '${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}',
                              videoTitle: homeController.astrologyVideo[index].videoTitle,
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
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                    child: homeController.astrologyVideo[index].coverImage == ''
                                        ? Image.asset(
                                            Images.blog,
                                            height: 180,
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.fill,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: '${global.imgBaseurl}${homeController.astrologyVideo[index].coverImage}',
                                            imageBuilder: (context, imageProvider) => Image.network(
                                              "${global.imgBaseurl}${homeController.astrologyVideo[index].coverImage}",
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
                                  Positioned(
                                    bottom: 40,
                                    left: 120,
                                    child: Image.asset(
                                      Images.youtube,
                                      height: 120,
                                      width: 120,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      homeController.astrologyVideo[index].videoTitle,
                                      style: Theme.of(context).primaryTextTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}",
                                          style: Theme.of(context).primaryTextTheme.subtitle2!.copyWith(color: Colors.grey),
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
            ),
          );
        }),
      ),
    );
  }
}
