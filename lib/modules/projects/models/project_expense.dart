import 'package:hive/hive.dart';

part 'project_expense.g.dart';

@HiveType(typeId: 8)
class ProjectExpense extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime date;

  ProjectExpense({
    required this.title,
    required this.amount,
    required this.description,
    required this.date,
  });
}