# PrixCourses - Agent Context

## Project Overview
Flutter mobile app for food price comparison with barcode scanner, using Open Food Facts API.

## Build Commands

```bash
# Development
cd prixcourses && flutter run

# Build APK
cd prixcourses && flutter build apk --release

# APK location
prixcourses/build/app/outputs/flutter-apk/app-release.apk
```

## Key Patterns

### State Management
- **Riverpod** for all state management
- Providers in `*_providers.dart` files
- Use `ConsumerWidget` / `ConsumerStatefulWidget` for screens

### Data Models
- `Product` - product info from Open Food Facts
- `Purchase` - price records with store, date

### Storage
- **Hive** for local persistence
- `LocalStorageService` for CRUD operations

### Theme (Cyberpunk)
- Primary: `#00FFFF` (cyan neon)
- Secondary: `#FF00FF` (pink neon)
- Background: `#0D0D0D`
- Card bg: `#1A1A2E`

### API
- Open Food Facts v2: `/api/v2/product/{barcode}`
- Image URL: `https://static.openfoodfacts.org/images/products/{barcode}/`

## File Structure
```
lib/
├── main.dart / app.dart
├── core/theme/app_theme.dart
├── core/constants/app_constants.dart
├── data/
│   ├── models/
│   └── services/
└── features/
    ├── scanner/
    ├── history/
    ├── analytics/
    └── settings/
```

## Troubleshooting

### LSP Errors
If `lib/features/stores/` errors appear, the folder was deleted but references remain. Check `app.dart` and remove any imports.

### Camera/Scanner
`MobileScanner` requires physical device - won't work on Chrome/web.

### Hive on Web
Known issue with double-open of boxes on Chrome. Works on Android.

## Documentation Rules

### Before Implementation
**ALWAYS** add Epic/Story documentation comments BEFORE writing any implementation code.

Format:
```dart
/// EPIC X: [Titre Epic]
/// STORY X.Y: [Titre Story]
///
/// Responsabilités:
/// - [Description des responsabilités]
///
/// Critères d'acceptation:
/// - [Critère 1]
/// - [Critère 2]
///
/// [Optionnel: Wireframe, diagramme, ou notes techniques]
```

Example:
```dart
/// EPIC 7: Export / Import des Données
/// STORY 7.4: Écran Paramètres
///
/// Responsabilités:
/// - Affiche les stats (nb achats, nb produits)
/// - Propose les boutons Export JSON/CSV
/// - Propose l'import JSON avec options Fusionner/Remplacer
///
/// Critères d'acceptation:
/// - GIVEN: L'utilisateur est sur l'écran Paramètres
/// WHEN: Il clique sur "Exporter en JSON"
/// THEN: Un fichier JSON est créé dans le dossier Downloads

import 'package:flutter/material.dart';
// ... implementation
```

### Documentation Location
- Every Dart file MUST start with Epic/Story documentation
- Document the file BEFORE any imports
- Reference the corresponding spec in `_bmad-output/planning-artifacts/`
- App entry points (app.dart) document which Epic/Stories they integrate
