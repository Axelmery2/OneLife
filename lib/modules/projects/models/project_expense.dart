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

  Map<String, dynamic> toMap() {
  return {
    'title': title,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(),
  };
}

factory ProjectExpense.fromMap(
  Map<String, dynamic> map,
) {
  return ProjectExpense(
    title: map['title'] ?? '',
    amount:
        (map['amount'] as num)
            .toDouble(),
    description:
        map['description'] ?? '',
    date: DateTime.parse(
      map['date'],
    ),
  );
}
}