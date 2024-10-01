import 'package:BharatiyAstro/model/geoCodingModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import '../model/astrologer_model.dart';
import '../model/astromall_product_model.dart';
import '../utils/services/api_helper.dart';

class SearchController extends GetxController {
  TextEditingController serachTextController = TextEditingController();
  FocusNode searchFnode = FocusNode();
  String searchText = "";
  int searchTabIndex = 0;
  String productSearchText = "";
  var geoCodingList = <GeoCodingModel>[];
  List<SearchModel> searchData = [
    SearchModel(title: 'Astrologer', isSelected: true),
    SearchModel(title: 'Astromall Products', isSelected: false),
  ];

  var astrologerList = <AstrologerModel>[];
  List astroProduct = <AstromallProductModel>[];
  List astroCategoryProduct = <AstromallProductModel>[];
  APIHelper apiHelper = APIHelper();
  ScrollController searchScrollController = ScrollController();

  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  String? searchString;
  ScrollController searchAstromallScrollController = ScrollController();
  int startIndexForAstromall = 0;
  bool isDataLoadedForAstromall = false;
  bool isAllDataLoadedForAstromall = false;
  bool isMoreDataAvailableForAstromall = false;

  selectSearchTab(int index) {
    searchData[index].isSelected = true;
    searchTabIndex = index;
    for (int i = 0; i < searchData.length; i++) {
      if (i == index) {
        continue;
      } else {
        searchData[i].isSelected = false;
        update();
      }
    }
    update();
  }

  @override
  void onInit() {
    paginateTask();
    super.onInit();
  }

  void paginateTask() {
    searchScrollController.addListener(() async {
      if (searchScrollController.position.pixels == searchScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        update();
        if (searchString != null || searchString != "") {
          print('Search astrologer String :- $searchString');
          await getSearchResult(searchString!, 'astrologer', true);
        }
      }
    });
    searchAstromallScrollController.addListener(() async {
      if (searchAstromallScrollController.position.pixels == searchAstromallScrollController.position.maxScrollExtent && !isAllDataLoadedForAstromall) {
        isMoreDataAvailableForAstromall = true;
        update();
        if (searchString != null || searchString != "") {
          print('Search astromall String :- $searchString');
          await getSearchResult(searchString!, 'astromall', true);
        }
      }
    });
  }
   bool isAllDataAstroLoaded = false;
  getSearchResult(String searchString, String? filter, bool isLazyLoading) async {
    try {
      // global.showOnlyLoaderDialog(Get.context);
      String filterKey = "";
      startIndex = 0;
      if (astrologerList.isNotEmpty) {
        startIndex = astrologerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      startIndexForAstromall = 0;
      if (astroProduct.isNotEmpty) {
        startIndexForAstromall = astroProduct.length;
      }
      if (!isLazyLoading) {
        isDataLoadedForAstromall = false;
      }
      if (searchTabIndex == 0) {
        filterKey = "astrologer";
        update();
      } else {
        filterKey = "astromall";
        update();
      }

      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.searchAstrologer(filter ?? filterKey, searchString, startIndex, fetchRecord).then((result) {
            isAllDataAstroLoaded = false;
            astrologerList.clear();
            if (result.status == "200") {
                  isAllDataAstroLoaded = true;
              if (filterKey == "astromall") {
                astroProduct.addAll(result.recordList);
                print('astromall search list length ${astroProduct.length} ');
                if (result.recordList.length == 0) {
                  isMoreDataAvailableForAstromall = false;
                  isAllDataLoadedForAstromall = true;
                }
              } else {
                astrologerList.addAll(result.recordList);
                print('astrologer search list length ${astrologerList.length} ');
                if (result.recordList.length == 0) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get kundli',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
      // global.hideLoader();
    } catch (e) {
      // global.hideLoader();
      print('Exception in getSearchResult():' + e.toString());
    }
  }

  getProductSearchResult(int productCategoryId, String searchString) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.searchProductByCategory(productCategoryId, searchString).then((result) {
            if (result.status == "200") {
              astroCategoryProduct = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Fail get product search result',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getProductSearchResult():' + e.toString());
    }
  }
}

class SearchModel {
  String title;
  bool isSelected;
  SearchModel({required this.title, required this.isSelected});
}
