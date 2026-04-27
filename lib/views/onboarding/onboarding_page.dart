import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<IntroductionScreenState> _introKey =
      GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      allowImplicitScrolling: true,
      infiniteAutoScroll: false,
      pages: [
        buildWelcomePage(),
        buildLearnPage(),
        buildSafetyPage(),
        buildAlertsAndContinuePage(),
      ],
      onDone: onOnboardingEnd,
      showSkipButton: false,
      showBackButton: true,
      showNextButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBottomPart: true,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        activeSize: const Size(22.0, 10.0),
        activeColor: Theme.of(context).colorScheme.primary,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      back: Text(
        "Back",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      next: Text(
        "Next",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      done: Text(
        "Go!",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  PageViewModel buildWelcomePage() {
    return PageViewModel(
      title: "Welcome to Kiko's Hub!",
      body:
          "A safe place to learn, play, and stay prepared for the rising tides",
      image: Image(
        image: AssetImage("assets/kiko/WashEd_kiko_sprite_cheer.png"),
      ),
      decoration: getPageDecoration(),
    );
  }

  PageViewModel buildLearnPage() {
    return PageViewModel(
      title: "Learn with Kiko!",
      body: "Discover fun and simple ways to keep everyone safe and healthy",
      image: Image(
        image: AssetImage("assets/kiko/WashEd_kiko_sprite_base.png"),
      ),
      decoration: getPageDecoration(),
    );
  }

  PageViewModel buildSafetyPage() {
    return PageViewModel(
      title: "Stay safe!",
      body: "Prepare for the rainy season with helpful guides and flood alerts",
      image: Image(
        image: AssetImage("assets/kiko/WashEd_kiko_sprite_side-jump.png"),
      ),
      decoration: getPageDecoration(),
    );
  }

  PageViewModel buildAlertsAndContinuePage() {
    return PageViewModel(
      title: "Let's begin!",
      body: "Let's start by getting your profile ready for action!",
      image: Image(
        image: AssetImage("assets/kiko/WashEd_kiko_sprite_cheer.png"),
      ),
      decoration: getPageDecoration(),
    );
  }

  Widget buildIconPage(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(40),
      child: Icon(
        icon,
        size: 120,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  PageDecoration getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18.0,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
      ),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: const EdgeInsets.symmetric(vertical: 20.0),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      pageMargin: const EdgeInsets.only(top: 80.0),
    );
  }

  void onOnboardingEnd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnboarded', true);

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
