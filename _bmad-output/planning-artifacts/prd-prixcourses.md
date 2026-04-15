---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7]
inputDocuments: []
workflowType: 'prd'
productName: 'PrixCourses'
version: '1.2'
status: 'draft'
updates:
  - date: '2026-04-15'
    author: 'Benja'
    changes:
      - 'Added project scope (personal use)'
      - 'Removed offline mode requirement'
      - 'Updated data quality approach (user trust)'
      - 'Clarified barcode as primary product identifier'
      - 'Added barcode backup for future flexibility'
  - date: '2026-04-15'
    author: 'Validation'
    changes:
      - 'Added device permissions documentation (camera, photo library)'
---

# Product Requirements Document - PrixCourses

**Author:** Benja
**Date:** 2026-04-14
**Version:** 1.1
**Status:** Draft
**Scope:** Personal use application

---

## 1. Executive Summary

**PrixCourses** is a mobile application for comparing grocery prices through crowd-sourcing. Users scan product barcodes, enter the price they paid and select the store. The app displays purchase history (last price) and shows where their cart is cheapest.

**Positioning:** "By the people, for the people" price comparator - no dependency on distributor APIs, real user-supplied data.

---

## 2. Problem Statement

| ID | Problem | Description |
|----|---------|-------------|
| P01 | No access to real distributor prices | Distributor APIs are closed/ unavailable |
| P02 | Existing comparators have outdated data | Scraped data is often incomplete or obsolete |
| P03 | No visibility on past purchase prices | Users can't see "where did I pay less before?" |
| P04 | Difficulty tracking food expenses | No simple way to follow monthly spending |

---

## 3. Solution Overview

Mobile application with:
- Barcode scanning → product lookup (via Open Food Facts)
- Price + store entry
- "Last purchase" display with price
- Price history per product
- Cart comparison between stores

---

## 4. User Journeys

### Journey 1: Record Purchase (Core)

```
1. Open app → Scan screen
2. Scan barcode
3. Product info displays (name, brand, photo from OFF)
4. Display: "Last: €XX at [STORE] on [DATE]"
5. Enter current price
6. Select store
7. (Optional) Add receipt photo
8. Confirm → Save
```

### Journey 2: Compare Prices

```
1. Go to "My Cart"
2. View scanned products list
3. Filter by period (month, quarter)
4. Comparison: "Cheapest store: €XX"
5. See savings vs last purchase
```

### Journey 3: Track Spending

```
1. Open Dashboard
2. View this month's spending: €XXX
3. See trend chart
4. View top purchased products
```

---

## 5. Feature List

### F01: Barcode Scanning
| Priority | Description |
|----------|-------------|
| REQUIRED | Full-screen camera, auto-capture |
| REQUIRED | Open Food Facts lookup |
| REQUIRED | Display name, brand, photo |
| FALLBACK | Manual entry if not found |

### F02: Price Entry
| Priority | Description |
|----------|-------------|
| REQUIRED | Price field (€) |
| REQUIRED | Store list (predefined + custom) |
| REQUIRED | Date (auto, editable) |

### F03: Purchase History
| Priority | Description |
|----------|-------------|
| REQUIRED | Display last purchase |
| REQUIRED | Product history list |
| REQUIRED | Min/max price per product |

### F04: Cart Comparison
| Priority | Description |
|----------|-------------|
| REQUIRED | Total cart calculation per store |
| REQUIRED | Cheapest store ranking |
| NICE | Period filtering |

### F05: Spending Analytics
| Priority | Description |
|----------|-------------|
| REQUIRED | Monthly spending |
| REQUIRED | Trend chart |
| NICE | Top products |

### F06: Receipt Photo (Optional)
| Priority | Description |
|----------|-------------|
| NICE | Capture receipt photo |
| NICE | Store with purchase |

---

## 6. Store List

### Predefined Stores by Category

| Category | Stores |
|----------|--------|
| Hypermarkets | Carrefour, Leclerc, Auchan, Casino, Intermarché, Système U |
| Hard Discount | Lidl, Aldi, Netto |
| Bio | Biocoop, La Vie Claire, Naturalia |
| Local | Super U (local), Proxy, Spar |
| Drive | Carrefour Drive, Leclerc Drive |

+ "Other" option for unlisted stores

---

## 7. Data Source

**Primary:** Open Food Facts API (free, open-source)
- Endpoint: https://world.openfoodfacts.org/cgi/search.pl
- Coverage: 3M+ products
- Data: name, brand, Nutri-Score, image

**Fallback:** Manual entry if product not found

**Product Identification:** Barcode is the primary identifier
- Barcode → lookup in OFF for product details
- Barcode stored locally for future flexibility (alternative data sources)
- No complex matching algorithm needed

---

## 8. Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| **Scan → product display** | < 2 seconds |
| **App launch** | < 1 second |
| **Connectivity** | Online only (no offline mode) |
| **iOS support** | iOS 14+ |
| **Android support** | Android 8+ |
| **Storage** | Cloud only (Supabase) |

---

## 8.1 Device Permissions

| Permission | Platform | Purpose | Required |
|------------|---------|--------|----------|
| **Camera** | iOS, Android | Barcode scanning | YES |
| **Photo Library** | iOS, Android | Save receipt photos (optional) | NO |

---

## 9. Data Model

### Product
```
- barcode (string, PK)
- name (string)
- brand (string)
- image_url (string)
- category (string)
- nutri_score (string)
```

### Purchase
```
- id (UUID)
- product_barcode (FK)
- price (decimal)
- store (string)
- purchase_date (date)
- receipt_photo_url (string, optional)
- user_id (UUID)
```

### User
```
- id (UUID)
- email (string)
- created_at (date)
- preferences (JSON)
```

---

## 10. Technical Stack (Adopted)

| Component | Technology |
|-----------|-------------|
| Mobile Framework | **Flutter 3.x** |
| State Management | Riverpod |
| Local Storage | Hive |
| Backend | Supabase |
| Database | PostgreSQL |
| Auth | None (Phase 1) |
| Storage | Supabase Storage (receipts) |
| API | Open Food Facts (external) |

---

## 11. Risks & Assumptions

| Risk | Mitigation |
|------|------------|
| R01: OFF API downtime | Cache results, show cached data |
| R02: Data quality | Trust user input (personal use app) |
| R03: OFF coverage gaps | Manual entry fallback |

| Assumption | Description |
|------------|-------------|
| A01 | Barcode provides reliable product identification |
| A02 | Sufficient coverage from Open Food Facts |
| A03 | User wants to track personal spending |
| A04 | Online connectivity available during use |

---

## 12. KPIs

| Metric | Target Y1 |
|--------|-----------|
| Downloads | 10,000 |
| MAU | 2,000 |
| Scans/user/week | 3+ |
| Retention M3 | 25% |
| Store coverage | 15+ |

---

## 13. Monetization

| Model | Description |
|-------|-------------|
| Freemium | Free (10 scans/day), Premium €2.99/month unlimited |
| Optional | Anonymous aggregated data (market studies) |

---

## 14. Future Enhancements

- F07: Shopping list with budget
- F08: Price alerts when lower
- F09: Social sharing
- F10: Multi-user (family)
- F11: Recipe suggestions based on purchases

---

**Document Status:** Draft - Updated with user decisions
**Next Step:** Continue validation → Create Architecture → Create Epics & Stories

> **Note:** This is a personal-use application. Simplified data quality approach (trust user input). No offline mode. No multi-user features.