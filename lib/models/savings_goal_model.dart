class SavingsGoalModel {
  final String id;

  final String title;

  final String? description;

  final double targetAmount;

  final double currentAmount;

  final DateTime? targetDate;

  final bool isArchived;

  final DateTime createdAt;

  final DateTime updatedAt;

  const SavingsGoalModel({
    required this.id,
    required this.title,
    this.description,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0;

    return (currentAmount / targetAmount) * 100;
  }

  bool get isCompleted {
    return currentAmount >= targetAmount;
  }

  SavingsGoalModel copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate':
          targetDate?.millisecondsSinceEpoch,
      'isArchived': isArchived,
      'createdAt':
          createdAt.millisecondsSinceEpoch,
      'updatedAt':
          updatedAt.millisecondsSinceEpoch,
    };
  }

  factory SavingsGoalModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return SavingsGoalModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      targetAmount:
          (map['targetAmount'] ?? 0).toDouble(),
      currentAmount:
          (map['currentAmount'] ?? 0).toDouble(),
      targetDate: map['targetDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['targetDate'],
            )
          : null,
      isArchived: map['isArchived'] ?? false,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? 0,
      ),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt'] ?? 0,
      ),
    );
  }
}