import 'dart:developer';

import 'package:BharatiyAstro/model/astromallHistoryModel.dart';
import 'package:BharatiyAstro/model/callHistoryModel.dart';
import 'package:BharatiyAstro/model/chatHistoryModel.dart';
import 'package:BharatiyAstro/model/paymentsLogsModel.dart';
import 'package:BharatiyAstro/model/reportHistoryModel.dart';
import 'package:BharatiyAstro/model/walletTransactionHistoryModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class HistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabControllerHistory;

  APIHelper apiHelper = APIHelper();
  int currentIndexHistory = 0;
  var callHistoryList = <CallHistoryModel>[];
  var callHistoryListById = <CallHistoryModel>[];
  var chatHistoryList = <ChatHistoryModel>[];
  var reportHistoryList = <ReportHistoryModel>[];
  var paymentLogsList = <PaymentsLogsModel>[];
  var astroMallHistoryList = <AstroMallHistoryModel>[];
  var walletTransactionList = <WalletTransactionHistoryModel>[];
  bool isPlay = false;
  // var audioPlayer = AudioPlayer();
  // var audioPlayer2 = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int? indRepot;
  ScrollController historyScrollController = ScrollController();

  int startIndex = 0;
  int fetchRecord = 20;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  ScrollController walletScrollController = ScrollController();
  int walletStart = 0;
  int walletFetch = 20;
  bool walletDataLoaded = false;
  bool walletAllDataLoaded = false;
  bool walletMoreDataAvailable = false;

  ScrollController paymentScrollController = ScrollController();
  int paymentStart = 0;
  int paymentFetch = 20;
  bool paymentDataLoaded = false;
  bool paymentAllDataLoaded = false;
  bool paymentMoreDataAvailable = false;

  ScrollController callScrollController = ScrollController();
  int callStart = 0;
  int callFetch = 20;
  bool callDataLoaded = false;
  bool callAllDataLoaded = false;
  bool callMoreDataAvailable = false;

  ScrollController chatScrollController = ScrollController();
  int chatStart = 0;
  int chatFetch = 20;
  bool chatDataLoaded = false;
  bool chatAllDataLoaded = false;
  bool chatMoreDataAvailable = false;

  ScrollController reportScrollController = ScrollController();
  int reportStart = 0;
  int reportFetch = 20;
  bool reportDataLoaded = false;
  bool reportAllDataLoaded = false;
  bool reportMoreDataAvailable = false;

  static var index;

  @override
  void onInit() {
    tabControllerHistory = TabController(length: 2, vsync: this, initialIndex: currentIndexHistory);
    _inIt();

    super.onInit();
  }

  void paginateTask() {
    historyScrollController.addListener(() async {
      if (historyScrollController.position.pixels == historyScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        update();
        await getAstroMall(global.currentUserId!, true);
      }
      update();
    });
    walletScrollController.addListener(() async {
      if (walletScrollController.position.pixels == walletScrollController.position.maxScrollExtent && !walletAllDataLoaded) {
        walletMoreDataAvailable = true;
        update();
        await getWalletTransaction(global.currentUserId!, true);
      }
      update();
    });

    paymentScrollController.addListener(() async {
      if (paymentScrollController.position.pixels == paymentScrollController.position.maxScrollExtent && !paymentAllDataLoaded) {
        paymentMoreDataAvailable = true;
        update();
        await getPaymentLogs(global.currentUserId!, true);
      }
      update();
    });

    callScrollController.addListener(() async {
      if (callScrollController.position.pixels == callScrollController.position.maxScrollExtent && !callAllDataLoaded) {
        callMoreDataAvailable = true;
        update();
        await getCallHistory(global.currentUserId!, true);
      }
      update();
    });

    chatScrollController.addListener(() async {
      if (chatScrollController.position.pixels == chatScrollController.position.maxScrollExtent && !chatAllDataLoaded) {
        chatMoreDataAvailable = true;
        update();
        await getChatHistory(global.currentUserId!, true);
      }
      update();
    });

    reportScrollController.addListener(() async {
      if (reportScrollController.position.pixels == reportScrollController.position.maxScrollExtent && !reportAllDataLoaded) {
        reportMoreDataAvailable = true;
        update();
        await getReportHistory(global.currentUserId!, true);
      }
      update();
    });
  }

  _inIt() {
    paginateTask();
    // audioPlayer.onDurationChanged.listen((event) {
    //   duration = event;
    //   update();
    // });
    // audioPlayer.onPositionChanged.listen((event) {
    //   position = event;
    //   update();
    // });
  }

  // disposeAudioPlayer() {
  //   audioPlayer.dispose();
  // }

  // disposeAudioPlayer2() {
  //   audioPlayer2.dispose();
  // }

  getCallHistory(int userId, bool callLazyLoading) async {
    try {
      callStart = 0;
      if (callHistoryList.isNotEmpty) {
        callStart = callHistoryList.length;
      }
      if (!callLazyLoading) {
        callDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHistory(userId, callStart, callFetch).then((result) {
            if (result.status == "200") {
              List<dynamic> callHistory = result.recordList[0]['callRequest']['callHistory'];
              callHistoryList.addAll(List<CallHistoryModel>.from(callHistory.map((p) => CallHistoryModel.fromJson(p))));
              print('call history length :- ${callHistoryList.length} ');
              if (result.recordList[0]['callRequest']['callHistory'].length == 0) {
                callMoreDataAvailable = false;
                callAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get Call History ',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getCallHistory():' + e.toString());
    }
  }

  getChatHistory(int userId, bool chatLazyLoading) async {
    try {
      chatStart = 0;
      if (chatHistoryList.isNotEmpty) {
        chatStart = chatHistoryList.length;
      }
      if (!chatLazyLoading) {
        chatDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHistory(userId, chatStart, fetchRecord).then((result) {
            if (result.status == "200") {
              List<dynamic> chatHistory = result.recordList[0]['chatRequest']['chatHistory'];
              chatHistoryList.addAll(List<ChatHistoryModel>.from(chatHistory.map((p) => ChatHistoryModel.fromJson(p))));
              print('chat history length :- ${chatHistoryList.length} ');
              if (result.recordList[0]['chatRequest']['chatHistory'].length == 0) {
                chatMoreDataAvailable = false;
                chatAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get Call History ',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getChatHistory():' + e.toString());
    }
  }

  getReportHistory(int userId, bool reportLazyLoading) async {
    try {
      reportStart = 0;
      if (reportHistoryList.isNotEmpty) {
        reportStart = reportHistoryList.length;
      }
      if (!reportLazyLoading) {
        reportDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHistory(userId, reportStart, reportFetch).then((result) {
            if (result.status == "200") {
              List<dynamic> reportHistory = result.recordList[0]['reportRequest']['reportHistory'];
              reportHistoryList.addAll(List<ReportHistoryModel>.from(reportHistory.map((p) => ReportHistoryModel.fromJson(p))));
              if (result.recordList[0]['reportRequest']['reportHistory'].length == 0) {
                reportMoreDataAvailable = false;
                reportAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get Report History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getReportHistory():' + e.toString());
    }
  }

  getPaymentLogs(int userId, bool paymentLazyLoading) async {
    try {
      paymentStart = 0;
      if (paymentLogsList.isNotEmpty) {
        paymentStart = paymentLogsList.length;
      }
      if (!paymentLazyLoading) {
        paymentDataLoaded = false;
      }

      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHistory(userId, paymentStart, paymentFetch).then((result) {
            if (result.status == "200") {
              List<dynamic> paymentLogsHistory = result.recordList[0]['paymentLogs']['payment'];
              paymentLogsList.addAll(List<PaymentsLogsModel>.from(paymentLogsHistory.map((p) => PaymentsLogsModel.fromJson(p))));
              if (result.recordList[0]['paymentLogs']['payment'].length == 0) {
                paymentMoreDataAvailable = false;
                paymentAllDataLoaded = true;
              }

              update();
            } else {
              global.showToast(
                message: 'Fail to get Payment Logs History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getPaymentLogs():' + e.toString());
    }
  }

  Future getAstroMall(int? userId, bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (astroMallHistoryList.isNotEmpty) {
        startIndex = astroMallHistoryList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
               print("here is result $result"); 
        if (result) {
          await apiHelper.getHistory(userId!, startIndex, fetchRecord).then((result) {
            if (result.status == "200") {
        log("${result.recordList[0]['orders']['order']}");
              List<dynamic> astroMallHistory = result.recordList[0]['orders']['order'];
              astroMallHistoryList.addAll(List<AstroMallHistoryModel>.from(astroMallHistory.map((p) => AstroMallHistoryModel.fromJson(p))));
              if (result.recordList[0]['orders']['order'].length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get AstroMall History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getPaymentLogs():' + e.toString());
    }
  }

  Future getWalletTransaction(int userId, bool walletLazyLoading) async {
    try {
      walletStart = 0;
      if (walletTransactionList.isNotEmpty) {
        walletStart = walletTransactionList.length;
        update();
      }
      if (!walletLazyLoading) {
        walletDataLoaded = false;
        update();
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHistory(userId, walletStart, walletFetch).then((result) {
            if (result.status == "200") {
              List<dynamic> walletTransaction = result.recordList[0]['walletTransaction']['wallet'];
              walletTransactionList.addAll(List<WalletTransactionHistoryModel>.from(walletTransaction.map((p) => WalletTransactionHistoryModel.fromJson(p))));
              print('wallet taransaction length - ${walletTransactionList.length}');
              if (result.recordList[0]['walletTransaction']['wallet'].length == 0) {
                walletMoreDataAvailable = false;
                walletAllDataLoaded = true;
              }

              update();
            } else {
              global.showToast(
                message: 'Fail Payment Logs History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getReportHistory():' + e.toString());
    }
  }

  getCallHistoryById(int callId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getCallHistoryById(callId).then((result) {
            if (result.status == "200") {
              callHistoryListById = List<CallHistoryModel>.from(result.recordList.map((p) => CallHistoryModel.fromJson(p)));
              update();
            } else {
              global.showToast(
                message: 'Fail Call History by ID',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getCallHistoryById():' + e.toString());
    }
  }

  cancleOrder(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.cancelAstromallOrder(id).then((result) async {
            if (result.status == "200") {
              double total = double.parse(result.recordList[0].totalPayable.toString());
              global.splashController.currentUser?.walletAmount = (global.splashController.currentUser?.walletAmount ?? 0) + total;
              astroMallHistoryList.clear();
              isAllDataLoaded = false;
              update();
              await getAstroMall(global.currentUserId!, true);
            } else {
              global.showToast(
                message: 'Failed to cancel order please try gain later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in cancleOrder():' + e.toString());
    }
  }
}
