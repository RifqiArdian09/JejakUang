import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/goal.dart';
import '../services/hive_service.dart';

final goalsProvider = StateNotifierProvider<GoalNotifier, List<Goal>>((ref) {
  final box = Hive.box<Goal>(HiveService.goalsBox);
  return GoalNotifier(box);
});

class GoalNotifier extends StateNotifier<List<Goal>> {
  final Box<Goal> _box;

  GoalNotifier(this._box) : super([]) {
    _load();
  }

  void _load() {
    state = _box.values.toList();
  }

  Future<void> addGoal(Goal goal) async {
    await _box.put(goal.id, goal);
    _load();
  }

  Future<void> updateGoal(Goal goal) async {
    await _box.put(goal.id, goal);
    _load();
  }

  Future<void> deleteGoal(String id) async {
    await _box.delete(id);
    _load();
  }
}
