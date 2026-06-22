import 'package:hive/hive.dart';

import '../models/creance.dart';

class CreanceService {
  static const String boxName = 'receivables';

  static Box<Creance> get box =>
      Hive.box<Creance>(boxName);

  static List<Creance> getAllCreances() {
    return box.values.toList();
  }

  static Future<void> addCreance(
    Creance creance,
  ) async {
    await box.put(
      creance.id,
      creance,
    );
  }

  static Future<void> updateCreance(
    Creance creance,
  ) async {
    await box.put(
      creance.id,
      creance,
    );
  }

  static Future<void> deleteCreance(
    String id,
  ) async {
    await box.delete(id);
  }

  static Creance? getCreance(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}