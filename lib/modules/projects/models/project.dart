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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'budget': budget,
      'spentAmount': spentAmount,
      'progress': progress,
      'status': status,
      'createdAt':
          createdAt.toIso8601String(),
      'deadline':
          deadline?.toIso8601String(),
      'tasks': tasks
          .map(
            (task) => task.toMap(),
          )
          .toList(),
      'expenses': expenses
          .map(
            (expense) =>
                expense.toMap(),
          )
          .toList(),
    };
  }

  factory Project.fromMap(
    Map<String, dynamic> map,
  ) {
    return Project(
      id: map['id'],
      title: map['title'] ?? '',
      description:
          map['description'] ?? '',
      budget:
          (map['budget'] as num)
              .toDouble(),
      spentAmount:
          (map['spentAmount']
                  as num)
              .toDouble(),
      progress:
          map['progress'] ?? 0,
      status:
          map['status'] ??
              'En cours',
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
      deadline:
          map['deadline'] == null
              ? null
              : DateTime.parse(
                  map['deadline'],
                ),
      tasks:
          (map['tasks']
                      as List? ??
                  [])
              .map(
                (task) =>
                    ProjectTask.fromMap(
                  Map<String,
                      dynamic>.from(
                    task,
                  ),
                ),
              )
              .toList(),
      expenses:
          (map['expenses']
                      as List? ??
                  [])
              .map(
                (expense) =>
                    ProjectExpense
                        .fromMap(
                  Map<String,
                      dynamic>.from(
                    expense,
                  ),
                ),
              )
              .toList(),
    );
  }
}