class ReceivableModel {
  final String id;

  final String personName;

  final String? phoneNumber;

  final String? description;

  final double totalAmount;

  final double receivedAmount;

  final DateTime receivableDate;

  final DateTime? dueDate;

  final bool isArchived;

  final DateTime createdAt;

  final DateTime updatedAt;

  const ReceivableModel({
    required this.id,
    required this.personName,
    this.phoneNumber,
    this.description,
    required this.totalAmount,
    required this.receivedAmount,
    required this.receivableDate,
    this.dueDate,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingAmount {
    return totalAmount - receivedAmount;
  }

  bool get isCompleted {
    return remainingAmount <= 0;
  }

  double get progressPercentage {
    if (totalAmount <= 0) return 0;

    return (receivedAmount / totalAmount) * 100;
  }

  ReceivableModel copyWith({
    String? id,
    String? personName,
    String? phoneNumber,
    String? description,
    double? totalAmount,
    double? receivedAmount,
    DateTime? receivableDate,
    DateTime? dueDate,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReceivableModel(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      receivableDate: receivableDate ?? this.receivableDate,
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
      'receivedAmount': receivedAmount,
      'receivableDate':
          receivableDate.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isArchived': isArchived,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ReceivableModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ReceivableModel(
      id: map['id'] ?? '',
      personName: map['personName'] ?? '',
      phoneNumber: map['phoneNumber'],
      description: map['description'],
      totalAmount:
          (map['totalAmount'] ?? 0).toDouble(),
      receivedAmount:
          (map['receivedAmount'] ?? 0).toDouble(),
      receivableDate:
          DateTime.fromMillisecondsSinceEpoch(
        map['receivableDate'] ?? 0,
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