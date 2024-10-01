import 'package:BharatiyAstro/model/home_Model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class BlogController extends GetxController {
  APIHelper apiHelper = APIHelper();
  final TextEditingController searchTextController = TextEditingController();
  var blogList = <Blog>[];
  var searchBlogList = <Blog>[];

  var astrologyBlogs = <Blog>[];
  var astrologySearchBlogs = <Blog>[];
  ScrollController blogScrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  ScrollController blogSearchScrollController = ScrollController();
  int startIndexForSearch = 0;
  bool isDataLoadedForSearch = false;
  bool isAllDataLoadedForSearch = false;
  bool isMoreDataAvailableForSearch = false;
  String? searchString;

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    paginateTask();
  }

  void paginateTask() {
    blogScrollController.addListener(() async {
      if (blogScrollController.position.pixels == blogScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        await getAstrologyBlog("", true);
      }
      update();
    });
    blogSearchScrollController.addListener(() async {
      if (blogSearchScrollController.position.pixels == blogSearchScrollController.position.maxScrollExtent && !isAllDataLoadedForSearch) {
        isMoreDataAvailableForSearch = true;
        if (searchString != null) {
          await getAstrologyBlog(searchString!, true);
        }
      }
      update();
    });
  }

  searchBlog(String kundliName) {
    List<Blog> result = [];
    if (kundliName.isEmpty) {
      result = blogList;
    } else {
      result = blogList.where((element) => element.title.toString().toLowerCase().contains(kundliName.toLowerCase())).toList();
    }
    searchBlogList = result;
    update();
  }

  getAstrologyBlog(String searchString, bool isLazyLoading) async {
    try {
      if (searchString == "") {
        startIndex = 0;
        if (astrologyBlogs.isNotEmpty) {
          startIndex = astrologyBlogs.length;
        }
        if (!isLazyLoading) {
          isDataLoaded = false;
        }
      } else {
        startIndexForSearch = 0;
        if (astrologySearchBlogs.isNotEmpty) {
          startIndexForSearch = astrologySearchBlogs.length;
        }
        if (!isLazyLoading) {
          isDataLoadedForSearch = false;
        }
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getBlog(searchString, searchString == "" ? startIndex : startIndexForSearch, fetchRecord).then((result) {
            if (result.status == "200") {
              if (searchString == "") {
                astrologyBlogs.addAll(result.recordList);
                print('astrology blog length ${astrologyBlogs.length}');
                if (result.recordList.length == 0) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
                update();
              } else {
                astrologySearchBlogs.addAll(result.recordList);
                print('astrology blog search length ${astrologySearchBlogs.length}');
                if (result.recordList.length == 0) {
                  isMoreDataAvailableForSearch = false;
                  isAllDataLoadedForSearch = true;
                }
                update();
              }
            } else {
              global.showToast(
                message: 'Failed to get Astrology Blog',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAstrologyBlog():' + e.toString());
    }
  }
}
