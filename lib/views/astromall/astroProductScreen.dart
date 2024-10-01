import 'dart:developer';

import 'package:BharatiyAstro/views/astromall/productDetailScreen.dart';
import 'package:BharatiyAstro/views/searchByNameScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../controllers/astromallController.dart';
import '../../widget/commonAppbar.dart';

class AstroProductScreen extends StatelessWidget {
  final String appbarTitle;
  final String sliderImage;
  final int productCategoryId;
  AstroProductScreen(
      {Key? key,
      required this.appbarTitle,
      required this.sliderImage,
      required this.productCategoryId})
      : super(key: key);
  final AstromallController astromallController =
      Get.find<AstromallController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: appbarTitle,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => SearchByNameScreen(
                          productCategoryId: productCategoryId,
                        ));
                  },
                  icon: Icon(Icons.search, color: Colors.black))
            ],
          )),
      body: RefreshIndicator(
        onRefresh: () async {
          astromallController.astroProduct.clear();
          astromallController.isAllDataLoadedForProduct = false;
          astromallController.productCatId = productCategoryId;
          astromallController.update();
          await astromallController.getAstromallProduct(
              productCategoryId, false);
        },
        child: astromallController.astroProduct.isEmpty
            ? Center(
                child: Text('Product not available'),
              )
            : SingleChildScrollView(
                controller:
                    astromallController.astromallProductScrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<AstromallController>(builder: (c) {
                      return astromallController.astroProduct.length == 0
                          ? Center(
                              child: Text('Product not available'),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 3 / 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount:
                                  astromallController.astroProduct.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    global.showOnlyLoaderDialog(context);
                                    await astromallController.getproductById(
                                        astromallController
                                            .astroProduct[index].id);

                                    log('${astromallController.astroProductbyId[0].extraImages}');
                                    astromallController.images =
                                        astromallController
                                            .astroProductbyId[0].extraImages;
                                    astromallController.update();
                                    global.hideLoader();
                                    Get.to(() => ProductDetailScreen(
                                          index: index,
                                        ));
                                  },
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 300,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.4),
                                            BlendMode.darken),
                                        image: NetworkImage(
                                            "${global.imgBaseurl}${astromallController.astroProduct[index].productImage}"),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          astromallController
                                              .astroProduct[index].name,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style: Get.textTheme.subtitle1!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${astromallController.astroProduct[index].amount}/-',
                                                style: Get.textTheme.subtitle1!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 11)),
                                            SizedBox(
                                              height: 30,
                                              child: TextButton(
                                                  onPressed: () async {
                                                    global.showOnlyLoaderDialog(
                                                        context);
                                                    await astromallController
                                                        .getproductById(
                                                            astromallController
                                                                .astroProduct[
                                                                    index]
                                                                .id);
                                                    global.hideLoader();
                                                    Get.to(() =>
                                                        ProductDetailScreen(
                                                          index: index,
                                                        ));
                                                  },
                                                  child: Text(
                                                    'Buy',
                                                    style: Get
                                                        .textTheme.subtitle1!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 11),
                                                  ),
                                                  style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets.all(
                                                                0)),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                            RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    )),
                                                  )),
                                            )
                                          ],
                                        )
                                      ],
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
                            itemCount: astromallController.astroProduct.length,
                            itemBuilder: (context, index) {
                              return astromallController
                                              .isMoreDataAvailableForProduct ==
                                          true &&
                                      !astromallController
                                          .isAllDataLoadedForProduct &&
                                      astromallController.astroProduct.length -
                                              1 ==
                                          index
                                  ? const CircularProgressIndicator()
                                  : const SizedBox();
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
