import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 4)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final double currentAmount;

  @HiveField(4)
  final DateTime deadline;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    required this.deadline,
  });
}
