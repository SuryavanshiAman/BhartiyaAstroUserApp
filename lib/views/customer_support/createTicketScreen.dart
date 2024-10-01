// ignore_for_file: must_be_immutable

import 'package:BharatiyAstro/controllers/customer_support_controller.dart';
import 'package:BharatiyAstro/views/customer_support/customerSupportChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../widget/commonAppbar.dart';

class CreateTiketScreen extends StatelessWidget {
  final String subject;
  final String helpSupportQuestion;
  final int helpSupportQuestionId;
  final String helpSupportSubQuestion;
  CreateTiketScreen({Key? key, required this.helpSupportQuestion, required this.helpSupportSubQuestion, required this.subject, required this.helpSupportQuestionId}) : super(key: key);

  CustomerSupportController customerSupportController = Get.find<CustomerSupportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Create Ticket',
          )),
      body: GetBuilder<CustomerSupportController>(builder: (c) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subject',
                  style: Get.textTheme.subtitle1!.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(helpSupportSubQuestion, style: Get.textTheme.subtitle1!.copyWith(fontSize: 15, color: Colors.grey)),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Description',
                  style: Get.textTheme.subtitle1!.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text('Please mention your complete concern here', style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w300)),
                FutureBuilder(
                    future: global.translatedText('Type your concern here...'),
                    builder: (context, snapshot) {
                      return TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 7,
                        maxLines: 7,
                        maxLength: 250,
                        controller: customerSupportController.descriptionController,
                        onChanged: (val) {
                          customerSupportController.textLength = val.length;
                          customerSupportController.update();
                          print('text length : ${customerSupportController.textLength}');
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: snapshot.data,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                      );
                    }),
                // SizedBox(
                //   height: 15,
                //   child: Align(
                //     alignment: Alignment.bottomRight,
                //     child: Text('${customerSupportController.textLength}/50', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.grey)),
                //   ),
                // )
              ],
            ),
          ),
        );
      }),
      bottomSheet: GetBuilder<CustomerSupportController>(builder: (c) {
        return GestureDetector(
          onTap: () async {
            if (customerSupportController.textLength < 10) {
              global.showToast(
                message: 'Please enter more than 20 words',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              customerSupportController.textLength = 0;
              global.showOnlyLoaderDialog(context);
              await customerSupportController.createCustomerTickets(subject, helpSupportQuestionId, helpSupportQuestion, helpSupportSubQuestion);
              global.hideLoader();
              Get.to(() => CustomerSupportChat());
            }
          },
          child: Container(
            color: customerSupportController.textLength < 10 ? Color.fromARGB(255, 196, 191, 191) : Get.theme.primaryColor,
            height: 50,
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              'Chat with us',
              style: Get.theme.textTheme.subtitle1!.copyWith(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0, color: Colors.white),
            ),
          ),
        );
      }),
    );
  }
}
