import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/input_fields.dart';

Future<List<String>?> customCallSetup(BuildContext context,
    {String? claimId, String? customerMobileNumber}) async {
  final SharedPreferences _pref = await SharedPreferences.getInstance();
  final TextEditingController _claimNumberController =
      TextEditingController(text: claimId ?? "GODJN5432");
  final TextEditingController _managerPhoneController =
      TextEditingController(text: _pref.getString("phone") ?? "");
  final TextEditingController _customerPhoneController =
      TextEditingController(text: customerMobileNumber ?? "");

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  return await showModalBottomSheet<List<String>?>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 15.w,
          top: 40.h,
          right: 15.w,
        ),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomTextFormField(
                textEditingController: _claimNumberController,
                label: "Claim number",
                hintText: "Enter claim number",
                textInputAction: TextInputAction.next,
                enabled: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              CustomTextFormField(
                textEditingController: _managerPhoneController,
                label: "Manager phone number",
                hintText: "Enter phone number",
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  } else if (value.length != 10 ||
                      !value.contains(RegExp(r'^[0-9]+$'))) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              CustomTextFormField(
                textEditingController: _customerPhoneController,
                label: "Customer phone number",
                hintText: "Enter phone number",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  } else if (value.length != 10 ||
                      !value.contains(RegExp(r'^[0-9]+$'))) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      List<String> modalResult = [
                        _claimNumberController.text,
                        _managerPhoneController.text,
                        _customerPhoneController.text,
                      ];
                      Navigator.pop<List<String>?>(context, modalResult);
                    }
                  },
                  child: const Text("Set call"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
