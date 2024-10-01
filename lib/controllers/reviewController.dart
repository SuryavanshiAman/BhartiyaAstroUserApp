import 'package:BharatiyAstro/model/reviewModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:url_launcher/url_launcher.dart';

class ReviewController extends GetxController {
  APIHelper apiHelper = APIHelper();
  String? version;
  int? astrologerId;

  var reviewList = <ReviewModel>[];

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {
    // await getReviewData();
  }

  getReviewData(int id) async {
    try {
      await global.checkBody().then((result) async {
        reviewList = [];
        if (result) {
          await apiHelper.getReview(id).then((result) {
            if (result.status == "200") {
              reviewList = result.recordList;
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Failed to get review',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getReviewData():' + e.toString());
    }
  }

  onShareWhatsappTap() async {
    var whatsappAndroid = Uri.parse("whatsapp://send?phone=&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      global.showToast(
        message: 'Please install whatsapp first',
        textColor: global.textColor,
        bgColor: global.toastBackGoundColor,
      );
    }
  }

  Future<dynamic> blockAstrologerReview(int id, int? isBlocked, int? isReported) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.blockAstrologerProfileReview(id, isBlocked, isReported).then((result) async {
            if (result.status == "200") {
              if (astrologerId != null) {
                await getReviewData(astrologerId!);
              }
              if (isBlocked != null) {
                global.showToast(
                  message: 'Astrologer Review Blocked',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              } else {
                global.showToast(
                  message: 'Astrologer Review Reported',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            } else {
              global.showToast(
                message: ' Fail to block Astrologer Review',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in blockAstrologerReview :-" + e.toString());
    }
  }
}
