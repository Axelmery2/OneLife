import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/debt.dart';

class DebtService {
  static Box<Debt> get box =>
      HiveService.getDebtsBox();

  static final FirebaseFirestore
      _firestore =
      FirebaseFirestore.instance;

  static String get _uid =>
      FirebaseAuth
          .instance
          .currentUser!
          .uid;

  static CollectionReference get
      _collection => _firestore
          .collection('users')
          .doc(_uid)
          .collection('debts');

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

    await _collection
        .doc(debt.id)
        .set(
          debt.toMap(),
        );
  }

  static Future<void> updateDebt(
    Debt debt,
  ) async {
    await box.put(
      debt.id,
      debt,
    );

    await _collection
        .doc(debt.id)
        .set(
          debt.toMap(),
        );
  }

  static Future<void> deleteDebt(
    String id,
  ) async {
    await box.delete(id);

    await _collection
        .doc(id)
        .delete();
  }

  static Debt? getDebt(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> clearAll() async {
    await box.clear();
  }

  static Future<void>
      syncFromFirestore() async {
    final snapshot =
        await _collection.get();

    for (final doc
        in snapshot.docs) {
      final debt =
          Debt.fromMap(
        doc.data()
            as Map<String, dynamic>,
      );

      await box.put(
        debt.id,
        debt,
      );
    }
  }
}