import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

const Color kNavyText = Color(0xFF1A47C8);
const Color kYellow = Color(0xFFFFCC00);
const Color kPink = Color(0xFFE91E8C);
const Color kCardBg = Color(0xFFFFFFFF);

const LinearGradient kPageGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE8D5F0), Color(0xFFFFE4D6)],
);

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
        decoration: const BoxDecoration(gradient: kPageGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _HeaderBanner()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
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
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF1A47C8), Color(0xFF1A47C8)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ready to\nPlay?',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join Kiko and help keep\neveryone safe!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
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
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kYellow, width: 2),
        boxShadow: [
          BoxShadow(
            color: kYellow.withValues(alpha: 1),
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.asset(game.thumbnailAsset, fit: BoxFit.cover),
            ),
          ),

          // ── Info + button ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kNavyText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  game.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
                      backgroundColor: kNavyText,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          backgroundColor: kPink,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Center(child: CircularProgressIndicator(color: kPink)),
          ],
        ),
      ),
    );
  }
}
