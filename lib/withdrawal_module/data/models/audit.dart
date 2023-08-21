import 'package:omeet_motor/data/models/hospital.dart';

enum AuditStatus { completed, workInProgress, pending, nonPotential, recovered }

enum ActionSuggested { deList, warningLetter, terminationLetter }

class Audit {
  final Hospital hospital;
  final String auditerName;
  final String locationManager;
  final AuditStatus status;
  final ActionSuggested actionSuggested;
  final String hatFinalAction;
  final String auditObservations;
  final String distinctHospitalId;
  final String network;
  final int claimsCount;
  final int claimsPaid;
  final int investigated;
  final double investigatedPercent;
  final int softFraud;
  final int hardFraud;
  final int total;
  final double softFraudPercent;
  final double hardFraudPercent;
  final double covidPercent;
  final int audited;
  final String preventiveAction;
  final double recoveredAmount;
  final String chequeNumber;
  final DateTime chequeDate;
  final bool industryAlert;
  final bool dataUploaded;

  const Audit({
    required this.hospital,
    required this.auditerName,
    required this.locationManager,
    required this.status,
    required this.actionSuggested,
    required this.hatFinalAction,
    required this.auditObservations,
    required this.distinctHospitalId,
    required this.network,
    required this.claimsCount,
    required this.claimsPaid,
    required this.investigated,
    required this.investigatedPercent,
    required this.softFraud,
    required this.hardFraud,
    required this.total,
    required this.softFraudPercent,
    required this.hardFraudPercent,
    required this.covidPercent,
    required this.audited,
    required this.preventiveAction,
    required this.recoveredAmount,
    required this.chequeNumber,
    required this.chequeDate,
    required this.industryAlert,
    required this.dataUploaded});
}