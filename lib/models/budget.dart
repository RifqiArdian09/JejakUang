import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 3)
class Budget extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final double spent;

  @HiveField(4)
  final String period; // e.g., 'Bulanan', 'Mingguan'

  Budget({
    required this.id,
    required this.categoryId,
    required this.amount,
    this.spent = 0,
    required this.period,
  });
}
