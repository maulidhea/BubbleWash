import 'dart:async';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
