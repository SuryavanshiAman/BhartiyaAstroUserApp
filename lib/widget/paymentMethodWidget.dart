import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String method;
  final String logo;
  final String value;
  final String? subtitle;
  final bool isWallet;
  final VoidCallback? onTap;
  final isup;

  const PaymentMethodWidget({Key? key, required this.method, required this.logo, required this.value,this.isup,  this.subtitle,this.isWallet = false,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(height: 30, width: 50, decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5), image: DecorationImage(image: AssetImage(logo)))),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                if (subtitle != null)
                  Text(subtitle ?? 'subtitle',
                      style: Get.textTheme.subtitle1!.copyWith(
                        color: Colors.grey,
                        fontSize: 10,
                      )),
              ],
            )
          ],
        ),
        if(!isWallet)
        Radio(value: value, groupValue: 'payment', onChanged: (value) {}),
        if(isWallet)
        IconButton( onPressed: onTap,icon: Icon(isup ? Icons.keyboard_arrow_up_outlined: Icons.keyboard_arrow_down_outlined))
      ],
    );
  }
}
