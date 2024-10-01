import 'dart:io';

import 'package:BharatiyAstro/controllers/astrologyBlogController.dart';
import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/views/astroBlog/astrologyDetailScreen.dart';
import 'package:BharatiyAstro/views/astroBlog/search_astrologyBlog_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../../utils/images.dart';

class AstrologyBlogScreen extends StatelessWidget {
  const AstrologyBlogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
          title: Text(
            'Astrology Blog',
            style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => SearchAstrologyBlogScreen());
                },
                icon: Icon(
                  Icons.search,
                  color: Get.theme.iconTheme.color,
                ))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            BlogController blogController = Get.find<BlogController>();
            blogController.astrologyBlogs = [];
            blogController.astrologyBlogs.clear();
            blogController.isAllDataLoaded = false;
            blogController.update();
            await blogController.getAstrologyBlog("", false);
          },
          child: GetBuilder<BlogController>(builder: (blogController) {
            return ListView.builder(
                itemCount: blogController.astrologyBlogs.length,
                controller: blogController.blogScrollController,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () async {
                      HomeController homeController = Get.find<HomeController>();
                      global.showOnlyLoaderDialog(context);
                      await homeController.incrementBlogViewer(blogController.astrologyBlogs[index].id);
                      homeController.homeBlogVideo(blogController.astrologyBlogs[index].blogImage);
                      global.hideLoader();
                      Get.to(() => AstrologyBlogDetailScreen(
                            image: "${blogController.astrologyBlogs[index].blogImage}",
                            title: blogController.astrologyBlogs[index].title,
                            description: blogController.astrologyBlogs[index].description!,
                            extension: blogController.astrologyBlogs[index].extension ?? "",
                            controller: homeController.homeVideoPlayerController,
                          ));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                    child: blogController.astrologyBlogs[index].blogImage == ""
                                        ? Image.asset(
                                            Images.blog,
                                            height: 180,
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.fill,
                                          )
                                        : blogController.astrologyBlogs[index].extension == 'mp4' || blogController.astrologyBlogs[index].extension == 'gif'
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: '${global.imgBaseurl}${blogController.astrologyBlogs[index].previewImage}',
                                                    imageBuilder: (context, imageProvider) => Container(
                                                      height: 180,
                                                      width: Get.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: imageProvider,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                    errorWidget: (context, url, error) => Image.asset(
                                                      Images.blog,
                                                      height: 180,
                                                      width: Get.width,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.play_arrow,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: '${global.imgBaseurl}${blogController.astrologyBlogs[index].blogImage}',
                                                imageBuilder: (context, imageProvider) => Image.network(
                                                  "${global.imgBaseurl}${blogController.astrologyBlogs[index].blogImage}",
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
                                    right: 8,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.white.withOpacity(0.5),
                                          elevation: 0,
                                          minimumSize: const Size(50, 30), //height
                                          maximumSize: const Size(60, 30), //width
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.visibility,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "${blogController.astrologyBlogs[index].viewer}",
                                                style: TextStyle(fontSize: 12, color: Colors.black),
                                              ),
                                            )
                                          ],
                                        )),
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
                                      blogController.astrologyBlogs[index].title,
                                      style: Theme.of(context).primaryTextTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            blogController.astrologyBlogs[index].author,
                                            style: Theme.of(context).primaryTextTheme.subtitle2,
                                          ),
                                          Text(
                                            "${DateFormat("MMM d,yyyy").format(DateTime.parse(blogController.astrologyBlogs[index].createdAt))}",
                                            style: Theme.of(context).primaryTextTheme.subtitle2,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        blogController.isMoreDataAvailable == true && !blogController.isAllDataLoaded && blogController.astrologyBlogs.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                });
          }),
        ),
      ),
    );
  }
}
