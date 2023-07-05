import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/claim.dart';
import '../../data/providers/claim_provider.dart';
import '../../utilities/show_snackbars.dart';
import '../../widgets/input_fields.dart';

class ConclusionPage extends StatefulWidget {
  final Claim claim;

  const ConclusionPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<ConclusionPage> createState() => _ConclusionPageState();
}

class _ConclusionPageState extends State<ConclusionPage> {
  String? _selectedConclusion;
  String? _selectedGroundOfDefense;

  TextEditingController? _controller;

  final List<String> conclusionOptions = [
    "Select",
    "Fraud",
    "Suspected Fraud",
    "Other Defence",
    "Suspected Other Defence",
    "Out of Court Settlement",
    "Genuine",
    "Non Conclusive",
  ];

  final List<String> fraudOptions = [
    "Select Ground Of Defense",
    "Driver Implant or Swapping",
    "Multiple Claim petition filed by same petitioner",
    "Misrepresentation Of Facts",
    "Formal Party",
    "Non-RTA",
    "Petitioner Implant",
    "Vehicle Implant",
    "Segment Change",
    "Fake PYP",
    "WC Claims Related Fraud",
  ];

  final List<String> otherDefenseOptions = [
    "Select Ground Of Defense",
    "Unauthorized passengers or Grattitious Passenger",
    "Petition Not Maintainable",
    "Invalid Driving License",
    "Self-Negligence or Unpaid Driver",
    "Pillion Rider Not Covered",
    "Contributory Negligence TP Chargesheeted",
    "Hire and Reward",
    "No Driving License",
    "No permit and fitness",
    "Check bounce go case",
    "No policy and policy of other insurer or DOL out of policy period",
    "Drunk and Drive",
    "Invalid Permit Hazardous only",
    "No Dependency Major son or Petitioner died",
    "Income of victim",
    "Dependency unit comedown",
    "No future loss of income in case of injured or amputation",
    "No loss of dependency in case of Business ongoing",
    "Medical bills reimbursement",
    "Duplicate claim",
    "Monetary loss of dependency in case of pvt or govt employee death",
    "Fake or inflated income proof",
    "Contributory Negligence",
    "Remarried of deceased wife",
    "No Disability Minor Disability",
  ];

  final List<String> genuineOptions = [
    "Select Ground Of Defense",
    "Non Discrepancy",
  ];

  final List<String> outOfCourtSettlementOptions = [
    "Select Ground Of Defense",
    "Out of Court Settlement",
  ];

  final List<String> nonConclusiveOptions = [
    "Select Ground Of Defense",
    "Non Conclusive",
  ];

  @override
  void initState() {
    super.initState();
    _selectedConclusion = conclusionOptions[0];
    _selectedGroundOfDefense = fraudOptions[0];
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Card(
            child: SizedBox(
              height: 70.h,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton<String>(
                  value: _selectedConclusion,
                  isExpanded: true,
                  icon: const FaIcon(FontAwesomeIcons.chevronDown),
                  underline: const SizedBox(),
                  items: <DropdownMenuItem<String>>[
                    ...conclusionOptions.map(
                          (option) => DropdownMenuItem<String>(
                        child: Text(option),
                        value: option,
                      ),
                    ),
                  ],
                  onChanged: (conclusion) {
                    setState(() {
                      _selectedConclusion = conclusion ?? conclusionOptions[0];
                    });
                  },
                ),
              ),
            ),
          ),
          Card(
            child: SizedBox(
              height: 70.h,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton<String>(
                  value: _selectedGroundOfDefense,
                  isExpanded: true,
                  icon: const FaIcon(FontAwesomeIcons.chevronDown),
                  underline: const SizedBox(),
                  items: getItems(_selectedConclusion!),
                  onChanged: (conclusion) {
                    setState(() {
                      _selectedGroundOfDefense = conclusion ?? fraudOptions[0];
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          CustomTextFormField(
            textEditingController: _controller,
            textInputAction: TextInputAction.done,
            label: "Observation",
            hintText: "Enter a observation",
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final ClaimProvider _provider = ClaimProvider();
                      if (await _provider.submitConclusion(
                        widget.claim.claimId,
                        _selectedConclusion!,
                        _selectedGroundOfDefense!,
                        _controller!.text,
                      )) {
                        _selectedConclusion = conclusionOptions[0];
                        _selectedGroundOfDefense = fraudOptions[0];
                        _controller!.clear();
                        setState(() {});
                        showInfoSnackBar(context, "Submitted",
                            color: Colors.green);
                      } else {
                        showInfoSnackBar(context, "Failed to submit conclusion",
                            color: Colors.red);
                      }
                    },
                    child: const Text("Submit"),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith(
                        (states) => EdgeInsets.symmetric(
                          vertical: 20.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getItems(String option) {
    if (option == conclusionOptions[0]) {
      return const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          child: Text("Select Ground Of Defense"),
          value: "Select Ground Of Defense",
        ),
      ];
    } else if (option == conclusionOptions[1] ||
        option == conclusionOptions[2]) {
      return <DropdownMenuItem<String>>[
        ...fraudOptions.map(
          (option) => DropdownMenuItem<String>(
            child: Text(option),
            value: option,
          ),
        ),
      ];
    } else if (option == conclusionOptions[3] ||
        option == conclusionOptions[4]) {
      return <DropdownMenuItem<String>>[
        ...otherDefenseOptions.map(
          (option) => DropdownMenuItem<String>(
            child: Text(option),
            value: option,
          ),
        ),
      ];
    } else if (option == conclusionOptions[5]) {
      return <DropdownMenuItem<String>>[
        ...outOfCourtSettlementOptions.map(
          (option) => DropdownMenuItem<String>(
            child: Text(option),
            value: option,
          ),
        ),
      ];
    } else if (option == conclusionOptions[6]) {
      return <DropdownMenuItem<String>>[
        ...genuineOptions.map(
          (option) => DropdownMenuItem<String>(
            child: Text(option),
            value: option,
          ),
        ),
      ];
    } else {
      return <DropdownMenuItem<String>>[
        ...nonConclusiveOptions.map(
          (option) => DropdownMenuItem<String>(
            child: Text(option),
            value: option,
          ),
        ),
      ];
    }
  }
}
