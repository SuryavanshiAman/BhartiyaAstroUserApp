import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/loginController.dart';
import '../../widget/commonAppbar.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({ Key? key }) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

    final LoginController loginController = Get.find<LoginController>();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  loginController.GetPrivacy();
  }

   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginController.isDataloaded.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Privacy and policy',
          )),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20),
        child:
              Obx(() => loginController.isDataloaded.value?Html(data: loginController.termsNadPrivacy.recordList!.body):Center(child: CircularProgressIndicator()))  ,
        ),
      ),
    );
  }
}
