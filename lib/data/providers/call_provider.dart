import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/api_urls.dart';
import 'app_server_provider.dart';

class CallProvider extends AppServerProvider {
  Future<DecodedResponse> callRequest(Map<String, dynamic> data) async {
    return await postRequest(
      baseUrl: ApiUrl.bridgeCallUrl,
      headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
        "access-key": ApiUrl.bridgeCallToken,
      },
      data: data,
    );
  }

  Future<DecodedResponse> messageRequest(Map<String, dynamic> data) async {
    return await getRequest(baseUrl: ApiUrl.sendMessageUrl, data: data);
  }

  Future<bool> callClient({
    String? managerPhoneNumber,
    required String claimNumber,
    required String phoneNumber,
  }) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    final Map<String, dynamic> _data = <String, dynamic>{
      "type": "callAndConnect",
      "call1": {
        "type": "phone",
        "number": managerPhoneNumber ?? _pref.getString("phone"),
        "callerId": "4825239",
      },
      "call2": {
        "type": "phone",
        "number": phoneNumber,
        "callerId": "4825239",
      },
      "recordCall": true,
      "stereo": true,
      "callbackUrl": "http://localhost:9898/events",
      "extraParams": {
        "cmnumber": claimNumber,
        "servicetype": "BAGIC_MCI",
      }
    };
    final DecodedResponse _requestResponse = await callRequest(_data);
    return _requestResponse.statusCode == successCode;
  }

  Future<bool> sendMessage({
    required String claimNumber,
    required String phoneNumber,
  }) async {
    // claimNumber = claimNumber.replaceAll(RegExp(r"\D"), "");
    // final String meetId = claimNumber + phoneNumber;
    final Map<String, dynamic> _data = <String, dynamic>{
      "key": ApiUrl.smsKey,
      "entity" : ApiUrl.smsEntity,
      "tempId" : ApiUrl.smsTempId,
      "routeid" : ApiUrl.smsRouteId,
      "type" : ApiUrl.smsType,
      "contacts" : phoneNumber,
      "senderid" : ApiUrl.smsSenderId,
      "msg" : "Kindly join the video meet by clicking on https://omeet.in/BAGIC_Motor_Claim_Investigation/OMEET/index.php?id=$claimNumber GODJNO"
    };
    final DecodedResponse _requestResponse = await messageRequest(_data);
    return _requestResponse.statusCode == successCode;
  }
}
