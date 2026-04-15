---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - '_bmad-output/planning-artifacts/prd-prixcourses.md'
workflowType: 'architecture'
project_name: 'PrixCourses'
user_name: 'Benja'
date: '2026-04-15'
update:
  date: '2026-04-15'
  change: 'Changed from PWA to Flutter for native mobile app'
---

# Architecture Decision Document - PrixCourses

**Version:** 2.0
**Status:** Approved
**Author:** Benja

---

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      PRIXCOURSES (Flutter)                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐     ┌─────────────┐     ┌──────────┐ │
│  │   Flutter App   │────▶│  Supabase  │────▶│ Open     │ │
│  │   (iOS/Android) │     │  (Backend) │     │ Food     │ │
│  └─────────────────┘     └─────────────┘     │ Facts    │ │
│           │                   │              │ API      │ │
│           │             ┌─────┴─────┐        └──────────┘ │
│           │             │          │                      │
│           │        ┌────┴───┐  ┌──┴─────────┐           │
│           │        │Postgres│  │ Supabase   │           │
│           │        │Database│  │  Storage   │           │
│           │        └─────────┘  │ (receipts) │           │
│           │                    └─────────────┘           │
│           ▼                                             │
│    ┌────────────┐                                      │
│    │Local Storage│ (Hive/SQFlite)                     │
│    │ (offline)   │                                     │
│    └────────────┘                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

### Frontend (Mobile)

| Component | Technology | Justification |
|-----------|------------|---------------|
| **Framework** | Flutter 3.x | Native cross-platform (iOS/Android) |
| **Language** | Dart | Official Flutter language |
| **State Management** | Riverpod | Modern, testable, scalable |
| **Local Database** | Hive | Fast, lightweight local storage |
| **Barcode Scanner** | mobile_scanner | Official Flutter plugin for camera/barcode |
| **Charts** | fl_chart | Beautiful Flutter charts |
| **HTTP Client** | dio | Feature-rich HTTP client |

### Backend (BaaS)

| Component | Technology | Justification |
|-----------|------------|---------------|
| **Backend** | Supabase | Backend-as-a-Service, free tier (500MB) |
| **Database** | PostgreSQL | Via Supabase, relational data model |
| **Auth** | None (Phase 1) | Personal use, local storage sufficient |
| **Storage** | Supabase Storage | For receipt photos (optional) |

### External Services

| Service | Purpose | Access Method |
|---------|---------|---------------|
| **Open Food Facts** | Product lookup | REST API (direct) |

---

## 3. Data Model

### Database Schema (Supabase PostgreSQL)

```sql
-- Products table (cached from Open Food Facts)
CREATE TABLE products (
  barcode VARCHAR(50) PRIMARY KEY,
  name VARCHAR(255),
  brand VARCHAR(255),
  image_url TEXT,
  category VARCHAR(255),
  nutri_score VARCHAR(1),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Purchases table
CREATE TABLE purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_barcode VARCHAR(50) REFERENCES products(barcode),
  price DECIMAL(10,2) NOT NULL,
  store VARCHAR(100) NOT NULL,
  purchase_date DATE NOT NULL,
  receipt_photo_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Index for faster queries
CREATE INDEX idx_purchases_date ON purchases(purchase_date);
CREATE INDEX idx_purchases_store ON purchases(store);
CREATE INDEX idx_purchases_barcode ON purchases(product_barcode);
```

### Local Storage (Flutter)

```dart
// Hive boxes for offline access
Hive.box('products');      // Cached products
Hive.box('purchases');     // Local purchases
Hive.box('settings');       // App settings
```

---

## 4. Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                    # MaterialApp configuration
├── core/
│   ├── constants/             # App constants
│   ├── theme/                 # App theme
│   └── utils/                 # Utilities
├── data/
│   ├── models/               # Data models
│   ├── repositories/         # Data repositories
│   └── services/             # External services
├── features/
│   ├── scanner/              # Barcode scanning
│   │   ├── presentation/     # UI screens
│   │   └── providers/        # State management
│   ├── purchase/             # Purchase entry
│   ├── history/              # Purchase history
│   ├── analytics/           # Spending analytics
│   └── settings/            # App settings
└── shared/
    └── widgets/             # Reusable widgets
```

---

## 5. Key Decisions

### DECISION-001: Flutter as Frontend

**Status:** Approved

**Context:** Need a native mobile app that works on iOS and Android.

**Decision:** Use Flutter with Riverpod for state management

**Consequences:**
- ✅ Native performance on iOS and Android
- ✅ Single codebase for both platforms
- ✅ Rich ecosystem of packages
- ⚠️ Requires Flutter SDK installation
- ⚠️ Learning Dart language

---

### DECISION-002: Supabase as Backend

**Status:** Approved

**Context:** Need database and storage without managing infrastructure.

**Decision:** Use Supabase Backend-as-a-Service

**Consequences:**
- ✅ Setup in minutes
- ✅ Free tier sufficient for personal use
- ✅ PostgreSQL database included
- ✅ Storage for receipts included
- ⚠️ Dependency on external service (acceptable for MVP)

---

### DECISION-003: No Authentication (Phase 1)

**Status:** Approved

**Context:** Personal use application, simplicity prioritized.

**Decision:** No auth in Phase 1, data stored locally

**Consequences:**
- ✅ Simplest possible implementation
- ✅ Works immediately, no account creation
- ⚠️ Data limited to single device
- ⚠️ No sync between devices
- 🔜 Future: Add Supabase Auth if multi-device needed

---

### DECISION-004: Open Food Facts Direct Integration

**Status:** Approved

**Context:** Need product information for barcode lookups.

**Decision:** Call Open Food Facts API directly from app

**Consequences:**
- ✅ No proxy server needed
- ✅ Real-time product data
- ✅ 3M+ products coverage
- ⚠️ Rate limit: 2 requests/second
- ⚠️ No internet = no product lookup (use local cache)

---

## 6. Required Packages

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # HTTP & API
  dio: ^5.4.0
  
  # Barcode Scanner
  mobile_scanner: ^4.0.1
  
  # Charts
  fl_chart: ^0.66.0
  
  # UI Utilities
  intl: ^0.18.1          # Date/number formatting
  cached_network_image: ^3.3.0  # Image caching
  flutter_svg: ^2.0.9    # SVG support
  
  # Supabase
  supabase_flutter: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.0
  flutter_lints: ^3.0.0
```

---

## 7. Development Phases

### Phase 1: MVP (Current)
- [ ] Flutter project setup
- [ ] Local storage with Hive
- [ ] Barcode scanner with mobile_scanner
- [ ] Open Food Facts integration
- [ ] Purchase entry (price + store)
- [ ] Purchase history view
- [ ] Basic analytics

### Phase 2: Enhanced
- [ ] Supabase backend integration
- [ ] Receipt photo upload
- [ ] Enhanced spending analytics
- [ ] Cart comparison

### Phase 3: Future (Out of Scope)
- [ ] Supabase Auth
- [ ] Multi-device sync
- [ ] Push notifications
- [ ] Social features

---

## 8. Setup Instructions

### Prerequisites

```bash
# Install Flutter SDK
# https://docs.flutter.dev/get-started/install

# Verify installation
flutter doctor
```

### Create Project

```bash
# Create new Flutter project
flutter create prixcourses
cd prixcourses

# Add dependencies to pubspec.yaml

# Get dependencies
flutter pub get

# Run on iOS simulator
flutter run -d iphone

# Run on Android emulator
flutter run -d android

# Build for production
flutter build apk --release
flutter build ipa --release
```

---

## 9. Acceptance Criteria

| Criterion | Target | Measurement |
|-----------|--------|-------------|
| Scan → Product display | < 2 seconds | Manual testing |
| App cold start | < 3 seconds | Flutter DevTools |
| Works offline | Core features | Airplane mode test |
| iOS build | Success | `flutter build ipa` |
| Android build | Success | `flutter build apk` |

---

**Document Status:** Approved v2.0
**Next Step:** Update Epics for Flutter → Development
