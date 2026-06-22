class ProjectModel {
  final String id;

  final String title;

  final String description;

  final double budget;

  final double spentAmount;

  final DateTime startDate;

  final DateTime? endDate;

  final String status;

  final bool autoProgress;

  final double manualProgress;

  final bool isFavorite;

  final bool isArchived;

  final List<String> attachments;

  final DateTime createdAt;

  final DateTime updatedAt;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.spentAmount,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.autoProgress,
    required this.manualProgress,
    required this.isFavorite,
    required this.isArchived,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingBudget {
    return budget - spentAmount;
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    double? budget,
    double? spentAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    bool? autoProgress,
    double? manualProgress,
    bool? isFavorite,
    bool? isArchived,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      spentAmount: spentAmount ?? this.spentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      autoProgress: autoProgress ?? this.autoProgress,
      manualProgress: manualProgress ?? this.manualProgress,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'budget': budget,
      'spentAmount': spentAmount,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'status': status,
      'autoProgress': autoProgress,
      'manualProgress': manualProgress,
      'isFavorite': isFavorite,
      'isArchived': isArchived,
      'attachments': attachments,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ProjectModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProjectModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      budget: (map['budget'] ?? 0).toDouble(),
      spentAmount: (map['spentAmount'] ?? 0).toDouble(),
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map['startDate'] ?? 0,
      ),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['endDate'],
            )
          : null,
      status: map['status'] ?? 'En cours',
      autoProgress: map['autoProgress'] ?? true,
      manualProgress:
          (map['manualProgress'] ?? 0).toDouble(),
      isFavorite: map['isFavorite'] ?? false,
      isArchived: map['isArchived'] ?? false,
      attachments:
          List<String>.from(map['attachments'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt'] ?? 0,
      ),
    );
  }
}