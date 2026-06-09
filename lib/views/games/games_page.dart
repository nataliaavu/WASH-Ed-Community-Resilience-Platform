import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
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
    url: 'https://wash-ed.itch.io/wash-ed-heroes-kiko-english',
  ),
  _GameItem(
    title: "Kiko's Day",
    description:
        'Join Kiko throughout his day as he teaches proper hand hygiene!',
    thumbnailAsset: "assets/wash-ed/Kiko's Day Mini Games.png",
    url: 'https://wash-ed.itch.io/kikos-day',
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
                Text('Ready to\nPlay?', style: AppTextStyles.h1White),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Join Kiko and help keep\neveryone safe!',
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
              child: Image.asset(
                game.thumbnailAsset,
                fit: BoxFit.cover,
              ),
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
                        builder: (_) => GameWebViewPage(
                          title: game.title,
                          url: game.url,
                        ),
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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.brandPink,
          foregroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.brandPink),
              ),
          ],
        ),
      ),
    );
  }
}