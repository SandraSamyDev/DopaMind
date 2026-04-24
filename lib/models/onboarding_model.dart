class OnboardingModel {
  final String title;
  final String subtitle;
  final String image;
  final String buttonText;

  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
  });
}

List<OnboardingModel> onboardingData = [
  OnboardingModel(
    title: "Stay Focused",
    subtitle:
        "Improve your focus and avoid distractions with a workspace designed specifically for how your mind works.",
    image: "lib/assets/images/onboarding1.png",
    buttonText: "Next",
  ),
  OnboardingModel(
    title: "Break Down Tasks",
    subtitle: "Turn big tasks into small, manageable steps",
    image: "lib/assets/images/onboarding2.png",
    buttonText: "Next",
  ),
  OnboardingModel(
    title: "Achieve Your Goals",
    subtitle: "Track your progress and stay motivated every day",
    image: "lib/assets/images/onboarding3.png",
    buttonText: "Get Started",
  ),
];
