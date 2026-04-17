import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
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
      helpText: 'SÉLECTIONNER LA PÉRIODE',
      cancelText: 'ANNULER',
      confirmText: 'OK',
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

    final filteredPurchases = (startDate != null && endDate != null)
        ? purchases
            .where((p) =>
                p!.purchaseDate
                    .isAfter(startDate.subtract(const Duration(days: 1))) &&
                p.purchaseDate.isBefore(endDate.add(const Duration(days: 1))))
            .toList()
        : purchases;

    final monthlyTotal =
        filteredPurchases.fold<double>(0, (sum, p) => sum + p!.price);

    final now = DateTime.now();
    final List<({String month, double spending})> monthlyData = [];
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      final monthPurchases = purchases.where((p) =>
          p!.purchaseDate.year == date.year &&
          p.purchaseDate.month == date.month);
      final total = monthPurchases.fold<double>(0, (sum, p) => sum + p!.price);
      monthlyData.add((month: _frenchMonths[date.month - 1], spending: total));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('STATISTIQUES'),
        actions: [
          if (startDate != null && endDate != null)
            IconButton(
              icon: const Icon(Icons.clear, color: AppTheme.primaryNeonPink),
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
            InkWell(
              onTap: () => _selectDateRange(context, ref),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (startDate != null && endDate != null)
                        ? AppTheme.neonGreen
                        : AppTheme.primaryNeonCyan.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.date_range,
                      color: (startDate != null && endDate != null)
                          ? AppTheme.neonGreen
                          : AppTheme.primaryNeonCyan,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            startDate != null && endDate != null
                                ? '${_formatDate(startDate)} - ${_formatDate(endDate)}'
                                : 'TOUTE LA PÉRIODE',
                            style: TextStyle(
                              color: (startDate != null && endDate != null)
                                  ? AppTheme.neonGreen
                                  : AppTheme.primaryNeonCyan,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          if (startDate != null && endDate != null)
                            Text(
                              '${endDate.difference(startDate).inDays + 1} jours',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down,
                        color: AppTheme.primaryNeonCyan),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.primaryNeonCyan.withValues(alpha: 0.3),
                  AppTheme.primaryNeonPurple.withValues(alpha: 0.3)
                ]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryNeonCyan, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.primaryNeonCyan.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    startDate != null && endDate != null
                        ? 'TOTAL PÉRIODE'
                        : 'TOTAL GÉNÉRAL',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14, letterSpacing: 3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatPrice(monthlyTotal),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryNeonCyan,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.bgDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              AppTheme.primaryNeonPink.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '${filteredPurchases.length} ACHATS',
                      style: const TextStyle(
                        color: AppTheme.primaryNeonPink,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppTheme.primaryNeonPurple.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.show_chart, color: AppTheme.primaryNeonPurple),
                    SizedBox(width: 8),
                    Text(
                      'ÉVOLUTION (6 MOIS)',
                      style: TextStyle(
                        color: AppTheme.primaryNeonPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: monthlyData.isEmpty ||
                            monthlyData.every((d) => d.spending == 0)
                        ? const Center(
                            child: Text('PAS ASSEZ DE DONNÉES',
                                style: TextStyle(color: Colors.white54)))
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
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppTheme.primaryNeonCyan,
                                          AppTheme.primaryNeonPurple
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      width: 24,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
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
                                              color: AppTheme.primaryNeonCyan,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
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
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 20,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: AppTheme.primaryNeonCyan
                                      .withValues(alpha: 0.1),
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppTheme.primaryNeonPink.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.store, color: AppTheme.primaryNeonPink),
                    SizedBox(width: 8),
                    Text(
                      'DÉPENSES PAR MAGASIN',
                      style: TextStyle(
                        color: AppTheme.primaryNeonPink,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  if (spendingByStore.isEmpty)
                    const Text('Pas de données',
                        style: TextStyle(color: Colors.white54))
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryNeonPink
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatPrice(entry.value),
                                    style: const TextStyle(
                                      color: AppTheme.primaryNeonPink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Stack(children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppTheme.bgDark,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: percentage / 100,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.primaryNeonPink,
                                        AppTheme.primaryNeonPurple
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryNeonPink
                                            .withValues(alpha: 0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 4),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppTheme.primaryNeonCyan,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
