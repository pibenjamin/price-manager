import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../data/models/product.dart';
import '../../../core/theme/app_theme.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('FICHE PRODUIT'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryNeonCyan),
              ),
              child: Column(
                children: [
                  if (product.imageUrl != null)
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(19)),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: AppTheme.bgDark,
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: AppTheme.primaryNeonCyan),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          color: AppTheme.bgDark,
                          child: const Icon(Icons.broken_image,
                              size: 80, color: AppTheme.primaryNeonPink),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        if (product.brand != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            product.brand!,
                            style: const TextStyle(
                                color: AppTheme.primaryNeonCyan, fontSize: 16),
                          ),
                        ],
                        if (lastPurchase != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryNeonCyan
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppTheme.primaryNeonCyan
                                      .withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'DERNIER PRIX',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  '${currencyFormat.format(lastPurchase.price)} à ${lastPurchase.store}',
                                  style: const TextStyle(
                                    color: AppTheme.primaryNeonCyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'NUTRITION',
              icon: Icons.restaurant_menu,
              color: AppTheme.neonGreen,
              child: Column(
                children: [
                  if (product.nutriScore != null) ...[
                    Row(
                      children: [
                        const Text('NUTRI-SCORE',
                            style: TextStyle(color: Colors.white70)),
                        const Spacer(),
                        _buildNutriScoreBadges(product.nutriScore!),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildNutrientRow('Énergie', product.energyKcal, 'kcal'),
                  _buildNutrientRow('Matières grasses', product.fat, 'g'),
                  _buildNutrientRow(
                      '  Acides gras saturés', product.saturatedFat, 'g'),
                  _buildNutrientRow('Glucides', product.carbohydrates, 'g'),
                  _buildNutrientRow('  Sucres', product.sugars, 'g'),
                  _buildNutrientRow('Protéines', product.proteins, 'g'),
                  _buildNutrientRow('Sel', product.salt, 'g'),
                  _buildNutrientRow('Fibres', product.fibers, 'g'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'INFORMATIONS',
              icon: Icons.info_outline,
              color: AppTheme.primaryNeonPink,
              child: Column(
                children: [
                  _buildInfoRow('Code-barres', product.barcode),
                  _buildInfoRow(
                      'Catégorie', product.category ?? 'Non renseigné'),
                  _buildInfoRow('Marque', product.brand ?? 'Non renseigné'),
                  _buildInfoRow('Origine', product.origins ?? 'Non renseignée'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PriceEvolutionScreen(product: product),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryNeonPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.show_chart),
              label: const Text(
                'VOIR ÉVOLUTION DU PRIX',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 12),
            if (purchaseId != null)
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppTheme.bgCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppTheme.primaryNeonPink),
                      ),
                      title: const Row(
                        children: [
                          Icon(Icons.warning, color: AppTheme.primaryNeonPink),
                          SizedBox(width: 8),
                          Text(
                            'SUPPRIMER CET ACHAT ?',
                            style: TextStyle(color: AppTheme.primaryNeonPink),
                          ),
                        ],
                      ),
                      content: const Text(
                        'Cette action est irréversible.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('ANNULER'),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryNeonPink),
                          onPressed: () {
                            ref
                                .read(purchasesProvider.notifier)
                                .deletePurchase(purchaseId!);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ACHAT SUPPRIMÉ'),
                                backgroundColor: AppTheme.primaryNeonPink,
                              ),
                            );
                          },
                          child: const Text('SUPPRIMER'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryNeonPink,
                  side: const BorderSide(color: AppTheme.primaryNeonPink),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text(
                  'SUPPRIMER CET ACHAT',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildNutriScoreBadges(String score) {
    final letters = ['A', 'B', 'C', 'D', 'E'];
    final selectedIndex = letters.indexOf(score.toUpperCase());
    final colors = [
      AppTheme.neonGreen,
      const Color(0xFF7CFC00),
      AppTheme.neonYellow,
      Colors.orange,
      const Color(0xFFFF4444),
    ];

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
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: colors[index],
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              letters[index],
              style: TextStyle(
                color: isSelected ? Colors.black : colors[index],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNutrientRow(String label, double? value, String unit) {
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
              color: isSubItem ? Colors.white54 : Colors.white70,
              fontSize: isSubItem ? 13 : 14,
            ),
          ),
          Text(
            displayValue,
            style: TextStyle(
              color: value != null ? AppTheme.primaryNeonCyan : Colors.white38,
              fontWeight: isSubItem ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
