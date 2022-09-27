import 'package:flutter/material.dart';

import '../../data/models/claim.dart';
import '../../widgets/buttons.dart';
import 'details.dart';

class DetailsPage extends StatelessWidget {
  final Claim claim;
  const DetailsPage({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Claim details'),
      ),
      body: ClaimDetails(claim: claim)
    );
  }
}
