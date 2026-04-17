import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/product.dart';
import '../../../data/models/purchase.dart';
import '../../../core/theme/app_theme.dart';
import '../../scanner/providers/scanner_providers.dart';

class PriceEvolutionScreen extends ConsumerWidget {
  final Product product;

  const PriceEvolutionScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(purchasesProvider).cast<Purchase>();
    final productPurchases = purchases
        .where((p) => p!.productBarcode == product.barcode)
        .toList()
      ..sort((a, b) => a!.purchaseDate.compareTo(b!.purchaseDate));

    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final dateFormat = DateFormat('dd/MM/yyyy');

    double minPrice = 0;
    double maxPrice = 0;
    double avgPrice = 0;
    if (productPurchases.isNotEmpty) {
      final prices = productPurchases.map((p) => p!.price).toList();
      minPrice = prices.reduce((a, b) => a < b ? a : b);
      maxPrice = prices.reduce((a, b) => a > b ? a : b);
      avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ÉVOLUTION PRIX'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: productPurchases.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 80,
                    color: AppTheme.primaryNeonPurple.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PAS ASSEZ DE DONNÉES',
                    style: TextStyle(
                      color: AppTheme.primaryNeonPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enregistrez plus d\'achats pour voir l\'évolution',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryNeonCyan.withValues(alpha: 0.3),
                          AppTheme.primaryNeonPurple.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryNeonCyan),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppTheme.primaryNeonCyan.withValues(alpha: 0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard('MIN', minPrice, AppTheme.neonGreen,
                                currencyFormat),
                            _buildStatCard('MOYEN', avgPrice,
                                AppTheme.primaryNeonCyan, currencyFormat),
                            _buildStatCard('MAX', maxPrice,
                                AppTheme.primaryNeonPink, currencyFormat),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.bgDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${productPurchases.length} ACHATS ENREGISTRÉS',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.primaryNeonPurple
                              .withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.show_chart,
                                color: AppTheme.primaryNeonPurple, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'COURBE DES PRIX',
                              style: TextStyle(
                                color: AppTheme.primaryNeonPurple,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval:
                                    ((maxPrice - minPrice) / 4).clamp(0.5, 2),
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: AppTheme.primaryNeonCyan
                                      .withValues(alpha: 0.1),
                                  strokeWidth: 1,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toStringAsFixed(1)}€',
                                        style: const TextStyle(
                                          color: AppTheme.primaryNeonCyan,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
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
                                            DateFormat('dd/MM').format(
                                                productPurchases[index]!
                                                    .purchaseDate),
                                            style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 9),
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
                                        entry.value!.price);
                                  }).toList(),
                                  isCurved: true,
                                  curveSmoothness: 0.3,
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.primaryNeonCyan,
                                      AppTheme.primaryNeonPurple
                                    ],
                                  ),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, bar, index) {
                                      return FlDotCirclePainter(
                                        radius: 4,
                                        color: AppTheme.primaryNeonCyan,
                                        strokeWidth: 2,
                                        strokeColor: AppTheme.bgDark,
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppTheme.primaryNeonCyan
                                            .withValues(alpha: 0.3),
                                        AppTheme.primaryNeonPurple
                                            .withValues(alpha: 0.1),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.neonYellow.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.list,
                                  color: AppTheme.neonYellow, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'DÉTAIL DES ACHATS',
                                style: TextStyle(
                                  color: AppTheme.neonYellow,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.white12, height: 1),
                        ...productPurchases.reversed.map((purchase) {
                          final isLowest = purchase!.price == minPrice;
                          final isHighest = purchase.price == maxPrice;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.white10)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    dateFormat.format(purchase.purchaseDate),
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    purchase.store,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isLowest
                                        ? AppTheme.neonGreen
                                            .withValues(alpha: 0.2)
                                        : isHighest
                                            ? AppTheme.primaryNeonPink
                                                .withValues(alpha: 0.2)
                                            : AppTheme.primaryNeonCyan
                                                .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isLowest
                                          ? AppTheme.neonGreen
                                          : isHighest
                                              ? AppTheme.primaryNeonPink
                                              : AppTheme.primaryNeonCyan,
                                    ),
                                  ),
                                  child: Text(
                                    currencyFormat.format(purchase.price),
                                    style: TextStyle(
                                      color: isLowest
                                          ? AppTheme.neonGreen
                                          : isHighest
                                              ? AppTheme.primaryNeonPink
                                              : AppTheme.primaryNeonCyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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

  Widget _buildStatCard(
      String label, double value, Color color, NumberFormat format) {
    return Column(
      children: [
        Text(
          label,
          style:
              TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1),
        ),
        const SizedBox(height: 4),
        Text(
          format.format(value),
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
