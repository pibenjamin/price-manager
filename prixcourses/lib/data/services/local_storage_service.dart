import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/purchase.dart';
import '../../core/constants/app_constants.dart';

class LocalStorageService {
  late Box<String> _productsBox;
  late Box<String> _purchasesBox;
  final _uuid = const Uuid();

  Future<void> init() async {
    _productsBox = await Hive.openBox<String>(AppConstants.productsBox);
    _purchasesBox = await Hive.openBox<String>(AppConstants.purchasesBox);

    if (_purchasesBox.isEmpty) {
      await _loadDefaultData();
    }
  }

  Box<String> get productsBox => _productsBox;
  Box<String> get purchasesBox => _purchasesBox;

  Future<void> _loadDefaultData() async {
    final now = DateTime.now();

    final defaultProducts = [
      {
        'barcode': '3017620422003',
        'name': 'Pâte à tartiner aux noisettes et au cacao',
        'brand': 'Nutella',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/301/762/042/2003/front_fr.4.200.jpg',
        'category': 'Pâte à tartiner',
        'nutriScore': 'e',
        'energyKcal': 539.0,
        'fat': 30.0,
        'saturatedFat': 10.0,
        'carbohydrates': 57.0,
        'sugars': 56.0,
        'proteins': 6.3,
        'salt': 0.107,
        'fibers': 0.0,
      },
      {
        'barcode': '5449000000996',
        'name': 'Coca-Cola Original',
        'brand': 'Coca-Cola',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/544/900/000/0996/front_fr.6.200.jpg',
        'category': 'Boissons gazeuses',
        'nutriScore': 'e',
        'energyKcal': 42.0,
        'fat': 0.0,
        'saturatedFat': 0.0,
        'carbohydrates': 10.6,
        'sugars': 10.6,
        'proteins': 0.0,
        'salt': 0.0,
        'fibers': 0.0,
      },
      {
        'barcode': '3017620421004',
        'name': 'Lait demi-écrémé',
        'brand': 'Lactel',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/301/762/042/1004/front_fr.5.200.jpg',
        'category': 'Lait demi-écrémé',
        'nutriScore': 'b',
        'energyKcal': 46.0,
        'fat': 1.5,
        'saturatedFat': 1.0,
        'carbohydrates': 4.8,
        'sugars': 4.8,
        'proteins': 3.2,
        'salt': 0.13,
        'fibers': 0.0,
      },
      {
        'barcode': '3046920027561',
        'name': 'Riz Basmati',
        'brand': 'Lesieur',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/304/692/002/7561/front_fr.5.200.jpg',
        'category': 'Riz',
        'nutriScore': 'a',
        'energyKcal': 130.0,
        'fat': 0.4,
        'saturatedFat': 0.1,
        'carbohydrates': 28.0,
        'sugars': 0.0,
        'proteins': 2.6,
        'salt': 0.005,
        'fibers': 0.4,
      },
      {
        'barcode': '3228021790012',
        'name': 'Chips Paprika',
        'brand': 'Lorenz',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/322/802/179/0012/front_fr.3.200.jpg',
        'category': 'Snacks salés',
        'nutriScore': 'd',
        'energyKcal': 487.0,
        'fat': 27.0,
        'saturatedFat': 3.5,
        'carbohydrates': 52.0,
        'sugars': 3.0,
        'proteins': 6.0,
        'salt': 1.5,
        'fibers': 4.0,
      },
      {
        'barcode': '3057640103742',
        'name': 'Eau minérale naturelle',
        'brand': 'Evian',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/305/764/010/3742/front_fr.6.200.jpg',
        'category': 'Eaux',
        'nutriScore': 'a',
        'energyKcal': 0.0,
        'fat': 0.0,
        'saturatedFat': 0.0,
        'carbohydrates': 0.0,
        'sugars': 0.0,
        'proteins': 0.0,
        'salt': 0.0,
        'fibers': 0.0,
      },
      {
        'barcode': '3017620425033',
        'name': 'Yaourt nature',
        'brand': 'Danone',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/301/762/042/5033/front_fr.4.200.jpg',
        'category': 'Yaourts',
        'nutriScore': 'a',
        'energyKcal': 59.0,
        'fat': 3.5,
        'saturatedFat': 2.3,
        'carbohydrates': 4.0,
        'sugars': 4.0,
        'proteins': 3.2,
        'salt': 0.11,
        'fibers': 0.0,
      },
      {
        'barcode': '3178530010303',
        'name': 'Pain de mie complet',
        'brand': 'Harrys',
        'imageUrl':
            'https://static.openfoodfacts.org/images/products/317/853/001/0303/front_fr.6.200.jpg',
        'category': 'Pains de mie',
        'nutriScore': 'b',
        'energyKcal': 254.0,
        'fat': 3.2,
        'saturatedFat': 0.6,
        'carbohydrates': 43.0,
        'sugars': 5.2,
        'proteins': 8.8,
        'salt': 1.0,
        'fibers': 5.5,
      },
    ];

    final defaultPurchases = [
      {
        'barcode': '3017620422003',
        'price': 3.49,
        'store': 'Carrefour',
        'daysAgo': 2
      },
      {
        'barcode': '3017620422003',
        'price': 3.29,
        'store': 'Leclerc',
        'daysAgo': 15
      },
      {
        'barcode': '3017620422003',
        'price': 3.79,
        'store': 'Auchan',
        'daysAgo': 25
      },
      {
        'barcode': '5449000000996',
        'price': 1.79,
        'store': 'Carrefour',
        'daysAgo': 5
      },
      {
        'barcode': '5449000000996',
        'price': 1.59,
        'store': 'Leclerc',
        'daysAgo': 18
      },
      {
        'barcode': '3017620421004',
        'price': 1.29,
        'store': 'Carrefour',
        'daysAgo': 3
      },
      {
        'barcode': '3017620421004',
        'price': 1.19,
        'store': 'Lidl',
        'daysAgo': 12
      },
      {
        'barcode': '3017620421004',
        'price': 1.35,
        'store': 'Casino',
        'daysAgo': 22
      },
      {
        'barcode': '3046920027561',
        'price': 2.49,
        'store': 'Carrefour',
        'daysAgo': 7
      },
      {
        'barcode': '3046920027561',
        'price': 2.29,
        'store': 'Leclerc',
        'daysAgo': 20
      },
      {
        'barcode': '3228021790012',
        'price': 2.99,
        'store': 'Carrefour',
        'daysAgo': 4
      },
      {
        'barcode': '3228021790012',
        'price': 2.49,
        'store': 'Aldi',
        'daysAgo': 14
      },
      {
        'barcode': '3057640103742',
        'price': 0.59,
        'store': 'Carrefour',
        'daysAgo': 1
      },
      {
        'barcode': '3057640103742',
        'price': 0.49,
        'store': 'Lidl',
        'daysAgo': 10
      },
      {
        'barcode': '3017620425033',
        'price': 1.49,
        'store': 'Carrefour',
        'daysAgo': 6
      },
      {
        'barcode': '3017620425033',
        'price': 1.29,
        'store': 'Biocoop',
        'daysAgo': 16
      },
      {
        'barcode': '3178530010303',
        'price': 1.79,
        'store': 'Carrefour',
        'daysAgo': 8
      },
      {
        'barcode': '3178530010303',
        'price': 1.59,
        'store': 'Intermarché',
        'daysAgo': 19
      },
    ];

    for (final productData in defaultProducts) {
      final product = Product(
        barcode: productData['barcode'] as String,
        name: productData['name'] as String,
        brand: productData['brand'] as String?,
        imageUrl: productData['imageUrl'] as String?,
        category: productData['category'] as String?,
        nutriScore: productData['nutriScore'] as String?,
        energyKcal: productData['energyKcal'] as double?,
        fat: productData['fat'] as double?,
        saturatedFat: productData['saturatedFat'] as double?,
        carbohydrates: productData['carbohydrates'] as double?,
        sugars: productData['sugars'] as double?,
        proteins: productData['proteins'] as double?,
        salt: productData['salt'] as double?,
        fibers: productData['fibers'] as double?,
      );
      await saveProduct(product);
    }

    for (final purchaseData in defaultPurchases) {
      final purchase = Purchase(
        id: _uuid.v4(),
        productBarcode: purchaseData['barcode'] as String,
        price: purchaseData['price'] as double,
        store: purchaseData['store'] as String,
        purchaseDate:
            now.subtract(Duration(days: purchaseData['daysAgo'] as int)),
      );
      await savePurchase(purchase);
    }
  }

  Future<void> saveProduct(Product product) async {
    await _productsBox.put(product.barcode, jsonEncode(product.toJson()));
  }

  Product? getProduct(String barcode) {
    final data = _productsBox.get(barcode);
    if (data == null) return null;
    return Product.fromJson(jsonDecode(data));
  }

  List<Product> getAllProducts() {
    return _productsBox.values
        .map((data) => Product.fromJson(jsonDecode(data)))
        .toList();
  }

  Future<void> savePurchase(Purchase purchase) async {
    await _purchasesBox.put(purchase.id, jsonEncode(purchase.toJson()));
  }

  Purchase? getPurchase(String id) {
    final data = _purchasesBox.get(id);
    if (data == null) return null;
    return Purchase.fromJson(jsonDecode(data));
  }

  List<Purchase> getAllPurchases() {
    final purchases = _purchasesBox.values
        .map((data) => Purchase.fromJson(jsonDecode(data)))
        .toList();
    purchases.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
    return purchases;
  }

  List<Purchase> getPurchasesByBarcode(String barcode) {
    return getAllPurchases().where((p) => p.productBarcode == barcode).toList();
  }

  List<Purchase> getPurchasesByStore(String store) {
    return getAllPurchases().where((p) => p.store == store).toList();
  }

  List<Purchase> getPurchasesByDateRange(DateTime start, DateTime end) {
    return getAllPurchases().where((p) {
      return p.purchaseDate.isAfter(start) && p.purchaseDate.isBefore(end);
    }).toList();
  }

  Future<void> deletePurchase(String id) async {
    await _purchasesBox.delete(id);
  }

  Future<void> deletePurchases(List<String> ids) async {
    for (final id in ids) {
      await _purchasesBox.delete(id);
    }
  }

  double getTotalSpending() {
    return getAllPurchases().fold(0, (sum, p) => sum + p.price);
  }

  double getMonthlySpending(int year, int month) {
    return getAllPurchases()
        .where(
            (p) => p.purchaseDate.year == year && p.purchaseDate.month == month)
        .fold(0, (sum, p) => sum + p.price);
  }

  Purchase? getLastPurchaseForProduct(String barcode) {
    final purchases = getPurchasesByBarcode(barcode);
    if (purchases.isEmpty) return null;
    return purchases.first;
  }

  Map<String, double> getSpendingByStore() {
    final Map<String, double> spending = {};
    for (final purchase in getAllPurchases()) {
      spending[purchase.store] =
          (spending[purchase.store] ?? 0) + purchase.price;
    }
    return spending;
  }

  Map<String, dynamic> getPriceStatsForProduct(String barcode) {
    final purchases = getPurchasesByBarcode(barcode);
    if (purchases.isEmpty) {
      return {'min': 0.0, 'max': 0.0, 'avg': 0.0, 'count': 0};
    }

    final prices = purchases.map((p) => p.price).toList();
    final min = prices.reduce((a, b) => a < b ? a : b);
    final max = prices.reduce((a, b) => a > b ? a : b);
    final avg = prices.reduce((a, b) => a + b) / prices.length;

    return {
      'min': min,
      'max': max,
      'avg': avg,
      'count': purchases.length,
    };
  }
}
