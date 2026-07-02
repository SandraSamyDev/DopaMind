import 'package:flutter/material.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Focus\nComing Soon",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}