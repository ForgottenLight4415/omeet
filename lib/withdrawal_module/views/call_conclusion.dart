import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/widgets/input_fields.dart';

import '../data/providers/app_server_provider.dart';
import '../data/providers/call_provider.dart';
import '../utilities/show_snackbars.dart';
import '../utilities/upload_dialog.dart';
import '../widgets/buttons.dart';

class CallConclusionPage extends StatefulWidget {
  final String managerPhoneNumber;
  final String customerPhoneNumber;
  final String caseId;

  const CallConclusionPage({
    Key? key,
    required this.managerPhoneNumber,
    required this.customerPhoneNumber,
    required this.caseId,
  }) : super(key: key);

  @override
  State<CallConclusionPage> createState() => _CallConclusionPageState();
}

class _CallConclusionPageState extends State<CallConclusionPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedPerson = "";
  final List<String> personOptions = <String>[
    "IV",
    "IV Driver",
    "IV Family Member",
    "TP",
    "TP Driver",
    "TP Family Member",
    "Injured",
    "Complainant",
    "Independant Eye Witness",
    "161 Eye Witness",
    "Attendant",
    "Medical Attendant",
    "Investigation Officer",
    "Ambulance",
    "Treating Doctor",
    "RTO Officer",
    "Advocate",
    "Vicinity",
    "Spot location",
    "Police Station",
    "Hospital",
    "Victim Vehicle",
    "Accused Vehicle",
    "Other - free text",
  ];

  String selectedStatus = "";
  final List<String> statusOptions = <String>[
    "This call done",
    "Found number of another person",
    "Ringing not responding",
    "Wrong number",
    "Call back",
    "Out of Network",
    "Busy",
    "Switch off",
  ];

  String selectedTrigger = "";
  final List<String> triggerOptions = <String>[
    "Delay in FIR more than 3 days",
    "Unknown vehicle in FIR",
    "Unknown driver in FIR",
    "Accident version mismatched",
    "Vehicle damages correlation",
    "Injuries correlation mismatch",
    "OD Claim not reported",
    "Insured/Driver and Eyewitness/Complainant knows each other",
    "No same day medical records",
    "Self surrender by insured/driver"
  ];

  late final TextEditingController _personName;
  late final TextEditingController _personNumber;
  late final TextEditingController _callVersion;

  @override
  void initState() {
    super.initState();
    selectedStatus = statusOptions[0];
    selectedPerson = personOptions[0];
    selectedTrigger = triggerOptions[0];
    _personName = TextEditingController();
    _personNumber = TextEditingController(text: widget.customerPhoneNumber);
    _callVersion = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("Call Conclusion"),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showProgressDialog(context, label: "Submitting", content: "Please wait");
                  final Map<String, String> conclusion = <String, String> {
                    "Current_Status": selectedStatus,
                    "Person": selectedPerson,
                    "Person_Name": _personName.text,
                    "Person_Number": _personNumber.text,
                    "Call_Version": _callVersion.text,
                    "Triggers": selectedTrigger,
                    "phone_no": widget.managerPhoneNumber,
                    "Claim_No": widget.caseId,
                  };
                  final CallProvider provider = CallProvider();
                  try {
                    final bool result = await provider.submitConclusion(
                        conclusion);
                    Navigator.pop(context);
                    if (result) {
                      showInfoSnackBar(
                          context, "Submitted", color: Colors.green);
                    } else {
                      showInfoSnackBar(
                          context, "Failed to submit conclusion",
                          color: Colors.red);
                    }
                    Navigator.pop(context);
                  } on AppException {
                    Navigator.pop(context);
                    showInfoSnackBar(
                        context, "Something went wrong",
                        color: Colors.red);
                  }
                },
                child: const Text("Submit"),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Current Status"),
                Card(
                  child: SizedBox(
                    height: 70.h,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        isExpanded: true,
                        icon: const FaIcon(FontAwesomeIcons.chevronDown),
                        underline: const SizedBox(),
                        items: <DropdownMenuItem<String>>[
                          ...statusOptions.map(
                                (option) => DropdownMenuItem<String>(
                              child: Text(option),
                              value: option,
                            ),
                          ),
                        ],
                        onChanged: (conclusion) {
                          setState(() {
                            selectedStatus = conclusion ?? selectedStatus[0];
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text("Person"),
                Card(
                  child: SizedBox(
                    height: 70.h,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: DropdownButton<String>(
                        value: selectedPerson,
                        isExpanded: true,
                        icon: const FaIcon(FontAwesomeIcons.chevronDown),
                        underline: const SizedBox(),
                        items: <DropdownMenuItem<String>>[
                          ...personOptions.map(
                                (option) => DropdownMenuItem<String>(
                              child: Text(option),
                              value: option,
                            ),
                          ),
                        ],
                        onChanged: (conclusion) {
                          setState(() {
                            selectedPerson = conclusion ?? selectedStatus[0];
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const Text("Person name"),
                CustomTextFormField(
                  textEditingController: _personName,
                  label: "Contacted Person Name",
                  hintText: "e.g., John Doe",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  textEditingController: _personNumber,
                  label: "Contacted Person Number",
                  hintText: "1234567890",
                  enabled: false,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  textEditingController: _callVersion,
                  label: "Call Version",
                  hintText: "",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16.0),
                const Text("Select Trigger"),
                Card(
                  child: SizedBox(
                    height: 70.h,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: DropdownButton<String>(
                        value: selectedTrigger,
                        isExpanded: true,
                        icon: const FaIcon(FontAwesomeIcons.chevronDown),
                        underline: const SizedBox(),
                        items: <DropdownMenuItem<String>>[
                          ...triggerOptions.map(
                                (option) => DropdownMenuItem<String>(
                              child: Text(option),
                              value: option,
                            ),
                          ),
                        ],
                        onChanged: (conclusion) {
                          setState(() {
                            selectedTrigger = conclusion ?? selectedStatus[0];
                          });
                        },
                      ),
                    ),
                  ),
                ),
                // const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
