import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/controllers/timer_controller.dart';
import 'package:BharatiyAstro/controllers/walletController.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:BharatiyAstro/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/chatController.dart';
import 'astrologerProfile/astrologerProfile.dart';
import 'bottomNavigationBarScreen.dart';

class FreeChatScreen extends StatefulWidget {
  final int flagId;
  final String profileImage;
  final String astrologerName;
  final String fireBasechatId;
  final int chatId;
  final int astrologerId;
  final String? fcmToken;
  const FreeChatScreen({
    Key? key,
    required this.flagId,
    required this.profileImage,
    required this.astrologerName,
    required this.fireBasechatId,
    required this.chatId,
    required this.astrologerId,
    this.fcmToken,
  }) : super(key: key);
  @override
  _FreeChatScreenState createState() => _FreeChatScreenState();
}

class _FreeChatScreenState extends State<FreeChatScreen> {
  @override
  void initState() {
    print("Aman");
    Future.delayed(Duration(seconds: 2),(){
      _startTimer();
      _triggerReply();
    });

    super.initState();
  }
  final List<Map<String, String>> _messages = []; // Stores all messages
  final List<String> _user1Replies = [
    "Hi there!",
    "What is your name?",
    "What is your gender?",
    "What is your Date of Birth?",
    "What is your Time of Birth?",
    "What is your marital status?",
    "You will get success soon😊😊",
    "How may i help you?",
    "Have a great day!"
  ]; // Predefined replies for user 1
  int _currentReplyIndex = 0; // Tracks the current reply index
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    // Add the user's message to the chat
    setState(() {
      _messages.add({"sender": "User 2", "message": text});
    });

    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    _handleReply(text);
  }

  void _handleReply(String userMessage) {
    // Custom validation logic for specific questions
    if (_currentReplyIndex == 3) {
      // Question: "What is your gender?"
      if (userMessage != "male" && userMessage.toLowerCase() != "female") {
        // Send fallback reply
        setState(() {
          _messages.add({
            "sender": "User 1",
            "message":
                "Sorry, I don’t get you. Please reply with 'male' or 'female'."
          });
        });
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        return;
      }
    }
    if (_currentReplyIndex == 4) {
      // Question: "What is your date of birth?"
      if (!_isValidDate(userMessage)) {
        setState(() {
          _messages.add({
            "sender": "User 1",
            "message":
                "Sorry, I don’t get you. Please provide your date of birth in a valid format (e.g., DD/MM/YYYY or MM-DD-YYYY)."
          });
        });
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        return;
      }
    }
    if (_currentReplyIndex == 5) {
      // Question: "What is your time?"
      if (!_isValidTime(userMessage)) {
        setState(() {
          _messages.add({
            "sender": "User 1",
            "message":
                "Sorry, I don’t get you. Please provide the time in a valid format (e.g., 14:30, 02:30 and am or pm is mandatory )."
          });
        });
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        return;
      }
    }

    if (_currentReplyIndex == 6) {
      // Question: "What is your marital status?"
      if (!_isValidMaritalStatus(userMessage)) {
        setState(() {
          _messages.add({
            "sender": "User 1",
            "message":
                "Sorry, I don’t get you. Please reply with 'single', 'married', 'divorced', or 'widowed'."
          });
        });
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        return;
      }
    }
    // Trigger the next reply
    _triggerReply();
  }

  bool _isValidDate(String input) {
    // Regex to match common date formats: DD/MM/YYYY, MM-DD-YYYY, YYYY-MM-DD, etc.
    final RegExp dateRegex = RegExp(
        r"^(0[1-9]|[12][0-9]|3[01])[-/](0[1-9]|1[0-2])[-/](\d{4})$|^(0[1-9]|1[0-2])[-/](0[1-9]|[12][0-9]|3[01])[-/](\d{4})$|^(\d{4})[-/](0[1-9]|1[0-2])[-/](0[1-9]|[12][0-9]|3[01])$");
    return dateRegex.hasMatch(input);
  }

  bool _isValidTime(String userMessage) {
    final RegExp timeRegex = RegExp(
        r"^(?:([01]\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?)$|^(?:0?[1-9]|1[0-2]):[0-5]\d(?::[0-5]\d)? (AM|PM)$",
        caseSensitive: false);
    return timeRegex.hasMatch(userMessage);
  }

  bool _isValidMaritalStatus(String userMessage) {
    // Define valid responses for marital status
    final List<String> validStatuses = [
      "single",
      "married",
      "divorced",
      "widowed"
    ];
    return validStatuses.contains(userMessage.toLowerCase());
  }

  void _triggerReply() {
    if (_currentReplyIndex < _user1Replies.length) {
      // Add "typing..." message to the chat
      setState(() {
        _messages.add({"sender": "User 1", "message": "typing..."});
      });

      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

      // Simulate the delay for the actual reply
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          // Replace the "typing..." message with the actual reply
          _messages[_messages.length - 1] = {
            "sender": "User 1",
            "message": _user1Replies[_currentReplyIndex]
          };
          _currentReplyIndex++;
        });

        _scrollToBottom();
      });
    }
  }

  // void _sendMessage(String text) {
  //   if (text.isEmpty) return;
  //
  //   // Add the second user's message
  //   setState(() {
  //     _messages.add({"sender": "User 2", "message": text});
  //   });
  //   _controller.clear();
  //   _scrollToBottom();
  //   Future.delayed(const Duration(seconds: 1),(){
  //     _triggerReply();
  //   });
  //
  //
  // }
  // // void _triggerReply() {
  // //
  // //   if (_currentReplyIndex < _user1Replies.length) {
  // //     Future.delayed(Duration(seconds: 1), () {
  // //       setState(() {
  // //         _messages.add({
  // //           "sender": "User 1",
  // //           "message": _user1Replies[_currentReplyIndex]
  // //         });
  // //         _currentReplyIndex++;
  // //
  // //       });
  // //       Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  // //     });
  // //   }
  // // }
  // void _triggerReply() {
  //   if (_currentReplyIndex < _user1Replies.length) {
  //     // Add "typing..." message to the chat
  //     setState(() {
  //       _messages.add({
  //         "sender": "User 1",
  //         "message": "typing..."
  //       });
  //     });
  //     Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  //
  //     // Simulate the delay for the actual reply
  //     Future.delayed(const Duration(seconds: 2), () {
  //       setState(() {
  //         // Replace the "typing..." message with the actual reply
  //         _messages[_messages.length - 1] = {
  //           "sender": "User 1",
  //           "message": _user1Replies[_currentReplyIndex]
  //         };
  //         _currentReplyIndex++;
  //       });
  //
  //       _scrollToBottom();
  //     });
  //   }
  // }

  final SplashController splashController =
      Get.put<SplashController>(SplashController());
  final BottomNavigationController bottomNavigationController =
      Get.put<BottomNavigationController>(BottomNavigationController());
  TimerController timerController = Get.put<TimerController>(TimerController());
  WalletController walletController =
      Get.put<WalletController>(WalletController());
  final ChatController chatController =
      Get.put<ChatController>(ChatController());
  bool islowbalance = false;
  // Timer? secTimer;
  // double Minutetime = 0.0;
  Timer? _timer;
  int _remainingSeconds = 60;
  // late AstrologerModel astrologerModel;

  // startTime(astrologerId, fireBasechatId) async {
  //   log("astrologerId==========================================>$astrologerId");
  //   log("fireBasechatId==========================================>$fireBasechatId");
  //   await bottomNavigationController.getAstrologerbyId(astrologerId);
  //   if (bottomNavigationController.astrologerbyId[0].charge == 0) {
  //     chatController.showtimer.value = false;
  //   } else {
  //     Minutetime = global.splashController.currentUser!.walletAmount! /
  //         bottomNavigationController.astrologerbyId[0].charge!;
  //
  //     secTimer =
  //         Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
  //           int timeCount = timer.tick;
  //           double updatedWalletAmount =
  //           global.splashController.currentUser!.walletAmount!;
  //           updatedWalletAmount = updatedWalletAmount -
  //               bottomNavigationController.astrologerbyId[0].charge! *( timeCount/60);
  //           log("${timer.tick}");
  //           log('${bottomNavigationController.astrologerbyId[0].charge! * 1 >= updatedWalletAmount}');
  //           if (bottomNavigationController.astrologerbyId[0].charge! * 1 >=
  //               updatedWalletAmount) {
  //             if (!timerController.isLowbalance.value) {
  //               chatController.sendMessage(
  //                   'User have low balance', fireBasechatId, astrologerId, true);
  //               timerController.isLowbalance.value = true;
  //               // timerController.isLowbalance.value = true;
  //             }
  //
  //             // openBottomSheetRechrage(context);
  //           }
  //         });
  //     chatController.showtimer.value = true;
  //     chatController.update();
  //   }
  // }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          global.showToast(message: "If you want to continue please recharge first", textColor: Colors.white, bgColor: Colors.orange);

          // global.showOnlyLoaderDialog(context);
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
        title: GestureDetector(
          onTap: () async {
            print('appbar tapped');
            if (widget.flagId == 0) {
              Get.find<ReviewController>().getReviewData(widget.astrologerId);
              global.showOnlyLoaderDialog(context);
              await bottomNavigationController
                  .getAstrologerbyId(widget.astrologerId);
              global.hideLoader();
              Get.to(() => AstrologerProfile(
                    index: 0,
                  ));
            }
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: CachedNetworkImage(
                  imageUrl: '${global.imgBaseurl}${widget.profileImage}',
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 48,
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    Images.deafultUser,
                    height: 40,
                    width: 30,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.astrologerName,
                    style: Get.theme.primaryTextTheme.headline6!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "${_remainingSeconds}s",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            if (widget.flagId == 0) {
              Get.back();
            } else {
              if (timerController.totalSeconds < 60) {
                Get.dialog(AlertDialog(
                  title: Text(
                    "You can end chat after one minute",
                    style: Get.textTheme.subtitle1,
                  ),
                  content: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Ok',
                        style: TextStyle(color: Get.theme.primaryColor)),
                  ),
                ));
              } else {
                Get.dialog(AlertDialog(
                  title: Text(
                    "Are you sure you want to end chat?",
                    style: Get.textTheme.subtitle1,
                  ),
                  content: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          global.showOnlyLoaderDialog(context);
                          final ChatController chatController =
                              Get.find<ChatController>();
                          chatController.sendMessage(
                              '${global.user.name == '' ? 'user' : global.user.name} -> ended chat',
                              widget.fireBasechatId,
                              widget.astrologerId,
                              true);
                          chatController.isChatRequest = false;
                          log("isChatRequest============================>${chatController.isChatRequest}");
                          chatController.showBottomAcceptChat = false;
                          global.sp = await SharedPreferences.getInstance();
                          chatController.isEndChat = true;
                          global.sp!.remove('chatBottom');
                          global.sp!.setInt('chatBottom', 0);
                          chatController.chatBottom = false;
                          chatController.isInchat = false;
                          chatController.isAstrologerEndedChat = false;
                          global.callOnFcmApiSendPushNotifications(
                              fcmTokem: [widget.fcmToken],
                              title: 'End chat from customer');
                          chatController.update();
                          await timerController.endChatTime(
                              timerController.totalSeconds, widget.chatId);
                          splashController.getCurrentUserData();
                          global.hideLoader();
                          timerController.min = 0;
                          timerController.minText = "";
                          timerController.sec = 0;
                          timerController.secText = "";
                          timerController.secTimer!.cancel();
                          timerController.update();
                          bottomNavigationController.astrologerList.clear();
                          bottomNavigationController.isAllDataLoaded = false;
                          if (bottomNavigationController.genderFilterList !=
                              null) {
                            bottomNavigationController.genderFilterList!
                                .clear();
                          }
                          if (bottomNavigationController.languageFilter !=
                              null) {
                            bottomNavigationController.languageFilter!.clear();
                          }
                          if (bottomNavigationController.skillFilterList !=
                              null) {
                            bottomNavigationController.skillFilterList!.clear();
                          }
                          bottomNavigationController.applyFilter = false;
                          bottomNavigationController.update();
                          await bottomNavigationController.getAstrologerList(
                              isLazyLoading: false);
                          // Get.back();
                          // Get.back();
                          // Get.back();
                          Get.off(() => BottomNavigationBarScreen(index: 0));
                        },
                        child: Text('Yes',
                            style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('No',
                            style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                    ],
                  ),
                ));
              }
            }
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Get.theme.iconTheme.color,
          ),
        ),
      ),
      body: Container(
        // height: height,
        // width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(Images.bgImage),
          ),
        ),
        // color: Colors.blue.withOpacity(0.2),
        child: Column(
          children: [
            SizedBox(height:10,),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser2 = message['sender'] == "User 2";
                  return Align(
                    alignment:
                        isUser2 ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isUser2 ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                            color: isUser2 ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                      ),
                      height: 50,
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {},
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5, left: 8),
                          hintText: " Enter Your Message",
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(color: Get.theme.primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Material(
                      elevation: 3,
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      child: Container(
                        height: 49,
                        width: 49,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _sendMessage(_controller.text);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.send,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
