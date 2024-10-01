import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/contact_us_controller.dart';
import '../../model/body/contact_us_body.dart';
import '../../widget/textFieldLabelWidget.dart';
import '../../widget/textFieldWidget.dart';
import '../bottomNavigationBarScreen.dart';

class ContactUs extends StatefulWidget {
  final String? subject;
  const ContactUs({Key? key, this.subject}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController message = TextEditingController();
  final ContactUsController conatctUs = Get.put(ContactUsController());


  disposeValue(){
    name.text='';
    phoneNumber.text='';
    email.text = '';
    message.text = '';
  }
 
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subject}',
     
          style: Get.textTheme.labelMedium!
              .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Customer Name',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: name,
                  validation: (value){
                    if (value!="") {
                      return null;
                    }else{
                      return "enter valid name";
                    }
                  },
                  // focusNode: callIntakeController.namefocus,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                  ],
                  labelText: 'Customer Name',
                ),
                //  SizedBox(
                //          height: 10,
                //  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Phone number',
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: phoneNumber,
                  keyboardType: TextInputType.number,
                  // focusNode: callIntakeController.namefocus,
                  maxlen: 10,
                  validation:   (value){
                     if (value.isEmpty || !RegExp( r'^[0-9]{10}$').hasMatch(value)) {
                        return  "enter valid number";
                     }else {
                      return null;
                     }
                  },
                  inputFormatter: [
                 LengthLimitingTextInputFormatter(10),
                  
                  ],
                  labelText: 'Enter Your 10 digit phone number',
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFieldLabelWidget(
                      label: 'Email',
                        
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: email,
                  // focusNode: callIntakeController.namefocus,
                  inputFormatter: [
            //  FilteringTextInputFormatter.allow(RegExp( r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'))
          
                  ],
                  validation: (value){
                     if (value.isEmpty || !RegExp( r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$').hasMatch(value)) {
                        return  "enter valid email id";
                     }else {
                      return null;
                     }
                  },
                  labelText: 'Enter Your email id',
                ),
          
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 7,
                  maxLines: 7,
                  maxLength: 250,
                  controller: message,
                
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: Get.width * 0.60,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async{
                        print('${name.text}  ${phoneNumber.text}   ${email.text}  ${message.value}');
                        if (_formKey.currentState!.validate()) {
                             await  conatctUs.sendContactUs(ContactUsBody(
                            name: name.value.text,
                            phone: phoneNumber.value.text,
                            email: email.value.text,  
                             subject: widget.subject,
                            message: message.value.text,
                          
                            
                            ));
                          disposeValue();
                           Get.off(() => BottomNavigationBarScreen(index: 0)); 
                        } 
                      },
                      child: Text('Send')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
