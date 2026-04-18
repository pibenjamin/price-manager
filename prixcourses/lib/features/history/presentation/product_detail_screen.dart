/// EPIC 3: Historique des Achats
/// STORY 3.2: Fiche Produit
///
/// Material Design 3 implementation with:
/// - M3 Cards and typography
/// - Proper colorScheme usage
/// - M3 Chips and Badges

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../data/models/product.dart';
import '../../scanner/providers/scanner_providers.dart';
import 'price_evolution_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;
  final String? purchaseId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.purchaseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastPurchase = ref.watch(lastPurchaseProvider(product.barcode));
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche produit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  if (product.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: colorScheme.surfaceContainerHighest,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.broken_image,
                            size: 80, color: colorScheme.outline),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (product.brand != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            product.brand!,
                            style: TextStyle(color: colorScheme.outline),
                          ),
                        ],
                        if (lastPurchase != null) ...[
                          const SizedBox(height: 16),
                          ListTile(
                            tileColor: colorScheme.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: const Icon(Icons.history),
                            title: const Text('Dernier prix'),
                            subtitle: Text(
                              '${currencyFormat.format(lastPurchase.price)} à ${lastPurchase.store}',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (product.nutriScore != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nutrition',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('NUTRI-SCORE'),
                          const Spacer(),
                          _buildNutriScoreBadge(product.nutriScore!),
                        ],
                      ),
                      const Divider(),
                      _buildNutrientRow(
                          'Énergie', product.energyKcal, 'kcal', colorScheme),
                      _buildNutrientRow(
                          'Matières grasses', product.fat, 'g', colorScheme),
                      _buildNutrientRow('  Acides gras saturés',
                          product.saturatedFat, 'g', colorScheme),
                      _buildNutrientRow(
                          'Glucides', product.carbohydrates, 'g', colorScheme),
                      _buildNutrientRow(
                          '  Sucres', product.sugars, 'g', colorScheme),
                      _buildNutrientRow(
                          'Protéines', product.proteins, 'g', colorScheme),
                      _buildNutrientRow('Sel', product.salt, 'g', colorScheme),
                      _buildNutrientRow(
                          'Fibres', product.fibers, 'g', colorScheme),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Divider(),
                    _buildInfoRow('Code-barres', product.barcode, colorScheme),
                    _buildInfoRow('Catégorie',
                        product.category ?? 'Non renseigné', colorScheme),
                    _buildInfoRow('Marque', product.brand ?? 'Non renseigné',
                        colorScheme),
                    _buildInfoRow('Origine',
                        product.origins ?? 'Non renseignée', colorScheme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PriceEvolutionScreen(product: product),
                  ),
                );
              },
              icon: const Icon(Icons.show_chart),
              label: const Text('Voir évolution du prix'),
            ),
            if (purchaseId != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _showDeleteDialog(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Supprimer cet achat'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNutriScoreBadge(String score) {
    final letters = ['A', 'B', 'C', 'D', 'E'];
    final colors = [
      const Color(0xFF00B050),
      const Color(0xFF92D050),
      const Color(0xFFFFC000),
      const Color(0xFFFF9900),
      const Color(0xFFFF0000),
    ];
    final selectedIndex = letters.indexOf(score.toUpperCase());

    return Row(
      children: List.generate(5, (index) {
        final isSelected = index == selectedIndex;
        return Container(
          margin: const EdgeInsets.only(left: 4),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isSelected
                ? colors[index]
                : colors[index].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: colors[index], width: isSelected ? 2 : 1),
          ),
          child: Center(
            child: Text(
              letters[index],
              style: TextStyle(
                color: isSelected ? Colors.white : colors[index],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNutrientRow(
      String label, double? value, String unit, ColorScheme colorScheme) {
    final displayValue =
        value != null ? '${value.toStringAsFixed(1)} $unit' : 'Non renseigné';
    final isSubItem = label.startsWith('  ');

    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: isSubItem ? 16 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isSubItem ? label.substring(2) : label,
            style: TextStyle(
              color: isSubItem ? colorScheme.outline : colorScheme.onSurface,
              fontSize: isSubItem ? 13 : 14,
            ),
          ),
          Text(
            displayValue,
            style: TextStyle(
              color: value != null ? colorScheme.primary : colorScheme.outline,
              fontWeight: isSubItem ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: colorScheme.outline),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cet achat ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(purchasesProvider.notifier).deletePurchase(purchaseId!);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Achat supprimé')),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
