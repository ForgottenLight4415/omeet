import 'package:rc_clone/data/providers/authentication_provider.dart';

class AuthRepository {
  final AuthenticationProvider _provider = AuthenticationProvider();

  Future<bool> signIn({String? email, String? password}) async {
    if (email == null && password == null) {
      return await AuthenticationProvider.isLoggedIn();
    } else {
      return await _provider.signIn(email!, password!);
    }
  }

  Future<void> signOut() => AuthenticationProvider.signOut();
}
