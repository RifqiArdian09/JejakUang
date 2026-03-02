import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../providers/summary_provider.dart';
import '../utils/currency_utils.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../providers/language_provider.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsProvider);
    final categories = ref.watch(categoriesProvider);
    final summary = ref.watch(summaryProvider);
    final currency = summary['currency'] as String? ?? 'IDR';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Anggaran', 'Budget'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: budgets.isEmpty
          ? Center(
              child: Text(
                S.text(context, 'Belum ada anggaran.', 'No budgets yet.'),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                final category = categories.firstWhere(
                  (c) => c.id == budget.categoryId,
                  orElse: () => categories.first,
                );
                final percent = (budget.spent / budget.amount).clamp(0.0, 1.0);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${(percent * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation(
                          percent > 0.9
                              ? const Color(0xFFE63946)
                              : const Color(0xFF1B4332),
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${S.text(context, 'Terpakai', 'Spent')}: ${CurrencyUtils.format(budget.spent, currency: currency)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Limit: ${CurrencyUtils.format(budget.amount, currency: currency)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _showAddBudgetDialog(context, ref, categories, currency),
        label: Text(S.text(context, 'Set Budget', 'Set Budget')),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
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
