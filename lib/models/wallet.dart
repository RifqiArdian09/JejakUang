import 'package:hive/hive.dart';

part 'wallet.g.dart';

@HiveType(typeId: 1)
class Wallet extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double balance;

  @HiveField(3)
  final String type; // e.g., 'Dompet', 'Bank', 'E-wallet'

  @HiveField(4)
  final String currency; // e.g., 'IDR', 'USD', 'MYR', 'EUR'

  Wallet({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    this.currency = 'IDR',
  });

  Wallet copyWith({
    String? id,
    String? name,
    double? balance,
    String? type,
    String? currency,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      currency: currency ?? this.currency,
    );
  }
}
