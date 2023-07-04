import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/utilities/show_snackbars.dart';
import 'package:omeet_motor/utilities/upload_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/call_bloc/call_cubit.dart';
import '../../blocs/home_bloc/assign_to_self_cubit/assign_self_cubit.dart';
import '../../utilities/app_permission_manager.dart';
import '../../utilities/location_service.dart';
import '../../widgets/input_fields.dart';
import '../repositories/call_repo.dart';

class Claim {
  final String claimId;
  final String state;
  final String district;
  final String policeStation;
  final String accidentYear;
  final String firNumber;
  final String firDate;
  final String accidentDate;
  final String section;
  final String accused;
  final String victim1;
  final String victim2;
  final String lossType;
  final String accusedInsurer;
  final String firDelay;
  final String landlinePhone;
  final String cugNumber;
  final String policeStationEmail;
  final String currentStatus;
  final String policyNumber;
  final String policyStartDate;
  final String policyEndDate;
  final String insuredName;
  final String customerMobileNumber;
  final String email;
  final String caseUpdatedDate;

  Claim.fromJson(Map<String, dynamic> decodedJson)
      : claimId = _cleanOrConvert(decodedJson['CASE_ID']),
        state = _cleanOrConvert(decodedJson['STATE']),
        district = _cleanOrConvert(decodedJson['DISTRICT']),
        policeStation = _cleanOrConvert(decodedJson['POLICE_STATION']),
        accidentYear = _cleanOrConvert(decodedJson['ACCIDENT_YEAR']),
        firNumber = _cleanOrConvert(decodedJson['FIR_NO']),
        firDate = _cleanOrConvert(decodedJson['FIR_DATE']),
        accidentDate = _cleanOrConvert(decodedJson['ACCIDENT_DATE']),
        section = _cleanOrConvert(decodedJson['SECTION']),
        accused = _cleanOrConvert(decodedJson['ACCUSED_VEHICLE_NO']),
        victim1 = _cleanOrConvert(decodedJson['VICTIM_1_VEHICLE_NO']),
        victim2 = _cleanOrConvert(decodedJson['VICTIM_2_VEHICLE_NO']),
        lossType = _cleanOrConvert(decodedJson['LOSS_TYPE']),
        accusedInsurer = _cleanOrConvert(decodedJson['INSURANCE_COMPANY']),
        firDelay = _cleanOrConvert(decodedJson['FIR_DELAY']),
        landlinePhone = _cleanOrConvert(decodedJson['LANDLINE_PHONE']),
        cugNumber = _cleanOrConvert(decodedJson['CUG_NO']),
        policeStationEmail =
            _cleanOrConvert(decodedJson['POLICE_STATION_EMAIL_ID']),
        currentStatus = _cleanOrConvert(decodedJson['Current_Status']),
        policyNumber = _cleanOrConvert(decodedJson['POLICY_NO']),
        policyStartDate = _cleanOrConvert(decodedJson['POLICY_START_DATE']),
        policyEndDate = _cleanOrConvert(decodedJson['POLICY_END_DATE']),
        insuredName = _cleanOrConvert(decodedJson['INSURED_NAME']),
        customerMobileNumber = _cleanOrConvert(decodedJson['INSURED_MOBILE_NO']),
        email = _cleanOrConvert(decodedJson['INSURED_EMAIL_ID']),
        caseUpdatedDate = _cleanOrConvert(decodedJson['ALLOCATION_DATE']);

  Map<String, Map<String, dynamic>> toMap() {
    return <String, Map<String, dynamic>>{
      'Accident Details': <String, dynamic>{
        'Case ID': claimId,
        'Accident state': state,
        'Accident district': district,
        'Police station': policeStation,
        'Accident year': accidentYear,
        'Accident date': accidentDate,
        'FIR number': firNumber,
        'FIR date': firDate,
        'FIR Delay': firDelay,
        'Section': section,
        'Accused vehicle number': accused,
        'Victim 1 vehicle number': victim1,
        'Victim 2 vehicle number': victim2,
        'Loss type': lossType,
        'Police station contact no.': landlinePhone,
        'Police station CUG no.': cugNumber,
      },
      'Policy Details': <String, dynamic> {
        'Police station email address': policeStationEmail,
        'Accused insurance company': accusedInsurer,
        'Policy number': policyNumber,
        'Policy start date': policyStartDate,
        'Policy end date': policyEndDate,
        'Insured name': insuredName,
        'Insured mobile': customerMobileNumber,
        'Insured email address': email,
      }
    };
  }

  Map<String, dynamic> toInternetMap() {
    return <String, String>{
      "CASE_ID": claimId,
      "STATE": state,
      "DISTRICT": district,
      "POLICE_STATION": policeStation,
      "ACCIDENT_YEAR": accidentYear,
      "FIR_NO": firNumber,
      "FIR_DATE": firDate,
      "ACCIDENT_DATE": accidentDate,
      "SECTION": section,
      "ACCUSED_VEHICLE_NO": accused,
      "VICTIM_1_VEHICLE_NO": victim1,
      "VICTIM_2_VEHICLE_NO": victim2,
      "LOSS_TYPE": lossType,
      "INSURANCE_COMPANY": accusedInsurer,
      "FIR_DELAY": firDelay,
      "LANDLINE_PHONE": landlinePhone,
      "CUG_NO": cugNumber,
      "POLICE_STATION_EMAIL_ID": policeStationEmail,
      "Current_Status": currentStatus,
      "POLICY_NO": policyNumber,
      "POLICY_START_DATE": policyStartDate,
      "POLICY_END_DATE": policyEndDate,
      "INSURED_NAME": insuredName,
      "INSURED_MOBILE_NO": customerMobileNumber,
      "INSURED_EMAIL_ID": email,
      "ALLOCATION_DATE": caseUpdatedDate
    };
  }

  static String _cleanStrings(String? string) {
    if (string == null || string.isEmpty) {
      return "Unavailable";
    }
    return string;
  }

  static String _cleanOrConvert(Object? object) {
    if (object != null) {
      String string = object.toString();
      return _cleanStrings(string);
    }
    return "Unavailable";
  }

  static Map<String, List<String>> get fields {
    return <String, List<String>>{
      'Customer Information': [
        'Insured name',
        'Insured mobile',
        'Insured email address',
      ],
      'Policy Details': [
        'Policy number',
        'Policy start date',
        'Policy end date',
      ],
      'Case Details': [
        'Case ID',
        'Accident state',
        'Accident district',
        'Police station',
        'Accident year',
        'Accident date',
        'FIR number',
        'FIR date',
        'FIR Delay',
        'Section',
        'Accused vehicle number',
        'Victim 1 vehicle number',
        'Victim 2 vehicle number',
        'Loss type',
        'Accused insurance company',
        'Police station contact no.',
        'Police station CUG no.',
        'Police station email address',
        'Current status',
        'Allocation date',
      ],
    };
  }

  static List<String> get createFields {
    return <String>[
      "CASE_ID",
      "STATE",
      "DISTRICT",
      "POLICE_STATION",
      "ACCIDENT_YEAR",
      "FIR_NO",
      "FIR_DATE",
      "ACCIDENT_DATE",
      "SECTION",
      "ACCUSED_VEHICLE_NO",
      "VICTIM_1_VEHICLE_NO",
      "VICTIM_1_VEHICLE_NO",
      "LOSS_TYPE",
      "INSURANCE_COMPANY",
      "FIR_DELAY",
      "LANDLINE_PHONE",
      "CUG_NO",
      "POLICE_STATION_EMAIL_ID",
      "Current_Status",
      "POLICY_NO",
      "POLICY_START_DATE",
      "POLICY_END_DATE",
      "INSURED_NAME",
      "INSURED_MOBILE_NO",
      "INSURED_EMAIL_ID",
      "ALLOCATION_DATE"
    ];
  }

  static Map<String, String> getLabelDataMap() {
    final List<String> labelFields = [];
    fields.forEach((key, value) {
      for (String val in value) {
        labelFields.add(val);
      }
    });
    return Map.fromIterables(labelFields, createFields);
  }

  Future<void> videoCall(BuildContext context) async {
    final bool cameraStatus = await cameraPermission(context) ?? false;
    final bool microphoneStatus = await microphonePermission(context) ?? false;

    final LocationService locationService = LocationService();
    final bool locationStatus =
        await locationService.checkLocationStatus(context);

    if (cameraStatus && microphoneStatus && locationStatus) {
      Navigator.pushNamed(context, '/claim/meeting', arguments: this);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    } else {
      showInfoSnackBar(
        context,
        "Grant required permissions to access this feature",
        color: Colors.red,
      );
    }
  }

  Future<bool> call(BuildContext context) async {
    String? selectedPhone = customerMobileNumber;
    if (selectedPhone != "Unavailable") {
      BlocProvider.of<CallCubit>(context).callClient(
        claimId: claimId,
        phoneNumber: selectedPhone,
      );
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendMessageModal(BuildContext context) async {
    String? selectedPhone = customerMobileNumber;
    final TextEditingController _controller = TextEditingController(
      text: selectedPhone == "Unavailable" ? "" : selectedPhone,
    );
    final bool? sendButtonPressed = await showModalBottomSheet<bool?>(
          context: context,
          constraints: BoxConstraints(maxHeight: 200.h),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                CustomTextFormField(
                  textEditingController: _controller,
                  label: "Phone number",
                  hintText: "Enter phone number",
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                      showInfoSnackBar(
                        context,
                        "Sending message",
                        color: Colors.orange,
                      );
                    },
                    child: const Text("SEND"),
                  ),
                ),
              ],
            ),
          ),
        );
    if (sendButtonPressed != null && sendButtonPressed) {
      if (_controller.text.length == 10) {
        final CallRepository callRepository = CallRepository();
        final bool messageRequestStatus = await callRepository.sendMessage(
          claimId: claimId,
          phoneNumber: _controller.text,
        );
        if (messageRequestStatus) {
          showInfoSnackBar(context, "Message sent", color: Colors.green);
        } else {
          showInfoSnackBar(context, "Failed", color: Colors.red);
        }
      } else if (sendButtonPressed && _controller.text.length != 10) {
        showInfoSnackBar(context, "Enter a valid phone number",
            color: Colors.red);
      }
    }
  }

  Future<void> assignToSelf(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxHeight: 250.h),
      builder: (context) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Are you sure?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 50.w,
            endIndent: 50.w,
            color: Colors.black54,
          ),
          BlocProvider<AssignSelfCubit>(
            create: (context) => AssignSelfCubit(),
            child: BlocConsumer<AssignSelfCubit, AssignSelfState>(
              listener: (context, state) {
                if (state is AssignSelfLoading) {
                  showProgressDialog(
                    context,
                    label: "Assigning",
                    content: "Assigning this claim to you...",
                  );
                } else if (state is AssignSelfSuccess) {
                  Navigator.pop(context);
                  showInfoSnackBar(context, "Assigned", color: Colors.green);
                } else if (state is AssignSelfFailed) {
                  Navigator.pop(context);
                  showInfoSnackBar(context, "Failed to assign",
                      color: Colors.red);
                }
              },
              builder: (context, snapshot) {
                return TextButton(
                  onPressed: () async {
                    final SharedPreferences _prefs = await SharedPreferences.getInstance();
                    await BlocProvider.of<AssignSelfCubit>(context).assignToSelf(context, claimId, _prefs.getString("email") ?? "");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                      child: Icon(
                          Icons.check,
                          size: 30.w,
                          color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: const Text("Assign this claim to me"),
                  ),
              );
            }),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                child: Icon(
                  Icons.close,
                  size: 30.w,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text("Cancel"),
            ),
          )
        ],
      ),
    );
  }
}
