import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/dropDownController.dart';
import 'package:BharatiyAstro/model/astrologer_model.dart';
import 'package:BharatiyAstro/model/reportModel.dart';
import 'package:BharatiyAstro/model/reportTypeModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class ReportController extends GetxController {
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();

  bool isSearch = false;
  var reportTypeList = <ReportTypeModel>[];
  TextEditingController searchController = TextEditingController();
  TextEditingController fristNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController birthTimeController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController ocucupationController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController partnerNameController = TextEditingController();
  TextEditingController partnerPlaceController = TextEditingController();
  TextEditingController partnerDobController = TextEditingController();
  TextEditingController partnerBirthController = TextEditingController();
  APIHelper apiHelper = APIHelper();
  var astrologerSorting = <AstrologerModel>[];
  FocusNode firstNamefocus = FocusNode();
  FocusNode lastNamefocus = FocusNode();
  FocusNode phonefocus = FocusNode();
  FocusNode occupationfocus = FocusNode();
  FocusNode partnerNamefocus = FocusNode();

  TextEditingController searchReportController = TextEditingController();
  DropDownController dropDownController = Get.find<DropDownController>();
  String errorText = "";
  bool isEnterPartnerDetails = false;
  bool isSelect = false;
  int groupValue = 1.obs();
  DateTime? selctedDate;
  DateTime? selctedPartnerDate;
  String? sortingFilter = ''.obs();
  String? searchString;
  ScrollController reportTypeScrollController = ScrollController();
  int fetchRecord = 3;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  String? countryCode;

  bool isValue = true;

  List title = [
    '2022 Detailed yearly Report',
    'Education Report',
    'Love & Relationship Report',
    'Child NameReport',
    'Match Making Report',
    'Travel & Forgeign Settlement',
    'Child Birth Report',
    'Ask any question on one topic',
    'career Rerport',
    'Business Report',
    'Buiness Partner Loyalty Report',
  ];
  updateCountryCode(value) {
    countryCode = value.toString();
    update();
  }

  List<ReportModel> sorting = [
    ReportModel(id: 1, name: 'Popularity', isSeledted: true, value: 'popularity'),
    ReportModel(id: 2, name: 'Experience:High to Low', isSeledted: false, value: 'experienceHighToLow'),
    ReportModel(id: 3, name: 'Experience: Low to High', isSeledted: false, value: 'experienceLowToHigh'),
    ReportModel(id: 4, name: 'Oders: High to Low', isSeledted: false, value: 'ordersHighToLow'),
    ReportModel(id: 5, name: 'Oders: Low to High', isSeledted: false, value: 'ordersLowToHigh'),
    ReportModel(id: 6, name: 'Price: High to Low', isSeledted: false, value: 'priceHighToLow'),
    ReportModel(id: 7, name: 'Price: Low to High', isSeledted: false, value: 'priceLowToHigh'),
    // ReportModel(id: 8, name: 'Rating: High to Low', isSeledted: false, value: 'rating'),
  ];
  List<ReportModel> reportSorting = [
    ReportModel(id: 1, name: 'Popularity', isSeledted: true, value: 'popularity'),
    ReportModel(id: 2, name: 'Experience:High to Low', isSeledted: false, value: 'experienceHighToLow'),
    ReportModel(id: 3, name: 'Experience: Low to High', isSeledted: false, value: 'experienceLowToHigh'),
    ReportModel(id: 4, name: 'Oders: High to Low', isSeledted: false, value: 'ordersHighToLow'),
    ReportModel(id: 5, name: 'Oders: Low to High', isSeledted: false, value: 'ordersLowToHigh'),
    ReportModel(id: 6, name: 'Price: High to Low', isSeledted: false, value: 'reportPriceHighToLow'),
    ReportModel(id: 7, name: 'Price: Low to High', isSeledted: false, value: 'reportPriceLowToHigh'),
    // ReportModel(id: 8, name: 'Rating: High to Low', isSeledted: false, value: 'rating'),
  ];

  List description = ['Get detailed analysis on your chart through the astrologer predictions to get a sense of how your year 2022 will go overall. this report will cover topics retlated to career,love,health,wealth and realtionship. we\'ll know your future based on your upcoming dashas what will be good and bad to you.', ''];

  @override
  void onInit() {
    paginateTask();
    super.onInit();
  }

  void paginateTask() {
    reportTypeScrollController.addListener(() async {
      if (reportTypeScrollController.position.pixels == reportTypeScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        await getReportTypes(searchString, true);
      }
      update();
    });
  }

  Future<dynamic> getAstrologerSorting(String sorting) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstrologer(sortingKey: sorting).then((result) {
            if (result.status == "200") {
              print('Astrologer sorting');
              bottomNavigationController.astrologerList = result.recordList;
              bottomNavigationController.update();

              global.showToast(
                message: 'Sorting Applied',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              update();
            } else {
              global.showToast(
                message: 'Get Atrologer sorting failed',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerSorting :-" + e.toString());
    }
  }

  getReportTypes(String? searchString, bool isLazyLoading) async {
    try {
      print('search report type string:-:- $searchString');
      startIndex = 0;
      if (reportTypeList.isNotEmpty) {
        startIndex = reportTypeList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getReportType(searchString, startIndex, fetchRecord).then((result) {
            if (result.status == "200") {
              reportTypeList.addAll(result.recordList);
              print('report type length:- ${reportTypeList.length}');
              if (result.recordList.length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: '${result.status} get Report',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getReportTypes():' + e.toString());
    }
  }

  String gender = 'male';

  updateGeneder(value) {
    gender = value;
    update();
  }

  partnerDetails(bool value) {
    isEnterPartnerDetails = value;
    if (isEnterPartnerDetails == false) {
      partnerBirthController.clear();
      partnerDobController.clear();
      partnerNameController.clear();
      partnerPlaceController.clear();
    }
    update();
  }

  bool isValidData() {
    if (fristNameController.text == "") {
      errorText = "Please Enter First name";
      return false;
    } else if (phoneController.text == "") {
      errorText = "Please Enter Phone Number";
      return false;
    } else if (dobController.text == "") {
      errorText = "Please Enter Bate of Birth";
      return false;
    } else if (birthTimeController.text == "") {
      errorText = "Please Enter Birth Time";
      return false;
    } else if (placeController.text == " ") {
      errorText = "Please Enter Place of Birth";
      return false;
    } else if (commentController.text == "") {
      errorText = "Please Enter Any Comment";
      return false;
    } else {
      if (isEnterPartnerDetails) {
        if (partnerNameController.text == "") {
          errorText = "Please Enter partner name";
          return false;
        } else if (partnerDobController.text == "") {
          errorText = "Please Enter partner DOB";
          return false;
        } else if (partnerBirthController.text == "") {
          errorText = "Please Enter partner birth time";
          return false;
        } else if (partnerPlaceController.text == " ") {
          errorText = "Please Enter partner birth place";
          return false;
        }
      }
      return true;
    }
  }

  addGetReportFormData(int astrologerId, int reportId) async {
    print('in addgetreport');
    var getReportModelData = isEnterPartnerDetails == true
        ? {
            "id": null,
            "userId": global.currentUserId,
            "astrologerId": astrologerId,
            "firstName": fristNameController.text,
            "lastName": lastNameController.text == "" ? null : lastNameController.text,
            "contactNo": phoneController.text,
            "gender": gender,
            "birthDate": DateTime.parse(selctedDate.toString()).toIso8601String(),
            "birthTime": birthTimeController.text,
            // "birthPlace": placeController.text,
                "birthPlace":"Ranchi",
            "maritalStatus": dropDownController.maritalStatus ?? "Single",
            "occupation": ocucupationController.text == "" ? null : ocucupationController.text,
            "answerLanguage": dropDownController.language ?? "English",
            "partnerName": partnerNameController.text == "" ? null : partnerNameController.text,
            "partnerBirthDate": partnerDobController.text == "" ? null : DateTime.parse(selctedPartnerDate.toString()).toIso8601String(),
            "partnerBirthTime": partnerBirthController.text == "" ? null : partnerBirthController.text,
            "partnerBirthPlace": partnerPlaceController.text == "" ? null : partnerPlaceController.text,
            "comments": commentController.text,
            "reportType": reportId,
            'countryCode': countryCode ?? "IN"
          }
        : {
            "id": null,
            "userId": global.currentUserId,
            "astrologerId": astrologerId,
            "firstName": fristNameController.text,
            "lastName": lastNameController.text == "" ? null : lastNameController.text,
            "contactNo": phoneController.text,
            "gender": gender,
            "birthDate": DateTime.parse(selctedDate.toString()).toIso8601String(),
            "birthTime": birthTimeController.text,
            // "birthPlace": placeController.text,
            "birthPlace":"Ranchi",
            "maritalStatus": dropDownController.maritalStatus ?? "Single",
            "occupation": ocucupationController.text == "" ? null : ocucupationController.text,
            "answerLanguage": dropDownController.language ?? "English",
            "comments": commentController.text,
            "reportType": reportId,
            'countryCode': countryCode ?? "IN"
          };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addReportIntakeDetail(getReportModelData).then((result) async {

            if (result.status == "200") {
              global.showToast(
                message: 'Add Form Data successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Failed to add form data!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addGetReportFormData:-" + e.toString());
    }
  }
}
