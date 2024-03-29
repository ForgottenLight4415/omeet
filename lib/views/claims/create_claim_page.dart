import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/new_claim_cubit/new_claim_cubit.dart';
import '../../data/models/claim.dart';
import '../../utilities/show_snackbars.dart';
import '../../utilities/upload_dialog.dart';
import '../../widgets/buttons.dart';
import '../../widgets/input_fields.dart';

class NewClaimPage extends StatefulWidget {
  const NewClaimPage({Key? key}) : super(key: key);

  @override
  State<NewClaimPage> createState() => _NewClaimPageState();
}

class _NewClaimPageState extends State<NewClaimPage> {
  Map<String, TextEditingController>? _textEditingControllers;
  List<Widget>? _formLayout;
  String _typeDropDown = "Select claim type";

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New claim"),
        leading: const AppBackButton(),
        actions: <Widget>[
          BlocProvider<NewClaimCubit>(
            create: (context) => NewClaimCubit(),
            child: BlocConsumer<NewClaimCubit, NewClaimState>(
              listener: (context, state) {
                if (state is CreatingClaim) {
                  showProgressDialog(context,
                      label: "Creating", content: "Creating new claim");
                } else if (state is CreatedClaim) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showInfoSnackBar(
                      context, "Claim created.",
                      color: Colors.green);
                } else if (state is CreationFailed) {
                  Navigator.pop(context);
                  showInfoSnackBar(context, "Failed to create claim.",
                      color: Colors.red);
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      if (_typeDropDown == "Select claim type") {
                        showInfoSnackBar(context, "Select claim type", color: Colors.red);
                        return;
                      }
                      Map<String, dynamic> _data = {};
                      Claim.getLabelDataMap().forEach((key, value) {
                        _data.putIfAbsent(
                          value,
                              () => _textEditingControllers![key]?.text ?? "",
                        );
                      });
                      BlocProvider.of<NewClaimCubit>(context).createClaim(
                        claimData: _data,
                      );
                    }
                  },
                  icon: const Icon(Icons.check),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _key,
            child: Column(
              children: _formLayout ?? _createFormFields(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createFormFields() {
    final Map<String, List<String>> claimFields = Claim.fields;
    final Map<String, TextEditingController> textEditingControllers = {};
    List<Widget> formLayout = [];
    claimFields.forEach((title, fields) {
      formLayout.addAll([
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ]);
      for (var fieldName in fields) {
        if (!(fieldName == "Manager Name" || fieldName == "Surveyor Name")) {
          if (fieldName == "Type of claim") {
            Padding _dropDown = Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: DropdownButtonFormField<String>(
                value: _typeDropDown,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(child: Text("Select claim type"), value: "Select claim type",),
                  DropdownMenuItem<String>(child: Text("Own Damage"), value: "Own Damage",),
                  DropdownMenuItem<String>(child: Text("Motor Theft"), value: "Motor Theft",),
                  DropdownMenuItem<String>(child: Text("Third party"), value: "Motor Theft",),
                  DropdownMenuItem<String>(child: Text("AIR"), value: "Motor Theft",),
                  DropdownMenuItem<String>(child: Text("CCTNS"), value: "Motor Theft",),
                ],
                onChanged: (value) {
                  setState(() {
                    _typeDropDown = value ?? "Select";
                  });
                },
              ),
            );
            formLayout.add(_dropDown);
            continue;
          }
          TextEditingController textEditingController = TextEditingController();
          textEditingControllers.putIfAbsent(
              fieldName, () => textEditingController);
          formLayout.add(
            CustomTextFormField(
              textEditingController: textEditingController,
              label: fieldName,
              hintText: "Enter $fieldName",
              validator: fieldName == "Customer name"
                  || fieldName == "Phone number"
                  || fieldName == "Claim number"
                  ? (value) {
                    if (value!.isEmpty) {
                      return "Please enter ${fieldName.toLowerCase()}";
                    } else {
                      return null;
                    }
                  } : null,
            ),
          );
          formLayout.add(
            const SizedBox(height: 7.0),
          );
        }
      }
    });
    _textEditingControllers = textEditingControllers;
    _formLayout = formLayout;
    return formLayout;
  }

  @override
  void dispose() {
    _textEditingControllers?.forEach((key, value) {
      _textEditingControllers![key]?.dispose();
    });
    super.dispose();
  }
}
