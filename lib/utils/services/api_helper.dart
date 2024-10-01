// ignore_for_file: null_check_always_fails

import 'dart:convert';
import 'dart:developer';

import 'package:BharatiyAstro/model/amount_model.dart';
import 'package:BharatiyAstro/model/app_review_model.dart';
import 'package:BharatiyAstro/model/astrologerCategoryModel.dart';
import 'package:BharatiyAstro/model/astrologer_availability_model.dart';
import 'package:BharatiyAstro/model/astrologer_model.dart';
import 'package:BharatiyAstro/model/astromall_category_model.dart';
import 'package:BharatiyAstro/model/astromall_product_model.dart';
import 'package:BharatiyAstro/model/blocked_astrologe_model.dart';
import 'package:BharatiyAstro/model/counsellor_model.dart';
import 'package:BharatiyAstro/model/current_user_model.dart';
import 'package:BharatiyAstro/model/customer_support_model.dart';
import 'package:BharatiyAstro/model/dailyHoroscope_model.dart';
import 'package:BharatiyAstro/model/gift_model.dart';
import 'package:BharatiyAstro/model/help_and_support_model.dart';
import 'package:BharatiyAstro/model/help_support_question.dart';
import 'package:BharatiyAstro/model/help_support_subcat_model.dart';
import 'package:BharatiyAstro/model/home_Model.dart';
import 'package:BharatiyAstro/model/hororscopeSignModel.dart';
import 'package:BharatiyAstro/model/kundliBasicDetailMode.dart';
import 'package:BharatiyAstro/model/kundli_model.dart';
import 'package:BharatiyAstro/model/language.dart';
import 'package:BharatiyAstro/model/languageModel.dart';
import 'package:BharatiyAstro/model/live_asrtrologer_model.dart';
import 'package:BharatiyAstro/model/live_user_model.dart';
import 'package:BharatiyAstro/model/notifications_model.dart';
import 'package:BharatiyAstro/model/remote_host_model.dart';
import 'package:BharatiyAstro/model/reportTypeModel.dart';
import 'package:BharatiyAstro/model/reviewModel.dart';
import 'package:BharatiyAstro/model/skillModel.dart';
import 'package:BharatiyAstro/model/systemFlagModel.dart';
import 'package:BharatiyAstro/model/user_address_model.dart';
import 'package:BharatiyAstro/model/wait_list_model.dart';
import 'package:BharatiyAstro/utils/global.dart';
import 'package:BharatiyAstro/utils/services/api_result.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../../controllers/reviewController.dart';
import '../../model/assistant_model.dart';
import '../../model/astromallHistoryModel.dart';
import '../../model/customer_support_review_model.dart';
import '../../model/intake_model.dart';
import '../../model/login_model.dart';
import '../../model/phonePayModel.dart';

class APIHelper {
  // login & signup
  Future<dynamic> loginSignUp(LoginModel loginModel) async {
    try {
      print('this is fcm token header during login${global.getApiHeaders(false)}');
      final response = await http.post(
        Uri.parse('$baseUrl/loginAppUser'),
        body: json.encode(loginModel),
        headers: await global.getApiHeaders(false),
      );
       log("========================================>${loginModel.toJson()}");
      log("========================================>${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);

        log('token at login:- ${response.body}');
      } else if (response.statusCode == 400) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in loginSignUp():-" + e.toString());
    }
  }

  //validatesession api
  Future<dynamic> validateSession() async {
    try {
      print('$baseUrl/validateSession');
      final response = await http.post(
        Uri.parse("$baseUrl/validateSession"),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = CurrentUserModel.fromJson(json.decode(response.body)["recordList"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception - validateSession(): " + e.toString());
    }
  }

  Future<dynamic> getHororscopeSign() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getHororscopeSign"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            List<HororscopeSignModel>.from(json.decode(response.body)["recordList"].map((x) => HororscopeSignModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getHororscopeSign():' + e.toString());
    }
  }

  //Get API
  Future<dynamic> getCurrentUser() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getProfile"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        log("Current user ===============================================${response.body}");
        recordList = CurrentUserModel.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getCurrentUser:' + e.toString());
    }
  }

  Future<dynamic> getKundli() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getkundali"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<KundliModel>.from(json.decode(response.body)["recordList"].map((x) => KundliModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getHomeBanner() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Banner>.from(json.decode(response.body)["banner"].map((x) => Banner.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getHomeBanner():' + e.toString());
    }
  }

  Future<dynamic> getHomeOrder() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<TopOrder>.from(json.decode(response.body)["topOrders"].map((x) => TopOrder.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getHomeOrder():' + e.toString());
    }
  }

  Future<dynamic> getHomeBlog() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Blog>.from(json.decode(response.body)["blog"].map((x) => Blog.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getHomeBlog():' + e.toString());
    }
  }

  Future<dynamic> getAppReview() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/appReview/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"appId": 1}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AppReviewModel>.from(json.decode(response.body)["recordList"].map((x) => AppReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAppReview():' + e.toString());
    }
  }

  Future<dynamic> getAstroNews() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            List<AstrotalkInNews>.from(json.decode(response.body)["astrotalkInNews"].map((x) => AstrotalkInNews.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAstroNews():' + e.toString());
    }
  }

  Future<dynamic> getAstroVideos() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            List<AstrologyVideo>.from(json.decode(response.body)["astrologyVideo"].map((x) => AstrologyVideo.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAstroNews():' + e.toString());
    }
  }

  Future<dynamic> getAstrologer(
      {int? catId,
      String? sortingKey,
      List<int>? skills,
      List<int>? language,
      List<String>? gender,
      int? startIndex,
      int? fetchRecords}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/getAstrologer'),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "userId": global.user.id,
            "astrologerCategoryId": catId,
            "filterData": {"skills": skills, "languageKnown": language, "gender": gender},
            "sortBy": sortingKey,
            "startIndex": startIndex,
            "fetchRecord": fetchRecords,
          }));
      dynamic recordList;
      print('json body ${json.encode({
            "userId": global.user.id,
            "astrologerCategoryId": catId,
            "filterData": {"skills": skills, "languageKnown": language, "gender": gender},
            "sortBy": sortingKey,
            "startIndex": startIndex,
            "fetchRecord": fetchRecords,
          })}');
      // log("astrologers ============================${response.body}");
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json.decode(response.body)["recordList"].map((x) => AstrologerModel.fromJson(x)));
        print('astrologer length in API helper ${recordList.length}');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAstrologer():' + e.toString());
    }
  }

  Future<dynamic> checkUserAlreadyInChatReq({int? astorlogerId}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/checkChatSessionAvailable'),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "astrologerId": astorlogerId,
          }));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = false;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in checkUserAlreadyInChatReq():' + e.toString());
    }
  }

  Future<dynamic> checkUserAlreadyInCallReq({int? astorlogerId}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/checkCallSessionAvailable'),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "astrologerId": astorlogerId,
          }));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = false;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in checkUserAlreadyInCallReq():' + e.toString());
    }
  }

  Future<dynamic> checkUserVideoAlreadyInCallReq({int? astorlogerId}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/checkVideoCallSessionAvailable'),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "astrologerId": astorlogerId,
          }));
      dynamic recordList;

      print('check astrologer in Videocall .......${response.body}');
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = false;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in checkUserAlreadyInCallReq():' + e.toString());
    }
  }

  Future<dynamic> getTokenFromChannel({String? channelName}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/liveAstrologer/getToken'),
          headers: await global.getApiHeaders(true), body: json.encode({"channelName": "$channelName"}));
      dynamic recordList;
      if (response.statusCode == 200) {
        print("Token : " + json.decode(response.body)["recordList"]);
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getTokenFromChannel():' + e.toString());
    }
  }

  Future<dynamic> getWaitList(String channel) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/waitlist/get'), body: {
        "channelName": channel,
      });
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<WaitList>.from(json.decode(response.body)["recordList"].map((x) => WaitList.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getWaitList():' + e.toString());
    }
  }

  Future<dynamic> deleteFromWishList(int id) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/waitlist/delete'), body: {
        "id": id.toString(),
      });
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in deleteFromWishList():' + e.toString());
    }
  }

  Future<dynamic> addToWaitlist(
      {String? channel,
      String? userName,
      String? userProfile,
      int? userId,
      String? time,
      String? requestType,
      String? userFcmToken,
      int? astrologerId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/waitlist/add'),
        body: {
          "userName": userName != "" ? "$userName" : "User",
          "profile": userProfile != "" ? "$userProfile" : "",
          "time": "$time",
          "channelName": "$channel",
          "requestType": "$requestType",
          "userId": "$userId",
          "userFcmToken": userFcmToken != "" ? "$userFcmToken" : "",
          "status": "Pending",
          "astrologerId": "$astrologerId",
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in addToWaitlist():' + e.toString());
    }
  }

  Future<dynamic> updateStatusForWaitList({int? id, String? status}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/waitlist/updateStatus'),
        body: {
          "id": id.toString(),
          "status": "$status",
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in updateStatusForWaitList():' + e.toString());
    }
  }

  Future<dynamic> getSkill() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getSkill'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<SkillModel>.from(json.decode(response.body)["recordList"].map((x) => SkillModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getSkill():' + e.toString());
    }
  }

  Future<dynamic> getLanguage() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getLanguage'),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<LanguageModel>.from(json.decode(response.body)["recordList"].map((x) => LanguageModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getSkill():' + e.toString());
    }
  }

  Future<dynamic> getAstromallCategory(int startIndex, int fetchRecord) async {
    try {
      print('getastromallcategory API called');
      final response = await http.post(
        Uri.parse("$baseUrl/getproductCategory"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"startIndex": startIndex, "fetchRecord": fetchRecord}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstromallCategoryModel>.from(
            json.decode(response.body)["recordList"].map((x) => AstromallCategoryModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAstromallCategory():' + e.toString());
    }
  }

  Future<String> razorpayCreateWallet(
      {@required String? totalAmount,
      @required Map<String, String>? notes,
      @required String? razorpayKey,
      @required String? razorpaySecret}) async {
    try {
      String _razorpayOrderId;

      final response = await http.post(
        Uri.parse("https://api.razorpay.com/v1/orders"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " + base64.encode(utf8.encode("$razorpayKey:$razorpaySecret"))
        },
        body: json.encode({"amount": totalAmount, "currency": "INR", "notes": notes}),
      );
      log("${response.body}");
      if (response.statusCode == 200) {
        _razorpayOrderId = json.decode(response.body)["id"];
      } else {
        _razorpayOrderId = null!;
      }
      return _razorpayOrderId;
    } catch (e) {
      print("Exception - razorpayCreate(): " + e.toString());
      return null!;
    }
  }

  Future<dynamic> getAstromallProduct(int id, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstromallProduct"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"productCategoryId": "$id", "startIndex": startIndex, "fetchRecord": fetchRecord}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstromallProductModel>.from(
            json.decode(response.body)["recordList"].map((x) => AstromallProductModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAstromallProduct:' + e.toString());
    }
  }

  Future<dynamic> getProductById(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstromallProductById"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"id": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        log('product categary:-${response.body}');
        recordList = List<AstromallProductModel>.from(
            json.decode(response.body)["recordList"].map((x) => AstromallProductModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getProductById:' + e.toString());
    }
  }

  Future<dynamic> cancelAstromallOrder(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/userOrder/cancel"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstroMallHistoryModel>.from(
            json.decode(response.body)["recordList"].map((x) => AstroMallHistoryModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in cancleAstromallOrder:' + e.toString());
    }
  }

  Future<dynamic> getGift() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getGift"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<GiftModel>.from(json.decode(response.body)["recordList"].map((x) => GiftModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getGift:' + e.toString());
    }
  }

  Future<dynamic> getUserAddress(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getOrderAddress"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"userId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            List<UserAddressModel>.from(json.decode(response.body)["recordList"].map((x) => UserAddressModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getUserAddress:' + e.toString());
    }
  }

  Future<dynamic> getKundliById(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/Kundali/show/$id"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<KundliModel>.from(json.decode(response.body)["recordList"].map((x) => KundliModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getReview(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstrologerUserReview"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReviewModel>.from(json.decode(response.body)["recordList"].map((x) => ReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getReview():' + e.toString());
    }
  }

  Future<dynamic> getAstrologerCategory() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/activeAstrologerCategory"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerCategoryModel>.from(
            json.decode(response.body)["recordList"].map((x) => AstrologerCategoryModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getReview():' + e.toString());
    }
  }

  Future<dynamic> getReportType(String? searchString, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getReportType"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"searchString": searchString, "startIndex": startIndex, "fetchRecord": fetchRecord}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReportTypeModel>.from(json.decode(response.body)["recordList"].map((x) => ReportTypeModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getReportType():' + e.toString());
    }
  }

  Future<dynamic> getCounsellors(int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCounsellor"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "startIndex": startIndex,
          "fetchRecord": fetchRecord,
          "userId": global.user.id,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CounsellorModel>.from(json.decode(response.body)["recordList"].map((x) => CounsellorModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getCounsellors():' + e.toString());
    }
  }

  Future<dynamic> getFollowedAstrologer(int startIndex, int record) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/getFollower"),
          headers: await global.getApiHeaders(true),
          body: json.encode(
            {"startIndex": startIndex, "fetchRecord": record},
          ));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json.decode(response.body)["recordList"].map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getFollowedAstrologer():' + e.toString());
    }
  }

  Future<dynamic> getLiveAstrologer() async {
    try {
      final response = await http.post(
        headers: await global.getApiHeaders(true),
        Uri.parse("$baseUrl/liveAstrologer/get"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            List<LiveAstrologerModel>.from(json.decode(response.body)["recordList"].map((x) => LiveAstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getLiveAstrologer():' + e.toString());
    }
  }

  Future<dynamic> setRemoteId(int astroId, int remoteId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/addAstrohost"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": "$astroId",
          "hostId": "$remoteId",
        }),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: - setRemoteId(): " + e.toString());
    }
  }

  Future<dynamic> getRemoteId(int astroId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstrohost"),
        body: {
          "astrologerId": astroId.toString(),
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<RemoteHostModel>.from(json.decode(response.body)["recordList"].map((x) => RemoteHostModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getLiveAstrologer():' + e.toString());
    }
  }

//add API
  Future<dynamic> addKundli(List<KundliModel> basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"kundali": basicDetails}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addKundli:- ' + e.toString());
    }
  }

  Future<dynamic> addPlanetKundli(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/addForTrackPlanet'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addPlanetKundli:- ' + e.toString());
    }
  }

  Future<dynamic> addAddress(UserAddressModel basicDetails) async {
    try {
      print('address API :- $baseUrl/orderAddress/add');
      final response = await http.post(
        Uri.parse('$baseUrl/orderAddress/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print('json body ${json.encode(basicDetails)}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addAddress ' + e.toString());
    }
  }

  Future<dynamic> addAppFeedback(var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/appReview/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addAppFeedback:-' + e.toString());
    }
  }

  Future<dynamic> followAstrologer(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/follower/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'astrologerId': '$astrologerId'}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in followAstrologer ' + e.toString());
    }
  }

  Future<dynamic> viewerCount(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addBlogReader'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"blogId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in viewerCount ' + e.toString());
    }
  }

//update API
  Future<dynamic> updateUserProfile(int id, var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/update/$id'),
        headers: await global.getApiHeaders(true),
        body: jsonEncode(basicDetails),
      );
      print('edit profile body:- ${jsonEncode(basicDetails)}');
      log("==========================================================>${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updateUserProfile:-' + e.toString());
    }
  }

  Future<dynamic> updateKundli(int id, KundliModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updateKundli:-' + e.toString());
    }
  }

  Future<dynamic> updateAddress(int id, UserAddressModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orderAddress/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updateAddress:-' + e.toString());
    }
  }

  Future<dynamic> unFollowAstrologer(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/follower/update'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": "$astrologerId"}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updateAddress:-' + e.toString());
    }
  }

//delete API
  Future<dynamic> deleteUser(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/delete'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteUser : -" + e.toString());
    }
  }

  Future<dynamic> deleteKundli(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/delete'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteKundli : -" + e.toString());
    }
  }

//call Astrologer request API
  Future<dynamic> sendAstrologerCallRequest(int astrologerId, bool isFreeSession) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/callRequest/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'astrologerId': '$astrologerId', "isFreeSession": isFreeSession}),
      );
      dynamic recordList;
      log("response =============================================>${response.body}");
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in sendAstrologerCallRequest ' + e.toString());
    }
  }

  Future<dynamic> sendAstrologerVideoCallRequest(int astrologerId, bool isFreeSession) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/videocallRequest/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'astrologerId': '$astrologerId', "isFreeSession": isFreeSession}),
      );
      log('add vedio request==============================================>$response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in sendAstrologerCallRequest ' + e.toString());
    }
  }

  dynamic getAPIResult<T>(final response, T recordList) {
    try {
      dynamic result;
      result = APIResult.fromJson(json.decode(response.body), recordList);
      return result;
    } catch (e) {
      print("Exception - getAPIResult():" + e.toString());
    }
  }

//=------------------------------chat----------------->

  Future<dynamic> sendAstrologerChatRequest(int astrologerId, bool isFreeSession) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId, "isFreeSession": isFreeSession}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in sendAstrologerCallRequest ' + e.toString());
    }
  }

  Future<dynamic> saveChattingTime(int second, int chatId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/endChat'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'chatId': '$chatId', 'totalMin': '$second'}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in sendAstrologerCallRequest ' + e.toString());
    }
  }

  Future<dynamic> orderAdd(
      {int? productCatId,
      int? productId,
      int? addressId,
      double? amount,
      int? gst,
      String? paymentMethod,
      double? totalPay}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userOrder/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          'productCategoryId': productCatId,
          'productId': productId,
          'orderAddressId': addressId,
          'payableAmount': amount,
          'gstPercent': gst,
          'paymentMethod': paymentMethod,
          'totalPayable': totalPay
        }),
      );
      dynamic recordList;
      print('here is order Status ${response.body}');
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in orderAdd ' + e.toString());
    }
  }

  Future<dynamic> addAmountInWallet({
    required String paymentMode,
    required String paymentId,
    required String orderId,
    required String status,
    required double amount,
    required double tax,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addpayment'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          'paymentMode': paymentMode,
          'paymentReference': paymentId,
          'orderId': orderId,
          'paymentStatus': status,
          'amount': amount,
          'tax': tax
        }),
      );
      var k = {
        'paymentMode': paymentMode,
        'paymentReference': paymentId,
        'orderId': orderId,
        'paymentStatus': status,
        'amount': amount,
        'tax': tax
      };
      dynamic recordList;
      log("$k");
      print("payment Response ${response.body}");
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addAmountInWallet ' + e.toString());
    }
  }

  Future<String> makePayment(String mobileNumber, String amount) async {
    // should be dynamic
    final response = await http.post(
      Uri.parse('https://astro.kriscenttechnohub.com/api/paywithphonepe'),
      headers: await global.getApiHeaders(true),
      body: json.encode({'mobile': mobileNumber, 'amount': amount}),
    );

    print("=========================>${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  Future<dynamic> addStrip({required String status, required double amount, required String paymentId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addpayment'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          'paymentMode': 'Stripe',
          'paymentStatus': status,
          'amount': amount,
          'paymentReference': paymentId,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addStrip ' + e.toString());
    }
  }

  Future<dynamic> getAvailability(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstrologerAvailability"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"astrologerId": "$astrologerId"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerAvailibilityModel>.from(json.decode(response.body)["recordList"].map(
              (x) => AstrologerAvailibilityModel.fromJson(x),
            ));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> acceptChat(int chatId) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/chatRequest/accept'),
          headers: await global.getApiHeaders(true), body: json.encode({"chatId": chatId}));
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in acceptChat : -" + e.toString());
    }
  }

  Future<dynamic> logout() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/logout'), headers: await global.getApiHeaders(true));
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in acceptChat : -" + e.toString());
    }
  }

  Future<dynamic> rejectChat(int cid) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/chatRequest/rejectChatRequest'),
          headers: await global.getApiHeaders(true),
          body: json.encode(
            {"chatId": cid},
          ));
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> cutPaymentForLiveStream(int userId, int astrologerId, int timeInSecond, String transactionType, String chatId,
      {String? sId1, String? sId2, String? channelName}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/chatRequest/endLiveChat'),
          headers: await global.getApiHeaders(true),
          body: json.encode(
            {
              "userId": userId,
              "astrologerId": astrologerId,
              "totalMin": timeInSecond,
              "transactionType": "$transactionType Live Streaming",
              "chatId": chatId,
              "sId": sId1,
              "sId1": sId2,
              "channelName": channelName
            },
          ));
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print("payment succesffully done for live streaming");
        recordList = json.decode(response.body)["recordList"];
      } else {
        print("payment fail done for live streaming");
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> acceptCall(int callId) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/callRequest/acceptCallRequest'),
          headers: await global.getApiHeaders(true), body: json.encode({"callId": callId}));
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in acceptCall : -" + e.toString());
    }
  }

  Future<dynamic> rejectCall(int callId) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/callRequest/rejectCallRequest'),
          headers: await global.getApiHeaders(true),
          body: json.encode(
            {"callId": callId},
          ));
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> endCall(int callId, int second, String sId, String sId1) async {
    log("================================>$callId, secound:$second sId:$sId sid1:$sId1");
    try {
      final response = await http.post(Uri.parse('$baseUrl/callRequest/end'),
          headers: await global.getApiHeaders(true),
          body: json.encode(
            {
              "callId": callId,
              "totalMin": "$second",
              "sId": sId.toString(),
              // ignore: unnecessary_null_comparison
              "sId1": sId1 != null ? sId1.toString() : null,
            },
          ));
      log('===================================>endCall done : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in endCall : -" + e.toString());
    }
  }

  Future<dynamic> getHistory(int userId, int startIndex, int fetchRecord) async {
    try {
      print('history url:-  $baseUrl/getUserById');
      final response = await http.post(Uri.parse('$baseUrl/getUserById'),
          headers: await global.getApiHeaders(true),
          body: json.encode({"userId": userId, "startIndex": startIndex, "fetchRecord": fetchRecord}));
      log('history got here : ${response.body}');
      print('json body ${json.encode({"userId": userId, "startIndex": startIndex, "fetchRecord": fetchRecord})}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getHistory : -" + e.toString());
    }
  }

  Future<dynamic> getUpcomingList() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/liveAstrologer/getUpcomingAstrologer"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json.decode(response.body)["recordList"].map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getUpcomingList():' + e.toString());
    }
  }
  //Third Party API

  Future<dynamic> getAdvancedPanchang(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/advanced_panchang"),
        body: json.encode(
            {"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": 77.2090, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAdvancedPanchang():' + e.toString());
    }
  }

  Future<dynamic> getKundliBasicDetails(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/birth_details"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": "application/json"
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKundliBasicDetails():' + e.toString());
    }
  }

  Future<dynamic> getKundliBasicPanchangDetails(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/basic_panchang"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKundliBasicPanchangDetails():' + e.toString());
    }
  }

  Future<dynamic> getAvakhadaDetails(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/astro_details"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAvakhadaDetails():' + e.toString());
    }
  }

  Future<dynamic> getPlanetsDetail(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/planets"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json',
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAvakhadaDetails():' + e.toString());
    }
  }

  Future<dynamic> getSadesati(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sadhesati_current_status"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getSadesati():' + e.toString());
    }
  }

  Future<dynamic> getKalsarpa(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/kalsarpa_details"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKalsarpa():' + e.toString());
    }
  }

  Future<dynamic> getGemstone(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/basic_gem_suggestion"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getGemstone():' + e.toString());
    }
  }

  Future<dynamic> getVimshattari(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/major_vdasha"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getVimshattari():' + e.toString());
    }
  }

  Future<dynamic> getAntardasha(
      {String? antarDasha, int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_vdasha/$antarDasha"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAntardasha():' + e.toString());
    }
  }

  Future<dynamic> getPatynatarDasha(
      {String? firstName,
      String? secoundName,
      int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_sub_vdasha/Mars/Rahu"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getPatynatarDasha():' + e.toString());
    }
  }

  Future<dynamic> getSookshmaDasha(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_sub_sub_vdasha/Mars/Rahu/Jupiter"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getSookshmaDasha():' + e.toString());
    }
  }

  Future<dynamic> getPrana(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_sub_sub_sub_vdasha/Mars/Rahu/Jupiter/Saturn"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getPrana():' + e.toString());
    }
  }

  Future<dynamic> getMatching(int? dayBoy, int? monthBoy, int? yearBoy, int? hourBoy, int? minBoy, int? dayGirl, int? monthGirl,
      int? yearGirl, int? hourGirl, int? minGirl) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/match_ashtakoot_points"),
        body: json.encode({
          "m_day": dayBoy,
          "m_month": monthBoy,
          "m_year": yearBoy,
          "m_hour": hourBoy,
          "m_min": minBoy,
          "m_lat": 19.132,
          "m_lon": 72.342,
          "m_tzone": 5.5,
          "f_day": dayGirl,
          "f_month": monthGirl,
          "f_year": yearGirl,
          "f_hour": hourGirl,
          "f_min": minGirl,
          "f_lat": 19.132,
          "f_lon": 72.342,
          "f_tzone": 5.5
        }),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      print('Exception in getMatching():' + e.toString());
    }
  }

  Future<dynamic> getManglic(int? dayBoy, int? monthBoy, int? yearBoy, int? hourBoy, int? minBoy, int? dayGirl, int? monthGirl,
      int? yearGirl, int? hourGirl, int? minGirl) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/match_manglik_report"),
        body: json.encode({
          "m_day": dayBoy,
          "m_month": monthBoy,
          "m_year": yearBoy,
          "m_hour": hourBoy,
          "m_min": minBoy,
          "m_lat": 19.132,
          "m_lon": 72.342,
          "m_tzone": 5.5,
          "f_day": dayGirl,
          "f_month": monthGirl,
          "f_year": yearGirl,
          "f_hour": hourGirl,
          "f_min": minGirl,
          "f_lat": 19.132,
          "f_lon": 72.342,
          "f_tzone": 5.5
        }),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      print('Exception in getManglic():' + e.toString());
    }
  }

  //Search
  Future<dynamic> searchAstrologer(String filterKey, String searchString, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/searchAstro'),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "filterKey": filterKey,
          "searchString": searchString,
          "startIndex": startIndex,
          "fetchRecord": fetchRecord,
          "userId": global.user.id,
        }),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        if (filterKey == "astromall") {
          recordList = List<AstromallProductModel>.from(
              json.decode(response.body)["recordList"].map((x) => AstromallProductModel.fromJson(x)));
        } else {
          recordList =
              List<AstrologerModel>.from(json.decode(response.body)["recordList"].map((x) => AstrologerModel.fromJson(x)));
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> searchProductByCategory(int productCategoryId, String searchString) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/searchAstromallProductCategory'),
        headers: await global.getApiHeaders(false),
        body: json.encode({"productCategoryId": "$productCategoryId", "searchString": searchString}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstromallProductModel>.from(
            json.decode(response.body)["recordList"].map((x) => AstromallProductModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in rejectChat : -" + e.toString());
    }
  }

  //astrologer blog

  Future<dynamic> getBlog(String searchString, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAppBlog'),
        headers: await global.getApiHeaders(false),
        body: json.encode({"searchString": searchString, "startIndex": startIndex, "fetchRecord": fetchRecord}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Blog>.from(json.decode(response.body)["recordList"].map((x) => Blog.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getBlog : -" + e.toString());
    }
  }

  Future<dynamic> getAstrologerById(int astrologerId, int? userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAstrologerForCustomer'),
        headers: await global.getApiHeaders(false),
        body: json.encode({"astrologerId": astrologerId, "userId": userId}),
      );
      log('done : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json.decode(response.body)["recordList"].map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getAstrologerById : -" + e.toString());
    }
  }

  Future<dynamic> getReport(
      {int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/general_ascendant_report"),
        body: json
            .encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getReportDasha():' + e.toString());
    }
  }

  //report
  Future<dynamic> addReportIntakeDetail(var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReport/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      log('${response.statusCode}');
      log('report body :- ${json.encode(basicDetails)}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addReportIntakeDetail:- ' + e.toString());
    }
  }

  //astrologer  review
  Future<dynamic> addAstrologerReview(int astrologerId, double? rating, String? review, bool isPublic) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReview/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "rating": rating,
          "review": review,
          "astrologerId": astrologerId,
          "isPublic": isPublic,
        }),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addAstrologerReview:- ' + e.toString());
    }
  }

  Future<dynamic> getuserReview(int userId, int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAstrologerUserReview'),
        body: json.encode({"userId": "$userId", "astrologerId": "$astrologerId"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReviewModel>.from(json.decode(response.body)["recordList"].map((x) => ReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getuserReview : -" + e.toString());
    }
  }

  Future<dynamic> updateAstrologerReview(int id, var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReview/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updateAstrologerReview:- ' + e.toString());
    }
  }

  Future<dynamic> deleteReview(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReview/delete/$id'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteKundli : -" + e.toString());
    }
  }

  Future<dynamic> getHoroscope({int? horoscopeSignId}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getDailyHoroscope"),
        body: json.encode({"horoscopeSignId": horoscopeSignId}),
        headers: await global.getApiHeaders(true),
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getHoroscope():' + e.toString());
    }
  }

  //customer support chat
  Future<dynamic> getTickets(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getTicket'),
        body: json.encode({"userId": "$userId"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CustomerSuppportModel>.from(
            json.decode(response.body)["recordList"].map((x) => CustomerSuppportModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getTickets : -" + e.toString());
    }
  }

  Future<dynamic> geoCoding({double? lat, double? long}) async {
    try {
      final response = await http.post(
        Uri.parse('https://json.astrologyapi.com/v1/timezone_with_dst'),
        body: json.encode({"latitude": lat, "longitude": long}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in geoCoding : -" + e.toString());
    }
  }

  Future<dynamic> deleteTicket() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/deleteAll'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteTicket : -" + e.toString());
    }
  }

  Future<dynamic> deleteOneTicket(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/delete'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteOneTicket : -" + e.toString());
    }
  }

  Future<dynamic> getHelpAndSupport() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getHelpSupport'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            List<HelpAndSupportModel>.from(json.decode(response.body)["recordList"].map((x) => HelpAndSupportModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getTickets : -" + e.toString());
    }
  }

  Future<dynamic> getHelpAndSupportQuestion(int helpSupportId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getHelpSupportQuestion'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'helpSupportId': '$helpSupportId'}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HelpSupportQuestionModel>.from(
            json.decode(response.body)["recordList"].map((x) => HelpSupportQuestionModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getHelpAndSupportQuestion : -" + e.toString());
    }
  }

  Future<dynamic> getHelpAndSupportQuestionAnswer(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getHelpSupportSubSubCategory'),
        headers: await global.getApiHeaders(false),
        body: json.encode({'helpSupportQuationId': '$id'}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HelpAndSupportSubcatModel>.from(
            json.decode(response.body)["recordList"].map((x) => HelpAndSupportSubcatModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getHelpAndSupportQuestionAnswer : -" + e.toString());
    }
  }

  Future<dynamic> addCustomerSupportReview(String review, double rating, int ticketId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/addReview'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"review": "$review", "rating": "$rating", "ticketId": "$ticketId"}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addCustomerSupportReview:- ' + e.toString());
    }
  }

  Future<dynamic> editCustomerSupportReview(String review, double rating, int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/updateReview'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"review": "$review", "rating": "$rating", "id": "$id"}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in editCustomerSupportReview:- ' + e.toString());
    }
  }

  Future<dynamic> getCustomerSupportReview(int ticketId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/getReview'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"ticketId": "$ticketId"}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CustomerSupportReviewModel>.from(
            json.decode(response.body)["recordList"].map((x) => CustomerSupportReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getCustomerSupportReview : -" + e.toString());
    }
  }

  Future<dynamic> getTicketStatus() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkOpenTicket'),
        headers: await global.getApiHeaders(true),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in getTicketStatus:- ' + e.toString());
    }
  }

  //create ticket
  Future<dynamic> creaetTicket(CustomerSuppportModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in creaetTicket:- ' + e.toString());
    }
  }

  Future<dynamic> restratCustomerSupportChat(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/restart'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in restratCustomerSupportChat : -" + e.toString());
    }
  }

  //send astrologer gift
  Future<dynamic> sendGiftToAstrologer(int giftId, int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendGift'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"giftId": "$giftId", "astrologerId": "$astrologerId"}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in sendGiftToAstrologer:- ' + e.toString());
    }
  }

  //Notifications
  Future<dynamic> getNotifications() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getUserNotification'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            List<NotificationsModel>.from(json.decode(response.body)["recordList"].map((x) => NotificationsModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getTickets : -" + e.toString());
    }
  }

  Future<dynamic> deleteNotifications(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userNotification/deleteUserNotification'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteNotifications : -" + e.toString());
    }
  }

  Future<dynamic> deleteAllNotifications() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userNotification/deleteAllNotification'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteAllNotifications : -" + e.toString());
    }
  }

  //report and block astrologer
  Future<dynamic> reportAndBlockAstrologer(int astrologerId, String reason) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reportBlockAstrologer'),
        body: json.encode({"astrologerId": "$astrologerId", "reason": "$reason"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in reportAndBlockAstrologer : -" + e.toString());
    }
  }

  Future<dynamic> unblockAstrologer(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/unBlockAstrologer'),
        body: json.encode({"astrologerId": "$astrologerId"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in unblockAstrologer : -" + e.toString());
    }
  }

  Future<dynamic> getBlockAstrologer() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getBlockAstrologer'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<BlockedAstrologerModel>.from(
            json.decode(response.body)["recordList"].map((x) => BlockedAstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in reportAndBlockAstrologer : -" + e.toString());
    }
  }

  //agora cloud recording

  Future<dynamic> getResourceId(String cname, int uid) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/acquire'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({
          "cname": "$cname",
          "uid": "$uid",
          "clientRequest": {"region": "CN", "resourceExpiredHour": 24}
        }),
      );
      print('response $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in getResourceId:- ' + e.toString());
    }
  }

  Future<dynamic> agoraStartCloudRecording(String cname, int uid, String token) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId}/mode/mix/start'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({
          "cname": "$cname",
          "uid": "$uid",
          "clientRequest": {
            "token": "$token",
            "storageConfig": {
              "secretKey": "${global.getSystemFlagValue(global.systemFlagNameList.googleSecretKey)}",
              "vendor": 6,
              "region": 0,
              "bucket": "${global.getSystemFlagValue(global.systemFlagNameList.googleBucketName)}",
              "accessKey": "${global.getSystemFlagValue(global.systemFlagNameList.googleAccessKey)}"
            },
            "recordingConfig": {
              "channelType": 0,
              "streamTypes": 0,
            }
          }
        }),
      );
      print('response of start recording ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in agoraStartCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> agoraStartCloudRecording2(String cname, int uid, String token) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId2}/mode/mix/start'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({
          "cname": "$cname",
          "uid": "$uid",
          "clientRequest": {
            "token": "$token",
            "storageConfig": {
              "secretKey": "${global.getSystemFlagValue(global.systemFlagNameList.googleSecretKey)}",
              "vendor": 6,
              "region": 0,
              "bucket": "${global.getSystemFlagValue(global.systemFlagNameList.googleBucketName)}",
              "accessKey": "${global.getSystemFlagValue(global.systemFlagNameList.googleAccessKey)}"
            },
            "recordingConfig": {
              "channelType": 0,
              "streamTypes": 0,
            }
          }
        }),
      );
      print('response of start recording ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in agoraStartCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> agoraStopCloudRecording(String cname, int uid) async {
    print('api helper stop');
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId}/sid/${global.agoraSid1}/mode/mix/stop'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({"uid": "$uid", "cname": "$cname", "clientRequest": {}}),
      );
      print('response $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in agoraStopCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> agoraStopCloudRecording2(String cname, int uid) async {
    print('api helper stop');
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId2}/sid/${global.agoraSid2}/mode/mix/stop'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({"uid": "$uid", "cname": "$cname", "clientRequest": {}}),
      );
      print('response $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in agoraStopCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> stopRecoedingStoreData(int callId, String channelName, String sId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/storeCallRecording'),
        body: json.encode({"callId": "$callId", "channelName": "$channelName", "sId": "$sId"}),
        headers: await global.getApiHeaders(true),
      );
      print('done stopRecoedingStoreData: $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getLiveUsers : -" + e.toString());
    }
  }

  //intake form

  Future<dynamic> addIntakeDetail(IntakeModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/addIntakeForm'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addReportIntakeDetail:- ' + e.toString());
    }
  }

  Future<dynamic> getIntakedata() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/getIntakeForm'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<IntakeModel>.from(json.decode(response.body)["recordList"].map((x) => IntakeModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getIntakedata : -" + e.toString());
    }
  }

  //live user
  Future<dynamic> saveLiveUsers(LiveUserModel details) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addLiveUser'),
        body: json.encode(details),
        headers: await global.getApiHeaders(true),
      );
      print('done save live  : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getIntakedata : -" + e.toString());
    }
  }

  Future<dynamic> getLiveUsers(String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getLiveUser'),
        body: json.encode({"channelName": "$channelName"}),
        headers: await global.getApiHeaders(false),
      );
      print('done get live: $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<LiveUserModel>.from(json.decode(response.body)["recordList"].map((x) => LiveUserModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getLiveUsers : -" + e.toString());
    }
  }

  Future<dynamic> deleteLiveUsers() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteLiveUser'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteLiveUsers : -" + e.toString());
    }
  }

  //astrologer assistant chat

  Future<dynamic> storeAssistantFirebaseChatId(int userId, int partnerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAssistantChatId'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "customerId": userId,
          "astrologerId": partnerId,
          "senderId": userId,
          "receiverId": partnerId,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: - storeAssistantFirebaseChatId(): ' + e.toString());
    }
  }

  Future<dynamic> getAssistantChat() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAssistantChatHistory'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AssistantModel>.from(json.decode(response.body)["recordList"].map((x) => AssistantModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: - getAssistantChat(): ' + e.toString());
    }
  }

  Future<dynamic> deleteAssistantChat(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteAssistantChat'),
        headers: await global.getApiHeaders(true),
        body: json.encode(
          {
            "id": id.toString(),
          },
        ),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in deleteAssistantChat():' + e.toString());
    }
  }

  Future<dynamic> checkAstrologerPaidSession(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getCustomerPaidSession'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": "$astrologerId"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: - checkAstrologerPaidSession(): ' + e.toString());
    }
  }

  Future<dynamic> blockAstrologerAssistant(int assistantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/astrologerAssistant/block'),
        body: json.encode({"assistantId": "$assistantId"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in blockAstrologerAssistant : -" + e.toString());
    }
  }

  Future<dynamic> unblockAstrologerAssistant(int assistantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/astrologerAssistant/unBlock'),
        body: json.encode({"assistantId": "$assistantId"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in unblockAstrologerAssistant : -" + e.toString());
    }
  }

  //upcomming event search event

  Future<dynamic> liveEventSearch(String? searchString) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/searchLiveAstro"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"searchString": searchString}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json.decode(response.body)["recordList"].map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in liveEventSearch():' + e.toString());
    }
  }

//report and block astrologer profile review

  Future<dynamic> blockAstrologerProfileReview(int id, int? isBlocked, int? isReported) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/blockUserReview'),
        body: json.encode({"id": "$id", "isBlocked": isBlocked, "isReported": isReported}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        if (json.decode(response.body)["recordList"] != null) {
          ReviewController reviewController = Get.find<ReviewController>();
          reviewController.astrologerId = int.parse(json.decode(response.body)["recordList"].toString());
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in blockAstrologerProfileReview : -" + e.toString());
    }
  }

  //chnage online offile astrologer status

  Future<dynamic> changeStatus({int? astrologerId, String? status}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/addStatus"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId, "status": status, "waitTime": null}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:  - changeStatus(): ' + e.toString());
    }
  }

  Future<dynamic> changeCallStatus({int? astrologerId, String? status}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/addCallStatus"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId, "status": status, "waitTime": null}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:  - changeCallStatus(): ' + e.toString());
    }
  }

  //get call history by id
  Future<dynamic> getCallHistoryById(int callId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getCallById'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"callId": callId}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getCallHistoryById : -" + e.toString());
    }
  }

  Future<dynamic> updetUserProfilePic(String profile) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/updateProfile'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"profile": '$profile'}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updetUserProfilePic:-' + e.toString());
    }
  }

  Future<dynamic> getPlanetKundli() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/getForTrackPlanet"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<KundliModel>.from(json.decode(response.body)["recordList"].map((x) => KundliModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> deletePlanetKundli() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/removeFromTrackPlanet'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deletePlanetKundli : -" + e.toString());
    }
  }

  Future<dynamic> generateRtmToken(String agoraAppId, String agoraAppCertificate, String chatId, String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generateToken'),
        body: json.encode(
            {"appID": "$agoraAppId", "appCertificate": "$agoraAppCertificate", "user": "$chatId", "channelName": "$channelName"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in generateRtmToken : -" + e.toString());
    }
  }

  Future endLiveSession(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/liveAstrologer/endSession"),
        body: {"astrologerId": "$astrologerId"},
      );
      print('done deleted astrologerId -> $astrologerId : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: api_helper.dart - endLiveSession(): " + e.toString());
    }
  }

  Future getZodiacProfileImg() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getUserProfile"),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Zodic>.from(json.decode(response.body)["recordList"].map((x) => Zodic.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: api_helper.dart - getZodiacProfileImg(): " + e.toString());
    }
  }

  Future getSystemFlag() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getSystemFlag"),
      );
      print('here is flag list: ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<SystemFlag>.from(json.decode(response.body)["recordList"].map((x) => SystemFlag.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: api_helper.dart - getSystemFlag(): " + e.toString());
    }
  }

  Future getLanguagesForMultiLanguage() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAppLanguage"),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Language>.from(json.decode(response.body)["recordList"].map((x) => Language.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: api_helper.dart - getLanguagesForMultiLanguage(): " + e.toString());
    }
  }

  Future getpaymentAmount() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getRechargeAmount"),
      );
      print('done : $response');
      dynamic recordList;
      log("=====================>${response.body}");
      if (response.statusCode == 200) {
        recordList = List<AmountModel>.from(json.decode(response.body)["recordList"].map((x) => AmountModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: api_helper.dart - getpaymentAmount(): " + e.toString());
    }
  }

  Future<dynamic> checkFreeSession() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkFreeSessionAvailable'),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["isAddNewRequest"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in checkFreeSession : -" + e.toString());
    }
  }

  Future<dynamic> addFeedBack(String feedbackType, String? feedback) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addHoroscopeFeedback'),
        body: json.encode({"feedbacktype": "$feedbackType", "feedback": feedback}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in addFeedBack : -" + e.toString());
    }
  }
}
