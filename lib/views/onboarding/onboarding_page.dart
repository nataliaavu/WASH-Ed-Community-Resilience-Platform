import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageViewController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> onboardingPages = [
      _buildOnboardingPage(
        "Welcome to Kiko's Hub!",
        "A safe place to learn, play, and stay prepared for the rising tides",
        Image.asset("assets/kiko/washed-kiko_sprite_get-started_00_wave-welcome.png"),
        "",
        "Get started",
      ),
      _buildOnboardingPage(
        "Learn with Kiko!",
        "Discover fun and simple ways to keep everyone safe and healthy",
        Image.asset("assets/kiko/WashEd_kiko_sprite_base.png"),
        "Back",
        "Next",
      ),
      _buildOnboardingPage(
        "Stay safe!",
        "Prepare for the rainy season with helpful guides and flood alerts",
        Image.asset("assets/kiko/washed-kiko_sprite_get-started_02_stay-safe-realtime-updates-icons.png"),
        "Back",
        "Next",
      ),
      _buildOnboardingPage(
        "Let's begin!",
        "Let's start by getting your profile ready for action!",
        Image.asset("assets/kiko/WashEd_kiko_sprite_cheer.png"),
        "",
        "Let's Start!",
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        onPageChanged: _onPageChanged,
        children: onboardingPages,
      ),
    );
  }

  void _onPageChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _onUpdateCurrentPageIndex(int index) {
    if (index == 4) {
      Navigator.pushNamedAndRemoveUntil(context, "/setup", (_) => false);
      return;
    }

    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildOnboardingPage(
    String title,
    String body,
    Image image,
    String backButtonText,
    String nextButtonText,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFDE7)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 10,
            horizontal: 40,
          ),
          child: Column(
            children: <Widget>[
              Spacer(),
              image,
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1A47C8),
                    fontSize: 28,
                    fontWeight: FontWeight(1000),
                    height: 0,
                  ),
                ),
              ),
              Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 18,
                  height: 0,
                ),
              ),
              NavigationButtons(
                currentPageIndex: _currentPageIndex,
                onUpdateCurrentPageIndex: _onUpdateCurrentPageIndex,
                backButtonText: backButtonText,
                nextButtonText: nextButtonText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({
    super.key,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.backButtonText,
    required this.nextButtonText,
  });

  final int currentPageIndex;
  final void Function(int) onUpdateCurrentPageIndex;
  final String backButtonText;
  final String nextButtonText;

  @override
  Widget build(BuildContext context) {
    // TODO: refactor colors into theme
    // final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (backButtonText != "") ...[
            TextButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(80, 40)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(Color(0xFFDDDDDF)),
                foregroundColor: WidgetStatePropertyAll(Color(0xFF1A1A2E)),
              ),
              onPressed: () {
                if (currentPageIndex > 0) {
                  onUpdateCurrentPageIndex(currentPageIndex - 1);
                }
              },
              child: Text(backButtonText),
            ),
          ],

          if (backButtonText != "" && nextButtonText != "") ...[Spacer()],

          if (nextButtonText != "") ...[
            TextButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(80, 40)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(Color(0xFFE8177A)),
                foregroundColor: WidgetStatePropertyAll(Color(0xFFF7F8FC)),
              ),
              onPressed: () {
                onUpdateCurrentPageIndex(currentPageIndex + 1);
              },
              child: Text(nextButtonText),
            ),
          ],
        ],
      ),
    );
  }
}
