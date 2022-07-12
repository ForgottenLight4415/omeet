import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rc_clone/data/models/claim.dart';
import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/data/repositories/claim_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'new_claim_state.dart';

class NewClaimCubit extends Cubit<NewClaimState> {
  final ClaimRepository _repository = ClaimRepository();
  NewClaimCubit() : super(NewClaimInitial());

  Future<void> createClaim({required Map<String, dynamic> claimData}) async {
    emit(CreatingClaim());
    try {
      final SharedPreferences _pref = await SharedPreferences.getInstance();
      claimData.putIfAbsent("Manager_Name", () => _pref.getString('email'));
      claimData.putIfAbsent("Surveyor_Name", () => _pref.getString('email'));
      final Claim _claim = Claim.fromJson(claimData);
      log(_claim.toMap().toString());
      await _repository.newClaim(_claim);
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
