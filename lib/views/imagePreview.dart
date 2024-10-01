import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../widget/commonAppbar.dart';

class ImagePreview extends StatelessWidget {
  final String image;
  const ImagePreview({Key? key,required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Image',
          )),
          body: SizedBox(
            child:PhotoView(
              imageProvider: NetworkImage(image),
            ) ),
    );
  }
}