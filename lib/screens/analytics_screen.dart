import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../utils/currency_utils.dart';
import '../services/report_service.dart';
import '../providers/wallet_provider.dart';
import '../providers/summary_provider.dart';
import '../providers/language_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);
    final wallets = ref.watch(walletsProvider);
    final summary = ref.watch(summaryProvider);
    final currency = summary['currency'] as String? ?? 'IDR';

    // Calculate category-wise spending
    final categorySpending = <String, double>{};
    for (var tx in transactions) {
      if (tx.isExpense) {
        categorySpending[tx.categoryId] =
            (categorySpending[tx.categoryId] ?? 0) + tx.amount;
      }
    }

    // Prepare Pie Chart Data
    final pieSections = categorySpending.entries.map((entry) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => categories.first,
      );
      return PieChartSectionData(
        value: entry.value,
        title: category.name,
        color: Color(category.color),
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Analisis Keuangan', 'Financial Analytics'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => ReportService.generatePdfReport(
              transactions,
              categories,
              wallets,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.text(
                context,
                'Pengeluaran Per Kategori',
                'Expenses by Category',
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Pie Chart
            SizedBox(
              height: 300,
              child: pieSections.isEmpty
                  ? Center(
                      child: Text(
                        S.text(
                          context,
                          'Belum ada data pengeluaran.',
                          'No expense data yet.',
                        ),
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        sections: pieSections,
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                      ),
                    ),
            ),

            const SizedBox(height: 40),

            Text(
              S.text(context, 'Rincian Pengeluaran', 'Expense Details'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Category List Breakdown
            ...categorySpending.entries.map((entry) {
              final category = categories.firstWhere(
                (c) => c.id == entry.key,
                orElse: () => categories.first,
              );
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(category.color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(category.name)),
                    Text(
                      CurrencyUtils.format(entry.value, currency: currency),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            // Rule-based Monthly Insights
            Text(
              S.text(context, 'Insight Bulanan', 'Monthly Insights'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _insightRow(
                    Icons.trending_up,
                    S.text(
                      context,
                      'Kategori paling boros: ',
                      'Most expensive category: ',
                    ),
                    categorySpending.isEmpty
                        ? '-'
                        : categories
                              .firstWhere(
                                (c) =>
                                    c.id ==
                                    (categorySpending.entries.toList()..sort(
                                          (a, b) => b.value.compareTo(a.value),
                                        ))
                                        .first
                                        .key,
                              )
                              .name,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _insightRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1B4332), size: 20),
        const SizedBox(width: 12),
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
