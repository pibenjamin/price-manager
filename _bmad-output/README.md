# Documentation PrixCourses

## 📁 Structure de la documentation

```
_bmad-output/
├── README.md                          # Ce fichier - index
├── planning-artifacts/
│   ├── product-backlog.md             # Product Backlog complet (épics + stories)
│   ├── epic-07-gestion-produits.md    # Epic 7 (gestion détaillée)
│   ├── architecture.md                # Architecture technique
│   └── sprints/
│       └── sprint-01.md               # Sprint 1
├── implementation-artifacts/
│   └── sprint-01-status.md           # Status Sprint 1
└── test-artifacts/
    └── test-plan.md                  # Plan de test
```

---

## 📋 Product Backlog

### Épics implémentés

| # | Epic | Stories | Status |
|---|------|---------|--------|
| 1 | Scanner de produits | 2 | ✅ Done |
| 2 | Enregistrement d'achats | 4 | ✅ Done |
| 3 | Gestion de l'historique | 4 | ✅ Done |
| 4 | Statistiques et analyses | 3 | ✅ Done |
| 5 | Interface Cyberpunk | 5 | ✅ Done |
| 6 | Données de démonstration | 1 | ✅ Done |

### Stories par Epic

#### Epic 1: Scanner de Produits
- [x] STORY 1.1: Scan de code-barres
- [x] STORY 1.2: Entrée manuelle

#### Epic 2: Enregistrement d'Achats
- [x] STORY 2.1: Saisie du prix
- [x] STORY 2.2: Sélection du magasin
- [x] STORY 2.3: Sélection de la date
- [x] STORY 2.4: Affichage du dernier achat

#### Epic 3: Gestion de l'Historique
- [x] STORY 3.1: Liste des achats
- [x] STORY 3.2: Suppression unitaire
- [x] STORY 3.3: Suppression en masse
- [x] STORY 3.4: Fiche produit détaillée

#### Epic 4: Statistiques et Analyses
- [x] STORY 4.1: Indicateurs principaux
- [x] STORY 4.2: Graphique d'évolution
- [x] STORY 4.3: Dépenses par magasin

#### Epic 5: Interface Cyberpunk
- [x] STORY 5.1: Thème sombre avec néon
- [x] STORY 5.2: Scanner avec cadre glow
- [x] STORY 5.3: Navigation cyberpunk
- [x] STORY 5.4: Cards et boutons
- [x] STORY 5.5: États vides et erreurs

#### Epic 6: Données de Démonstration
- [x] STORY 6.1: Dataset initial

---

## 🎨 Design System - Cyberpunk

### Palette de couleurs

```dart
// Couleurs principales
primaryNeonCyan:   #00FFFF  // Cyan néon - actions principales
primaryNeonPink:   #FF00FF  // Magenta - accents, erreurs
primaryNeonPurple: #9D00FF  // Violet - éléments secondaires
neonYellow:        #FFFF00  // Jaune - favoris, personnalisé
neonGreen:         #00FF41  // Vert - succès, Nutri-Score A

// Fond
bgDark:            #0D0D0D  // Fond principal
bgCard:            #1A1A2E  // Cartes et surfaces
```

### Typographie
- Titres: majuscules, letter-spacing: 2
- Labels: 12-14px, semi-bold
- Corps: 14-16px

---

## 📱 Écrans de l'application

1. **Scanner** - Caméra avec cadre glow, scan line animée
2. **Enregistrement** - Fiche produit + formulaire achat
3. **Historique** - Liste des achats avec badges
4. **Stats** - Total, graphique, répartition par magasin
5. **Paramètres** - Placeholder pour futures options

---

## 🔧 Technologies

| Composant | Technologie |
|-----------|-------------|
| Framework | Flutter |
| State | Riverpod |
| Storage | Hive (local) |
| API | Open Food Facts |
| Charts | fl_chart |
| Images | cached_network_image |
| HTTP | Dio |

---

## 📅 Historique des sprints

| Sprint | Dates | Stories | Status |
|--------|-------|---------|--------|
| Sprint 1 | - | 6 épics complets | ✅ Done |

---

## 🚀 Roadmap

### Phase 1 (Actuelle) - MVP ✅
- Scanner de codes-barres
- Enregistrement des achats
- Historique avec suppression
- Statistiques de base
- Thème cyberpunk

### Phase 2 - Cloud
- [ ] Synchronisation cloud (Supabase)
- [ ] Authentification utilisateur
- [ ] Multi-devices

### Phase 3 - Fonctionnalités avancées
- [ ] Liste de courses
- [ ] Alertes prix
- [ ] Comparateur de prix
- [ ] Export des données

---

_Dernière mise à jour: Avril 2026_
