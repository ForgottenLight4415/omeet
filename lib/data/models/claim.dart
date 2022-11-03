import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/utilities/show_snackbars.dart';
import 'package:omeet_motor/utilities/upload_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/call_bloc/call_cubit.dart';
import '../../blocs/home_bloc/assign_to_self_cubit/assign_self_cubit.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/app_permission_manager.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/phone_list_tile.dart';
import '../repositories/call_repo.dart';

class Claim {
  final int claimID;
  final String typeOfClaim;
  final String dateOfTheft;
  final String dateOfIntimation;
  final String invReferralDate;
  final String productType;
  final String locationCode;
  final String claimNumber;
  final String policyNumber;
  final String insuredName;
  final String insuredContactNumber;
  final String insuredAltContactNumber;
  final String email;
  final String policyStartDate;
  final String policyEndDate;
  final String vehicleRegistrationNumber;
  final String make;
  final String model;
  final String engineNumber;
  final String chassisNumber;
  final String reserveAmount;
  final String prevInsurerName;
  final String prevPolicyNumber;
  final String prevPolicyExpDate;
  final String noClaimBonus;
  final String imtEndorsement;
  final String insuredCity;
  final String insuredState;
  final String lossLocationCity;
  final String lossLocationState;
  final String pastClaimNumber;
  final String dateOfLoss;
  final String previousTypeOfClaim;
  final String autoManualTrigger;
  final String managerName;
  final String surveyorName;
  final String lotNo;
  final String dateOfAllocation;
  final String timeOfAllocation;
  final String currentStatus;
  final String scheduler;
  final String videoOps;
  final String videoOpsStatement;
  final String finalConclusion;
  final String videoMeetDate;
  final String videoMeetTime;
  final String tat;
  final String kycStatus;
  final String kycStatusProof;
  final String faceMatch;

  final String policeStation;
  final String firNo;
  final String firDate;
  final String firMonth;
  final String firQuarter;
  final String firDelay;
  final String firDelayBucket;
  final String accidentDateAsPerFir;
  final String vehicle1Accused;
  final String engine1Accused;
  final String chassis1Accused;
  final String vehicle1AccusedAccidentId;
  final String rid;
  final String red;

  Claim.fromJson(Map<String, dynamic> decodedJson)
      : claimID = decodedJson['id'] != null ? int.parse(decodedJson["id"]) : 0,
        //  CUSTOMER INFO
        insuredName = _cleanOrConvert(decodedJson["Insured_Name"]),
        insuredCity = _cleanOrConvert(decodedJson["Insured_City"]),
        insuredState = _cleanOrConvert(decodedJson["Insured_State"]),
        insuredContactNumber = _cleanOrConvert(
          decodedJson["Insured_Contact_Number"],
        ),
        insuredAltContactNumber = _cleanOrConvert(
          decodedJson["Insured_Alternate_Contact_Number"],
        ),
        email =
            _cleanOrConvert(decodedJson["Insured_Alternate_Contact_Number"]),

        // VEHICLE DETAILS
        productType = _cleanOrConvert(decodedJson["Product_Type"]),
        make = _cleanOrConvert(decodedJson["Make"]),
        model = _cleanOrConvert(decodedJson["Model"]),
        engineNumber = _cleanOrConvert(decodedJson["Engine_No"]),
        chassisNumber = _cleanOrConvert(decodedJson["Engine_No"]),
        vehicleRegistrationNumber =
            _cleanOrConvert(decodedJson["Vehicle_Reg_No"]),

        // POLICY DETAILS
        policyNumber = _cleanOrConvert(decodedJson["Policy_Number"]),
        policyStartDate =
            _cleanOrConvert(decodedJson["Policy_start_date_From"]),
        policyEndDate = _cleanOrConvert(decodedJson["Policy_start_date_To"]),
        prevPolicyNumber =
            _cleanOrConvert(decodedJson["Previous_Policy_Number"]),
        prevPolicyExpDate = _cleanOrConvert(
          decodedJson["Previous_Policy_Expiry_Date"],
        ),

        // CLAIM DETAILS
        claimNumber = _cleanOrConvert(decodedJson["Claim_No"]),
        currentStatus = _cleanOrConvert(decodedJson["Current_Status"]),
        typeOfClaim = _cleanOrConvert(decodedJson["Type_of_Claim"]),
        pastClaimNumber = _cleanOrConvert(decodedJson["Past_Claim_Number"]),
        previousTypeOfClaim = _cleanOrConvert(
          decodedJson["Previous_Type_of_Claim"],
        ),
        dateOfTheft = _cleanOrConvert(decodedJson["Date_of_Theft"]),
        dateOfLoss = _cleanOrConvert(decodedJson["Date_of_Loss"]),
        dateOfIntimation = _cleanOrConvert(decodedJson["Date_of_Intimation"]),
        invReferralDate = _cleanOrConvert(decodedJson["Inv_Referral_Date"]),
        lossLocationCity = _cleanOrConvert(decodedJson["Loss_Location_City"]),
        lossLocationState = _cleanOrConvert(decodedJson["Loss_Location_State"]),
        locationCode = _cleanOrConvert(decodedJson["Location_Code"]),

        // EXTRAS
        managerName = _cleanOrConvert(decodedJson["Manager_Name"]),
        surveyorName = _cleanOrConvert(decodedJson["Surveyor_Name"]),
        dateOfAllocation = _cleanOrConvert(decodedJson["Date_of_Allocation"]),
        timeOfAllocation = _cleanOrConvert(decodedJson["Time_of_Allocation"]),
        prevInsurerName = _cleanOrConvert(decodedJson["Previous_Insurer_Name"]),
        reserveAmount = _cleanOrConvert(decodedJson["Reserve_Amount"]),
        noClaimBonus = _cleanOrConvert(decodedJson["No_Claim_Bonus"]),
        imtEndorsement = _cleanOrConvert(decodedJson["IMT_Endorsement"]),
        autoManualTrigger = _cleanOrConvert(decodedJson["Auto_Manual_Trigger"]),
        lotNo = _cleanOrConvert(decodedJson["Lot_no"]),
        scheduler = _cleanOrConvert(decodedJson["Scheduler"]),
        videoOps = _cleanOrConvert(decodedJson["Video_Ops"]),
        videoOpsStatement = _cleanOrConvert(decodedJson["Video_Ops_Statement"]),
        finalConclusion = _cleanOrConvert(decodedJson["Final_Conclusion"]),
        videoMeetDate = _cleanOrConvert(decodedJson["Video_Meet_Date"]),
        videoMeetTime = _cleanOrConvert(decodedJson["Video_Meet_Time"]),
        tat = _cleanOrConvert(decodedJson["TAT"]),
        kycStatus = _cleanOrConvert(decodedJson["KYC_Status"]),
        kycStatusProof = _cleanOrConvert(decodedJson["KYC_Status_Proof"]),
        faceMatch = _cleanOrConvert(decodedJson["Face_Match"]),
        policeStation = _cleanOrConvert(decodedJson["Police_Station"]),
        firNo = _cleanOrConvert(decodedJson["FIR_No"]),
        firDate = _cleanOrConvert(decodedJson["FIR_Date"]),
        firMonth = _cleanOrConvert(decodedJson["FIR_Month"]),
        firQuarter = _cleanOrConvert(decodedJson["FIR_Quarter"]),
        firDelay = _cleanOrConvert(decodedJson["FIR_Delay"]),
        firDelayBucket = _cleanOrConvert(decodedJson["FIR_Delay_Bucket"]),
        accidentDateAsPerFir =
            _cleanOrConvert(decodedJson["Accident_date_as_per_FIR"]),
        vehicle1Accused = _cleanOrConvert(decodedJson["Vehicle_1_Accused"]),
        engine1Accused = _cleanOrConvert(decodedJson["Engine_1_Accused"]),
        chassis1Accused = _cleanOrConvert(decodedJson["Chassis_1_Accused"]),
        vehicle1AccusedAccidentId =
            _cleanOrConvert(decodedJson["Vehicle_1_Accused_Accident_ID"]),
        rid = _cleanOrConvert(decodedJson["RID"]),
        red = _cleanOrConvert(decodedJson["RED"]);

  Map<String, Map<String, dynamic>> toMap() {
    return <String, Map<String, dynamic>>{
      'Customer Information': <String, dynamic>{
        'Customer name': insuredName,
        'Customer address': _createAddress(insuredCity, insuredState),
        'Phone number': insuredContactNumber,
        'Alternate phone number': insuredAltContactNumber,
        'Email address': email,
      },
      'Policy Details': <String, dynamic>{
        'Policy number': policyNumber,
        'Policy start date': policyStartDate,
        'Policy end date': policyEndDate,
        'Previous policy number': prevPolicyNumber,
        'Previous policy expiration date': prevPolicyExpDate,
      },
      'Vehicle Details': <String, dynamic>{
        'Type': productType,
        'Make': make,
        'Model': model,
        'Engine number': engineNumber,
        'Chassis number': chassisNumber,
      },
      'Claim Details': <String, dynamic>{
        'Type': typeOfClaim,
        'Current status': currentStatus,
        'Date of theft': dateOfTheft,
        'Date of loss': dateOfLoss,
        'Date of intimation': dateOfIntimation,
        'Invoice referral date': invReferralDate,
        'Police station': policeStation,
        'FIR No.': firNo,
        'FIR Date': firDate,
        'Month': firMonth,
        'Quarter': firQuarter,
        'FIR Delay': firDelay,
        'FIR Delay Bucket': firDelayBucket,
        'Accident date (as per FIR)': accidentDateAsPerFir,
        'Vehicle 1 (Accused)': vehicle1Accused,
        'Engine 1 (Accused)': engine1Accused,
        'Chassis 1 (Accused)': chassis1Accused,
        'Vehicle 1 (Accused) Accident ID': vehicle1AccusedAccidentId,
        'RID': rid,
        'RED': red,
        'Loss location': _createAddress(lossLocationCity, lossLocationState),
        'Location code': locationCode
      }
    };
  }

  Map<String, dynamic> toInternetMap() {
    return <String, String>{
      'Type_of_Claim': typeOfClaim,
      'Date_of_Theft': dateOfTheft,
      'Date_of_Intimation': dateOfIntimation,
      'Inv_Referral_Date': invReferralDate,
      'Product_Type': productType,
      'Location_Code': locationCode,
      'Claim_No': claimNumber,
      'Policy_Number': policyNumber,
      'Insured_Name': insuredName,
      'Insured_Contact_Number': insuredContactNumber,
      'Insured_Alternate_Contact_Number': insuredAltContactNumber,
      'Email_Id': email,
      'Policy_start_date_From': policyStartDate,
      'Policy_start_date_To': policyEndDate,
      'Vehicle_Reg_No': vehicleRegistrationNumber,
      'Make': make,
      'Model': model,
      'Engine_No': engineNumber,
      'Chassis_No': chassisNumber,
      'Reserve_Amount': reserveAmount,
      'Previous_Insurer_Name': prevInsurerName,
      'Previous_Policy_Number': prevPolicyNumber,
      'Previous_Policy_Expiry_Date': prevPolicyExpDate,
      'No_Claim_Bonus': noClaimBonus,
      'IMT_Endorsement': imtEndorsement,
      'Insured_City': insuredCity,
      'Insured_State': insuredState,
      'Loss_Location_City': lossLocationCity,
      'Loss_Location_State': lossLocationState,
      'Past_Claim_Number': pastClaimNumber,
      'Date_of_Loss': dateOfLoss,
      'Previous_Type_of_Claim': previousTypeOfClaim,
      'Auto_Manual_Trigger': autoManualTrigger,
      'Manager_Name': managerName,
      'Surveyor_Name': surveyorName,
      'Lot_no': lotNo,
      'Police_Station': policeStation,
      'FIR_No': firNo,
      'FIR_Date': firDate,
      'FIR_Month': firMonth,
      'FIR_Quarter': firQuarter,
      'FIR_Delay': firDelay,
      'FIR_Delay_Bucket': firDelayBucket,
      'Accident_date_as_per_FIR': accidentDateAsPerFir,
      'Vehicle_1_Accused': vehicle1Accused,
      'Engine_1_Accused': engine1Accused,
      'Chassis_1_Accused': chassis1Accused,
      'Vehicle_1_Accused_Accident_ID': vehicle1AccusedAccidentId,
      'RID': rid,
      'RED': red,
    };
  }

  String get customerAddress {
    return _createAddress(insuredCity, insuredState);
  }

  String get lossAddress {
    return _createAddress(lossLocationCity, lossLocationState);
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

  String _createAddress(String city, String state) {
    if (city != AppStrings.unavailable && state != AppStrings.unavailable) {
      return "$city, $state";
    } else if (city != AppStrings.unavailable) {
      return city;
    } else if (state != AppStrings.unavailable) {
      return state;
    } else {
      return AppStrings.unavailable;
    }
  }

  static Map<String, List<String>> get fields {
    return <String, List<String>>{
      'Customer Information': [
        'Customer name',
        'Customer city',
        'Customer state',
        'Phone number',
        'Alternate phone number',
        'Email address',
      ],
      'Policy Details': [
        'Policy number',
        'Policy start date',
        'Policy end date',
        'Previous policy number',
        'Previous policy expiration date',
      ],
      'Vehicle Details': [
        'Vehicle Registration Number',
        'Type',
        'Make',
        'Model',
        'Engine number',
        'Chassis number',
      ],
      'Claim Details': [
        'Type of claim',
        'Claim number',
        'Date of theft',
        'Date of loss',
        'Date of intimation',
        'Invoice referral date',
        'Police station',
        'FIR No.',
        'FIR Date',
        'Month',
        'Quarter',
        'FIR Delay',
        'FIR Delay Bucket',
        'Accident date (as per FIR)',
        'Vehicle 1 (Accused)',
        'Engine 1 (Accused)',
        'Chassis 1 (Accused)',
        'Vehicle 1 (Accused) Accident ID',
        'RID',
        'RED',
        'Loss location city',
        'Loss location state',
        'Location code'
      ]
    };
  }

  static List<String> get createFields {
    return <String>[
      'Insured_Name',
      'Insured_City',
      'Insured_State',
      'Insured_Contact_Number',
      'Insured_Alternate_Contact_Number',
      'Email_Id',
      'Policy_Number',
      'Policy_start_date_From',
      'Policy_start_date_To',
      'Previous_Policy_Number',
      'Previous_Policy_Expiry_Date',
      'Vehicle_Reg_No',
      'Product_Type',
      'Make',
      'Model',
      'Engine_No',
      'Chassis_No',
      'Type_of_Claim',
      'Claim_No',
      'Date_of_Theft',
      'Date_of_Loss',
      'Date_of_Intimation',
      'Inv_Referral_Date',
      'Police_Station',
      'FIR_No',
      'FIR_Date',
      'FIR_Month',
      'FIR_Quarter',
      'FIR_Delay',
      'FIR_Delay_Bucket',
      'Accident_date_as_per_FIR',
      'Vehicle_1_Accused',
      'Engine_1_Accused',
      'Chassis_1_Accused',
      'Vehicle_1_Accused_Accident_ID',
      'RID',
      'RED',
      'Loss_Location_City',
      'Loss_Location_State',
      'Location_Code',
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
    bool cameraStatus = await cameraPermission();
    bool microphoneStatus = await microphonePermission();
    bool storageStatus = await storagePermission();
    if (cameraStatus && microphoneStatus && storageStatus) {
      Navigator.pushNamed(context, '/claim/meeting', arguments: this);
    } else {
      showInfoSnackBar(
        context,
        AppStrings.camMicStoragePerm,
        color: Colors.red,
      );
    }
  }

  Future<bool> call(BuildContext context) async {
    String? _selectedPhone;
    if (insuredAltContactNumber != AppStrings.unavailable) {
      _selectedPhone = await showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(maxHeight: 300.h),
        builder: (context) => Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                AppStrings.voiceCall,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Divider(
              height: 0.5,
              thickness: 0.5,
              indent: 50.w,
              endIndent: 50.w,
              color: Colors.black54,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop<String>(
                  context,
                  insuredContactNumber,
                );
              },
              child: PhoneListTile(
                phoneNumber: insuredContactNumber,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop<String>(
                  context,
                  insuredAltContactNumber,
                );
              },
              child: PhoneListTile(
                phoneNumber: insuredAltContactNumber,
                primary: false,
              ),
            )
          ],
        ),
      );
    } else {
      _selectedPhone = insuredContactNumber;
    }
    if (_selectedPhone != null) {
      BlocProvider.of<CallCubit>(context).callClient(
        claimNumber: claimNumber,
        phoneNumber: _selectedPhone,
      );
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendMessageModal(BuildContext context) async {
    final TextEditingController _controller =
    TextEditingController(text: insuredContactNumber);
    bool? _result = await showModalBottomSheet<bool?>(
      context: context,
      constraints: BoxConstraints(maxHeight: 200.h),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              textEditingController: _controller,
              label: "Phone number",
              hintText: "Enter phone number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  showInfoSnackBar(context, "Sending message",
                      color: Colors.orange);
                },
                child: const Text("SEND"),
              ),
            ),
          ],
        ),
      ),
    );
    if (_result == null) {
      return;
    } else if (_controller.text.isNotEmpty || _controller.text.length != 10) {
      if (await CallRepository().sendMessage(
        claimNumber: claimNumber,
        phoneNumber: _controller.text,
      )) {
        showInfoSnackBar(context, "Message sent", color: Colors.green);
      } else {
        showInfoSnackBar(context, "Failed", color: Colors.red);
      }
    } else {
      showInfoSnackBar(context, "Enter a valid phone number",
          color: Colors.red);
    }
  }

  Future<void> assignToSelf(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxHeight: 250.h),
      builder: (context) => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              "Are you sure?",
              style: Theme.of(context).textTheme.headline6,
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
                    showProgressDialog(context, label: "Assigning", content: "Assigning this claim to you...",);
                  } else if (state is AssignSelfSuccess) {
                    Navigator.pop(context);
                    showInfoSnackBar(context, "Assigned", color: Colors.green);
                  } else if (state is AssignSelfFailed) {
                    Navigator.pop(context);
                    showInfoSnackBar(context, "Failed to assign", color: Colors.red);
                  }
                }, builder: (context, snapshot) {
              return TextButton(
                onPressed: () async {
                  final SharedPreferences _prefs =
                  await SharedPreferences.getInstance();
                  await BlocProvider.of<AssignSelfCubit>(context).assignToSelf(
                    context,
                    claimNumber,
                    _prefs.getString("email") ?? "",
                  );
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 8.h),
                    child: Icon(Icons.check,
                        size: 30.w, color: Theme.of(context).primaryColor),
                  ),
                  title: const Text("Assign this claim to me"),
                ),
              );
            }),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop<String>(
                context,
                insuredAltContactNumber,
              );
            },
            child: ListTile(
              leading: Padding(
                padding: EdgeInsets.only(left: 12.w, top: 8.h),
                child: Icon(Icons.close,
                    size: 30.w, color: Theme.of(context).primaryColor),
              ),
              title: const Text("Cancel"),
            ),
          )
        ],
      ),
    );
  }
}
