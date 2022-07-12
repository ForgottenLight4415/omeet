import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rc_clone/data/providers/claim_provider.dart';
import 'package:rc_clone/utilities/show_snackbars.dart';

import '../../widgets/input_fields.dart';

class ConclusionPage extends StatefulWidget {
  final Claim claim;

  const ConclusionPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<ConclusionPage> createState() => _ConclusionPageState();
}

class _ConclusionPageState extends State<ConclusionPage> {
  String? _selectedConclusion;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _selectedConclusion = "Select";
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
              width: 412.w,
              height: 70.h,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton<String>(
                  value: _selectedConclusion,
                  isExpanded: true,
                  icon: const FaIcon(FontAwesomeIcons.chevronDown),
                  underline: const SizedBox(),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      child: Text("Select"),
                      value: "Select",
                    ),
                    DropdownMenuItem<String>(
                      child: Text("Positive"),
                      value: "Positive",
                    ),
                    DropdownMenuItem<String>(
                      child: Text("Neutral"),
                      value: "Neutral",
                    ),
                    DropdownMenuItem<String>(
                      child: Text("Negative"),
                      value: "Negative",
                    ),
                  ],
                  onChanged: (conclusion) {
                    setState(() {
                      _selectedConclusion = conclusion ?? "Select";
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          CustomTextFormField(
            textEditingController: _controller,
            textInputAction: TextInputAction.done,
            label: "Conclusion reason",
            hintText: "Enter a reason",
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
                        widget.claim.claimNumber,
                        _selectedConclusion!,
                        _controller!.text,
                      )) {
                        _selectedConclusion = "Select";
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
