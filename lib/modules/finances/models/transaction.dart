import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String type;

  @HiveField(4)
  String category;

  @HiveField(5)
  String description;

  @HiveField(6)
  DateTime createdAt;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.createdAt,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? type,
    String? category,
    String? description,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      description:
          description ?? this.description,
      createdAt:
          createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'createdAt':
          createdAt.toIso8601String(),
    };
  }

  factory Transaction.fromMap(
    Map<String, dynamic> map,
  ) {
    return Transaction(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount:
          (map['amount'] ?? 0)
              .toDouble(),
      type: map['type'] ?? '',
      category:
          map['category'] ?? '',
      description:
          map['description'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
    );
  }
}