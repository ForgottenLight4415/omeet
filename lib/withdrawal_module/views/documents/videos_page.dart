import 'package:flutter/material.dart';
import 'package:omeet_motor/views/meet_pages/videos_section.dart';

import '../../data/models/document.dart';
import '../../utilities/document_utilities.dart';
import '../../widgets/buttons.dart';

class VideosPage extends StatelessWidget {
  final String caseId;
  final bool readOnly;

  const VideosPage({Key? key, required this.caseId, this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("All videos"),
        actions: readOnly ? null : [
          IconButton(
            onPressed: () => DocumentUtilities.documentUploadDialog(context, caseId, DocumentType.video),
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: VideosView(claimNumber: caseId),
    );
  }
}
