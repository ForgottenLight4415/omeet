import 'package:flutter/material.dart';
import '../views/meet_pages/conclusion_page.dart';
import '../widgets/buttons.dart';

import '../data/models/withdrawal.dart';

class ConclusionPageMain extends StatefulWidget {
  final Withdrawal claim;
  const ConclusionPageMain({Key? key, required this.claim}) : super(key: key);

  @override
  State<ConclusionPageMain> createState() => _ConclusionPageMainState();
}

class _ConclusionPageMainState extends State<ConclusionPageMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("Final Conclusion"),
      ),
      body: ConclusionPage(claim: widget.claim),
    );
  }
}
