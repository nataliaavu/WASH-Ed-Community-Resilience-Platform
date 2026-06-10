import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';

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
        "Welcome to \nKiko's Hub!",
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
      resizeToAvoidBottomInset: true,
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
      decoration: const BoxDecoration(gradient: AppGradients.onboarding),
      child: SafeArea(
        child: Column(
          children: [
            // ── Spacer pushes content to vertical centre ───────────────────
            const Spacer(flex: 2),

            // ── Kiko image ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: image,
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── Title ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1Blue,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Body text ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            ),

            // ── Spacer balances space below text ───────────────────────────
            const Spacer(flex: 2),

            // ── Progress dots ──────────────────────────────────────────────
            _ProgressDots(
              total: 4,
              current: _currentPageIndex,
            ),

            // ── Navigation buttons ─────────────────────────────────────────
            NavigationButtons(
              currentPageIndex: _currentPageIndex,
              onUpdateCurrentPageIndex: _onUpdateCurrentPageIndex,
              backButtonText: backButtonText,
              nextButtonText: nextButtonText,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Progress dots ─────────────────────────────────────────────────────────────

class _ProgressDots extends StatelessWidget {
  final int total;
  final int current;

  const _ProgressDots({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (index) {
          final isActive = index == current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive ? AppColors.brandPink : AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          );
        }),
      ),
    );
  }
}

// ── Navigation buttons ────────────────────────────────────────────────────────

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (backButtonText != "") ...[
            TextButton(
              style: ButtonStyle(
                minimumSize: const WidgetStatePropertyAll(Size(80, 44)),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppRadius.sm)),
                  ),
                ),
                backgroundColor:
                    WidgetStatePropertyAll(Colors.grey.shade200),
                foregroundColor:
                    const WidgetStatePropertyAll(AppColors.textDark),
              ),
              onPressed: () {
                if (currentPageIndex > 0) {
                  onUpdateCurrentPageIndex(currentPageIndex - 1);
                }
              },
              child: Text(backButtonText, style: AppTextStyles.button),
            ),
          ],

          if (backButtonText != "" && nextButtonText != "") ...[
            const Spacer()
          ],

          if (nextButtonText != "") ...[
            TextButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(80, 44)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppRadius.sm)),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(AppColors.brandPink),
                foregroundColor: WidgetStatePropertyAll(AppColors.offWhite),
              ),
              onPressed: () {
                onUpdateCurrentPageIndex(currentPageIndex + 1);
              },
              child: Text(nextButtonText, style: AppTextStyles.button),
            ),
          ],
        ],
      ),
    );
  }
}