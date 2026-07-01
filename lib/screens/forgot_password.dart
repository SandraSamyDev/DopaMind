import 'package:dopamind/core/app_colors.dart';
import 'package:dopamind/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/app_text_field.dart';
import '../widgets/gradient_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      height: 290,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

           
            const Icon(Icons.lock_reset, size: 80, color: Colors.white),

            const SizedBox(height: 12),

           
            const Text(
              "Forgot Password?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Enter your email to receive a reset link",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ),

            const SizedBox(height: 50),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    const AppTextField(
                      label: "Email",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 25),

                    GradientButton(text: "Send Reset Link", onPressed: () {}),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  LoginPage()),
                );
              },
              child: const Text(
                "Back to Login",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
