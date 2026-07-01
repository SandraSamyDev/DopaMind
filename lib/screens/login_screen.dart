import 'package:dopamind/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/app_text_field.dart';
import '../widgets/gradient_button.dart';
import '../core/app_colors.dart';
import 'forgot_password.dart';
import 'signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

@override
  void dispose (){
_emailController.dispose();
_passwordController.dispose();
super.dispose();

  }

  void login(email,password) async {
    try {
      await _authService.signIn(email: email, password: password);
           } on FirebaseAuthException catch (e) {
            if (!mounted) return null;
            ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())));
      
    }

    

  }
  void loginWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
           } on FirebaseAuthException catch (e) {
            if (!mounted) return null;
            ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())));
      
    }

    

  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      height: 290,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'lib/assets/images/logo2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 40),

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
                    AppTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),

                    AppTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    GradientButton(
                      text: "Login",
                      onPressed: () {
                        login(_emailController.text.trim(), _passwordController.text.trim());
                      },
                    ),

                    const SizedBox(height: 20),

                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text("OR"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 20),

                    OutlinedButton.icon(
                      onPressed: () {
try {
   _authService.signInWithGoogle();  
} catch (e) {
  if(!mounted) return;

}
                     
                      },
                      icon: Image.asset(
                        "lib/assets/images/google.png",
                        height: 22,
                      ),
                      label: const Text("Continue with Google"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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
                  "Don't have an account? ",
                  style: TextStyle(color: AppColors.primary),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
