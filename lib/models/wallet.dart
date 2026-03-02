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

  Wallet({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
  });
}
