import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/razorPayController.dart';
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
import 'paymentInformationScreen.dart';

class FreeChatScreen extends StatefulWidget {
  final int flagId;
  final String profileImage;
  final String astrologerName;
  final String fireBasechatId;
  final int chatId;
  final int astrologerId;
  final String? fcmToken;
  final String balance;
  const FreeChatScreen({
    Key? key,
    required this.flagId,
    required this.profileImage,
    required this.astrologerName,
    required this.fireBasechatId,
    required this.chatId,
    required this.astrologerId,
    this.fcmToken,
    required this.balance,
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
      _sendRandomGreeting();
      // _triggerReply();
    });

    super.initState();
  }
  final List<Map<String, String>> _messages = []; // Stores all messages
  final List<String> _greetingMessages = [
    "Hello!",
    "Hi there!",
    "Namaste!",
    "Greetings!",
    "Hello! It's a pleasure to meet you,"
  ];
  final List<String> _positiveMessages = [
    "Stay positive and keep moving forward! 😊",
    "Good things are coming your way! 🌟",
    "Believe in yourself! You're amazing! 💪",
    "Success is on the horizon! Keep going! 🌈",
    "You're doing great! Keep up the good work! 🌟"
  ];

  final List<String> _user1Replies = [
    "What is your name?",
    "What is your gender?",
    "What is your Date of Birth?",
    "What is your Time of Birth?",
    "What is your marital status?",
    "How may i help you?",
    "Do you have your kundali?",
    "Ok wait",
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
  void _sendPositiveMessage() {
    final positiveMessage = _positiveMessages[
    (DateTime.now().millisecondsSinceEpoch % _positiveMessages.length)
    ];

    setState(() {
      _messages.add({"sender": "User 1", "message": positiveMessage});
    });

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

  }
  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "User 2", "message": text});
    });

    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    _handleReply(text);
  }

  void _handleReply(String userMessage) {
    // Custom validation logic for specific questions
    if (_currentReplyIndex == 2) {
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
    if (_currentReplyIndex == 3) {
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
    if (_currentReplyIndex == 4) {
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

    if (_currentReplyIndex == 5) {
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
    if (_currentReplyIndex == 5) {
      // After asking for marital status, send positive messages
      _sendPositiveMessage();
    }


  _triggerReply();
  }

  // bool _isValidDate(String input) {
  //   // Regex to match common date formats: DD/MM/YYYY, MM-DD-YYYY, YYYY-MM-DD, etc.
  //   final RegExp dateRegex = RegExp(
  //       r"^(0[1-9]|[12][0-9]|3[01])[-/](0[1-9]|1[0-2])[-/](\d{4})$|^(0[1-9]|1[0-2])[-/](0[1-9]|[12][0-9]|3[01])[-/](\d{4})$|^(\d{4})[-/](0[1-9]|1[0-2])[-/](0[1-9]|[12][0-9]|3[01])$");
  //   return dateRegex.hasMatch(input);
  // }
  bool _isValidDate(String input) {
    // Regex to match common date formats: DD/MM/YYYY, MM-DD-YYYY, YYYY-MM-DD, etc.
    final RegExp dateRegex = RegExp(
        r"^(0[1-9]|[12][0-9]|3[01])[-/](0[1-9]|1[0-2])[-/](\d{4})$|^(0[1-9]|1[0-2])[-/](0[1-9]|[12][0-9]|3[01])[-/](\d{4})$|^(\d{4})[-/](0[1-9]|1[0-2])[-/](0[1-9]|[12][0-9]|3[01])$");

    // Check if the input matches the date format
    if (!dateRegex.hasMatch(input)) {
      return false;
    }
    try {
      DateTime enteredDate;
      if (input.contains('/')) {
        // Handle DD/MM/YYYY or MM/DD/YYYY formats
        final parts = input.split('/');
        if (parts[2].length == 4) {
          // Assume DD/MM/YYYY
          enteredDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } else {
          return false; // Invalid format
        }
      } else if (input.contains('-')) {
        // Handle MM-DD-YYYY or YYYY-MM-DD formats
        final parts = input.split('-');
        if (parts[0].length == 4) {
          // Assume YYYY-MM-DD
          enteredDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        } else {
          // Assume MM-DD-YYYY
          enteredDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      } else {
        return false; // Invalid format
      }

      // Check if the entered date is today or a past date
      final today = DateTime.now();
      if (enteredDate.isAfter(today)) {
        return false; // Future date
      }

      return true;
    } catch (e) {
      return false; // Invalid date parsing
    }
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
  void _sendRandomGreeting() {
    final randomGreeting = _greetingMessages[
    (DateTime.now().millisecondsSinceEpoch % _greetingMessages.length)
    ];

    setState(() {
      _messages.add({"sender": "User 1", "message": randomGreeting});
    });

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    // Future.delayed(const Duration(seconds: 1), _triggerReply);
  }
  void _triggerReply() {
    if (_currentReplyIndex < _user1Replies.length) {
      setState(() {
        _messages.add({"sender": "User 1", "message": "typing..."});
      });

      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
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
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          global.showToast(message: "If you want to continue please recharge first", textColor: Colors.white, bgColor: Colors.orange);
          global.showOnlyLoaderDialog(context);
          // await walletController.getAmount();
          global.hideLoader();
          Future.delayed(Duration(seconds: 2),(){
            openBottomSheetRechrage(context, widget.balance,
                '${widget.astrologerName}');
          });

        }
      });
    });
  }

int balance=0;

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
                  final  balance=(bottomNavigationController.astrologerList[index].charge! * 5).toString();
                  print("amanwwww$balance");
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
                          onTap: () async{
                            if(_remainingSeconds==0) {
                              global.showToast(message: "If you want to continue please recharge first", textColor: Colors.white, bgColor: Colors.orange);
                              await walletController.getAmount();
                              global.showOnlyLoaderDialog(context);
                              Future.delayed(Duration(seconds: 2),(){
                                openBottomSheetRechrage(context, (bottomNavigationController.astrologerList[0].charge! * 5).toString(),
                                    '${widget.astrologerName}');
                              });
                              global.hideLoader();
                            }else{
                              _sendMessage(_controller.text);
                            }
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
  void openBottomSheetRechrage(BuildContext context, String minBalance, String astrologer) {
    Get.bottomSheet(
      Wrap(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.85,
                                  child: minBalance != ''
                                      ? Text(
                                      'Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start conversation with $astrologer ',
                                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red))
                                      : const SizedBox(),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: minBalance == ''
                                        ? const EdgeInsets.only(top: 8)
                                        : const EdgeInsets.only(top: 0),
                                    child: Icon(Icons.close, size: 18),
                                  ),
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                              child: Text('Recharge Now', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Icon(Icons.lightbulb_rounded, color: Get.theme.primaryColor, size: 13),
                                ),
                                Expanded(
                                    child: Text(
                                        'Minimum balance required ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance',
                                        style: TextStyle(fontSize: 12)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              child: GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:MediaQuery.of(context).size.width<300?2:3,
                    childAspectRatio: 3 / 3.5,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  // physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: walletController.rechrage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.delete<RazorPayController>();
                        Get.to(() => PaymentInformationScreen(
                          amount: double.parse(walletController.paymentAmount[index].amount.toString()),
                          extraAmount: walletController.paymentAmount[index].amount! *
                              (walletController.paymentAmount[index].offer! / 100),
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Container(
                          // padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 2, color: Colors.black38)],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  gradient: LinearGradient(
                                      transform: GradientRotation(180), colors: [Colors.white, Get.theme.primaryColor]),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                                height: 25,
                                child: Center(
                                  child: Text(
                                    '${walletController.paymentAmount[index].offer}% Extra',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.paymentAmount[index].amount}',
                                    style: Get.textTheme.titleSmall!.copyWith(color: Colors.black, fontSize: 16),
                                  ),
                                  Text(
                                    'Get',
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}  ${walletController.paymentAmount[index].amount! + (walletController.paymentAmount[index].offer! / 100) * int.parse("${walletController.paymentAmount[index].amount}")}',
                                    style: Get.textTheme.titleSmall!.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }
}
