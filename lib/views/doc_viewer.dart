import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

import '../blocs/meet_page_bloc/document_cubit/view_document_cubit.dart';
import '../widgets/loading_widget.dart';

import '../widgets/buttons.dart';
import '../widgets/error_widget.dart';

class DocumentViewPage extends StatefulWidget {
  final String documentUrl;

  const DocumentViewPage({Key? key, required this.documentUrl}) : super(key: key);

  @override
  State<DocumentViewPage> createState() => _DocumentViewPageState();
}

class _DocumentViewPageState extends State<DocumentViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  VideoPlayerController? _videoController;

  ViewDocumentCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ViewDocumentCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("Document viewer"),
        actions: <Widget>[
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
                  } else if (state.docType == DocType.video) {
                    if (_videoController == null) {
                      initVideo(state.docUrl);
                    }
                  }
                  return const SizedBox();
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      body: BlocProvider<ViewDocumentCubit>.value(
        value: _cubit!..viewDocument(widget.documentUrl),
        child: BlocBuilder<ViewDocumentCubit, ViewDocumentState>(
          builder: (context, state) {
            if (state is ViewDocumentReady) {
              if (state.docType == DocType.pdf) {
                return SfPdfViewer.network(
                  state.docUrl,
                  key: _pdfViewerKey,
                );
              } else if (state.docType == DocType.image) {
                return Center(child: Image.network(state.docUrl));
              } else {
                return Center(
                  child: _videoController != null && _videoController!.value.isInitialized
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _videoController!.value.isPlaying
                                ? _videoController!.pause()
                                : _videoController!.play();
                          });
                        },
                        child: const Icon(Icons.play_arrow),
                      )
                    ],
                  )
                      : const CircularProgressIndicator(),
                );
              }
            } else if (state is ViewDocumentFailed) {
              return CustomErrorWidget(
                errorText: state.cause + "\n(Error code: ${state.code})",
                action: () {
                  BlocProvider.of<ViewDocumentCubit>(context).viewDocument(widget.documentUrl);
                },
              );
            } else {
              return const LoadingWidget(
                label: "Fetching document",
              );
            }
          },
        ),
      ),
    );
  }

  void initVideo(String source) {
    _videoController = VideoPlayerController.network(source)
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    if (_cubit != null) {
      _cubit!.close();
    }
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }
}
