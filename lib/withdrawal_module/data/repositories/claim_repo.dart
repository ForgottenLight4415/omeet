import 'package:omeet_motor/withdrawal_module/data/models/withdrawal.dart';

import '../providers/claim_provider.dart';

class ClaimRepository {
  List<Withdrawal> _claims = [];
  final ClaimProvider _provider = ClaimProvider();

  Future<List<Withdrawal>> getClaims({
    ClaimType claimType = ClaimType.allocated,
    String state = "",
    String district = "",
    String policeStation = "",
  }) async {
    _claims = await _provider.getClaims(
      state: state,
      district: district,
      policeStation: policeStation,
      claimType: claimType
    );
    return _claims;
  }

  Future<bool> assignToSelf(Map<String, String> payload) async {
    return await _provider.assignToSelf(payload);
  }

  List<Withdrawal> getClaimList() {
    return _claims;
  }
}
