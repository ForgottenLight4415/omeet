import '../providers/authentication_provider.dart';

class AuthRepository {
  Future<List<String?>> getUserDetails() async {
    return [
      await AuthenticationProvider.getEmail(),
      await AuthenticationProvider.getPhone(),
    ];
  }

  static Future<String> getPhone() async {
    return await AuthenticationProvider.getPhone();
  }

  Future<void> signOut() => AuthenticationProvider.signOut();
}
