import '../../utilities/app_constants.dart';

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
        faceMatch = _cleanOrConvert(decodedJson["Face_Match"]);

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

  static List<String> get fields {
    return <String>[
      'Type of claim',
      'Date of theft',
      'Date of Intimation',
      'Inv Referral Date',
      'Product Type',
      'Location Code',
      'Claim No',
      'Policy Number',
      'Insured Name',
      'Insured Contact Number',
      'Insured Alternate Contact Number',
      'Email Id',
      'Policy start date From',
      'Policy start date To',
      'Vehicle Reg No',
      'Make',
      'Model',
      'Engine No',
      'Chassis No',
      'Reserve Amount',
      'Previous Insurer Name',
      'Previous Policy Number',
      'Previous Policy Expiry Date',
      'No Claim Bonus',
      'IMT Endorsement',
      'Insured City',
      'Insured State',
      'Loss Location City',
      'Loss Location State',
      'Past Claim Number',
      'Date of Loss',
      'Previous Type of Claim',
      'Auto Manual Trigger',
      'Manager Name',
      'Surveyor Name',
      'Lot no',
    ];
  }

  static List<String> get createFields {
    return <String>[
      'Type_of_Claim',
      'Date_of_Theft',
      'Date_of_Intimation',
      'Inv_Referral_Date',
      'Product_Type',
      'Location_Code',
      'Claim_No',
      'Policy_Number',
      'Insured_Name',
      'Insured_Contact_Number',
      'Insured_Alternate_Contact_Number',
      'Email_Id',
      'Policy_start_date_From',
      'Policy_start_date_To',
      'Vehicle_Reg_No',
      'Make',
      'Model',
      'Engine_No',
      'Chassis_No',
      'Reserve_Amount',
      'Previous_Insurer_Name',
      'Previous_Policy_Number',
      'Previous_Policy_Expiry_Date',
      'No_Claim_Bonus',
      'IMT_Endorsement',
      'Insured_City',
      'Insured_State',
      'Loss_Location_City',
      'Loss_Location_State',
      'Past_Claim_Number',
      'Date_of_Loss',
      'Previous_Type_of_Claim',
      'Auto_Manual_Trigger',
      'Manager_Name',
      'Surveyor_Name',
      'Lot_no',
    ];
  }

  static Map<String, String> getLabelDataMap() {
    return Map.fromIterables(fields, createFields);
  }
}
