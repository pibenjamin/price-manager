# PRIXCOURSES - Product Backlog

## Vue d'ensemble du Projet

**Nom:** PrixCourses  
**Type:** Application mobile Flutter (Android/iOS)  
**Objectif:** Comparer les prix des produits alimentaires en scannant les codes-barres  
**Style UI:** Cyberpunk (néon, fond sombre, effets glow)  
**Stack:** Flutter + Riverpod + Hive (local storage) + Open Food Facts API

---

## Épics

| # | Epic | Status | Stories |
|---|------|--------|---------|
| 1 | [Scanner de produits](#epic-1-scanner-de-produits) | ✅ Done | 2 |
| 2 | [Enregistrement d'achats](#epic-2-enregistrement-dachats) | ✅ Done | 4 |
| 3 | [Gestion de l'historique](#epic-3-gestion-de-lhistorique) | ✅ Done | 4 |
| 4 | [Statistiques et analyses](#epic-4-statistiques-et-analyses) | ✅ Done | 3 |
| 5 | [Interface Cyberpunk](#epic-5-interface-cyberpunk) | ✅ Done | 5 |
| 6 | [Données de démonstration](#epic-6-données-de-démonstration) | ✅ Done | 1 |

---

## Epic 1: Scanner de Produits

### STORY 1.1: Scan de code-barres

**En tant qu'**utilisateur  
**Je veux** scanner un produit avec mon téléphone  
**Afin de** rechercher rapidement un aliment dans la base de données

**Critères d'acceptation:**
- La caméra s'ouvre automatiquement sur l'écran Scanner
- Le cadre de scan glow (effet néon pulsant) est visible
- Une ligne de scan animée traverse le cadre
- Quand un code-barres est détecté, vibration de feedback
- Le scanner se met en pause pendant la navigation
- Le scanner reprend quand l'utilisateur revient

**Implémentation:**
```dart
MobileScannerController // barre de scan
AnimationController      // animation pulse + ligne
HapticFeedback          // retour haptique
```

---

### STORY 1.2: Entrée manuelle de code-barres

**En tant qu'**utilisateur  
**Je veux** pouvoir saisir un code-barres manuellement  
**Afin de** quand la caméra ne fonctionne pas ou pour tester

**Critères d'acceptation:**
- Bouton clavier dans l'appBar du scanner
- Dialog avec champ de saisie numérique
- Validation et recherche du produit

---

## Epic 2: Enregistrement d'Achats

### STORY 2.1: Saisie du prix

**En tant qu'**utilisateur  
**Je veux** saisir le prix du produit  
**Afin de** enregistrer le coût de mon achat

**Critères d'acceptation:**
- Champ de saisie numérique avec décimales
- Prix pré-rempli depuis le dernier achat (si existant)
- Validation: prix > 0

---

### STORY 2.2: Sélection du magasin

**En tant qu'**utilisateur  
**Je veux** choisir le magasin où j'ai acheté  
**Afin de** comparer les prix entre enseignes

**Critères d'acceptation:**
- Liste de magasins prédéfinis (Carrefour, Leclerc, Lidl, etc.)
- Option "Ajouter un nouveau..." en bas de liste
- Dialog pour saisir un nom de magasin personnalisé
- Le nouveau magasin apparaît en jaune (étoile) dans la liste

**Magasins prédéfinis:**
```
Hypermarchés:     Carrefour, Leclerc, Auchan, Casino, Intermarché, Système U
Hard Discount:     Lidl, Aldi, Netto
Bio:               Biocoop, Naturalia
Drive:             Carrefour Drive, Leclerc Drive
Local:             Super U, Proxy, Spar
```

---

### STORY 2.3: Sélection de la date

**En tant qu'**utilisateur  
**Je veux** choisir la date d'achat  
**Afin de** pouvoir enregistrer des achats passés

**Critères d'acceptation:**
- Date par défaut: aujourd'hui
- Picker de date (max 1 an en arrière)
- Affichage au format français (dd/MM/yyyy)

---

### STORY 2.4: Affichage du dernier achat

**En tant qu'**utilisateur  
**Je veux** voir mon dernier achat de ce produit  
**Afin de** comparer les prix rapidement

**Critères d'acceptation:**
- Card avec gradient cyan/violet
- Affiche: prix, magasin, date du dernier achat
- Si premier achat: message "PREMIER ACHAT DE CE PRODUIT"

---

## Epic 3: Gestion de l'Historique

### STORY 3.1: Liste des achats

**En tant qu'**utilisateur  
**Je veux** voir la liste de tous mes achats  
**Afin de** avoir une vue d'ensemble de mes dépenses

**Critères d'acceptation:**
- Liste triée par date (plus récent en haut)
- Pour chaque item: image, nom, prix, magasin, date
- Badge avec nombre d'achats du même produit (ex: "3x")
- Tap sur un item → fiche produit détaillée

---

### STORY 3.2: Suppression unitaire

**En tant qu'**utilisateur  
**Je veux** supprimer un achat de mon historique  
**Afin de** corriger mes erreurs

**Critères d'acceptation:**
- Swipe gauche sur un item
- Bouton supprimer rouge apparaît
- Confirmation avant suppression
- SnackBar "ACHAT SUPPRIMÉ"

---

### STORY 3.3: Suppression en masse

**En tant qu'**utilisateur  
**Je veux** sélectionner et supprimer plusieurs achats  
**Afin de** nettoyer rapidement mon historique

**Critères d'acceptation:**
- Bouton checkbox dans l'appBar active le mode sélection
- Checkbox sur chaque item
- Bouton pour tout sélectionner/désélectionner
- Bouton supprimer avec nombre d'éléments sélectionnés
- Confirmation avec le nombre d'éléments à supprimer

---

### STORY 3.4: Fiche produit détaillée

**En tant qu'**utilisateur  
**Je veux** voir toutes les informations d'un produit  
**Afin de** faire un choix éclairé

**Critères d'acceptation:**
- Image produit (via Open Food Facts)
- Nom et marque
- **Nutri-Score** (A-E) avec couleurs
- **Informations nutritionnelles** (pour 100g):
  - Énergie (kcal)
  - Matières grasses
  - Acides gras saturés
  - Glucides
  - Sucres
  - Protéines
  - Sel
  - Fibres
- **Informations:**
  - Code-barres
  - Catégorie
  - Origine
- Bouton "VOIR ÉVOLUTION DU PRIX"
- Bouton "SUPPRIMER CET ACHAT"

---

## Epic 4: Statistiques et Analyses

### STORY 4.1: Indicateurs principaux

**En tant qu'**utilisateur  
**Je veux** voir mes dépenses totales  
**Afin de** suivre mon budget courses

**Critères d'acceptation:**
- Card avec le total des dépenses
- Nombre d'achats dans la période
- Filtre par intervalle de dates (sélecteur de plage)
- Prix arrondis à 2 décimales

---

### STORY 4.2: Graphique d'évolution

**En tant qu'**utilisateur  
**Je veux** voir l'évolution de mes dépenses  
**Afin de** identifier les tendances

**Critères d'acceptation:**
- BarChart avec 6 derniers mois
- Couleurs gradient cyan → violet
- Labels des mois en français
- Valeurs arrondies à 2 décimales

---

### STORY 4.3: Dépenses par magasin

**En tant qu'**utilisateur  
**Je veux** voir où je dépense le plus  
**Afin de** comparer les enseignes

**Critères d'acceptation:**
- Liste des 5 premiers magasins
- Montant et pourcentage
- Barre de progression visuelle
- Trie par montant décroissant

---

## Epic 5: Interface Cyberpunk

### STORY 5.1: Thème sombre avec néon

**En tant qu'**utilisateur  
**Je veux** une interface stylée cyberpunk  
**Afin de** que l'app soit agréable à utiliser

**Palette de couleurs:**
```dart
primaryNeonCyan:   #00FFFF  // Couleur principale
primaryNeonPink:   #FF00FF  // Accent
primaryNeonPurple:  #9D00FF  // Tertiaire
neonYellow:        #FFFF00  // Magasins personnalisés
neonGreen:         #00FF41  // Prix bas / Nutri-Score A
bgDark:            #0D0D0D  // Fond
bgCard:            #1A1A2E  // Cartes
```

---

### STORY 5.2: Scanner avec cadre glow

**En tant qu'**utilisateur  
**Je veux** un scanner visuellement attractif  
**Afin de** que le scan soit une expérience agréable

**Critères d'acceptation:**
- Cadre carré avec bordures néon cyan
- Animation de pulsation (glowing)
- Coins avec effets de lumière colorés
- Scan line animée qui traverse le cadre
- Feedback visuel quand un code est détecté

---

### STORY 5.3: Navigation cyberpunk

**En tant qu'**utilisateur  
**Je veux** une navigation cohérente avec le thème  
**Afin de** une expérience unifiée

**Critères d'acceptation:**
- Bottom navigation bar avec 4 onglets:
  - 📷 Scanner
  - 📋 Historique
  - 📊 Stats
  - ⚙️ Paramètres
- Indicateur actif en cyan
- Labels en majuscules

---

### STORY 5.4: Cards et boutons

**En tant qu'**utilisateur  
**Je veux** des éléments d'interface cohérents  
**Afin de** une UX fluide

**Critères d'acceptation:**
- Cards avec bordure néon et fond sombre
- Boutons avec lettres majuscules
- SnackBars avec couleurs cyberpunk
- Inputs avec labels néon

---

### STORY 5.5: États vides et erreurs

**En tant qu'**utilisateur  
**Je veux** des feedbacks visuels appropriés  
**Afin de** savoir ce qui se passe

**Critères d'acceptation:**
- Écran vide: icône avec message en néon
- Chargement: indicateur circulaire cyan
- Erreur: message en rose avec icône warning

---

## Epic 6: Données de Démonstration

### STORY 6.1: Dataset initial

**En tant qu'**développeur  
**Je veux** charger des données de démonstration  
**Afin de** que l'utilisateur puisse tester l'app immédiatement

**Critères d'acceptation:**
- Données pré-chargées si l'historique est vide
- 8 produits courants:
  - Nutella (3017620422003)
  - Coca-Cola (5449000000996)
  - Lait demi-écrémé (3017620421004)
  - Riz Basmati (3046920027561)
  - Chips Paprika (3228021790012)
  - Eau Evian (3057640103742)
  - Yaourt nature (3017620425033)
  - Pain de mie (3178530010303)
- 18 achats avec dates échelonnées

---

## Annexe: Architecture Technique

### Structure du projet
```
lib/
├── main.dart                    # Point d'entrée
├── app.dart                    # App principale + navigation
├── core/
│   ├── theme/
│   │   └── app_theme.dart     # Thème cyberpunk
│   └── constants/
│       └── app_constants.dart  # URLs, noms de boxes
├── data/
│   ├── models/
│   │   ├── product.dart       # Modèle produit
│   │   └── purchase.dart      # Modèle achat
│   └── services/
│       ├── local_storage_service.dart    # Hive storage
│       └── open_food_facts_service.dart  # API OFF
└── features/
    ├── scanner/
    │   ├── presentation/
    │   │   └── scanner_screen.dart
    │   └── providers/
    │       └── scanner_providers.dart
    ├── purchase/
    │   └── presentation/
    │       └── price_entry_screen.dart
    ├── history/
    │   └── presentation/
    │       ├── history_screen.dart
    │       ├── product_detail_screen.dart
    │       └── price_evolution_screen.dart
    └── analytics/
        └── presentation/
            └── analytics_screen.dart
```

### Data Models

**Product:**
```dart
class Product {
  String barcode;
  String name;
  String? brand;
  String? imageUrl;
  String? category;
  String? nutriScore;
  double? energyKcal;
  double? fat;
  double? saturatedFat;
  double? carbohydrates;
  double? sugars;
  double? proteins;
  double? salt;
  double? fibers;
  String? origins;
}
```

**Purchase:**
```dart
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

### API Open Food Facts

```
GET https://world.openfoodfacts.org/api/v2/product/{barcode}
    ?fields=product_name,brands,image_small_url,categories,
            nutriscore_grade,nutriments,origins
```

### Local Storage (Hive)

| Box | Contenu |
|-----|---------|
| products | Cache des produits scannés |
| purchases | Historique des achats |

### Roadmap Future

| Priorité | Feature | Description |
|----------|---------|-------------|
| P1 | Cloud sync | Synchronisation multi-appareils (Supabase) |
| P1 | Authentification | Compte utilisateur |
| P2 | Liste de courses | Gestion de liste |
| P2 | Alertes prix | Notification quand prix baisse |
| P3 | Comparateur | Comparaison de prix entre magasins |
| P3 | Export | Export CSV/PDF |
