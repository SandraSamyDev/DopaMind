import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

    if (!mounted) return;

    if (seenOnboarding) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),

        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "lib/assets/images/logo.jpeg",
                        width: 200,
                        height: 200,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "DopaMind",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B3C49),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "YOUR DIGITAL SANCTUARY",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(seconds: 3),
                        height: 6,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B5571),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Designing focus for the modern mind.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
