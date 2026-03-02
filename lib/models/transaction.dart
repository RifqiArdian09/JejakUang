import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String note;

  @HiveField(5)
  final String walletId;

  @HiveField(6)
  final bool isExpense;

  Transaction({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note = '',
    required this.walletId,
    required this.isExpense,
  });
}
