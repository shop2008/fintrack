import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintrack/main.dart';
import 'package:fintrack/screens/login_screen.dart';
import 'package:flutter/material.dart';

part 'auth_service.g.dart';

class AuthState {
  final bool isAuthenticated;
  final String? error;
  final String? email;

  AuthState({required this.isAuthenticated, this.error, this.email});
}

@riverpod
class AuthService extends AutoDisposeNotifier<AuthState> {
  @override
  AuthState build() {
    _loadAuthState();
    return AuthState(isAuthenticated: false);
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email != null) {
      state = AuthState(isAuthenticated: true, email: email);
    }
  }

  Future<void> login(String email, String password) async {
    if (email == 'test@example.com' && password == '123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      state = AuthState(isAuthenticated: true, email: email);
    } else {
      state =
          AuthState(isAuthenticated: false, error: 'Invalid email or password');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    state = AuthState(isAuthenticated: false);

    // Navigate to login screen
    navigateToLogin();
  }

  void navigateToLogin() {
    // Use a NavigatorKey to access navigation from a non-widget class
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
