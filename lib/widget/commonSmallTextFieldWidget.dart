import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class CommonSmallTextFieldWidget extends StatelessWidget {
  final String? titleText;
  final String hintText;
  final IconData preFixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final int? maxLines;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatter;

  const CommonSmallTextFieldWidget({
    Key? key,
    this.titleText,
    required this.hintText,
    required this.preFixIcon,
    required this.controller,
    this.keyboardType,
    this.readOnly,
    this.maxLines,
    this.onTap,
    this.onFieldSubmitted,
    this.inputFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText == ""
            ? SizedBox(
                height: 10,
              )
            : Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  titleText ?? "",
                  style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 40,
            child: FutureBuilder(
                future: global.translatedText(hintText),
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: controller,
                    maxLines: maxLines,
                    inputFormatters: inputFormatter ?? [],
                    onFieldSubmitted: onFieldSubmitted,
                    onTap: onTap,
                    readOnly: readOnly ?? false,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    keyboardType: keyboardType ?? TextInputType.text,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
                      helperStyle: TextStyle(color: Get.theme.primaryColor),
                      contentPadding: EdgeInsets.all(10.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: snapshot.data ?? '',
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          preFixIcon /*?? Icons.no_accounts*/,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
