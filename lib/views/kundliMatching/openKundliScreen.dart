import 'dart:math';

import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:BharatiyAstro/controllers/kundliMatchingController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class OpenKundliScreen extends StatelessWidget {
  OpenKundliScreen({Key? key}) : super(key: key);
  final KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<KundliController>(builder: (kundliController) {
              return SizedBox(
                height: 40,
                child: FutureBuilder(
                    future: global.translatedText('Search Kundli by name'),
                    builder: (context, snapshot) {
                      return TextFormField(
                        onChanged: (value) {
                          kundliController.searchKundli(value);
                        },
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                          helperStyle: TextStyle(color: Get.theme.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          hintText: snapshot.data,
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Recently Opened",
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ),
            ),
            Expanded(
              child: GetBuilder<KundliController>(builder: (kundliController) {
                return kundliController.searchKundliList.isEmpty
                    ? Center(
                        child: Text(kundliController.emptyScreenText),
                      )
                    : ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        itemCount: kundliController.searchKundliList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              kundliMatchingController.openKundliData(kundliController.searchKundliList, index);
                              kundliMatchingController.onHomeTabBarIndexChanged(1);
                            },
                            child: ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(color: Colors.primaries[Random().nextInt(Colors.primaries.length)], borderRadius: BorderRadius.circular(7)),
                                child: Center(
                                  child: Text(
                                    kundliController.searchKundliList[index].name[0].toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kundliController.searchKundliList[index].name,
                                    style: Get.textTheme.subtitle1,
                                  ),
                                  Text(
                                    "${DateFormat("dd MMM yyyy").format(kundliController.searchKundliList[index].birthDate)},${kundliController.searchKundliList[index].birthTime}",
                                    style: Theme.of(context).primaryTextTheme.subtitle2!.copyWith(fontSize: 10, color: Colors.grey),
                                  ),
                                  Text(
                                    kundliController.searchKundliList[index].birthPlace,
                                    style: Theme.of(context).primaryTextTheme.subtitle2!.copyWith(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text(
                                        "Are you sure you want to permanently delete this kundli?",
                                        style: Get.textTheme.bodyText2,
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
                                                await kundliController.deleteKundli(kundliController.searchKundliList[index].id!);
                                                if (kundliMatchingController.boykundliId == kundliController.searchKundliList[index].id!) {
                                                  kundliMatchingController.boykundliId = null;
                                                  kundliMatchingController.cBoysName.text = "";
                                                  kundliMatchingController.onBoyDateSelected(DateTime.now());
                                                  kundliMatchingController.cBoysBirthTime.text = DateFormat.jm().format(DateTime.now());
                                                  kundliMatchingController.cBoysBirthPlace.text = "New Delhi,Delhi,India";
                                                  kundliMatchingController.update();
                                                } else if (kundliMatchingController.girlKundliId == kundliController.searchKundliList[index].id!) {
                                                  kundliMatchingController.girlKundliId = null;
                                                  kundliMatchingController.cGirlName.text = "";
                                                  kundliMatchingController.onGirlDateSelected(DateTime.now());
                                                  kundliMatchingController.cGirlBirthTime.text = DateFormat.jm().format(DateTime.now());
                                                  kundliMatchingController.cGirlBirthPlace.text = "New Delhi,Delhi,India";
                                                  kundliMatchingController.update();
                                                }
                                                await kundliController.getKundliList();
                                                Get.back();
                                                global.hideLoader();
                                              },
                                              child: Text('YES'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
