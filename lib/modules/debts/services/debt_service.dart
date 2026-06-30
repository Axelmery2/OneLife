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
          .currentUser
          ?.uid ??
      'guest';

  static CollectionReference?
      get _collection {
    if (FirebaseAuth
            .instance
            .currentUser ==
        null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('debts');
  }

  static List<Debt> getAllDebts() {
    return box.values.toList();
  }

  static Debt? getDebt(
    String id,
  ) {
    return box.get(id);
  }

  static Future<void> addDebt(
    Debt debt,
  ) async {
    // Sauvegarde locale immédiate
    await box.put(
      debt.id,
      debt,
    );

    // Synchronisation cloud en arrière-plan
    if (_collection != null) {
      _collection!
          .doc(debt.id)
          .set(debt.toMap())
          .catchError((e) {
        print(
          'Erreur sync ajout dette : $e',
        );
      });
    }
  }

  static Future<void> updateDebt(
    Debt debt,
  ) async {
    // Mise à jour locale immédiate
    await box.put(
      debt.id,
      debt,
    );

    // Synchronisation cloud
    if (_collection != null) {
      _collection!
          .doc(debt.id)
          .set(debt.toMap())
          .catchError((e) {
        print(
          'Erreur sync modification dette : $e',
        );
      });
    }
  }

  static Future<void> deleteDebt(
    String id,
  ) async {
    // Suppression locale immédiate
    await box.delete(id);

    // Suppression cloud
    if (_collection != null) {
      _collection!
          .doc(id)
          .delete()
          .catchError((e) {
        print(
          'Erreur suppression cloud : $e',
        );
      });
    }
  }

  static Future<void>
      syncFromFirestore() async {
    if (_collection == null) {
      return;
    }

    try {
      final snapshot =
          await _collection!.get();

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
    } catch (e) {
      print(
        'Erreur synchronisation Firestore : $e',
      );
    }
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}