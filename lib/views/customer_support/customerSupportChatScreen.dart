import 'package:BharatiyAstro/views/customer_support/chatWithAstrologerAssistant.dart';
import 'package:BharatiyAstro/views/customer_support/chatWithCustomerSupport.dart';
import 'package:BharatiyAstro/widget/commonAppbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../../controllers/bottomNavigationController.dart';
import '../bottomNavigationBarScreen.dart';

class CustomerSupportChat extends StatelessWidget {
  const CustomerSupportChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: WillPopScope(
        onWillPop: () async {
          BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
          bottomNavigationController.setIndex(0, 0);
          Get.to(() => BottomNavigationBarScreen(
                index: 0,
              ));
          return true;
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: CommonAppBar(
                title: 'Support Chat',
                flagId: 1,
              )),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(indicatorColor: Get.theme.primaryColor, tabs: [
                Container(height: 35, alignment: Alignment.center, child: Text('Customer Support')),
                // Container(height: 35, alignment: Alignment.center, child: Text('Astrologer Assistant')),
              ]),
              Expanded(
                child: TabBarView(children: [
                  ChatWithCustomerSupport(),
                  // ChatWithAstrologerAssistant(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
