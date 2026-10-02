/// Fonctions de validation des formulaires
class Validators {
  const Validators._();

  /// Valide qu'un champ n'est pas vide
  static String? required(String? value, {String label = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label est requis';
    }
    return null;
  }

  /// Valide un mot de passe (6 caractères minimum)
  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return '6 caractères minimum';
    }
    return null;
  }

  /// Valide un numéro de téléphone ou email (présence minimale)
  static String? contact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrez un email ou numéro de téléphone';
    }
    return null;
  }

  /// Valide une date au format yyyy-MM-dd
  static String? date(String? value) {
    if (value == null || value.isEmpty) return 'Date requise';
    try {
      DateTime.parse(value);
      return null;
    } catch (_) {
      return 'Format de date invalide';
    }
  }
}
