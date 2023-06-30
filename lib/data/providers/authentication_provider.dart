import 'package:omeet_motor/utilities/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_server_provider.dart';

class AuthenticationProvider extends AppServerProvider {
  Future<bool> signIn(String email, String password) async {
    final Map<String, String> _data = <String, String>{
      "phone_no": email.trim(),
      "password": password,
    };
    final DecodedResponse _response = await postRequest(
      path: ApiUrl.loginUrl,
      data: _data,
    );
    final Map<String, dynamic>? _rData = _response.data;
    if (_rData != null) {
      _setLoginStatus(
        await AuthenticationProvider.isLoggedIn(),
        phone: _rData["phone_no"],
      );
      return _rData["code"] == successCode;
    }
    return false;
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    final Map<String, String> _data = <String, String>{
      "phone_no": phoneNumber.trim(),
      "otp": otp,
    };
    final DecodedResponse _response = await postRequest(
      path: ApiUrl.verifyOtp,
      data: _data,
    );
    final Map<String, dynamic> _rData = _response.data!;
    return _setLoginStatus(_rData["code"] == successCode, email: phoneNumber);
  }

  static Future<void> signOut() async {
    await _setLoginStatus(false);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getBool("isLoggedIn") ?? false;
  }

  static Future<String> getEmail() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("email") ?? "";
  }

  static Future<String> getPhone() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("phone") ?? "";
  }

  static Future<bool> _setLoginStatus(bool status, {String? email, String? phone}) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    if (status) {
      if (email != null) {
        _pref.setString("email", email);
      }
      if (phone != null) {
        _pref.setString("phone", phone);
      }
    } else {
      _pref.remove("email");
      _pref.remove("phone");
    }
    _pref.setBool("isLoggedIn", status);
    return status;
  }
}
