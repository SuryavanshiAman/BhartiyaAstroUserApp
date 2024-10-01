import 'dart:io';

import 'package:BharatiyAstro/controllers/bottomNavigationController.dart';
import 'package:BharatiyAstro/theme/nativeTheme.dart';
import 'package:BharatiyAstro/views/bottomNavigationBarScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import '../../controllers/themeController.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key, this.themeMode}) : super(key: key);
  final ValueChanged<ThemeMode>? themeMode;

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> with SingleTickerProviderStateMixin {
  List<Color> fullMaterialColors = [
    Color(0xffffc107),
    Color(0xff3342ae),
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];
  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        bottomNavigationController.setBottomIndex(0, 1);
        bottomNavigationController.update();
        Get.off(() => BottomNavigationBarScreen());
        return true;
      }),
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: GetBuilder<ThemeController>(builder: (c) {
              return AppBar(
                backgroundColor: themeController.pickColor,
                title: Text(
                  'Theme',
                  style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                leading: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    bottomNavigationController.setBottomIndex(0, 1);
                    bottomNavigationController.update();
                    Get.off(() => BottomNavigationBarScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Get.theme.iconTheme.color,
                    ),
                  ),
                ),
              );
            }),
          ),
          body: Scrollbar(
            child: GetBuilder<ThemeController>(builder: (themeController) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                          ),
                          itemCount: fullMaterialColors.length,
                          //shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                themeController.setPickColor(fullMaterialColors[index]);
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: [
                                  Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: fullMaterialColors[index],
                                      ),
                                    ),
                                  ),
                                  fullMaterialColors[index].value == themeController.pickColor.value
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }),
          )),
    );
  }
}
