import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('IDR') {
    _loadCurrency();
  }

  static const String _boxName = 'settings';
  static const String _key = 'currency_code';

  Future<void> _loadCurrency() async {
    final box = await Hive.openBox(_boxName);
    final code = box.get(_key, defaultValue: 'IDR') as String;
    state = code;
  }

  Future<void> setCurrency(String code) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, code);
    state = code;
  }
}
