/// EPIC 4: Statistiques
/// STORY 4.1: Écran Analytics
///
/// Responsabilités:
/// - Affiche les stats de dépenses
/// - Filtre par période
/// - Graphiques d'évolution
///
/// Critères d'acceptation:
/// - GIVEN: L'utilisateur est sur l'écran Stats
/// - WHEN: Il voit ses statistiques
/// - THEN: Total dépenses, graphique, répartition par magasin

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../scanner/providers/scanner_providers.dart';
import '../../../data/models/purchase.dart';

final startDateProvider = StateProvider<DateTime?>((ref) => null);
final endDateProvider = StateProvider<DateTime?>((ref) => null);

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  static const _frenchMonths = [
    'Jan',
    'Fév',
    'Mar',
    'Avr',
    'Mai',
    'Juin',
    'Juil',
    'Août',
    'Sep',
    'Oct',
    'Nov',
    'Déc'
  ];

  String _formatPrice(double value) => '${value.toStringAsFixed(2)} €';

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${_frenchMonths[date.month - 1]}/${date.year}';

  Future<void> _selectDateRange(BuildContext context, WidgetRef ref) async {
    final startDate = ref.read(startDateProvider);
    final endDate = ref.read(endDateProvider);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate, end: endDate)
          : DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 30)),
              end: DateTime.now(),
            ),
    );

    if (picked != null) {
      ref.read(startDateProvider.notifier).state = picked.start;
      ref.read(endDateProvider.notifier).state = picked.end;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(purchasesProvider).cast<Purchase>();
    final spendingByStore = ref.watch(spendingByStoreProvider);
    final startDate = ref.watch(startDateProvider);
    final endDate = ref.watch(endDateProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final filteredPurchases = (startDate != null && endDate != null)
        ? purchases
            .where((p) =>
                p.purchaseDate
                    .isAfter(startDate.subtract(const Duration(days: 1))) &&
                p.purchaseDate.isBefore(endDate.add(const Duration(days: 1))))
            .toList()
        : purchases;

    final monthlyTotal =
        filteredPurchases.fold<double>(0, (sum, p) => sum + p.price);

    final now = DateTime.now();
    final List<({String month, double spending})> monthlyData = [];
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      final monthPurchases = purchases.where((p) =>
          p.purchaseDate.year == date.year &&
          p.purchaseDate.month == date.month);
      final total = monthPurchases.fold<double>(0, (sum, p) => sum + p.price);
      monthlyData.add((month: _frenchMonths[date.month - 1], spending: total));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          if (startDate != null && endDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                ref.read(startDateProvider.notifier).state = null;
                ref.read(endDateProvider.notifier).state = null;
              },
              tooltip: 'Réinitialiser',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _selectDateRange(context, ref),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: startDate != null && endDate != null
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              startDate != null && endDate != null
                                  ? '${_formatDate(startDate)} - ${_formatDate(endDate)}'
                                  : 'Toute la période',
                              style: TextStyle(
                                color: startDate != null && endDate != null
                                    ? colorScheme.onSurface
                                    : colorScheme.outline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (startDate != null && endDate != null)
                              Text(
                                '${endDate.difference(startDate).inDays + 1} jours',
                                style: TextStyle(
                                  color: colorScheme.outline,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: colorScheme.outline),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      startDate != null && endDate != null
                          ? 'TOTAL PÉRIODE'
                          : 'TOTAL GÉNÉRAL',
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatPrice(monthlyTotal),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${filteredPurchases.length} achats',
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                        Icon(Icons.show_chart, color: colorScheme.tertiary),
                        const SizedBox(width: 8),
                        Text(
                          'Évolution (6 mois)',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: monthlyData.isEmpty ||
                              monthlyData.every((d) => d.spending == 0)
                          ? Center(
                              child: Text(
                                'Pas assez de données',
                                style: TextStyle(color: colorScheme.outline),
                              ),
                            )
                          : BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: (monthlyData
                                            .map((d) => d.spending)
                                            .reduce((a, b) => a > b ? a : b) *
                                        1.3)
                                    .ceilToDouble(),
                                barGroups: monthlyData.asMap().entries.map((e) {
                                  return BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value.spending,
                                        color: colorScheme.primary,
                                        width: 24,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index >= 0 &&
                                            index < monthlyData.length) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              monthlyData[index].month,
                                              style: TextStyle(
                                                color: colorScheme.outline,
                                                fontSize: 10,
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
                                gridData: const FlGridData(show: false),
                              ),
                            ),
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
                        Icon(Icons.store, color: colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'Dépenses par magasin',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (spendingByStore.isEmpty)
                      Text(
                        'Pas de données',
                        style: TextStyle(color: colorScheme.outline),
                      )
                    else
                      ...((spendingByStore.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value)))
                          .take(5)
                          .map((entry) {
                        final total = spendingByStore.values
                            .fold<double>(0, (a, b) => a + b);
                        final percentage = (entry.value / total * 100);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    _formatPrice(entry.value),
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  minHeight: 8,
                                  backgroundColor:
                                      colorScheme.surfaceContainerHighest,
                                  color: colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: colorScheme.outline,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
