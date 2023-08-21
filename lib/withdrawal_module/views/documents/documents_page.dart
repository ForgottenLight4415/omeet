import 'package:flutter/material.dart';

import '../../utilities/document_utilities.dart';
import '../../data/models/document.dart';
import '../meet_pages/documents_section.dart';
import '../../widgets/buttons.dart';

class DocumentsPage extends StatelessWidget {
  final String caseId;
  final bool readOnly;
  const DocumentsPage({Key? key, required this.caseId, this.readOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("All documents"),
        actions: readOnly ? null : [
          IconButton(
            onPressed: () => DocumentUtilities.documentUploadDialog(context, caseId, DocumentType.file),
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: DocumentsView(caseId: caseId),
    );
  }
}
