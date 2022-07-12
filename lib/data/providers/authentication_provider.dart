import 'package:rc_clone/data/providers/app_server_provider.dart';
import 'package:rc_clone/utilities/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends AppServerProvider {
  Future<bool> signIn(String email, String password) async {
    final Map<String, String> _data = <String, String>{
      "email": email.trim(),
      "password": password,
    };
    final DecodedResponse _response = await postRequest(
      path: AppStrings.loginUrl,
      data: _data,
    );
    if (_response.statusCode == successCode) {
      final Map<String, dynamic> _rData = _response.data!;
      return _rData["code"] == successCode;
    } else {
      throw ServerException(
        code: _response.statusCode,
        cause: _response.reasonPhrase ?? AppStrings.unknown,
      );
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    final Map<String, String> _data = <String, String>{
      "email": email.trim(),
      "otp": otp,
    };
    final DecodedResponse _response = await postRequest(
      path: AppStrings.verifyOtp,
      data: _data,
    );
    if (_response.statusCode == successCode) {
      final Map<String, dynamic> _rData = _response.data!;
      return _setLoginStatus(_rData["code"] == successCode, email: email);
    } else {
      throw ServerException(
        code: _response.statusCode,
        cause: _response.reasonPhrase ?? AppStrings.unknown,
      );
    }
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

  static Future<bool> _setLoginStatus(bool status, {String? email}) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("email", email ?? "");
    _pref.setBool("isLoggedIn", status);
    return status;
  }
}
