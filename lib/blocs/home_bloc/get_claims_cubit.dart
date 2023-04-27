import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../data/models/audit.dart';
import '../../data/models/claim.dart';
import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/claim_repo.dart';
import '../../utilities/check_connection.dart';

part 'get_claims_state.dart';

class GetClaimsCubit extends Cubit<GetClaimsState> {
  final ClaimRepository _homeRepository = ClaimRepository();
  GetClaimsCubit() : super(GetClaimsInitial());

  Future<void> getClaims(BuildContext context) async {
    if (!await checkConnection(context)) {
      emit(GetClaimsFailed(1000, "No internet connection"));
      return;
    }
    emit(GetClaimsLoading());
    try {
      emit(
        GetClaimsSuccess(
          await _homeRepository.getClaims(),
        ),
      );
    } on SocketException {
      emit(GetClaimsFailed(1000, "Failed to connect the server."));
    } on AppException catch (a) {
      emit(GetClaimsFailed(a.code, a.cause));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }

  Future<void> getHospitalClaims(BuildContext context, String hospitalId) async {
    if (!await checkConnection(context)) {
      emit(GetClaimsFailed(1000, "No internet connection"));
      return;
    }
    emit(GetClaimsLoading());
    try {
      emit(
        GetHospitalClaimsSuccess(
          await _homeRepository.getHospitalClaims(hospitalId),
        ),
      );
    } on SocketException {
      emit(GetClaimsFailed(1000, "Failed to connect the server."));
    } on AppException catch (a) {
      emit(GetClaimsFailed(a.code, a.cause));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }

  void searchClaims(String? searchQuery) {
    List<Audit> _claims = _homeRepository.getClaimList();
    if (searchQuery == null || searchQuery.isEmpty) {
      emit(GetClaimsSuccess(_claims));
      return;
    }
    try {
      List<Audit> _result = [];
      String _searchQuery = searchQuery.trim().toLowerCase();
      for (var claim in _claims) {
        String hospitalId = claim.hospital.id.toLowerCase();
        String hospitalName = claim.hospital.name.toLowerCase();
        if (hospitalId.contains(_searchQuery)
            || hospitalName.contains(_searchQuery)) {
          _result.add(claim);
        }
      }
      emit(GetClaimsSuccess(_result));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }
}
