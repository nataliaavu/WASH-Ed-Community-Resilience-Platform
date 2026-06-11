// ── Name Validator ─────────────────────────────────────────────────────────
// Shared utility for validating user-entered names.
// Used in setup_page.dart (onboarding) and personal_details_page.dart (profile).

class NameValidator {
  NameValidator._();

  // ── Blocked words list ───────────────────────────────────────────────────
  // Common English and Filipino swear/offensive words.
  // Add more as needed — all checked case-insensitively.

  static const List<String> _blockedWords = [
    // English profanity
    'fuck', 'f*ck', 'fck', 'fucker', 'fucking',
    'shit', 'sh*t', 'bullshit',
    'ass', 'asshole', 'arse',
    'bitch', 'b*tch',
    'bastard',
    'damn', 'dammit',
    'crap',
    'piss',
    'cock', 'dick', 'prick',
    'pussy', 'cunt',
    'whore', 'slut', 'hoe',
    'nigger', 'nigga',
    'retard', 'retarded',
    'idiot', 'moron', 'imbecile', 'stupid',
    'loser', 'ugly', 'fat', 'dumb',
    'hate', 'kill', 'die', 'death',
    'sex', 'sexy', 'porn',

    // Filipino profanity / offensive words
    'putang', 'putangina', 'puta', 'p*ta',
    'gago', 'gaga',
    'bobo', 'boba',
    'tanga', 'tang',
    'ulol',
    'hinayupak',
    'leche', 'letse',
    'shet',
    'punyeta',
    'pesteng',
    'animal',
    'hayop',
    'inutil',
    'bwisit',
    'lintik',
    'kupal',
    'tarantado',
    'torpe',
    'pakyu',
    'pakshet',
  ];

  // ── Validate ──────────────────────────────────────────────────────────────
  // Returns null if the name is valid.
  // Returns an error message string if the name is invalid.

  static String? validate(String name) {
    final trimmed = name.trim();

    // Must not be empty
    if (trimmed.isEmpty) {
      return 'Please enter your name.';
    }

    // Must be at least 2 characters
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters.';
    }

    // Must not exceed 30 characters
    if (trimmed.length > 30) {
      return 'Name must be 30 characters or less.';
    }

    // Must only contain letters, spaces, hyphens, apostrophes
    // (covers names like "Maria-Jose" or "O'Brien")
    final validChars = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$");
    if (!validChars.hasMatch(trimmed)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes.';
    }

    // Check for blocked words — case insensitive, whole-word matching
    final lowerName = trimmed.toLowerCase();
    for (final word in _blockedWords) {
      // Check if the blocked word appears as a standalone word or substring
      if (lowerName.contains(word.toLowerCase())) {
        return 'Please enter an appropriate name.';
      }
    }

    return null; // valid
  }
}