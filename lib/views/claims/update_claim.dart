import 'package:flutter/material.dart';

import '../../views/meeting_views/section_conclusion.dart';
import '../../widgets/buttons.dart';

class UpdateClaim extends StatefulWidget {
  final String hospitalId;

  const UpdateClaim({Key? key, required this.hospitalId}) : super(key: key);

  @override
  State<UpdateClaim> createState() => _UpdateClaimState();
}

class _UpdateClaimState extends State<UpdateClaim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("Update"),
      ),
      body: ConclusionPage(claimNumber: widget.hospitalId),
    );
  }
}
