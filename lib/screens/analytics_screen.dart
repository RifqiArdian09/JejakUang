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
import '../widgets/glass_container.dart';
import '../models/transaction.dart';
import '../models/category.dart';

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
    for (Transaction tx in transactions) {
      if (tx.isExpense) {
        categorySpending[tx.categoryId] =
            (categorySpending[tx.categoryId] ?? 0) + tx.amount;
      }
    }

    // Prepare Pie Chart Data
    final pieSections = categorySpending.entries.map((entry) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => categories.isNotEmpty
            ? categories.first
            : Category(
                id: '0',
                name: 'Unknown',
                icon: 'question',
                color: 0xFF9E9E9E,
                isExpense: true,
              ),
      );
      return PieChartSectionData(
        value: entry.value,
        title: '',
        color: Color(category.color),
        radius: 35,
        showTitle: false,
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Analisis Keuangan', 'Financial Analytics'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white70),
            onPressed: () => ReportService.generatePdfReport(
              transactions,
              categories,
              wallets,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartSection(context, pieSections),
            const SizedBox(height: 48),
            _buildSectionHeader(
              context,
              S.text(context, 'Rincian Pengeluaran', 'Expense Details'),
            ),
            const SizedBox(height: 16),
            _buildCategoryList(categorySpending, categories, currency),
            const SizedBox(height: 40),
            _buildInsightSection(context, categorySpending, categories),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(
    BuildContext context,
    List<PieChartSectionData> sections,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      opacity: 0.05,
      blur: 20,
      border: Border.all(color: Colors.white.withOpacity(0.05)),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: sections.isEmpty
                ? Center(
                    child: Text(
                      S.text(
                        context,
                        'No expense data yet.',
                        'No expense data yet.',
                      ),
                      style: TextStyle(color: Colors.white.withOpacity(0.3)),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 4,
                          centerSpaceRadius: 70,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.pie_chart_outline_rounded,
                            color: Colors.white.withOpacity(0.3),
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'OVERVIEW',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildCategoryList(
    Map<String, double> spending,
    List<Category> categories,
    String currency,
  ) {
    if (spending.isEmpty) return const SizedBox();
    return Column(
      children: spending.entries.map((entry) {
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
          orElse: () => categories.isNotEmpty
              ? categories.first
              : Category(
                  id: '0',
                  name: '?',
                  icon: 'circle-question',
                  color: 0xFF9E9E9E,
                  isExpense: true,
                ),
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            opacity: 0.03,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(category.color),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(category.color).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  CurrencyUtils.format(entry.value, currency: currency),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInsightSection(
    BuildContext context,
    Map<String, double> spending,
    List<Category> categories,
  ) {
    String topCategory = '-';
    if (spending.isNotEmpty) {
      final topId =
          (spending.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first
              .key;
      topCategory = categories
          .firstWhere((c) => c.id == topId, orElse: () => categories.first)
          .name;
    }

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      opacity: 0.05,
      gradientColors: const [Color(0xFF2CC07B), Color(0xFF003820)],
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: Color(0xFF2CC07B),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.text(context, 'Kategori Boros', 'Spending Peak'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                Text(
                  topCategory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
