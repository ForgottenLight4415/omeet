part of 'new__claim_cubit.dart';

@immutable
abstract class NewClaimState {}

class NewClaimInitial extends NewClaimState {}

class CreatingClaim extends NewClaimState {}

class CreatedClaim extends NewClaimState {}

class CreationFailed extends NewClaimState {
  final int code;
  final String cause;

  CreationFailed(this.code, this.cause);
}
