import 'package:dopamind/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth_widget/auth_scaffold.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../core/app_colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _comfirmPasswordController.dispose();
    super.dispose();
  }

  void register(email, password, usernamre) async {
try {
      await _authService.createAccount(
      email: email,
      password: password,
      username: usernamre,
    );
    if (mounted) {
      Navigator.pop(context);
    }
} catch (e) {
  if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())));
}
    



  }

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
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _usernameController,
                        label: "Full Name",
                        hint: "Enter your name",
                        icon: Icons.person_outline,
                        
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please re-enter your name";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emailController,
                        label: "Email",
                        hint: "Enter your email",
                        icon: Icons.email_outlined,
                        
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please re-enter your email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _passwordController,
                        label: "Password",
                        hint: "Enter password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please re-enter your password";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _comfirmPasswordController,
                        label: "Confirm Password",
                        hint: "Re-enter password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please re-enter your password";
                          }
                          if (value.trim() != _passwordController.text.trim()) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 26),

                      GradientButton(
                        text: "Create Account",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _usernameController.text.trim(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
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
                      Navigator.pop(context);
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
