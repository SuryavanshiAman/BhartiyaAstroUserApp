import 'package:BharatiyAstro/widget/containerListTIleWidgte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class ManglikDosh extends StatelessWidget {
  const ManglikDosh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Manglik Analysis', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          ContainerListTileWidget(
            title: '',
            subTitle: '',
            doshText: 'No',
            color: Colors.green,
          ),
          SizedBox(
            height: 10,
          ),
          Text('This is a computer generated result. Please consult an Astrologer to confirm & understand this in detail.', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, color: Colors.grey))
        ],
      ),
    );
  }
}
