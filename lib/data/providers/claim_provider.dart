import 'dart:developer';

import '../../utilities/api_urls.dart';

import '/data/models/claim.dart';
import '/data/providers/app_server_provider.dart';
import '/data/providers/authentication_provider.dart';

enum ClaimType { overall, allocated, accepted, rejected, concluded }

class ClaimProvider extends AppServerProvider {
  Future<List<Claim>> getClaims(
      {String state = "",
      String district = "",
      String policeStation = "",
      ClaimType claimType = ClaimType.allocated}) async {
    final Map<String, String> _data = <String, String>{
      "phone_no": await AuthenticationProvider.getPhone(),
    };
    if (state.isNotEmpty) {
      _data["state"] = state;
    }
    if (district.isNotEmpty) {
      _data["district"] = district;
    }
    if (policeStation.isNotEmpty) {
      _data["police_station"] = policeStation;
    }
    String path = "";
    switch (claimType) {
      case ClaimType.overall:
        path = ApiUrl.getOverallClaimsUrl;
        break;
      case ClaimType.allocated:
        path = ApiUrl.getClaimsUrl;
        break;
      case ClaimType.accepted:
        path = ApiUrl.acceptedClaimsUrl;
        break;
      case ClaimType.rejected:
        path = ApiUrl.rejectedClaimsUrl;
        break;
      case ClaimType.concluded:
        path = ApiUrl.getConcludedClaimsUrl;
        break;
    }
    log("Hit: $path");
    final DecodedResponse _response = await postRequest(
      path: path,
      data: _data,
    );
    final Map<String, dynamic> _rData = _response.data!;
    final List<Claim> _claims = [];
    if (_rData["response"] != "nopost") {
      for (var claim in _rData["allpost"]) {
        _claims.add(Claim.fromJson(claim));
      }
    }
    log("Count: " + _claims.length.toString());
    return _claims;
  }

  Future<bool> createClaim(Claim claim) async {
    await postRequest(
      path: ApiUrl.newClaim,
      data: claim.toInternetMap(),
    );
    return true;
  }

  Future<bool> submitConclusion(String claimNumber, String conclusion,
      String groundOfDefense, String observation) async {
    final DecodedResponse response = await postRequest(
      path: ApiUrl.claimConclusion,
      data: <String, String>{
        "CASE_ID": claimNumber,
        "Conclusion": conclusion,
        "Ground_Of_Defence": groundOfDefense,
        "Observation": observation,
      },
    );
    return response.data?["code"] == 200;
  }

  Future<bool> submitReporting(
      String claimNumber, String selection, String description) async {
    final DecodedResponse response = await postRequest(
      path: ApiUrl.reporting,
      data: <String, String>{
        "CASE_ID": claimNumber,
        "phone_no": await AuthenticationProvider.getPhone(),
        "selection": selection,
        "description": description,
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
