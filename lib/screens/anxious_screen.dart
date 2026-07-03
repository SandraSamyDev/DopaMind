import 'package:flutter/material.dart';
import '../core/app_colors.dart';
class AnxiousScreen extends StatefulWidget {
  const AnxiousScreen({super.key});

  @override
  State<AnxiousScreen> createState() => _AnxiousScreenState();
}

class _AnxiousScreenState extends State<AnxiousScreen> {
  int currentStep = 0;

  final List<Map<String, String>> groundingSteps = [
    {
      "title": "5 Things You Can See",
      "subtitle": "Look around and name five things you can see.",
    },
    {
      "title": "4 Things You Can Touch",
      "subtitle": "Notice four things you can physically feel.",
    },
    {
      "title": "3 Things You Can Hear",
      "subtitle": "Listen carefully and identify three sounds.",
    },
    {
      "title": "2 Things You Can Smell",
      "subtitle": "Try to notice two different smells.",
    },
    {
      "title": "1 Thing You Can Taste",
      "subtitle": "Focus on one taste in your mouth.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isFinished = currentStep == groundingSteps.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text(
          "Anxiety Support",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.self_improvement,
                color: AppColors.primary,
                size: 45,
              ),
            ),
            const SizedBox(height: 20),
            if (!isFinished) ...[
              Text(
                groundingSteps[currentStep]["title"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                groundingSteps[currentStep]["subtitle"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  "${currentStep + 1} / ${groundingSteps.length}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentStep++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
              const Text(
                "Take a Deep Breath",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "You are safe.\nYou don't have to solve everything right now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    "I'm Feeling Better",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
