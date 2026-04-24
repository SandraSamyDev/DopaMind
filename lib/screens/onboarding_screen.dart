import 'package:dopamind/models/onboarding_model.dart';
import 'package:dopamind/widgets/onboarding_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("Go to Home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "DopaMind",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B5571),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Color(0xFF3B5571)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingItem(model: onboardingData[index]);
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Color(0xFF3B5571)
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B5571),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  onboardingData[currentIndex].buttonText,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
