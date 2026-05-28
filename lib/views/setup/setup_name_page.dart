import 'package:flutter/material.dart';

class SetupNamePage extends StatelessWidget {
  final TextEditingController controller;

  const SetupNamePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCE4EC), Color(0xFFF3E5F5)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 52),
            // Speech bubble
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 14),
                ],
              ),
              child: const Text(
                "Hello I'm Kiko!\nWhat's your name?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A45A0),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/kiko/WashEd_kiko_sprite_cheer.png',
              height: 290,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  hintText: 'Type here',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
