import 'package:omeet_motor/utilities/data_cleaner.dart';

import 'hospital.dart';

class Audit {
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
    : hospital = Hospital.fromJson(decodedJson),
  auditeeName = cleanOrConvert(decodedJson["auditee_name"]),
  locationManager = cleanOrConvert(decodedJson["location_manager"]),
  status = cleanOrConvert(decodedJson["audit_status"]),
  actionSuggested = cleanOrConvert(decodedJson["action_suggested"]),
  hatFinalAction = cleanOrConvert(decodedJson["hat_final_action"]),
  auditObservations = cleanOrConvert(decodedJson["description_of_audit_observations"]),
  distinctHospitalId = cleanOrConvert(decodedJson["distinct_hospital_ids"]),
  network = cleanOrConvert(decodedJson["network"]),
  claimsCount = cleanOrConvert(decodedJson["claims_count"]),
  claimsPaid = cleanOrConvert(decodedJson["claims_paid"]),
  investigated = cleanOrConvert(decodedJson["investigated"]),
  investigatedPercent = cleanOrConvert(decodedJson["investigated_percent"]),
  softFraud = cleanOrConvert(decodedJson["soft_fraud"]),
  hardFraud = cleanOrConvert(decodedJson["hard_fraud"]),
  total = cleanOrConvert(decodedJson["total_percent"]),
  softFraudPercent = cleanOrConvert(decodedJson["soft_fraud_percent"]),
  hardFraudPercent = cleanOrConvert(decodedJson["hard_fraud_percent"]),
  totalPercent = cleanOrConvert(decodedJson["total_percent"]),
  covidClaims = cleanOrConvert(decodedJson["covid_claims"]),
  covidPercent = cleanOrConvert(decodedJson["covid_percent"]),
  audited = cleanOrConvert(decodedJson["audited"]),
  preventiveAction = cleanOrConvert(decodedJson["preventive_action"]),
  recoveredAmount = cleanOrConvert(decodedJson["recovered_amount"]),
  chequeNumber = cleanOrConvert(decodedJson["cheque_number"]),
  chequeDate = cleanOrConvert(decodedJson["cheque_date"]),
  industryAlert = cleanOrConvert(decodedJson["industry_alert_given"]),
  dataUploaded = cleanOrConvert(decodedJson["data_uploaded"]);

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
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