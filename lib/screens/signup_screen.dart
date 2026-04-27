import 'package:dopamind/screens/home_screen.dart';
import 'package:dopamind/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/app_text_field.dart';
import '../widgets/gradient_button.dart';
import '../core/app_colors.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      height: 290,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Build your focus step by step",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // CARD
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    const AppTextField(
                      label: "Full Name",
                      hint: "Enter your name",
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 16),

                    const AppTextField(
                      label: "Email",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),

                    const AppTextField(
                      label: "Password",
                      hint: "Enter password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 16),

                    const AppTextField(
                      label: "Confirm Password",
                      hint: "Re-enter password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 26),

                    GradientButton(text: "Create Account", onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>  HomeScreen()),
                    );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

