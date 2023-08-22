import 'package:shared_preferences/shared_preferences.dart';

import 'app_server_provider.dart';

class AuthenticationProvider extends AppServerProvider {
  static Future<void> signOut() async {
    await _setLoginStatus(false);
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
