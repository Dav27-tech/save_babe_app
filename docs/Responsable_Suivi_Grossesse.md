# 🤰 Responsable Suivi de Grossesse

## Contexte

Le suivi de grossesse est le cœur fonctionnel et clinique de SaveBabe. L'application accompagne les futures mamans tout au long de leurs 40 semaines d'aménorrhée (SA), ainsi qu'en période post-partum. 

Dans le contexte subsaharien et panafricain, ce suivi doit intégrer des réalités locales : aliments traditionnels riches en nutriments (feuilles de moringa, manioc, baobab, niébé), prévention de pathologies prévalentes (paludisme, anémie, pré-éclampsie), et reconnaissance des signes d'alerte vitaux.

L'objectif de ce rôle est d'enrichir et structurer l'expérience de suivi de grossesse : **calculs obstétriques précis**, **recommandations nutritionnelles adaptées**, **guides d'activité physique sûre**, **surveillance des biométries (poids, tension, glycémie)** et **dépistage des signaux de danger**.

---

## Périmètre d'exécution

| Module | Fonctionnalités attendues |
|--------|---------------------------|
| **Calendrier & Stades de grossesse** | Calcul précis des SA, trimestres, calendrier des consultations prénatales obligatoires (CPN 1 à 4+ selon recommandations OMS) |
| **Nutrition locale & Hydratation** | Recommandations par trimestre, aliments recommandés du terroir, aliments déconseillés, prévention des carences en fer/folates |
| **Santé & Prévention** | TPI (Traitement Préventif Intermittent du paludisme), moustiquaires imprégnées, vaccination antitétanique |
| **Exercices & Bien-être** | Mouvements adaptés (marche, étirements du bassin, postures de soulagement du dos), contre-indications |
| **Signaux de danger (Red Flags)** | Identification et mise en évidence des symptômes d'urgence (métrorragies, céphalées intenses avec œdèmes, fièvre, diminution des mouvements fœtaux) |
| **Journal des métriques** | Enregistrement et visualisation graphique des courbes de poids, tension artérielle et glycémie |

---

## Fichiers concernés

### À lire / comprendre en premier

| Fichier | Rôle |
|---------|------|
| `lib/core/state/app_user_state.dart` | Modèles `AppUserState`, `Measure`, `Appointment` |
| `lib/core/utils/date_formatter.dart` | Calculs de dates (`weeksOf`, `dueDate`, `trimester`) |
| `lib/features/pregnancy_tracker/presentation/screens/tracking_screen.dart` | Écran principal de suivi de grossesse |
| `lib/features/pregnancy_tracker/presentation/screens/metrics_screen.dart` | Écran de saisie et d'historique des mesures |
| `lib/features/home/presentation/screens/home_screen.dart` | Résumé d'accueil affichant la semaine courante et les conseils |
| `lib/core/state/app_user_notifier.dart` | Méthodes d'ajout de mesures et mise à jour de la date des règles |

### À créer ou enrichir

```
lib/features/pregnancy_tracker/
├── domain/
│   ├── models/
│   │   ├── pregnancy_week_info.dart    ← métadonnées détaillées par semaine
│   │   ├── nutrition_guide.dart        ← données nutritionnelles africaines
│   │   └── danger_sign.dart            ← signes d'alerte et conduite à tenir
│   └── services/
│       └── pregnancy_calculation_service.dart ← logique obstétrique avancée
├── data/
│   └── pregnancy_dataset.dart          ← référentiel de données semaine par semaine
└── presentation/
    ├── widgets/
    │   ├── metric_chart_card.dart      ← visualisation graphique des constantes
    │   ├── danger_signs_banner.dart    ← bannière interactive de signaux d'alerte
    │   └── nutrition_recommendation_card.dart ← conseils nutritionnels locaux
    └── screens/
        ├── danger_signs_screen.dart    ← écran dédié aux signes de danger
        └── nutrition_guide_screen.dart ← guide complet alimentation & santé
```

---

## Étapes d'implémentation

### Étape 1 — Formaliser le calcul obstétrique avancé

**Fichier** : `lib/features/pregnancy_tracker/domain/services/pregnancy_calculation_service.dart`

Développer un service clinique complet :
- Calcul de la DPA (Règle de Naegele) : `LMP + 280 jours`.
- Semaine d'aménorrhée précise (SA) et jour courant (ex: 24 SA + 3 jours).
- Trimestre en cours :
  - 1er trimestre : 1 à 13 SA.
  - 2ème trimestre : 14 à 27 SA.
  - 3ème trimestre : 28 à 40+ SA.
- Échéancier officiel des Consultations Prénatales (CPN) selon le protocole OMS :
  - CPN 1 : avant 12 SA.
  - CPN 2 : vers 20 SA (échographie morphologique).
  - CPN 3 : vers 26-28 SA (dépistage anémie/glycémie).
  - CPN 4+ : 32 SA, 36 SA, 38 SA, 40 SA.

---

### Étape 2 — Créer le référentiel semaine par semaine

**Fichier** : `lib/features/pregnancy_tracker/data/pregnancy_dataset.dart`

Pour chaque semaine (de 1 à 41 SA), renseigner :
- **Taille & Poids fœtal estimé** avec des analogies locales parlantes (graine de sésame, mangue sauvage, papaye, noix de coco).
- **Développement du bébé** : formation des organes, perception des sons, mouvements actifs.
- **Corps de la maman** : changements physiologiques normaux (posture, sommeil, essoufflement).
- **Conseil santé & nutrition de la semaine** : aliments locaux riches en micronutriments (fer, calcium, iode).

---

### Étape 3 — Structurer le guide de nutrition panafricaine

**Fichier** : `lib/features/pregnancy_tracker/domain/models/nutrition_guide.dart`

Fournir des fiches alimentaires concrètes :
- **Sources de Fer & Folates** : feuilles de moringa séchées, sauce gombo, haricots koki/niébé, foie bien cuit.
- **Sources d'Énergie saine** : igname, patate douce, manioc bouilli, mil, fonio.
- **Hydratation** : eau potable contrôlée, infusion de gingembre léger contre les nausées, eau de coco.
- **Aliments et pratiques à bannir** : viande ou poisson mal cuit, géophagie (consommation de kaolin/terre - risque d'anémie et d'infection parasitaire), alcool, excès d'automédication traditionnelle non dosée.

---

### Étape 4 — Dépistage et signalement des Signes de Danger

**Fichier** : `lib/features/pregnancy_tracker/domain/models/danger_sign.dart`

Intégrer les signaux d'alarme majeurs avec redirection immédiate vers l'écran d'urgence :
1. **Saignements vaginaux** (fausse couche, hématome rétroplacentaire, placenta prævia).
2. **Céphalées intenses avec troubles visuels ou œdèmes brutaux** (signes de pré-éclampsie).
3. **Fièvre élevée ou frissons** (paludisme gestationnel, infection urinaire grave).
4. **Diminution nette des mouvements fœtaux** (moins de 10 mouvements en 2 heures après 28 SA).
5. **Rupture prématurée des poches des eaux**.

Connecter ces éléments avec `EmergencyScreen` (`/emergency`) et la personne de confiance (`/invite`).

---

### Étape 5 — Enrichir l'écran de métriques (`MetricsScreen`)

Améliorer `lib/features/pregnancy_tracker/presentation/screens/metrics_screen.dart` :
- **Prise de poids** : classification de l'évolution (IMC avant grossesse et recommandation de prise pondérale).
- **Tension artérielle** : alerte visuelle si la systolique $\ge 140$ mmHg ou diastolique $\ge 90$ mmHg.
- **Glycémie à jeun** : seuil de vigilance pour diabète gestationnel.
- Historique trié par date avec affichage graphique clair (courbes simples ou jauges colorées).

---

## Règles importantes

- Toutes les recommandations médicales doivent être rigoureusement validées selon les référentiels de santé publique (OMS / Ministères de la Santé).
- Toujours rappeler à l'utilisatrice que l'application **ne remplace pas la consultation avec un médecin, une sage-femme ou un centre de santé**.
- Les analogies et le vocabulaire doivent être accessibles, clairs et respectueux des cultures locales.

---

## Critères de validation

- [ ] Calcul des SA et trimestres exact à partir de n'importe quelle date de dernières règles (`lmp`)
- [ ] Présence d'un référentiel de données pour les 40 semaines de grossesse
- [ ] Guide de nutrition intégrant les aliments du terroir subsaharien
- [ ] Module d'alerte des signes de danger relié au numéro d'urgence et à la personne de confiance
- [ ] Saisie et affichage ergonomiques des mesures de tension, poids et glycémie avec seuils de couleur
