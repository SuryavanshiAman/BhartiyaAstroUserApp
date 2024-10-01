import 'package:BharatiyAstro/controllers/astromallController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../widget/commonAppbar.dart';
import '../../widget/customBottomButton.dart';
import '../../widget/textFieldWidget.dart';
import 'package:BharatiyAstro/utils/global.dart' as global;

class AddNewAddressScreen extends StatelessWidget {
  final int? id;
  AddNewAddressScreen({Key? key, this.id}) : super(key: key);
  final AstromallController astromallController = AstromallController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: id != null ? 'Edit Address' : 'Address',
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 70),
          child: GetBuilder<AstromallController>(builder: (astromallController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: global.translatedText('Name'),
                    builder: (context, snapshot) {
                      return TextFieldWidget(
                        controller: astromallController.nameController,
                        labelText: snapshot.data,
                        focusNode: astromallController.namefocus,
                        inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      child: FutureBuilder(
                          future: global.translatedText('Phone Number'),
                          builder: (context, snapshot) {
                            return IntlPhoneField(
                              autovalidateMode: null,
                              showDropdownIcon: false,
                              onCountryChanged: (value) {
                                astromallController.updateCountryCode(value.code, 1);
                              },
                              controller: astromallController.phoneController,
                              keyboardType: TextInputType.phone,
                              cursorColor: global.coursorColor,
                              focusNode: astromallController.phone1focus,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
                                  hintText: snapshot.data,
                                  errorText: null,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  counterText: ''),
                              initialCountryCode: astromallController.countryCode ?? 'IN',
                              onChanged: (phone) {
                                print('length ${phone.number.length}');
                              },
                            );
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      child: FutureBuilder(
                          future: global.translatedText('Alternate phone Number'),
                          builder: (context, snapshot) {
                            return IntlPhoneField(
                              autovalidateMode: null,
                              showDropdownIcon: false,
                              onCountryChanged: (value) {
                                astromallController.updateCountryCode(value.code, 2);
                              },
                              controller: astromallController.alternatePhoneController,
                              keyboardType: TextInputType.phone,
                              cursorColor: global.coursorColor,
                              focusNode: astromallController.phone2focus,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
                                  hintText: snapshot.data,
                                  errorText: null,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "verdana_regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  counterText: ''),
                              initialCountryCode: astromallController.countryCode2 ?? 'IN',
                              onChanged: (phone) {
                                print('length ${phone.number.length}');
                              },
                            );
                          })),
                ),
                TextFieldWidget(
                  controller: astromallController.flatNoController,
                  labelText: 'Flat number',
                  keyboardType: TextInputType.number,
                ),
                TextFieldWidget(
                  controller: astromallController.localityController,
                  labelText: 'Locality',
                ),
                TextFieldWidget(
                  controller: astromallController.landmarkController,
                  labelText: 'Landmark',
                ),
                TextFieldWidget(
                  controller: astromallController.cityController,
                  labelText: 'City',
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                ),
                TextFieldWidget(
                  controller: astromallController.stateController,
                  labelText: 'State/Province',
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                ),
                TextFieldWidget(
                  controller: astromallController.countryController,
                  labelText: 'Country',
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                ),
                TextFieldWidget(
                  controller: astromallController.pinCodeController,
                  labelText: 'Pincode',
                  keyboardType: TextInputType.number,
                  inputFormatter: [LengthLimitingTextInputFormatter(6)],
                  maxlen: 6,
                ),
              ],
            );
          }),
        ),
      ),
      bottomSheet: GetBuilder<AstromallController>(builder: (astromallController) {
        return CustomBottomButton(
          title: 'Continue',
          onTap: () async {
            bool isvalid = astromallController.isValidData();
            if (!isvalid) {
              global.showToast(
                message: astromallController.errorText,
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showOnlyLoaderDialog(context);
              if (id != null) {
                await astromallController.updateUserAddress(id!);
                await astromallController.getUserAddressData(global.sp!.getInt("currentUserId") ?? 0);
              } else {
                await astromallController.addAddress(global.sp!.getInt("currentUserId") ?? 0);
                await astromallController.getUserAddressData(global.sp!.getInt("currentUserId") ?? 0);
              }
              global.hideLoader();
              Get.back();
            }
          },
        );
      }),
    );
  }
}
