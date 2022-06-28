import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rc_clone/blocs/meet_page_bloc/document_cubit/get_document_cubit.dart';
import 'package:rc_clone/widgets/document_card.dart';
import 'package:rc_clone/widgets/error_widget.dart';
import 'package:rc_clone/widgets/loading_widget.dart';

class DocumentsView extends StatefulWidget {
  final String claimNumber;

  const DocumentsView({Key? key, required this.claimNumber}) : super(key: key);

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> with AutomaticKeepAliveClientMixin<DocumentsView> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<GetDocumentCubit>(
      create: (context) => GetDocumentCubit()..getDocuments(widget.claimNumber),
      child: BlocBuilder<GetDocumentCubit, GetDocumentState>(
        builder: (context, state) {
          if (state is GetDocumentReady) {
            if (state.documents.isEmpty) {
              return const InformationWidget(
                svgImage: 'images/no-data.svg',
                label: "No documents",
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: state.documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => DocumentCard(
                  document: state.documents[index],
                ),
              ),
            );
          } else if (state is GetDocumentFailed) {
            return CustomErrorWidget(
              errorText: "Exception: ${state.cause} (${state.code})",
              action: () {
                BlocProvider.of<GetDocumentCubit>(context).getDocuments(widget.claimNumber);
              },
            );
          } else {
            return const LoadingWidget(
              label: "Fetching documents",
            );
          }
        },
      ),
    );
  }
}
