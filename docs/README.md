# 📋 Répartition des Rôles et Responsabilités de l'Équipe SaveBabe

Bienvenue dans l'espace de documentation d'équipe du projet **SaveBabe**.

Afin d'assurer une collaboration fluide et modulaire sur l'application, les tâches ont été réparties en 5 rôles clés. Chaque responsable dispose d'un document dédié détaillant le contexte, le périmètre, les fichiers cibles, les étapes pas à pas et les critères de validation.

---

## 👥 Rôles et Fiches de Mission

| Rôle | Fiche de Mission | Périmètre Clé |
|------|------------------|---------------|
| **Responsable Notifications** | [Responsable_Notifications.md](./Responsable_Notifications.md) | Notifications locales quotidiennes, conseils du jour selon la semaine de grossesse, rappels de rendez-vous médicaux et compte à rebours vers la DPA. |
| **Responsable Sécurité** | [Responsable_Securite.md](./Responsable_Securite.md) | Chiffrement AES-256 des boîtes Hive avec clé stockée dans le Keystore/Keychain, audit Firebase pour interdire les données médicales en clair, suppression des logs sensibles. |
| **Responsable Intégration IA** | [Responsable_Integration_IA.md](./Responsable_Integration_IA.md) | Remplacement du moteur simuler par une API réelle (Google Gemini / OpenAI), contextualisation médicale subsaharienne, respect strict des préférences de confidentialité (`aiPrivacy`). |
| **Responsable Structuration & Documentation** | [Responsable_Structuration_Documentation.md](./Responsable_Structuration_Documentation.md) | Refonte du `README.md` principal, rédaction de l'architecture logicielle (`ARCHITECTURE.md`), guide de contribution (`CONTRIBUTING.md`) et dictionnaire des données (`DATA_DICTIONARY.md`). |
| **Responsable Suivi de Grossesse** | [Responsable_Suivi_Grossesse.md](./Responsable_Suivi_Grossesse.md) | Moteur obstétrique (calcul SA, CPN selon normes OMS), guide de nutrition locale africaine, dépistage des signaux d'alerte vitaux (Red Flags) et suivi des constantes vitales. |

---

## 🎯 Principes Communs à Tous les Responsables

1. **Offline-First** : L'application doit rester utilisable même sans connexion Internet.
2. **Confidentialité absolue** : Les données médicales sont privées et protégées par défaut.
3. **Respect de l'Architecture** : Séparation stricte entre `core/` (services communs, thème, état global) et `features/` (modules métier).
4. **Zéro Warning Dart** : Tout code produit doit passer `flutter analyze` sans warning.
