import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../services/hive_service.dart';

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
      final box = Hive.box<Category>(HiveService.categoriesBox);
      return CategoryNotifier(box);
    });

class CategoryNotifier extends StateNotifier<List<Category>> {
  final Box<Category> _box;

  CategoryNotifier(this._box) : super([]) {
    _loadCategories();
  }

  void _loadCategories() {
    state = _box.values.toList();
  }

  Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
    _loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
    _loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
    _loadCategories();
  }
}
