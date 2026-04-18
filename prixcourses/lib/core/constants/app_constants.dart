import 'package:flutter/foundation.dart';

class AppConstants {
  // Open Food Facts API
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org';
  static const String openFoodFactsProductEndpoint = '/api/v0/product';

  // Laravel API - auto-detect based on platform
  static String get apiBaseUrl {
    if (kIsWeb) return 'http://localhost:8005';
    // Android emulator uses 10.0.2.2, real device needs your IP
    return 'http://10.0.2.2:8005';
  }

  static const String apiAuthEndpoint = '/api/auth';
  static const String apiPurchasesEndpoint = '/api/purchases';
  static const String apiProductsEndpoint = '/api/products';

  // Hive Box Names
  static const String productsBox = 'products';
  static const String purchasesBox = 'purchases';
  static const String settingsBox = 'settings';
  static const String authBox = 'auth';

  // Performance
  static const int scanTimeoutSeconds = 2;
}

class StoreConstants {
  static const Map<String, List<String>> storesByCategory = {
    'Hypermarchés': [
      'Carrefour',
      'Leclerc',
      'Auchan',
      'Casino',
      'Intermarché',
      'Système U',
    ],
    'Hard Discount': [
      'Lidl',
      'Aldi',
      'Netto',
    ],
    'Bio': [
      'Biocoop',
      'La Vie Claire',
      'Naturalia',
    ],
    'Drive': [
      'Carrefour Drive',
      'Leclerc Drive',
      'Auchan Drive',
    ],
    'Local': [
      'Super U',
      'Proxy',
      'Spar',
    ],
  };

  static List<String> get allStores {
    final List<String> stores = [];
    for (final category in storesByCategory.values) {
      stores.addAll(category);
    }
    stores.add('Autre');
    return stores;
  }
}
