import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/withdrawal.dart';
import '../../widgets/buttons.dart';
import 'details_section.dart';
import 'documents_section.dart';
import 'meet_section.dart';
import 'questions_section.dart';

class MeetingMainPage extends StatefulWidget {
  final Withdrawal claim;

  const MeetingMainPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<MeetingMainPage> createState() => _MeetingMainPageState();
}

class _MeetingMainPageState extends State<MeetingMainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          centerTitle: true,
          title: Text(
            "Meeting with ${widget.claim.insured}",
            overflow: TextOverflow.fade,
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.black),
            ),
            isScrollable: true,
            tabs: <Widget>[
              Tab(icon: FaIcon(FontAwesomeIcons.video), text: "Meet"),
              Tab(icon: FaIcon(FontAwesomeIcons.question), text: "Q & A"),
              Tab(icon: FaIcon(FontAwesomeIcons.file), text: "Documents"),
              // Tab(icon: FaIcon(FontAwesomeIcons.circleCheck), text: "Conclusion"),
              Tab(icon: FaIcon(FontAwesomeIcons.info), text: "Details"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VideoMeetPage(claim: widget.claim),
            QuestionsPage(claimId: widget.claim.claimId),
            DocumentsView(caseId: widget.claim.claimId),
            // ConclusionPage(claim: widget.claim),
            MeetDetails(claim: widget.claim),
          ],
        ),
      ),
    );
  }
}
