import 'package:BharatiyAstro/views/kudali/doshaReport.dart';
import 'package:BharatiyAstro/views/kudali/generalReportScreen.dart';
import 'package:BharatiyAstro/views/kudali/remediesKundli.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class KundliReportScreen extends StatelessWidget {
  KundliReportScreen({Key? key}) : super(key: key);
// final KundliController kundliController = Get.find<KundliController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(indicatorColor: Get.theme.primaryColor, tabs: [
            Container(height: 35, alignment: Alignment.center, child: Text('General', style: TextStyle(fontSize: 13))),
            Container(height: 35, alignment: Alignment.center, child: Text('Remedies', style: TextStyle(fontSize: 13))),
            Container(height: 35, alignment: Alignment.center, child: Text('Dosha', style: TextStyle(fontSize: 13))),
          ]),
          SizedBox(
            height: Get.height - 184,
            child: TabBarView(
              children: [GeneralReport(), RemediesKundli(), DoshaReport()],
            ),
          )
        ],
      ),
    );
  }
}
