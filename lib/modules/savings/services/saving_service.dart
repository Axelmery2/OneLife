import 'package:hive/hive.dart';

import '../models/saving.dart';
import '../../../services/hive_service.dart';

class SavingService {
  static Box<Saving> get box =>
      Hive.box<Saving>(
        HiveService.savingsBox,
      );

  static List<Saving> getAllSavings() {
    return box.values.toList();
  }

  static Future<void> addSaving(
    Saving saving,
  ) async {
    await box.put(
      saving.id,
      saving,
    );
  }

  static Future<void> updateSaving(
    Saving saving,
  ) async {
    await box.put(
      saving.id,
      saving,
    );
  }

  static Future<void> deleteSaving(
    String id,
  ) async {
    await box.delete(id);
  }

  static Saving? getSaving(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}