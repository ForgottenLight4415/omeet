import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../blocs/meet_page_bloc/document_cubit/view_document_cubit.dart';
import '../../data/models/document.dart';
import '../../widgets/loading_widget.dart';

import '../../widgets/buttons.dart';
import '../../widgets/error_widget.dart';

class DocumentViewPageArguments {
  final String documentUrl;
  final DocumentType type;

  const DocumentViewPageArguments(this.documentUrl, this.type);
}

class DocumentViewPage extends StatefulWidget {
  final String documentUrl;
  final DocumentType type;

  const DocumentViewPage(
      {Key? key, required this.documentUrl, required this.type})
      : super(key: key);

  @override
  State<DocumentViewPage> createState() => _DocumentViewPageState();
}

class _DocumentViewPageState extends State<DocumentViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ViewDocumentCubit? _cubit;

  String pageTitle = "";

  @override
  void initState() {
    super.initState();
    log("Opening document: ${widget.documentUrl}");
    switch (widget.type) {
      case DocumentType.file:
        pageTitle = "PDF viewer";
        _cubit = ViewDocumentCubit();
        break;
      case DocumentType.audio:
        // TODO: Handle this case.
        break;
      case DocumentType.video:
        // TODO: Handle this case.
        break;
      case DocumentType.image:
        pageTitle = "Image viewer";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(pageTitle),
        actions: widget.type == DocumentType.file
            ? <Widget>[
                BlocProvider<ViewDocumentCubit>.value(
                  value: _cubit!,
                  child: BlocBuilder<ViewDocumentCubit, ViewDocumentState>(
                    builder: (context, state) {
                      if (state is ViewDocumentReady) {
                        if (state.docType == DocType.pdf) {
                          return IconButton(
                            icon: const Icon(
                              Icons.bookmark,
                              color: Colors.white,
                              semanticLabel: 'Bookmark',
                            ),
                            onPressed: () {
                              _pdfViewerKey.currentState?.openBookmarkView();
                            },
                          );
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ]
            : null,
      ),
      body: BlocProvider<ViewDocumentCubit>.value(
              value: _cubit!..viewDocument(widget.documentUrl),
              child: BlocBuilder<ViewDocumentCubit, ViewDocumentState>(
                builder: (context, state) {
                  if (state is ViewDocumentReady) {
                    log("Actual: ${state.docUrl}");
                    if (state.docType == DocType.pdf) {
                      return SfPdfViewer.network(
                        state.docUrl,
                        key: _pdfViewerKey,
                      );
                    } else if (state.docType == DocType.image) {
                      return Center(
                        child: Image.network(
                            state.docUrl,
                            errorBuilder: (context, object, stack) {
                              return const InformationWidget(svgImage: "images/no-data.svg", label: "Image unavailable");
                            },
                        ),
                      );
                    }
                    return const SizedBox();
                  } else if (state is ViewDocumentFailed) {
                    return CustomErrorWidget(
                      errorText: state.cause + "\n(Error code: ${state.code})",
                      action: () {
                        BlocProvider.of<ViewDocumentCubit>(context)
                            .viewDocument(widget.documentUrl);
                      },
                    );
                  } else {
                    return const LoadingWidget(
                      label: "Fetching document",
                    );
                  }
                },
              ),
            )
    );
  }

  @override
  void dispose() {
    if (_cubit != null) {
      _cubit!.close();
    }
    super.dispose();
  }
}
