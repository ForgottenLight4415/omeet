import 'package:omeet_motor/utilities/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_server_provider.dart';

class AuthenticationProvider extends AppServerProvider {
  Future<bool> signIn({String? phoneNumber, String? password}) async {
    final bool isLoggedIn = await AuthenticationProvider.isLoggedIn();
    if (isLoggedIn) {
      return true;
    } else if (phoneNumber != null && password != null) {
      final Map<String, String> data = <String, String> {
        "phone_no": phoneNumber.trim(),
        "password": password,
      };
      final DecodedResponse response = await postRequest(
        path: ApiUrl.loginUrl,
        data: data,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseData = response.data;
        if (responseData != null && responseData["code"] != null) {
          if (responseData["code"] == 200) {
            _setLoginStatus(false, phone: responseData["phone_no"]);
            // Redirects to OTP Page
            return true;
          } else if (responseData["code"] == 400) {
            throw const AppException(code: 400, cause: "Bad Credentials");
          } else {
            throw const AppException(code: 500, cause: "Server side failure");
          }
        } else {
          throw const AppException(code: 204, cause: "No response received from server");
        }
      } else {
        throw AppException(
          code: response.statusCode, 
          cause: "The service is temporarily down or unavailable. We are working to get it up and running as soon as possible.",
        );
      }
    } else {
      return false;
    }
  }

  Future<bool> resendOtp(String phoneNumber, String password) async {
    return await signIn(phoneNumber: phoneNumber, password: password);
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
