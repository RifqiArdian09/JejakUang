import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget.dart';
import '../services/hive_service.dart';

final budgetsProvider = StateNotifierProvider<BudgetNotifier, List<Budget>>((
  ref,
) {
  final box = Hive.box<Budget>(HiveService.budgetsBox);
  return BudgetNotifier(box);
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
