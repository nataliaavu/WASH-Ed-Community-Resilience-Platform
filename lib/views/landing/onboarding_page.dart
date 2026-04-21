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
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildSkipButton(),
          ),
        ),
      ),
      pages: [
        buildWelcomePage(),
        buildWelcomePage(),
        buildAppearancePage(),
        buildCompletePage(),
      ],
      onDone: onOnboardingEnd,
      onSkip: onOnboardingEnd,
      // showSkipButton: false,
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
      next: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),
      back: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
      ),
      done: Text(
        "Done",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: onOnboardingEnd,
      child: Text(
        "Skip",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  PageViewModel buildWelcomePage() {
    return PageViewModel(
      title: "welcome",
      body: "this is the onboarding screen",
      image: buildIconPage(Icons.book_outlined),
      decoration: getPageDecoration(),
    );
  }

  PageViewModel buildAppearancePage() {
    return PageViewModel(
      title: "another page",
      body: "this is another page",
      image: buildIconPage(Icons.book_outlined),
      decoration: getPageDecoration(),
    );
  }

  PageViewModel buildCompletePage() {
    return PageViewModel(
      title: "done",
      body: "onboarding complete",
      image: buildIconPage(Icons.check_circle_outline),
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
        fontSize: 19.0,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
      ),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      imagePadding: const EdgeInsets.symmetric(vertical: 40.0),
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
