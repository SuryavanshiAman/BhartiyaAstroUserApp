import 'package:BharatiyAstro/controllers/homeController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:video_player/video_player.dart';
import '../../utils/images.dart';
import '../../widget/commonAppbar.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class AstrologyBlogDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String extension;
  final VideoPlayerController? controller;
  final VoidCallback? ontap;
  const AstrologyBlogDetailScreen({Key? key, this.ontap, this.controller, required this.extension, required this.title, required this.description, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: Stack(children: [
              CommonAppBar(
                title: 'Astrology Blog',
              ),
              Positioned(
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      global.createAndShareLinkForBloog(title);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              Images.whatsapp,
                              height: 40,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
                              child: Text('Share', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ])),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: image == ""
                        ? Image.asset(
                            Images.blog,
                            height: 230,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          )
                        : extension == "mp4" || extension == 'gif'
                            ? GetBuilder<HomeController>(builder: (homeController) {
                                return Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: SizedBox(
                                            height: 230,
                                            width: Get.width,
                                            child: VideoPlayer(controller!),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            homeController.blogplayPauseVideo(controller!);
                                          },
                                          child: Icon(
                                            controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    VideoProgressIndicator(
                                      controller!,
                                      allowScrubbing: true,
                                      colors: VideoProgressColors(backgroundColor: Colors.grey, playedColor: Colors.red),
                                    )
                                  ],
                                );
                              })
                            : CachedNetworkImage(
                                imageUrl: '${global.imgBaseurl}$image',
                                imageBuilder: (context, imageProvider) => Image.network(
                                  '${global.imgBaseurl}$image',
                                  height: 230,
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Image.asset(
                                  Images.blog,
                                  height: 230,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                              ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                    child: FutureBuilder(
                      future: global.showHtml(
                        html: description,
                      ),
                      builder: (context, snapshot) {
                        return snapshot.data ?? const SizedBox();
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
