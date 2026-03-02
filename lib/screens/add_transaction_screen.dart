import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../models/wallet.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/currency_utils.dart';
import '../providers/language_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isExpense = true;
  Category? _selectedCategory;
  Wallet? _selectedWallet;
  DateTime _selectedDate = DateTime.now();
  final _ocrService = OcrService();
  bool _isScanning = false;

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _selectedWallet != null) {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: double.parse(_amountController.text),
        categoryId: _selectedCategory!.id,
        date: _selectedDate,
        note: _noteController.text,
        walletId: _selectedWallet!.id,
        isExpense: _isExpense,
      );

      ref.read(transactionsProvider.notifier).addTransaction(transaction);
      Navigator.pop(context);
    }
  }

  Future<void> _scanReceipt() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(S.text(context, 'Kamera', 'Camera')),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(S.text(context, 'Galeri', 'Gallery')),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final image = await _ocrService.pickImage(source);
      if (image != null) {
        setState(() => _isScanning = true);
        final result = await _ocrService.processReceipt(image);
        setState(() => _isScanning = false);

        if (result != null && result['total'] > 0) {
          _amountController.text = result['total'].toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                S.text(
                  context,
                  'Berhasil mengekstrak total harga!',
                  'Successfully extracted total price!',
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                S.text(
                  context,
                  'Gagal mengekstrak harga. Silakan isi manual.',
                  'Failed to extract price. Please fill manually.',
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref
        .watch(categoriesProvider)
        .where((c) => c.isExpense == _isExpense)
        .toList();
    final wallets = ref.watch(walletsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.text(context, 'Tambah Transaksi', 'Add Transaction')),
        actions: [
          IconButton(
            icon: _isScanning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.camera_alt),
            onPressed: _isScanning ? null : _scanReceipt,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Switcher
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isExpense = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isExpense
                              ? const Color(0xFFE63946)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          S.text(context, 'Pengeluaran', 'Expense'),
                          style: TextStyle(
                            color: _isExpense ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isExpense = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isExpense
                              ? const Color(0xFF2D6A4F)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          S.text(context, 'Pemasukan', 'Income'),
                          style: TextStyle(
                            color: !_isExpense ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Amount Input
              Text(
                S.text(context, 'Jumlah', 'Amount'),
                style: const TextStyle(color: Colors.black54),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  prefixText: _selectedWallet != null
                      ? CurrencyUtils.getSymbol(_selectedWallet!.currency)
                      : 'Rp ',
                  border: InputBorder.none,
                  hintText: '0',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return S.text(context, 'Masukkan jumlah', 'Enter amount');
                  if (double.tryParse(value) == null)
                    return S.text(
                      context,
                      'Jumlah tidak valid',
                      'Invalid amount',
                    );
                  return null;
                },
              ),
              const Divider(),
              const SizedBox(height: 20),

              // Category Picker
              Text(
                S.text(context, 'Kategori', 'Category'),
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) => val == null
                    ? S.text(context, 'Pilih kategori', 'Select category')
                    : null,
              ),
              const SizedBox(height: 20),

              // Wallet Picker
              Text(
                S.text(context, 'Dompet / Akun', 'Wallet / Account'),
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Wallet>(
                value: _selectedWallet,
                items: wallets
                    .map((w) => DropdownMenuItem(value: w, child: Text(w.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedWallet = val),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) => val == null
                    ? S.text(context, 'Pilih dompet', 'Select wallet')
                    : null,
              ),
              const SizedBox(height: 20),

              // Date Picker
              Text(
                S.text(context, 'Tanggal', 'Date'),
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat(
                          'dd MMMM yyyy',
                          S.text(context, 'id', 'en'),
                        ).format(_selectedDate),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Note Input
              Text(
                S.text(context, 'Catatan', 'Notes'),
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: S.text(
                    context,
                    'Tambahkan catatan...',
                    'Add a note...',
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    S.text(context, 'Simpan Transaksi', 'Save Transaction'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
