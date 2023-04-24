import '../../utilities/data_cleaner.dart';
import 'hospital.dart';

class Audit {
  final String auditId;
  final Hospital hospital;
  final String auditeeName;
  final String locationManager;
  final String status;
  final String actionSuggested;
  final String hatFinalAction;
  final String auditObservations;
  final String distinctHospitalId;
  final String network;
  final String claimsCount;
  final String claimsPaid;
  final String investigated;
  final String investigatedPercent;
  final String softFraud;
  final String hardFraud;
  final String total;
  final String softFraudPercent;
  final String hardFraudPercent;
  final String totalPercent;
  final String covidClaims;
  final String covidPercent;
  final String audited;
  final String preventiveAction;
  final String recoveredAmount;
  final String chequeNumber;
  final String chequeDate;
  final String industryAlert;
  final String dataUploaded;

  Audit.fromJson(Map<String, dynamic> decodedJson)
    : auditId = cleanOrConvert(decodedJson["id"]),
  hospital = Hospital.fromJson(decodedJson),
  auditeeName = cleanOrConvert(decodedJson["Auditee_Name"]),
  locationManager = cleanOrConvert(decodedJson["Location_Manager"]),
  status = cleanOrConvert(decodedJson["Audit_status"]),
  actionSuggested = cleanOrConvert(decodedJson["Action_Suggested"]),
  hatFinalAction = cleanOrConvert(decodedJson["HAT_Final_Action"]),
  auditObservations = cleanOrConvert(decodedJson["Description_of_Audit_observations"]),
  distinctHospitalId = cleanOrConvert(decodedJson["Distinct_hospital_Ids"]),
  network = cleanOrConvert(decodedJson["Network_OR__non_network"]),
  claimsCount = cleanOrConvert(decodedJson["Claims_count"]),
  claimsPaid = cleanOrConvert(decodedJson["Claims_paid"]),
  investigated = cleanOrConvert(decodedJson["Investigated"]),
  investigatedPercent = cleanOrConvert(decodedJson["Investigated_Percent"]),
  softFraud = cleanOrConvert(decodedJson["Soft_Fraud"]),
  hardFraud = cleanOrConvert(decodedJson["Hard_Fraud"]),
  total = cleanOrConvert(decodedJson["Total_F"]),
  softFraudPercent = cleanOrConvert(decodedJson["Soft_Fraud_Percent"]),
  hardFraudPercent = cleanOrConvert(decodedJson["Hard_Fraud_Percent"]),
  totalPercent = cleanOrConvert(decodedJson["Total_Percent"]),
  covidClaims = cleanOrConvert(decodedJson["Covid_Claims"]),
  covidPercent = cleanOrConvert(decodedJson["COVID_Percent"]),
  audited = cleanOrConvert(decodedJson["Audited"]),
  preventiveAction = cleanOrConvert(decodedJson["Preventive_Action"]),
  recoveredAmount = cleanOrConvert(decodedJson["Recovered_Amount"]),
  chequeNumber = cleanOrConvert(decodedJson["Cheque_OR_UTR_NO"]),
  chequeDate = cleanOrConvert(decodedJson["Date_Cheque_OR_UTR_NO"]),
  industryAlert = cleanOrConvert(decodedJson["Industry_Alert_Given"]),
  dataUploaded = cleanOrConvert(decodedJson["Data_Uploaded_in_FRMP"]);

  Map<String, Map<String, dynamic>> toMap() {
    return <String, Map<String, dynamic>> {
      'Hospital Details': hospital.toMap(),
      'Audit Details': {
        'Auditee name': auditeeName,
        'Location manager': locationManager,
        'Audit status': status,
        'Action suggested': actionSuggested,
        'HAT final action': hatFinalAction,
        'Description of Audit Observations' : auditObservations,
        'Distinct Hospital IDs': distinctHospitalId,
        'Network/Non-network': network,
      },
      'Claim Details': {
        'Claims count': claimsCount,
        'Claims paid': claimsPaid,
        'Investigated': investigated,
        'Investigated %': investigatedPercent,
        'Soft fraud': softFraud,
        'Hard fraud': hardFraud,
        'Total': total,
        'Soft fraud %': softFraudPercent,
        'Hard fraud %': hardFraudPercent,
        'Total %': totalPercent,
        'Covid claims': covidClaims,
        'Covid %': covidPercent,
        'Audited': audited,
        'Preventive action': preventiveAction,
        'Recovered amount': recoveredAmount,
        'Cheque/UTR No': chequeNumber,
        'Date Cheque/UTR No': chequeDate,
        'Industry alert given': industryAlert,
        'Data uploaded in FRMP': dataUploaded,
      }
    };
  }
}