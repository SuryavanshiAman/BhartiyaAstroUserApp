import 'dart:async';

import 'package:BharatiyAstro/views/CheckPayment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/phonepayController.dart';
import 'dart:developer';

class PhonePayPaymentScreen extends StatefulWidget {
  const PhonePayPaymentScreen({Key? key}) : super(key: key);

  @override
  _PhonePayPaymentScreenState createState() => _PhonePayPaymentScreenState();
}

class _PhonePayPaymentScreenState extends State<PhonePayPaymentScreen> {
  PhonePayController phonepayController =
      Get.put<PhonePayController>(PhonePayController());
  final _controller = Completer<WebViewController>();
 

  @override
  void initState() {
    // makePaymet();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phonepayController.isPageLoaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.off(() => CheckPayment());
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                WebView(
                  backgroundColor: Colors.white,
                  onProgress: (progress) {
                    print('Progress is here ${progress}');
                    //
                    phonepayController.progress.value = progress;
                  },
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (url) {
                    log('here is log $url');
                    if (url == "https://bharatiyastro.com/payloader") {
                      Future.delayed(Duration(seconds: 2), () {
                        // Get.off(() => CheckPayment());
                      });
                    }
                    phonepayController.isPageLoaded.value = true;
                  },
                  onPageFinished: (url) {
                    phonepayController.isPageLoaded.value = false;
                  },
                  initialUrl: phonepayController.phonePayModel.data
                          ?.instrumentResponse!.redirectInfo!.url ??
                      "",
                  javascriptMode: JavascriptMode.unrestricted,
                ),
                Obx(() => phonepayController.isPageLoaded.value
                    ? Positioned(
                        top: Get.height * 0.50,
                        // bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'We are Processing Your Payment',
                              style: Get.textTheme.bodyLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ))
                    : SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
