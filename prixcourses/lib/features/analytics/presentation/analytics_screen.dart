import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/scanner_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(purchasesProvider);
    final spendingByStore = ref.watch(spendingByStoreProvider);
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    // Calculate current month spending
    final now = DateTime.now();
    final currentMonthPurchases = purchases.where((p) =>
        p.purchaseDate.year == now.year &&
        p.purchaseDate.month == now.month);
    final monthlyTotal =
        currentMonthPurchases.fold<double>(0, (sum, p) => sum + p.price);

    // Calculate previous months spending for chart
    final List<({String month, double spending})> monthlyData = [];
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      final monthPurchases = purchases.where((p) =>
          p.purchaseDate.year == date.year &&
          p.purchaseDate.month == date.month);
      final total =
          monthPurchases.fold<double>(0, (sum, p) => sum + p.price);
      monthlyData.add((
        month: DateFormat('MMM', 'fr_FR').format(date).substring(0, 3),
        spending: total,
      ));
    }

    if (purchases.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Pas encore de données',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enregistrez vos achats pour voir les statistiques',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Monthly Spending Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Ce mois',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(monthlyTotal),
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${currentMonthPurchases.length} achats',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Spending Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Évolution (6 derniers mois)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: monthlyData.isEmpty ||
                              monthlyData.every((d) => d.spending == 0)
                          ? const Center(child: Text('Pas assez de données'))
                          : BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: monthlyData
                                        .map((d) => d.spending)
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.2,
                                barGroups: monthlyData.asMap().entries.map((e) {
                                  return BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value.spending,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 20,
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
                                        SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles:
                                        SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles:
                                        SideTitles(showTitles: false),
                                  ),
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
                                              style: const TextStyle(
                                                  fontSize: 10),
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
            const SizedBox(height: 24),

            // Spending by Store
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dépenses par magasin',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    if (spendingByStore.isEmpty)
                      const Text('Pas de données')
                    else
                      ...spendingByStore.entries
                          .toList()
                          ..sort((a, b) => b.value.compareTo(a.value))
                          ..take(5).map((entry) {
                        final total = spendingByStore.values
                            .fold<double>(0, (a, b) => a + b);
                        final percentage = (entry.value / total * 100);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key),
                                  Text(
                                    currencyFormat.format(entry.value),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey[200],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
