---
stepsCompleted: [1, 2, 3]
inputDocuments:
  - '_bmad-output/planning-artifacts/prd-prixcourses.md'
  - '_bmad-output/planning-artifacts/architecture.md'
workflowType: 'epics'
project_name: 'PrixCourses'
date: '2026-04-15'
epicsApproved: true
storiesComplete: true
framework: flutter
implementationStatus: mvp_complete
---

# PrixCourses - Epic Breakdown (Flutter)

## Overview

This document provides the complete epic and story breakdown for PrixCourses, a Flutter mobile application for comparing grocery prices.

## Technology Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x + Dart |
| State Management | Riverpod |
| Local Storage | Hive |
| Backend | Supabase |
| Barcode Scanner | mobile_scanner |

---

## Requirements Inventory

### Functional Requirements

**F01: Barcode Scanning**
- FR1.1: Full-screen camera with auto-capture
- FR1.2: Open Food Facts API lookup
- FR1.3: Display product name, brand, and photo
- FR1.4: Manual entry fallback if product not found

**F02: Price Entry**
- FR2.1: Price field (€) with validation
- FR2.2: Store selection (predefined list + custom)
- FR2.3: Date field (auto-filled, editable)

**F03: Purchase History**
- FR3.1: Display last purchase for each product
- FR3.2: Product history list (all purchases)
- FR3.3: Min/max price per product

**F04: Cart Comparison**
- FR4.1: Total cart calculation per store
- FR4.2: Cheapest store ranking
- FR4.3: Period filtering (month, quarter)

**F05: Spending Analytics**
- FR5.1: Monthly spending total
- FR5.2: Trend chart (evolution over time)
- FR5.3: Top purchased products

**F06: Receipt Photo (Optional)**
- FR6.1: Capture receipt photo
- FR6.2: Associate photo with purchase

---

## Epic List

| Epic | Title | Stories | Priority |
|------|-------|---------|----------|
| Epic 1 | Flutter Project Setup | 3 | High |
| Epic 2 | Barcode Scanner | 2 | High |
| Epic 3 | Price Entry | 2 | High |
| Epic 4 | Purchase History | 2 | High |
| Epic 5 | Spending Analytics | 2 | Medium |
| Epic 6 | Cart Comparison | 2 | Medium |

---

## Epic 1: Flutter Project Setup

**Goal:** Establish Flutter project with dependencies, theme, and local storage.

### Story 1.1: Initialize Flutter Project

As a developer,
I want to set up the Flutter project with dependencies,
So that the app has a solid foundation.

**Acceptance Criteria:**

**Given** Flutter SDK is installed
**When** I create a new Flutter project
**Then** the project structure is created with proper folders (lib/, test/)
**And** all dependencies are added to pubspec.yaml

**Given** dependencies are installed
**When** I run `flutter pub get`
**Then** all packages are downloaded without errors
**And** the project builds successfully

---

### Story 1.2: Configure App Theme and Navigation

As a developer,
I want to set up the app theme and navigation,
So that the UI is consistent and navigable.

**Acceptance Criteria:**

**Given** the Flutter project exists
**When** I configure the theme
**Then** Material Design 3 is enabled
**And** primary color scheme is defined
**And** text styles are consistent

**Given** the theme is configured
**When** I set up navigation
**Then** Bottom navigation bar with 4 tabs exists (Scan, History, Analytics, Settings)
**And** navigation between tabs is smooth

---

### Story 1.3: Set Up Local Storage with Hive

As a developer,
I want to set up Hive for local storage,
So that data persists between app sessions.

**Acceptance Criteria:**

**Given** the Flutter project exists
**When** I configure Hive
**Then** Hive is initialized in main.dart
**And** boxes for products, purchases, and settings are created

**Given** Hive is configured
**When** the app starts
**Then** local data loads from Hive
**And** new data saves to Hive automatically

---

## Epic 2: Barcode Scanner

**Goal:** Implement barcode scanning with Open Food Facts integration.

### Story 2.1: Camera-Based Barcode Scanner

As a user,
I want to scan barcodes with my camera,
So that I can quickly identify products.

**Acceptance Criteria:**

**Given** the user opens the scan screen
**When** camera permission is granted
**Then** the camera preview is displayed full-screen
**And** barcodes are auto-detected in real-time

**Given** a barcode is detected
**When** the scan is successful
**Then** the barcode is extracted
**And** the Open Food Facts lookup is triggered

**Given** camera permission is denied
**When** the user opens the scanner
**Then** they see instructions to enable camera
**And** they can use manual barcode entry instead

---

### Story 2.2: Open Food Facts Integration

As a user,
I want product details from Open Food Facts,
So that I know what I'm buying.

**Acceptance Criteria:**

**Given** a valid barcode is scanned
**When** the app looks up the product
**Then** it calls Open Food Facts API
**And** product name, brand, and image are retrieved

**Given** the product exists in Open Food Facts
**When** the lookup completes
**Then** product info is displayed with image
**And** price entry screen is shown

**Given** the product does NOT exist in Open Food Facts
**When** the lookup completes
**Then** a "Product not found" message is shown
**And** manual entry option is presented

---

## Epic 3: Price Entry

**Goal:** Enable users to enter purchase details (price, store, date).

### Story 3.1: Price and Store Entry

As a user,
I want to enter the price and store,
So that I can record my purchase.

**Acceptance Criteria:**

**Given** product info is displayed
**When** the user enters the price
**Then** a numeric input with € suffix accepts decimal values
**And** validation ensures positive numbers only

**Given** price is entered
**When** the user selects a store
**Then** a dropdown shows predefined stores by category
**And** an "Other" option allows custom store names

**Given** price and store are entered
**When** the user confirms
**Then** the purchase is saved to Hive
**And** the user sees a success confirmation

---

### Story 3.2: Manual Barcode Entry

As a user,
I want to enter barcodes manually,
So that I can add products even without scanning.

**Acceptance Criteria:**

**Given** the user cannot scan (no camera, damaged barcode)
**When** they tap "Enter manually"
**Then** a text input accepts barcode numbers
**And** the system looks up the product via API

**Given** the manual barcode is found
**When** the product is retrieved
**Then** the normal price entry flow continues
**And** the user can complete their purchase entry

---

## Epic 4: Purchase History

**Goal:** Display purchase history and last purchase prices.

### Story 4.1: View Purchase History

As a user,
I want to see my purchase history,
So that I can track what I've bought.

**Acceptance Criteria:**

**Given** the user opens history
**When** purchases exist
**Then** a list shows all purchases sorted by date (newest first)
**And** each item shows product name, price, store, and date

**Given** the user has many purchases
**When** viewing the list
**Then** lazy loading loads more items as they scroll
**And** performance remains acceptable

---

### Story 4.2: Display Last Purchase Price

As a user,
I want to see the last price I paid,
So that I know if I'm paying more or less.

**Acceptance Criteria:**

**Given** a product is being entered
**When** previous purchases exist for this barcode
**Then** "Last: €XX at [STORE] on [DATE]" is displayed
**And** the difference from last price is highlighted

**Given** a product has no history
**When** it is being entered
**Then** "First purchase of this product" is displayed

---

## Epic 5: Spending Analytics

**Goal:** Display spending insights and trends.

### Story 5.1: Monthly Spending Dashboard

As a user,
I want to see my monthly spending,
So that I can track my food expenses.

**Acceptance Criteria:**

**Given** the user opens the dashboard
**When** purchases exist
**Then** the current month's total is displayed prominently
**And** a breakdown by store is shown

---

### Story 5.2: Spending Trend Chart

As a user,
I want to see spending trends over time,
So that I can identify patterns.

**Acceptance Criteria:**

**Given** the user opens the analytics
**When** sufficient data exists
**Then** a line chart shows spending over the last 3 months
**And** the chart is interactive (tap for details)

---

## Epic 6: Cart Comparison

**Goal:** Compare cart totals across stores.

### Story 6.1: Cart Total Calculation

As a user,
I want to see my cart total by store,
So that I know where to shop.

**Acceptance Criteria:**

**Given** the user has products in their history
**When** they view cart comparison
**Then** each store shows the sum of prices for shared products
**And** stores are ranked from cheapest to most expensive

---

### Story 6.2: Period Filtering

As a user,
I want to filter by time period,
So that I can compare specific timeframes.

**Acceptance Criteria:**

**Given** the user is viewing cart comparison
**When** they select a time period (month, quarter, all)
**Then** only purchases from that period are included
**And** the totals update accordingly

---

## Technical Notes

### Device Permissions

**Android (android/app/src/main/AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is needed to scan product barcodes</string>
```

### Supabase Setup

1. Create project at supabase.com
2. Get URL and anon key
3. Create tables using SQL from architecture.md
4. Add to Flutter app:
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_ANON_KEY',
);
```
