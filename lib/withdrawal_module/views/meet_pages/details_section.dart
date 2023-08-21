import 'package:flutter/material.dart';
import '../../data/models/withdrawal.dart';

import './details.dart';

class MeetDetails extends StatefulWidget {
  final Withdrawal claim;
  const MeetDetails({Key? key, required this.claim}) : super(key: key);

  @override
  State<MeetDetails> createState() => _MeetDetailsState();
}

class _MeetDetailsState extends State<MeetDetails> with AutomaticKeepAliveClientMixin<MeetDetails> {
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
