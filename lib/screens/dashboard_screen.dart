import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/summary_provider.dart';
import '../utils/currency_utils.dart';
import '../widgets/summary_card.dart';
import 'budget_screen.dart';
import 'goal_screen.dart';
import '../providers/language_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(summaryProvider);
    final currency = summary['currency'] as String? ?? 'IDR';
    final currentBalance =
        (summary['currentBalance'] as num?)?.toDouble() ?? 0.0;
    final totalIncome = (summary['totalIncome'] as num?)?.toDouble() ?? 0.0;
    final totalExpense = (summary['totalExpense'] as num?)?.toDouble() ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'JejakUang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.text(context, 'Halo, Selamat Datang!', 'Hello, Welcome!'),
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                S.text(context, 'Ringkasan Keuangan', 'Financial Summary'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B4332).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Saldo',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyUtils.format(currentBalance, currency: currency),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Income & Expense Row
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Pemasukan',
                      amount: CurrencyUtils.formatCompact(
                        totalIncome,
                        currency: currency,
                      ),
                      color: Colors.green,
                      icon: Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Pengeluaran',
                      amount: CurrencyUtils.formatCompact(
                        totalExpense,
                        currency: currency,
                      ),
                      color: Colors.red,
                      icon: Icons.arrow_downward,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                S.text(context, 'Layanan Pintar', 'Smart Services'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _featureCard(
                      context,
                      Icons.pie_chart,
                      S.text(context, 'Anggaran', 'Budget'),
                      S.text(context, 'Set limit bulanan', 'Set monthly limit'),
                      const BudgetScreen(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _featureCard(
                      context,
                      Icons.emoji_events,
                      S.text(context, 'Target', 'Goals'),
                      S.text(context, 'Tabungan masa depan', 'Future savings'),
                      const GoalScreen(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                S.text(context, 'Analisis AI Pintar', 'Smart AI Analysis'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // AI Insight Card (Rule-based Placeholder)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        totalExpense > totalIncome
                            ? S.text(
                                context,
                                'Wah, pengeluaranmu lebih besar dari pemasukan bulan ini. Coba cek lagi anggaranmu!',
                                'Whoops, your expenses are higher than your income this month. Check your budget!',
                              )
                            : S.text(
                                context,
                                'Bagus! Kamu berhasil menghemat ${CurrencyUtils.formatCompact(totalIncome - totalExpense, currency: currency)} bulan ini.',
                                'Great! You saved ${CurrencyUtils.formatCompact(totalIncome - totalExpense, currency: currency)} this month.',
                              ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.text(
                      context,
                      'Transaksi Terakhir',
                      'Recent Transactions',
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    S.text(context, 'Lihat Semua', 'View All'),
                    style: const TextStyle(
                      color: Color(0xFF1B4332),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Placeholder for transactions
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    S.text(
                      context,
                      'Belum ada transaksi.',
                      'No transactions yet.',
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget screen,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF6200EE)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
