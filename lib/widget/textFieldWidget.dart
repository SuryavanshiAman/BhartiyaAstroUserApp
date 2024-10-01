import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final int? maxlen;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
final dynamic validation;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  const TextFieldWidget({Key? key, this.onTap, required this.controller, this.labelText, this.hintText, this.keyboardType, this.maxlen, this.inputFormatter, this.focusNode, this.validation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            child: FutureBuilder(
                future: global.translatedText('$labelText'),
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    cursorColor: global.coursorColor,
                    inputFormatters: inputFormatter ?? [],
                    textCapitalization: TextCapitalization.words,
                    maxLength: maxlen ?? null,
                    keyboardType: keyboardType ?? TextInputType.text,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    validator: validation,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                     
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.grey,

                      hintText: snapshot.data,

                      //make hint text
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),
                      
                      //create lable
                      labelText: snapshot.data ?? '',
                      //lable style
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
