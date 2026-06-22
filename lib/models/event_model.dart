class EventModel {
  final String id;

  final String title;

  final String? description;

  final DateTime startDate;

  final DateTime? endDate;

  final bool isAllDay;

  final bool isCompleted;

  final bool isArchived;

  final String eventType;

  final DateTime createdAt;

  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    required this.isAllDay,
    required this.isCompleted,
    required this.isArchived,
    required this.eventType,
    required this.createdAt,
    required this.updatedAt,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    bool? isCompleted,
    bool? isArchived,
    String? eventType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAllDay: isAllDay ?? this.isAllDay,
      isCompleted: isCompleted ?? this.isCompleted,
      isArchived: isArchived ?? this.isArchived,
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'isCompleted': isCompleted,
      'isArchived': isArchived,
      'eventType': eventType,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory EventModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map['startDate'] ?? 0,
      ),
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['endDate'],
            )
          : null,
      isAllDay: map['isAllDay'] ?? false,
      isCompleted: map['isCompleted'] ?? false,
      isArchived: map['isArchived'] ?? false,
      eventType: map['eventType'] ?? 'event',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt'] ?? 0,
      ),
    );
  }
}