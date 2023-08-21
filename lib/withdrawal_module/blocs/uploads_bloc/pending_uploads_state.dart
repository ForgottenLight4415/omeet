part of 'pending_uploads_cubit.dart';

@immutable
abstract class PendingUploadsState {}

class PendingUploadsInitial extends PendingUploadsState {}

class FetchingPendingUploads extends PendingUploadsState {}

class FetchedPendingUploads extends PendingUploadsState {
  final List<UploadObject> uploads;

  FetchedPendingUploads(this.uploads);
}

class FailedPendingUploads extends PendingUploadsState {
  final int code;
  final String cause;

  FailedPendingUploads(this.code, this.cause);
}
