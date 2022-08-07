import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_server_provider.dart';

class CallProvider extends AppServerProvider {
  Future<bool> callClient({required String claimNumber, required String phoneNumber, required String customerName}) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    final Map<String, dynamic> _data = <String, dynamic>{
      "type": "callAndConnect",
      "call1" : {
        "type" : "phone",
        "number" : _pref.getString("phone"),
        "callerId" : "4825239"
      },
      "call2" : {
        "type" : "phone",
        "number" : phoneNumber,
        "callerId" : "4825239"
      },
      "recordCall": true,
      "stereo" : true,
      "callbackUrl": "http://localhost:9898/events",
      "extraParams": {
        "cmnumber" : claimNumber,
        "servicetype":"BAGIC_MCI"
      }
    };
    return await callRequest(_data);
  }

  Future<bool> sendMessage({required String claimNumber, required String phoneNumber}) async {
    // claimNumber = claimNumber.replaceAll(RegExp(r"\D"), "");
    // final String meetId = claimNumber + phoneNumber;
    final encodedUrl = Uri.encodeFull('http://sms.gooadvert.com/app/smsapi/index.php?key=562A39B5CE0B91&entity=1501693730000042530&tempid=1507165743675014713&routeid=636&type=text&contacts=$phoneNumber&senderid=GODJNO&msg=Kindly join the video meet by clicking on https://omeet.in/BAGIC_Motor_Claim_Investigation/OMEET/index.php?id=$claimNumber GODJNO');
    final Response _response = await get(
      Uri.parse(encodedUrl),
      headers: <String, String>{
        "Accept": "application/json",
      },
    );
    return _response.statusCode == successCode;
  }
}
