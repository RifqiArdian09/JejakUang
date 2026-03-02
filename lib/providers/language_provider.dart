import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('id')) {
    _loadLanguage();
  }

  static const String _boxName = 'settings';
  static const String _key = 'language_code';

  Future<void> _loadLanguage() async {
    final box = await Hive.openBox(_boxName);
    final code = box.get(_key, defaultValue: 'id');
    state = Locale(code);
  }

  Future<void> setLanguage(String code) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_key, code);
    state = Locale(code);
  }

  static String translate(BuildContext context, String keyID, String keyEN) {
    final locale = ProviderScope.containerOf(context).read(languageProvider);
    return locale.languageCode == 'id' ? keyID : keyEN;
  }
}

class S {
  static String text(BuildContext context, String id, String en) {
    final locale = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(languageProvider);
    return locale.languageCode == 'id' ? id : en;
  }
}
