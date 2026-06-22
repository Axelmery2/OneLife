class DebtModel {
  final String id;

  final String personName;

  final String? phoneNumber;

  final String? description;

  final double totalAmount;

  final double paidAmount;

  final DateTime debtDate;

  final DateTime? dueDate;

  final bool isArchived;

  final DateTime createdAt;

  final DateTime updatedAt;

  const DebtModel({
    required this.id,
    required this.personName,
    this.phoneNumber,
    this.description,
    required this.totalAmount,
    required this.paidAmount,
    required this.debtDate,
    this.dueDate,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingAmount {
    return totalAmount - paidAmount;
  }

  bool get isPaid {
    return remainingAmount <= 0;
  }

  double get progressPercentage {
    if (totalAmount <= 0) return 0;

    return (paidAmount / totalAmount) * 100;
  }

  DebtModel copyWith({
    String? id,
    String? personName,
    String? phoneNumber,
    String? description,
    double? totalAmount,
    double? paidAmount,
    DateTime? debtDate,
    DateTime? dueDate,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DebtModel(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      debtDate: debtDate ?? this.debtDate,
      dueDate: dueDate ?? this.dueDate,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personName': personName,
      'phoneNumber': phoneNumber,
      'description': description,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'debtDate': debtDate.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isArchived': isArchived,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory DebtModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return DebtModel(
      id: map['id'] ?? '',
      personName: map['personName'] ?? '',
      phoneNumber: map['phoneNumber'],
      description: map['description'],
      totalAmount:
          (map['totalAmount'] ?? 0).toDouble(),
      paidAmount:
          (map['paidAmount'] ?? 0).toDouble(),
      debtDate: DateTime.fromMillisecondsSinceEpoch(
        map['debtDate'] ?? 0,
      ),
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['dueDate'],
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