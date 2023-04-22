import 'package:omeet_motor/utilities/api_urls.dart';

import '/data/models/claim.dart';
import '/data/providers/app_server_provider.dart';
import '/data/providers/authentication_provider.dart';

class HomeProvider extends AppServerProvider {
  Future<List<Claim>> getClaims() async {
    final Map<String, String> _data = <String, String>{
      "email": await AuthenticationProvider.getEmail(),
    };
    final DecodedResponse _response = await postRequest(
      path: ApiUrl.getCompletedClaimsUrl,
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
}
