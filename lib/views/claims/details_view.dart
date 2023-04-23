import 'package:flutter/material.dart';

import '../../data/models/audit.dart';
import '../../widgets/buttons.dart';
import '../../widgets/claim_details.dart';

class DetailsView extends StatelessWidget {
  final Audit claim;
  const DetailsView({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text('Details: ${claim.hospital.id}'),
      ),
      body: ClaimDetails(claim: claim)
    );
  }
}
