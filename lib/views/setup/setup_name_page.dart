import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';

class SetupNamePage extends StatelessWidget {
  final TextEditingController controller;

  const SetupNamePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // No background — parent setup_page.dart provides the gradient
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 52),

          // ── Speech bubble ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 14),
              ],
            ),
            child: Text(
              "Hello I'm Kiko!\nWhat's your name?",
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.brandBlue,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg - 4),

          // ── Kiko image ─────────────────────────────────────────────────
          Image.asset(
            'assets/kiko/washed-kiko_sprite_whats-your-name.png',
            height: 240,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Name text field ────────────────────────────────────────────
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Type here',
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMid),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 22, vertical: 20),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}