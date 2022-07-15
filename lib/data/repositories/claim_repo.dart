import '../models/claim.dart';
import '../providers/claim_provider.dart';

class ClaimRepository {
  List<Claim> _claims = [];
  final ClaimProvider _provider = ClaimProvider();

  Future<List<Claim>> getClaims() async {
    _claims = await _provider.getClaims();
    return _claims;
  }

  List<Claim> getClaimList() {
    return _claims;
  }

  Future<bool> newClaim(Claim claim) => _provider.createClaim(claim);
}
