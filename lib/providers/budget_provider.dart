import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget.dart';
import '../services/hive_service.dart';
import 'transaction_provider.dart';

final budgetsProvider = StateNotifierProvider<BudgetNotifier, List<Budget>>((
  ref,
) {
  final box = Hive.box<Budget>(HiveService.budgetsBox);
  return BudgetNotifier(box);
});

final computedBudgetsProvider = Provider<List<Budget>>((ref) {
  final budgets = ref.watch(budgetsProvider);
  final transactions = ref.watch(transactionsProvider);

  final now = DateTime.now();
  final currentMonthTransactions = transactions.where((tx) {
    return tx.date.year == now.year &&
        tx.date.month == now.month &&
        tx.isExpense;
  });

  return budgets.map((budget) {
    final spent = currentMonthTransactions
        .where((tx) => tx.categoryId == budget.categoryId)
        .fold<double>(0, (sum, tx) => sum + tx.amount);

    return Budget(
      id: budget.id,
      categoryId: budget.categoryId,
      amount: budget.amount,
      spent: spent,
      period: budget.period,
    );
  }).toList();
});

class BudgetNotifier extends StateNotifier<List<Budget>> {
  final Box<Budget> _box;

  BudgetNotifier(this._box) : super([]) {
    _load();
  }

  void _load() {
    state = _box.values.toList();
  }

  Future<void> addBudget(Budget budget) async {
    await _box.put(budget.id, budget);
    _load();
  }

  Future<void> updateBudget(Budget budget) async {
    await _box.put(budget.id, budget);
    _load();
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
    _load();
  }
}
