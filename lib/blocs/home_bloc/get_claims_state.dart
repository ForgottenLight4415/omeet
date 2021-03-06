part of 'get_claims_cubit.dart';

@immutable
abstract class GetClaimsState {}

class GetClaimsInitial extends GetClaimsState {}

class GetClaimsLoading extends GetClaimsState {}

class GetClaimsSuccess extends GetClaimsState {
  final List<Claim> claims;

  GetClaimsSuccess(this.claims);
}

class GetClaimsFailed extends GetClaimsState {
  final int code;
  final String cause;

  GetClaimsFailed(this.code, this.cause);
}
