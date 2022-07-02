import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/views/meet_pages/details_section.dart';
import 'package:rc_clone/views/meet_pages/documents_section.dart';
import 'package:rc_clone/views/meet_pages/questions_section.dart';
import 'package:rc_clone/views/meet_pages/meet_section.dart';
import 'package:rc_clone/widgets/buttons.dart';

import 'conclusion_page.dart';

class MeetingMainPage extends StatefulWidget {
  final Claim claim;

  const MeetingMainPage({Key? key, required this.claim}) : super(key: key);

  @override
  State<MeetingMainPage> createState() => _MeetingMainPageState();
}

class _MeetingMainPageState extends State<MeetingMainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          centerTitle: true,
          title: Text("Meeting with ${widget.claim.insuredName}"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(icon: FaIcon(FontAwesomeIcons.video), text: "Meet"),
              Tab(icon: FaIcon(FontAwesomeIcons.question), text: "Q & A"),
              Tab(icon: FaIcon(FontAwesomeIcons.file), text: "Documents"),
              Tab(icon: FaIcon(FontAwesomeIcons.checkCircle), text: "Conclusion"),
              Tab(icon: FaIcon(FontAwesomeIcons.info), text: "Details"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VideoMeetPage(claim: widget.claim),
            QuestionsPage(claimNumber: widget.claim.claimNumber),
            DocumentsView(claimNumber: widget.claim.claimNumber),
            ConclusionPage(claim: widget.claim),
            MeetDetails(claim: widget.claim),
          ],
        ),
      ),
    );
  }
}
