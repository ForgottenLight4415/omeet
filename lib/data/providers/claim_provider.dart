import '../../utilities/api_urls.dart';

import '/data/models/claim.dart';
import '/data/providers/app_server_provider.dart';
import '/data/providers/authentication_provider.dart';

class ClaimProvider extends AppServerProvider {
  Future<List<Claim>> getClaims({bool department = false}) async {
    final Map<String, String> _data = <String, String>{
      "email": await AuthenticationProvider.getEmail(),
    };
    final DecodedResponse _response = await postRequest(
      path: department
          ? ApiUrl.getDepartmentClaimsUrl
          : ApiUrl.getClaimsUrl,
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

  Future<bool> createClaim(Claim claim) async {
    await postRequest(
      path: ApiUrl.newClaim,
      data: claim.toInternetMap(),
    );
    return true;
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

  Future<bool> assignToSelf(String claimNumber, String surveyor) async {
    await postRequest(
      path: ApiUrl.assignToSelfUrl,
      data: <String, String> {
        "Claim_No" : claimNumber,
        "Surveyor_Name" : surveyor,
      },
    );
    return true;
  }
}
