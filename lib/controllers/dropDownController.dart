import 'package:get/get.dart';

class DropDownController extends GetxController {
  String? chosenValue;
  String? maritalStatus;
  String? language;
  String? topic;
  String innitialValue(int callId, List<String> item) {
    if (callId == 1) {
      return maritalStatus ?? item[0];
    } else if (callId == 2) {
      return language ?? item[0];
    } else if (callId == 3) {
      return topic ?? item[0];
    } else {
      return 'no data';
    }
  }

  void maritalStatusChoose(String value) {
    maritalStatus = value;
    update();
  }

  void languagetChoose(String value) {
    language = value;
    update();
  }

  void topicChoose(String value) {
    topic = value;
    update();
  }
}
