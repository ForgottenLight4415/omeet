import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/withdrawal.dart';
import '../../data/providers/claim_provider.dart';
import '../../utilities/show_snackbars.dart';
import '../../widgets/input_fields.dart';

class ConclusionPage extends StatefulWidget {
  final Withdrawal claim;

  const ConclusionPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<ConclusionPage> createState() => _ConclusionPageState();
}

class _ConclusionPageState extends State<ConclusionPage> {
  String? _selectedVisitStatus;
  String? _probableWithdrawn;
  String? _withdrawalStatus;

  TextEditingController? _controller;
  TextEditingController? _controllerB;
  TextEditingController? _controllerC;

  final List<String> visitOptions = [
    "Visit Pending",
    "Visit Done",
  ];

  final List<String> probableWithdrawnOptions = [
    "Yes",
    "No",
    "Pending"
  ];

  final List<String> withdrawalStatusOptions = [
    "Case withdrawn",
    "Court closed",
    "Genuine case",
    "Non cooperation",
    "Probable withdrawal",
    "Under investigation",
    "Visit pending"
  ];

  @override
  void initState() {
    super.initState();
    _selectedVisitStatus = visitOptions[0];
    _probableWithdrawn = probableWithdrawnOptions[0];
    _withdrawalStatus = withdrawalStatusOptions[0];
    _controller = TextEditingController();
    _controllerB = TextEditingController();
    _controllerC = TextEditingController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _controllerB!.dispose();
    _controllerC!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("Current Visit Status"),
          ),
          Card(
            child: SizedBox(
              height: 70.h,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton<String>(
                  value: _selectedVisitStatus,
                  isExpanded: true,
                  icon: const FaIcon(FontAwesomeIcons.chevronDown),
                  underline: const SizedBox(),
                  items: <DropdownMenuItem<String>>[
                    ...visitOptions.map(
                          (option) => DropdownMenuItem<String>(
                        child: Text(option),
                        value: option,
                      ),
                    ),
                  ],
                  onChanged: (conclusion) {
                    setState(() {
                      _selectedVisitStatus = conclusion ?? visitOptions[0];
                    });
                  },
                ),
              ),
            ),
          ),
          CustomTextFormField(
            textEditingController: _controller,
            textInputAction: TextInputAction.done,
            label: "Visit Remarks",
            hintText: "Enter a remark",
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("Probable withdrawn"),
          ),
          Card(
            child: SizedBox(
              height: 70.h,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton<String>(
                  value: _probableWithdrawn,
                  isExpanded: true,
                  icon: const FaIcon(FontAwesomeIcons.chevronDown),
                  underline: const SizedBox(),
                  items: <DropdownMenuItem<String>>[
                    ...probableWithdrawnOptions.map(
                          (option) => DropdownMenuItem<String>(
                        child: Text(option),
                        value: option,
                      ),
                    ),
                  ],
                  onChanged: (conclusion) {
                    setState(() {
                      _probableWithdrawn = conclusion ?? probableWithdrawnOptions[0];
                    });
                  },
                ),
              ),
            ),
          ),
          CustomTextFormField(
            textEditingController: _controllerB,
            textInputAction: TextInputAction.done,
            label: "LM/Settleable/Withdrawn",
            hintText: "Enter a observation",
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("Withdrawal Status"),
          ),
          Card(
            child: SizedBox(
              height: 70.h,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton<String>(
                  value: _withdrawalStatus,
                  isExpanded: true,
                  icon: const FaIcon(FontAwesomeIcons.chevronDown),
                  underline: const SizedBox(),
                  items: <DropdownMenuItem<String>>[
                    ...withdrawalStatusOptions.map(
                          (option) => DropdownMenuItem<String>(
                        child: Text(option),
                        value: option,
                      ),
                    ),
                  ],
                  onChanged: (conclusion) {
                    setState(() {
                      _withdrawalStatus = conclusion ?? withdrawalStatusOptions[0];
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          CustomTextFormField(
            textEditingController: _controllerC,
            textInputAction: TextInputAction.done,
            label: "Final Remarks",
            hintText: "Enter a remark",
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
                        _selectedVisitStatus!,
                        _controller!.text,
                        _probableWithdrawn!,
                        _controllerB!.text,
                        _withdrawalStatus!,
                        _controller!.text,
                      )) {
                        _selectedVisitStatus = visitOptions[0];
                        _probableWithdrawn = probableWithdrawnOptions[0];
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
}
