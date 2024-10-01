import 'package:BharatiyAstro/model/customer_support_model.dart';
import 'package:BharatiyAstro/model/help_and_support_model.dart';
import 'package:BharatiyAstro/model/help_support_question.dart';
import 'package:BharatiyAstro/model/help_support_subcat_model.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../model/chat_message_model.dart';
import '../model/customer_support_review_model.dart';

class CustomerSupportController extends GetxController {
  APIHelper apiHelper = APIHelper();

  var ticketList = <CustomerSuppportModel>[];
  var createdTicket = <CustomerSuppportModel>[];
  var helpAndSupport = <HelpAndSupportModel>[];
  var helpAndSupportQuestion = <HelpSupportQuestionModel>[];
  var helpSupportSubCat = <HelpAndSupportSubcatModel>[];
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  int textLength = 0;
  double rating = 0.0;
  CollectionReference userChatCollectionRef = FirebaseFirestore.instance.collection("supportChat");
  bool isAddEdit = true;
  bool isIn = false;
  String status = "WAITING";
  int? tickitIndex;
  getCustomerTickets() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getTickets(global.currentUserId!).then((result) {
            if (result.status == "200") {
              ticketList = result.recordList;
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getCustomerTickets():' + e.toString());
    }
  }

  deleteTickets() async {
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.deleteTicket().then((result) async {
          if (result.status == "200") {
            global.showToast(
              message: 'Deleted Successfully',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
            await getCustomerTickets();
          } else {
            global.showToast(
              message: 'Fail Delete',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  deleteOneTicket(int ticketId) async {
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.deleteOneTicket(ticketId).then((result) async {
          if (result.status == "200") {
            global.showToast(
              message: 'Deleted Successfully',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
            await getCustomerTickets();
          } else {
            global.showToast(
              message: 'Delete Failed',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  getHelpAndSupport() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHelpAndSupport().then((result) {
            if (result.status == "200") {
              helpAndSupport = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'customer help and support',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getHelpAndSupport():' + e.toString());
    }
  }

  getHelpAndSupportQuestion(int helpSupportId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHelpAndSupportQuestion(helpSupportId).then((result) {
            if (result.status == "200") {
              helpAndSupportQuestion = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'customer help and support getHelpAndSupportQuestion',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getHelpAndSupportQuestion():' + e.toString());
    }
  }

  getHelpAndSupportQuestionAnswer(int helpSupportId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHelpAndSupportQuestionAnswer(helpSupportId).then((result) {
            if (result.status == "200") {
              helpSupportSubCat = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'customer help and support getHelpAndSupportQuestionAnswer',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getHelpAndSupportQuestionAnswer():' + e.toString());
    }
  }

  restartSupportChat(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.restratCustomerSupportChat(id).then((result) async {
            if (result.status == "200") {
              status = "WAITING";
              await getCustomerTickets();
            } else {
              global.showToast(
                message: 'Fail customer help and support',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getHelpAndSupportQuestion():' + e.toString());
    }
  }

  createCustomerTickets(String subject, int helpSupportQuestionId, String helpSupportQuestion, String helpSupportSubQuestion) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          CustomerSuppportModel customerSuppportModel = CustomerSuppportModel(
            userId: global.currentUserId!,
            subject: subject,
            description: descriptionController.text,
            helpSupportId: helpSupportQuestionId,
          );
          await apiHelper.creaetTicket(customerSuppportModel).then((result) async {
            if (result.status == "200") {
              await getCustomerTickets();
              update();
              if (helpSupportQuestion != "") {
                if (helpSupportSubQuestion != "") {
                  sendMessage('$helpSupportQuestion -> $helpSupportSubQuestion -> ${result.recordList["subject"]}', result.recordList["chatId"], result.recordList["id"]);
                } else {
                  sendMessage('$helpSupportQuestion -> ${result.recordList["subject"]}', result.recordList["chatId"], result.recordList["id"]);
                }
              } else {
                sendMessage('${result.recordList["subject"]}', result.recordList["chatId"], result.recordList["id"]);
              }

              sendMessage('${result.recordList["description"]}', result.recordList["chatId"], result.recordList["id"]);

              global.showToast(
                message: 'Ticket created successfully!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              descriptionController.clear();
            } else {
              global.showToast(
                message: 'failed created ticket',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in createCustomerTickets():' + e.toString());
    }
  }

  addCustomerReview(int ticketId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addCustomerSupportReview(reviewController.text, rating, ticketId).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Review added successfully!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isAddEdit = false;
              update();
            } else {
              global.showToast(
                message: 'failed add review please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addCustomerReview():' + e.toString());
    }
  }

  updateCustomerReview(int ticketId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.editCustomerSupportReview(reviewController.text, rating, ticketId).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Review updated successfully!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isAddEdit = false;
              update();
            } else {
              global.showToast(
                message: 'failed update review please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addCustomerReview():' + e.toString());
    }
  }

  var getReview = <CustomerSupportReviewModel>[];
  int? reviewId;
  getCustomerReview(int ticketId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getCustomerSupportReview(ticketId).then((result) {
            if (result.status == "200") {
              print('getCustomerReview:- ${result.recordList}');
              if (result.recordList.isEmpty) {
                isAddEdit = true;
              } else {
                isAddEdit = false;
                getReview = result.recordList;
                reviewController.text = getReview[0].review ?? "";
                rating = getReview[0].rating ?? 0;
                reviewId = getReview[0].id;
              }
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getCustomerReview():' + e.toString());
    }
  }

  bool isMe = true;

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('supportChat/$firebaseChatId/userschat').doc('$currentUserId').collection('messages').orderBy("createdAt", descending: true).snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception - apiHelper.dart - getChatMessages()" + err.toString());
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

  bool isOpenTicket = false;
  getClosedTicketStatus() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getTicketStatus().then((result) async {
            if (result.status == "200") {
              isOpenTicket = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Get ticket status failed',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getClosedTicketStatus():' + e.toString());
    }
  }
}
