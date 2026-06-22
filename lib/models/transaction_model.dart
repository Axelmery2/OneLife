enum TransactionType {
  income,
  expense,
}

class TransactionModel {
  final String id;

  final String title;

  final double amount;

  final TransactionType type;

  final String categoryId;

  final String categoryName;

  final String paymentMethod;

  final String? note;

  final String? receiptImagePath;

  final DateTime transactionDate;

  final DateTime createdAt;

  final DateTime updatedAt;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.paymentMethod,
    this.note,
    this.receiptImagePath,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? categoryId,
    String? categoryName,
    String? paymentMethod,
    String? note,
    String? receiptImagePath,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'paymentMethod': paymentMethod,
      'note': note,
      'receiptImagePath': receiptImagePath,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      note: map['note'],
      receiptImagePath: map['receiptImagePath'],
      transactionDate:
          DateTime.fromMillisecondsSinceEpoch(
        map['transactionDate'] ?? 0,
      ),
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