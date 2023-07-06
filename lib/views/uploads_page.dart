import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omeet_motor/data/databases/database.dart';

import '../blocs/uploads_bloc/pending_uploads_cubit.dart';
import '../data/repositories/data_upload_repo.dart';
import '../utilities/app_constants.dart';
import '../utilities/show_snackbars.dart';
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
              onPressed: () => _uploadButton(context, state),
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
                svgImage: 'images/upload_files.svg',
                label: "Nothing to upload",
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
        child: const AlertDialog(
          title: Text("Uploading files"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircularProgressIndicator(),
              Text("Uploading"),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadButton(BuildContext context, FetchedPendingUploads state) async {
    _showLoading(context);
    int i = 0;
    for (UploadObject object in state.uploads) {
      try {
        final File file = File(object.file);
        bool result = await DataUploadRepository().uploadData(
          claimId: object.claimNo,
          latitude: object.latitude,
          longitude: object.longitude,
          file: file,
          uploadNow: true,
        );
        if (result) {
          i++;
          if (!object.directUpload) {
            file.delete();
          }
        } else {
          throw Exception("An unknown error occurred while uploading the file.");
        }
      } on Exception catch (e) {
        showInfoSnackBar(
          context,
          AppStrings.fileUploadFailed + "(${e.toString()})",
          color: Colors.red,
        );
        break;
      }
    }
    showInfoSnackBar(
      context,
      AppStrings.fileUploaded + "($i/${state.uploads.length})",
      color: Colors.green,
    );
    Navigator.pop(context);
    BlocProvider.of<PendingUploadsCubit>(context).getPendingUploads();
  }
}
