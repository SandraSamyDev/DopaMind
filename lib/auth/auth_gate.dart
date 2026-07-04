import 'package:dopamind/auth/auth_service.dart';
import 'package:dopamind/screens/auth_screens/email_verification.dart';
import 'package:dopamind/screens/home_screen.dart';
import 'package:dopamind/screens/auth_screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  static final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authchanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          if (user.emailVerified) {
            return const HomeScreen();
          } else {
            return const EmailVerification();
          }
        }

        return LoginPage();
      },
    );
  }
}

//userId: user.uid
