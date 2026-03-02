import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import '../models/budget.dart';
import '../models/goal.dart';

class HiveService {
  static const String categoriesBox = 'categories';
  static const String transactionsBox = 'transactions';
  static const String walletsBox = 'wallets';
  static const String budgetsBox = 'budgets';
  static const String goalsBox = 'goals';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(WalletAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(BudgetAdapter());
    Hive.registerAdapter(GoalAdapter());

    // Open Boxes
    await Hive.openBox<Category>(categoriesBox);
    await Hive.openBox<Transaction>(transactionsBox);
    await Hive.openBox<Wallet>(walletsBox);
    await Hive.openBox<Budget>(budgetsBox);
    await Hive.openBox<Goal>(goalsBox);

    // Initial Data if empty
    await _seedInitialData();
  }

  Future<void> _seedInitialData() async {
    final categoryBox = Hive.box<Category>(categoriesBox);
    if (categoryBox.isEmpty) {
      final initialCategories = [
        Category(
          id: '1',
          name: 'Makanan',
          icon: 'utensils',
          color: 0xFFFF5252,
          isExpense: true,
        ),
        Category(
          id: '2',
          name: 'Transport',
          icon: 'car',
          color: 0xFF448AFF,
          isExpense: true,
        ),
        Category(
          id: '3',
          name: 'Hiburan',
          icon: 'gamepad',
          color: 0xFFFFAB40,
          isExpense: true,
        ),
        Category(
          id: '4',
          name: 'Gaji',
          icon: 'money-bill-wave',
          color: 0xFF4CAF50,
          isExpense: false,
        ),
      ];
      for (var cat in initialCategories) {
        await categoryBox.put(cat.id, cat);
      }
    }

    final walletBox = Hive.box<Wallet>(walletsBox);
    if (walletBox.isEmpty) {
      await walletBox.put(
        'main',
        Wallet(id: 'main', name: 'Dompet Utama', balance: 0, type: 'Dompet'),
      );
    }
  }
}
