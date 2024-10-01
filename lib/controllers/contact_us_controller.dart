import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as https;

import '../model/body/contact_us_body.dart';
import '../model/success_on_enquery.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;
import 'package:BharatiyAstro/constants/appConstant.dart';

class ContactUsController extends GetxController{
RxBool isDataPost = false.obs;
SuccessModel successModel = SuccessModel();
sendContactUs(ContactUsBody contactUs)async{
  print(contactUs.toJson());
  try {
    var response = await https.post(Uri.parse('https://bharatiyastro.com/api/saveenquiry'),
    headers: {
      'Content-Type':'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(contactUs.toJson())
    );
    print('${response.body}');
    if (response.statusCode==200) {
        isDataPost.value = true;
        successModel = SuccessModel.fromJson(jsonDecode(response.body));
       Get.snackbar('Success','Message Send SuceessFully');
    } 

  } catch (e) {
    Get.snackbar('Error','Get error On sending Message');
  }
}


}