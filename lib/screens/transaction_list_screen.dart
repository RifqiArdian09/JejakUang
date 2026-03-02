import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/language_provider.dart';
import '../providers/wallet_provider.dart';
import '../services/import_service.dart';
import '../widgets/transaction_item.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Riwayat Transaksi', 'Transaction History'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
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
                        content: Text(
                          S.text(
                            context,
                            'Berhasil mengimpor ${newTransactions.length} transaksi',
                            'Successfully imported ${newTransactions.length} transactions',
                          ),
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
              child: Text(
                S.text(context, 'Belum ada transaksi.', 'No transactions yet.'),
                style: const TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final category = categories.firstWhere(
                  (c) => c.id == tx.categoryId,
                  orElse: () => categories.first, // Fallback
                );
                return TransactionItem(transaction: tx, category: category);
              },
            ),
    );
  }
}
