import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../controllers/bottomNavigationController.dart';

class ContactAstrologerCottomButton extends StatelessWidget {
  const ContactAstrologerCottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 6),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(1, 0);
                  Get.to(() => BottomNavigationBarScreen(index: 1));
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.solidCommentDots,
                          size: 13,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'Chat with Astrologers',
                            style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                              wordSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(3, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 3,
                      ));
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'Call with Astrologers',
                            style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                              wordSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
