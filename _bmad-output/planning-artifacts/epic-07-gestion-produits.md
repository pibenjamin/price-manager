# Epic 7: Gestion des Produits et Historique

## Vue d'ensemble

Cette epic couvre les fonctionnalités de gestion des produits, l'affichage de l'historique des prix, et les opérations en bloc sur l'historique d'achats.

---

## Stories

### STORY 7.1: Dataset Initial avec Produits de Démonstration

**En tant que** développeur  
**Je veux** charger un jeu de données initial avec des produits alimentaires courants  
**Afin que** l'utilisateur puisse tester l'application dès la première ouverture

**Critères d'acceptation:**

```
DONNÉES: Le dataset inclut les produits suivants:
- Nutella (3017620422003) - Pâte à tartiner
- Coca-Cola (5449000000996) - Boisson gazeuse
- Pain de mie (3178530010303) - Boulangerie
- Lait demi-écrémé (3017620421004) - Produits laitiers
- Riz basmati (3046920027561) - Epicerie
- Chips Paprika (3228021790012) - Snacks
- Eau Evian (3057640103742) - Boissons
- Yaourt nature (3017620425033) - Produits laitiers

ÉTAT INITIAL:
- L'historique contient des achats de démonstration pour ces produits
- Les prix sont réalistes (ex: Nutella ~3.50€, Lait ~1.20€)
- Les dates sont échelonnées sur les 30 derniers jours

IMPLÉMENTATION:
- Le chargement des données se fait dans LocalStorageService.init()
- Les données sont pré-remplies uniquement si l'historique est vide
```

---

### STORY 7.2: Suppression Un par Un des Achats

**En tant qu'**utilisateur  
**Je veux** supprimer un achat individuel de mon historique  
**Afin de** corriger mes erreurs ou nettoyer mes données

**Critères d'acceptation:**

```
GIVEN: L'utilisateur est sur l'écran Historique
WHEN: Il glisse un item vers la gauche (swipe)
THEN: Un bouton "Supprimer" apparaît avec une animation
AND: En relâchant, une confirmation s'affiche
AND: Après confirmation, l'achat est supprimé avec un feedback visuel

GIVEN: L'utilisateur a cliqué sur le bouton supprimer d'un item
WHEN: Il confirme la suppression
THEN: L'item disparaît avec une animation
AND: Un SnackBar affiche "ACHAT SUPPRIMÉ"
```

---

### STORY 7.3: Suppression en Masse (Bulk Delete)

**En tant qu'**utilisateur  
**Je veux** sélectionner plusieurs achats et les supprimer d'un coup  
**Afin de** nettoyer rapidement mon historique

**Critères d'acceptation:**

```
MODE SÉLECTION:
- Un bouton dans l'appBar active le mode sélection
- Une checkbox apparaît sur chaque item de l'historique
- La barre du bas affiche le nombre d'éléments sélectionnés
- Un bouton "TOUT SÉLECTIONNER" / "TOUT DÉSÉLECTIONNER" est disponible

ACTIONS EN MASSE:
- Bouton supprimer (icône poubelle) - Supprime tous les éléments cochés
- Confirmation requise: "SUPPRIMER X ACHATS ?"
- Feedback: "X ACHATS SUPPRIMÉS"

SORTIE DU MODE:
- Bouton fermer (X) dans l'appBar
- Touche retour du système
- Désélection de tous les éléments
```

---

### STORY 7.4: Fiche Détaillée du Produit

**En tant qu'**utilisateur  
**Je veux** voir toutes les informations d'un produit en cliquant dessus  
**Afin de** avoir une vision complète avant d'acheter

**Critères d'acceptation:**

```
ACCÈS:
- Tap sur un item de l'historique ouvre la fiche produit
- Navigation avec transition fluide

INFORMATIONS AFFICHÉES:
┌─────────────────────────────────────┐
│ [IMAGE PRODUIT]                     │
│                                     │
│ NOM DU PRODUIT                      │
│ Marque: xxx                         │
│                                     │
│ ═══ NUTRITION ═══                   │
│ Nutri-Score: [A] [B] [C] [D] [E]   │
│ ℹ️ Calories: xxx kcal               │
│ ℹ️ Matières grasses: xx g            │
│ ℹ️ Sucres: xx g                     │
│ ℹ️ Sel: xx g                        │
│ ℹ️ Fibres: xx g                     │
│                                     │
│ ═══ INFORMATIONS ═══                │
│ Code-barres: xxxxxxxxxxxxx          │
│ Catégorie: xxx                       │
│ Marque: xxx                         │
│                                     │
│ [BOUTON: VOIR ÉVOLUTION PRIX]       │
│ [BOUTON: SUPPRIMER CET ACHAT]       │
└─────────────────────────────────────┘

SOURCES:
- Toutes les données proviennent de Open Food Facts API
- Les champs non disponibles affichent "Non renseigné"
```

---

### STORY 7.5: Évolution du Prix d'un Produit

**En tant qu'**utilisateur  
**Je veux** voir l'historique des prix d'un produit  
**Afin de** identifier les meilleures offres et tendances

**Critères d'acceptation:**

```
ACCÈS:
- Bouton "ÉVOLUTION PRIX" sur la fiche produit
- S'ouvre en modal ou nouvel écran

GRAPHIQUE:
- Chart type ligne (LineChart) montrant les prix dans le temps
- Axe Y: Prix en euros
- Axe X: Dates des achats
- Points de données pour chaque achat enregistré

INFORMATIONS COMPLEMENTAIRES:
┌─────────────────────────────────────┐
│ 📊 ÉVOLUTION DU PRIX                │
│                                     │
│ [GRAPHique LINe]                    │
│     ╱╲                             │
│    ╱  ╲___╱                        │
│ ──╱───────────►                    │
│                                     │
│ ┌─────────────────────────────┐     │
│ │ Prix actuel: 3.49€ 🟢       │     │
│ │ Prix moyen: 3.52€           │     │
│ │ Prix min: 2.99€ 📉          │     │
│ │ Prix max: 3.99€ 📈          │     │
│ │ Nb d'achats: 12             │     │
│ └─────────────────────────────┘     │
│                                     │
│ TABLEAU DÉTAIL:                     │
│ ┌────────┬────────┬────────┐       │
│ │ Date   │ Prix   │ Magasin │       │
│ ├────────┼────────┼────────┤       │
│ │ 15/04  │ 3.49€  │Carrefour│       │
│ │ 02/04  │ 3.29€  │Leclerc │       │
│ │ ...    │ ...    │...     │       │
│ └────────┴────────┴────────┘       │
│                                     │
│ [FERMER]                            │
└─────────────────────────────────────┘
```

---

### STORY 7.6: Back Office (Documentation)

**En tant qu'**utilisateur / développeur  
**Je veux** comprendre où se trouve le back office de l'application  
**Afin de** administrer et maintenir les données

**Note technique:**

```
L'APPLICATION N'UTILISE PAS DE BACK OFFICE TRADITIONNEL.

ARCHITECTURE ACTUELLE:
┌─────────────────┐
│   APP MOBILE    │
│   (Flutter)     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   LOCAL STORAGE │
│   (Hive - App)  │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  OPEN FOOD FACTS│
│  (API Cloud)    │
└─────────────────┘

DONNÉES LOCALES (Hive):
- products: Cache des produits scannés
- purchases: Historique des achats
- settings: Préférences utilisateur

DONNÉES CLOUD (API Open Food Facts):
- Informations nutritionnelles
- Photos produits
- Catégories

PERSISTANCE FUTURE (Phase 2):
- Supabase (Backend as a Service)
- Authentification utilisateurs
- Synchronisation multi-appareils
```

---

## US 7.7: Rétention des Données et CGU

**En tant que** développeur  
**Je veux** informer l'utilisateur de la politique de rétention  
**Afin de** respecter les exigences légales

**Note:**

```
RETENTION DES DONNÉES:
- Toutes les données sont stockées LOCALEMENT sur l'appareil
- Aucune donnée n'est transmise à des serveurs tiers
- L'utilisateur peut supprimer toutes les données via l'app
- L'application n'utilise pas de cookies ni de tracking

CGU:
- Application gratuite sans achat in-app
- Données personnelles: Aucune collectée
- Utilisation: Comparison de prix alimentaires personnelles
```

---

## Wireframes

### Écran Historique - Mode Normal
```
┌────────────────────────────────┐
│ ← HISTORIQUE          [🗑️]   │
├────────────────────────────────┤
│ ┌──────────────────────────┐   │
│ │ [✓] 🥛 Lait Demi-écrémé  │   │
│ │     1.29€ • Carrefour     │   │
│ │     15/04/2024           │   │
│ └──────────────────────────┘   │
│ ┌──────────────────────────┐   │
│ │ [ ] 🍫 Nutella           │   │
│ │     3.49€ • Leclerc      │   │
│ │     14/04/2024           │   │
│ └──────────────────────────┘   │
│ ┌──────────────────────────┐   │
│ │ [ ] 🥤 Coca-Cola         │   │
│ │     1.79€ • Auchan        │   │
│ │     12/04/2024           │   │
│ └──────────────────────────┘   │
├────────────────────────────────┤
│  [📷] [📋] [📊] [⚙️]          │
└────────────────────────────────┘
```

### Écran Historique - Mode Sélection
```
┌────────────────────────────────┐
│ ← SÉLECTION (2)        [✕]    │
├────────────────────────────────┤
│ ┌──────────────────────────┐   │
│ │ [✓] 🥛 Lait Demi-écrémé  │   │
│ │     1.29€ • Carrefour     │   │
│ │     15/04/2024           │   │
│ └──────────────────────────┘   │
│ ┌──────────────────────────┐   │
│ │ [✓] 🍫 Nutella           │   │
│ │     3.49€ • Leclerc      │   │
│ │     14/04/2024           │   │
│ └──────────────────────────┘   │
│ ┌──────────────────────────┐   │
│ │ [ ] 🥤 Coca-Cola         │   │
│ │     1.79€ • Auchan        │   │
│ │     12/04/2024           │   │
│ └──────────────────────────┘   │
├────────────────────────────────┤
│  [Tout désélectionner]         │
│  ┌──────────────────────────┐  │
│  │      🗑️ SUPPRIMER        │  │
│  └──────────────────────────┘  │
├────────────────────────────────┤
│  [📷] [📋] [📊] [⚙️]          │
└────────────────────────────────┘
```

### Fiche Produit Détaillée
```
┌────────────────────────────────┐
│ ← FICHE PRODUIT       [✕]    │
├────────────────────────────────┤
│ ┌──────────────────────────┐   │
│ │                          │   │
│ │      [IMAGE PRODUIT]     │   │
│ │                          │   │
│ └──────────────────────────┘   │
│                                │
│ PÂTE À TARTINER                │
│ Marque: Ferrero                │
│                                │
│ ═══════════════════════════    │
│ NUTRITION                      │
│ ═══════════════════════════    │
│                                │
│ NUTRI-SCORE: [A] B C D E       │
│                                │
│ ℹ️ Energie: 539 kcal          │
│ ℹ️ Matières grasses: 30g       │
│ ℹ️ Acides gras saturés: 10g   │
│ ℹ️ Glucides: 57g               │
│ ℹ️ Sucres: 56g                 │
│ ℹ️ Protéines: 6.3g             │
│ ℹ️ Sel: 0.107g                 │
│ ℹ️ Fibres: 0g                   │
│                                │
│ ═══════════════════════════    │
│ INFORMATIONS                    │
│ ═══════════════════════════    │
│                                │
│ 📊 Code-barres: 3017620422003 │
│ 🏷️ Catégorie: Pâte à tartiner │
│ 🏢 Marque: Ferrero             │
│ 🌍 Origine: Non renseigné      │
│                                │
│ ═══════════════════════════    │
│                                │
│ ┌──────────────────────────┐   │
│ │ 📈 VOIR ÉVOLUTION PRIX   │   │
│ └──────────────────────────┘   │
│                                │
├────────────────────────────────┤
│  [📷] [📋] [📊] [⚙️]          │
└────────────────────────────────┘
```

---

## Définitions Techniques

### Data Models

```dart
// Product - depuis Open Food Facts
class Product {
  String barcode;
  String name;
  String? brand;
  String? imageUrl;
  String? category;
  String? nutriScore;
  double? energyKcal;     // Calories
  double? fat;            // Matières grasses
  double? saturatedFat;   // Acides gras saturés
  double? carbohydrates;  // Glucides
  double? sugars;        // Sucres
  double? proteins;      // Protéines
  double? salt;          // Sel
  double? fibers;        // Fibres
  String? origins;
}

// Purchase - achat enregistré
class Purchase {
  String id;
  String productBarcode;
  double price;
  String store;
  DateTime purchaseDate;
  String? receiptPhotoUrl;
  DateTime createdAt;
}
```

### Endpoints API

```
Open Food Facts API:
GET https://world.openfoodfacts.org/api/v0/product/{barcode}.json

Réponse:
{
  "status": 1,
  "product": {
    "product_name": "...",
    "brands": "...",
    "image_url": "...",
    "nutriscore_grade": "e",
    "nutriments": {
      "energy-kcal_100g": 539,
      "fat_100g": 30,
      ...
    }
  }
}
```

---

## Estimation

| Story | Complexité | Temps |
|-------|------------|-------|
| 7.1 Dataset initial | Medium | 2h |
| 7.2 Suppression unitaire | Low | 1h |
| 7.3 Suppression bulk | Medium | 3h |
| 7.4 Fiche produit | High | 4h |
| 7.5 Évolution prix | High | 4h |
| 7.6 Documentation | Low | 1h |
| **Total** | | **15h** |

---

## Risques Identifiés

1. **API Open Food Facts lente** → Cache local étendu
2. **Données nutritionnelles incomplètes** → Afficher "Non renseigné"
3. **Graphique avec peu de données** → Message "Pas assez de données"
