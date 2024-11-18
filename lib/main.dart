import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:awesome_notification/main.dart';
import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/controllers/callController.dart';
import 'package:BharatiyAstro/controllers/chatController.dart';
import 'package:BharatiyAstro/controllers/customer_support_controller.dart';
import 'package:BharatiyAstro/controllers/liveController.dart';
import 'package:BharatiyAstro/controllers/reviewController.dart';
import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/controllers/themeController.dart';
import 'package:BharatiyAstro/firebase_options.dart';
import 'package:BharatiyAstro/l10n/l10n.dart';
import 'package:BharatiyAstro/theme/nativeTheme.dart';
import 'package:BharatiyAstro/utils/binding/networkBinding.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:BharatiyAstro/views/astrologerProfile/astrologerProfile.dart';
import 'package:BharatiyAstro/views/call/incoming_call_request.dart';
import 'package:BharatiyAstro/views/chat/incoming_chat_request.dart';
import 'package:BharatiyAstro/views/live_astrologer/live_astrologer_screen.dart';
import 'package:BharatiyAstro/views/loginScreen.dart';
import 'package:BharatiyAstro/views/splashScreen.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/VedioCallController.dart';
class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('_firebaseMessagingBackgroundHandler called..');
  global.sp = await SharedPreferences.getInstance();
  if (global.sp!.getString("currentUser") != null) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    global.generalPayload = json.encode(message.data['body']);
    log("=============================================Background notification ${message.notification!.title}");
    var messageData;
    if (message.data['body'] != null) {
      messageData = json.decode((message.data['body']));
      print("AmanSata$messageData");
    }
    if (message.notification!.title == "For starting the timer in other audions for video and audio") {
      print('_firebaseMessagingBackgroundHandler For starting the timer in other audions for video and audio');
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
        print({"manu1"});
      });
      if (liveController.isImInLive == true) {
        print("waitListId for 3rd users:" + message.data.toString());
        int waitListId = int.parse(message.data["waitListId"].toString());
        String channelName = message.data['channelName'];
        liveController.joinUserName = message.data['name'] ?? "User";
        liveController.joinUserProfile = message.data['profile'] ?? "";
        await liveController.getWaitList(channelName);

        print("liveController.waitList" + liveController.waitList[0].id.toString());
        int index5 = liveController.waitList.indexWhere((element) => element.id == waitListId);
        if (index5 != -1) {
          print("joined waitlist user time = " + liveController.waitList[index5].time.toString());
          liveController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(liveController.waitList[index5].time);
          liveController.update();
        }
      }
    } else if (message.notification!.title == "For Live accept/reject") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
        print({"manu2"});
      });
      if (liveController.isImInLive == true) {
        String astroName = message.data["astroName"];
        int astroId = message.data['astroId'] != null ? int.parse(message.data['astroId'].toString()) : 0;
        String channel = message.data['channel'];
        String token = message.data['token'];
        String astrologerProfile = message.data['astroProfile'] ?? "";
        String requestType = message.data['requestType'];
        int id = message.data['id'] != null ? int.parse(message.data['id'].toString()) : 0;
        double charge = message.data['charge'] != null ? double.parse(message.data['charge'].toString()) : 0;
        double videoCallCharge = message.data['videoCallCharge'] != null ? double.parse(message.data['videoCallCharge'].toString()) : 0;
        String astrologerFcmToken = message.data['fcmToken'] != null ? message.data['fcmToken'] : "";
        await bottomController.getAstrologerbyId(astroId);
        bool isFollow = bottomController.astrologerbyId[0].isFollow!;
        // not show notification just show dialog for accept/reject for live stream
        liveController.accpetDeclineContfirmationDialogForLiveStreaming(
          astroId: astroId,
          astroName: astroName,
          channel: channel,
          token: token,
          requestType: requestType,
          id: id,
          charge: charge,
          astrologerFcmToken2: astrologerFcmToken,
          astrologerProfile: astrologerProfile,
          videoCallCharge: videoCallCharge,
          isFollow: isFollow,
        );
      }
    } else if (message.notification!.title == "For accepting time while user already splitted") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
        print({"manu3"});
      });
      print("waitListId for 3rd users:" + message.data.toString());
      int timeInInt = int.parse(message.data["timeInInt"].toString());
      print("timeInInt" + timeInInt.toString());

      liveController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(timeInInt.toString());
      liveController.joinUserName = message.data["joinUserName"] ?? "";
      liveController.joinUserProfile = message.data["joinUserProfile"] ?? "";
      liveController.update();
    } else if (message.notification!.title == "Notification for customer support status update") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();

      });
      var message1 = jsonDecode(message.data['body']);
      if (customerSupportController.isIn) {
        customerSupportController.status = message1["status"] ?? "WAITING";
        customerSupportController.update();
      }
    } else if (message.notification!.title == "End chat from astrologer") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
        print({"manu5"});
      });
      chatController.showBottomAcceptChat = false;
      global.sp = await SharedPreferences.getInstance();
      global.sp!.remove('chatBottom');
      global.sp!.setInt('chatBottom', 0);
      chatController.chatBottom = false;
      chatController.isAstrologerEndedChat = true;
      chatController.update();
    } else if (message.notification!.title == "Astrologer Leave call") {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();print({"manu6"});
      });
      callController.showBottomAcceptCall = false;
      global.sp!.remove('callBottom');
      global.sp!.setInt('callBottom', 0);
      callController.callBottom = false;
      callController.update();
    } else if (messageData['notificationType'] == 4) {
      print('live astrologer $messageData');
      await bottomController.getLiveAstrologerList();
      bottomController.liveAstrologer = bottomController.liveAstrologer;
      bottomController.update();
      if (messageData['isFollow'] == 1) {
        //1 means user follow that astrologer
      } else {
        Future.delayed(Duration(milliseconds: 500)).then((value) async {
          await _localNotifications.cancelAll();

        });
      }
    } else if (messageData['notificationType'] == 3) {

      // chatController.showBottomAcceptChatRequest(
      //   astrologerId: messageData["astrologerId"],
      //   chatId: messageData["chatId"],
      //   astroName: messageData["astrologerName"] == null ? "Astrologer" : messageData["astrologerName"],
      //   astroProfile: messageData["profile"] == null ? "" : messageData["profile"],
      //   firebaseChatId: messageData["firebaseChatId"],
      //   fcmToken: messageData["fcmToken"],
      // );
    } else if (messageData['notificationType'] == 1) {
      print('fcmtoken for call:- ${messageData["fcmToken"]}');
      print('😁😁😁😁');
/// call notification come this will active

      callController.showBottomAcceptCallRequest(
        channelName: messageData["channelName"] ?? "",
        astrologerId: messageData["astrologerId"] ?? 0,
        callId: messageData["callId"],
        token: messageData["token"] ?? "",
        astroName: messageData["astrologerName"] ?? "Astrologer",
        astroProfile: messageData["profile"] ?? "",
        fcmToken: messageData["fcmToken"] ?? "",
        isBackGround: true,
        isSoundOn:true,
      );
    } else if (messageData['notificationType'] == 14) {
      Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
        print({"manu8"});
      });
      await bottomController.getLiveAstrologerList();
    }
  } else {
    Future.delayed(Duration(milliseconds: 500)).then((value) async {
      await _localNotifications.cancelAll();
      print({"manu9"});
    });
  }
}

void main() async {
  final facebookAppEvents = FacebookAppEvents();
  facebookAppEvents.logEvent(
    name:"app_launch",
    parameters: {
      'timestamp': DateTime.now().toString()
    },
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  HttpOverrides.global = PostHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
      log("firebasee token===================>${value}");
    });
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // await NotificationController.initializeLocalNotifications();
  // print(settings);
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelKey: 'callChannel',
  //       channelName: 'Channel of calling',
  //       channelDescription: 'channel of calling',
  //       defaultColor: Colors.redAccent,
  //       ledColor: Colors.white,
  //       importance: NotificationImportance.High,
  //       channelShowBadge: true, // Show badge when the notification arrives
  //       // Allow the notification to bypass Do Not Disturb mode
  //       locked: true,
  //       criticalAlerts: true

  //       // defaultRingtoneType: DefaultRingtoneType.Ringtone
  //       )
  // ]);

  HttpOverrides.global = new MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
  await fetchLinkData();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

Future fetchLinkData() async {
  // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
  PendingDynamicLinkData? link = await FirebaseDynamicLinks.instance.getInitialLink();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
  if (link != null) {
    handleLinkData(link);
  }

  //This will handle incoming links if the application is already opened
  dynamicLinks.onLink.listen((dynamicLinkData) {
    handleLinkData(dynamicLinkData);
  }).onError((error) {
    print('onLink error');
    print(error.message);
  });
}

BottomNavigationController bottomController = Get.put(BottomNavigationController());

LiveController liveController = Get.put(LiveController());
CustomerSupportController customerSupportController = Get.put(CustomerSupportController());
ChatController chatController = Get.put(ChatController());
CallController callController = Get.put(CallController());
void handleLinkData(PendingDynamicLinkData? data) async {
  final Uri uri = data!.link;
  String? screen;
  // ignore: unnecessary_null_comparison
  if (uri != null) {
    final queryParams = uri.queryParameters;
    if (queryParams.length > 0) {
      screen = queryParams["screen"]!;
    }
    if (screen != null) {
      global.sp = await SharedPreferences.getInstance();
      if (global.sp!.getString("currentUser") != null) {
        if (screen == "liveStreaming") {
          String? token = "";
          String channelName = queryParams["channelName"]!;
          token = await bottomController.getTokenFromChannelName(channelName);
          String astrologerName = queryParams["astrologerName"]!;
          int astrologerId = int.parse(queryParams["astrologerId"]!);
          double charge = double.parse(queryParams["charge"]!);
          double videoCallCharge = double.parse(queryParams["videoCallCharge"]!);
          bottomController.anotherLiveAstrologers = bottomController.liveAstrologer.where((element) => element.astrologerId != astrologerId).toList();
          bottomController.update();
          await liveController.getWaitList(channelName);
          int index2 = liveController.waitList.indexWhere((element) => element.userId == global.currentUserId);
          if (index2 != -1) {
            liveController.isImInWaitList = true;
            liveController.update();
          } else {
            liveController.isImInWaitList = false;
            liveController.update();
          }
          liveController.isImInLive = true;
          liveController.isJoinAsChat = false;
          liveController.isLeaveCalled = false;
          await bottomController.getAstrologerbyId(astrologerId);
          bool isFollow = bottomController.astrologerbyId[0].isFollow!;
          liveController.update();
          Get.to(() => LiveAstrologerScreen(
                token: token!,
                channel: channelName,
                astrologerName: astrologerName,
                astrologerId: astrologerId,
                isFromHome: true,
                charge: charge,
                isForLiveCallAcceptDecline: false,
                videoCallCharge: videoCallCharge,
                isFollow: isFollow,
              ));
          // need to set navigation to live astologer page.
        }
      } else {
        Get.to(() => LoginScreen());
      }
    }
  }
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'Atroguru local notifications',
    'High Importance Notifications for Atroguru',
    importance: Importance.defaultImportance,
  );

  VedioController videoontroller = Get.put(VedioController());

  @override
  void initState() {
    super.initState();
    // AwesomeNotifications().actionStream.listen(((event) {
    //   if (event.buttonKeyPressed == "Accecpt") {
    //     log("call method is called ");
    //     FlutterRingtonePlayer.stop();
    //     _MyAppState.navigatorKey.currentState!.push(
    //       MaterialPageRoute(
    //           builder: (_) => 
    // AcceptChatScreen(
    //                 astrologerId: global.sp!.getInt("bottomAstrologerId") ?? 0,
    //                 chatId: global.sp!.getInt("bottomChatId") ?? 0,
    //                 astrologerName: global.sp!.getString("bottomAstrologerName") ?? "",
    //                 fireBasechatId: global.sp!.getString("bottomFirebaseChatId") ?? "",
    //                 flagId: 1,
    //                 profileImage: global.sp!.getString("bottomAstrologerProfile") ?? "",
    //                 fcmToken: global.sp!.getString("bottomFcmToken") ?? "",
    //               )),
    //     );
    //   }
    //   if (event.buttonKeyPressed == "Reject") {
    //     log("call method is called ");
    //     FlutterRingtonePlayer.stop();
    //   }
    // }));
    //Sent Notification When App is Running || Background Message is Automatically Sent by Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("message id" + message.data.toString());

      print('chnannelName data ${message.data['ChannelName']}');
      print('chnannelName data ${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}');

      if (message.notification!.title == "For Live accept/reject") {
        if (liveController.isImInLive == true) {
          String astroName = message.data["astroName"];
          int astroId = message.data['astroId'] != null ? int.parse(message.data['astroId'].toString()) : 0;
          String channel = message.data['channel'];
          String token = message.data['token'];
          String astrologerProfile = message.data['astroProfile'] ?? "";
          String requestType = message.data['requestType'];
          int id = message.data['id'] != null ? int.parse(message.data['id'].toString()) : 0;
          double charge = message.data['charge'] != null ? double.parse(message.data['charge'].toString()) : 0;
          double videoCallCharge = message.data['videoCallCharge'] != null ? double.parse(message.data['videoCallCharge'].toString()) : 0;
          String astrologerFcmToken = message.data['fcmToken'] != null ? message.data['fcmToken'] : "";
          await bottomController.getAstrologerbyId(astroId);
          bool isFollow = bottomController.astrologerbyId[0].isFollow!;
          // not show notification just show dialog for accept/reject for live stream
          liveController.accpetDeclineContfirmationDialogForLiveStreaming(
            astroId: astroId,
            astroName: astroName,
            channel: channel,
            token: token,
            requestType: requestType,
            id: id,
            charge: charge,
            astrologerFcmToken2: astrologerFcmToken,
            astrologerProfile: astrologerProfile,
            videoCallCharge: videoCallCharge,
            isFollow: isFollow,
          );
        }
      } else if (message.notification!.title == "For starting the timer in other audions for video and audio") {
        if (liveController.isImInLive == true) {
          print("waitListId for 3rd users:" + message.data.toString());
          int waitListId = int.parse(message.data["waitListId"].toString());
          String channelName = message.data['channelName'];
          liveController.joinUserName = message.data['name'] ?? "User";
          liveController.joinUserProfile = message.data['profile'] ?? "";
          await liveController.getWaitList(channelName);

          print("liveController.waitList" + liveController.waitList[0].id.toString());
          int index5 = liveController.waitList.indexWhere((element) => element.id == waitListId);
          if (index5 != -1) {
            print("joined waitlist user time = " + liveController.waitList[index5].time.toString());
            liveController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(liveController.waitList[index5].time);
            liveController.update();
          }
        }
      } else if (message.notification!.title == "For accepting time while user already splitted") {
        print("waitListId for 3rd users:" + message.data.toString());
        int timeInInt = int.parse(message.data["timeInInt"].toString());
        print("timeInInt" + timeInInt.toString());

        liveController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(timeInInt.toString());
        liveController.joinUserName = message.data["joinUserName"] ?? "";
        liveController.joinUserProfile = message.data["joinUserProfile"] ?? "";
        liveController.update();
      } else if (message.notification!.title == "Notification for customer support status update") {
        var message1 = jsonDecode(message.data['body']);
        if (customerSupportController.isIn) {
          customerSupportController.status = message1["status"] ?? "WAITING";
          customerSupportController.update();
        }
      } else if (message.notification!.title == "End chat from astrologer") {
        chatController.showBottomAcceptChat = false;
        global.sp = await SharedPreferences.getInstance();
        global.sp!.remove('chatBottom');
        global.sp!.setInt('chatBottom', 0);
        chatController.chatBottom = false;
        chatController.isAstrologerEndedChat = true;
        chatController.update();
      } else if (message.notification!.title == "Astrologer Leave call") {
        callController.showBottomAcceptCall = false;
        global.sp!.remove('callBottom');
        global.sp!.setInt('callBottom', 0);
        callController.callBottom = false;
        callController.update();
      } else if (message.notification!.title == "Accept Chat Request From somnath") {
        callController.showBottomAcceptCall = false;
        global.sp!.remove('callBottom');
        global.sp!.setInt('callBottom', 0);
        callController.callBottom = false;
        callController.update();
      }

      try {
        if (message.data.isNotEmpty) {
          var messageData = json.decode((message.data['body']));
          print('body $messageData');
          if (messageData['notificationType'] != null) {
            if (messageData['notificationType'] == 3) {
              log("here is the log that happens multyple time");

              await chatController.showBottomAcceptChatRequest(
                context: context,
                astrologerId: messageData["astrologerId"],
                chatId: messageData["chatId"],
                astroName: messageData["astrologerName"] == null ? "Astrologer" : messageData["astrologerName"],
                astroProfile: messageData["profile"] == null ? "" : messageData["profile"],
                firebaseChatId: messageData["firebaseChatId"],
                fcmToken: messageData["fcmToken"],
              );
                 Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
        print({"manu10"});
      });
            } else if (messageData['notificationType'] == 1) {
              //     print('fcmtoken for call:- ${messageData["fcmToken"]}');
              print('😆😆😆😆😆');
              callController.showBottomAcceptCallRequest(
                  channelName: messageData["channelName"] ?? "",
                  astrologerId: messageData["astrologerId"] ?? 0,
                  callId: messageData["callId"],
                  token: messageData["token"] ?? "",
                  astroName: messageData["astrologerName"] ?? "Astrologer",
                  astroProfile: messageData["profile"] ?? "",
                  fcmToken: messageData["fcmToken"] ?? "",
                  isBackGround: false);
                     Future.delayed(Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
        print({"manu11"});
      });
            } else if (messageData['notificationType'] == 4) {
              print('live astrologer $messageData');
              await bottomController.getLiveAstrologerList();
              if (messageData['isFollow'] == 1) {
                //1 means user follow that astrologer
                foregroundNotification(message);
                await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
              }
            } else if (messageData['notificationType'] == 3) {
              print('notification got .......................');
            } else if (messageData['notificationType'] == 14) {
              print('live astrologer $messageData');
              await bottomController.getLiveAstrologerList();
            } else {
              foregroundNotification(message);
              await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
            }
          } else {
            if (message.notification!.title != "Accept Call Request") {
              foregroundNotification(message);
              await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
            }
          }
        } else {
          if (message.notification!.title != "Accept Call Request") {
            foregroundNotification(message);
            await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
          }
        }
      } catch (e) {
        if (message.notification!.title != "Accept Call Request") {
          foregroundNotification(message);
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        }
      }
    });
    //Perform On Tap Operation On Notification Click when app is in backgroud Or in Kill Mode
    FlutterRingtonePlayer.stop();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("👍👍👍👍");
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onSelectNotification(json.encode(message.data));
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('getInitialMessage return not null');
        print('Message Notification:' + message.notification!.body.toString());
        global.generalPayload = json.encode(message.data);
        print('${global.generalPayload.toString()}');
      }
    });});

  }

  Future<void> foregroundNotification(RemoteMessage payload) async {
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print("object notification call");
        return;
      },
    );
    AndroidInitializationSettings android = const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initialSetting = InitializationSettings(android: android, iOS: initializationSettingsDarwin);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initialSetting, onDidReceiveNotificationResponse: (_) {
      onSelectNotification(json.encode(payload.data));
    });

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('asset/sound/notification.mp3'),
    );
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        payload.notification!.title,
        payload.notification!.body,
        platformChannelSpecifics,
        payload: json.encode(payload.data.toString()),
      );
    }
  }

  Future<void> onSelectNotification(String payload) async {
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
      Map<dynamic, dynamic> messageData;
      try {
        messageData = json.decode(payload);
        Map<dynamic, dynamic> body;
        body = jsonDecode(messageData['body']);
        if (body["notificationType"] == 1) {
          Get.to(() => IncomingCallRequest(
                astrologerId: body["astrologerId"],
                astrologerName: body["astrologerName"] == null ? "Astrologer" : body["astrologerName"],
                astrologerProfile: body["profile"] == null ? "" : body["profile"],
                token: body["token"],
                channel: body["channelName"],
                callId: body["callId"],
                fcmToken: body["fcmToken"] ?? "",
              ));
        } else if (body["notificationType"] == 3) {
            Get.to(() => IncomingChatRequest(
                  astrologerName: body["astrologerName"] == null ? "Astrolo ger" : body["astrologerName"],
                  profile: body["profile"] == null ? "" : body["profile"],
                  fireBasechatId: body["firebaseChatId"],
                  chatId: body["chatId"],
                  astrologerId: body["astrologerId"],
                  fcmToken: body["fcmToken"],
                ));
          // if (chatController.isAstrologerEndedChat == true) {
          //   global.showToast(
          //     message: 'Astrologer ended chat',
          //     textColor: global.textColor,
          //     bgColor: global.toastBackGoundColor,
          //   );
          // } else {
          
          // }
        } else if (body["notificationType"] == 4) {
          print('live astrologer');
          Get.find<ReviewController>().getReviewData(body["astrologerId"]);

          await bottomController.getAstrologerbyId(body["astrologerId"]);

          Get.to(() => AstrologerProfile(index: 0));
        } else {
          print('other notification');
        }
      } catch (e) {
        print(
          'Exception in onSelectNotification main.dart:- ${e.toString()}',
        );
      }
    }
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final String apiKey = "AIzaSyDwps2hHZbsri0yg4NPUYdQoj5BOsZmWK0";
  ThemeController themeController = Get.put(ThemeController());
  SplashController splashController = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<SplashController>(builder: (s) {
        return GoogleTranslatorInit(apiKey,
            translateFrom: Locale(splashController.currentLanguageCode == 'en' ? 'hi' : 'en'),
            translateTo: Locale(splashController.currentLanguageCode),
            automaticDetection: true, builder: () {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            enableLog: true,
            theme: nativeTheme(),
            initialBinding: NetworkBinding(),
            title: 'Bharatiya',
            initialRoute: "SplashScreen",
            supportedLocales: L10n.all,
            home: SplashScreen(),
          );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
