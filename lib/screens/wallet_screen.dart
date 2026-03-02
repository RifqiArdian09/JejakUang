import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wallet_provider.dart';
import '../utils/currency_utils.dart';
import '../providers/language_provider.dart';
import '../models/wallet.dart';
import '../widgets/glass_container.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Dompet Saya', 'My Wallets'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: wallets.isEmpty
          ? Center(
              child: Text(
                S.text(context, 'Belum ada dompet.', 'No wallets yet.'),
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                160,
              ), // Added bottom padding to avoid navbar
              itemCount: wallets.length,
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: [
                      GlassContainer(
                        padding: const EdgeInsets.all(24),
                        borderRadius: 28,
                        opacity: 0.05,
                        blur: 20,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                          width: 1,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2CC07B,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: Color(0xFF2CC07B),
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                  ),
                                  color: Colors.red.withOpacity(0.5),
                                  onPressed: () =>
                                      _confirmDelete(context, ref, wallet),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              wallet.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${wallet.type} • ${wallet.currency}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              CurrencyUtils.format(
                                wallet.balance,
                                currency: wallet.currency,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Decorative gradient accent
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF2CC07B).withOpacity(0.05),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 100,
        ), // Adjusted to be above navbar
        child: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            _showAddWalletDialog(context, ref);
          },
          label: Text(
            S.text(context, 'Tambah Dompet', 'Add Wallet'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.add_rounded),
          backgroundColor: const Color(0xFF2CC07B),
          foregroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    String selectedType = 'Dompet';
    String selectedCurrency = 'IDR';
    final types = ['Dompet', 'Bank', 'E-wallet'];
    final currencies = CurrencyUtils.supportedCurrencies;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(S.text(context, 'Tambah Dompet Baru', 'Add New Wallet')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: S.text(context, 'Nama Dompet', 'Wallet Name'),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => selectedType = val!),
                decoration: InputDecoration(
                  labelText: S.text(context, 'Tipe', 'Type'),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCurrency,
                items: currencies
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCurrency = val!),
                decoration: InputDecoration(
                  labelText: S.text(context, 'Mata Uang', 'Currency'),
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
                if (nameController.text.isNotEmpty) {
                  final wallet = Wallet(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    balance: 0,
                    type: selectedType,
                    currency: selectedCurrency,
                  );
                  ref.read(walletsProvider.notifier).addWallet(wallet);
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Wallet wallet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141E30),
        title: Text(
          S.text(context, 'Hapus Dompet', 'Delete Wallet'),
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          S.text(
            context,
            'Hapus dompet "${wallet.name}"? Semua data transaksi terkait tidak akan hilang tapi dompet ini akan dihapus.',
            'Delete wallet "${wallet.name}"? This action cannot be undone.',
          ),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.text(context, 'Batal', 'Cancel')),
          ),
          TextButton(
            onPressed: () {
              ref.read(walletsProvider.notifier).deleteWallet(wallet.id);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
