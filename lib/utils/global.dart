//import 'package:flutter/animation.dart';
// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:BharatiyAstro/model/current_user_model.dart';
import 'package:BharatiyAstro/model/hororscopeSignModel.dart';
import 'package:BharatiyAstro/model/systemFlagNameListModel.dart';
import 'package:BharatiyAstro/utils/services/api_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_translator/google_translator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:translator/translator.dart';

import '../controllers/loginController.dart';
import '../controllers/networkController.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../views/loginScreen.dart';

String currentLocation = '';
SharedPreferences? sp;
String? currencyISOCode3;
dynamic generalPayload;

String timeFormat = '24';
String? appDeviceId;
FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
String languageCode = 'en';
String? mapBoxAPIKey;
APIHelper apiHelper = APIHelper();
bool isRTL = false;
String status = "WAITING";
CurrentUserModel? currentUserPayment;
CurrentUserModel user = CurrentUserModel();
Color toastBackGoundColor = Colors.black;
Color textColor = Colors.white;
NetworkController networkController = Get.put((NetworkController()));
SplashController splashController = Get.find<SplashController>();
final DateFormat formatter = DateFormat("dd MMM yy, hh:mm a");

String stripeBaseApi = 'https://api.stripe.com/v1';

String baseUrl = "https://bharatiyastro.com/api";
String imgBaseurl = "https://bharatiyastro.com/";
String webBaseUrl = "https://bharatiyastro.com/";
String appMode = "LIVE";
Map<String, dynamic> appParameters = {
  "LIVE": {
    "apiUrl": "https://bharatiyastro.com/",
    "imageBaseurl": "https://bharatiyastro.com/"
  },
  "DEV": {
    "apiUrl": "http://192.168.29.223:8001/api",
    "imageBaseurl": "http://192.168.29.223:8001/",
  }
};
String agoraChannelName = ""; //valid 24hr
String agoraToken = "";
String channelName = "BharatiyAstroCall";
String agoraLiveToken = "";
String liveChannelName = "BharatiyAstroLive";
String agoraChatUserId = "BharatiyAstroUser";
String chatChannelName = "BharatiyAstroChat";
String agoraChatToken = "";
String encodedString = "&&";
Color coursorColor = Color(0xFF757575);
int? currentUserId;
String agoraResourceId = "";
String agoraResourceId2 = "";
String agoraSid1 = "";
String agoraSid2 = "";
String? googleAPIKey;
String lat = "21.124857";
String lng = "73.112610";
var nativeAndroidPlatform = const MethodChannel('nativeAndroid');
int? localUid;
int? localLiveUid;
int? localLiveUid2;
bool isHost = false;
Future<bool> callOnFcmApiSendPushNotifications(
    {List<String?>? fcmTokem,
    String? title,
    String? subTitle,
    sendData,
    String? notificationType}) async {
  try {
    String postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": fcmTokem,
      "notification": {
        "title": title,
        "body": subTitle,
        "sound": "default",
        "color": "#ff3296fa",
        "vibrate": "300",
        "priority": 'high',
        "content_available": 'true',
      },
      "android": {
        "priority": 'high',
        "notification": {
          " sound": 'default',
          "color": '#ff3296fa',
          "clickAction": 'FLUTTER_NOTIFICATION_CLICK',
          "content_available": 'true',
          "notificationType": notificationType ?? '52',
        },
      },
      "data": sendData
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAmwRvEy0:APA91bE_lDUJ8Llz9Y9QsWxp2pITgnjwNOeZ84U-GeWrCu99xT_SCXinqrCWMObYQiaMBMwtu9bMHdZhyD1G0g2HKgl_KEJqQpPzdcyfudZD-QERgFWaVDAMj3THPn1EOrMy2mDIXBTU' // 'key=YOUR_SERVER_KEY'
    };
    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
    if (response.statusCode == 200) {
      // on success do sth
      print('Send');
      return true;
    } else {
      print('Error');
      // on failure do sth
      return false;
    }
  } catch (e) {
    print(
        "Exception -  global.dart - callOnFcmApiSendPushNotifications(): ${e.toString()}");
    return false;
  }
}

/* stripe implement */

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

String getCleanedNumber(String text) {
  RegExp regExp = new RegExp(r"[^0-9]");
  return text.replaceAll(regExp, '');
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

List<int> getExpiryDate(String value) {
  var split = value.split(new RegExp(r'(\/)'));
  return [int.parse(split[0]), int.parse(split[1])];
}

int convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

bool hasDateExpired(int month, int year) {
  return !(month == null || year == null) && isNotExpired(year, month);
}

bool isNotExpired(int year, int month) {
  // It has not expired if both the year and date has not passed
  return !hasYearPassed(year) && !hasMonthPassed(year, month);
}

bool hasYearPassed(int year) {
  int fourDigitsYear = convertYearTo4Digits(year);
  var now = DateTime.now();
  // The year has passed if the year we are currently is more than card's
  // year
  return fourDigitsYear < now.year;
}

bool hasMonthPassed(int year, int month) {
  var now = DateTime.now();
  // The month has passed if:
  // 1. The year is in the past. In that case, we just assume that the month
  // has passed
  // 2. Card's month (plus another month) is more than current month.
  return hasYearPassed(year) ||
      convertYearTo4Digits(year) == now.year && (month < now.month + 1);
}

//Strip implement finish

Future<void> createAndShareLinkForHistoryChatCall() async {
  try {
    showOnlyLoaderDialog(Get.context);
    String appShareLink;
    String applink;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bharatiyastro.com/',
      link: Uri.parse(
          "https://bharatiyastro.com/userProfile?screen=historyCallChat"),
      androidParameters: AndroidParameters(
        packageName: 'com.bharatiyastro.userapp',
        minimumVersion: 1,
      ),
    );
    Uri url;
    final ShortDynamicLink shortLink = await dynamicLinks
        .buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
    url = shortLink.shortUrl;
    appShareLink = url.toString();
    applink = appShareLink;
    hideLoader();
    await FlutterShare.share(
      title:
          'Check my call on ${global.getSystemFlagValue(global.systemFlagNameList.appName)} app. You should also try and see your future. First call is free',
      text:
          'Check my call on ${global.getSystemFlagValue(global.systemFlagNameList.appName)} app. You should also try and see your future. First call is free',
      linkUrl: '$applink',
    );
  } catch (e) {
    print("Exception - global.dart - referAndEarn():" + e.toString());
  }
}

Future<void> createAndShareTrackPlanet() async {
  try {
    showOnlyLoaderDialog(Get.context);
    String appShareLink;
    String applink;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bharatiyastro.com',
      link:
          Uri.parse("https://bharatiyastro.com/userProfile?screen=trackPlanet"),
      androidParameters: AndroidParameters(
        packageName: 'com.BharatiyAstro.app',
        minimumVersion: 1,
      ),
    );
    Uri url;
    final ShortDynamicLink shortLink = await dynamicLinks
        .buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
    url = shortLink.shortUrl;
    appShareLink = url.toString();
    applink = appShareLink;
    hideLoader();
    await FlutterShare.share(
      title:
          'The movement of our planets in the sky impact our lives daily. Now track every movement of your planets on BharatiyAstro for FREE!',
      text:
          'The movement of our planets in the sky impact our lives daily. Now track every movement of your planets on BharatiyAstro for FREE!',
      linkUrl: '$applink',
    );
  } catch (e) {
    print("Exception - global.dart - referAndEarn():" + e.toString());
  }
}

Future<void> createAndShareLinkForBloog(String title) async {
  try {
    showOnlyLoaderDialog(Get.context);
    String appShareLink;
    String applink;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bharatiyastro.com',
      link: Uri.parse("https://bharatiyastro.com/userProfile?screen=blogs"),
      androidParameters: AndroidParameters(
        packageName: 'com.BharatiyAstro.app',
        minimumVersion: 1,
      ),
    );
    Uri url;
    final ShortDynamicLink shortLink = await dynamicLinks
        .buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
    url = shortLink.shortUrl;
    appShareLink = url.toString();
    applink = appShareLink;
    hideLoader();
    await FlutterShare.share(
      title: '$title BharatiyAstro',
      text: '$title BharatiyAstro',
      linkUrl: '$applink',
    );
  } catch (e) {
    print("Exception - global.dart - referAndEarn():" + e.toString());
  }
}

Future<void> createAndShareAstroProfile(ScreenshotController sc) async {
  try {
    showOnlyLoaderDialog(Get.context);
    String appShareLink;
    String applink;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bharatiyastro.com',
      link: Uri.parse(
          "https://bharatiyastro.com/userProfile?screen=astroProfile"),
      androidParameters: AndroidParameters(
        packageName: 'com.BharatiyAstro.app',
        minimumVersion: 1,
      ),
    );
    Uri url;
    final ShortDynamicLink shortLink = await dynamicLinks
        .buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
    url = shortLink.shortUrl;
    appShareLink = url.toString();
    applink = appShareLink;
    hideLoader();
    shareAstroProfile(applink, sc);
  } catch (e) {
    print("Exception - global.dart - referAndEarn():" + e.toString());
  }
}

shareAstroProfile(String appShareLink, ScreenshotController sc) async {
  final directory = (await getApplicationDocumentsDirectory()).path;
  sc.capture().then((Uint8List? image) async {
    if (image != null) {
      try {
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        final imagePath = await File('$directory/$fileName.png').create();
        if (imagePath != null) {
          final temp = await getExternalStorageDirectory();
          final path = '${temp!.path}/$fileName.jpg';
          File(path).writeAsBytesSync(image);
          await FlutterShare.shareFile(
                  filePath: path,
                  title:
                      '${getSystemFlagValueForLogin(systemFlagNameList.appName)}',
                  text: "$appShareLink")
              .then((value) {})
              .catchError((e) {
            print(e);
            // showCustomSnackBar(e.toString());
          });
        }
      } catch (error) {}
    }
  }).catchError((onError) {
    print('Error --->> $onError');
  });
}

createAndShareLinkForDailyHorscope(ScreenshotController sc) async {
  showOnlyLoaderDialog(Get.context);
  String appShareLink;
  String applink;
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://bharatiyastro.com',
    link:
        Uri.parse("https://bharatiyastro.com/userProfile?screen=dailyHorscope"),
    androidParameters: AndroidParameters(
      packageName: 'com.BharatiyAstro.app',
      minimumVersion: 1,
    ),
  );
  Uri url;
  final ShortDynamicLink shortLink = await dynamicLinks
      .buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
  url = shortLink.shortUrl;
  appShareLink = url.toString();
  applink = appShareLink;
  hideLoader();
  final directory = (await getApplicationDocumentsDirectory()).path;
  sc.capture().then((Uint8List? image) async {
    if (image != null) {
      try {
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        final imagePath = await File('$directory/$fileName.png').create();
        if (imagePath != null) {
          final temp;
          if (Platform.isIOS) {
            temp = await getApplicationDocumentsDirectory();
          } else {
            temp = await getExternalStorageDirectory();
          }

          //final temp = await getExternalStorageDirectory();
          final path = '${temp!.path}/$fileName.jpg';
          File(path).writeAsBytesSync(image);
          await FlutterShare.shareFile(
                  filePath: path,
                  title:
                      '${getSystemFlagValueForLogin(systemFlagNameList.appName)}',
                  text:
                      "Check out your free daily horoscope on ${global.getSystemFlagValue(global.systemFlagNameList.appName)} & plan your day batter $appShareLink")
              .then((value) {})
              .catchError((e) {
            print(e);
          });
        }
      } catch (error) {}
    }
  }).catchError((onError) {
    print('Error --->> $onError');
  });
}

abstract class DateFormatter {
  static String? formatDate(DateTime timestamp) {
    if (timestamp == null) {
      return null;
    }
    String date =
        "${timestamp.day} ${DateFormat('MMMM').format(timestamp)} ${timestamp.year}";
    return date;
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }
}

showOnlyLoaderDialog(context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              CircularProgressIndicator(
                color: Get.theme.primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('please wait')
            ],
          ),
        ),
      );
    },
  );
}

showSnackBar(String title, String text, {Duration? duration}) {
  return Get.snackbar(title, text,
      dismissDirection: DismissDirection.horizontal,
      showProgressIndicator: true,
      isDismissible: true,
      duration: duration != null ? duration : Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM);
}

void hideLoader() {
  Get.back();
}

Future<bool> checkBody() async {
  bool result;
  try {
    await networkController.initConnectivity();
    if (networkController.connectionStatus.value != 0) {
      result = true;
    } else {
      print(networkController.connectionStatus.value);
      Get.snackbar(
        'Warning',
        'No internet connection',
        snackPosition: SnackPosition.BOTTOM,
        messageText: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'No internet available',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (networkController.connectionStatus.value != 0) {
                  Get.back();
                }
              },
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.white),
                height: 30,
                width: 55,
                child: Center(
                  child: Text(
                    'Retry',
                    style: TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
            )
          ],
        ),
        duration: Duration(days: 1),
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );

      result = false;
    }

    return result;
  } catch (e) {
    print("Exception - checkBodyController - checkBody():" + e.toString());
    return false;
  }
}

//check login
Future<bool> isLogin() async {
  sp = await SharedPreferences.getInstance();
  if (sp!.getString("token") == null &&
      sp!.getInt("currentUserId") == null &&
      currentUserId == null) {
    Get.to(() => LoginScreen());
    return false;
  } else {
    return true;
  }
}

logoutUser() async {
  await apiHelper.logout();
  sp = await SharedPreferences.getInstance();
  sp!.remove("currentUser");
  sp!.remove("currentUserId");
  sp!.remove("token");
  sp!.remove("tokenType");
  user = CurrentUserModel();
  sp!.clear();
  final LoginController loginController = Get.find<LoginController>();
  loginController.phoneController.clear();
  loginController.update();
  log("current user logout:- ${sp!.getString('currentUserId')}");
  currentUserId = null;
  splashController.currentUser = null;
  Get.off(() => LoginScreen());
}

//save current user
// CurrentUserModel? user;
saveCurrentUser(int id, String token, String tokenType) async {
  try {
    sp = await SharedPreferences.getInstance();
    await sp!.setInt('currentUserId', id);
    await sp!.setString('token', token);
    await sp!.setString('tokenType', tokenType);
    log("ID login ${sp!.getInt('currentUserId')}");
    log("Token login:- ${sp!.getString('token')}");
    print("sucess");
  } catch (e) {
    print("Exception - gloabl.dart - saveCurrentUser():" + e.toString());
  }
}

getCurrentUser() async {
  try {
    sp = await SharedPreferences.getInstance();
    currentUserId = sp!.getInt('currentUserId');
    log('user get:- $currentUserId');
  } catch (e) {
    print("Exception - gloabl.dart - getCurrentUser():" + e.toString());
  }
}

String appId = Platform.isAndroid ? "1" : "1";
AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosInfo;
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
var appVersion = "1.0.0";
String? deviceId;
String? fcmToken;
String? deviceLocation;
String? deviceManufacturer;
String? deviceModel;
SystemFlagNameList systemFlagNameList = SystemFlagNameList();
List<HororscopeSignModel> hororscopeSignList = [];
final translator = GoogleTranslator();

String getAppVersion() {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  return appVersion;
}

String getSystemFlagValue(String flag) {
  String value = splashController.currentUser!.systemFlagList!
      .firstWhere((e) => e.name == flag)
      .value;
  log('hello from getValue flag-$flag  $value');
  return splashController.currentUser!.systemFlagList!
      .firstWhere((e) => e.name == flag)
      .value;
}

String getSystemFlagValueForLogin(String flag) {
  String value =
      splashController.syatemFlag.firstWhere((e) => e.name == flag).value;
  // log('hello from getSystemFlagValueForLogin flag-$flag  $value');
  return splashController.syatemFlag.firstWhere((e) => e.name == flag).value;
}

showToast(
    {required String message,
    required Color textColor,
    required Color bgColor}) async {
  log('===================================>${message}');
  var translation = await translator.translate(message,
      to: splashController.currentLanguageCode);
  return Fluttertoast.showToast(
    msg: translation.text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 14.0,
  );
}

Future<String> translatedText(String text) async {
  var textTranslation = await translator.translate(text,
      to: splashController.currentLanguageCode);
  return textTranslation.text;
}

Future<Widget> showHtml(
    {required String html, Map<String, Style>? style}) async {
  try {
    var translation = await translator.translate(html,
        to: splashController.currentLanguageCode);
    return Html(
      data: translation.text,
      style: style ?? {},
    );
  } catch (e) {
    return Html(
      data: html,
      style: style ?? {},
    );
  }
}

Future<BottomNavigationBarItem> showBottom(
    {required String text, required Widget widget}) async {
  var translation = await translator.translate(text,
      to: splashController.currentLanguageCode);
  return BottomNavigationBarItem(
    icon: widget,
    label: global.translatedText(translation.text).toString(),
  );
}

Future<InputDecoration> showDecorationHint(
    {required String hint, InputBorder? inputBorder}) async {
  var translation = await translator.translate(hint,
      to: splashController.currentLanguageCode);
  return InputDecoration(hintText: translation.text, border: inputBorder);
}

Future getDeviceData() async {
  print('in getDeviceData');
  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  if (Platform.isAndroid) {
    if (androidInfo == null) {
      androidInfo = await deviceInfo.androidInfo;
    }
    deviceModel = androidInfo!.model;
    deviceManufacturer = androidInfo!.manufacturer;
    deviceId = androidInfo!.id;
    fcmToken = await FirebaseMessaging.instance.getToken();
    //appVersion = getAppVersion();

    ///await getCurrentLocation(),
    //"playerId": status.userId.toString()
  } else if (Platform.isIOS) {
    if (iosInfo == null) {
      iosInfo = await deviceInfo.iosInfo;
    }
    deviceModel = iosInfo!.model;
    deviceManufacturer = "Apple";
    deviceId = iosInfo!.identifierForVendor;
    fcmToken = await FirebaseMessaging.instance.getToken();
  }
}

saveUser(CurrentUserModel user) async {
  try {
    sp = await SharedPreferences.getInstance();
    await sp!.setString('currentUser', json.encode(user.toJson()));
  } catch (e) {
    print("Exception - global.dart - saveUser(): ${e.toString()}");
  }
}

Future<void> share() async {
  await FlutterShare.share(
    title: '1 item',
    text: '1 item',
    chooserTitle: '1 item',
  );
}

//Api Header
Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  Map<String, String> apiHeader = new Map<String, String>();

  if (authorizationRequired) {
    sp = await SharedPreferences.getInstance();
    String tokenType = sp!.getString("tokenType") ?? "Bearer";
    String token = sp!.getString("token") ?? "invalid token";
    print('authentication token :- $token');
    apiHeader.addAll({"Authorization": " $tokenType $token"});
  }
  apiHeader.addAll({"Content-Type": "application/json"});
  apiHeader.addAll({"Accept": "application/json"});
  log('header during sending request${apiHeader}');
  return apiHeader;
}
