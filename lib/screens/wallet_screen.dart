import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wallet_provider.dart';
import '../utils/currency_utils.dart';
import '../providers/language_provider.dart';
import '../models/wallet.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Dompet Saya', 'My Wallets'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4332).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF1B4332),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${wallet.type} • ${wallet.currency}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  CurrencyUtils.format(
                    wallet.balance,
                    currency: wallet.currency,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF1B4332),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddWalletDialog(context, ref);
        },
        label: Text(S.text(context, 'Tambah Dompet', 'Add Wallet')),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
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
                onChanged: (val) => setState(() => selectedType = val!),
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
}
