import 'package:hive/hive.dart';

part 'debt.g.dart';

@HiveType(typeId: 1)
class Debt extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String description;

  @HiveField(4)
  double totalAmount;

  @HiveField(5)
  double paidAmount;

  @HiveField(6)
  double remainingAmount;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? dueDate;

  @HiveField(9)
  List<String> history;

  Debt({
    required this.id,
    required this.name,
    required this.phone,
    required this.description,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.createdAt,
    required this.history,
    this.dueDate,
  });

  Debt copyWith({
    String? id,
    String? name,
    String? phone,
    String? description,
    double? totalAmount,
    double? paidAmount,
    double? remainingAmount,
    DateTime? createdAt,
    DateTime? dueDate,
    List<String>? history,
  }) {
    return Debt(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      history: history ?? this.history,
    );
  }
}