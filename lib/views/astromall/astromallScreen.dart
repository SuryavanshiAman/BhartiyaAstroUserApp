import 'package:BharatiyAstro/controllers/astromallController.dart';
import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/astromall/astroProductScreen.dart';
import 'package:BharatiyAstro/views/searchAstrologerScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import '../../widget/commonAppbar.dart';

class AstromallScreen extends StatelessWidget {
  AstromallScreen({Key? key}) : super(key: key);
  final AstromallController astromallController = Get.find<AstromallController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Astromall',
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          astromallController.astroCategory.clear();
          astromallController.isAllDataLoaded = false;
          astromallController.update();
          await astromallController.getAstromallCategory(false);
        },
        child: GetBuilder<AstromallController>(builder: (c) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: astromallController.astromallCatScrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                astromallController.astroCategory.length >= 3
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ImageSlideshow(
                          width: double.infinity,
                          height: 150,
                          initialPage: 0,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                astromallController.astroProduct.clear();
                                astromallController.isAllDataLoadedForProduct = false;
                                astromallController.productCatId = astromallController.astroCategory[0].id;
                                astromallController.update();
                                global.showOnlyLoaderDialog(Get.context);
                                await astromallController.getAstromallProduct(astromallController.astroCategory[0].id, false);
                                global.hideLoader();
                                Get.to(() => AstroProductScreen(
                                      appbarTitle: astromallController.astroCategory[0].name,
                                      productCategoryId: astromallController.astroCategory[0].id,
                                      sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[0].categoryImage}",
                                    ));
                              },
                              child: CachedNetworkImage(
                                imageUrl: '${global.imgBaseurl}${astromallController.astroCategory[0].categoryImage}',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    height: Get.height * 0.2,
                                    width: Get.width,
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Card(
                                  child: Image.asset(
                                    Images.blog,
                                    height: Get.height * 0.15,
                                    width: Get.width,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                astromallController.astroProduct.clear();
                                astromallController.isAllDataLoadedForProduct = false;
                                astromallController.productCatId = astromallController.astroCategory[1].id;
                                astromallController.update();
                                global.showOnlyLoaderDialog(Get.context);
                                await astromallController.getAstromallProduct(astromallController.astroCategory[1].id, false);
                                // astromallController.imageList = astromallController.astroCategory[1].extraImages;
                                global.hideLoader();
                                Get.to(() => AstroProductScreen(
                                      appbarTitle: astromallController.astroCategory[1].name,
                                      productCategoryId: astromallController.astroCategory[1].id,
                                      sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[1].categoryImage}",
                                      
                                    ));
                              },
                              child: CachedNetworkImage(
                                imageUrl: '${global.imgBaseurl}${astromallController.astroCategory[1].categoryImage}',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    height: Get.height * 0.2,
                                    width: Get.width,
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Card(
                                  child: Image.asset(
                                    Images.blog,
                                    height: Get.height * 0.15,
                                    width: Get.width,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                astromallController.astroProduct.clear();
                                astromallController.isAllDataLoadedForProduct = false;
                                astromallController.productCatId = astromallController.astroCategory[2].id;
                                astromallController.update();
                                global.showOnlyLoaderDialog(Get.context);
                                await astromallController.getAstromallProduct(astromallController.astroCategory[2].id, false);
                                global.hideLoader();
                                Get.to(() => AstroProductScreen(
                                      appbarTitle: astromallController.astroCategory[2].name,
                                      productCategoryId: astromallController.astroCategory[2].id,
                                      sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[2].categoryImage}",
                                    ));
                              },
                              child: CachedNetworkImage(
                                imageUrl: '${global.imgBaseurl}${astromallController.astroCategory[2].categoryImage}',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    height: Get.height * 0.2,
                                    width: Get.width,
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Card(
                                  child: Image.asset(
                                    Images.blog,
                                    height: Get.height * 0.15,
                                    width: Get.width,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : astromallController.astroCategory.length >= 2
                        ? ImageSlideshow(
                            width: double.infinity,
                            height: 150,
                            initialPage: 0,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  astromallController.astroProduct.clear();
                                  astromallController.isAllDataLoadedForProduct = false;
                                  astromallController.productCatId = astromallController.astroCategory[0].id;
                                  astromallController.update();
                                  global.showOnlyLoaderDialog(Get.context);
                                  await astromallController.getAstromallProduct(astromallController.astroCategory[0].id, false);
                                  global.hideLoader();
                                  Get.to(() => AstroProductScreen(
                                        appbarTitle: astromallController.astroCategory[0].name,
                                        productCategoryId: astromallController.astroCategory[0].id,
                                        sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[0].categoryImage}",
                                      ));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: '${global.imgBaseurl}${astromallController.astroCategory[0].categoryImage}',
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width,
                                      margin: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider,
                                        ),
                                      ),
                                    );
                                  },
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Card(
                                    child: Image.asset(
                                      Images.blog,
                                      height: Get.height * 0.15,
                                      width: Get.width,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  astromallController.astroProduct.clear();
                                  astromallController.isAllDataLoadedForProduct = false;
                                  astromallController.productCatId = astromallController.astroCategory[1].id;
                                  astromallController.update();
                                  global.showOnlyLoaderDialog(Get.context);
                                  await astromallController.getAstromallProduct(astromallController.astroCategory[1].id, false);
                                  global.hideLoader();
                                  Get.to(() => AstroProductScreen(
                                        appbarTitle: astromallController.astroCategory[1].name,
                                        productCategoryId: astromallController.astroCategory[1].id,
                                        sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[1].categoryImage}",
                                      ));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: '${global.imgBaseurl}${astromallController.astroCategory[1].categoryImage}',
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      height: Get.height * 0.2,
                                      width: Get.width,
                                      margin: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider,
                                        ),
                                      ),
                                    );
                                  },
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Card(
                                    child: Image.asset(
                                      Images.blog,
                                      height: Get.height * 0.15,
                                      width: Get.width,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : astromallController.astroCategory.length >= 1
                            ? ImageSlideshow(
                                width: double.infinity,
                                height: 150,
                                initialPage: 0,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      astromallController.astroProduct.clear();
                                      astromallController.isAllDataLoadedForProduct = false;
                                      astromallController.productCatId = astromallController.astroCategory[0].id;
                                      astromallController.update();
                                      global.showOnlyLoaderDialog(Get.context);
                                      await astromallController.getAstromallProduct(astromallController.astroCategory[0].id, false);
                                      global.hideLoader();
                                      Get.to(() => AstroProductScreen(
                                            appbarTitle: astromallController.astroCategory[0].name,
                                            productCategoryId: astromallController.astroCategory[0].id,
                                            sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[0].categoryImage}",
                                          ));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: '${global.imgBaseurl}${astromallController.astroCategory[0].categoryImage}',
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          height: Get.height * 0.2,
                                          width: Get.width,
                                          margin: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: imageProvider,
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Card(
                                        child: Image.asset(
                                          Images.blog,
                                          height: Get.height * 0.15,
                                          width: Get.width,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                InkWell(
                  onTap: () => Get.to(() => SearchAstrologerScreen()),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                      height: 40,
                      child: IgnorePointer(
                          child: FutureBuilder(
                              future: global.translatedText("Let's find what you're looking for..."),
                              builder: (context, snapshot) {
                                return TextField(
                                  decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Get.theme.iconTheme.color,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      ),
                                      hintText: snapshot.data,
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                                );
                              })),
                    ),
                  ),
                ),
                GetBuilder<AstromallController>(builder: (c) {
                  return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 250, childAspectRatio: 3 / 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: astromallController.astroCategory.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            global.showOnlyLoaderDialog(context);
                            astromallController.astroProduct.clear();
                            astromallController.isAllDataLoadedForProduct = false;
                            astromallController.productCatId = astromallController.astroCategory[index].id;
                            astromallController.update();
                            await astromallController.getAstromallProduct(astromallController.astroCategory[index].id, false);
                            global.hideLoader();
                            Get.to(() => AstroProductScreen(
                                  appbarTitle: astromallController.astroCategory[index].name,
                                  productCategoryId: astromallController.astroCategory[index].id,
                                  sliderImage: "${global.imgBaseurl}${astromallController.astroCategory[index].categoryImage}",
                                ));
                          },
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            height: 300,
                            padding: index == 1 ? EdgeInsets.all(0) : EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken,
                                ),
                                image: NetworkImage("${global.imgBaseurl}${astromallController.astroCategory[index].categoryImage}"),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: index == 1
                                ? Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              astromallController.astroCategory[index].name,
                                              textAlign: TextAlign.center,
                                              style: Get.textTheme.subtitle1!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                    ],
                                  )
                                : Text(
                                    astromallController.astroCategory[index].name,
                                    textAlign: TextAlign.center,
                                    style: Get.textTheme.subtitle1!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        );
                      });
                }),
                Center(
                  child: SizedBox(
                    width: 40,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: astromallController.astroCategory.length,
                        itemBuilder: (context, index) {
                          return astromallController.isMoreDataAvailable == true && !astromallController.isAllDataLoaded && astromallController.astroCategory.length - 1 == index ? const CircularProgressIndicator() : const SizedBox();
                        }),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
