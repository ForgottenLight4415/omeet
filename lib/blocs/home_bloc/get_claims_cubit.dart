import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:omeet_motor/data/providers/claim_provider.dart';

import '../../data/models/claim.dart';
import '../../data/providers/app_server_provider.dart';
import '../../data/repositories/claim_repo.dart';
import '../../utilities/check_connection.dart';

part 'get_claims_state.dart';

class GetClaimsCubit extends Cubit<GetClaimsState> {
  final ClaimType claimType;
  final ClaimRepository _homeRepository = ClaimRepository();

  String _state = "ALL";
  String _district = "ALL";
  String _policeStation = "ALL";

  GetClaimsCubit({this.claimType = ClaimType.allocated}) : super(GetClaimsInitial());

  void setStateName(String stateName) {
    _state = stateName;
  }

  void setDistrictName(String districtName) {
    _district = districtName;
  }

  void setPoliceStationName(String policeStationName) {
    _policeStation = policeStationName;
  }

  Future<void> getClaims(BuildContext context) async {
    if (!await checkConnection(context)) {
      emit(GetClaimsFailed(1000, "No internet connection"));
      return;
    }
    emit(GetClaimsLoading());
    try {
      emit(
        GetClaimsSuccess(
          await _homeRepository.getClaims(
            claimType: claimType,
            state: _state,
            district: _district,
            policeStation: _policeStation,
          ),
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
    List<Claim> _claims = _homeRepository.getClaimList();
    if (searchQuery == null || searchQuery.isEmpty) {
      emit(GetClaimsSuccess(_claims));
      return;
    }
    try {
      List<Claim> _result = [];
      String _searchQuery = searchQuery.trim().toLowerCase();
      for (var claim in _claims) {
        String insuredName = claim.insuredName.toLowerCase();
        String phoneNumber = claim.customerMobileNumber;
        String caseId = claim.claimId.toLowerCase();
        String vehicleNumber = claim.accused.toLowerCase();
        String victimVehicleNumberA = claim.victim1.toLowerCase();
        String victimVehicleNumberB = claim.victim2.toLowerCase();
        String firNumber = claim.firNumber.toLowerCase();
        String district = claim.district.toLowerCase();
        String policeStation = claim.policeStation.toLowerCase();
        if (insuredName.contains(_searchQuery) ||
            phoneNumber.contains(_searchQuery) ||
            firNumber.contains(_searchQuery) ||
            vehicleNumber.contains(_searchQuery) ||
            victimVehicleNumberA.contains(_searchQuery) ||
            victimVehicleNumberB.contains(_searchQuery) ||
            district.contains(_searchQuery) ||
            policeStation.contains(_searchQuery) ||
            caseId.contains(_searchQuery)) {
          _result.add(claim);
        }
      }
      emit(GetClaimsSuccess(_result));
    } catch (e) {
      emit(GetClaimsFailed(2000, e.toString()));
    }
  }
}
