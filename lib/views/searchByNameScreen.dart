import 'dart:io';

import 'package:BharatiyAstro/controllers/astromallController.dart';
import 'package:BharatiyAstro/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import 'astromall/productDetailScreen.dart';

class SearchByNameScreen extends StatelessWidget {
  final int productCategoryId;
  const SearchByNameScreen({Key? key, required this.productCategoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Get.theme.iconTheme.color,
          ),
        ),
        title: GetBuilder<SearchController>(builder: (searchController) {
          return FutureBuilder(
              future: global.translatedText('Search by Name'),
              builder: (context, snapshot) {
                return TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    searchController.productSearchText = value;
                    if (value.length > 2) {
                      global.showOnlyLoaderDialog(context);
                      await searchController.getProductSearchResult(productCategoryId, value);
                      searchController.update();
                      global.hideLoader();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: snapshot.data,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                );
              });
        }),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Get.theme.iconTheme.color,
              ))
        ],
      ),
      body: GetBuilder<SearchController>(builder: (searchController) {
        return searchController.astroCategoryProduct.isEmpty && searchController.productSearchText != ""
            ? Center(
                child: Text('Product not available'),
              )
            : ListView.builder(
                itemCount: searchController.astroCategoryProduct.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      AstromallController astromallController = Get.find<AstromallController>();
                      global.showOnlyLoaderDialog(context);
                      await astromallController.getproductById(searchController.astroCategoryProduct[index].id);
                      global.hideLoader();
                      Get.to(() => ProductDetailScreen(
                            index: index,
                          ));
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 200,
                      padding: EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                          image: NetworkImage("${global.imgBaseurl}${searchController.astroCategoryProduct[index].productImage}"),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${searchController.astroCategoryProduct[index].name}",
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: Get.textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${searchController.astroCategoryProduct[index].amount} /-', style: Get.textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 11)),
                              SizedBox(
                                height: 28,
                                child: TextButton(
                                    onPressed: () async {
                                      AstromallController astromallController = Get.find<AstromallController>();
                                      global.showOnlyLoaderDialog(context);
                                      await astromallController.getproductById(searchController.astroCategoryProduct[index].id);
                                      global.hideLoader();
                                      Get.to(() => ProductDetailScreen(
                                            index: index,
                                          ));
                                    },
                                    child: Text(
                                      'Buy',
                                      style: Get.textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 11),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30.0),
                                      )),
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
