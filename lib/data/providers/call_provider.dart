import 'dart:convert';

import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/utilities/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallProvider extends AppServerProvider {
  Future<bool> callClient({required String claimNumber, required String phoneNumber, required String customerName}) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    final Map<String, dynamic> _data = <String, dynamic>{
      "agenTptId": _pref.getString("email"),
      "customerNumber": phoneNumber,
      "insertLead": "true",
      "customerInfo": jsonEncode(<String, String>{
        "c_resourceId": claimNumber,
        "customerName": customerName,
      }),
      "tokenId": AppStrings.callToken,
    };
    return await callRequest(_data);
  }

  Future<bool> sendMessage({required String claimNumber, required String phoneNumber}) async {
    final Map<String, dynamic> _data = <String, dynamic>{
      "contacts" : phoneNumber,
      "message" : "Kindly join the video meet by clicking on ${AppStrings.messageMeetUrl}$claimNumber GODJNO",
    };
    return await messageRequest(_data);
  }
}
