import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Center(
      child: Text(
        "Profile\nComing Soon",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}