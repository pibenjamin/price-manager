class AppConstants {
  // Open Food Facts API
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org';
  static const String openFoodFactsProductEndpoint = '/api/v0/product';

  // Hive Box Names
  static const String productsBox = 'products';
  static const String purchasesBox = 'purchases';
  static const String settingsBox = 'settings';

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
