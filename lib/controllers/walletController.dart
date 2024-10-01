import 'package:BharatiyAstro/model/amount_model.dart';
import 'package:get/get.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

import '../utils/services/api_helper.dart';

class WalletController extends GetxController {
  APIHelper apiHelper = APIHelper();
  List payment = ['50', '100', '200', '300', '500', '1000', '2000', '3000', '4000', '8000', '15000', '20000', '50000', '100000'];
  List rechrage = ['50', '100', '200', '300', '500', '1000', '2000', '3000'];

  var paymentAmount = <AmountModel>[];

  bool isChashbackMsg = true;
  bool isWallet = false;

  updateChashbackStatus() {
    isChashbackMsg = false;
    update();
  }

  updateWallet() {
    isWallet = !isWallet;
    update();
  }

  getAmount() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getpaymentAmount().then((result) {
            if (result.status == "200") {
              paymentAmount = result.recordList;
              payment.clear();
              rechrage.clear();
              for (int i = 0; i < paymentAmount.length; i++) {
                payment.add(paymentAmount[i].amount.toString());
                rechrage.add(paymentAmount[i].amount.toString());
              }
              update();
            } else {
              global.showToast(
                message: 'Failed to get amount',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAmount:-" + e.toString());
    }
  }
}
