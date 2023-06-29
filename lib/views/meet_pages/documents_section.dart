import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omeet_motor/data/models/document.dart';

import '../../blocs/meet_page_bloc/document_cubit/get_document_cubit.dart';
import '../../widgets/document_card.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class DocumentsView extends StatefulWidget {
  final String claimId;

  const DocumentsView({Key? key, required this.claimId}) : super(key: key);

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView>
    with AutomaticKeepAliveClientMixin<DocumentsView> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<GetDocumentCubit>(
      create: (context) => GetDocumentCubit()
        ..getDocuments(
          widget.claimId,
          DocumentType.file,
        ),
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
                  type: DocumentType.file,
                ),
              ),
            );
          } else if (state is GetDocumentFailed) {
            return CustomErrorWidget(
              errorText: "Exception: ${state.cause} (${state.code})",
              action: () {
                BlocProvider.of<GetDocumentCubit>(context)
                    .getDocuments(widget.claimId, DocumentType.file);
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
