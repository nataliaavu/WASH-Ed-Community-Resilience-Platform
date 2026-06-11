import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ── Game data ─────────────────────────────────────────────────────────────────

class _GameItem {
  final String title;
  final String description;
  final String thumbnailAsset;
  final String url;

  const _GameItem({
    required this.title,
    required this.description,
    required this.thumbnailAsset,
    required this.url,
  });
}

const _games = [
  _GameItem(
    title: "Kiko's Flood Escape",
    description: 'Save Kiko and race to help him reach to safety!',
    thumbnailAsset: "assets/wash-ed/Kiko's Flood Escape.png",
    url:
        'https://html-classic.itch.zone/html/14755858/Wash-Ed-Interactive-Learning-Game-wash-heroes-english/Kiko\'s Flood Escape/index.html',
  ),
  _GameItem(
    title: "Kiko's Day",
    description:
        'Join Kiko throughout his day as he teaches proper hand hygiene!',
    thumbnailAsset: "assets/wash-ed/Kiko's Day Mini Games.png",
    url:
        'https://html-classic.itch.zone/html/15634034/KikosDayFinal/index.html',
  ),
];

// ── GamesPage ─────────────────────────────────────────────────────────────────

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.pageBg),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _HeaderBanner()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: _GameCard(game: _games[i]),
                    ),
                    childCount: _games.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header banner ─────────────────────────────────────────────────────────────

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg - 4,
        AppSpacing.md,
        0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: AppDecorations.blueHeader(radius: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ready to Play?', style: AppTextStyles.h1White),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Join Kiko and help keep everyone safe!',
                  style: AppTextStyles.bodyWhite.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/kiko/washed-kiko_sprite_games-ready-to-play.png',
            height: 150,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// ── Game card ─────────────────────────────────────────────────────────────────

class _GameCard extends StatelessWidget {
  final _GameItem game;
  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.yellowBorderCard(radius: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md)),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.asset(game.thumbnailAsset, fit: BoxFit.cover),
            ),
          ),

          // ── Info + button ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              14,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.title, style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  game.description,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMid),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            GameWebViewPage(title: game.title, url: game.url),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('Play Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPink,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                      ),
                      textStyle: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── In-app WebView page ───────────────────────────────────────────────────────

class GameWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const GameWebViewPage({super.key, required this.title, required this.url});

  @override
  State<GameWebViewPage> createState() => _GameWebViewPageState();
}

class _GameWebViewPageState extends State<GameWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([.landscapeLeft, .landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(.immersive);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          if (_loading)
            const Center(child: CircularProgressIndicator(color: AppColors.brandPink)),

          WebViewWidget(controller: _controller),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExitButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExitButton extends StatefulWidget {
  const ExitButton({super.key});

  @override
  State<ExitButton> createState() => _ExitButtonState();
}

class _ExitButtonState extends State<ExitButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showTooltip = false;
  int _presses = 0;

  void onTapUp() {
    if (_controller.value == _controller.upperBound) return;

    if (!_showTooltip) {
      setState(() {
        _showTooltip = true;
      });
    }

    // Keep showing tooltip if button is pressed again within 2s
    _presses += 1;
    int n = _presses;
    Timer(Duration(seconds: 2), () {
      if (_controller.value == _controller.upperBound) return;

      if (n == _presses) {
        setState(() {
          _showTooltip = false;
        });

        _presses = 0;
      }
    });

    _controller.reset();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapUp,

      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            children: [
              CustomPaint(
                foregroundPainter: ProgressRingPainter(
                  progress: _controller.value,
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
              if (_showTooltip)
                Container(
                  margin: const .only(left: 4),
                  padding: const .symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: .circular(4),
                  ),
                  child: const Text(
                    "Hold down the button to exit!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: .none,
                      // TODO: add font
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  ProgressRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return; // Don't draw anything if not being held

    const strokeWidth = 2.0;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Shrink the drawing rectangle slightly so the stroke isn't clipped
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
