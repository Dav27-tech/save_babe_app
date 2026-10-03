# 📚 Responsable Structuration et Documentation du Projet

## Contexte

SaveBabe est une application mobile Flutter conçue pour le suivi de la grossesse et du nouveau-né en Afrique subsaharienne. Le projet met en avant des principes forts : **offline-first**, **confidentialité et sécurité des données de santé**, **accessibilité vocale (STT/TTS)** et **architecture propre (Clean Architecture modulaire)**.

Pour permettre à toute l'équipe de collaborer efficacement et pérenniser la maintenance, ce rôle a pour mission de **structurer le référentiel**, **rédiger la documentation technique et fonctionnelle**, **formaliser les conventions de code et d'architecture**, et **tenir à jour le README et les guides de déploiement**.

---

## Périmètre d'exécution

| Domaine | Livrables attendus |
|---------|--------------------|
| **README principal** | Présentation complète du projet, fonctionnalités, stack, prérequis, installation, commandes |
| **Documentation d'Architecture** | Description du pattern Clean Architecture / Feature-First, gestion d'état Riverpod, navigation GoRouter |
| **Guide de Contribution** | Conventions de code (Dart Style Guide, nommage, commits conventionnels, PR workflow) |
| **Dictionnaire de Données** | Modèles du domaine (`AppUserState`, `Appointment`, `Measure`, `Baby`, etc.) et persistance Hive |
| **Guide de Déploiement / Build** | Instructions pour générer les APK/AAB Android, configurer les flavors/environnements et Firebase |

---

## Fichiers concernés

### À lire / analyser en premier

| Fichier | Rôle |
|---------|------|
| `README.md` | Fichier racine actuel (à réécrire complètement) |
| `pubspec.yaml` | Stack technologique et dépendances |
| `lib/core/` | Socle technique commun (services, routing, state, theme, constants) |
| `lib/features/` | Modules fonctionnels indépendants |
| `docs/` | Dossier des fiches de responsabilités et documentations cibles |

### À créer ou enrichir

```
docs/
├── ARCHITECTURE.md          ← Architecture logicielle, flux de données, Riverpod
├── CONTRIBUTING.md          ← Règles de contribution, style Dart, conventions Git
├── DATA_DICTIONARY.md       ← Spécification des modèles de données et stockage
├── DEPLOYMENT_GUIDE.md      ← Compilation, variables d'environnement, release
└── Responsable_*.md         ← Fiches de missions d'équipe (centralisation/index)
README.md                    ← README vitrine et technique complet à la racine
```

---

## Étapes d'implémentation

### Étape 1 — Refonte complète du `README.md`

Remplacer le template par défaut de Flutter par un document complet :
1. **Bannière et présentation** : Mission humanitaire et médicale de SaveBabe, vision offline-first.
2. **Fonctionnalités clés** :
   - Suivi personnalisé de la grossesse (SA, trimestres, taille bébé en fruits locaux).
   - Carnet de santé numérique & numérisation OCR du carnet de santé papier.
   - Assistant vocal et textuel bienveillant (IA + synthèse/reconnaissance vocale).
   - Gestion des rendez-vous et contacts d'urgence (personne de confiance, appel direct).
   - Suivi postnatal du bébé (taille, poids, tétées, sommeil, couches).
   - Protection rigoureuse de la vie privée (stockage local chiffré, consentement granulaire).
3. **Architecture technique & Stack** (Flutter 3.x, Riverpod 2.x, GoRouter, Hive, Firebase Auth, ML Kit).
4. **Guide de démarrage rapide** :
   ```bash
   flutter pub get
   flutter run
   ```
5. **Variables d'environnement & flags** (`--dart-define=GEMINI_API_KEY=...`).
6. **Structure du projet** (arborescence commentée).

---

### Étape 2 — Rédiger `docs/ARCHITECTURE.md`

Formaliser l'architecture de la codebase :
- **Pattern Feature-First** :
  - `core/` : Services transverses partagés (Auth, LocalStorage, Audio, OCR), thème, navigation, gestionnaires d'erreurs.
  - `features/<feature_name>/` : Découpage en couches `presentation/`, `domain/`, `data/`.
- **Gestion d'état avec Riverpod** :
  - `StateNotifierProvider` / `NotifierProvider` pour l'état mutable persistant (`AppUserStateNotifier`).
  - Immutabilité stricte des états (`copyWith`).
- **Routage avec GoRouter** :
  - Distinction entre `ShellRoute` (écrans avec barre de navigation inférieure) et routes modales racine (Chat, Scan, Urgence).
  - Gestion des redirections selon l'état d'onboarding (`redirect` logic).
- **Stratégie Offline-First** :
  - Priorité absolue au stockage local Hive.
  - Synchronisation conditionnelle et non bloquante.

---

### Étape 3 — Rédiger `docs/CONTRIBUTING.md`

Définir les règles du travail en équipe :
- **Conventions Git** :
  - Modèle de branches : `main`, `develop`, `feature/<nom-feature>`, `fix/<nom-bug>`.
  - Format des commits (Conventional Commits) : `feat: ...`, `fix: ...`, `docs: ...`, `refactor: ...`.
- **Qualité de code Dart** :
  - Exécution stricte de `flutter analyze` sans avertissements ni warnings.
  - Règles de formatage : `dart format .`.
  - Règles spécifiques : utiliser `withValues(alpha: ...)` au lieu de `withOpacity(...)`, préférer les constantes `const`, typer explicitement les retours publics.
- **Processus de Pull Request** :
  - Template de description de PR, checklist de validation avant merge.

---

### Étape 4 — Rédiger `docs/DATA_DICTIONARY.md`

Documenter la structure de persistance et les modèles métier :
- Détailler chaque modèle présent dans `lib/core/state/app_user_state.dart` :
  - `AppUserState` : profil, date des dernières règles (`lmp`), langue, thème, consentement.
  - `Appointment` : identifiant, titre, date, heure, lieu.
  - `Measure` : type (poids, tension, glycémie), valeur, date.
  - `HealthRecord` : données extraites du carnet de santé par OCR.
  - `Baby` & `BabyLogEntry` : suivi postnatal.
  - `ConsentSettings` & `AiPrivacySettings` : drapeaux de consentement légal et technique.
- Décrire les boîtes Hive associées (`AppKeys`) et les types stockés.

---

### Étape 5 — Rédiger `docs/DEPLOYMENT_GUIDE.md`

Détailler la chaîne de compilation et publication :
- Configuration des clés de signature Android (Keystore).
- Génération des bundles :
  ```bash
  flutter build appbundle --release
  flutter build apk --split-per-abi --release
  ```
- Configuration Firebase (`google-services.json` et `firebase_options.dart`).
- Injection des clés API sécurisées via `--dart-define`.

---

## Règles importantes

- Rédiger dans un français clair, professionnel et structuré.
- Utiliser des diagrammes Mermaid (flux, arborescence, architecture) pour faciliter la compréhension visuelle.
- Veiller à ce que les chemins de fichiers mentionnés soient rigoureusement exacts.
- Synchroniser la documentation avec les travaux des autres responsables (Notifications, Sécurité, IA, Suivi Grossesse).

---

## Critères de validation

- [ ] Le `README.md` est attrayant, exhaustif et permet à un nouvel arrivant de lancer l'application en 5 minutes
- [ ] `docs/ARCHITECTURE.md` explicite clairement le pattern Feature-First et Riverpod
- [ ] `docs/CONTRIBUTING.md` donne des règles claires de nommage, commits et PRs
- [ ] `docs/DATA_DICTIONARY.md` recense tous les modèles de données et leurs clés de stockage
- [ ] Tous les liens relatifs entre documents et fichiers de code fonctionnent
