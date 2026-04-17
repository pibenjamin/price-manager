/// EPIC 7: Export / Import des Données
/// STORY 7.1: Export JSON
/// STORY 7.2: Export CSV
/// STORY 7.3: Import JSON
///
/// Responsabilités:
/// - ExportService: Génère les fichiers JSON et CSV dans Downloads
/// - ImportService: Parse et valide les fichiers JSON importés
///
/// Critères d'acceptation:
/// - JSON exporté avec pretty print (indenté)
/// - CSV avec séparateur ; et format FR (virgule décimale)
/// - Validation du format avant import
///
/// API: Open Food Facts v2 /api/v2/product/{barcode}

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../data/models/product.dart';
import '../../../data/models/purchase.dart';

class ExportService {
  static const String appVersion = '1.0.0';

  String _formatDateForFile() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<String> exportToJson(
      List<Purchase> purchases, List<Product> products) async {
    final data = {
      'appVersion': appVersion,
      'exportDate': DateTime.now().toIso8601String(),
      'purchases': purchases
          .map((p) => {
                'id': p.id,
                'productBarcode': p.productBarcode,
                'price': p.price,
                'store': p.store,
                'purchaseDate': p.purchaseDate.toIso8601String(),
                'createdAt': p.createdAt.toIso8601String(),
              })
          .toList(),
      'products': products
          .map((p) => {
                'barcode': p.barcode,
                'name': p.name,
                'brand': p.brand,
                'imageUrl': p.imageUrl,
                'category': p.category,
                'nutriScore': p.nutriScore,
                'energyKcal': p.energyKcal,
                'fat': p.fat,
                'saturatedFat': p.saturatedFat,
                'carbohydrates': p.carbohydrates,
                'sugars': p.sugars,
                'proteins': p.proteins,
                'salt': p.salt,
                'fibers': p.fibers,
                'origins': p.origins,
              })
          .toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final fileName = 'prixcourses_export_${_formatDateForFile()}.json';

    final directory = await _getExportDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonString);

    return file.path;
  }

  Future<String> exportToCsv(
      List<Purchase> purchases, List<Product> products) async {
    final productMap = {for (var p in products) p.barcode: p};

    final buffer = StringBuffer();
    buffer.writeln('Date;Produit;Marque;Prix;Magasin;Code-barres');

    for (final purchase in purchases) {
      final product = productMap[purchase.productBarcode];
      final date =
          '${purchase.purchaseDate.day.toString().padLeft(2, '0')}/${purchase.purchaseDate.month.toString().padLeft(2, '0')}/${purchase.purchaseDate.year}';
      final name = _escapeCsv(product?.name ?? 'Produit inconnu');
      final brand = _escapeCsv(product?.brand ?? '');
      final price = purchase.price.toString().replaceAll('.', ',');
      final store = _escapeCsv(purchase.store);
      final barcode = purchase.productBarcode;

      buffer.writeln('$date;$name;$brand;$price;$store;$barcode');
    }

    final fileName = 'prixcourses_achats_${_formatDateForFile()}.csv';

    final directory = await _getExportDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(buffer.toString());

    return file.path;
  }

  String _escapeCsv(String value) {
    if (value.contains(';') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  Future<Directory> _getExportDirectory() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final downloadsDir = Directory('${directory.path}/Download');
        if (await downloadsDir.exists()) {
          return downloadsDir;
        }
        await downloadsDir.create(recursive: true);
        return downloadsDir;
      }
    }
    return await getApplicationDocumentsDirectory();
  }
}

class ImportResult {
  final int purchasesImported;
  final int productsImported;
  final List<String> errors;
  final bool success;

  ImportResult({
    required this.purchasesImported,
    required this.productsImported,
    this.errors = const [],
    required this.success,
  });
}

class ImportService {
  ImportResult? _lastResult;

  ImportResult? get lastResult => _lastResult;

  Map<String, dynamic>? parseJson(String jsonContent) {
    try {
      return jsonDecode(jsonContent) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  bool validateFormat(Map<String, dynamic> data) {
    return data.containsKey('purchases') &&
        data['purchases'] is List &&
        data.containsKey('products');
  }

  ImportResult importData(Map<String, dynamic> data) {
    final errors = <String>[];
    int purchasesCount = 0;
    int productsCount = 0;

    try {
      final purchasesList = data['purchases'] as List?;
      if (purchasesList != null) {
        for (final item in purchasesList) {
          try {
            if (item is Map<String, dynamic>) {
              purchasesCount++;
            }
          } catch (e) {
            errors.add('Erreur achat: $e');
          }
        }
      }

      final productsList = data['products'] as List?;
      if (productsList != null) {
        for (final item in productsList) {
          try {
            if (item is Map<String, dynamic>) {
              productsCount++;
            }
          } catch (e) {
            errors.add('Erreur produit: $e');
          }
        }
      }

      _lastResult = ImportResult(
        purchasesImported: purchasesCount,
        productsImported: productsCount,
        errors: errors,
        success: errors.isEmpty,
      );

      return _lastResult!;
    } catch (e) {
      _lastResult = ImportResult(
        purchasesImported: 0,
        productsImported: 0,
        errors: ['Format invalide: $e'],
        success: false,
      );
      return _lastResult!;
    }
  }

  List<Purchase> parsePurchases(Map<String, dynamic> data) {
    final purchases = <Purchase>[];
    final purchasesList = data['purchases'] as List?;

    if (purchasesList != null) {
      for (final item in purchasesList) {
        if (item is Map<String, dynamic>) {
          try {
            purchases.add(Purchase(
              id: item['id'] ?? '',
              productBarcode: item['productBarcode'] ?? '',
              price: (item['price'] as num?)?.toDouble() ?? 0.0,
              store: item['store'] ?? '',
              purchaseDate: DateTime.tryParse(item['purchaseDate'] ?? '') ??
                  DateTime.now(),
              createdAt: DateTime.tryParse(item['createdAt'] ?? ''),
            ));
          } catch (e) {
            // Skip invalid purchase
          }
        }
      }
    }

    return purchases;
  }

  List<Product> parseProducts(Map<String, dynamic> data) {
    final products = <Product>[];
    final productsList = data['products'] as List?;

    if (productsList != null) {
      for (final item in productsList) {
        if (item is Map<String, dynamic>) {
          try {
            products.add(Product(
              barcode: item['barcode'] ?? '',
              name: item['name'] ?? 'Unknown',
              brand: item['brand'],
              imageUrl: item['imageUrl'],
              category: item['category'],
              nutriScore: item['nutriScore'],
              energyKcal: (item['energyKcal'] as num?)?.toDouble(),
              fat: (item['fat'] as num?)?.toDouble(),
              saturatedFat: (item['saturatedFat'] as num?)?.toDouble(),
              carbohydrates: (item['carbohydrates'] as num?)?.toDouble(),
              sugars: (item['sugars'] as num?)?.toDouble(),
              proteins: (item['proteins'] as num?)?.toDouble(),
              salt: (item['salt'] as num?)?.toDouble(),
              fibers: (item['fibers'] as num?)?.toDouble(),
              origins: item['origins'],
            ));
          } catch (e) {
            // Skip invalid product
          }
        }
      }
    }

    return products;
  }
}
