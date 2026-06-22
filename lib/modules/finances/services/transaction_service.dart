import 'package:hive/hive.dart';

import '../models/transaction.dart';

class TransactionService {
  static const String boxName =
      'transactions';

  static Box<Transaction> get box =>
      Hive.box<Transaction>(boxName);

  static List<Transaction>
      getAllTransactions() {
    return box.values.toList();
  }

  static Future<void> addTransaction(
    Transaction transaction,
  ) async {
    await box.put(
      transaction.id,
      transaction,
    );
  }

  static Future<void> updateTransaction(
    Transaction transaction,
  ) async {
    await box.put(
      transaction.id,
      transaction,
    );
  }

  static Future<void> deleteTransaction(
    String id,
  ) async {
    await box.delete(id);
  }

  static double getTotalRevenus() {
    return box.values
        .where(
          (t) => t.type == 'revenu',
        )
        .fold(
          0,
          (sum, t) =>
              sum + t.amount,
        );
  }

  static double getTotalDepenses() {
    return box.values
        .where(
          (t) => t.type == 'depense',
        )
        .fold(
          0,
          (sum, t) =>
              sum + t.amount,
        );
  }

  static double getSolde() {
    return getTotalRevenus() -
        getTotalDepenses();
  }
}