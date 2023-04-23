import '../models/claim.dart';
import '../providers/claim_provider.dart';

class ClaimRepository {
  List<Claim> _claims = [];
  final ClaimProvider _provider = ClaimProvider();

  Future<List<Claim>> getClaims({bool completed = false}) async {
    _claims = await _provider.getClaims(completed: completed);
    return _claims;
  }

  List<Claim> getClaimList() {
    return _claims;
  }
}
