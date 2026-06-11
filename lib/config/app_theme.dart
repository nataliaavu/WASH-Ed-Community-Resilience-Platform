import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WASH-Ed App Theme
// Based on WASH-Ed Branding Guidelines v1.0 (March 2026)
// ─────────────────────────────────────────────────────────────────────────────

// ── Colour tokens ─────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Brand primaries
  static const Color brandBlue   = Color(0xFF1A47C8); // Primary UI: nav, buttons, card headers
  static const Color deepBlue    = Color(0xFF0F2EA8); // Hover/active states, footer
  static const Color lightBlue   = Color(0xFF3D6EF0); // Tints, progress bars, link hover
  static const Color brandPink   = Color(0xFFE8177A); // Accent: badges, labels, tags
  static const Color brandYellow = Color(0xFFF5C800); // Impact stats, highlight boxes

  // Backgrounds & surfaces
  static const Color white       = Color(0xFFFFFFFF); // Cards, forms, reading panels
  static const Color offWhite    = Color(0xFFF7F8FC); // Screen/page background
  static const Color border      = Color(0xFFE0E4F0); // Card borders, dividers, inputs

  // Text
  static const Color textDark    = Color(0xFF1A1A2E); // Body text — never use pure black
  static const Color textMid     = Color(0xFF444466); // Captions, metadata, supporting text

  // Semantic / flood-alert colours (kept in theme so widgets reference one source)
  static const Color floodWatch      = Color(0xFFFFF9C4);
  static const Color floodWarning    = Color(0xFFFFE0B2);
  static const Color floodEmergency  = Color(0xFFFFCDD2);
  static const Color floodClear      = Color(0xFFC3EB9A);

  // Misc
  static const Color errorRed    = Color(0xFFF44336);
}

// ── Gradient tokens ───────────────────────────────────────────────────────────

class AppGradients {
  AppGradients._();

  /// Used on Learn, Prepare, and profile screens as the page background.
  static const LinearGradient pageBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8D5F0), Color(0xFFFFE4D6)],
  );

  /// Used on Onboarding splash screens.
  static const LinearGradient onboarding = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3F2FD), Color(0xFFFFFDE7)],
  );

  /// Used on profile/personal-details screen.
  static const LinearGradient profileBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFCE4EC), Color(0xFFF3E5F5)],
  );
}

// ── Spacing tokens ────────────────────────────────────────────────────────────

class AppSpacing {
  AppSpacing._();

  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 40;
}

// ── Border-radius tokens ──────────────────────────────────────────────────────

class AppRadius {
  AppRadius._();

  static const double sm   = 8;   // Buttons, inputs, small chips
  static const double md   = 12;  // Cards, panels, modals
  static const double lg   = 20;  // Larger cards (home widgets)
  static const double xl   = 24;  // Header banners (Prepare, Learn)
  static const double pill = 20;  // Badge/tag pills
}

// ── Text styles ───────────────────────────────────────────────────────────────
//
// Montserrat → headings, buttons, labels
// Arial      → body copy, forms, captions
//
// Flutter bundles "Arial" as the system sans-serif on Android; use
// fontFamily: 'Arial' and it resolves correctly. Montserrat must be
// added to pubspec.yaml under google_fonts or as a bundled asset.

class AppTextStyles {
  AppTextStyles._();

  // H1 — Screen titles (28–36 px, weight 900)
  static const TextStyle h1White = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    height: 1.1,
  );

  static const TextStyle h1Blue = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.brandBlue,
    height: 1.1,
  );

  // H2 — Section headings (20–22 px, weight 800)
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static const TextStyle h2White = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  // H3 — Card titles (15–16 px, weight 700)
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle h3Blue = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.brandBlue,
  );

  static const TextStyle h3Pink = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.brandPink,
  );

  // Module label — small eyebrow above card titles (12 px, weight 600)
  static const TextStyle moduleLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.brandPink,
    letterSpacing: 0.5,
  );

  // Body copy (13–15 px, weight 400, Arial)
  static const TextStyle body = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.5,
  );

  static const TextStyle bodyWhite = TextStyle(
    fontFamily: 'Arial',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Arial',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.4,
  );

  // Caption / metadata (10–11 px, weight 400, Arial, textMid)
  static const TextStyle caption = TextStyle(
    fontFamily: 'Arial',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMid,
  );

  // Button label (Montserrat, weight 700, 13 px)
  static const TextStyle button = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  // Nav bar label
  static const TextStyle navLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  // Section label (used in Prepare page: "Need help?", "Quick Safety Steps")
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.lightBlue,
  );
}

// ── BoxDecoration presets ─────────────────────────────────────────────────────

class AppDecorations {
  AppDecorations._();

  /// White card with yellow border — used on Home widgets and Learn module cards.
  static BoxDecoration yellowBorderCard({double radius = AppRadius.lg}) =>
      BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.brandYellow, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandYellow.withValues(alpha: 0.7),
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      );

  /// White card with light border — used on Prepare safety steps, contacts.
  static BoxDecoration lightBorderCard({double radius = AppRadius.md}) =>
      BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
      );

  /// Brand-blue header banner — used on Learn and Prepare hero sections.
  static BoxDecoration blueHeader({double radius = AppRadius.xl}) =>
      BoxDecoration(
        color: AppColors.brandBlue,
        borderRadius: BorderRadius.circular(radius),
      );

  /// Pale yellow checklist container (Prepare page).
  static const BoxDecoration checklistContainer = BoxDecoration(
    color: Color(0xFFFFFDE7),
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFFFD54F)),
    ),
  );

  /// Emergency-call card (pink tint, very rounded).
  static const BoxDecoration emergencyCard = BoxDecoration(
    color: Color(0xFFFFCDD2),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );
}

// ── ThemeData ─────────────────────────────────────────────────────────────────

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Arial', // default body font; headings override per widget
    scaffoldBackgroundColor: AppColors.offWhite,

    // ── Colour scheme ──────────────────────────────────────────────────────
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.brandBlue,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.lightBlue,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.brandPink,
      onSecondary: AppColors.white,
      secondaryContainer: Color(0xFFFCE4EC),
      onSecondaryContainer: AppColors.textDark,
      tertiary: AppColors.brandYellow,
      onTertiary: AppColors.textDark,
      tertiaryContainer: Color(0xFFFFFDE7),
      onTertiaryContainer: AppColors.textDark,
      error: AppColors.errorRed,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.textDark,
      surfaceContainerHighest: AppColors.offWhite,
      outline: AppColors.border,
    ),

    // ── AppBar ─────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.brandBlue,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
      ),
    ),

    // ── Bottom navigation bar ──────────────────────────────────────────────
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.brandPink,
      unselectedItemColor: AppColors.textMid,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      elevation: 8,
    ),

    // ── Elevated buttons — primary (brand blue) ────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandBlue,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        elevation: 0,
      ),
    ),

    // ── Text buttons ───────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brandBlue,
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    ),

    // ── Outlined buttons ───────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brandBlue,
        side: const BorderSide(color: AppColors.brandBlue),
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    ),

    // ── Text theme ─────────────────────────────────────────────────────────
    textTheme: const TextTheme(
      // Display / hero titles
      displayLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: AppColors.textDark,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppColors.textDark,
      ),
      // Section headings
      headlineLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      // Card titles
      titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: 0.3,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textMid,
        letterSpacing: 0.5,
      ),
      // Body copy
      bodyLarge: TextStyle(
        fontFamily: 'Arial',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Arial',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Arial',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textMid,
      ),
      // Labels / captions
      labelLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Arial',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textMid,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Arial',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.textMid,
      ),
    ),

    // ── Input / text fields ────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.brandBlue, width: 2),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 13,
        color: AppColors.textMid,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 13,
        color: AppColors.textMid,
      ),
    ),

    // ── Cards ──────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
    ),

    // ── Checkbox ───────────────────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.brandBlue;
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(AppColors.white),
      shape: const CircleBorder(),
      side: const BorderSide(color: AppColors.textMid, width: 1.5),
    ),

    // ── Divider ────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: AppSpacing.md,
    ),

    // ── Progress indicator ─────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brandPink,
    ),

    // ── Snackbar ───────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.deepBlue,
      contentTextStyle: AppTextStyles.bodyWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Dialog ─────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      titleTextStyle: AppTextStyles.h3,
      contentTextStyle: AppTextStyles.body,
    ),
  );

  return base;
}