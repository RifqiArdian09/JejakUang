import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
import '../providers/currency_provider.dart';
import '../providers/category_provider.dart';
import '../utils/currency_utils.dart';
import '../models/category.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCurrencyController =
      TextEditingController();
  List<String> _filteredCurrencies = CurrencyUtils.supportedCurrencies;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchCurrencyController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCurrencyController.dispose();
    super.dispose();
  }

  void _filterCurrencies() {
    final query = _searchCurrencyController.text.toLowerCase();
    setState(() {
      _filteredCurrencies = CurrencyUtils.supportedCurrencies.where((code) {
        final name = CurrencyUtils.getName(code).toLowerCase();
        return code.toLowerCase().contains(query) || name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isID = language.languageCode == 'id';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          S.text(context, 'Pengaturan', 'Settings'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: const Color(0xFF2CC07B),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2CC07B).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
              tabs: [
                Tab(text: S.text(context, 'BAHASA', 'LANGUAGE')),
                Tab(text: S.text(context, 'MATA UANG', 'CURRENCY')),
                Tab(text: S.text(context, 'KATEGORI', 'CATEGORIES')),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLanguageTab(isID),
          _buildCurrencyTab(isID),
          _buildCategoryTab(isID),
        ],
      ),
    );
  }

  // ─── LANGUAGE TAB ──────────────────────────────────────────────────────────

  Widget _buildLanguageTab(bool isID) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _sectionHeader(
          S.text(context, 'Pilih Bahasa Utama', 'Select Primary Language'),
        ),
        const SizedBox(height: 16),
        _languageTile(
          code: 'id',
          label: 'Bahasa Indonesia',
          subtitle: 'Indonesian',
          flag: '🇮🇩',
          isSelected: isID,
        ),
        const SizedBox(height: 12),
        _languageTile(
          code: 'en',
          label: 'English',
          subtitle: 'English',
          flag: '🇺🇸',
          isSelected: !isID,
        ),
      ],
    );
  }

  Widget _languageTile({
    required String code,
    required String label,
    required String subtitle,
    required String flag,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => ref.read(languageProvider.notifier).setLanguage(code),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        opacity: isSelected ? 0.08 : 0.03,
        border: Border.all(
          color: isSelected
              ? const Color(0xFF2CC07B)
              : Colors.white.withOpacity(0.05),
          width: isSelected ? 1.5 : 1,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected
                          ? const Color(0xFF2CC07B)
                          : Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF2CC07B)),
          ],
        ),
      ),
    );
  }

  // ─── CURRENCY TAB ──────────────────────────────────────────────────────────

  Widget _buildCurrencyTab(bool isID) {
    final selectedCurrency = ref.watch(currencyProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: GlassContainer(
            borderRadius: 20,
            opacity: 0.05,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextField(
              controller: _searchCurrencyController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: S.text(
                  context,
                  'Cari mata uang...',
                  'Search currency...',
                ),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF2CC07B),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _filteredCurrencies.length,
            itemBuilder: (context, index) {
              final code = _filteredCurrencies[index];
              final name = CurrencyUtils.getName(code);
              final isSelected = code == selectedCurrency;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () =>
                      ref.read(currencyProvider.notifier).setCurrency(code),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    borderRadius: 20,
                    opacity: isSelected ? 0.08 : 0.03,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2CC07B)
                          : Colors.white.withOpacity(0.05),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2CC07B)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            code,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF2CC07B)
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF2CC07B),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── CATEGORY TAB ──────────────────────────────────────────────────────────

  Widget _buildCategoryTab(bool isID) {
    final categories = ref.watch(categoriesProvider);
    final incomeCategories = categories.where((c) => !c.isExpense).toList();
    final expenseCategories = categories.where((c) => c.isExpense).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        _categorySection(
          title: S.text(context, 'KATEGORI PEMASUKAN', 'INCOME CATEGORIES'),
          categories: incomeCategories,
          isExpense: false,
          isID: isID,
          color: const Color(0xFF2CC07B),
        ),
        const SizedBox(height: 32),
        _categorySection(
          title: S.text(context, 'KATEGORI PENGELUARAN', 'EXPENSE CATEGORIES'),
          categories: expenseCategories,
          isExpense: true,
          isID: isID,
          color: const Color(0xFFFF5252),
        ),
      ],
    );
  }

  Widget _categorySection({
    required String title,
    required List<Category> categories,
    required bool isExpense,
    required bool isID,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.3),
                letterSpacing: 2,
              ),
            ),
            IconButton(
              onPressed: () =>
                  _showAddCategoryDialog(isExpense: isExpense, isID: isID),
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: color,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (categories.isEmpty)
          GlassContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: 24,
            opacity: 0.03,
            child: Center(
              child: Text(
                isID ? 'Belum ada kategori.' : 'No categories yet.',
                style: TextStyle(color: Colors.white.withOpacity(0.3)),
              ),
            ),
          )
        else
          ...categories.map((cat) => _categoryTile(cat, isID, color)),
      ],
    );
  }

  Widget _categoryTile(Category cat, bool isID, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(8),
        borderRadius: 20,
        opacity: 0.03,
        child: ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(cat.color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(cat.icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          title: Text(
            cat.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.white.withOpacity(0.2),
              size: 20,
            ),
            onPressed: () => _confirmDelete(cat, isID),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Category cat, bool isID) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF141E30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          isID ? 'Hapus Kategori?' : 'Delete Category?',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          isID
              ? 'Kategori "${cat.name}" akan dihapus.'
              : 'Category "${cat.name}" will be deleted.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isID ? 'Batal' : 'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(categoriesProvider.notifier).deleteCategory(cat.id);
              Navigator.pop(context);
            },
            child: Text(
              isID ? 'Hapus' : 'Delete',
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog({required bool isExpense, required bool isID}) {
    final nameController = TextEditingController();
    String selectedEmoji = isExpense ? '💸' : '💰';
    int selectedColor = isExpense ? 0xFFE63946 : 0xFF2CC07B;

    final emojis = isExpense
        ? [
            '💸',
            '🛒',
            '🏠',
            '🚗',
            '🍔',
            '👕',
            '💊',
            '📚',
            '🎮',
            '✈️',
            '📱',
            '⚡',
            '🐾',
            '🎁',
            '💇',
          ]
        : [
            '💰',
            '💼',
            '📈',
            '🏦',
            '🎯',
            '🎪',
            '💡',
            '🤝',
            '🏆',
            '💎',
            '🌟',
            '📦',
            '🎓',
            '🔧',
          ];

    final colors = [
      0xFF2CC07B,
      0xFF00D2FF,
      0xFFE63946,
      0xFFFFB703,
      0xFF2196F3,
      0xFF9C27B0,
      0xFFFF5722,
      0xFF607D8B,
    ];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: const Color(0xFF141E30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(
            isID
                ? 'Tambah Kategori ${isExpense ? "Pengeluaran" : "Pemasukan"}'
                : 'Add ${isExpense ? "Expense" : "Income"} Category',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: isID ? 'Nama Kategori' : 'Category Name',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _dialogSectionTitle(isID ? 'Pilih Ikon:' : 'Pick Icon:'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: emojis.map((e) {
                    final sel = e == selectedEmoji;
                    return GestureDetector(
                      onTap: () => setDialog(() => selectedEmoji = e),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFF2CC07B).withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel
                                ? const Color(0xFF2CC07B)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                _dialogSectionTitle(isID ? 'Pilih Warna:' : 'Pick Color:'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: colors.map((c) {
                    final sel = c == selectedColor;
                    return GestureDetector(
                      onTap: () => setDialog(() => selectedColor = c),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: sel
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                isID ? 'Batal' : 'Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final cat = Category(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    icon: selectedEmoji,
                    color: selectedColor,
                    isExpense: isExpense,
                  );
                  ref.read(categoriesProvider.notifier).addCategory(cat);
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2CC07B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isID ? 'Simpan' : 'Save',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    );
  }
}
