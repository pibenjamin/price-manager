# PrixCourses - Project Plan

**Date:** 2026-04-14  
**Author:** Benja  

---

## 1. Vision

Application mobile de comparaison de prix alimentaires par crowd-sourcing. L'utilisateur scanne ses produits, enregistre le prix payé et l'enseigne. L'app compare les prix et suit les dépenses.

---

## 2. Concept

| Élément | Description |
|---------|-------------|
| **Core** | Scanner → prix + enseigne → historique |
| **Différenciant** | "Panier Moyen" + données consommation |
| **Data** | Saisie utilisateur (crowd-sourcing) |
| **Source produits** | Open Food Facts |

---

## 3. Features Prioritaires

### Phase 1 (MVP)
- F01: Scan code-barres
- F02: Saisie prix + enseigne
- F03: Historique (dernier achat visible)
- F04: Dashboard dépenses

### Phase 2
- F05: Comparaison panier moyen
- F06: Photo receipt (optionnel)
- F07: Graphiques tendances

---

## 4. Enseignes Supportées

| Catégorie | Enseignes |
|-----------|----------|
| Hypermarkets | Carrefour, Leclerc, Auchan, Casino, Intermarché, Système U |
| Hard Discount | Lidl, Aldi, Netto |
| Bio | Biocoop, La Vie Claire, Naturalia |
| Local | Super U, Proxy, Spar |
| Drive | Carrefour Drive, Leclerc Drive |

---

## 5. User Flows

### Flow 1: Enregistrer un achat
1. Scanner code-barres
2. Produit s'affiche (nom, marque via OFF)
3. "Dernier achat: XX€ à [ENSEIGNE]"
4. Entrer prix actuel
5. Choisir enseigne
6. (Optionnel) Photo reçu
7. Confirmer

### Flow 2: Comparer
1. "Mon Panier" → Liste produits
2. Filtrer par période
3. Voir "Enseigne la moins chère"

### Flow 3: Dépenses
1. Dashboard
2. Total mois en cours
3. Graphique évolution
4. Top produits

---

## 6. Concurrence

| Concurrent | Force | Notre Différenciation |
|------------|-------|------------------|
| Circl | Couverture large | Prix réel payé par user |
| Basket | IA, 50K produits | Interface simple + historique |
| UFC Que Choisir | Indépendance | UX moderne |

---

## 7. Risques

- R01: APIs externes (OFF) → Cache local
- R02: Engagement user → Programme referral
- R03: Qualité données → Modération user

---

## 8. KPIs Cible (Y1)

| Métrique | Cible |
|----------|-------|
| Téléchargements | 10,000 |
| MAU | 2,000 |
| Scans/user/semaine | 3+ |
| Retention M3 | 25% |

---

## 9. Modèle Économique

- Freemium: Gratuit (10 scans/jour) → Premium 2,99€/mois
- Data agrégée anonymisée (études marché)

---

## 10. Tech Stack Suggeré

| Composant | Technologie |
|-----------|-------------|
| Mobile | React Native ou Flutter |
| Backend | Node.js / Supabase |
| Database | PostgreSQL |
| Auth | Supabase Auth |
| Storage | Supabase Storage (receipts) |

---

## 11. Prochaines Étapes

| # | Étape | Skill | Code | Description |
|---|------|-------|------|-------------|
| 1 | Valider PRD | `bmad-validate-prd` | VP | Valider le PRD contre les standarts |
| 2 | Create Architecture | `bmad-create-architecture` | CA | Architecture technique |
| 3 | Create Epics & Stories | `bmad-create-epics-and-stories` | CE | Epics + User Stories |
| 4 | Create UX Design | `bmad-create-ux-design` | CU | Design UX |
| 5 | Sprint Planning | `bmad-sprint-planning` | SP | Plan de implementación |
| 6 | Implementation | `bmad-dev-story` | DS | Développement |

---

## 12. Documents

| Document | Chemin |
|-----------|--------|
| PRD | `_bmad-output/planning-artifacts/prd-prixcourses.md` |
| Ce plan | `_bmad-output/planning-artifacts/plan-prixcourses.md` |

---

*Document généré le 14 Avril 2026*