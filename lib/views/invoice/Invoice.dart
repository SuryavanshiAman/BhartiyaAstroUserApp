import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/history_controller.dart';
import '../../utils/images.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class Invoice extends StatefulWidget {
  final int index;
  const Invoice({Key? key, required this.index}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  HistoryController historyController = Get.find<HistoryController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text('Invoice'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Invoice',
                  style: Get.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [],
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 400,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Get.theme.primaryColor)),
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              '${global.imgBaseurl}${historyController.astroMallHistoryList[widget.index].productImage}',
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            Images.deafultUser,
                            fit: BoxFit.cover,
                            height: 50,
                            width: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Product Name",
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              historyController
                                  .astroMallHistoryList[widget.index]
                                  .productName!,
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //      Text(
                        //       'Order Address Name',
                        //     ),
                        //     Text(
                        //       '${historyController.astroMallHistoryList[widget.index].orderAddressName}',
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Date',
                            ),
                            Text(
                              '${global.formatter.format(historyController.astroMallHistoryList[widget.index].createdAt!)}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Address',
                            ),
                            Text(
                              '${historyController.astroMallHistoryList[widget.index].flatNo} ${historyController.astroMallHistoryList[widget.index].city} ${historyController.astroMallHistoryList[widget.index].state} ${historyController.astroMallHistoryList[widget.index].country} ${historyController.astroMallHistoryList[widget.index].pincode}',
                              overflow: TextOverflow.clip,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price: ',
                              style: Get.textTheme.bodyText2!
                                  .copyWith(fontSize: 13),
                            ),
                            Text(
                              "${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${historyController.astroMallHistoryList[widget.index].payableAmount ?? ""}",
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text(
                              'GST:',
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                            Text(
                              '${global.getSystemFlagValue(global.systemFlagNameList.gst)}%',
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' Total Price: ',
                              style: Get.textTheme.bodyText2!
                                  .copyWith(fontSize: 13),
                            ),
                            Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.astroMallHistoryList[widget.index].totalPayable}',
                              style: Get.textTheme.bodyText2!
                                  .copyWith(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Status: ',
                              style: Get.textTheme.bodyText2!
                                  .copyWith(fontSize: 13),
                            ),
                            Text(
                              historyController
                                  .astroMallHistoryList[widget.index]
                                  .orderStatus!
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: historyController
                                              .astroMallHistoryList[
                                                  widget.index]
                                              .orderStatus! ==
                                          "Cancelled"
                                      ? Colors.yellow
                                      : historyController
                                                  .astroMallHistoryList[
                                                      widget.index]
                                                  .orderStatus! ==
                                              "Pending"
                                          ? Colors.red
                                          : Colors.green),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'trancking Id: ',
                              style: Get.textTheme.bodyText2!
                                  .copyWith(fontSize: 13),
                            ),
                            Text(
                              historyController
                                  .astroMallHistoryList[widget.index].trakingno!
                                  .toUpperCase(),
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Courier name: ',
                              style: Get.textTheme.bodyText2!
                                  .copyWith(fontSize: 13),
                            ),
                            Text(
                              historyController
                                      .astroMallHistoryList[widget.index]
                                      .couriername ??
                                  "",
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
