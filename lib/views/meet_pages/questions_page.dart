import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rc_clone/blocs/meet_page_bloc/get_questions_cubit.dart';
import 'package:rc_clone/data/models/question.dart';

class QuestionsPage extends StatefulWidget {
  final String claimNumber;

  const QuestionsPage({Key? key, required this.claimNumber}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage>
    with AutomaticKeepAliveClientMixin<QuestionsPage> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<GetQuestionsCubit>(
      create: (context) =>
          GetQuestionsCubit()..getQuestions(widget.claimNumber),
      child: BlocBuilder<GetQuestionsCubit, GetQuestionsState>(
        builder: (context, state) {
          if (state is GetQuestionsReady) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: state.questions.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return QuestionCard(question: state.questions[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Answer submit functionality
                    },
                    child: const Text("Submit"),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith(
                        (states) => EdgeInsets.symmetric(
                          horizontal: 150.w,
                          vertical: 20.h,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          } else if (state is GetQuestionsFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Exception: ${state.cause} (${state.code})"),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<GetQuestionsCubit>(context)
                          .getQuestions(widget.claimNumber);
                    },
                    child: const Text("RETRY"),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20.0),
                  Text("Fetching details")
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final Question question;

  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Card(
        child: Container(
          margin: EdgeInsets.all(10.w),
          constraints: BoxConstraints(
            minHeight: 130.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.question.question,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(height: 20.h),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20.w,
                runSpacing: 20.h,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.question.setFlag();
                      });
                    },
                    child: Text(widget.question.flag ? "Flagged" : "Flag"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      widget.question.setAnswer(await _showAnswerInputModal(
                        context,
                        widget.question,
                      ));
                    },
                    child: Text(widget.question.getAnswer() == null
                      ? "Answer"
                      : "Edit answer",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      widget.question.setQuestion(await _editQuestionModal(
                        context,
                        widget.question,
                      ),);
                      setState(() {});
                    },
                    child: const Text("Edit question"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> _showAnswerInputModal(
    BuildContext context, Question question) async {
  final TextEditingController _controller =
      TextEditingController(text: question.getAnswer());
  final String? _answer = await showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFEDEADE),
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: 600.h,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Answer question",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  question.question,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 10.h),
                TextField(
                  controller: _controller,
                  maxLines: 10,
                  decoration:
                      const InputDecoration(hintText: "Write an answer"),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _controller.text);
                    },
                    child: const Text("Save"),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
  return _answer;
}

Future<String?> _editQuestionModal(
    BuildContext context, Question question) async {
  final TextEditingController _controller =
  TextEditingController(text: question.question);
  final String? _question = await showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFEDEADE),
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: 600.h,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Edit question",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: _controller,
                  maxLines: 10,
                  decoration:
                  const InputDecoration(hintText: "Write a question"),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        question.resetQuestion();
                        _controller.text = question.question;
                      },
                      child: const Text("Reset"),
                    ),
                    SizedBox(width: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _controller.text);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
  return _question;
}