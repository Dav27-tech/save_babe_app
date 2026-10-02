/// Chaînes de texte statiques de l'application
/// (version française par défaut)
abstract final class AppStrings {
  // ── App ────────────────────────────────────────────────────
  static const String appName = 'SaveBabe';
  static const String appTagline = 'Votre grossesse, votre tranquillité.';
  static const String appSubTagline =
      'Un accompagnement simple, privé et accessible, même sans internet.';

  // ── Navigation ─────────────────────────────────────────────
  static const String tabHome = 'Accueil';
  static const String tabTracking = 'Grossesse';
  static const String tabAppointments = 'Rendez-vous';
  static const String tabBaby = 'Bébé';
  static const String tabProfile = 'Profil';

  // ── Commun ─────────────────────────────────────────────────
  static const String btnContinue = 'Continuer';
  static const String btnSave = 'Enregistrer';
  static const String btnCancel = 'Annuler';
  static const String btnBack = 'Retour';
  static const String btnAdd = 'Ajouter';
  static const String btnDelete = 'Supprimer';
  static const String privateBadge = 'Vos données restent privées';
  static const String encryptedBadge = 'Données chiffrées';
  static const String offlineBadge = 'Hors connexion';

  // ── Erreurs ────────────────────────────────────────────────
  static const String errorStorage = 'Erreur de stockage';
  static const String errorNetwork = 'Pas de connexion réseau';
  static const String errorOcr = "Impossible de lire l'image";
  static const String errorAudio = 'Microphone non disponible';
  static const String errorGeneric = 'Une erreur est survenue';
}
