import 'package:BharatiyAstro/model/assistant_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../model/chat_message_model.dart';

class AstrologerAssistantController extends GetxController {
  APIHelper apiHelper = APIHelper();
  String firebaseChatId = "";
  var assistantList = <AssistantModel>[];
  List<String> lastMessage = [];
  List<dynamic> lastMessageTime = [];
  CollectionReference userChatCollectionRef = FirebaseFirestore.instance.collection("assistantchats");

  storeChatId(int partnerId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.storeAssistantFirebaseChatId(global.user.id!, partnerId).then(
              (result) {
                if (result.status == "200") {
                  firebaseChatId = result.recordList['recordList'];
                  update();
                  print('chat id genrated:- $firebaseChatId');
                } else {
                  global.showToast(
                    message: '${result.status} problem to store firebase chat id',
                    textColor: global.textColor,
                    bgColor: global.toastBackGoundColor,
                  );
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception:- storeChatId(): ' + e.toString());
    }
  }

  bool isMe = true;
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('assistantchats/$firebaseChatId/userschat').doc('$currentUserId').collection('messages').orderBy("createdAt", descending: true).snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception -  getChatMessages()" + err.toString());
      return null;
    }
  }

  Future<void> sendMessage(String message, String chatId, int partnerId) async {
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
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
      final String globalId = global.currentUserId.toString();
      final refMessages = userChatCollectionRef.doc(idUser).collection('userschat').doc(globalId).collection('messages');
      final refMessages1 = userChatCollectionRef.doc(idUser).collection('userschat').doc(partnerId).collection('messages');
      final newMessage1 = anonymous;

      final newMessage2 = anonymous;
      newMessage2.messageId = refMessages1.id;

      var messageResult = await refMessages.add(newMessage1.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      newMessage1.messageId = messageResult.id;
      await userChatCollectionRef.doc(idUser).collection('userschat').doc(globalId).collection('messages').doc(newMessage1.messageId).update({"messageId": newMessage1.messageId});

      newMessage2.isRead = false;
      var message1Result = await refMessages1.add(newMessage2.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      await userChatCollectionRef.doc(idUser).collection('userschat').doc(partnerId).collection('messages').doc(newMessage1.messageId).update({"messageId": newMessage1.messageId});
      return {
        'user1': messageResult.id,
        'user2': message1Result.id,
      };
    } catch (err) {
      print('uploadMessage err $err');
    }
  }

  Future<ChatMessageModel?> getLastMessages({String? chatId}) async {
    try {
      Stream<List<ChatMessageModel>> m = FirebaseFirestore.instance.collection('assistantchats').doc(chatId).collection('userschat').doc(global.user.id.toString()).collection('messages').orderBy("createdAt", descending: true).limit(1).snapshots().map((reviews) => reviews.docs.map((review) => ChatMessageModel.fromJson(review.data())).toList());
      print(m.length);
      List<ChatMessageModel> mm = await m.first;
      return mm.isNotEmpty
          ? mm[0]
          : ChatMessageModel(
              message: '',
              createdAt: DateTime.now().subtract(const Duration(days: 365)),
              url: '',
            );
    } catch (err) {
      print("Exception - getLastMessages()" + err.toString());
      return null;
    }
  }

  getChatWithAstrologerAssisteant() async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.getAssistantChat().then(
              (result) {
                if (result.status == "200") {
                  assistantList = result.recordList;
                  for (int i = 0; i < assistantList.length; i++) {
                    getLastMessages(chatId: assistantList[i].chatId).then((value) {
                      print('message :- ${value!.message}');
                      print('time ${value.createdAt}');
                      assistantList[i].lastMessage = value.message;
                      assistantList[i].lastMessageTime = value.createdAt;
                      update();
                    });
                  }
                  update();
                  print('get assistant chat history:- ${result.recordList}');
                } else {
                  global.showToast(
                    message: '${result.status} problem to get assistant chat history',
                    textColor: global.textColor,
                    bgColor: global.toastBackGoundColor,
                  );
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception:- getChatWithAstrologerAssisteant(): ' + e.toString());
    }
  }

  bool isPaidSession = false;

  checkPaidSession(int astrologerId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            print('paid session astro id :- $astrologerId');
            await apiHelper.checkAstrologerPaidSession(astrologerId).then(
              (result) {
                if (result.status == "200") {
                  isPaidSession = result.recordList['isAvailable'];
                  update();
                  print('paid session or not:- $isPaidSession');
                } else {
                  global.showToast(
                    message: '${result.status} problem to get assistant chat history',
                    textColor: global.textColor,
                    bgColor: global.toastBackGoundColor,
                  );
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception:- checkPaidSession(): ' + e.toString());
    }
  }

  Future<dynamic> assistantblock(int assistantId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.blockAstrologerAssistant(assistantId).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Assistant Block Successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Fail block Assistant',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in assistantblock :-" + e.toString());
    }
  }

  Future<dynamic> assistantDelete(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteAssistantChat(id).then((result) async {
            if (result.status == "200") {
              await getChatWithAstrologerAssisteant();

              global.showToast(
                message: 'Assistant Deleted Successfully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: '${result.status} Fail Deleted Assistant',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in assistantDelete :-" + e.toString());
    }
  }
}
