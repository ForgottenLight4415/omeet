import '../models/audit.dart';
import '../models/claim.dart';
import '../providers/claim_provider.dart';

class ClaimRepository {
  List<Audit> _claims = [];
  final ClaimProvider _provider = ClaimProvider();

  Future<List<Audit>> getClaims() async {
    _claims = await _provider.getClaims();
    return _claims;
  }

  Future<List<Claim>> getHospitalClaims(String hospitalId) async {
    return await _provider.getHospitalClaims(hospitalId);
  }

  List<Audit> getClaimList() {
    return _claims;
  }
}
