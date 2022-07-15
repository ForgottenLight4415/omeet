import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/meet_page_bloc/modify_question_bloc/modify_question_bloc.dart';
import '../data/models/question.dart';

class QuestionCard extends StatefulWidget {
  final Question question;

  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                textStyle: MaterialStateProperty.resolveWith(
                  (states) => TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
                padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 20.w,
                  ),
                ),
              ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(14.r),
            ),
            constraints: BoxConstraints(
              minHeight: 130.h,
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: BlocProvider<ModifyQuestionBloc>(
                create: (context) => ModifyQuestionBloc(question: widget.question),
                child: BlocBuilder<ModifyQuestionBloc, ModifyQuestionState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.question.question,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black87),
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
                                BlocProvider.of<ModifyQuestionBloc>(context).add(ToggleFlag());
                              },
                              child: Text(
                                state.question.flag ? "Flagged" : "Flag",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                BlocProvider.of<ModifyQuestionBloc>(context).add(
                                  AnswerQuestion(
                                    answer: await _showAnswerInputModal(
                                      context,
                                      state.question,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                state.question.getAnswer() == null ? "Answer" : "Edit answer",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                BlocProvider.of<ModifyQuestionBloc>(context).add(
                                  ModifyQuestion(
                                    question: await _editQuestionModal(
                                      context,
                                      state.question,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Edit question"),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _showAnswerInputModal(BuildContext context, Question question) async {
    final TextEditingController _controller = TextEditingController(text: question.getAnswer());
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
            padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 10.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Question",
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
                    decoration: const InputDecoration(hintText: "Write an answer"),
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

  Future<String?> _editQuestionModal(BuildContext context, Question question) async {
    final TextEditingController _controller = TextEditingController(text: question.question);
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
            padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 10.h),
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
                    decoration: const InputDecoration(hintText: "Write a question"),
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
}
