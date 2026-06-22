import 'package:hive/hive.dart';

import '../models/debt.dart';

class DebtService {
  static const String boxName = 'debts';

  static Box<Debt> get box =>
      Hive.box<Debt>(boxName);

  static List<Debt> getAllDebts() {
    return box.values.toList();
  }

  static Future<void> addDebt(
    Debt debt,
  ) async {
    await box.put(
      debt.id,
      debt,
    );
  }

  static Future<void> updateDebt(
    Debt debt,
  ) async {
    await box.put(
      debt.id,
      debt,
    );
  }

  static Future<void> deleteDebt(
    String id,
  ) async {
    await box.delete(id);
  }

  static Debt? getDebt(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}