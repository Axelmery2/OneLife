import 'package:hive/hive.dart';

part 'saving.g.dart';

@HiveType(typeId: 5)
class Saving extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double targetAmount;

  @HiveField(3)
  double savedAmount;

  @HiveField(4)
  double remainingAmount;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? targetDate;

  @HiveField(7)
  List<String> history;

  Saving({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.remainingAmount,
    required this.createdAt,
    this.targetDate,
    required this.history,
  });

  Saving copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    double? remainingAmount,
    DateTime? createdAt,
    DateTime? targetDate,
    List<String>? history,
  }) {
    return Saving(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount:
          targetAmount ?? this.targetAmount,
      savedAmount:
          savedAmount ?? this.savedAmount,
      remainingAmount:
          remainingAmount ??
              this.remainingAmount,
      createdAt:
          createdAt ?? this.createdAt,
      targetDate:
          targetDate ?? this.targetDate,
      history:
          history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'remainingAmount': remainingAmount,
      'createdAt':
          createdAt.toIso8601String(),
      'targetDate':
          targetDate?.toIso8601String(),
      'history': history,
    };
  }

  factory Saving.fromMap(
    Map<String, dynamic> map,
  ) {
    return Saving(
      id: map['id'],
      title: map['title'] ?? '',
      targetAmount:
          (map['targetAmount'] as num)
              .toDouble(),
      savedAmount:
          (map['savedAmount'] as num)
              .toDouble(),
      remainingAmount:
          (map['remainingAmount']
                  as num)
              .toDouble(),
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
      targetDate:
          map['targetDate'] == null
              ? null
              : DateTime.parse(
                  map['targetDate'],
                ),
      history: List<String>.from(
        map['history'] ?? [],
      ),
    );
  }
}