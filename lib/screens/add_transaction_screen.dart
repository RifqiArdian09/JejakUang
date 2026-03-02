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
import '../widgets/glass_container.dart';

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

      // In-app Notification
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
              'Berhasil mencatat transaksi',
              'Transaction recorded successfully',
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _scanReceipt() async {
    final image = await _ocrService.pickImage(ImageSource.camera);
    if (image != null) {
      setState(() => _isScanning = true);
      final result = await _ocrService.processReceipt(image);
      setState(() => _isScanning = false);

      if (result != null && result['total'] > 0) {
        _amountController.text = result['total'].toString();
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
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        title: Text(
          S.text(context, 'Tambah Transaksi', 'Add Transaction'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: _isScanning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.camera_alt, color: Colors.white70),
            onPressed: _isScanning ? null : _scanReceipt,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Switcher
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _typeTab(
                      S.text(context, 'PENGELUARAN', 'EXPENSE'),
                      true,
                      const Color(0xFFFF5252),
                    ),
                    const SizedBox(width: 8),
                    _typeTab(
                      S.text(context, 'PEMASUKAN', 'INCOME'),
                      false,
                      const Color(0xFF2CC07B),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Amount Input Section
              _fieldHeader(S.text(context, 'JUMLAH TOTAL', 'TOTAL AMOUNT')),
              const SizedBox(height: 8),
              GlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                borderRadius: 24,
                opacity: 0.05,
                child: Row(
                  children: [
                    Text(
                      _selectedWallet != null
                          ? CurrencyUtils.getSymbol(_selectedWallet!.currency)
                          : 'Rp ',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2CC07B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.white10),
                          isCollapsed: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return S.text(context, 'Isi jumlah', 'Fill amount');
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _buildGlassPicker(
                      title: S.text(context, 'KATEGORI', 'CATEGORY'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Category>(
                          value: _selectedCategory,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF161B22),
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val),
                          items: categories
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                          hint: Text(
                            S.text(context, 'Pilih', 'Select'),
                            style: const TextStyle(color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGlassPicker(
                      title: S.text(context, 'DOMPET', 'WALLET'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Wallet>(
                          value: _selectedWallet,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF161B22),
                          onChanged: (val) =>
                              setState(() => _selectedWallet = val),
                          items: wallets
                              .map(
                                (w) => DropdownMenuItem(
                                  value: w,
                                  child: Text(
                                    w.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                          hint: Text(
                            S.text(context, 'Pilih', 'Select'),
                            style: const TextStyle(color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _fieldHeader(S.text(context, 'TANGGAL', 'DATE')),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Color(0xFF2CC07B),
                          onPrimary: Colors.white,
                          surface: Color(0xFF161B22),
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
                child: GlassContainer(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  opacity: 0.05,
                  child: Row(
                    children: [
                      const Icon(Icons.today_rounded, color: Colors.white54),
                      const SizedBox(width: 16),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _fieldHeader(S.text(context, 'CATATAN (OPTIONAL)', 'NOTES')),
              const SizedBox(height: 8),
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                borderRadius: 20,
                opacity: 0.05,
                child: TextField(
                  controller: _noteController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: S.text(context, 'Beli apa...', 'Bought what...'),
                    hintStyle: const TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: _isExpense
                          ? [const Color(0xFFFF5252), const Color(0xFFD32F2F)]
                          : [const Color(0xFF2CC07B), const Color(0xFF003820)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isExpense
                                    ? const Color(0xFFFF5252)
                                    : const Color(0xFF2CC07B))
                                .withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      S.text(context, 'SIMPAN TRANSAKSI', 'SAVE TRANSACTION'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.5,
                      ),
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

  Widget _typeTab(String label, bool value, Color color) {
    final active = _isExpense == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isExpense = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.white38,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(0.3),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildGlassPicker({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(title),
        const SizedBox(height: 8),
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          borderRadius: 20,
          opacity: 0.05,
          child: child,
        ),
      ],
    );
  }
}
