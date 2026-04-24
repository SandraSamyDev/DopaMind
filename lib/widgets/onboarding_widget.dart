import 'package:dopamind/models/onboarding_model.dart';
import 'package:flutter/material.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),

        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              model.image,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            ),
          ),
        ),

        const SizedBox(height: 40),

        
        Text(
          model.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            model.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}