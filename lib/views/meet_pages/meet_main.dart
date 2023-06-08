import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:omeet_motor/views/meet_pages/section_questions.dart';

import '../../data/models/claim.dart';
import '../../widgets/buttons.dart';
import 'section_conclusion.dart';
import 'section_details.dart';
import 'section_documents.dart';
import 'section_meeting.dart';

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
          title: Text("Meeting with ${widget.claim.insuredPerson.insuredName}"),
          bottom: const TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.black,
            labelColor: Colors.red,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.red)
            ),
            tabs: <Widget>[
              Tab(icon: FaIcon(FontAwesomeIcons.video), text: "Meet"),
              Tab(icon: FaIcon(FontAwesomeIcons.question), text: "Q & A"),
              Tab(icon: FaIcon(FontAwesomeIcons.file), text: "Documents"),
              Tab(icon: FaIcon(FontAwesomeIcons.circleCheck), text: "Conclusion"),
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
            SectionDetails(claim: widget.claim),
          ],
        ),
      ),
    );
  }
}
