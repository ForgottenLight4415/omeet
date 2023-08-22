import 'dart:developer';

import '../models/withdrawal.dart';
import '../../utilities/api_urls.dart';
import '../providers/app_server_provider.dart';
import '../providers/authentication_provider.dart';

enum ClaimType { overall, allocated, accepted, rejected, concluded }

class ClaimProvider extends AppServerProvider {
  Future<List<Withdrawal>> getClaims(
      {String state = "",
      String district = "",
      String policeStation = "",
      ClaimType claimType = ClaimType.allocated}) async {
    final Map<String, String> _data = <String, String>{
      "phone_no": await AuthenticationProvider.getPhone(),
    };
    if (state.isNotEmpty) {
      _data["Court_State"] = state;
    }
    if (district.isNotEmpty) {
      _data["Court_Location"] = district;
    }
    if (policeStation.isNotEmpty) {
      _data["Police_Station"] = policeStation;
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
    final List<Withdrawal> _claims = [];
    if (_rData["response"] != "nopost") {
      for (var claim in _rData["allpost"]) {
        _claims.add(Withdrawal.fromJson(claim));
      }
    }
    log("Count: " + _claims.length.toString());
    return _claims;
  }

  Future<bool> submitConclusion(
    String claimNumber,
    String currentVisitStatus,
    String visitRemark,
    String probableWithdrawal,
    String lmSettlement,
    String withdrawalStatus,
    String finalRemarks,
  ) async {
    final DecodedResponse response = await postRequest(
      path: ApiUrl.claimConclusion,
      data: <String, String>{
        "phone_no": await AuthenticationProvider.getPhone(),
        "Claim_No": claimNumber,
        "Current_Visit_Status": currentVisitStatus,
        "Visit_Remark": visitRemark,
        "Probable_Withdrawal": probableWithdrawal,
        "LM_Settleable_Withdrawn": lmSettlement,
        "Withdrawal_Status": withdrawalStatus,
        "Final_Remarks": finalRemarks,
      },
    );
    return response.data?["code"] == 200;
  }

  Future<bool> submitReporting(
      String claimNumber, String selection, String description) async {
    final DecodedResponse response = await postRequest(
      path: ApiUrl.reporting,
      data: <String, String>{
        "Claim_No": claimNumber,
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
    return responseData['code'] == 200;
  }
}
