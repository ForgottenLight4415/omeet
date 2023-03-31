import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/meet_page_bloc/questions_bloc/questions_bloc.dart';
import '../../blocs/meet_page_bloc/submit_question_cubit/submit_question_cubit.dart';
import '../../utilities/show_snackbars.dart';
import '../../widgets/question_card.dart';

class QuestionsPage extends StatefulWidget {
  final String claimNumber;

  const QuestionsPage({Key? key, required this.claimNumber}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> with AutomaticKeepAliveClientMixin<QuestionsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollDown() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<QuestionsBloc>(
      create: (context) => QuestionsBloc()..add(GetQuestionsEvent(claimNumber: widget.claimNumber)),
      child: BlocConsumer<QuestionsBloc, QuestionsState>(
        listener: (context, state) {
          if (state is QuestionsReady) {
            if (state.isModified) {
              _scrollDown();
            }
          }
        },
        builder: (context, state) {
          if (state is QuestionsReady) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      itemCount: state.questions.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return QuestionCard(question: state.questions[index]);
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            BlocProvider.of<QuestionsBloc>(context).add(
                              AddQuestionEvent(
                                question: await _addQuestionModal(context),
                              ),
                            );
                          },
                          child: const Text("Add question"),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.resolveWith(
                              (states) => EdgeInsets.symmetric(
                                vertical: 20.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocProvider<SubmitQuestionCubit>(
                          create: (context) => SubmitQuestionCubit(),
                          child: BlocConsumer<SubmitQuestionCubit, SubmitQuestionState>(
                            listener: (context, submitState) {
                              if (submitState is SubmitQuestionReady) {
                                showInfoSnackBar(context, "Answers submitted successfully.", color: Colors.green);
                              } else if (submitState is SubmitQuestionFailed) {
                                showInfoSnackBar(context, "Failed to submit answers. (${submitState.cause})", color: Colors.red);
                              }
                            },
                            builder: (context, submitState) {
                              return ElevatedButton(
                                onPressed: submitState is SubmitQuestionLoading
                                    ? null
                                    : () {
                                        BlocProvider.of<SubmitQuestionCubit>(context).submitQuestion(
                                          widget.claimNumber,
                                          state.questions,
                                        );
                                      },
                                child: const Text("Submit"),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.resolveWith(
                                    (states) => EdgeInsets.symmetric(
                                      vertical: 20.h,
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.resolveWith(
                                      (states) => submitState is SubmitQuestionLoading ? Colors.grey : Theme.of(context).primaryColor),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          } else if (state is QuestionsLoadingFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Exception: ${state.cause} (${state.code})"),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<QuestionsBloc>(context).add(
                        GetQuestionsEvent(claimNumber: widget.claimNumber),
                      );
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
                children: const <Widget>[CircularProgressIndicator(), SizedBox(height: 20.0), Text("Fetching details")],
              ),
            );
          }
        },
      ),
    );
  }
}

Future<String?> _addQuestionModal(BuildContext context) async {
  final TextEditingController _controller = TextEditingController();
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
                    "Add question",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: _controller,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Write a question",
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    SizedBox(width: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        _controller.text = "";
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
