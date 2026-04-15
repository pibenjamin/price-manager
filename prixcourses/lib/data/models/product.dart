import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String barcode;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? brand;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String? category;

  @HiveField(5)
  final String? nutriScore;

  @HiveField(6)
  final DateTime createdAt;

  Product({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.category,
    this.nutriScore,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product.fromOpenFoodFacts(String barcode, Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;

    if (product == null) {
      throw Exception('Product not found');
    }

    return Product(
      barcode: barcode,
      name: product['product_name'] ?? product['product_name_fr'] ?? 'Unknown',
      brand: product['brands'],
      imageUrl: product['image_url'] ?? product['image_front_url'],
      category: product['categories'],
      nutriScore: product['nutriscore_grade']?.toString().toUpperCase(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'category': category,
      'nutriScore': nutriScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'],
      name: json['name'],
      brand: json['brand'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      nutriScore: json['nutriScore'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
