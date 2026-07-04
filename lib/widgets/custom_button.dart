import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final IconData? icon;
  final double verticalPadding;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.textColor = Colors.white,
    this.icon,
    this.verticalPadding = 16.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );

    // If an icon is provided, use ElevatedButton.icon, otherwise use regular ElevatedButton
    if (icon != null) {
      return ElevatedButton.icon(
        style: _buttonStyle(),
        onPressed: onPressed,
        icon: Icon(icon, color: textColor),
        label: labelWidget,
      );
    }

    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: onPressed,
      child: labelWidget,
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      elevation: 0, // Keeps it modern and flat
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}