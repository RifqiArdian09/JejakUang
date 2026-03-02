import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon; // Icon name as string

  @HiveField(3)
  final int color; // Color as hex int

  @HiveField(4)
  final bool isExpense;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isExpense,
  });
}
