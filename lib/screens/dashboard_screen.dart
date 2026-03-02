import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/summary_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../utils/currency_utils.dart';
import '../widgets/transaction_item.dart';
import 'settings_screen.dart'; // Added this import
import '../widgets/glass_container.dart';
import 'budget_screen.dart';
import 'goal_screen.dart';
import 'transaction_list_screen.dart';
import 'analytics_screen.dart';
import '../providers/language_provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(summaryProvider);
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);

    final currency = summary['currency'] as String? ?? 'IDR';
    final currentBalance =
        (summary['currentBalance'] as num?)?.toDouble() ?? 0.0;
    final totalIncome = (summary['totalIncome'] as num?)?.toDouble() ?? 0.0;
    final totalExpense = (summary['totalExpense'] as num?)?.toDouble() ?? 0.0;

    final recentTransactions = transactions.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final displayTransactions = recentTransactions.take(5).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        title: Text(
          'JejakUang',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white70),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildMainCard(context, currentBalance, currency),
              const SizedBox(height: 24),
              _buildSummaryRow(currency, totalIncome, totalExpense),
              const SizedBox(height: 32),
              _buildSectionTitle(
                context,
                S.text(context, 'Layanan Pintar', 'Smart Services'),
              ),
              const SizedBox(height: 16),
              _buildFeaturesGrid(context),
              const SizedBox(height: 32),
              _buildAIInsight(context, totalIncome, totalExpense, currency),
              const SizedBox(height: 32),
              _buildRecentTransactionsHeader(context),
              const SizedBox(height: 16),
              _buildRecentTransactionsList(displayTransactions, categories),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.text(context, 'Halo, Selamat Datang!', 'Hello, Welcome!'),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                S.text(context, 'Ringkasan Keuangan', 'My Finances'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, double balance, String currency) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Transform.scale(
        scale: 0.9 + (0.1 * value),
        child: Opacity(
          opacity: value,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                colors: [Color(0xFF003820), Color(0xFF2CC07B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2CC07B).withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  right: -50,
                  top: -50,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),
                Positioned(
                  left: -30,
                  bottom: -30,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            S.text(context, 'Total Saldo', 'Total Balance'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        child: Text(
                          CurrencyUtils.format(balance, currency: currency),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          // Navigate to Analytics
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AnalyticsScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: GlassContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          borderRadius: 12,
                          opacity: 0.1,
                          child: Text(
                            S.text(context, 'Lihat Rincian', 'View Details'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String currency, double income, double expense) {
    return Row(
      children: [
        Expanded(
          child: _glossyCard(
            title: 'Income',
            amount: CurrencyUtils.formatCompact(income, currency: currency),
            color: const Color(0xFF2CC07B),
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _glossyCard(
            title: 'Expense',
            amount: CurrencyUtils.formatCompact(expense, currency: currency),
            color: const Color(0xFFE63946),
            icon: Icons.arrow_downward_rounded,
          ),
        ),
      ],
    );
  }

  Widget _glossyCard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
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

  Widget _buildFeaturesGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _featureCardModern(
            context,
            Icons.auto_graph_rounded,
            S.text(context, 'Anggaran', 'Budget'),
            const Color(0xFF00D2FF),
            const BudgetScreen(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _featureCardModern(
            context,
            Icons.rocket_launch_rounded,
            S.text(context, 'Target', 'Goals'),
            const Color(0xFFFFB703),
            const GoalScreen(),
          ),
        ),
      ],
    );
  }

  Widget _featureCardModern(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    Widget screen,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      borderRadius: BorderRadius.circular(24),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        opacity: 0.03,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsight(
    BuildContext context,
    double income,
    double expense,
    String currency,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      opacity: 0.05,
      gradientColors: const [Colors.amber, Colors.orange],
      border: Border.all(color: Colors.amber.withOpacity(0.2)),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.amber),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              expense > income
                  ? S.text(
                      context,
                      'Ups! Pengeluaranmu melampaui batas hari ini.',
                      'Oops! Your spending exceeded the limit today.',
                    )
                  : S.text(
                      context,
                      'Luar Biasa! Saldo saat ini sangat aman.',
                      'Incredibile! Current balance is very safe.',
                    ),
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle(context, S.text(context, 'Terakhir', 'Recent')),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TransactionListScreen(),
              ),
            );
          },
          child: Text(
            S.text(context, 'Semua', 'All'),
            style: const TextStyle(
              color: Color(0xFF2CC07B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsList(
    List<Transaction> displayTransactions,
    List<Category> categories,
  ) {
    if (displayTransactions.isEmpty) {
      return Center(
        child: Text(
          'No records found',
          style: TextStyle(color: Colors.white.withOpacity(0.3)),
        ),
      );
    }
    return Column(
      children: displayTransactions.map((tx) {
        final category = categories.firstWhere(
          (c) => c.id == tx.categoryId,
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
          child: Theme(
            data: ThemeData.dark(),
            child: TransactionItem(transaction: tx, category: category),
          ),
        );
      }).toList(),
    );
  }
}
