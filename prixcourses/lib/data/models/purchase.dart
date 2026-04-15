import 'package:hive/hive.dart';

part 'purchase.g.dart';

@HiveType(typeId: 1)
class Purchase extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productBarcode;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String store;

  @HiveField(4)
  final DateTime purchaseDate;

  @HiveField(5)
  final String? receiptPhotoUrl;

  @HiveField(6)
  final DateTime createdAt;

  Purchase({
    required this.id,
    required this.productBarcode,
    required this.price,
    required this.store,
    required this.purchaseDate,
    this.receiptPhotoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productBarcode': productBarcode,
      'price': price,
      'store': store,
      'purchaseDate': purchaseDate.toIso8601String(),
      'receiptPhotoUrl': receiptPhotoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      productBarcode: json['productBarcode'],
      price: json['price'].toDouble(),
      store: json['store'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      receiptPhotoUrl: json['receiptPhotoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
