import 'package:flutter/material.dart';

import '../../data/models/withdrawal.dart';
import '../../widgets/buttons.dart';
import 'details.dart';

class DetailsPage extends StatelessWidget {
  final Withdrawal claim;
  const DetailsPage({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Case details'),
      ),
      body: ClaimDetails(claim: claim)
    );
  }
}
