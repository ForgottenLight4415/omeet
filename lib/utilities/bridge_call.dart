import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/call_bloc/call_cubit.dart';
import '../widgets/input_fields.dart';

Future<bool> customCallSetup(BuildContext context,
    {String? claimNumber, String? insuredContactNumber}) async {
  final SharedPreferences _pref = await SharedPreferences.getInstance();
  final TextEditingController _claimNumberController =
      TextEditingController(text: claimNumber ?? "GODJN5432");
  final TextEditingController _managerPhoneController =
      TextEditingController(text: _pref.getString("phone") ?? "");
  final TextEditingController _customerPhoneController =
      TextEditingController(text: insuredContactNumber ?? "");

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool? result = await showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 15.w,
        top: 15.h,
        right: 15.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15.h,
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
                    Navigator.pop(context, true);
                  }
                },
                child: const Text("Set call"),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  if (result != null && result) {
    BlocProvider.of<CallCubit>(context).callClient(
      claimNumber: _claimNumberController.text,
      phoneNumber: _customerPhoneController.text,
      managerNumber: _managerPhoneController.text,
    );
    return true;
  } else {
    return false;
  }
}
