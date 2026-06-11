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

  static const _backLabels = ['', 'Back', 'Back', ''];
  static const _nextLabels = ['Get started', 'Next', 'Next', "Let's Start!"];

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

  void _onPageChanged(int index) {
    setState(() => _currentPageIndex = index);
  }

  void _onNext() {
    if (_currentPageIndex == 3) {
      Navigator.pushNamedAndRemoveUntil(context, "/setup", (_) => false);
      return;
    }
    _pageViewController.animateToPage(
      _currentPageIndex + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onBack() {
    if (_currentPageIndex > 0) {
      _pageViewController.animateToPage(
        _currentPageIndex - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backLabel = _backLabels[_currentPageIndex];
    final nextLabel = _nextLabels[_currentPageIndex];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // Gradient wraps the entire scaffold so it fills edge to edge
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.onboarding),
        child: SafeArea(
          child: Column(
            children: [
              // ── Pages ──────────────────────────────────────────────────
              Expanded(
                child: PageView(
                  controller: _pageViewController,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPage(
                      "Welcome to Kiko's Hub!",
                      "A safe place to learn, play, and stay prepared for the rising tides",
                      Image.asset("assets/kiko/washed-kiko_sprite_get-started_00_wave-welcome.png"),
                    ),
                    _buildPage(
                      "Learn with Kiko!",
                      "Discover fun and simple ways to keep everyone safe and healthy",
                      Image.asset("assets/kiko/WashEd_kiko_sprite_base.png"),
                    ),
                    _buildPage(
                      "Stay safe!",
                      "Prepare for the rainy season with helpful guides and flood alerts",
                      Image.asset("assets/kiko/washed-kiko_sprite_get-started_02_stay-safe-realtime-updates-icons.png"),
                    ),
                    _buildPage(
                      "Let's begin!",
                      "Let's start by getting your profile ready for action!",
                      Image.asset("assets/kiko/WashEd_kiko_sprite_cheer.png"),
                    ),
                  ],
                ),
              ),

              // ── Progress dots ───────────────────────────────────────────
              _ProgressDots(total: 4, current: _currentPageIndex),

              // ── Navigation buttons ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (backLabel.isNotEmpty) ...[
                      TextButton(
                        style: ButtonStyle(
                          minimumSize:
                              const WidgetStatePropertyAll(Size(80, 44)),
                          shape: const WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppRadius.sm)),
                            ),
                          ),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.grey.shade200),
                          foregroundColor: const WidgetStatePropertyAll(
                              AppColors.textDark),
                        ),
                        onPressed: _onBack,
                        child: Text(backLabel, style: AppTextStyles.button),
                      ),
                      const Spacer(),
                    ],
                    TextButton(
                      style: const ButtonStyle(
                        minimumSize: WidgetStatePropertyAll(Size(80, 44)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppRadius.sm)),
                          ),
                        ),
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.brandPink),
                        foregroundColor:
                            WidgetStatePropertyAll(AppColors.offWhite),
                      ),
                      onPressed: _onNext,
                      child: Text(nextLabel, style: AppTextStyles.button),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Individual page — transparent, no gradient ────────────────────────────

  Widget _buildPage(String title, String body, Image image) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxHeight < 500 ? 120.0 : 280.0;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: imageHeight, child: image),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h1Blue,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
          ),
        );
      },
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