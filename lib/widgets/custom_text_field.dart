import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller; // Added this line
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  

  const CustomTextField({
    super.key,
    this.controller, // Added this line
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.maxLines =1
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF3B5571),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, // Injected the controller into the underlying Flutter TextField
          validator: validator,
          obscureText: isPassword,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF3B5571)),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            
          ),
        ),
      ],
    );
  }
}