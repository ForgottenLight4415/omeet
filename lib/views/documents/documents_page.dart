import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/data_upload_repo.dart';
import '../../utilities/app_constants.dart';
import '../../utilities/upload_dialog.dart';
import '../meet_pages/documents_section.dart';
import '../../widgets/buttons.dart';
import '../../widgets/snack_bar.dart';

class DocumentsPage extends StatelessWidget {
  final String claimNumber;
  final bool readOnly;
  const DocumentsPage({Key? key, required this.claimNumber, this.readOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("All documents"),
        actions: readOnly ? null : [
          IconButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                File file = File(result.files.single.path!);
                final DataUploadRepository _repository = DataUploadRepository();
                showSnackBar(
                  context,
                  AppStrings.startingUpload,
                  type: SnackBarType.success,
                );
                showProgressDialog(context);
                bool _result = await _repository.uploadData(
                  claimId: claimNumber,
                  latitude: 0,
                  longitude: 0,
                  file: file,
                  isDoc: true,
                );
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.pop(context);
                if (_result) {
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
              }
            },
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: DocumentsView(claimId: claimNumber),
    );
  }
}
