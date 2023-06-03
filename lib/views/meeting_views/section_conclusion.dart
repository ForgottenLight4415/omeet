import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/providers/claim_provider.dart';
import '../../utilities/show_snackbars.dart';
import '../../widgets/input_fields.dart';

class ConclusionPage extends StatefulWidget {
  final String claimNumber;

  const ConclusionPage({Key? key, required this.claimNumber}) : super(key: key);

  @override
  State<ConclusionPage> createState() => _ConclusionPageState();
}

class _ConclusionPageState extends State<ConclusionPage> {
  late final DateTime _today;
  late final TextEditingController _recoveredAmount;
  late final TextEditingController _chequeNo;
  late final TextEditingController _industryAlert;
  late final TextEditingController _dataUploaded;

  DateTime _selectedDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _recoveredAmount = TextEditingController();
    _chequeNo = TextEditingController();
    _industryAlert = TextEditingController();
    _dataUploaded = TextEditingController();
  }

  @override
  void dispose() {
    _recoveredAmount.dispose();
    _chequeNo.dispose();
    _industryAlert.dispose();
    _dataUploaded.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _today.subtract(const Duration(days: 90)),
      lastDate: _today.add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CustomTextFormField(
                textEditingController: _recoveredAmount,
                label: "Recovered amount (in lakhs)",
                hintText: "e.g. 2.5",
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This is a required field";
                  } else if (double.parse(value) == 0) {
                    return "This field cannot be 0";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              CustomTextFormField(
                textEditingController: _chequeNo,
                label: "Cheque/UTR No.",
                hintText: "Enter cheque or UTR number",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This is a required field";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Date of cheque/UTR",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${_selectedDate.toLocal()}".split(' ')[0]),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomTextFormField(
                textEditingController: _industryAlert,
                label: "Industry alert given",
                hintText: "Enter industry alert given",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This is a required field";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              CustomTextFormField(
                textEditingController: _dataUploaded,
                label: "Data uploaded in FRMP",
                hintText: "Enter data uploaded in FRMP",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This is a required field";
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  FocusScope.of(context).unfocus();
                  final Map<String, String> submissionData = <String, String> {
                    "Claim_No" : widget.claimNumber,
                    "Recovered_Amount" : _recoveredAmount.text,
                    "Cheque_OR_UTR_NO" : _chequeNo.text,
                    "Date_Cheque_OR_UTR_NO": _selectedDate.toIso8601String(),
                    "Industry_Alert_Given": _industryAlert.text,
                    "Data_Uploaded_in_FRMP": _dataUploaded.text,
                  };
                  final ClaimProvider _provider = ClaimProvider();
                  final bool submissionResult
                    = await _provider.submitConclusion(submissionData);
                  if (submissionResult) {
                    _selectedDate = DateTime.now();
                    _recoveredAmount.clear();
                    _chequeNo.clear();
                    _industryAlert.clear();
                    _dataUploaded.clear();
                    setState(() {});
                    showInfoSnackBar(context, "Submitted", color: Colors.green);
                  } else {
                    showInfoSnackBar(context, "Failed to submit conclusion",
                    color: Colors.red);
                  }
                },
                child: const Text("SAVE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
