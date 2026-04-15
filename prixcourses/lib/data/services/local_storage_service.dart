import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/product.dart';
import '../models/purchase.dart';
import '../../core/constants/app_constants.dart';

class LocalStorageService {
  late Box<String> _productsBox;
  late Box<String> _purchasesBox;

  Future<void> init() async {
    _productsBox = await Hive.openBox<String>(AppConstants.productsBox);
    _purchasesBox = await Hive.openBox<String>(AppConstants.purchasesBox);
  }

  // Products
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

  // Purchases
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
    return getAllPurchases()
        .where((p) => p.productBarcode == barcode)
        .toList();
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

  // Statistics
  double getTotalSpending() {
    return getAllPurchases().fold(0, (sum, p) => sum + p.price);
  }

  double getMonthlySpending(int year, int month) {
    return getAllPurchases()
        .where((p) =>
            p.purchaseDate.year == year && p.purchaseDate.month == month)
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
}
