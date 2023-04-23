
import '../../utilities/api_urls.dart';

import '../models/audit.dart';
import '../models/claim.dart';
import '../providers/app_server_provider.dart';
import '../providers/authentication_provider.dart';

class ClaimProvider extends AppServerProvider {
  Future<List<Audit>> getClaims() async {
    final Map<String, String> _data = <String, String>{
      "email": await AuthenticationProvider.getEmail(),
    };
    final DecodedResponse _response = await postRequest(
      path: ApiUrl.getClaimsUrl,
      data: _data,
    );
    final Map<String, dynamic> _rData = _response.data!;
    final List<Audit> _claims = [];
    if (_rData["response"] != "nopost") {
      for (var claim in _rData["allpost"]) {
        _claims.add(Audit.fromJson(claim));
      }
    }
    return _claims;
  }

  Future<List<Claim>> getHospitalClaims(String hospitalId) async {
    final Map<String, String> _data = <String, String>{
      "Hos_ID": hospitalId,
    };
    final DecodedResponse _response = await postRequest(
      path: ApiUrl.getHospitalClaimsUrl,
      data: _data,
    );
    final Map<String, dynamic> _rData = _response.data!;
    final List<Claim> _claims = [];
    if (_rData["response"] != "nopost") {
      for (var claim in _rData["allpost"]) {
        _claims.add(Claim.fromJson(claim));
      }
    }
    return _claims;
  }

  Future<bool> submitConclusion(String claimNumber, String selected, String reason) async {
    await postRequest(
      path: ApiUrl.claimConclusion,
      data: <String, String> {
        "Claim_No" : claimNumber,
        "Selected" : selected,
        "Conclusion_Reason" : reason
      },
    );
    return true;
  }
}
