import 'package:flutter/material.dart';

const Color kPink = Color(0xFFE91E8C);
const Color kYellow = Color(0xFFFFCC00);
const Color kNavyText = Color(0xFF1A237E);
const Color kCardBg = Color(0xFFFFFFFF);
const Color kPageBg = Color(0xFFFFF8F0); 

const LinearGradient kMascotBgGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE8D5F0), Color(0xFFFFE4D6)],
);

// data model 
class GameItem {
  final String title;
  final String description;
  final String  thumbnailAsset; 
  final VoidCallback? onPlay;

  const GameItem({
  required this.title,
  required this.description,
  required this.thumbnailAsset,
  this.onPlay,
  });
}

// todo: add data for games 

final List<GameItem> kGames = [
  GameItem(
    title: "Kiko's Flood Escape",
    description: 'Save Kiko and race to help him reach safety!',
    thumbnailAsset: 'assets/kiko/kikos_flood_escape_game.png',
  ),
  GameItem(
    title: "Kiko's day", 
    description: 'Join Kiko throughout his day as he teaches proper hand hygiene!', 
    thumbnailAsset: 'assets/kiko/kikos_day_game.png',
  ),
];


class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kMascotBgGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              const _HeroBanner(),
              const SizedBox(height: 20),
 
              ...kGames.map(
                (game) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _GameCard(game: game),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3D5AFE),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ready to\nPlay?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Join Kiko and help keep everyone safe!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: const Offset(0, 3),
            child: Image.asset(
              'assets/kiko/WashEd_kiko_sprite_cheer.png',
              height: 130,
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final GameItem game;
  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kYellow, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: kYellow.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GameThumbnail(assetPath: game.thumbnailAsset),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D5AFE),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  game.description,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                _PlayNowButton(onPressed: game.onPlay),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





class _GameThumbnail extends StatelessWidget {
  final String assetPath;
  const _GameThumbnail({required this.assetPath});
 
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _PlayNowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _PlayNowButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () {},
        icon: const Icon(Icons.play_arrow_rounded, size: 22),
        label: const Text(
          'Play Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3D5AFE),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}