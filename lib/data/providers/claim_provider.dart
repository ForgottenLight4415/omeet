import 'dart:developer';

import '/data/models/claim.dart';
import '/data/providers/app_server_provider.dart';
import '/data/providers/authentication_provider.dart';
import '/utilities/app_constants.dart';

class ClaimProvider extends AppServerProvider {
  Future<List<Claim>> getClaims() async {
    final Map<String, String> _data = <String, String>{
      "email": await AuthenticationProvider.getEmail(),
    };
    final DecodedResponse _response = await postRequest(
      path: AppStrings.getClaimsUrl,
      data: _data,
    );
    if (_response.statusCode == successCode) {
      final Map<String, dynamic> _rData = _response.data!;
      final List<Claim> _claims = [];
      if (_rData["response"] != "nopost") {
        for (var claim in _rData["allpost"]) {
          _claims.add(Claim.fromJson(claim));
        }
      }
      return _claims;
    }
    throw ServerException(
      code: _response.statusCode,
      cause: _response.reasonPhrase ?? AppStrings.unknown,
    );
  }

  Future<bool> createClaim(Claim claim) async {
    final DecodedResponse _response = await postRequest(
      path: AppStrings.newClaim,
      data: claim.toInternetMap(),
    );
    if (_response.statusCode == successCode) {
      return true;
    }
    throw ServerException(
      code: _response.statusCode,
      cause: _response.reasonPhrase ?? AppStrings.unknown,
    );
  }

  Future<bool> submitConclusion(String claimNumber, String selected, String reason) async {
    final DecodedResponse _response = await postRequest(
      path: AppStrings.claimConclusion,
      data: <String, String> {
        "Claim_No" : claimNumber,
        "Selected" : selected,
        "Conclusion_Reason" : reason
      },
    );
    if (_response.statusCode == successCode) {
      log(_response.data.toString());
      return true;
    }
    throw ServerException(
      code: _response.statusCode,
      cause: _response.reasonPhrase ?? AppStrings.unknown,
    );
  }
}
