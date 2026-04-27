import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final double height;

  const AuthScaffold({super.key, required this.child, this.height = 260});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
              ),
            ),
          ),

          Container(
            height: height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(child: child),
        ],
      ),
    );
  }
}
