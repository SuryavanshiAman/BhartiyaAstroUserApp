import 'dart:developer';
import 'dart:io';
import 'package:BharatiyAstro/controllers/notificationController.dart';
import 'package:BharatiyAstro/main.dart';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/model/astrologerCategoryModel.dart';
import 'package:BharatiyAstro/model/astrologer_model.dart';
import 'package:BharatiyAstro/model/reviewModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:BharatiyAstro/views/homeScreen.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/date_converter.dart';

import '../model/chat_message_model.dart';
import 'package:pdf/widgets.dart' as pw;

import '../views/chat/chat_screen.dart';

class ChatController extends GetxController with GetSingleTickerProviderStateMixin {
  var categoryList = <AstrologerCategoryModel>[];
  int isSelected = 0.obs();
  TabController? categoryTab;
  var astroList = <AstrologerModel>[];
  var reviewData = <ReviewModel>[];
  bool isEndChat = false;
  RxBool showtimer = false.obs;
  int? astrologerId;
  APIHelper apiHelper = APIHelper();
  //agora chat channnelName for current user and current astrologer
  String channelId = "";
  // agora current user id
  String agorauserId = "";
  //  agora current astrologer user id
  double? rating;
  bool isPublic = true;
  TextEditingController reviewController = TextEditingController();

  String agoraAstrologerUserId = "";
  ChatMessageModel chatmessage = ChatMessageModel();
  CollectionReference userChatCollectionRef = FirebaseFirestore.instance.collection("chats");
  bool showBottomAcceptChat = false;
  int? bottomAstrologerId;
  String bottomAstrologerName = "Astrologer";
  String? bottomAstrologerProfile;
  String? bottomFirebaseChatId;
  int? bottomChatId;
  String? bottomFcmToken;
  bool? isAstrologerEndedChat;
  bool chatBottom = false;
  bool isInchat = false;
  var pdf = pw.Document();
  final BottomNavigationController bottomNavigationController = Get.put<BottomNavigationController>(BottomNavigationController());
  NoticationController notificationController = Get.put(NoticationController());
  bool isChatRequest = false;
  @override
  void onInit() async {
    await _init();
    super.onInit();
    categoryTab = TabController(vsync: this, length: categoryList.length, initialIndex: isSelected);
  }

  @override
  void dispose() {
    categoryTab?.dispose();
    super.dispose();
  }

  _init() async {
    await getAstrologerCategorys();
  }

  bool isMeForShare = false;
  shareChat(String chatId, String astrologer) async {
    try {
      pdf = pw.Document();
      List<ChatMessageModel?>? messageList = await getShareMessages(chatId: chatId);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(messageList!.length, (index) {
                ChatMessageModel message = messageList[index]!;
                isMeForShare = message.userId1 == '${global.currentUserId}';
                return isMeForShare
                    ? pw.Text(
                        '${DateConverter.dateToDateAndTime(messageList[index]!.createdAt!)}:${global.user.name}:${messageList[index]!.message}')
                    : pw.Text(
                        '${DateConverter.dateToDateAndTime(messageList[index]!.createdAt!)}:$astrologer:${messageList[index]!.message}');
              })),
        ),
      );
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final temp = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
      final path = '${temp!.path}/$fileName.pdf';
      File(path).writeAsBytesSync(await pdf.save());
      print('path $path');
      await FlutterShare.shareFile(
              filePath: path,
              title: '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}',
              text:
                  "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career.Check my chat with $astrologer.You should also try and see your future https://play.google.com/store/apps/details?id=com.bharatiyastro.userapp")
          .then((value) {})
          .catchError((e) {
        print(e);
      });
    } catch (e) {
      log('Exception in shareChat $e');
    }
  }

  Future<List<ChatMessageModel?>?> getShareMessages({String? chatId}) async {
    try {
      Stream<List<ChatMessageModel>> m = FirebaseFirestore.instance
          .collection('chats/$chatId/userschat')
          .doc('${global.currentUserId}')
          .collection('messages')
          .orderBy("createdAt", descending: false)
          .snapshots()
          .map((reviews) => reviews.docs.map((review) => ChatMessageModel.fromJson(review.data())).toList());
      print(m.length);
      List<ChatMessageModel> mm = await m.first;
      return mm.isNotEmpty ? mm : [];
    } catch (err) {
      print("Exception - apiHelper.dart - getShareMessages() ${err.toString()}");
      return null;
    }
  }

  showBottomAcceptChatRequest(
      {required BuildContext context,
      required int astrologerId,
      required int chatId,
      required String astroName,
      required String fcmToken,
      required String astroProfile,
      required String firebaseChatId}) async {
    showBottomAcceptChat = true;
    log("isChatRequest============================>${isChatRequest}");
    if (!isChatRequest) {
      bottomAstrologerId = astrologerId;
      bottomAstrologerName = astroName;
      bottomAstrologerProfile = astroProfile;
      bottomFirebaseChatId = firebaseChatId;
      bottomChatId = chatId;
      bottomFcmToken = fcmToken;

      print('showBottomAcceptChat:- $showBottomAcceptChat');
      global.sp = await SharedPreferences.getInstance();
      global.sp!.remove('chatBottom');
      // global.sp!.remove('chatBottom');
      await global.sp!.setInt('bottomAstrologerId', astrologerId);
      await global.sp!.setInt('bottomChatId', chatId);
      await global.sp!.setString('bottomAstrologerName', astroName);
      await global.sp!.setString('bottomFirebaseChatId', firebaseChatId);
      await global.sp!.setInt('chatBottom', 1);
      await global.sp!.setString('bottomAstrologerProfile', astroProfile);
      await global.sp!.setString('bottomFcmToken', fcmToken);
      update();

      FlutterRingtonePlayer.playRingtone(asAlarm: false);
      // notificationController.showSnackBar();
      notificationController.showChatNotification(
          astroProfile,
          astroName,
          () => {
                FlutterRingtonePlayer.stop(),
                Get.to(() => AcceptChatScreen(
                      astrologerId: astrologerId,
                      chatId: chatId,
                      astrologerName: astroName,
                      fireBasechatId: firebaseChatId,
                      flagId: 1,
                      profileImage: astroProfile,
                      fcmToken: fcmToken,
                    ))
              });
    }
  }

  getAstrologerCategorys() async {
    try {
      await global.checkBody().then((result) async {
        categoryList = [];
        if (result) {
          await apiHelper.getAstrologerCategory().then((result) {
            if (result.status == "200") {
              categoryList = result.recordList;
              categoryList[0] = AstrologerCategoryModel(
                image: '',
                name: 'All',
                id: 1,
              );
              update();
            } else {
              global.showToast(
                message: 'Failed to get Category',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getAstrologerCategory():' + e.toString());
    }
  }

  sendChatRequest(int astrologerId, bool isFreeSession) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.sendAstrologerChatRequest(astrologerId, isFreeSession).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'Sending chat request..',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Failed to send chat request',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in sendCallRequest : - ${e.toString()}');
    }
  }

  bool isMe = true;
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance
          .collection('chats/$firebaseChatId/userschat')
          .doc('$currentUserId')
          .collection('messages')
          .orderBy("createdAt", descending: true)
          .snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception - apiHelper.dart - getChatMessages()" + err.toString());
      return null;
    }
  }

  Future<void> sendMessage(String message, String chatId, int partnerId, bool isEndMessage) async {
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.user.id}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
        );
        update();
        await uploadMessage(chatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  Future uploadMessage(String idUser, String partnerId, ChatMessageModel anonymous) async {
    try {
      final String globalId = global.user.id.toString();
      log("$globalId   $partnerId");
      final refMessages =
          userChatCollectionRef.doc(idUser).collection('userschat').doc(globalId).collection('messages');
      final refMessages1 =
          userChatCollectionRef.doc(idUser).collection('userschat').doc(partnerId).collection('messages');
      final newMessage1 = anonymous;

      final newMessage2 = anonymous;
      // newMessage2.messageId = refMessages1.id;

      var messageResult = await refMessages.add(newMessage1.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      newMessage1.messageId = messageResult.id;
      await userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(globalId)
          .collection('messages')
          .doc(newMessage1.messageId)
          .update({"messageId": newMessage1.messageId});

      newMessage2.isRead = false;
      var message1Result = await refMessages1.add(newMessage2.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      print("messageResult " + messageResult.toString());
      print("message1Result " + message1Result.toString());
      newMessage2.messageId = message1Result.id;
      await userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages')
          .doc(newMessage2.messageId)
          .update({"messageId": newMessage2.messageId});
      return {
        'user1': messageResult.id,
        'user2': message1Result.id,
      };
    } catch (err) {
      print('uploadMessage err $err');
    }
  }

  rejectedChat(int cid) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.rejectChat(cid).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'Chat Rejected',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Chat Reject fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception rejectedChat:-" + e.toString());
    }
  }

  acceptedChat(int chatId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.acceptChat(chatId).then((result) {
            if (result.status == "200") {
              global.showToast(
                message: 'Chat Accepted',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Chat Accepet fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception acceptedChat:-" + e.toString());
    }
  }

  addReview(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .addAstrologerReview(
            astrologerId,
            rating,
            reviewController.text,
            !isPublic,
          )
              .then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Thank you!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await getuserReview(astrologerId);
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to add review',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addReview : - ${e.toString()}');
    }
  }

  getuserReview(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getuserReview(global.currentUserId!, astrologerId).then((result) {
            if (result.status == "200") {
              reviewData = result.recordList;
              reviewController.text = reviewData[0].review;
              rating = reviewData[0].rating;
              isPublic = reviewData[0].isPublic == 1 ? true : false;
              update();
            } else {
              global.showToast(
                message: 'Chat Accepet fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception acceptedChat:-" + e.toString());
    }
  }

  deleteReview(int reviewId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteReview(reviewId).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your review has been deleted',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              reviewData.clear();
              rating = 0;
              reviewController.clear();
              update();
            } else {
              global.showToast(
                message: 'Delete review failed!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception deleteReview:-" + e.toString());
    }
  }

  updateReview(int reviewId, int astrologerId) async {
    try {
      var basicDetails = {
        "rating": rating,
        "review": reviewController.text == "" ? "" : reviewController.text,
        "astrologerId": astrologerId,
        "isPublic": !isPublic,
      };
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.updateAstrologerReview(reviewId, basicDetails).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your review has been updated',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await getuserReview(astrologerId);
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to update review',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addReview : - ${e.toString()}');
    }
  }
}
