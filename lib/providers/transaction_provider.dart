import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../services/hive_service.dart';
import 'wallet_provider.dart';

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
      final box = Hive.box<Transaction>(HiveService.transactionsBox);
      return TransactionNotifier(box, ref);
    });

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final Box<Transaction> _box;
  final Ref _ref;

  TransactionNotifier(this._box, this._ref) : super([]) {
    _load();
  }

  void _load() {
    state = _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
    _load();

    // Update Wallet Balance
    final wallets = _ref.read(walletsProvider);
    final walletIndex = wallets.indexWhere((w) => w.id == transaction.walletId);
    if (walletIndex != -1) {
      final wallet = wallets[walletIndex];
      final newBalance = transaction.isExpense
          ? wallet.balance - transaction.amount
          : wallet.balance + transaction.amount;

      final updatedWallet = wallet.copyWith(balance: newBalance);
      await _ref.read(walletsProvider.notifier).updateWallet(updatedWallet);
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final oldTransaction = _box.get(transaction.id);
    if (oldTransaction == null) return;

    // Revert old transaction's impact on balance
    final wallets = _ref.read(walletsProvider);
    final oldWalletIndex = wallets.indexWhere(
      (w) => w.id == oldTransaction.walletId,
    );
    if (oldWalletIndex != -1) {
      final oldWallet = wallets[oldWalletIndex];
      final revertedBalance = oldTransaction.isExpense
          ? oldWallet.balance + oldTransaction.amount
          : oldWallet.balance - oldTransaction.amount;

      final revertedWallet = oldWallet.copyWith(balance: revertedBalance);
      await _ref.read(walletsProvider.notifier).updateWallet(revertedWallet);
    }

    // Apply new transaction's impact
    await _box.put(transaction.id, transaction);
    _load();

    final newWallets = _ref.read(walletsProvider);
    final newWalletIndex = newWallets.indexWhere(
      (w) => w.id == transaction.walletId,
    );
    if (newWalletIndex != -1) {
      final newWallet = newWallets[newWalletIndex];
      final newBalance = transaction.isExpense
          ? newWallet.balance - transaction.amount
          : newWallet.balance + transaction.amount;

      final updatedWallet = newWallet.copyWith(balance: newBalance);
      await _ref.read(walletsProvider.notifier).updateWallet(updatedWallet);
    }
  }

  Future<void> deleteTransaction(String id) async {
    final transaction = _box.get(id);
    if (transaction != null) {
      // Revert transaction's impact on balance
      final wallets = _ref.read(walletsProvider);
      final walletIndex = wallets.indexWhere(
        (w) => w.id == transaction.walletId,
      );
      if (walletIndex != -1) {
        final wallet = wallets[walletIndex];
        final revertedBalance = transaction.isExpense
            ? wallet.balance + transaction.amount
            : wallet.balance - transaction.amount;

        final revertedWallet = wallet.copyWith(balance: revertedBalance);
        await _ref.read(walletsProvider.notifier).updateWallet(revertedWallet);
      }
    }

    await _box.delete(id);
    _load();
  }
}
