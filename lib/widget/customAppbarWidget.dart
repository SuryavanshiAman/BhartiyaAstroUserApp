import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onBackPressed;
  final List<Widget> actions;
  final Color bgColor;
  final TextStyle titleStyle;
  final int flagId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  CustomAppBar({required this.title, required this.bgColor, this.flagId = 0, required this.onBackPressed, required this.actions, required this.titleStyle, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      // leading: InkWell(
      //   onTap: () {
      //     // print('${scaffoldKey.currentState!.isDrawerOpen}');
      //     if (scaffoldKey.currentState!.isDrawerOpen) {
      //       scaffoldKey.currentState!.closeDrawer();
      //       Get.back();
      //     } else {
      //       scaffoldKey.currentState!.openDrawer();
      //     }
      //   },
      //   child: Icon(
      //     flagId == 1
      //         ? Icons.chat
      //         : flagId == 2
      //             ? Icons.phone
      //             : Icons.menu,
      //     color: Get.theme.iconTheme.color,
      //   ),
      // ),
      title: Text(
        title,
        style: titleStyle,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
