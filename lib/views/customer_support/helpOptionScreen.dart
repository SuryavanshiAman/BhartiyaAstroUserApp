// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/views/customer_support/helpDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/customer_support_controller.dart';
import '../../widget/commonAppbar.dart';
import '../../widget/commonListTileWidget.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class HelpOptionScreen extends StatelessWidget {
  final String title;
  final int helpSupportQuestionId;
  HelpOptionScreen({Key? key, required this.title, required this.helpSupportQuestionId}) : super(key: key);
  final CustomerSupportController customerSupportController = Get.find<CustomerSupportController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Help and Support',
          )),
      body: customerSupportController.helpAndSupportQuestion.isEmpty
          ? Center(
              child: Text('No Question Available'),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: Get.textTheme.subtitle2!.copyWith(fontSize: 18),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: customerSupportController.helpAndSupportQuestion.length,
                      itemBuilder: (context, i) {
                        return CommonListTileWidget(
                          helpSupportSubQuestion: '',
                          helpSupportQuestion: title,
                          isSubCategory: customerSupportController.helpAndSupportQuestion[i].isSubCategory ?? false,
                          subject: customerSupportController.helpAndSupportQuestion[i].question,
                          title: customerSupportController.helpAndSupportQuestion[i].question,
                          isChatWithUs: customerSupportController.helpAndSupportQuestion[i].isChatWithUs ?? 0,
                          helpSupportQuestionId: helpSupportQuestionId,
                          onTap: () async {
                            if (customerSupportController.helpAndSupportQuestion[i].isSubCategory!) {
                              global.showOnlyLoaderDialog(context);
                              await customerSupportController.getHelpAndSupportQuestionAnswer(customerSupportController.helpAndSupportQuestion[i].id);
                              global.hideLoader();
                              Get.to(() => HelpDetailsScreen(
                                    index: i,
                                    title: customerSupportController.helpAndSupportQuestion[i].question,
                                    helpSupportQuestionId: helpSupportQuestionId,
                                    helpSupportQuestion: title,
                                  ));
                            }
                          },
                        );
                      }),
                ],
              ),
            ),
    );
  }
}
