import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../views/customer_support/createTicketScreen.dart';

class CommonListTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String subject;
  final int helpSupportQuestionId;
  final String helpSupportQuestion;
  final String helpSupportSubQuestion;
  final int isChatWithUs;
  final bool isSubCategory;
  const CommonListTileWidget({Key? key, required this.helpSupportQuestion, required this.helpSupportSubQuestion, required this.title, required this.isSubCategory, required this.onTap, required this.isChatWithUs, required this.subject, required this.helpSupportQuestionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.subtitle2,
                ),
                Spacer(),
                isSubCategory
                    ? Icon(
                        Icons.arrow_forward_ios,
                        color: Get.theme.iconTheme.color,
                        size: 14,
                      )
                    : const SizedBox()
              ],
            ),
          ),
          isChatWithUs == 1
              ? Column(
                  children: [
                    Text('Still need help?', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => CreateTiketScreen(
                              helpSupportQuestion: helpSupportQuestion,
                              subject: subject,
                              helpSupportSubQuestion: "",
                              helpSupportQuestionId: helpSupportQuestionId,
                            ));
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Get.theme.primaryColor),
                        child: FittedBox(
                          child: Text(
                            'Chat with us',
                            style: Get.textTheme.subtitle1!.copyWith(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    Text('Wait time - 5 min', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10)),
                  ],
                )
              : const SizedBox(),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
