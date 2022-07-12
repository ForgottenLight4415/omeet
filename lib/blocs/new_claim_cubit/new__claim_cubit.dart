import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/data/providers/claim_provider.dart';

part 'new__claim_state.dart';

class NewClaimCubit extends Cubit<NewClaimState> {
  final ClaimProvider _provider = ClaimProvider();
  NewClaimCubit() : super(NewClaimInitial());

  Future<void> createClaim({required Claim claim}) async {
    emit(CreatingClaim());
    try {
      await _provider.createClaim(claim);
      emit(CreatedClaim());
    } on SocketException {
      emit(CreationFailed(500, "Failed to create new claim."));
    } on ServerException catch (a) {
      emit(CreationFailed(a.code, a.cause));
    } on Exception catch (e) {
      emit(CreationFailed(1000, e.toString()));
    }
  }
}
