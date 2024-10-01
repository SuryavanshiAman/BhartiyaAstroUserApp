// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/splashController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import '../controllers/life_cycle_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;
  SplashController splashController = Get.put(SplashController());
  HomeCheckController homeCheckController = Get.put(HomeCheckController());

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      InAppUpdate.performImmediateUpdate()
        .catchError((e) => showSnack(e.toString()));
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FittedBox(
        fit: BoxFit.cover,
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset('assets/images/splash.png'),
              ),
              const SizedBox(
                height: 15,
              ),
              // GetBuilder<SplashController>(builder: (s) {
              //   return splashController.appName == ''
              //       ? const CircularProgressIndicator()
              //       : Text(
              //           'BharatiyAstro',
              //           style: Get.textTheme.headline5,
              //         );
              // })
            ],
          ),
        ),
      ),
    );
  }
}
