# 🔐 Responsable Sécurité

## Contexte

SaveBabe stocke des données de santé très sensibles (grossesse, mesures biométriques, rendez-vous médicaux, informations sur le bébé). Ces données sont persistées localement via **Hive** et optionnellement synchronisées via **Firebase Auth**. L'application cible des femmes dans des contextes où la vie privée peut être vitale.

L'objectif de ce rôle est de garantir que **toutes les données sensibles sont chiffrées au repos** et que **Firebase ne reçoit jamais de données médicales en clair**.

---

## Périmètre d'exécution

| Domaine | Action requise |
|---------|----------------|
| **Chiffrement Hive** | Chiffrer toutes les boîtes avec une clé AES-256 |
| **Clé de chiffrement** | Générer et stocker la clé dans le Keystore (Android) / Keychain (iOS) |
| **Firebase** | S'assurer qu'aucune donnée médicale ne transite vers Firestore/RTDB |
| **Logs & debug** | Interdire tout `print()` ou `debugPrint()` affichant des données utilisateur |
| **Hashing** | Hasher les identifiants avant usage comme clé Firebase si nécessaire |

---

## Fichiers concernés

### À lire / comprendre en premier

| Fichier | Rôle |
|---------|------|
| `lib/core/services/local_storage_service.dart` | Service Hive (toutes les boîtes sont ouvertes ici) |
| `lib/core/constants/app_keys.dart` | Noms des boîtes Hive et clés utilisées |
| `lib/core/state/app_user_notifier.dart` | Lit et écrit les données dans Hive |
| `lib/core/services/auth_service.dart` | Gère Firebase Auth (UID, email) |
| `lib/core/state/app_user_state.dart` | Modèles de données sensibles |
| `pubspec.yaml` | Dépendances existantes (`crypto: ^3.0.3` déjà présent) |
| `lib/firebase_options.dart` | Config Firebase |

### À créer

```
lib/core/services/encryption_service.dart   ← gestion clé AES + chiffrement
```

---

## Étapes d'implémentation

### Étape 1 — Ajouter la dépendance de Keystore

Dans `pubspec.yaml` :

```yaml
flutter_secure_storage: ^9.2.2
```

> `crypto` est déjà présent dans le projet pour le hashing SHA-256.

---

### Étape 2 — Créer `lib/core/services/encryption_service.dart`

Ce service gère la génération et la récupération sécurisée de la clé Hive :

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EncryptionService {
  static const _keyName = 'savebabe_hive_key';
  final FlutterSecureStorage _storage;

  const EncryptionService(this._storage);

  /// Retourne la clé AES-256 existante ou en génère une nouvelle.
  Future<HiveCipher> getHiveCipher() async {
    String? encoded = await _storage.read(key: _keyName);
    if (encoded == null) {
      final key = Hive.generateSecureKey(); // 32 bytes aléatoires
      encoded = base64UrlEncode(key);
      await _storage.write(key: _keyName, value: encoded);
    }
    final keyBytes = base64Url.decode(encoded);
    return HiveAesCipher(keyBytes);
  }
}
```

---

### Étape 3 — Chiffrer toutes les boîtes dans `local_storage_service.dart`

Modifier `LocalStorageServiceImpl.init()` pour ouvrir chaque boîte avec le cipher :

```dart
// Avant (non chiffré) :
await Hive.openBox(boxName);

// Après (chiffré) :
final cipher = await _encryptionService.getHiveCipher();
await Hive.openBox(boxName, encryptionCipher: cipher);
```

L'implémentation doit recevoir l'`EncryptionService` en injection de dépendance :

```dart
class LocalStorageServiceImpl implements LocalStorageService {
  final EncryptionService _encryptionService;
  LocalStorageServiceImpl(this._encryptionService);
  // ...
}
```

---

### Étape 4 — Audit Firebase : aucune donnée médicale en clair

Vérifier tous les fichiers du projet :

```bash
# Chercher tout envoi vers Firestore ou RTDB
grep -r "FirebaseFirestore\|firestore()\|database()" lib/
grep -r "collection\|document\|set(\|update(" lib/
```

**Règle** : Firebase Auth n'est utilisé que pour l'authentification (UID + email). Aucun champ de `AppUserState` (mesures, RDV, bébé, grossesse) ne doit être envoyé vers Firebase.

Si un envoi existe, le supprimer ou le remplacer par le stockage Hive.

---

### Étape 5 — Supprimer tous les prints de données sensibles

```bash
# Identifier les prints suspects
grep -rn "print\|debugPrint" lib/
```

Remplacer les logs qui affichent des données utilisateur par des logs neutres ou les supprimer en release :

```dart
// ❌ Interdit
debugPrint('User state: ${state.toJson()}');

// ✅ Autorisé
debugPrint('[LocalStorage] Sauvegarde réussie');
```

---

### Étape 6 — Hashing de l'UID Firebase (si utilisé comme clé)

Si l'UID Firebase est utilisé comme clé de stockage ou d'accès :

```dart
import 'package:crypto/crypto.dart';
import 'dart:convert';

String hashUid(String uid) {
  final bytes = utf8.encode(uid);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

> `crypto` est déjà dans `pubspec.yaml`.

---

## Règles importantes

- La clé AES ne doit **jamais** apparaître dans les logs.
- Si `flutter_secure_storage` échoue (rare), ne pas fallback vers un stockage non sécurisé — lever une exception.
- En mode debug, on peut logger des événements neutres, **jamais des données utilisateur**.
- Les boîtes Hive chiffrées ne sont pas lisibles avec un lecteur Hive standard (c'est l'objectif).

---

## Critères de validation

- [ ] Toutes les boîtes Hive sont ouvertes avec `HiveAesCipher`
- [ ] La clé est stockée dans `FlutterSecureStorage` (Keystore/Keychain natif)
- [ ] Aucun `print()` n'expose de données médicales ou personnelles
- [ ] `grep -r "FirebaseFirestore" lib/` ne retourne aucun résultat (ou les résultats sont audités et approuvés)
- [ ] Un effacement d'application (désinstallation) supprime la clé du Keystore
- [ ] La clé est recréée proprement si le Keystore est vidé (première install sur nouvel appareil)
