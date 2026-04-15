import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product.dart';
import '../../data/models/purchase.dart';
import '../../data/services/open_food_facts_service.dart';
import '../../data/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

// Services
final openFoodFactsServiceProvider = Provider((ref) => OpenFoodFactsService());
final localStorageServiceProvider = Provider((ref) => LocalStorageService());

// Scanner State
final scannedProductProvider = StateProvider<Product?>((ref) => null);
final isScanningProvider = StateProvider<bool>((ref) => false);
final isLoadingProductProvider = StateProvider<bool>((ref) => false);
final scannerErrorProvider = StateProvider<String?>((ref) => null);

// Purchases State
final purchasesProvider = StateNotifierProvider<PurchasesNotifier, List<Purchase>>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return PurchasesNotifier(storageService);
});

class PurchasesNotifier extends StateNotifier<List<Purchase>> {
  final LocalStorageService _storageService;
  final _uuid = const Uuid();

  PurchasesNotifier(this._storageService) : super([]) {
    _loadPurchases();
  }

  void _loadPurchases() {
    state = _storageService.getAllPurchases();
  }

  Future<void> addPurchase({
    required String productBarcode,
    required double price,
    required String store,
    required DateTime purchaseDate,
    String? receiptPhotoUrl,
  }) async {
    final purchase = Purchase(
      id: _uuid.v4(),
      productBarcode: productBarcode,
      price: price,
      store: store,
      purchaseDate: purchaseDate,
      receiptPhotoUrl: receiptPhotoUrl,
    );

    await _storageService.savePurchase(purchase);
    _loadPurchases();
  }

  Future<void> deletePurchase(String id) async {
    await _storageService.deletePurchase(id);
    _loadPurchases();
  }

  void refresh() {
    _loadPurchases();
  }
}

// Last Purchase for Product
final lastPurchaseProvider = Provider.family<Purchase?, String>((ref, barcode) {
  final purchases = ref.watch(purchasesProvider);
  final productPurchases = purchases.where((p) => p.productBarcode == barcode);
  return productPurchases.isEmpty ? null : productPurchases.first;
});

// Products Cache
final productsCacheProvider = StateNotifierProvider<ProductsCacheNotifier, Map<String, Product>>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return ProductsCacheNotifier(storageService);
});

class ProductsCacheNotifier extends StateNotifier<Map<String, Product>> {
  final LocalStorageService _storageService;

  ProductsCacheNotifier(this._storageService) : super({});

  Product? getProduct(String barcode) {
    if (state.containsKey(barcode)) {
      return state[barcode];
    }
    return _storageService.getProduct(barcode);
  }

  Future<Product?> fetchAndCacheProduct(String barcode) async {
    final openFoodFacts = OpenFoodFactsService();
    
    try {
      final product = await openFoodFacts.getProductByBarcode(barcode);
      if (product != null) {
        await _storageService.saveProduct(product);
        state = {...state, barcode: product};
      }
      return product;
    } catch (e) {
      return null;
    }
  }
}

// Analytics
final monthlySpendingProvider = Provider.family<double, ({int year, int month})>((ref, params) {
  final purchases = ref.watch(purchasesProvider);
  return purchases
      .where((p) => p.purchaseDate.year == params.year && p.purchaseDate.month == params.month)
      .fold(0, (sum, p) => sum + p.price);
});

final spendingByStoreProvider = Provider<Map<String, double>>((ref) {
  final purchases = ref.watch(purchasesProvider);
  final Map<String, double> spending = {};
  for (final purchase in purchases) {
    spending[purchase.store] = (spending[purchase.store] ?? 0) + purchase.price;
  }
  return spending;
});
