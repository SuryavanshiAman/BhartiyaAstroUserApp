import 'dart:io';

import 'package:BharatiyAstro/controllers/astrologyBlogController.dart';
import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:BharatiyAstro/views/astroBlog/astrologyDetailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../../model/home_Model.dart';
import '../../utils/images.dart';

class SearchAstrologyBlogScreen extends StatelessWidget {
  SearchAstrologyBlogScreen({Key? key}) : super(key: key);
  final BlogController blogController = Get.find<BlogController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          blogController.astrologySearchBlogs = <Blog>[];
          blogController.searchTextController.clear();
          blogController.update();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              onPressed: () {
                blogController.astrologySearchBlogs = <Blog>[];
                blogController.searchTextController.clear();
                blogController.update();
                Get.back();
              },
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
            title: GetBuilder<BlogController>(builder: (blogcontroller) {
              return FutureBuilder(
                  future: global.showDecorationHint(
                    hint: 'Search by Blog Title',
                    inputBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  builder: (context, snapshot) {
                    return TextField(
                      autofocus: true,
                      onChanged: (value) async {
                        if (value.length > 2) {
                          global.showOnlyLoaderDialog(context);
                          blogController.searchString = blogController.searchTextController.text;
                          blogController.astrologySearchBlogs = [];
                          blogController.astrologySearchBlogs.clear();
                          blogController.isAllDataLoadedForSearch = false;
                          blogController.update();
                          await blogController.getAstrologyBlog(blogController.searchTextController.text, false);
                          global.hideLoader();
                        }
                      },
                      controller: blogcontroller.searchTextController,
                      decoration: snapshot.data,
                    );
                  });
            }),
            actions: [
              GetBuilder<BlogController>(builder: (blogController) {
                return IconButton(
                    onPressed: () async {
                      global.showOnlyLoaderDialog(context);
                      blogController.searchString = blogController.searchTextController.text;
                      blogController.astrologySearchBlogs = [];
                      blogController.astrologySearchBlogs.clear();
                      blogController.isAllDataLoadedForSearch = false;
                      blogController.update();
                      await blogController.getAstrologyBlog(blogController.searchTextController.text, false);
                      global.hideLoader();
                    },
                    icon: Icon(
                      Icons.search,
                      color: Get.theme.iconTheme.color,
                    ));
              })
            ],
          ),
          body: GetBuilder<BlogController>(builder: (blogController) {
            return blogController.astrologySearchBlogs.isEmpty
                ? Center(
                    child: Text('Blogs not found'),
                  )
                : ListView.builder(
                    itemCount: blogController.astrologySearchBlogs.length,
                    controller: blogController.blogSearchScrollController,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: () async {
                          HomeController homeController = Get.find<HomeController>();
                          global.showOnlyLoaderDialog(context);
                          await homeController.incrementBlogViewer(blogController.astrologySearchBlogs[index].id);
                          homeController.homeBlogVideo(blogController.astrologySearchBlogs[index].blogImage);
                          global.hideLoader();
                          Get.to(() => AstrologyBlogDetailScreen(
                                image: "${blogController.astrologySearchBlogs[index].blogImage}",
                                title: blogController.astrologySearchBlogs[index].title,
                                description: blogController.astrologySearchBlogs[index].description!,
                                extension: blogController.astrologySearchBlogs[index].extension!,
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
                                        child: blogController.astrologySearchBlogs[index].blogImage == ""
                                            ? Image.asset(
                                                Images.blog,
                                                height: 180,
                                                width: MediaQuery.of(context).size.width,
                                                fit: BoxFit.fill,
                                              )
                                            : blogController.astrologySearchBlogs[index].extension == 'mp4' || blogController.astrologySearchBlogs[index].extension == 'gif'
                                                ? Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: '${global.imgBaseurl}${blogController.astrologySearchBlogs[index].previewImage}',
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
                                                    imageUrl: '${global.imgBaseurl}${blogController.astrologySearchBlogs[index].blogImage}',
                                                    imageBuilder: (context, imageProvider) => Image.network(
                                                      "${global.imgBaseurl}${blogController.astrologySearchBlogs[index].blogImage}",
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
                                                    "${blogController.astrologySearchBlogs[index].viewer}",
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
                                          blogController.astrologySearchBlogs[index].title,
                                          style: Theme.of(context).primaryTextTheme.bodyText1,
                                          textAlign: TextAlign.start,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                blogController.astrologySearchBlogs[index].author,
                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                              ),
                                              Text(
                                                "${DateFormat("MMM d,yyyy").format(DateTime.parse(blogController.astrologySearchBlogs[index].createdAt))}",
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
                            blogController.isMoreDataAvailableForSearch == true && !blogController.isAllDataLoadedForSearch && blogController.astrologySearchBlogs.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
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
