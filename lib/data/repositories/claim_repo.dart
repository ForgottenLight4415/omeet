import '../models/claim.dart';
import '../providers/claim_provider.dart';

class ClaimRepository {
  List<Claim> _claims = [];
  final ClaimProvider _provider = ClaimProvider();

  Future<List<Claim>> getClaims({bool department = false}) async {
    _claims = await _provider.getClaims(department: department);
    return _claims;
  }

  Future<bool> assignToSelf(String claimNumber, String surveyor) async {
    return await _provider.assignToSelf(claimNumber, surveyor);
  }

  List<Claim> getClaimList() {
    return _claims;
  }

  Future<bool> newClaim(Claim claim) => _provider.createClaim(claim);
}
