# Epic 7: Export / Import des Données

## Vue d'ensemble

Cette epic couvre les fonctionnalités d'export et d'import des données de l'application PrixCourses pour permettre la sauvegarde et la restauration des données utilisateur.

---

## Stories

### STORY 7.1: Export JSON dans Downloads

**En tant qu'**utilisateur  
**Je veux** exporter mes données en JSON  
**Afin de** sauvegarder une copie de mes achats et produits

**Critères d'acceptation:**
```
GIVEN: L'utilisateur est sur l'écran Paramètres
WHEN: Il clique sur "Exporter en JSON"
THEN: Un fichier JSON est créé dans le dossier Downloads
AND: Le fichier se nomme "prixcourses_export_YYYY-MM-DD.json"
AND: Un SnackBar affiche "Export réussi ! Downloads/prixcourses_export_2026-04-17.json"

CONTENU DU FICHIER:
{
  "appVersion": "1.0.0",
  "exportDate": "2026-04-17T10:30:00",
  "purchases": [...],
  "products": [...]
}

FORMAT:
- JSON indenté (pretty print)
- Encodage UTF-8
- Timestamps en ISO 8601
```

**Note technique:**
- Utiliser `path_provider` pour accéder au dossier Downloads Android
- Demander la permission WRITE_EXTERNAL_STORAGE si nécessaire

---

### STORY 7.2: Export CSV pour Excel

**En tant qu'**utilisateur  
**Je veux** exporter mes achats en CSV  
**Afin de** pouvoir analyser mes dépenses dans Excel ou Google Sheets

**Critères d'acceptation:**
```
GIVEN: L'utilisateur est sur l'écran Paramètres
WHEN: Il clique sur "Exporter en CSV"
THEN: Un fichier CSV est créé dans Downloads
AND: Le fichier se nomme "prixcourses_achats_YYYY-MM-DD.csv"

FORMAT DU FICHIER:
Date;Produit;Marque;Prix;Magasin;Code-barres
17/04/2026;Pâte à tartiner aux noisettes;Nutella;3.49;Carrefour;3017620422003
16/04/2026;Coca-Cola Original;Coca-Cola;1.79;Leclerc;5449000000996

ENCODAGE:
- Séparateur: point-virgule (;) - standard France
- Encodage: UTF-8
- Format date: dd/MM/yyyy
- Séparateur décimal: virgule (,) pour compatibilité Excel FR
```

---

### STORY 7.3: Import depuis fichier JSON

**En tant qu'**utilisateur  
**Je veux** importer des données depuis un fichier JSON  
**Afin de** restaurer mes données ou les transférer d'un autre appareil

**Critères d'acceptation:**
```
GIVEN: L'utilisateur est sur l'écran Paramètres
WHEN: Il clique sur "Importer depuis JSON"
THEN: Un sélecteur de fichier s'ouvre
AND: L'utilisateur peut parcourir ses dossiers
AND: L'utilisateur sélectionne un fichier .json

AFTER SELECTION:
- Validation du format JSON
- Vérification de la structure attendue
- Dialog options:
  * "Remplacer" → Efface les données existantes
  * "Fusionner" → Ajoute sans supprimer
- SnackBar: "X achats importés avec succès"
- En cas d'erreur: SnackBar rouge avec message d'erreur

FORMAT ACCEPTÉ:
{
  "appVersion": "1.0.0",
  "exportDate": "2026-04-17T10:30:00",
  "purchases": [...],
  "products": [...]
}
```

---

### STORY 7.4: Écran Paramètres

**En tant qu'**utilisateur  
**Je veux** accéder à une section dédiée aux paramètres  
**Afin de** trouver facilement les options d'export/import

**Critères d'acceptation:**
```
ÉCRAN PARAMÈTRES:

┌─────────────────────────────────────┐
│ ← PARAMÈTRES                        │
├─────────────────────────────────────┤
│                                     │
│  💾 EXPORT DES DONNÉES             │
│  ┌─────────────────────────────┐   │
│  │ 📄 Exporter en JSON         │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 📊 Exporter en CSV          │   │
│  └─────────────────────────────┘   │
│                                     │
│  📂 IMPORT DES DONNÉES             │
│  ┌─────────────────────────────┐   │
│  │ 📥 Importer depuis JSON      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ──────────────────────────────    │
│                                     │
│  ℹ️ PrixCourses v1.0.0            │
│                                     │
└─────────────────────────────────────┘

STYLE:
- Cards avec icônes cyberpunk
- Bordure néon cyan
- Boutons full-width
```

---

## Wireframes

### Écran Paramètres - Export
```
┌────────────────────────────────┐
│ ← PARAMÈTRES                   │
├────────────────────────────────┤
│                                │
│  💾 EXPORT DES DONNÉES        │
│                                │
│  ┌──────────────────────────┐  │
│  │ 📄 Exporter en JSON      │  │
│  │    Sauvegarde complète   │  │
│  └──────────────────────────┘  │
│                                │
│  ┌──────────────────────────┐  │
│  │ 📊 Exporter en CSV       │  │
│  │    Pour Excel / Google   │  │
│  └──────────────────────────┘  │
│                                │
│  📂 IMPORT DES DONNÉES        │
│                                │
│  ┌──────────────────────────┐  │
│  │ 📥 Importer depuis JSON   │  │
│  └──────────────────────────┘  │
│                                │
├────────────────────────────────┤
│  [📷] [📋] [📊] [⚙️]        │
└────────────────────────────────┘
```

### Dialog Import - Options
```
┌────────────────────────────────┐
│  📥 IMPORTER LES DONNÉES      │
├────────────────────────────────┤
│                                │
│  Comment souhaitez-vous         │
│  importer les données ?       │
│                                │
│  ┌──────────────────────────┐  │
│  │  🔄 REMPLACER           │  │
│  │  Efface les données      │  │
│  │  existantes               │  │
│  └──────────────────────────┘  │
│                                │
│  ┌──────────────────────────┐  │
│  │  🔀 FUSIONNER           │  │
│  │  Ajoute aux données      │  │
│  │  existantes               │  │
│  └──────────────────────────┘  │
│                                │
│  [ANNULER]                    │
│                                │
└────────────────────────────────┘
```

---

## Définitions Techniques

### Packages requis
```yaml
dependencies:
  path_provider: ^2.1.0        # Accès au système de fichiers
  file_picker: ^8.0.0         # Sélecteur de fichiers
  share_plus: ^10.0.0         # Partage optionnel
```

### Service ExportService
```dart
class ExportService {
  Future<String> exportToJson(List<Purchase> purchases, List<Product> products);
  Future<String> exportToCsv(List<Purchase> purchases, List<Product> products);
  Future<String> getDownloadsPath();
}
```

### Service ImportService
```dart
class ImportService {
  Future<ImportResult> importFromJson(String jsonContent);
  bool validateJsonFormat(String jsonContent);
}
```

### Modèle ImportResult
```dart
class ImportResult {
  final int purchasesImported;
  final int productsImported;
  final List<String> errors;
  final bool success;
}
```

---

## Estimation

| Story | Complexité | Temps |
|-------|------------|-------|
| 7.1 Export JSON | Medium | 2h |
| 7.2 Export CSV | Low | 1h |
| 7.3 Import JSON | Medium | 2h |
| 7.4 Écran Paramètres | Low | 1h |
| **Total** | | **6h** |

---

## Risques Identifiés

1. **Permission WRITE_EXTERNAL_STORAGE** → Utiliser Storage Access Framework (Android 10+)
2. **Taille du fichier JSON** → Limiter à 1000 achats par export si nécessaire
3. **Encodage CSV Excel FR** → Utiliser UTF-8 with BOM si problème d'accents

---

## Validation

- [ ] **PM:** Les options d'export sont-elles suffisantes ?
- [ ] **UX:** Le flow import est-il intuitif ?
- [ ] **Tech:** La permission Android est-elle gérée correctement ?
- [ ] **QA:** Tester avec fichiers de +1000 achats

---

**Status:** En attente de validation
