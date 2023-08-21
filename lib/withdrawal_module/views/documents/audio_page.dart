import 'package:flutter/material.dart';

import '../../data/models/document.dart';
import '../../utilities/document_utilities.dart';
import '../meet_pages/audio_section.dart';
import '../../widgets/buttons.dart';

class AudioPage extends StatelessWidget {
  final String caseId;
  final bool readOnly;

  const AudioPage({Key? key, required this.caseId, this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("All audio recordings"),
        actions: readOnly ? null : [
          IconButton(
            onPressed: () => DocumentUtilities.documentUploadDialog(context, caseId, DocumentType.audio),
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: AudioView(claimNumber: caseId),
    );
  }
}
