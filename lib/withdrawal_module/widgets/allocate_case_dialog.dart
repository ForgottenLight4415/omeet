import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/data/repositories/auth_repo.dart';

import '../blocs/home_bloc/assign_to_self_cubit/assign_self_cubit.dart';
import '../utilities/show_snackbars.dart';
import '../utilities/upload_dialog.dart';
import 'input_fields.dart';

class AllocateCaseDialog extends StatefulWidget {
  final String caseId;

  const AllocateCaseDialog({Key? key, required this.caseId}) : super(key: key);

  @override
  State<AllocateCaseDialog> createState() => _AllocateCaseDialogState();
}

class _AllocateCaseDialogState extends State<AllocateCaseDialog> {
  final TextEditingController _reasonController = TextEditingController();
  String selected = "Review and Accept";
  final List<String> options = <String>[
    "Review and Accept",
    "Review and Reject",
  ];

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        top: 15.0,
        right: 15.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15.0,
      ),
      child: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Card(
              child: SizedBox(
                height: 70.h,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DropdownButton<String>(
                    value: selected,
                    isExpanded: true,
                    icon: const FaIcon(FontAwesomeIcons.chevronDown),
                    underline: const SizedBox(),
                    items: <DropdownMenuItem<String>>[
                      ...options.map(
                            (option) => DropdownMenuItem<String>(
                          child: Text(option),
                          value: option,
                        ),
                      ),
                    ],
                    onChanged: (conclusion) {
                      setState(() {
                        selected = conclusion ?? options[0];
                      });
                    },
                  ),
                ),
              ),
            ),
            selected == options[1] ? CustomTextFormField(
              textEditingController: _reasonController,
              label: "Reason",
              hintText: "Enter a reason",
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Required";
                }
                return null;
              },
            ) : const SizedBox(),
            const SizedBox(height: 5.0),

            BlocProvider<AssignSelfCubit>(
              create: (context) => AssignSelfCubit(),
              child: BlocConsumer<AssignSelfCubit, AssignSelfState>(
                  listener: (context, state) {
                    if (state is AssignSelfLoading) {
                      showProgressDialog(
                        context,
                        label: "Updating status",
                        content: "Updating (Case ID: ${widget.caseId})",
                      );
                    } else if (state is AssignSelfSuccess) {
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                      if (state.success) {
                        showInfoSnackBar(
                            context, "Case updated", color: Colors.green);
                      } else {
                        showInfoSnackBar(context, "Failed to update", color: Colors.red);
                      }
                    } else if (state is AssignSelfFailed) {
                      Navigator.pop(context);
                      Navigator.pop(context, false);
                      showInfoSnackBar(context, "Failed to update", color: Colors.red);
                    }
                  },
                  builder: (context, snapshot) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            final Map<String, String> payload = <String, String> {
                              "Claim_No" : widget.caseId,
                              "phone_no" : await AuthRepository.getPhone(),
                              "Case_Acceptance": selected == options[0] ? "ACCEPTED" : "REJECTED",
                              "Case_Rejection_Reason": _reasonController.text,
                            };
                            await BlocProvider.of<AssignSelfCubit>(context).assignToSelf(context, payload);
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
