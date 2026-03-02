import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../providers/summary_provider.dart';
import '../utils/currency_utils.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../providers/language_provider.dart';
import '../widgets/glass_container.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(computedBudgetsProvider);
    final categories = ref.watch(categoriesProvider);
    final summary = ref.watch(summaryProvider);
    final currency = summary['currency'] as String? ?? 'IDR';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Anggaran', 'Budget'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: budgets.isEmpty
          ? Center(
              child: Text(
                S.text(context, 'Belum ada anggaran.', 'No budgets yet.'),
                style: TextStyle(color: Colors.white.withOpacity(0.3)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                final category = categories.firstWhere(
                  (c) => c.id == budget.categoryId,
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
                final percent = (budget.spent / budget.amount).clamp(0.0, 1.0);
                final isOver = budget.spent > budget.amount;

                return GlassContainer(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 24,
                  opacity: 0.05,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(category.color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.category_rounded,
                              color: Color(category.color),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  budget.period,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white24,
                              size: 20,
                            ),
                            onPressed: () {
                              ref
                                  .read(budgetsProvider.notifier)
                                  .deleteBudget(budget.id);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(percent * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: isOver
                                  ? const Color(0xFFFF5252)
                                  : const Color(0xFF2CC07B),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${CurrencyUtils.format(budget.spent, currency: currency)} / ${CurrencyUtils.format(budget.amount, currency: currency)}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: AlwaysStoppedAnimation(
                            isOver
                                ? const Color(0xFFFF5252)
                                : const Color(0xFF2CC07B),
                          ),
                          minHeight: 12,
                        ),
                      ),
                      if (isOver)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            S.text(context, 'Melebihi batas!', 'Over budget!'),
                            style: const TextStyle(
                              color: Color(0xFFFF5252),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () =>
            _showAddBudgetDialog(context, ref, categories, currency),
        label: Text(
          S.text(context, 'Atur Anggaran', 'Set Budget'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: const Color(0xFF2CC07B),
        foregroundColor: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _showAddBudgetDialog(
    BuildContext context,
    WidgetRef ref,
    List<Category> categories,
    String currency,
  ) {
    final amountController = TextEditingController();
    Category? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            S.text(context, 'Set Budget Kategori', 'Set Category Budget'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Category>(
                value: selectedCategory,
                items: categories
                    .where((c) => c.isExpense)
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                decoration: InputDecoration(
                  labelText: S.text(context, 'Kategori', 'Category'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      '${S.text(context, 'Limit Anggaran', 'Budget Limit')} ($currency)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.text(context, 'Batal', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedCategory != null &&
                    amountController.text.isNotEmpty) {
                  final budget = Budget(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    categoryId: selectedCategory!.id,
                    amount: double.parse(amountController.text),
                    period: 'Bulanan',
                  );
                  ref.read(budgetsProvider.notifier).addBudget(budget);
                  Navigator.pop(context);
                }
              },
              child: Text(S.text(context, 'Simpan', 'Save')),
            ),
          ],
        ),
      ),
    );
  }
}
