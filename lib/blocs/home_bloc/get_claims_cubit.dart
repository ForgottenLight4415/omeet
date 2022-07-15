import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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
      emit(GetClaimsSuccess(await _homeRepository.getClaims()));
    } on SocketException {
      emit(GetClaimsFailed(1000, "Failed to connect the server."));
    } on ServerException catch (a) {
      emit(GetClaimsFailed(a.code, a.cause));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }

  Future<void> searchClaims(String? searchQuery) async {
    List<Claim> _claims = await _homeRepository.getClaims();
    if (searchQuery == null || searchQuery.isEmpty) {
      emit(GetClaimsSuccess(_claims));
      return;
    }
    try {
      List<Claim> _result = [];
      String _searchQuery = searchQuery.trim().toLowerCase();
      for (var claim in _claims) {
        if (claim.claimNumber.toString().toLowerCase().contains(_searchQuery)) {
          _result.add(claim);
        }
      }
      emit(GetClaimsSuccess(_result));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }
}
