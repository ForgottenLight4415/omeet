import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omeet_motor/data/models/hospital.dart';
import 'package:omeet_motor/data/models/people.dart';
import 'package:omeet_motor/utilities/show_snackbars.dart';
import '../../blocs/call_bloc/call_cubit.dart';
import '../../utilities/app_permission_manager.dart';
import '../../utilities/data_cleaner.dart';
import '../../utilities/location_service.dart';
import '../../widgets/input_fields.dart';
import '../repositories/call_repo.dart';

class Claim {
  final String pid;
  final String claimID;

  final String product;
  final String caseType;

  final String clid;
  final String claimNumber;
  final String claimStatus;

  final String policyNumber;
  final String policyAge;

  final String preAuthDate;
  final String preAuthAmount;

  final InsuredPerson insuredPerson;
  final Patient patient;
  final Hospital hospital;

  final String managerName;
  final String surveyorName;
  final String dateOfAllocation;
  final String timeOfAllocation;
  final String currentStatus;
  final String scheduler;

  final String nameDrO;
  final String drOStatement;
  final String drOConclusion;

  final String videoMeetDate;
  final String videoMeetTime;

  final String tat;
  final String kycStatus;
  final String kycStatusProof;
  final String faceMatch;
  final String gMeet;
  final String meetLink;

  final String conclusion;
  final String groundOfDefence;

  final String actionableReason;
  final String actionable;
  final String insuranceActionable;
  final String actionableDate;

  final String conferenceNumber;
  final String conferenceName;
  final String completionDate;
  final String completionTime;
  final String schedulingDate;

  final String nameDrB;
  final String billPaid;
  final String paidToDr;

  final String triggerCase;

  Claim.fromJson(Map<String, dynamic> decodedJson)
      : claimID = cleanOrConvert(decodedJson['id']),

        pid = cleanOrConvert(decodedJson["pid"]),
        clid = cleanOrConvert(decodedJson["clid"]),
        product = cleanOrConvert(decodedJson["product"]),
        caseType = cleanOrConvert(decodedJson["case_type"]),

        // CLAIM DETAILS
        claimNumber = cleanOrConvert(decodedJson["Claim_No"]),
        claimStatus = cleanOrConvert(decodedJson["claim_status"]),

        // POLICY DETAILS
        policyNumber = cleanOrConvert(decodedJson["policy_number"]),
        policyAge = cleanOrConvert(decodedJson["policy_age"]),
        
        preAuthDate = cleanOrConvert(decodedJson["pre_auth_date"]),
        preAuthAmount = cleanOrConvert(decodedJson["pre_auth_amt"]),

        insuredPerson = InsuredPerson.fromJson(decodedJson),
        patient = Patient.fromJson(decodedJson),
        hospital = Hospital.fromJson(decodedJson),

        // EXTRAS
        managerName = cleanOrConvert(decodedJson["Manager_Name"]),
        surveyorName = cleanOrConvert(decodedJson["Surveyor_Name"]),
        dateOfAllocation = cleanOrConvert(decodedJson["Date_of_Allocation"]),
        timeOfAllocation = cleanOrConvert(decodedJson["Time_of_Allocation"]),
        currentStatus = cleanOrConvert(decodedJson["Current_Status"]),
        scheduler = cleanOrConvert(decodedJson["Scheduler"]),

        nameDrO = cleanOrConvert(decodedJson["name_dr_o"]),
        drOStatement = cleanOrConvert(decodedJson["dr_o_statement"]),
        drOConclusion = cleanOrConvert(decodedJson["dr_o_conclusion"]),
        videoMeetDate = cleanOrConvert(decodedJson["Video_Meet_Date"]),
        videoMeetTime = cleanOrConvert(decodedJson["Video_Meet_Time"]),

        tat = cleanOrConvert(decodedJson["TAT"]),
        kycStatus = cleanOrConvert(decodedJson["KYC_Status"]),
        kycStatusProof = cleanOrConvert(decodedJson["KYC_Status_Proof"]),
        faceMatch = cleanOrConvert(decodedJson["Face_Match"]),
        gMeet = cleanOrConvert(decodedJson["gmeet"]),
        meetLink = cleanOrConvert(decodedJson["meet_link"]),

        conclusion = cleanOrConvert(decodedJson["Conclusion"]),
        groundOfDefence = cleanOrConvert(decodedJson["Ground_Of_Defense"]),

        actionableReason = cleanOrConvert(decodedJson["ACTIONABLE_reason"]),
        actionable = cleanOrConvert(decodedJson["ACTIONABLE"]),
        insuranceActionable = cleanOrConvert(decodedJson["Insurance_Actionable"]),
        actionableDate = cleanOrConvert(decodedJson["Actionable_date"]),

        conferenceNumber = cleanOrConvert(decodedJson["conference_number"]),
        conferenceName = cleanOrConvert(decodedJson["conference_name"]),
        completionDate = cleanOrConvert(decodedJson["Completion_Date"]),
        completionTime = cleanOrConvert(decodedJson["Completion_Time"]),
        schedulingDate = cleanOrConvert(decodedJson["SCHEDULING_DATE"]),
  
        nameDrB = cleanOrConvert(decodedJson["name_dr_b"]),
        billPaid = cleanOrConvert(decodedJson["bill_paid"]),
        paidToDr = cleanOrConvert(decodedJson["paid_to_dr"]),
        triggerCase = cleanOrConvert(decodedJson["Trigger_Case"]);

  Map<String, Map<String, dynamic>> toMap() {
    return <String, Map<String, dynamic>> {
      'Claim Details': <String, dynamic> {
        'PID': pid,
        'CLID': clid,
        'Claim ID': claimID,
        'Case type': caseType,
        'Claim status': claimStatus,
        'Current status': currentStatus,
        'Completion date': completionDate,
        'Completion time': completionTime,
        'Scheduling date': schedulingDate,
        'Product': product,
        'Pre auth date': preAuthDate,
        'Pre auth amount': preAuthAmount,
        'Bill paid': billPaid,
        'Paid to doctor': paidToDr,
        'Trigger case': triggerCase,
        'Ground of defense': groundOfDefence,
        'Conclusion': conclusion
      },
      'Policy Details': <String, String> {
        'Policy number': policyNumber,
        'Policy age': policyAge,
      },
      'Insured Person': insuredPerson.toMap(),
      'Patient': patient.toMap(),
      'Hospital': hospital.toMap(),
      'Allocation Details': <String, String> {
        'Manager name': managerName,
        'Surveyor name': surveyorName,
        'Date of allocation': dateOfAllocation,
        'Time of allocation': timeOfAllocation,
        'Scheduler': scheduler,
      },
      'Doctor': <String, String> {
        'Name (Doctor O)': nameDrO,
        'Statement (Doctor O)': drOStatement,
        'Conclusion (Doctor O)': drOConclusion,
        'Video meet date': videoMeetDate,
        'Video meet time': videoMeetTime,
        'GMeet': gMeet,
        "Meeting link": meetLink,
        'Name (Doctor B)': nameDrB,
      },
      'Extra Information': <String, String> {
        'TAT': tat,
        'KYC status': kycStatus,
        'KYC status proof': kycStatusProof,
        'Face match': faceMatch,
      },
      'Action': <String, String> {
        'Actionable': actionable,
        'Insurance actionable': insuranceActionable,
        'Reason': actionableReason,
        'Actionable date': actionableDate,
      },
    };
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
    String? selectedPhone = insuredPerson.insuredContactNumber;
    if (selectedPhone != "Unavailable") {
      BlocProvider.of<CallCubit>(context).callClient(
        claimNumber: claimNumber,
        phoneNumber: selectedPhone,
      );
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendMessageModal(BuildContext context) async {
    String? selectedPhone = insuredPerson.insuredContactNumber;
    final TextEditingController _controller = TextEditingController(
        text: selectedPhone == "Unavailable" ? "" : selectedPhone,
    );
    final bool sendButtonPressed = await showModalBottomSheet<bool?>(
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
            ),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  showInfoSnackBar(context, "Sending message",
                      color: Colors.orange,
                  );
                },
                child: const Text("SEND"),
              ),
            ),
          ],
        ),
      ),
    ) ?? false;
    if (sendButtonPressed && _controller.text.length == 10) {
      final CallRepository callRepository = CallRepository();
      final bool messageRequestStatus = await callRepository.sendMessage(
        claimNumber: claimNumber,
        phoneNumber: _controller.text,
      );
      if (messageRequestStatus) {
        showInfoSnackBar(context, "Message sent", color: Colors.green);
      } else {
        showInfoSnackBar(context, "Failed", color: Colors.red);
      }
    } else if (sendButtonPressed && _controller.text.length != 10) {
      showInfoSnackBar(context, "Enter a valid phone number", color: Colors.red);
    }
  }
}
