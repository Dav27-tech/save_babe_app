# 🔔 Responsable Notifications

## Contexte

SaveBabe est une application Flutter de suivi de grossesse destinée aux femmes en Afrique subsaharienne. Elle fonctionne **offline-first** (stockage Hive local) et utilise Firebase Auth pour l'authentification.

L'objectif de ce rôle est d'implémenter un **système de notifications locales** (pas de push distant) qui informe et accompagne l'utilisatrice chaque jour de sa grossesse : conseils du matin, rappels de rendez-vous, et compte à rebours vers la date d'accouchement estimée.

---

## Périmètre d'exécution

| Type | Description |
|------|-------------|
| **Notifications quotidiennes** | Conseil ou astuce du jour envoyé chaque matin |
| **Rappels rendez-vous** | Alerte J-7, J-3, J-1 et le jour J avant un rendez-vous |
| **Date d'accouchement (DPA)** | Rappel hebdomadaire du nombre de semaines restantes |
| **Suivi bébé postnatal** | Si un bébé est enregistré, rappels de pesée, vaccins, etc. |

---

## Fichiers concernés

### À lire / comprendre en premier

| Fichier | Rôle |
|---------|------|
| `lib/core/state/app_user_state.dart` | Contient `AppUserState` avec `lmp`, `appointments`, `baby` |
| `lib/core/state/app_user_provider.dart` | Provider Riverpod exposant `appUserStateNotifierProvider` |
| `lib/core/state/app_user_notifier.dart` | Notifier qui lit/écrit l'état dans Hive |
| `lib/core/constants/app_keys.dart` | Clés Hive utilisées pour le stockage |
| `pubspec.yaml` | Dépendances à compléter |
| `lib/main.dart` | Point d'entrée à modifier pour l'init |

### À créer

```
lib/core/services/notification_service.dart
lib/features/notifications/data/pregnancy_tips.dart
lib/features/notifications/domain/notification_scheduler.dart
```

---

## Étapes d'implémentation

### Étape 1 — Ajouter la dépendance dans `pubspec.yaml`

```yaml
flutter_local_notifications: ^17.0.0
timezone: ^0.9.4
```

Puis : `flutter pub get`

---

### Étape 2 — Créer `lib/core/services/notification_service.dart`

Service abstrait + implémentation :

```dart
abstract class NotificationService {
  Future<void> init();
  Future<void> scheduleDaily({required int id, required String title, required String body, required Time time});
  Future<void> scheduleOnDate({required int id, required String title, required String body, required DateTime dateTime});
  Future<void> cancelAll();
  Future<void> cancel(int id);
}
```

Points clés de l'implémentation :
- Demander la permission Android 13+ (`requestNotificationsPermission`)
- Canal Android : `channelId = 'savebabe_main'`, importance HIGH
- Utiliser `zonedSchedule` pour les rappels datés

---

### Étape 3 — Créer `lib/features/notifications/data/pregnancy_tips.dart`

```dart
class PregnancyTip {
  final int weekMin;
  final int weekMax;
  final String tip; // max 120 caractères
}

const List<PregnancyTip> kPregnancyTips = [
  PregnancyTip(weekMin: 1,  weekMax: 12, tip: 'Prenez votre acide folique chaque matin.'),
  PregnancyTip(weekMin: 13, weekMax: 27, tip: 'Dormez sur le côté gauche pour améliorer la circulation.'),
  // ... au moins 20 conseils couvrant les 40 semaines
];
```

Créer **au minimum 20 conseils** couvrant les 3 trimestres (hydratation, paludisme, nutrition locale africaine, repos, mouvements du bébé).

---

### Étape 4 — Créer `lib/features/notifications/domain/notification_scheduler.dart`

```dart
class NotificationScheduler {
  final NotificationService _service;
  NotificationScheduler(this._service);

  Future<void> scheduleAll(AppUserState state) async {
    await _service.cancelAll();
    if (!state.consent.health) return; // respecter le consentement
    await _scheduleDailyTip(state);
    await _scheduleAppointmentReminders(state.appointments);
    await _scheduleDpaReminder(state.lmp);
  }

  // Conseil du matin à 8h00 selon semaine de grossesse
  Future<void> _scheduleDailyTip(AppUserState state) async { ... }

  // Rappels J-7, J-3, J-1 pour chaque appointment
  Future<void> _scheduleAppointmentReminders(List<Appointment> appointments) async { ... }

  // Rappel hebdomadaire : semaines restantes avant DPA
  Future<void> _scheduleDpaReminder(String lmp) async { ... }
}
```

Calculs clés :
```dart
// DPA = LMP + 280 jours
final dpa = DateTime.parse(state.lmp).add(const Duration(days: 280));
// Semaine actuelle
final sa = DateTime.now().difference(DateTime.parse(state.lmp)).inDays ~/ 7;
```

---

### Étape 5 — Initialiser dans `lib/main.dart`

Après `await Firebase.initializeApp(...)` :

```dart
final notifService = NotificationServiceImpl();
await notifService.init();
final scheduler = NotificationScheduler(notifService);
await scheduler.scheduleAll(container.read(appUserStateNotifierProvider));
```

---

### Étape 6 — Replanifier à chaque modification d'état

Dans `lib/core/state/app_user_notifier.dart`, après chaque `_save()` :

```dart
unawaited(NotificationScheduler(_notifService).scheduleAll(state));
```

---

## Règles importantes

- Toutes les notifications sont **locales** — aucune donnée ne quitte l'appareil.
- Ne rien programmer si `state.consent.health == false`.
- IDs stables : utiliser un hash de `appointment.id` pour éviter les doublons.
- Tester sur Android API 33+ (permission notification obligatoire).

---

## Critères de validation

- [ ] Notification quotidienne à 8h00 avec conseil adapté à la semaine de grossesse
- [ ] Rappels J-7, J-3 et J-1 pour chaque rendez-vous de `state.appointments`
- [ ] Rappel hebdomadaire avec semaines restantes avant la DPA
- [ ] Aucune notification si `consent.health == false`
- [ ] Init sans crash sur Android et iOS
