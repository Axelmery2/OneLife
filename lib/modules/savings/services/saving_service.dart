import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../models/saving.dart';

class SavingService {
  static Box<Saving> get box =>
      HiveService.getSavingsBox();

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
          .collection('savings');

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

    await _collection
        .doc(saving.id)
        .set(
          saving.toMap(),
        );
  }

  static Future<void> updateSaving(
    Saving saving,
  ) async {
    await box.put(
      saving.id,
      saving,
    );

    await _collection
        .doc(saving.id)
        .set(
          saving.toMap(),
        );
  }

  static Future<void> deleteSaving(
    String id,
  ) async {
    await box.delete(id);

    await _collection
        .doc(id)
        .delete();
  }

  static Saving? getSaving(
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
      final saving =
          Saving.fromMap(
        doc.data()
            as Map<String, dynamic>,
      );

      await box.put(
        saving.id,
        saving,
      );
    }
  }
}