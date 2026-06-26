import 'package:hive/hive.dart';

part 'creance.g.dart';

@HiveType(typeId: 2)
class Creance extends HiveObject {
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

  Creance({
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

  Creance copyWith({
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
    return Creance(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      description:
          description ?? this.description,
      totalAmount:
          totalAmount ?? this.totalAmount,
      paidAmount:
          paidAmount ?? this.paidAmount,
      remainingAmount:
          remainingAmount ??
          this.remainingAmount,
      createdAt:
          createdAt ?? this.createdAt,
      dueDate:
          dueDate ?? this.dueDate,
      history:
          history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'description': description,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'createdAt':
          createdAt.toIso8601String(),
      'dueDate':
          dueDate?.toIso8601String(),
      'history': history,
    };
  }

  factory Creance.fromMap(
    Map<String, dynamic> map,
  ) {
    return Creance(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      description:
          map['description'] ?? '',
      totalAmount:
          (map['totalAmount'] as num)
              .toDouble(),
      paidAmount:
          (map['paidAmount'] as num)
              .toDouble(),
      remainingAmount:
          (map['remainingAmount']
                  as num)
              .toDouble(),
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
      dueDate:
          map['dueDate'] == null
              ? null
              : DateTime.parse(
                  map['dueDate'],
                ),
      history: List<String>.from(
        map['history'] ?? [],
      ),
    );
  }
}