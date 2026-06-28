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
        .collection('savings');
  }

  static List<Saving> getAllSavings() {
    return box.values.toList();
  }

  static Future<void> addSaving(
    Saving saving,
  ) async {
    // Sauvegarde locale
    await box.put(
      saving.id,
      saving,
    );

    // Sauvegarde cloud
    if (_collection != null) {
      await _collection!
          .doc(saving.id)
          .set(
            saving.toMap(),
          );
    }
  }

  static Future<void> updateSaving(
    Saving saving,
  ) async {
    // Mise à jour locale
    await box.put(
      saving.id,
      saving,
    );

    // Mise à jour cloud
    if (_collection != null) {
      await _collection!
          .doc(saving.id)
          .set(
            saving.toMap(),
          );
    }
  }

  static Future<void> deleteSaving(
    String id,
  ) async {
    // Suppression locale
    await box.delete(id);

    // Suppression cloud
    if (_collection != null) {
      await _collection!
          .doc(id)
          .delete();
    }
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
    if (_collection == null) {
      return;
    }

    final snapshot =
        await _collection!.get();

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