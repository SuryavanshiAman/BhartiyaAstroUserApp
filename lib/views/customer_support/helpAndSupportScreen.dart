// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/customer_support_controller.dart';
import 'package:BharatiyAstro/views/customer_support/helpOptionScreen.dart';
import 'package:BharatiyAstro/widget/commonListTileWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../../widget/commonAppbar.dart';

class HeplAndSupportScreen extends StatelessWidget {
  HeplAndSupportScreen({Key? key}) : super(key: key);
  final CustomerSupportController customerSupportController = Get.find<CustomerSupportController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Help and Support',
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: customerSupportController.helpAndSupport.length,
            itemBuilder: (context, i) {
              return CommonListTileWidget(
                title: customerSupportController.helpAndSupport[i].name,
                helpSupportQuestion: customerSupportController.helpAndSupport[i].name,
                isChatWithUs: 0,
                subject: '',
                helpSupportSubQuestion: '',
                isSubCategory: customerSupportController.helpAndSupport[i].isSubCategory ?? false,
                helpSupportQuestionId: 0,
                onTap: () async {
                  if (customerSupportController.helpAndSupport[i].isSubCategory!) {
                    global.showOnlyLoaderDialog(context);
                    await customerSupportController.getHelpAndSupportQuestion(customerSupportController.helpAndSupport[i].id);
                    global.hideLoader();
                    Get.to(() => HelpOptionScreen(
                          helpSupportQuestionId: customerSupportController.helpAndSupport[i].id,
                          title: customerSupportController.helpAndSupport[i].name,
                        ));
                  }
                },
              );
            }),
      ),
    );
  }
}
