import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/language_provider.dart';
import '../providers/wallet_provider.dart';
import '../services/import_service.dart';
import '../widgets/transaction_item.dart';
import '../models/category.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Riwayat Transaksi', 'Transaction History'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.file_download_outlined,
              color: Colors.white70,
            ),
            onPressed: () async {
              final wallets = ref.read(walletsProvider);
              if (wallets.isEmpty) return;

              final data = await ImportService.pickAndParseCsv();
              if (data != null) {
                final newTransactions = ImportService.mapCsvToTransactions(
                  data: data,
                  defaultWalletId: wallets.first.id,
                  defaultCategoryId: categories.first.id,
                );

                if (newTransactions.isNotEmpty) {
                  for (final tx in newTransactions) {
                    ref.read(transactionsProvider.notifier).addTransaction(tx);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF141E30),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Text(
                          S.text(
                            context,
                            'Berhasil mengimpor ${newTransactions.length} transaksi',
                            'Successfully imported ${newTransactions.length} transactions',
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 64,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.text(
                      context,
                      'Belum ada transaksi.',
                      'No transactions yet.',
                    ),
                    style: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final category = categories.firstWhere(
                  (c) => c.id == tx.categoryId,
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
                return TransactionItem(transaction: tx, category: category);
              },
            ),
    );
  }
}
