import 'package:BharatiyAstro/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

// ignore: must_be_immutable
class ViewReportScreen extends StatelessWidget {
  int? index;
  ViewReportScreen({Key? key, this.index}) : super(key: key);
  HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.appBarTheme.systemOverlayStyle!.statusBarColor,
        title: Text('View Report'),
      ),
      body: SfPdfViewer.network('${global.imgBaseurl}${historyController.reportHistoryList[index!].reportFile}', enableDocumentLinkAnnotation: false),
    );
  }
}
