import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rc_clone/blocs/new_claim_cubit/new__claim_cubit.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/utilities/show_snackbars.dart';
import 'package:rc_clone/utilities/upload_dialog.dart';
import 'package:rc_clone/widgets/buttons.dart';
import 'package:rc_clone/widgets/input_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewClaimPage extends StatefulWidget {

  const NewClaimPage({Key? key}) : super(key: key);

  @override
  State<NewClaimPage> createState() => _NewClaimPageState();
}

class _NewClaimPageState extends State<NewClaimPage> {
  Map<String, TextEditingController>? _textEditingControllers;

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
                  showProgressDialog(context, label: "Creating", content: "Creating new claim");
                } else if (state is CreatedClaim) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showInfoSnackBar(context, "Claim created. Pull down to refresh", color: Colors.green);
                } else if (state is CreationFailed) {
                  Navigator.pop(context);
                  showInfoSnackBar(context, "Failed to create claim.", color: Colors.red);
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      showInfoSnackBar(context, "Creating claim", color: Colors.orange);
                      Map<String, dynamic> _data = {};
                      final SharedPreferences _pref = await SharedPreferences.getInstance();
                      _data.putIfAbsent("Manager_Name", () => _pref.getString('email'));
                      _data.putIfAbsent("Surveyor_Name", () => _pref.getString('email'));
                      Claim.getLabelDataMap().forEach((key, value) {
                        _data.putIfAbsent(value, () => _textEditingControllers![key]!.text);
                      });
                      final Claim _claim = Claim.fromJson(_data);
                      BlocProvider.of<NewClaimCubit>(context).createClaim(claim: _claim);
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
              children: _createFormFields(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createFormFields() {
    final Map<String, String> claimFields = Claim.getLabelDataMap();
    final Map<String, TextEditingController> textEditingControllers = {};
    List<Widget> textFields = <Widget>[];
    claimFields.forEach((key, value) {
      if (!(key == "Manager Name" || key == "Surveyor Name")) {
        TextEditingController textEditingController = TextEditingController();
        textEditingControllers.putIfAbsent(key, () => textEditingController);
        textFields.add(
          CustomTextFormField(
            textEditingController: textEditingController,
            label: key,
            hintText: "Enter $key",
            validator: key == "Insured_Name" || key == "Insured_Contact_Number" || key == "Claim_No" ? (value) {
              if (value!.isEmpty) {
                return "Please enter $key";
              } else {
                return null;
              }
            } : null,
          ),
        );
        textFields.add(
          SizedBox(
            height: 12.h,
          ),
        );
      }
    });
    _textEditingControllers = textEditingControllers;
    return textFields;
  }
}
