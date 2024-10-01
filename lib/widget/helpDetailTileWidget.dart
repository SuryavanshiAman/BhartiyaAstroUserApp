import 'package:BharatiyAstro/utils/images.dart';
import 'package:BharatiyAstro/views/customer_support/createTicketScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class HelpDetailTileWidget extends StatelessWidget {
  final String text;
  final String helpSupportQuestion;
  final String helpSupportSubQuestion;
  final String subject;
  final int helpSupportQuestionId;
  final Function? ontap;
  final isChatWithUs;
  final isImage;
  const HelpDetailTileWidget({
    Key? key,
    required this.text,
    this.ontap,
    required this.subject,
    required this.isChatWithUs,
    required this.helpSupportQuestionId,
    required this.isImage,
    required this.helpSupportQuestion,
    required this.helpSupportSubQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$subject',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
            future: global.showHtml(
              html: text,
            ),
            builder: (context, snapshot) {
              return snapshot.data ?? const SizedBox();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          isImage
              ? GestureDetector(
                  onTap: () {
                    print('show an image');
                    Get.dialog(AlertDialog(
                      contentPadding: const EdgeInsets.all(0),
                      titlePadding: const EdgeInsets.all(0),
                      title: SizedBox(
                        height: Get.height * 0.8,
                        width: Get.width * 0.7,
                        child: Image.asset(
                          Images.yearlyImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ));
                  },
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('See image here', style: TextStyle(decoration: TextDecoration.underline, fontSize: 13, color: Colors.blue)),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.photo,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          isChatWithUs == 1
              ? Center(
                  child: Column(
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Still need help?', style: Get.textTheme.subtitle1!.copyWith(fontSize: 13)),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Wait time - 5 min', style: Get.textTheme.subtitle1!.copyWith(fontSize: 13)),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => CreateTiketScreen(
                                helpSupportQuestion: helpSupportQuestion,
                                subject: subject,
                                helpSupportQuestionId: helpSupportQuestionId,
                                helpSupportSubQuestion: helpSupportSubQuestion,
                              ));
                        },
                        child: Container(
                          height: 50,
                          width: 250,
                          padding: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Get.theme.primaryColor),
                          child: FittedBox(
                            child: Text(
                              'Chat with us',
                              style: Get.textTheme.subtitle1!.copyWith(fontSize: 13,

                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      
                    ],
                  ),
                )
              : const SizedBox(),
          Divider()
        ],
      ),
    );
  }
}
