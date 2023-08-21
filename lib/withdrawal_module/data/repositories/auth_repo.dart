import '../providers/authentication_provider.dart';

class AuthRepository {
  final AuthenticationProvider _provider = AuthenticationProvider();

  Future<bool> signIn({String? email, String? password, bool development = false}) => _provider.signIn(
      phoneNumber: email,
      password: password,
      development: development,
  );

  Future<List<String?>> getUserDetails() async {
    return [
      await AuthenticationProvider.getEmail(),
      await AuthenticationProvider.getPhone(),
    ];
  }

  static Future<String> getPhone() async {
    return await AuthenticationProvider.getPhone();
  }

  Future<bool> resendOtp(String phoneNumber, String password) => _provider
      .resendOtp(phoneNumber, password);

  Future<bool> verifyOtp(String phoneNumber, String otp, {bool development = false}) => _provider
      .verifyOtp(phoneNumber, otp, development: development);

  Future<void> signOut() => AuthenticationProvider.signOut();
}
