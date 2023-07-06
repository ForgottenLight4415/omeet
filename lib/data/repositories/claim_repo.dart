import '../models/claim.dart';
import '../providers/claim_provider.dart';

class ClaimRepository {
  List<Claim> _claims = [];
  final ClaimProvider _provider = ClaimProvider();

  Future<List<Claim>> getClaims({bool forSelfAssignment = false, bool rejected = false}) async {
    _claims = await _provider.getClaims(forSelfAssignment: forSelfAssignment, rejected: rejected);
    return _claims;
  }

  Future<bool> assignToSelf(Map<String, String> payload) async {
    return await _provider.assignToSelf(payload);
  }

  List<Claim> getClaimList() {
    return _claims;
  }

  Future<bool> newClaim(Claim claim) => _provider.createClaim(claim);
}
