import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:omeet_motor/data/models/document.dart';
import 'package:omeet_motor/data/providers/app_server_provider.dart';
import 'package:omeet_motor/widgets/input_fields.dart';
import 'package:omeet_motor/widgets/snack_bar.dart';

import '../data/providers/claim_provider.dart';
import '../data/repositories/data_upload_repo.dart';
import '../utilities/app_constants.dart';
import '../utilities/document_utilities.dart';
import '../utilities/location_service.dart';
import '../utilities/show_snackbars.dart';
import '../utilities/upload_dialog.dart';

class UploadDocumentsDialog extends StatefulWidget {
  final File? recFile;
  final String caseId;
  final DocumentType type;
  final bool noFileReporting;

  const UploadDocumentsDialog(
      {Key? key,
      required this.caseId,
      required this.type,
      this.recFile,
      this.noFileReporting = false})
      : super(key: key);

  @override
  State<UploadDocumentsDialog> createState() => _UploadDocumentsDialogState();
}

class _UploadDocumentsDialogState extends State<UploadDocumentsDialog> {
  String selected = "";
  final List<String> documentOptions = <String>[
    "Adhar Card IV",
    "Adhar Card IV Driver",
    "Adhar Card TP",
    "Adhar Card TP Driver",
    "Age Proof Claimant",
    "Age Proof Of Injured",
    "All Medicine Bills",
    "Arrest Memo",
    "Charge Sheet Final Report",
    "Death Certificate",
    "Disability Certificate",
    "Discharge Card",
    "DL Copy Of IV DrIVer",
    "DL Of TP Driver",
    "Email",
    "Email Revert",
    "Extract Of FC Of IV",
    "Extract Of RC Of IV",
    "FIR Copy",
    "GD Entry",
    "Income Proof Of Deceased",
    "Inquest Panchanama",
    "Insured Driver Statement",
    "Insured Statement",
    "Ins TP Driver Statement",
    "Insured TP Statement",
    "Legal Heirs Certificate",
    "Medical Hospital Bills",
    "Motor Vehi Inspection",
    "News Paper Cuttings",
    "Permit Copy Extract Of IV",
    "Policy Copy",
    "Post Mortem Report",
    "RC Copy Of IV Driver",
    "RC Copy Of TP Driver",
    "RTO Extract Verification",
    "Seizure Memo",
    "Spot Photo Panchanama",
    "Statements Of Witnesses",
    "Summary A",
    "Vard Janva Jog Entry",
    "Other",
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

  final List<String> videoOptions = <String>[
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

  final List<String> audioOptions = <String>[
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

  File? file;
  late List<String> options;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    if (widget.recFile != null) {
      file = widget.recFile;
    }
    if (widget.type == DocumentType.file || widget.type == DocumentType.image) {
      selected = documentOptions[0];
      options = documentOptions;
    } else if (widget.type == DocumentType.video) {
      selected = videoOptions[0];
      options = videoOptions;
    } else {
      selected = audioOptions[0];
      options = audioOptions;
    }
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        16.0,
        16.0,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
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
                      selected = conclusion ?? documentOptions[0];
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          CustomTextFormField(
            textEditingController: _descriptionController,
            label: "Description",
            hintText: "Describe this file",
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !widget.noFileReporting && widget.recFile == null
                  ? Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectFile(),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.upload),
                            SizedBox(width: 8.0),
                            Text("Select file"),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 16.0),
          file != null ? Text(file!.path.split("/").last) : const SizedBox(),
          file != null ? const SizedBox(height: 16.0) : const SizedBox(),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                !widget.noFileReporting
                    ? ElevatedButton(
                        onPressed: () async {
                          await _uploadDocuments(context, uploadNow: false);
                          Navigator.pop(context);
                        },
                        child: const Text("Upload later"),
                      )
                    : const SizedBox(),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await _uploadDocuments(context);
                    Navigator.pop(context);
                  },
                  child: Text(!widget.noFileReporting ? "Upload" : "Submit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectFile() async {
    List<String> allowedFileTypes = DocumentUtilities.allowedFileExtensions;
    if (widget.type == DocumentType.file || widget.type == DocumentType.image) {
      allowedFileTypes = DocumentUtilities.allowedFileExtensions;
    } else if (widget.type == DocumentType.video) {
      allowedFileTypes = DocumentUtilities.allowedVideoExtensions;
    } else {
      allowedFileTypes = DocumentUtilities.allowedAudioExtensions;
    }
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: allowedFileTypes);
    if (result != null) {
      String filePath = result.files.single.path!;
      final String fileExtension = filePath.split(".").last;
      if (allowedFileTypes.contains(fileExtension)) {
        setState(() {
          file = File(filePath);
        });
      } else {
        showSnackBar(
          context,
          AppStrings.unsupportedFile,
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _uploadDocuments(BuildContext context,
      {bool uploadNow = true}) async {
    if (file != null) {
      final DataUploadRepository repository = DataUploadRepository();
      final LocationService locationService = LocationService();
      final LocationData location = await locationService.getLocation(context);
      showProgressDialog(context);
      bool result = await repository.uploadData(
          claimId: widget.caseId,
          latitude: location.latitude ?? 0,
          longitude: location.longitude ?? 0,
          file: file!,
          uploadNow: uploadNow,
          directUpload: true,
          extraParams: {
            "document_type": selected,
            "document_description": _descriptionController.text,
          });
      Navigator.pop(context);
      if (result) {
        showSnackBar(
          context,
          AppStrings.fileUploaded,
          type: SnackBarType.success,
        );
      } else {
        showSnackBar(
          context,
          AppStrings.fileUploadFailed,
          type: SnackBarType.error,
        );
      }
    } else if (widget.noFileReporting) {
      final ClaimProvider _provider = ClaimProvider();
      try {
        showProgressDialog(context,
            label: "Submitting", content: "Please wait");
        final result = await _provider.submitReporting(
          widget.caseId,
          selected,
          _descriptionController.text,
        );
        Navigator.pop(context);
        if (result) {
          showInfoSnackBar(context, "Submitted", color: Colors.green);
        } else {
          showInfoSnackBar(context, "Failed to submit conclusion",
              color: Colors.red);
        }
      } on AppException {
        Navigator.pop(context);
        showInfoSnackBar(context, "Something went wrong", color: Colors.red);
      }
    } else {
      Navigator.pop(context);
      showSnackBar(
        context,
        AppStrings.noFileSelected,
        type: SnackBarType.error,
      );
    }
  }
}
