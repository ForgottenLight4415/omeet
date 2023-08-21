import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/document.dart';
import '../../blocs/meet_page_bloc/document_cubit/get_document_cubit.dart';
import '../../widgets/document_card.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class AudioView extends StatefulWidget {
  final String claimNumber;

  const AudioView({Key? key, required this.claimNumber}) : super(key: key);

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView>
    with AutomaticKeepAliveClientMixin<AudioView> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<GetDocumentCubit>(
      create: (context) => GetDocumentCubit()
        ..getDocuments(widget.claimNumber, DocumentType.audio),
      child: BlocBuilder<GetDocumentCubit, GetDocumentState>(
        builder: (context, state) {
          if (state is GetDocumentReady) {
            if (state.documents.isEmpty) {
              return const InformationWidget(
                svgImage: 'images/no-data.svg',
                label: "No audio recordings",
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: state.documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => DocumentCard(
                  document: state.documents[index],
                  type: DocumentType.audio,
                ),
              ),
            );
          } else if (state is GetDocumentFailed) {
            return CustomErrorWidget(
              errorText: "Exception: ${state.cause} (${state.code})",
              action: () {
                BlocProvider.of<GetDocumentCubit>(context).getDocuments(
                  widget.claimNumber,
                  DocumentType.audio,
                );
              },
            );
          } else {
            return const LoadingWidget(
              label: "Fetching audio recordings",
            );
          }
        },
      ),
    );
  }
}
