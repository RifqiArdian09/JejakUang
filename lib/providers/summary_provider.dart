import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_provider.dart';
import 'wallet_provider.dart';
import 'currency_provider.dart';

final summaryProvider = Provider((ref) {
  final transactions = ref.watch(transactionsProvider);
  final wallets = ref.watch(walletsProvider);
  final currency = ref.watch(currencyProvider);

  double totalIncome = 0;
  double totalExpense = 0;

  for (var tx in transactions) {
    if (tx.isExpense) {
      totalExpense += tx.amount;
    } else {
      totalIncome += tx.amount;
    }
  }

  double totalBalance = 0;
  for (var wallet in wallets) {
    totalBalance += wallet.balance;
  }

  return {
    'totalIncome': totalIncome,
    'totalExpense': totalExpense,
    'totalBalance': totalBalance,
    'currentBalance': totalBalance,
    'currency': currency,
  };
});
