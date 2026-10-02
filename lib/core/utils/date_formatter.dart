/// Utilitaires de formatage de dates pour SaveBabe
/// Porte les fonctions weeksOf() et dueDate() du store React
class DateFormatter {
  const DateFormatter._();

  /// Calcule le nombre de semaines de grossesse depuis la DDR (date des dernières règles).
  /// Retourne 24 par défaut si lmp est vide ou invalide.
  static int weeksOf(String lmp) {
    if (lmp.isEmpty) return 24;
    try {
      final date = DateTime.parse(lmp);
      final days = DateTime.now().difference(date).inDays;
      final weeks = days ~/ 7;
      return weeks.clamp(1, 42);
    } catch (_) {
      return 24;
    }
  }

  /// Calcule la date prévue d'accouchement (DDR + 280 jours).
  /// Retourne une chaîne vide si lmp est vide.
  static String dueDate(String lmp) {
    if (lmp.isEmpty) return '';
    try {
      final date = DateTime.parse(lmp);
      final due = date.add(const Duration(days: 280));
      final d = due.day.toString().padLeft(2, '0');
      final m = due.month.toString().padLeft(2, '0');
      return '$d/$m/${due.year}';
    } catch (_) {
      return '';
    }
  }

  /// Formate une date ISO en format français (dd/MM/yyyy)
  static String formatFR(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  /// Formate une date en mois abrégé français (ex: "oct.")
  static String monthShort(DateTime date) {
    const months = [
      'jan.', 'fév.', 'mar.', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sep.', 'oct.', 'nov.', 'déc.'
    ];
    return months[date.month - 1];
  }

  /// Retourne le trimestre actuel (1, 2 ou 3) selon la semaine
  static int trimester(int week) {
    if (week < 14) return 1;
    if (week < 28) return 2;
    return 3;
  }
}
