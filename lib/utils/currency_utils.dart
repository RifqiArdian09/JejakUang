import 'package:intl/intl.dart';

class CurrencyUtils {
  static final Map<String, Map<String, dynamic>> _currencyConfigs = {
    'IDR': {'locale': 'id_ID', 'symbol': 'Rp ', 'decimal': 0},
    'USD': {'locale': 'en_US', 'symbol': '\$ ', 'decimal': 2},
    'MYR': {'locale': 'ms_MY', 'symbol': 'RM ', 'decimal': 2},
    'EUR': {'locale': 'de_DE', 'symbol': '€ ', 'decimal': 2},
  };

  static String format(double amount, {String currency = 'IDR'}) {
    final config = _currencyConfigs[currency] ?? _currencyConfigs['IDR']!;
    final formatter = NumberFormat.currency(
      locale: config['locale'],
      symbol: config['symbol'],
      decimalDigits: config['decimal'],
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {String currency = 'IDR'}) {
    if (currency == 'IDR') {
      if (amount >= 1000000) {
        return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
      } else if (amount >= 1000) {
        return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
      }
    }
    return format(amount, currency: currency);
  }

  static List<String> get supportedCurrencies => _currencyConfigs.keys.toList();

  static String getSymbol(String currency) {
    return _currencyConfigs[currency]?['symbol'] ?? 'Rp ';
  }
}
