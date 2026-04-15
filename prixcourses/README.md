# PrixCourses

Application mobile Flutter pour comparer les prix des courses avec des données crowd-sourcées.

## Fonctionnalités

- 📷 Scan de codes-barres avec la caméra
- 🔍 Recherche de produits via Open Food Facts
- 💰 Enregistrement des prix par magasin
- 📊 Historique des achats
- 📈 Analytics des dépenses

## Installation

### Prérequis

- Flutter SDK 3.2+ ([Installation](https://docs.flutter.dev/get-started/install))
- Android Studio (pour Android)
- Xcode (pour iOS, macOS uniquement)

### Setup

1. **Cloner le projet:**
```bash
cd prixcourses
```

2. **Installer les dépendances:**
```bash
flutter pub get
```

3. **Lancer sur un appareil:**
```bash
# Android
flutter run -d android

# iOS (simulateur)
flutter run -d iphone

# iOS (appareil réel)
flutter run -d <device_id>
```

## Structure du projet

```
lib/
├── main.dart                    # Point d'entrée
├── app.dart                     # Configuration de l'app
├── core/
│   ├── constants/              # Constantes (magasins, API)
│   └── theme/                  # Thème de l'app
├── data/
│   ├── models/                 # Modèles de données
│   └── services/               # Services (API, stockage)
└── features/
    ├── scanner/               # Écran de scan
    ├── purchase/              # Saisie du prix
    ├── history/               # Historique des achats
    └── analytics/             # Statistiques
```

## Technologies

| Composant | Technologie |
|-----------|------------|
| Framework | Flutter 3.x |
| State | Riverpod |
| Local DB | Hive |
| Scanner | mobile_scanner |
| Charts | fl_chart |
| API | Open Food Facts |

## Permissions

### Android
- Camera (scan codes-barres)
- Internet (API Open Food Facts)

### iOS
- Camera (scan codes-barres)

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ipa --release
```

## Licence

MIT
