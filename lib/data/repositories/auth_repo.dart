import '../providers/authentication_provider.dart';

class AuthRepository {
  final AuthenticationProvider _provider = AuthenticationProvider();

  Future<bool> signIn({String? email, String? password}) => _provider.signIn(
      phoneNumber: email,
      password: password,
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

  Future<bool> verifyOtp(String phoneNumber, String otp) => _provider
      .verifyOtp(phoneNumber, otp);

  Future<void> signOut() => AuthenticationProvider.signOut();
}
