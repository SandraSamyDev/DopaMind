import 'dart:async';

import 'package:dopamind/auth/auth_service.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final AuthService _authService = AuthService();

  bool _isEmailVerified = false;
  bool _canResendEmail = true;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _isEmailVerified = _authService.currentUser?.emailVerified ?? false;

    if (!_isEmailVerified) {
      _sendEmailLink();
    }
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => _verifyCurrentUser(),
    );
  }

  Future<void> _sendEmailLink() async {
    try {
      await _authService.sendEmailVerification();

      setState(() => _canResendEmail = false);
      await Future.delayed(Duration(seconds: 20));
      if (!mounted) return;
      setState(() => _canResendEmail = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

Future<void> _verifyCurrentUser() async {
    try {
      // This forces the userChanges stream in AuthGate to notice the update
      await _authService.currentUser?.reload(); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_rounded,
                size: 80,
                color: Color(0xFF3B5571),
              ),
              const SizedBox(height: 24),
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B3C49),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We sent an activation link to:\n${_authService.currentUser?.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B5571),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _canResendEmail ? _sendEmailLink : null,
                icon: const Icon(Icons.email),
                label: Text(
                  _canResendEmail ? "Resend Link" : "Wait a moment...",
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  _authService.signOut();
                },
                child: const Text(
                  "Cancel & Log Out",
                  style: TextStyle(
                    color: Color(0xFF0B3C49),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
             ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B5571)),
  onPressed: () async {
    bool isVerified = await _authService.checkEmailVerified();
    if (isVerified) {
      // You don't need manual navigation! 
      // Setting state or letting AuthGate notice the change shifts the app automatically.
if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email verified successfully!")),
      );
}

      

    } else {
     if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email not verified yet. Please check your inbox.")),
      );
     }
    }
  },
  child: const Text("I've Clicked the Link", style: TextStyle(color: Colors.white70),),
)
            ],
          ),
        ),
      ),
    );
  }
}
