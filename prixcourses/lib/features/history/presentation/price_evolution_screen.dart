/// EPIC 3: Historique des Achats
/// STORY 3.3: Évolution des Prix
///
/// Responsabilités:
/// - Affiche l'historique des prix d'un produit
/// - Graphique d'évolution
/// - Liste détaillée des achats
///
/// Critères d'acceptation:
/// - GIVEN: L'utilisateur est sur la fiche produit
/// - WHEN: Il clique sur "Voir évolution du prix"
/// - THEN: L'écran montre l'évolution des prix

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/product.dart';
import '../../../data/models/purchase.dart';
import '../../scanner/providers/scanner_providers.dart';

class PriceEvolutionScreen extends ConsumerWidget {
  final Product product;

  const PriceEvolutionScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(purchasesProvider).cast<Purchase>();
    final productPurchases = purchases
        .where((p) => p.productBarcode == product.barcode)
        .toList()
      ..sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));

    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final colorScheme = Theme.of(context).colorScheme;

    double minPrice = 0;
    double maxPrice = 0;
    double avgPrice = 0;
    if (productPurchases.isNotEmpty) {
      final prices = productPurchases.map((p) => p.price).toList();
      minPrice = prices.reduce((a, b) => a < b ? a : b);
      maxPrice = prices.reduce((a, b) => a > b ? a : b);
      avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Évolution prix'),
      ),
      body: productPurchases.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 80,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pas assez de données',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enregistrez plus d\'achats pour voir l\'évolution',
                    style: TextStyle(color: colorScheme.outline),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn(context, 'MIN', minPrice,
                                  currencyFormat, Colors.green),
                              _buildStatColumn(context, 'MOY', avgPrice,
                                  currencyFormat, colorScheme.primary),
                              _buildStatColumn(context, 'MAX', maxPrice,
                                  currencyFormat, Colors.orange),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Chip(
                            label: Text('${productPurchases.length} achats'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.show_chart,
                                  color: colorScheme.tertiary),
                              const SizedBox(width: 8),
                              Text(
                                'Courbe des prix',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval:
                                      ((maxPrice - minPrice) / 4).clamp(0.5, 2),
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: colorScheme.outlineVariant,
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          '${value.toStringAsFixed(1)}€',
                                          style: TextStyle(
                                            color: colorScheme.outline,
                                            fontSize: 10,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index >= 0 &&
                                            index < productPurchases.length) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              dateFormat
                                                  .format(
                                                      productPurchases[index]
                                                          .purchaseDate)
                                                  .substring(0, 5),
                                              style: TextStyle(
                                                color: colorScheme.outline,
                                                fontSize: 9,
                                              ),
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                minY: (minPrice * 0.9).floorToDouble(),
                                maxY: (maxPrice * 1.1).ceilToDouble(),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: productPurchases
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return FlSpot(entry.key.toDouble(),
                                          entry.value.price);
                                    }).toList(),
                                    isCurved: true,
                                    curveSmoothness: 0.3,
                                    color: colorScheme.primary,
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, bar, index) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: colorScheme.primary,
                                          strokeWidth: 2,
                                          strokeColor: colorScheme.surface,
                                        );
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: colorScheme.primary
                                          .withValues(alpha: 0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.list, color: colorScheme.secondary),
                              const SizedBox(width: 8),
                              Text(
                                'Détail des achats',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        ...productPurchases.reversed.map((purchase) {
                          final isLowest = purchase.price == minPrice;
                          final isHighest = purchase.price == maxPrice;
                          final priceColor = isLowest
                              ? Colors.green
                              : isHighest
                                  ? Colors.orange
                                  : colorScheme.onSurface;

                          return ListTile(
                            title: Text(
                              dateFormat.format(purchase.purchaseDate),
                              style: TextStyle(color: colorScheme.outline),
                            ),
                            subtitle: Text(purchase.store),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: priceColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: priceColor),
                              ),
                              child: Text(
                                currencyFormat.format(purchase.price),
                                style: TextStyle(
                                  color: priceColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    double value,
    NumberFormat format,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          format.format(value),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
