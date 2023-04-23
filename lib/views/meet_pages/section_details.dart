import 'package:flutter/material.dart';

import '../../data/models/claim.dart';
import '../../widgets/claim_details.dart';

class SectionDetails extends StatefulWidget {
  final Claim claim;
  const SectionDetails({Key? key, required this.claim}) : super(key: key);

  @override
  State<SectionDetails> createState() => _SectionDetailsState();
}

class _SectionDetailsState extends State<SectionDetails> with AutomaticKeepAliveClientMixin<SectionDetails> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClaimDetails(claim: widget.claim);
  }
}
