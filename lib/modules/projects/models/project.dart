import 'package:hive/hive.dart';
import 'project_task.dart';
import 'project_expense.dart';

part 'project.g.dart';

@HiveType(typeId: 6)
class Project extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  double budget;

  @HiveField(4)
  double spentAmount;

  @HiveField(5)
  int progress;

  @HiveField(6)
  String status;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? deadline;

  @HiveField(9)
  List<ProjectTask> tasks;

  @HiveField(10)
  List<ProjectExpense> expenses;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.spentAmount,
    required this.progress,
    required this.status,
    required this.createdAt,
    this.deadline,
    required this.tasks,
    required this.expenses,
  });

  Project copyWith({
    String? id,
    String? title,
    String? description,
    double? budget,
    double? spentAmount,
    int? progress,
    String? status,
    DateTime? createdAt,
    DateTime? deadline,
    List<ProjectTask>? tasks,
    List<ProjectExpense>? expenses,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description:
          description ?? this.description,
      budget: budget ?? this.budget,
      spentAmount:
          spentAmount ?? this.spentAmount,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      createdAt:
          createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      tasks: tasks ?? this.tasks,
      expenses: expenses ?? this.expenses,
    );
  }
}