import 'package:BharatiyAstro/controllers/astrologer_assistant_controller.dart';
import 'package:BharatiyAstro/views/searchAstrologerScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../utils/images.dart';
import '../../widget/customBottomButton.dart';
import '../astrologerProfile/chat_with_assistant_screen.dart';

class ChatWithAstrologerAssistant extends StatelessWidget {
  ChatWithAstrologerAssistant({Key? key}) : super(key: key);

  final AstrologerAssistantController astrologerAssistantController = Get.find<AstrologerAssistantController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: Get.height,
          decoration: BoxDecoration(color: Color.fromARGB(255, 240, 233, 233)),
          child: astrologerAssistantController.assistantList.isEmpty
              ? Center(
                  child: FittedBox(child: Text("You have not texted any astrologer's assistant yet")),
                )
              : GetBuilder<AstrologerAssistantController>(builder: (c) {
                  return ListView.builder(
                      itemCount: astrologerAssistantController.assistantList.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Get.to(() => ChatWithAstrologerAssistantScreen(
                                  flagId: 1,
                                  profileImage: '',
                                  astrologerName: astrologerAssistantController.assistantList[index].astrologerName!,
                                  fireBasechatId: astrologerAssistantController.assistantList[index].chatId,
                                  astrologerId: astrologerAssistantController.assistantList[index].astrologerId,
                                  chatId: 1,
                                ));
                          },
                          onLongPress: () async {
                            Get.dialog(AlertDialog(
                              title: Text(
                                "Are you sure you want delete chat with Astrologer Assistant?",
                                style: Get.textTheme.subtitle1,
                              ),
                              content: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('No'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        global.showOnlyLoaderDialog(context);
                                        astrologerAssistantController.assistantDelete(astrologerAssistantController.assistantList[index].id);
                                        global.hideLoader();
                                        Get.back();
                                      },
                                      child: Text('YES'),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Get.theme.primaryColor),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: astrologerAssistantController.assistantList[index].profileImage == ""
                                          ? CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.white,
                                              child: Image.asset(
                                                Images.deafultUser,
                                                fit: BoxFit.cover,
                                                height: 50,
                                                width: 40,
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: '${global.imgBaseurl}${astrologerAssistantController.assistantList[index].profileImage}',
                                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: Colors.white,
                                                  child: Image.network(
                                                    fit: BoxFit.cover,
                                                    height: 50,
                                                    width: 40,
                                                    '${global.imgBaseurl}${astrologerAssistantController.assistantList[index].profileImage}',
                                                  )),
                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Image.asset(
                                                Images.deafultUser,
                                                fit: BoxFit.cover,
                                                height: 50,
                                                width: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${astrologerAssistantController.assistantList[index].astrologerName}'s Assistant"),
                                      Text(
                                        astrologerAssistantController.assistantList[index].lastMessage ?? '',
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat('dd MMM yyyy , hh:mm a').format(astrologerAssistantController.assistantList[index].lastMessageTime ?? DateTime.now()),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                })),
      bottomSheet: CustomBottomButton(
        title: 'Chat With Astrologer Assistant',
        onTap: () {
          Get.to(() => SearchAstrologerScreen());
        },
      ),
    );
  }
}
