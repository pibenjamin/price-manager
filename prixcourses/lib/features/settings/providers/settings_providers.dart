/// EPIC 7: Export / Import des Données
/// STORY 7.1: Export JSON
/// STORY 7.2: Export CSV
/// STORY 7.3: Import JSON
///
/// Responsabilités:
/// - SettingsNotifier: Orchestre les opérations d'export/import
/// - Appelle ExportService et ImportService
/// - Rafraîchit les providers après import
///
/// Flux:
/// Export: Recupere données → Appelle ExportService → Retourne chemin fichier
/// Import: Ouvre FilePicker → Parse JSON → Valide → Sauvegarde → Refresh providers

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product.dart';
import '../../../data/models/purchase.dart';
import '../../../data/services/local_storage_service.dart';
import '../../scanner/providers/scanner_providers.dart';
import '../services/export_import_service.dart';

final exportServiceProvider = Provider((ref) => ExportService());
final importServiceProvider = Provider((ref) => ImportService());

final settingsNotifierProvider = Provider((ref) {
  return SettingsNotifier(
    ref.watch(localStorageServiceProvider),
    ref.watch(exportServiceProvider),
    ref.watch(importServiceProvider),
    ref,
  );
});

class SettingsNotifier {
  final LocalStorageService _storageService;
  final ExportService _exportService;
  final ImportService _importService;
  final Ref _ref;

  SettingsNotifier(
    this._storageService,
    this._exportService,
    this._importService,
    this._ref,
  );

  Future<String?> exportToJson() async {
    try {
      final purchases = _storageService.getAllPurchases();
      final products = _storageService.getAllProducts();
      final path = await _exportService.exportToJson(purchases, products);
      return path;
    } catch (e) {
      return null;
    }
  }

  Future<String?> exportToCsv() async {
    try {
      final purchases = _storageService.getAllPurchases();
      final products = _storageService.getAllProducts();
      final path = await _exportService.exportToCsv(purchases, products);
      return path;
    } catch (e) {
      return null;
    }
  }

  Future<ImportResult?> importFromJson({required bool replace}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.first;
      String content;

      if (file.path != null) {
        content = await File(file.path!).readAsString();
      } else if (file.bytes != null) {
        content = String.fromCharCodes(file.bytes!);
      } else {
        return null;
      }

      final data = _importService.parseJson(content);
      if (data == null) {
        return ImportResult(
          purchasesImported: 0,
          productsImported: 0,
          errors: ['Format JSON invalide'],
          success: false,
        );
      }

      if (!_importService.validateFormat(data)) {
        return ImportResult(
          purchasesImported: 0,
          productsImported: 0,
          errors: ['Structure du fichier non reconnue'],
          success: false,
        );
      }

      final purchases = _importService.parsePurchases(data);
      final products = _importService.parseProducts(data);

      if (replace) {
        // Clear existing data and replace
        final existingPurchases = _storageService.getAllPurchases();
        for (final p in existingPurchases) {
          await _storageService.deletePurchase(p.id);
        }
        final existingProducts = _storageService.getAllProducts();
        for (final p in existingProducts) {
          await _storageService.getProduct(p.barcode);
        }
      }

      // Import new data
      for (final product in products) {
        await _storageService.saveProduct(product);
      }
      for (final purchase in purchases) {
        await _storageService.savePurchase(purchase);
      }

      // Refresh providers
      _ref.read(purchasesProvider.notifier).refresh();
      _ref.invalidate(productsCacheProvider);

      return ImportResult(
        purchasesImported: purchases.length,
        productsImported: products.length,
        success: true,
      );
    } catch (e) {
      return ImportResult(
        purchasesImported: 0,
        productsImported: 0,
        errors: ['Erreur d\'import: $e'],
        success: false,
      );
    }
  }
}
