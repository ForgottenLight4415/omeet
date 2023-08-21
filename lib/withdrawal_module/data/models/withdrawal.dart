import 'package:flutter/material.dart';
import '../../utilities/show_snackbars.dart';
import '../../utilities/app_permission_manager.dart';
import '../../utilities/location_service.dart';

class Withdrawal {
  final String claimId;
  final String insured;
  final String policeStation;
  final String courtLocation;
  final String currentManagerName;
  final String oldManagerName;
  final String statusOfDocumentSet;
  final String policeConsultantName;
  final String responsible;
  final String logFraudSuspect;
  final String fraudElement;
  final String dateOfAllocation;
  final String caseBrief;
  final String fraudSuspectElements;
  final String fraudFindings;
  final String evidenceAvailable;
  final String currentVisitStatus;
  final String visitRemark;
  final String withdrawalStatus;
  final String caseDeathInjury;
  final String reserve;
  final String caseBriefAdded;
  final String investigationFindings;
  final String probableWithdrawal;
  final String lmSettleableWithdrawn;
  final String finalRemarks;
  final String withdrawalCompletedDate;
  final String currentStatus;

  Withdrawal.fromJson(Map<String, dynamic> decodedJson)
      : claimId = _cleanOrConvert(decodedJson['Claim_No']),
        insured = _cleanOrConvert(decodedJson['Insured']),
        policeStation = _cleanOrConvert(decodedJson['Police_Station']),
        courtLocation = _cleanOrConvert(decodedJson['Court_Location']),
        currentManagerName = _cleanOrConvert(decodedJson['Current_Manager_Name']),
        oldManagerName = _cleanOrConvert(decodedJson['Old_Manager_Name']),
        statusOfDocumentSet = _cleanOrConvert(decodedJson['Status_of_Document_Set']),
        policeConsultantName = _cleanOrConvert(decodedJson['Police_Consultant_Name']),
        responsible = _cleanOrConvert(decodedJson['Responsible']),
        logFraudSuspect = _cleanOrConvert(decodedJson['Log_Fraud_Suspect']),
        fraudElement = _cleanOrConvert(decodedJson['Fraud_Element']),
        dateOfAllocation = _cleanOrConvert(decodedJson['Date_of_Allocation']),
        caseBrief = _cleanOrConvert(decodedJson['Case_Brief']),
        fraudSuspectElements = _cleanOrConvert(decodedJson['Fraud_Suspect_Elements']),
        fraudFindings = _cleanOrConvert(decodedJson['Fraud_Findings']),
        evidenceAvailable = _cleanOrConvert(decodedJson['Evidence_Available']),
        currentVisitStatus =
        _cleanOrConvert(decodedJson['Current_Visit_Status']),
        visitRemark = _cleanOrConvert(decodedJson['Visit_Remark']),
        withdrawalStatus = _cleanOrConvert(decodedJson['Withdrawal_Status']),
        caseDeathInjury = _cleanOrConvert(decodedJson['Case_Death_Injury']),
        reserve = _cleanOrConvert(decodedJson['Reserve']),
        caseBriefAdded = _cleanOrConvert(decodedJson['Case_Brief_Added']),
        investigationFindings = _cleanOrConvert(decodedJson['Investigation_Findings']),
        probableWithdrawal = _cleanOrConvert(decodedJson['Probable_Withdrawal']),
        lmSettleableWithdrawn = _cleanOrConvert(decodedJson['LM_Settleable_Withdrawn']),
        finalRemarks = _cleanOrConvert(decodedJson['Final_Remarks']),
        withdrawalCompletedDate = _cleanOrConvert(decodedJson['Withdrwal_Completed_Date']),
        currentStatus = _cleanOrConvert(decodedJson['Current_Status']);

  Map<String, Map<String, String>> toMap() {
    return <String, Map<String, String>>{
      'Accident Details': <String, String>{
        'Case ID': claimId,
        'Insured': insured,
        'Police station': policeStation,
        'Court Location': courtLocation,
        'Current Manager name': currentManagerName,
        'Old Manager Name': oldManagerName,
        'Status of document set': statusOfDocumentSet,
        'Police Consultant Name': policeConsultantName,
        'Responsible': responsible,
        'Log-Fraud/Suspect': logFraudSuspect,
        'Fraud Element': fraudElement,
        'Date of Allocation': dateOfAllocation,
        'Case brief': caseBrief,
        'Fraud / Suspect elements': fraudSuspectElements,
        'Fraud findings': fraudFindings,
        'Evidence available': evidenceAvailable,
        'Current visit status': currentVisitStatus,
        'Visit Remark': visitRemark,
        'Withdrawal Status': withdrawalStatus,
        'Case Death / Injury': caseDeathInjury,
        'Reserve': reserve,
        'Case Brief': caseBrief,
        'Investigation Findings': investigationFindings,
        'Probable Withdrawal': probableWithdrawal,
        'LM/Settleable/Withdrawn': lmSettleableWithdrawn,
        'Remarks': finalRemarks,
        'Withdrwal/Completed Date': withdrawalCompletedDate,
      }
    };
  }

  Map<String, dynamic> toInternetMap() {
    return <String, String>{
      "Claim_No": claimId,
      "Insured": insured,
      "Police_Station": policeStation,
      "Court_Location": courtLocation,
      "Current_Manager_Name": currentManagerName,
      "Old_Manager_Name": oldManagerName,
      "Status_of_Document_Set": statusOfDocumentSet,
      "Police_Consultant_Name": policeConsultantName,
      "Responsible": responsible,
      "Log_Fraud_Suspect": logFraudSuspect,
      "Fraud_Element": fraudElement,
      "Date_of_Allocation": dateOfAllocation,
      "Case_Brief": caseBrief,
      "Fraud_Suspect_Elements": fraudSuspectElements,
      "Fraud_Findings": fraudFindings,
      "Evidence_Available": evidenceAvailable,
      "Current_Visit_Status": currentVisitStatus,
      "Visit_Remark": visitRemark,
      "Withdrawal_Status": withdrawalStatus,
      "Case_Death_Injury": caseDeathInjury,
      "Reserve": reserve,
      "Case_Brief_Added": caseBriefAdded,
      "Investigation_Findings": investigationFindings,
      "Probable_Withdrawal": probableWithdrawal,
      "LM_Settleable_Withdrawn": lmSettleableWithdrawn,
      "Final_Remarks": finalRemarks,
      "Withdrwal_Completed_Date": withdrawalCompletedDate,
      "Current_Status": currentStatus,
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
}
