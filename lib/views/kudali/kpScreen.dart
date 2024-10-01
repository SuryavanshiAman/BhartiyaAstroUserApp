import 'package:BharatiyAstro/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class KPScreen extends StatelessWidget {
  const KPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<KundliController>(builder: (kundliController) {
        return ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Planets',
              style: Get.textTheme.subtitle1,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 242, 205),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DataTable(
                columnSpacing: 20,
                dataTextStyle: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                horizontalMargin: 10,
                headingRowHeight: 48,
                columns: [
                  DataColumn(
                    label: Text('Planet', textAlign: TextAlign.center),
                  ),
                  DataColumn(label: Text('Cusp', textAlign: TextAlign.center)),
                  DataColumn(
                    label: Text('Sign', textAlign: TextAlign.center),
                  ),
                  DataColumn(label: Text('Sign\nLord', textAlign: TextAlign.center)),
                  DataColumn(label: Text('Star\nLord', textAlign: TextAlign.center)),
                  DataColumn(label: Text('Sub\nLord', textAlign: TextAlign.center)),
                ],
                border: TableBorder(
                  verticalInside: BorderSide(color: Colors.grey),
                  horizontalInside: BorderSide(color: Colors.grey),
                ),
                rows: kundliController.listOfPlanets // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => DataRow(
                            color: MaterialStateProperty.all(Colors.white),
                            cells: <DataCell>[
                              DataCell(Center(
                                  child: Text(
                                element["planet"]!,
                              ))),
                              DataCell(Center(child: Text(element["cups"]!))),
                              DataCell(Center(child: Text(element["sign"]!))),
                              DataCell(Center(child: Text(element["signLord"]!))),
                              DataCell(Center(child: Text(element["starLord"]!))),
                              DataCell(Center(child: Text(element["subLord"]!))),
                            ],
                          )),
                    )
                    .toList(),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            //
          ],
        );
      }),
    );
  }
}
