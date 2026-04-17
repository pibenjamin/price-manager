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

  @HiveField(7)
  final double? energyKcal;

  @HiveField(8)
  final double? fat;

  @HiveField(9)
  final double? saturatedFat;

  @HiveField(10)
  final double? carbohydrates;

  @HiveField(11)
  final double? sugars;

  @HiveField(12)
  final double? proteins;

  @HiveField(13)
  final double? salt;

  @HiveField(14)
  final double? fibers;

  @HiveField(15)
  final String? origins;

  Product({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.category,
    this.nutriScore,
    DateTime? createdAt,
    this.energyKcal,
    this.fat,
    this.saturatedFat,
    this.carbohydrates,
    this.sugars,
    this.proteins,
    this.salt,
    this.fibers,
    this.origins,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product.fromOpenFoodFacts(String barcode, Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    final nutriments = product?['nutriments'] as Map<String, dynamic>?;

    String? imageUrl = product?['image_small_url'] ??
        product?['image_front_url'] ??
        product?['image_url'];

    return Product(
      barcode: barcode,
      name:
          product?['product_name'] ?? product?['product_name_fr'] ?? 'Unknown',
      brand: product?['brands'],
      imageUrl: imageUrl,
      category: product?['categories'],
      nutriScore: product?['nutriscore_grade']?.toString().toUpperCase(),
      energyKcal: nutriments?['energy-kcal_100g']?.toDouble(),
      fat: nutriments?['fat_100g']?.toDouble(),
      saturatedFat: nutriments?['saturated-fat_100g']?.toDouble(),
      carbohydrates: nutriments?['carbohydrates_100g']?.toDouble(),
      sugars: nutriments?['sugars_100g']?.toDouble(),
      proteins: nutriments?['proteins_100g']?.toDouble(),
      salt: nutriments?['salt_100g']?.toDouble(),
      fibers: nutriments?['fiber_100g']?.toDouble(),
      origins: product?['origins'],
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
      'energyKcal': energyKcal,
      'fat': fat,
      'saturatedFat': saturatedFat,
      'carbohydrates': carbohydrates,
      'sugars': sugars,
      'proteins': proteins,
      'salt': salt,
      'fibers': fibers,
      'origins': origins,
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
      energyKcal: json['energyKcal']?.toDouble(),
      fat: json['fat']?.toDouble(),
      saturatedFat: json['saturatedFat']?.toDouble(),
      carbohydrates: json['carbohydrates']?.toDouble(),
      sugars: json['sugars']?.toDouble(),
      proteins: json['proteins']?.toDouble(),
      salt: json['salt']?.toDouble(),
      fibers: json['fibers']?.toDouble(),
      origins: json['origins'],
    );
  }
}
