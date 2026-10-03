# 🤖 Responsable Intégration IA

## Contexte

SaveBabe dispose actuellement d'un assistant IA **simulé** : `AiKnowledgeService` répond à des questions via un simple matching de mots-clés hardcodé. L'objectif de ce rôle est de remplacer ce système par une **vraie API d'IA** (Google Gemini recommandé, ou OpenAI/Groq en alternative), tout en respectant la vie privée de l'utilisatrice.

L'écran de chat (`ChatScreen`) et l'écran vocal (`VoiceScreen`) sont déjà en place côté UI.

---

## Périmètre d'exécution

| Domaine | Action requise |
|---------|----------------|
| **Remplacement du moteur IA** | Remplacer `AiKnowledgeService` par un appel API réel |
| **Prompt système** | Définir un contexte médical/grossesse pour l'IA |
| **Gestion du contexte** | Injecter les données de la grossesse dans le prompt |
| **Historique de conversation** | Stocker/récupérer l'historique selon `aiPrivacy.history` |
| **Anonymisation** | Masquer le nom réel si `aiPrivacy.anonymize == true` |
| **Gestion d'erreur** | Fallback offline propre si l'API est indisponible |

---

## Fichiers concernés

### À lire / comprendre en premier

| Fichier | Rôle |
|---------|------|
| `lib/features/ai_assistant/domain/services/ai_knowledge_service.dart` | Implémentation actuelle à remplacer |
| `lib/features/ai_assistant/presentation/screens/chat_screen.dart` | Écran de chat (appelle le service) |
| `lib/features/ai_assistant/presentation/screens/voice_screen.dart` | Écran vocal (STT → service → TTS) |
| `lib/core/state/app_user_state.dart` | `AiPrivacySettings` + données grossesse |
| `lib/core/state/app_user_provider.dart` | Accès à l'état depuis les providers |
| `lib/core/services/local_storage_service.dart` | Pour sauvegarder l'historique (box `chatHistoryBox`) |
| `lib/core/constants/app_keys.dart` | Clé `chatHistoryBox` |
| `lib/core/network/network_info.dart` | Vérifier la connectivité avant l'appel API |

### À créer

```
lib/features/ai_assistant/
├── data/
│   ├── ai_api_client.dart          ← client HTTP vers l'API IA
│   └── chat_repository_impl.dart   ← implémentation du repo
├── domain/
│   ├── entities/
│   │   └── chat_message.dart       ← entité message (role, content, ts)
│   ├── repositories/
│   │   └── chat_repository.dart    ← interface abstraite
│   └── services/
│       └── ai_service.dart         ← remplace AiKnowledgeService
lib/core/constants/
│   └── ai_prompts.dart             ← prompts système centralisés
```

---

## Étapes d'implémentation

### Étape 1 — Choisir et configurer l'API

**Option recommandée : Google Gemini**

Dans `pubspec.yaml` :
```yaml
google_generative_ai: ^0.4.6
```

> Alternative : utiliser le package `http` (déjà utilisable) pour appeler OpenAI ou Groq via REST.

**Stocker la clé API de manière sécurisée** :
- Ne pas hardcoder la clé dans le code source.
- Utiliser `flutter_dotenv` ou `--dart-define` au build :
  ```bash
  flutter run --dart-define=GEMINI_API_KEY=AIzaSy...
  ```
- Accéder dans le code : `const String.fromEnvironment('GEMINI_API_KEY')`

---

### Étape 2 — Définir l'entité `ChatMessage`

**Fichier** : `lib/features/ai_assistant/domain/entities/chat_message.dart`

```dart
enum ChatRole { user, assistant }

class ChatMessage {
  final String id;
  final ChatRole role;
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => { ... };
  factory ChatMessage.fromJson(Map<dynamic, dynamic> json) => ...;
}
```

---

### Étape 3 — Créer les prompts système dans `ai_prompts.dart`

**Fichier** : `lib/core/constants/ai_prompts.dart`

```dart
class AiPrompts {
  /// Génère le prompt système selon l'état de la grossesse.
  static String systemPrompt({
    required int semaines,
    required bool anonymize,
    required String name,
    required bool medicalContext,
  }) {
    final prenom = anonymize ? 'cette utilisatrice' : name;
    return '''
Tu es SageBabe, une sage-femme virtuelle bienveillante spécialisée dans le suivi de grossesse en Afrique de l'Ouest.
Tu parles toujours en français, avec un ton chaleureux et rassurant.
Tu t'adresses à $prenom, qui est à la semaine $semaines de sa grossesse.
Tu donnes des conseils adaptés au contexte africain (alimentation locale, accès aux soins, paludisme, etc.).
En cas de symptôme grave (saignement, perte de conscience, fièvre élevée), tu recommandes toujours de consulter en urgence.
${medicalContext ? 'Tu peux répondre à des questions médicales détaillées.' : 'Limite tes réponses aux conseils généraux.'}
Tu ne dois jamais diagnostiquer, prescrire de médicaments ou remplacer un professionnel de santé.
    ''';
  }
}
```

---

### Étape 4 — Créer `AiApiClient`

**Fichier** : `lib/features/ai_assistant/data/ai_api_client.dart`

```dart
class AiApiClient {
  final String _apiKey;

  AiApiClient(this._apiKey);

  Future<String> sendMessage({
    required String systemPrompt,
    required List<ChatMessage> history,
    required String userMessage,
  }) async {
    // Avec Gemini :
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    final chat = model.startChat(
      history: history.map((m) => Content(m.role.name, [TextPart(m.content)])).toList(),
      systemInstruction: Content.system(systemPrompt),
    );
    final response = await chat.sendMessage(Content.text(userMessage));
    return response.text ?? 'Désolée, je n\'ai pas pu générer une réponse.';
  }
}
```

---

### Étape 5 — Créer `AiService` (remplace `AiKnowledgeService`)

**Fichier** : `lib/features/ai_assistant/domain/services/ai_service.dart`

```dart
class AiService {
  final AiApiClient _client;
  final LocalStorageService _storage;
  final NetworkInfo _network;

  AiService(this._client, this._storage, this._network);

  Future<String> ask({
    required String query,
    required AppUserState userState,
    required List<ChatMessage> history,
  }) async {
    // 1. Vérifier la connectivité
    if (!await _network.isConnected) {
      return _fallbackOffline(query);
    }

    // 2. Construire le prompt système
    final sa = userState.lmp.isNotEmpty
        ? DateTime.now().difference(DateTime.parse(userState.lmp)).inDays ~/ 7
        : 0;
    final prompt = AiPrompts.systemPrompt(
      semaines: sa,
      anonymize: userState.aiPrivacy.anonymize,
      name: userState.name,
      medicalContext: userState.aiPrivacy.medical,
    );

    // 3. Appel API
    final response = await _client.sendMessage(
      systemPrompt: prompt,
      history: history,
      userMessage: query,
    );

    // 4. Sauvegarder l'historique si autorisé
    if (userState.aiPrivacy.history) {
      _saveHistory(history, query, response);
    }

    return response;
  }

  String _fallbackOffline(String query) {
    // Réutiliser l'ancienne logique de AiKnowledgeService comme fallback
    return const AiKnowledgeService().answer(query);
  }
}
```

---

### Étape 6 — Mise à jour des écrans

Dans `ChatScreen` et `VoiceScreen` :
- Remplacer l'appel à `AiKnowledgeService().answer(query)` par `AiService.ask(...)`
- Passer l'`AppUserState` et l'historique en paramètre
- Afficher un indicateur de chargement pendant l'appel API
- Gérer les erreurs réseau avec un message bienveillant

---

## Règles importantes

- **Consentement IA** : ne jamais appeler l'API si `state.consent.ai == false`. Retourner un message expliquant que l'IA est désactivée.
- **Anonymisation** : si `state.aiPrivacy.anonymize == true`, ne pas envoyer le nom réel dans le prompt.
- **Historique** : ne stocker l'historique que si `state.aiPrivacy.history == true`.
- **Données médicales** : ne jamais envoyer les mesures biométriques brutes (tensions, poids) à l'API sans le consentement explicite (`state.aiPrivacy.medical`).
- **Fallback** : toujours fournir une réponse, même offline, via `AiKnowledgeService` existant.

---

## Critères de validation

- [ ] L'IA répond avec du contexte lié à la semaine de grossesse
- [ ] Aucun appel API si `consent.ai == false`
- [ ] Le nom de l'utilisatrice est masqué si `aiPrivacy.anonymize == true`
- [ ] En mode offline, le fallback `AiKnowledgeService` est utilisé
- [ ] La clé API n'est pas dans le code source (utiliser `--dart-define`)
- [ ] L'historique est sauvegardé dans Hive uniquement si `aiPrivacy.history == true`
- [ ] Les erreurs API affichent un message bienveillant à l'utilisatrice
