import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/uploads_bloc/pending_uploads_cubit.dart';
import '../data/repositories/data_upload_repo.dart';
import '../widgets/buttons.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class UploadsPage extends StatefulWidget {
  const UploadsPage({Key? key}) : super(key: key);

  @override
  State<UploadsPage> createState() => _UploadsPageState();
}

class _UploadsPageState extends State<UploadsPage> {
  PendingUploadsCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PendingUploadsCubit();
  }

  @override
  void dispose() {
    _cubit!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text("Pending uploads"),
      ),
      floatingActionButton: BlocProvider<PendingUploadsCubit>.value(
        value: _cubit!,
        child: BlocBuilder<PendingUploadsCubit, PendingUploadsState>(
            builder: (context, state) {
          if (state is FetchedPendingUploads && state.uploads.isNotEmpty) {
            return FloatingActionButton(
              child: const Center(
                child: Icon(Icons.upload),
              ),
              onPressed: () async {
                _showLoading(context);
                for (var value in state.uploads) {
                  await DataUploadRepository().uploadData(
                    claimNumber: value.claimNo,
                    latitude: value.latitude,
                    longitude: value.longitude,
                    file: File(value.file),
                  );
                }
                Navigator.pop(context);
                BlocProvider.of<PendingUploadsCubit>(context)
                    .getPendingUploads();
              },
            );
          }
          return const SizedBox();
        }),
      ),
      body: BlocProvider<PendingUploadsCubit>.value(
        value: _cubit!..getPendingUploads(),
        child: BlocBuilder<PendingUploadsCubit, PendingUploadsState>(
            builder: (context, state) {
          if (state is FetchedPendingUploads) {
            if (state.uploads.isEmpty) {
              return const InformationWidget(
                svgImage: 'images/no-data.svg',
                label: 'No pending uploads.',
              );
            }
            return ListView.builder(
              itemCount: state.uploads.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.uploads[index].claimNo),
                  subtitle: Text(state.uploads[index].time.toIso8601String()),
                  isThreeLine: true,
                );
              },
            );
          } else if (state is FailedPendingUploads) {
            return CustomErrorWidget(
              errorText: state.cause,
              action: () {
                BlocProvider.of<PendingUploadsCubit>(context)
                    .getPendingUploads();
              },
            );
          }
          return const LoadingWidget(label: "Checking");
        }),
      ),
    );
  }

  void _showLoading(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          title: const Text("Uploading files"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const <Widget>[
              CircularProgressIndicator(),
              Text("Uploading"),
            ],
          ),
        ),
      ),
    );
  }
}
