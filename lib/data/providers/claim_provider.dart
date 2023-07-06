import 'dart:developer';

import '../../utilities/api_urls.dart';

import '/data/models/claim.dart';
import '/data/providers/app_server_provider.dart';
import '/data/providers/authentication_provider.dart';

class ClaimProvider extends AppServerProvider {
  Future<List<Claim>> getClaims({bool forSelfAssignment = false, bool rejected = false}) async {
    final Map<String, String> _data = <String, String>{
      "phone_no": await AuthenticationProvider.getPhone(),
    };
    log(_data.toString());
    final DecodedResponse _response = await postRequest(
      path: forSelfAssignment
          ? ApiUrl.getClaimsUrl
          : rejected
            ? ApiUrl.rejectedClaimsUrl
            : ApiUrl.acceptedClaimsUrl,
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

  Future<bool> submitConclusion(String claimNumber, String conclusion, String groundOfDefense, String observation) async {
    final DecodedResponse response = await postRequest(
      path: ApiUrl.claimConclusion,
      data: <String, String> {
        "CASE_ID" : claimNumber,
        "Conclusion" : conclusion,
        "Ground_Of_Defence" : groundOfDefense,
        "Observation" : observation,
      },
    );
    return response.data?["code"] == 200;
  }

  Future<bool> assignToSelf(Map<String, String> payload) async {
    final DecodedResponse response = await postRequest(
      path: ApiUrl.assignToSelfUrl,
      data: payload,
    );
    final Map<String, dynamic> responseData = response.data!;
    log(responseData.toString());
    return true;
  }
}
