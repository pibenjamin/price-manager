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
`MobileScanner` requires physical device - won't work in Chrome/web.

### Hive on Web
Known issue with double-open of boxes on Chrome. Works on Android.
